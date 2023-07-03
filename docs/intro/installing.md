# Installation

## Requirements

### Openstack

For deployment purposes, we need access to an OpenStack provider. 
The provider is responsible for managing the connection between your project and the OpenStack environment.

#### Authentication

To authenticate with an OpenStack provider, you should configure your authentication using [Keystone](https://docs.openstack.org/keystone/latest). We can configure authentication with [Keystone credentials](https://docs.openstack.org/keystone/latest/user/application_credentials.html) using either the [clouds.yaml](https://docs.openstack.org/python-openstackclient/pike/configuration/index.html#clouds-yaml) or [environment variables](https://docs.openstack.org/python-openstackclient/pike/cli/man/openstack.html#environment-variables).

The [clouds.yaml](https://docs.openstack.org/python-openstackclient/pike/configuration/index.html#clouds-yaml) file is used to store your OpenStack configuration information. This file should be located in your home directory under the `.config/openstack` directory.

Alternatively, you can configure authentication using [environment variables](https://docs.openstack.org/python-openstackclient/pike/cli/man/openstack.html#environment-variables). This file is typically sourced within your shell environment.

```{important}
In either case, it is important to ensure that authentication is properly configured so that the OpenStack provider is accessible and secure.
```

### Terraform

Find up-to-date instructions for your operating system on [Install Terraform](https://developer.hashicorp.com/terraform/downloads)

#### Deployments

```{note}
This section requires attention
```

```shell
terraform plan -out tf.plan
terraform apply tf.plan
```
