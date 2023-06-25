# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
# from gettext import gettext as _
from pathlib import Path
import gettext
import os

BASE_DIR = Path(__file__).parent

# This opens the `sphinx.mo` for the configured language so that translated
# messages can be retrieved using `_("message")` for each i18n html builder run
trans = gettext.translation('sphinx', (BASE_DIR / "_build" / "locale").as_posix(), 
  languages=[
    # SPHINX_LANGUAGE is set by the meta builder in `build.py`
    os.environ.get('SPHINX_LANGUAGE', 'en')
  ])

_ = trans.gettext

# --

project = _('Research Data Management (RDM)')
copyright = '2023, opsocket'
author = 'opsocket'

version = '0.0.3'
release = version

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
  'sphinx.ext.autodoc',
  'sphinx.ext.intersphinx',
  'sphinx.ext.autosectionlabel',
  'sphinx_rtd_theme',
  'sphinx_copybutton',
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

# -- Internationalization (i18n)
# https://www.sphinx-doc.org/en/master/usage/advanced/intl.html

gettext_command = 'sphinx-intl'
gettext_compact = False
# gettext_language_team = 'THE LANGUAGE POLICE <opsocket@pm.me>'

# used by `sphinx-intl` to generate .po files
locale_dirs = ['_build/locale']

# used by `build.py` for generating i18n docs
languages = (
  ('en', _('English')),
  ('fr', _('French')),
)

# -- Options for PDF output -------------------------------------------------

latex_engine = "xelatex"

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

# -- Multi-version documentation

import os
import re

# define a regular expression pattern to match version numbers
version_pattern = re.compile(r'\d+\.\d+\.\d+')

public_path = BASE_DIR.parent / "public"

dirnames = os.listdir(public_path.as_posix()) if public_path.exists() else []

versions = [
    dirname for dirname in dirnames
    if os.path.isdir((public_path / dirname).as_posix())
    and version_pattern.match(dirname)
]

html_context = {
  "display_gitlab": True,
  "gitlab_host": "gitlab.com",
  "gitlab_user": "opsocket",
  "gitlab_repo": "infra-gdr",
  "gitlab_version": "main",
  "conf_py_path": "/docs/", # path in the checkout to the docs root
  "languages": languages,

  # multiversion
  "current_version": "main",
  "versions": [
    (version, f"/{version}/index.html") 
    for version in versions
  ],
  "downloads": [],
  "links": [
    (_('Repository'), 'https://gitlab.com/opsocket/infra-gdr')
  ],

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

html_css_files = [
  'css/extra.css'
]

html_favicon = "_static/favicon.ico"

html_show_sphinx = False
