# Research Data Management

This project is aimed at providing an easy-to-use tool for researchers to manage their research data effectively. 

```{admonition} Notes
:class: info

The tool will help researchers to organize their data, create backups, and collaborate with other researchers.
```

```{toctree}
:caption: ✨ GETTING STARTED
:maxdepth: 2
:hidden:

installing.md
```

```{toctree}
:caption: 🌌 INFRASTRUCTURE
:maxdepth: 2
:hidden:

cluster.md
backups.md
troubleshooting.md
```

```{toctree}
:caption: 🫂 Community
:maxdepth: 2
:hidden:

contributing.md
license.md
```

## Installation

For installation instructions, please refer to the {doc}`installation section </installing>` of the documentation. This section provides detailed steps to set up and configure the software for your environment. In case you run into any issues during installation, our {doc}`troubleshooting section </troubleshooting>` might come in handy.

## Documentation

```{tip}
Let's give readers a helpful hint!
```


```shell
sphinx-build docs public && python3 -m http.server -d public
```

## Features

- Easy data organization
- Automatic backups
- Highly available database cluster

<!-- Un instantané (snapshot) des données est pris une fois par jour et est conservé pendant 14 jours. -->

# Contributing

Please see the {doc}`contributing </contributing>` section for more information.

# License
This project is licensed under the [AGPLv3 License](https://www.gnu.org/licenses/agpl-3.0.html) - see the {doc}`license </license>` section for details.
