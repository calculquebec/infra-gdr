from ansible.plugins.inventory import BaseInventoryPlugin
from ansible.errors import AnsibleError
import requests
import os

class InventoryModule(BaseInventoryPlugin):
  """
  This inventory module populates an inventory from a remote Terraform state
  stored in GitLab. It interacts with the GitLab REST API to fetch the state
  data and dynamically generates an inventory based on the retrieved
  information.
  """

  # used internally by Ansible, it should match the file name but not required
  NAME = 'gitlab_tfstate'

  def parse(self, inventory, loader, path, cache=True):
    # call base method to ensure properties are available for use with other
    # helper methods
    super().parse(inventory, loader, path, cache)

    # this method will parse 'common format' inventory sources and update any
    # options declared in DOCUMENTATION as needed
    config = self._read_config_data(path)

    state_url, token = None, None
    state = {}

    if gitlab := config.get('gitlab', None):
      state_url = gitlab.get('state_url', None)
      token = gitlab.get('token', None)
    
    if not state_url:
      state_url = os.environ.get('GITLAB_STATE_URL', None)
      if not state_url:
        raise AnsibleError("Either `gitlab.state_url` inventory plugin option or `GITLAB_STATE_URL` environment variable is not set")

    if not token:
      token = os.environ.get('GITLAB_ACCESS_TOKEN', None)
      if not token:
        raise AnsibleError("Either `gitlab.token` inventory plugin option or `GITLAB_ACCESS_TOKEN` environment variable is not set")

    if state_url and token:
      headers = {'PRIVATE-TOKEN': token}
      res = requests.get(state_url, headers=headers)
      res.raise_for_status()
      state = res.json()

    # process terraform state and populate the inventory
    for resource in state.get('resources', {}):

      if 'ansible_group' in resource['type']:
        for instance in resource.get('instances', []):
          # parse attributes if any
          if attrs := instance.get('attributes', {}):
            # set group variables if any
            for key, value in attrs.get('variables', {}).items():
              if instance_id := attrs.get('id', None):
                self.inventory.set_variable(instance_id, key, value)

      if 'ansible_host' in resource['type']:
        for instance in resource.get('instances', []):
          # parse attributes if any
          if attrs := instance.get('attributes', {}):
            if hostname := attrs.get('id', None):
              # add host if any
              self.inventory.add_host(hostname)
              # set host variables if any
              for key, value in attrs.get('variables', {}).items():
                self.inventory.set_variable(hostname, key, value)
              # add groups and children relations if any
              for group in attrs.get('groups', []):
                self.inventory.add_group(group)
                self.inventory.add_child(group, hostname)

    # @NOTE: supports for extra group variables at inventory level
    config.pop('plugin')
    config.pop('gitlab')
    for group in config:
      self.inventory.add_group(group)
      for key, value in config[group].get('vars', {}).items():
        self.inventory.set_variable(group, key, value)

