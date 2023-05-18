# Ansible for Research Data Management (ARDM)

## Install collections from requirements.yml

```shell
ansible-galaxy collection install -r requirements.yml
ansible-playbook -i inventory.yml cluster.yml
```

<!-- ### Improvements

**TODO**: abstract ansible stuff into a `pyproject.toml`

So that bindings are *improvable* and less painful

```shell
python3 -m venv env && . activate
pip install -e .
```
