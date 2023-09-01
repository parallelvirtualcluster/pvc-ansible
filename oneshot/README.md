# PVC Oneshot Playbooks

This directory contains playbooks to assist in automating day-to-day maintenance of a PVC cluster. These playbooks can be used independent of the main `pvc.yml` and roles setup to automate tasks.

## `update-pvc-cluster.yml` and `reboot-pvc-cluster.yml`

This playbook performs a sequential full upgrade on all nodes in a PVC cluster.

The `reboot-pvc-cluster.yml` does the same shutdown and restart steps as `update-pvc-cluster.yml`, but forced for all hosts, and without the update part.

### Running the Playbook

```
$ ansible-playbook -i hosts -l [cluster] update-pvc-cluster.yml
```

### Caveats, Warnings and Notes

* Ensure the cluster is in Optimal health before executing this playbook; all nodes should be up and reachable and operating normally

* Be prepared to intervene if step 9 times out; OOB access may be required

* This playbook is safe to run against a given host multiple times (e.g. to rerun after a failure); if a reboot is not required, it will not be performed

### Process and Steps

For each host in the cluster sequentially, do:

1. Enable cluster maintenance mode

1. Perform a full apt update, upgrade, autoremove, and clean

1. Clean up obsolete kernels (`kernel-cleanup.sh`), packages/updated configuration files (`dpkg-cleanup.sh`), and the apt archive

1. Verify library freshness and kernel version; if these produce no warnings, go to step 14 (skip reboot)

1. Secondary the node, then wait 30 seconds

1. Flush the node, wait for all VMs to migrate, then wait 15 seconds

1. Stop the `pvcnoded` and `zookeeper` daemons, then wait 15 seconds

1. Set Ceph OSD `noout` and stop all Ceph OSD, monitor, and manager processes, then wait 30 seconds

1. Reboot the system and wait for it to come back up (maximum wait time of 1800 seconds)

1. Ensure all OSDs become active and all PGs recover, then unset Ceph OSD `noout`

1. Unflush the node, wait for all VMs to migrate, then wait 30 seconds

1. Reset any systemd failures

1. Disable cluster maintenance mode, then wait 30 seconds

## `upgrade-pvc-daemons.yml`

This playbook performs a sequential upgrade of the PVC software daemons via apt on all nodes in a PVC cluster. This is a less invasive update process than the `update-pvc-cluster.yml` playbook as it does not flush or reboot the nodes, but does restart all PVC daemons (`pvcnoded`, `pvcapid`, and `pvcapid-worker`).

### Running the Playbook

```
$ ansible-playbook -i hosts -l [cluster] upgrade-pvc-daemons.yml
```

### Caveats, Warnings, and Notes

* Ensure the cluster is in Optimal health before executing this playbook; all nodes should be up and reachable and operating normally

* This playbook is safe to run against a given host multiple times; if service restarts are not required, they will not be performed

* This playbook should only be used in exceptional circumstances when performing a full `update-pvc-cluster.yml` would be too disruptive; it is always preferable to update all packages and reboot the nodes instead

### Process and Steps

For each node in the cluster sequentially, do:

1. Enable cluster maintenance mode

1. Perform an apt update, and install the 4 PVC packages (`pvc-client-cli`, `pvc-daemon-common`, `pvc-daemon-api`, `pvc-daemon-node`)

1. Clean up the apt archive

1. Verify if packages changed; if not, go to step 8 (skip restarts)

1. Secondary the node, then wait 30 seconds

1. Restart both active PVC daemons (`pvcapid-worker`, `pvcnoded`), then wait 60 seconds; since the node is not the primary coordinator, `pvcapid` will not be running

1. Verify daemons are running

1. Disble cluster maintenance mode, then wait 30 seconds
