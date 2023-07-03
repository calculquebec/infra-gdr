from pathlib import Path
from sphinx.application import Sphinx
from sphinx_intl.basic import update
import importlib.util
import multiprocessing
import os
import subprocess

BASE_DIR = Path(__file__).parent
BUILD_DIR = BASE_DIR / "_build"

# LOAD THE SPHINX CONFIG MODULE
# =============================

sphinx_conf_path = BASE_DIR / "conf.py"
sphinx_conf_spec = importlib.util.spec_from_file_location('conf', sphinx_conf_path.as_posix())
conf = importlib.util.module_from_spec(sphinx_conf_spec)
sphinx_conf_spec.loader.exec_module(conf)

# INTERNATIONALIZED HTML BUILDER PARAMS
# =====================================

languages = getattr(conf, 'languages', [])
outdir = BASE_DIR.parent / "public" 

# base sphinx params
sphinx_params = dict(
    srcdir=BASE_DIR.as_posix(),
    confdir=BASE_DIR.as_posix(),
    outdir=outdir.as_posix(),
    doctreedir=(BUILD_DIR / "doctrees" / "html").as_posix(),
    buildername="html",
)

# generate i18n params for html builders
html_params = {}
for code, _ in languages:
    # assume first language is default language
    if code == languages[0][0]:
        html_params[code] = sphinx_params
    else:
        html_params[code] = {
            **sphinx_params,
            "confoverrides": {"language": code},
            "outdir": (outdir / code).as_posix()
        }

# GETTEXT BUILDER PARAMS
# ======================

gettext_outdir = BUILD_DIR / "gettext"
gettext_params = {
    **sphinx_params,
    "doctreedir": (BUILD_DIR / "doctrees" / "gettext").as_posix(),
    "outdir": gettext_outdir.as_posix(),
    "buildername": "gettext",
}

# GENERIC BUILD WORKER
# =====================

def worker(params):
    overrides = params.get('confoverrides', {})
    os.environ['SPHINX_LANGUAGE'] = overrides.get('language', 'en')
    app = Sphinx(**params)
    app.build()

# GENERATE DOCUMENTATION
# ======================

if __name__ == '__main__':
    # run the sphinx `gettext` builder to extract translation messages from
    # sources for generating related .pot files
    proc = multiprocessing.Process(target=worker, args=(gettext_params,))
    proc.start()
    proc.join()

    # sphinx has close to no support for translations inside `conf.py` as a
    # result, we also need to run xgettext to extract translation messages from
    # the `conf.py` to merge these translations within the `sphinx.pot` domain
    subprocess.run([
        "xgettext", "-j", "-o", (gettext_outdir / "sphinx.pot").as_posix(), 
        sphinx_conf_path.as_posix(), "--omit-header"
    ])

    # update .po files from generated .pot files using sphinx-intl
    locale_dir = BUILD_DIR / "locale"
    pot_dir = gettext_params["outdir"]
    update(locale_dir.as_posix(), pot_dir, [ code for code, _ in languages ])

    # create a separate html build process for each language
    for _, params in html_params.items():
        proc = multiprocessing.Process(target=worker, args=(params,))
        proc.start()
        proc.join()
