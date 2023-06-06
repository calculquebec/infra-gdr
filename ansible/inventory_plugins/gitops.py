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
  NAME = 'gitops'

  def get_state(self):
    state_url, kwargs = None, {}
    
    if os.environ.get('GITLAB_CI', False):
      # running in gitlab ci
      state_url = os.path.expandvars("$CI_API_V4_URL/projects/$CI_PROJECT_ID/terraform/state/$TF_STATE_NAME")
      token = os.environ.get('CI_JOB_TOKEN', None)
      # https://gitlab.com/gitlab-org/gitlab/-/blob/v16.0.1-ee/lib/api/terraform/state.rb?ref_type=tags#L73
      # According to the terraform state api, we can authenticate using ci job
      # token by performing basic auth as follows
      kwargs = dict(auth=('gitlab-ci-token', token))
    else:
      # running elsewhere
      state_url = os.environ.get('GITLAB_STATE_URL', None)
      if not state_url:
        raise AnsibleError("The `GITLAB_STATE_URL` environment variable is not set")
      
      token = os.environ.get('GITLAB_ACCESS_TOKEN', None)
      if not token:
        raise AnsibleError("The `GITLAB_ACCESS_TOKEN` environment variable is not set")

      # authenticate using token as http header
      kwargs = dict(headers={'Private-Token': token})
  
    # query state
    res = requests.get(state_url, **kwargs)
    res.raise_for_status()
    state = res.json()
    return state

  def parse(self, inventory, loader, path, cache=True):
    # call base method to ensure properties are available for use with other
    # helper methods
    super().parse(inventory, loader, path, cache)
    # this method will parse 'common format' inventory sources and update any
    # options declared in DOCUMENTATION as needed
    config = self._read_config_data(path)

    # query terraform state
    state = self.get_state()

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

    # extra group variables at inventory level
    config.pop('plugin', None)
    for group in config:
      self.inventory.add_group(group)
      for key, value in config[group].get('vars', {}).items():
        self.inventory.set_variable(group, key, value)
