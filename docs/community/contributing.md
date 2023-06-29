# Contributing

## Documentation

This repository uses [Sphinx](https://www.sphinx-doc.org), a powerful documentation generator, to create high-quality documentation. It enables you to write documentation in reStructuredText (reST) format or markdown (MyST) and provides tools for complex documentation and publishing workflows.

### Prerequisities

To set up the development environment and build the documentation, follow these steps inside the cloned repository:


1. Create a virtual environment

```shell
python3 -m venv venv
```

2. Activate the virtual environment

```shell
. activate
```

3. Install the required dependencies

```shell
pip install -r docs/requirements.txt
```

### Building the Documentation

Since we have to support many languages, a meta build system `docs/build.py` has been added to support internationalized builds for any configured language.

Therefore, building the documentation is as simple as:

```shell
python3 docs/build.py
```

Which will produce an **HTML** output in the `public` folder.

## Internationalization (i18n)

https://github.com/sphinx-doc/sphinx-intl

> `sphinx-intl` is a utility tool that provides several features that make it
> easy to translate and to apply translation to **Sphinx** generated document.
