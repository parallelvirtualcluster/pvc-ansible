<p align="center">
<img alt="Logo banner" src="https://docs.parallelvirtualcluster.org/en/latest/images/pvc_logo_black.png"/>
<br/><br/>
<a href="https://www.parallelvirtualcluster.org"><img alt="Website" src="https://img.shields.io/badge/visit-website-blue"/></a>
<a href="https://github.com/parallelvirtualcluster/pvc"><img alt="License" src="https://img.shields.io/github/license/parallelvirtualcluster/pvc"/></a>
<a href="https://github.com/psf/black"><img alt="Code style: Black" src="https://img.shields.io/badge/code%20style-black-000000.svg"/></a>
<a href="https://github.com/parallelvirtualcluster/pvc/releases"><img alt="Latest Release" src="https://img.shields.io/github/release-pre/parallelvirtualcluster/pvc"/></a>
<a href="https://docs.parallelvirtualcluster.org/en/latest/?badge=latest"><img alt="Documentation Status" src="https://readthedocs.org/projects/parallelvirtualcluster/badge/?version=latest"/></a>
</p>

## What is PVC?

PVC is a Linux KVM-based hyperconverged infrastructure (HCI) virtualization cluster solution that is fully Free Software, scalable, redundant, self-healing, self-managing, and designed for administrator simplicity. It is an alternative to other HCI solutions such as Ganeti, Harvester, Nutanix, and VMWare, as well as to other common virtualization stacks such as ProxMox and OpenStack.

PVC is a complete HCI solution, built from well-known and well-trusted Free Software tools, to assist an administrator in creating and managing a cluster of servers to run virtual machines, as well as self-managing several important aspects including storage failover, node failure and recovery, virtual machine failure and recovery, and network plumbing. It is designed to act consistently, reliably, and unobtrusively, letting the administrator concentrate on more important things.

PVC is highly scalable. From a minimum (production) node count of 3, up to 12 or more, and supporting many dozens of VMs, PVC scales along with your workload and requirements. Deploy a cluster once and grow it as your needs expand.

As a consequence of its features, PVC makes administrating very high-uptime VMs extremely easy, featuring VM live migration, built-in always-enabled shared storage with transparent multi-node replication, and consistent network plumbing throughout the cluster. Nodes can also be seamlessly removed from or added to service, with zero VM downtime, to facilitate maintenance, upgrades, or other work.

PVC also features an optional, fully customizable VM provisioning framework, designed to automate and simplify VM deployments using custom provisioning profiles, scripts, and CloudInit userdata API support.

Installation of PVC is accomplished by two main components: a [Node installer ISO](https://github.com/parallelvirtualcluster/pvc-installer) which creates on-demand installer ISOs, and an [Ansible role framework](https://github.com/parallelvirtualcluster/pvc-ansible) to configure, bootstrap, and administrate the nodes. Installation can also be fully automated with a companion [cluster bootstrapping system](https://github.com/parallelvirtualcluster/pvc-bootstrap). Once up, the cluster is managed via an HTTP REST API, accessible via a Python Click CLI client ~~or WebUI~~ (eventually).

Just give it physical servers, and it will run your VMs without you having to think about it, all in just an hour or two of setup time.

More information about PVC, its motivations, the hardware requirements, and setting up and managing a cluster [can be found over at our docs page](https://docs.parallelvirtualcluster.org).

# PVC Ansible Management Framework

This repository contains a set of Ansible roles for setting up and managing PVC nodes.

Tested on Ansible 2.2 through 2.10; it is not guaranteed to work properly on older or newer versions.

# Roles

This repository contains two roles:

### base

This role provides a standardized and configured base system for PVC. This role expects that
the system was installed via the PVC installer ISO, which results in a Debian Buster system.

This role is optional; the administrator may configure the base system however they please so
long as the `pvc` role can be installed thereafter.

### pvc

This role configures the various subsystems required by PVC, including Ceph, Libvirt, Zookeeper,
FRR, and Patroni, as well as the main PVC components themselves.

# Variables

A default example set of configuration variables can be found in `group_vars/default/`.

A full explanation of all variables can be found in [the manual](https://parallelvirtualcluster.readthedocs.io/en/latest/manuals/ansible/).

# Using

*NOTE:* These roles expect a Debian 12.X (Bookworm) system specifically (as of PVC 0.9.100).
        This is currently the only operating environment supported for PVC. This role MAY work
        on Debian derivatives but this is not guaranteed!

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
