# Introduction

This project is aimed at providing an easy-to-use tool for researchers to manage their research data effectively. 

```{admonition} Notes
:class: info

The tool will help researchers to organize their data, create backups, and collaborate with other researchers.
```

## Installation

For installation instructions, please refer to the {doc}`installation <intro/installing>` section of the documentation. This section provides detailed steps to set up and configure the software for your environment. In case you run into any issues during installation, our {doc}`troubleshooting <infra/troubleshooting>` section might come in handy.

## Documentation

The documentation for this project is built using [Sphinx][#sphinx], a popular tool that makes it easy to create intelligent and beautiful documentation.

The documentation source files can be found in the `docs` directory.

````{admonition} Create a virtual environment
:class: tip

We recommend using a virtual environment for installing required dependencies to be able to generate the documentation

```shell    
python3 -m venv env && source env/bin/activate
pip install -r docs/requirements.txt
```
```` 

To build the documentation, simply run the follwing command:

```shell
sphinx-build docs public
```

This will generate the HTML documentation files in the `public` directory.

```{admonition} Expose the documentation
:class: tip
Use `python3 -m http.server -d public` to expose your freshly built documentation on http://0.0.0.0:8000 
```

## Features

- Easy data organization
- Automatic backups
- Highly available database cluster

% Un instantané (snapshot) des données est pris une fois par jour et est conservé pendant 14 jours.

# Contributing

Please see the {doc}`contributing <community/contributing>` section for more information.

# License
This project is licensed under the [AGPLv3 License](https://www.gnu.org/licenses/agpl-3.0.html) - see the {doc}`license <community/license>` section for details.

[#sphinx]: https://www.sphinx-doc.org

% HIDDEN TOCS

```{toctree}
:caption: ✨ Getting started
:maxdepth: 2
:hidden:

self
intro/installing.md
```

```{toctree}
:caption: 🌌 Infrastructure
:maxdepth: 2
:hidden:

infra/overview.md
infra/apps.md
infra/databases.md
infra/backups.md
infra/security.md
infra/troubleshooting.md
```

```{toctree}
:caption: 🫂 Community
:maxdepth: 2
:hidden:

community/contributing.md
community/license.md
```