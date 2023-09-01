# PVC Ansible

**NOTICE FOR GITHUB**: This repository is a read-only mirror of the PVC repositories from my personal GitLab instance. Pull requests submitted here will not be merged. Issues submitted here will however be treated as authoritative.

A set of Ansible roles to set up PVC nodes. Part of the [Parallel Virtual Cluster system](https://github.com/parallelvirtualcluster/pvc).

Tested on Ansible 2.2 through 2.10; it is not guaranteed to work properly on older or newer versions.

## Roles

This repository contains two roles:

#### base

This role provides a standardized and configured base system for PVC. This role expects that
the system was installed via the PVC installer ISO, which results in a Debian Buster system.

This role is optional; the administrator may configure the base system however they please so
long as the `pvc` role can be installed thereafter.

#### pvc

This role configures the various subsystems required by PVC, including Ceph, Libvirt, Zookeeper,
FRR, and Patroni, as well as the main PVC components themselves.

## Variables

A default example set of configuration variables can be found in `group_vars/default/`.

A full explanation of all variables can be found in [the manual](https://parallelvirtualcluster.readthedocs.io/en/latest/manuals/ansible/).

## Using

*NOTE:* These roles expect a Debian 10.X (Buster) or Debian 11.X (Bullseye) system specifically.
        This is currently the only operating environment supported for PVC.

*NOTE:* All non-`default` directories under `group_vars/` and `files/`, and the `hosts` file,
        are ignored by this Git repository. It is advisable to manage these files securely
        in a separate repository and use symlinks to place them in the expected locations in
        this repository. Note that the `files/` data is created during cluster bootstrap.
        You can leverage the `create-local-repo.sh` script to do so automatically.

For full details, please see the general [PVC install documentation](https://parallelvirtualcluster.readthedocs.io/en/latest/installing/).

0. Deploy a set of 3 or 5 initial PVC nodes using the PVC install ISO.
0. Create a new cluster group in the `hosts` file, using `hosts.default` as an example. For
   the initial bootstrap run, it is recommended to only include the initial coordinators
   to ensure a smooth bootstrapping.
0. Create a set of vars in `group_vars`, using `group_vars/default` as an example. Ensure
   that all desired coordinators are configured with the `is_coordinator: yes` flag.
0. Run the `pvc.yml` playbook against the servers. If this is the very first run for a given
   cluster, use the `-e do_bootstrap=yes` variable to ensure the Ceph, Patroni, and PVC
   clusters are initialized.

## License

Copyright (C) 2018-2021  Joshua M. Boniface <joshua@boniface.me>

This repository, and all contained files, is free software: you can
redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, version 3.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
