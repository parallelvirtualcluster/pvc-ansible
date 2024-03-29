#!/bin/bash

echo -e "DANGER: This script will PURGE ALL PVC data and configuration from the following host(s):"
echo
echo -e " $@"
echo
echo -e "Are you sure you want to continue?"
echo
echo -en "To abort, press <Ctrl+C> now. To continue, press <Enter>. "
read
echo

for host in $@; do
    echo -n "Purging host ${host}... "
    ssh deploy@${host} '
    sudo systemctl stop pvcnoded;
    sudo systemctl stop pvcapid;
    sudo systemctl stop ceph-mon@$(hostname -s);
    sudo systemctl stop ceph-mgr@$(hostname -s);
    sudo systemctl stop patroni;
    for key in $( echo "ls /" | sudo /usr/share/zookeeper/bin/zkCli.sh -server $(hostname -s):2181 | grep --color=none zookeeper | tr -d "[]," | tr " " "\n" | grep -v zookeeper ); do
        echo "rmr /${key}" | sudo /usr/share/zookeeper/bin/zkCli.sh -server $(hostname -s):2181;
    done
    sudo systemctl stop zookeeper;
    sudo rm -rf /etc/pvc-install.* /etc/ceph* /etc/patroni* /etc/postgres* /etc/zookeeper* /etc/libvirt*;
    sudo rm -rf /var/lib/postgresql /var/lib/zookeeper/* /var/lib/libvirt /var/lib/ceph/*;
    suod rm -rf /var/log/postgresql /var/log/zookeeper /var/log/libvirt /var/log/ceph;
    sudo rm -rf /run/ceph;
    sudo rm -rf /etc/systemd/system/ceph-*.target.wants;
    sudo apt purge -y *pvc*;
    sudo apt purge -y *ceph* *rbd* *rados*;
    sudo apt purge -y patroni* postgres* zookeeper* libvirt*
    sudo apt purge -y ca-certificates-java fontconfig-config libjemalloc2 libpq5 python-psycopg2 python3-eventlet python3-greenlet python3-jinja2 python3-kazoo python3-markupsafe python3-pkg-resources python3-pygments python3-six uuid-runtime
    sudo apt autoremove --purge -y;
    sudo apt clean;
    sudo apt update;
    sudo userdel ceph;
    sudo umount /var/lib/ceph;
    sudo mkfs.ext4 /dev/vgx/ceph;
    sudo mount /var/lib/ceph;
    ' &>/dev/null || continue
    echo "done."
    echo -n "Rebooting host ${host}... "
    ssh deploy@${host} '
    sudo reboot;
    ' &>/dev/null
    echo "done."
done
