#!/bin/sh

set -x
set -e

ansible-playbook "upgrade.yml" --vault-password-file=vault_pass.sh \
                 -i inventories/production/hosts "$@"
