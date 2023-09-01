# PVC Ansible `group_vars`

Use this "default" set of variables as a template for your own clusters.

1. There should always be at least two (2) files here, with an optional third (3rd):

   * `base.yml`: Specifies basic cluster information.
   
   * `pvc.yml`: Specifies PVC system information.

   * `bootstrap.yml`: Specifies `pvcbootstrapd` deployment information (optional).

2. The files can be named arbitrarily, but these named are highly recommended. If the names are changed, and you use `pvcbootstrapd`, ensure you set them properly in its configuration.

These files are self-documented; read the comments carefully.
