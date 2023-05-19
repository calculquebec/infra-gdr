# Research Data Management

## Documentation

Our [📚 documentation][#documentation] provides detailed steps to set up and configure the software for your environment.

## Continuous Integration / Continuous Delivery

The `.gitlab-ci.yml` file is used to manage terraform state files.

When a **merge request** is created, the pipeline is triggered, which includes formatting and validating the code.

Parallelized **plan** jobs are then executed using terraform for each **TF_STATE_NAMES** specified.

If planning succeeds, the **apply** job can be manually executed. 

To trigger manual jobs, access to the repository as a Developer or higher is required.

# Quickstart

Generate a key pair locally using:

```shell
ssh-keygen -b 2048 -t rsa -N "" -f /path/to/key
```

This will generate a private and public key pair:
- /path/to/key
- /path/to/key.pub

# Contributing

Please see the [contributing section][#contributing] for more information.

# License
This project is licensed under the [AGPLv3 License](https://www.gnu.org/licenses/agpl-3.0.html) - see the [license section][#license] for details.

[#documentation]: https://opsocket.gitlab.io/infra-gdr
[#contributing]: https://opsocket.gitlab.io/infra-gdr/contributing.html
[#installing]: https://opsocket.gitlab.io/infra-gdr/intro/installing.html
[#troubleshooting]: https://opsocket.gitlab.io/infra-gdr/intro/troubleshooting.html
[#license]: https://opsocket.gitlab.io/infra-gdr/license.html