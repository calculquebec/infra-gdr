data "cloudinit_config" "apps" {
  gzip          = false
  base64_encode = false

  # Initialized the virtual machine
  part {
    filename     = "init.yml"
    content_type = "text/cloud-config"
    content = <<-CLOUD_CONFIG
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - avahi-daemon
      - nginx
    runcmd:
      - apt autoremove -y
      - lxd init --auto
      - lxc launch ubuntu:22.04 mattermost
    CLOUD_CONFIG

  }

  part {
    content = <<-CLOUD_CONFIG
    runcmd:
      - lxc launch ubuntu:22.04 nextcloud
      - export NEXTCLOUD_BACKEND=`lxc info nextcloud | grep -i 'inet: ' | awk '{print $2}' | head -1 | cut -d '/' -f 1`
      - nextcloud.occ config:system:set overwritehost --value="${local.nextcloud_server_name}"
      - nextcloud.occ config:system:set overwriteprotocol --value="https"
      - nextcloud.occ config:system:set trusted_proxies --value="$NEXTCLOUD_BACKEND"
    CLOUD_CONFIG
  }

  #   part {
  #     content_type = "text/cloud-config"
  #     content = jsonencode({
  #       write_files = [
  #         {
  #           content = file("cloud_init/apps/containers/gitlab.yml")
  #           path = "/opt/gitlab.yml"
  #         }
  #       ]
  #     })
  #   }

  #   part {
  #     filename     = "gateway.sh"
  #     content_type = "text/x-shellscript"
  #     content = file("gateway.sh")
  #   }

  # Configure virtual hosts for nginx
  part {
    filename     = "vhosts.yml"
    content_type = "text/cloud-config"
    content = <<-CLOUD_CONFIG
    #cloud-config
    write_files:
      - path: /etc/nginx/sites-available/${local.mattermost_server_name}
        content: |
        proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=mattermost_cache:10m max_size=3g inactive=120m use_temp_path=off;
        server {
          listen 80;
          listen [::]:80;
          server_name ${local.mattermost_server_name};

          client_max_body_size 50M;
          client_body_buffer_size 50M;

          location ~ /api/v[0-9]+/(users/)?websocket$ {
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              client_max_body_size 50M;
              proxy_set_header Host $http_host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Frame-Options SAMEORIGIN;
              proxy_buffers 256 16k;
              proxy_buffer_size 16k;
              client_body_timeout 60;
              send_timeout 300;
              lingering_timeout 5;
              proxy_connect_timeout 90;
              proxy_send_timeout 300;
              proxy_read_timeout 90s;
              proxy_pass https://__MATTERMOST_BACKEND__;
          }

          location / {
              proxy_set_header Connection "";
              proxy_set_header Host $http_host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Frame-Options SAMEORIGIN;
              proxy_buffers 256 16k;
              proxy_buffer_size 16k;
              proxy_read_timeout 600s;
              proxy_cache mattermost_cache;
              proxy_cache_revalidate on;
              proxy_cache_min_uses 2;
              proxy_cache_use_stale timeout;
              proxy_cache_lock on;
              proxy_http_version 1.1;
              proxy_pass https://__MATTERMOST_BACKEND__;
          }
        }

      - path: /etc/nginx/sites-available/${local.nextcloud_server_name}
        content: |
        server {
            listen 80;
            listen [::]:80;
            server_name ${local.nextcloud_server_name};
            
            client_max_body_size 50M;
            client_body_buffer_size 50M;
            add_header Strict-Transport-Security "max-age=15552000";
            server_tokens off;
            tcp_nodelay on;

            location /onlyoffice_ds_server/ {
              proxy_http_version 1.1;
              proxy_set_header Connection $proxy_connection;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $the_host/onlyoffice_ds_server;
              proxy_set_header X-Forwarded-Proto $the_scheme;
              proxy_pass http://__NEXTCLOUD_BACKEND__:8080/;
            }

            location / {
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $server_name;
              proxy_pass http://__NEXTCLOUD_BACKEND__;
            }
        }
    runcmd:
      - sed -i "s/__MATTERMOST_BACKEND__/$(lxc info mattermost | grep -i 'inet: ' | awk '{print $2}' | head -1 | cut -d '/' -f 1):3000/g" /etc/nginx/sites-available/${local.mattermost_server_name}
      - sed -i "s/__NEXTCLOUD_BACKEND__/$(lxc info nextcloud | grep -i 'inet: ' | awk '{print $2}' | head -1 | cut -d '/' -f 1):4000/g" /etc/nginx/sites-available/${local.nextcloud_server_name}
      - ln -s /etc/nginx/sites-{available,enabled}/${local.mattermost_server_name}
      - ln -s /etc/nginx/sites-{available,enabled}/${local.nextcloud_server_name}
      - nginx -t && nginx -s reload
    CLOUD_CONFIG
  }
}
