# Research Data Management Infrastructure (RDMI)

This is a Terraform project for creating an infrastructure in the cloud.

## Prerequisites

- Terraform installed
- Cloud provider account credentials (see [clouds.yaml](https://docs.openstack.org/python-openstackclient/pike/configuration/index.html#configuration-files))

## Usage

1. Clone the repository:

```shell
git clone https://gitlab.com/opsocket/infra-gdr.git && cd infra-gdr
```

2. Initialize the Terraform project:

```shell
terraform init
```


3. Modify the `variables.tf` file to set any desired variables.

4. Plan the infrastructure changes:

```shell
terraform plan -out init.plan
```

5. Apply the infrastructure changes:

```shell
terraform apply init.plan
```

Optionnally, we can show the debug output when applying the plan

```shell
OS_DEBUG=1 TF_LOG=DEBUG terraform apply init.plan
```

## Cleanup

To delete the infrastructure created by this project, run:

```shell
terraform destroy
```

Optionnally, we can bypass approval using

```shell
terraform destroy -auto-approve
```

## License

This project is licensed under the [GPLv3 License](https://www.gnu.org/licenses/gpl-3.0.html) - see the [LICENSE.md](LICENSE.md) file for details.
