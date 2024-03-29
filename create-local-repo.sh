#!/usr/bin/env bash

# Creates a local repo for storing group_vars/files/inventories, with this
# project as a submodule.

echo "This script will create a new repository for storing your local modifications"
echo "and configurations. It will then include the pvc-ansible and pvc-installer "
echo "repositories as submodules for ease of updating and management."
echo

echo -n "Absolute path to new repository ('~', '\$HOME', etc. are NOT supported): "
read target_path
echo

echo "Creating new repo at ${target_path}..."
mkdir -p ${target_path}
pushd ${target_path}
git init .

echo "Adding submodules..."
git submodule add https://github.com/parallelvirtualcluster/pvc-ansible
git submodule add https://github.com/parallelvirtualcluster/pvc-installer

echo "Creating directories and symlinks..."
mkdir files group_vars roles
ln -s ../pvc-ansible/files/default files/default
ln -s ../pvc-ansible/group_vars/default group_vars/default
ln -s ../pvc-ansible/roles/base roles/base
ln -s ../pvc-ansible/roles/pvc roles/pvc
ln -s files ceph
cp -r pvc-ansible/oneshot oneshot
cp pvc-ansible/pvc.yml .
cp pvc-ansible/clusters.yml .
if [[ ! -d files/default ]]; then
    cp -r pvc-ansible/files/default files/
fi
touch hosts
cat <<EOF >update-remote.sh
#!/usr/bin/env bash

# Updates the local copy of pvc-ansible

set -o errexit

pushd pvc-ansible
git pull --rebase
git checkout master
popd

pushd pvc-installer
git pull --rebase
git checkout master
popd

git add pvc-ansible pvc-installer
git commit -m "Update submodules from upstream"
EOF
chmod +x update-remote.sh

echo "Adding and performing initial commit..."
git add .
git commit -m "Initial commit of new repository"

popd

echo
echo -e "Success: your new repository has been created at ${target_path}."
echo -e "* You no longer need this copy of the repository and may delete it."
echo -e "* You may edit the initial commit message and author details with the command:"
echo -e "    git commit --amend"
echo -e "  inside the new repository."
echo -e "* You will need to add a 'git remote' in order to push the new repository."
echo -e "* A copy of the file 'pvc.yml' has been made there, as well as your own 'roles/'"
echo -e "  directory, so you may add your own roles and customizations to these files"
echo -e "  if you so desire."
echo -e "* An empty 'hosts' inventory along with empty 'group_vars' and 'files'"
echo -e "  directories have also been prepared; edit these as required."
echo -e "* You may use the 'update-remote.sh' script in this new repository to keep your"
echo -e "  copy of pvc-ansible updated, or use normal git commands to do so."
echo -e "* IMPORTANT: Whenever Ansible creates a new cluster, or if you do so manually,"
echo -e "  you must move the files from 'pvc-ansible/files/' to 'files/', AND replace"
echo -e "  them with a symlink like so:"
echo -e "    cd pvc-ansible/files/"
echo -e "    mv cluster ../../files/"
echo -e "    ln -s ../../files/cluster"
echo -e "  If you do not do so, the files will not be committed and future runs of the"
echo -e "  playbooks will not work properly due to how Ansible looks up files."
