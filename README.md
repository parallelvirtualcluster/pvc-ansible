# PVC Ansible

A set of Ansible roles to set up a PVC node host.

## Variables

A default example set of configuration variables can be found in `group_vars/default/vars.yml

## Using

0. Deploy Debian 10 to a set of servers.
0. Create a new cluster group in the `hosts` file.
0. Create a set of vars in `group_vars`.
0. Run the `pvc.yml` playbook against the servers.
