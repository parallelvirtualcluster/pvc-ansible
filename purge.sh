#!/bin/bash


for host in $@; do
    ssh deploy@${host} "
    sudo systemctl stop ceph-mon@$(hostname -s);
    sudo rm -rf /etc/systemd/system/ceph-*.target.wants;
    sudo apt purge -y *ceph* *rbd* *rados*;
    sudo apt purge -y patroni* postgres* zookeeper* libvirt*
    sudo apt purge -y ca-certificates-java fontconfig-config libjemalloc2 libpq5 python-psycopg2 python3-eventlet python3-greenlet python3-jinja2 python3-kazoo python3-markupsafe python3-pkg-resources python3-pygments python3-six uuid-runtime
    sudo apt autoremove --purge -y;
    sudo apt clean;
    sudo apt update;
    sudo rm -rf /etc/pvc-install.* /etc/ceph* /etc/patroni* /etc/postgres* /etc/zookeeper* /etc/libvirt*;
    sudo rm -rf /var/lib/postgresql /var/lib/zookeeper /var/lib/libvirt;
    sudo rm -rf /run/ceph;
    sudo userdel ceph;
    sudo umount /var/lib/ceph;
    sudo mkfs.ext4 /dev/vgx/ceph;
    sudo mount /var/lib/ceph" &
done
wait
