data "cloudinit_config" "apps" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.yml"
    content_type = "text/cloud-config"
    content = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - nginx
    runcmd:
      - apt autoremove -y
      - lxd init --auto
      - lxc launch ubuntu:22.04 mattermost
      - lxc launch ubuntu:22.04 nextcloud
    EOF
  }

  part {
    filename     = "vhosts.yml"
    content_type = "text/cloud-config"
    content = <<-EOF
    #cloud-config
    write_files:
      - path: /etc/nginx/sites-available/${local.mattermost_server_name}
        content: |
        server {
          listen 3000;
          listen [::]:3000;
          server_name ${local.mattermost_server_name};

          location / {
              proxy_pass https://$MATTERMOST_CONTAINER_IPV4;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $server_name;
          }
        }
      - path: /etc/nginx/sites-available/${local.nextcloud_server_name}
        content: |
        server {
            listen 4000;
            listen [::]:4000;
            server_name ${local.nextcloud_server_name};

            add_header Strict-Transport-Security "max-age=15552000";
            server_tokens off;

            location /onlyoffice_ds_server/ {
              proxy_pass http://$NEXTCLOUD_CONTAINER_IPV4:8080/;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $proxy_connection;
              proxy_set_header X-Forwarded-Host $the_host/onlyoffice_ds_server;
              proxy_set_header X-Forwarded-Proto $the_scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_http_version 1.1;
            }

            location / {
              proxy_pass http://$NEXTCLOUD_CONTAINER_IPV4;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $server_name;

              # allow client request bodies up to 25MB
              client_max_body_size 25m;
              client_body_buffer_size 25m;

              # efficiently send large files over the network without buffering them in memory
              sendfile on;
              tcp_nopush on;
              tcp_nodelay on;
            }
        }
    runcmd:
      - sed -i "s/\$MATTERMOST_CONTAINER_IPV4/$(lxc info mattermost | grep -i 'inet: ' | awk '{print $2}' | head -1 | cut -d '/' -f 1)/g" /etc/nginx/sites-available/${local.mattermost_server_name}
      - sed -i "s/\$NEXTCLOUD_CONTAINER_IPV4/$(lxc info nextcloud | grep -i 'inet: ' | awk '{print $2}' | head -1 | cut -d '/' -f 1)/g" /etc/nginx/sites-available/${local.nextcloud_server_name}
      - ln -s /etc/nginx/sites-{available,enabled}/${local.mattermost_server_name}
      - ln -s /etc/nginx/sites-{available,enabled}/${local.nextcloud_server_name}
      - rm /etc/nginx/sites-enabled/default
      - nginx -s reload
    EOF
  }
}
