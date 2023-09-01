# package-pvc

This package configures the PVC virtual cluster system.

# Supplemental variables

## Configurable

### `ceph_storage_secret_key`: The Ceph storage secret key in base64 format.
* Should be obtained from Ceph cluster.

### `ceph_storage_secret_uuid`: A UUID for the Ceph secret in libvirt.
* Should be unique per cluster.
