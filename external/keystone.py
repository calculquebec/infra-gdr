#!/usr/bin/env python3
import os
import json

def get_openstack_config():
    return {
        'OS_CLOUD': os.environ.get('OS_CLOUD', None),
        'OS_USERNAME': os.environ.get('OS_USERNAME', None),
        'OS_TENANT_NAME': os.environ.get('OS_TENANT_NAME', None),
        'OS_PASSWORD': os.environ.get('OS_PASSWORD', None),
        'OS_AUTH_URL': os.environ.get('OS_AUTH_URL', None),
        'OS_REGION_NAME': os.environ.get('OS_REGION_NAME', None),
    }

if __name__ == '__main__':
    config = get_openstack_config()
    print(json.dumps(config))