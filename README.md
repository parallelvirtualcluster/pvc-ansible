# PVC Ansible

A set of Ansible roles to set up a PVC node host.

## Roles

This repository contains two roles:

#### base

This role provides a standardized and configured base system for PVC. This role expects that
the system was installed via the PVC installer ISO, which results in a Debian Buster system.

## Variables

A default example set of configuration variables can be found in `group_vars/default/vars.yml

## Using

*NOTE:* All non-`default` directories under `group_vars/` and `files/`, and the `hosts` file,
        are ignored by this Git repository. It is advisable to manage these files securely
        in a separate repository and use symlinks to place them in the expected locations in
        this repository. Note that the `files/` data is created during cluster bootstrap.

0. Deploy a set of 3 or 5 initial PVC nodes using the PVC install ISO.
0. Configure the networking on the hosts via `ssh deploy@<host>` and editing the
   `/etc/network/interfaces` file to match your network layout, including and bonding and
   vlans. Remember to remove the static or DHCP configuration from the primary (`upstream`,
   usually) network interface that was set by the installer to allow bootstrapping. Use the
   `manual` mode for all interfaces that PVC will manage. Bring up all configured interfaces
   via `ifup`.
0. Create a new cluster group in the `hosts` file, using `hosts.default` as an example. For
   the initial bootstrap run, it is recommended to only include the initial coordinators
   to ensure a smooth bootstrapping.
0. Create a set of vars in `group_vars`, using `group_vars/default` as an example. Ensure
   that all desired coordinators are configured with the `is_coordinator: yes` flag.
0. Run the `pvc.yml` playbook against the servers. If this is the very first run for a given
   cluster, use the `-e bootstrap=yes` variable to ensure the Ceph, Patroni, and PVC clusters
   are initialized.
