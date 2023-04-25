terraform plan -var cloud="beluga" -out tf.plan
terraform apply tf.plan

# database failover

https://repmgr.org/docs/4.0/repmgrd-basic-configuration.html#REPMGRD-AUTOMATIC-FAILOVER-CONFIGURATION

terraform state mv openstack_compute_instance_v2.databases[0] openstack_compute_instance_v2.databases[1]

# Documentation

```shell
mkdocs build -f docs/mkdocs.yml
```