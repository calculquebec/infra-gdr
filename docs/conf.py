# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'Gestion des Données de Recherche (GDR)'
copyright = '2023, opsocket'
author = 'opsocket'

version = '0.0.2'
release = version

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
  'sphinx.ext.autodoc',
  'sphinx.ext.intersphinx',
  'sphinx.ext.autosectionlabel',
  'sphinx_rtd_theme',
  'myst_parser',
]

autosectionlabel_prefix_document = True

myst_enable_extensions = [
    "amsmath",
    "attrs_inline",
    "colon_fence",
    "deflist",
    "dollarmath",
    "fieldlist",
    "html_admonition",
    "html_image",
    "linkify",
    "replacements",
    "smartquotes",
    "strikethrough",
    "substitution",
    "tasklist",
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

source_suffix = ['.rst', '.md']

pygments_style = 'monokai'

todo_include_todos = False

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output


html_context = {
  "display_gitlab": True,
  "gitlab_host": "git.computecanada.ca",
  "gitlab_user": "opsocket",
  "gitlab_repo": "infra-gdr",
  "gitlab_version": "main",
  "conf_py_path": "/docs/", # path in the checkout to the docs root
}

html_theme = 'sphinx_rtd_theme'
html_theme_options = {
  'logo_only': False,
  'display_version': True,
  'prev_next_buttons_location': 'bottom',
  'style_external_links': True,
  'vcs_pageview_mode': 'blob',
  'collapse_navigation': True,
  'sticky_navigation': True,
  'navigation_depth': 4,
  'titles_only': False,
}


html_static_path = ['_static']

html_css_files = ['css/extra.css']

html_favicon = "_static/favicon.ico"

html_show_sphinx = False
