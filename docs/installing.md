# Installation

## Requirements

### Openstack

For deployment purposes, we need access to an OpenStack provider. 
The provider is responsible for managing the connection between your project and the OpenStack environment.

#### Authentication

To authenticate with an OpenStack provider, you should configure your authentication using [Keystone][#keystone]. We can configure authentication with [Keystone credentials][#keystone_creds] using either the [clouds.yaml][#clouds_yaml] or [environment variables][#envvars].

The [clouds.yaml][#clouds_yaml] file is used to store your OpenStack configuration information. This file should be located in your home directory under the .config/openstack directory.

Alternatively, you can configure authentication using [environment variables][#envvars]. This file is typically sourced within your shell environment.

```{note}
In either case, it is important to ensure that authentication is properly configured so that the OpenStack provider is accessible and secure.
```

### Terraform

Find up-to-date instructions for your operating system on [Install Terraform][#install_terraform]

#### Workspaces

```{attention}
This is section requires attention
```

```shell
terraform workspace new myworkspace
```

> Created and switched to workspace "myworkspace"!
> 
> You're now on a new, empty workspace. Workspaces isolate their state,
> so if you run "terraform plan" Terraform will not see any existing state
> for this configuration.

#### Deployments

```{attention}
This is section requires attention
```

```shell
terraform plan -out tf.plan
terraform apply tf.plan
```

[#install_terraform]: https://developer.hashicorp.com/terraform/downloads
[#keystone]: https://docs.openstack.org/keystone/latest
[#keystone_creds]: https://docs.openstack.org/keystone/latest/user/application_credentials.html
[#clouds_yaml]: https://docs.openstack.org/python-openstackclient/pike/configuration/index.html#clouds-yaml
[#envvars]: https://docs.openstack.org/python-openstackclient/pike/cli/man/openstack.html#environment-variables