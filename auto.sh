#!/bin/zsh

export WORKDIR=$(pwd)
rm -rf $WORKDIR/ansible/kubespray/inventory/diplom

#######
# Terraform block
#######
echo ""
echo ""
echo "############################################"
echo "Set up for backend"
echo "############################################"
cd $WORKDIR/terraform/for_backend
terraform init
terraform apply --auto-approve
# terraform output --json

export ACCESS_KEY="$(terraform output --json | jq -r ".access_key.value")"
export SECRET_KEY="$(terraform output --json | jq -r ".secret_key.value")"

echo ""
echo "############################################"
echo "Done!"
echo "############################################"


echo ""
echo ""
echo "############################################"
echo "Init backend"
echo "############################################"
cd ../backend
terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY" -reconfigure

echo ""
echo "############################################"
echo "Done!"
echo "############################################"


echo ""
echo ""
echo "############################################"
echo "Create nodes"
echo "############################################"
terraform apply --auto-approve
export MASTER_IP=$(terraform output --json | jq -r ".ips.value.master")
export NODE1_IP=$(terraform output --json | jq -r ".ips.value.node1")
export NODE2_IP=$(terraform output --json | jq -r ".ips.value.node2")
echo ""
echo "############################################"
echo "Done!"
echo "############################################"

######
# Ansible block
######
echo ""
echo ""
echo "############################################"
echo "Copy inventory sample"
echo "############################################"
cp -r $WORKDIR/ansible/kubespray/inventory/sample $WORKDIR/ansible/kubespray/inventory/diplom 
echo "supplementary_addresses_in_ssl_keys: [$MASTER_IP]" >> $WORKDIR/ansible/kubespray/inventory/diplom/group_vars/k8s_cluster/k8s-cluster.yml

echo ""
echo "############################################"
echo "Done!"
echo "############################################"

sed -i -e "s/helm_enabled: false/helm_enabled: true/g" $WORKDIR/ansible/kubespray/inventory/diplom/group_vars/k8s_cluster/addons.yml
sed -i -e "s/ingress_nginx_enabled: false/ingress_nginx_enabled: true/g" $WORKDIR/ansible/kubespray/inventory/diplom/group_vars/k8s_cluster/addons.yml

echo ""
echo ""
echo "############################################"
echo "Generate inventory file"
echo "############################################"
terraform output --json | jq -r '
{
  all: {
    hosts: (
      .ips.value | to_entries |
      map({
        (.key): {
          ansible_host: .value,
          ansible_user: "ubuntu"
        }
      }) | add
    ),
    children: {
      kube_control_plane: { hosts: { "master": null } },
      kube_node: { hosts: { "node1": null, "node2": null } },
      etcd: { hosts: { "master": null } },
      k8s_cluster: {
        children: {
          kube_control_plane: null,
          kube_node: null
        }
      }
    }
  }
}' | yq -P > $WORKDIR/ansible/kubespray/inventory/diplom/inventory.yaml
echo ""
echo "############################################"
echo "Done!"
echo "############################################"


echo ""
echo ""
echo "############################################"
echo "Add ssh keys"
echo "############################################"
for ((i = 15; i >= 0; i=i-1))
do
echo $i
sleep 1
done
ssh -oStrictHostKeyChecking=no -l ubuntu $MASTER_IP "exit"
ssh -oStrictHostKeyChecking=no -l ubuntu $NODE1_IP "exit"
ssh -oStrictHostKeyChecking=no -l ubuntu $NODE2_IP "exit"
ssh -oStrictHostKeyChecking=no -l ubuntu $MASTER_IP "exit"
ssh -oStrictHostKeyChecking=no -l ubuntu $NODE1_IP "exit"
ssh -oStrictHostKeyChecking=no -l ubuntu $NODE2_IP "exit"
ssh -oStrictHostKeyChecking=no -l ubuntu $MASTER_IP "exit"
ssh -oStrictHostKeyChecking=no -l ubuntu $NODE1_IP "exit"
ssh -oStrictHostKeyChecking=no -l ubuntu $NODE2_IP "exit"
echo ""
echo "############################################"
echo "Done!"
echo "############################################"


echo ""
echo ""
echo "############################################"
echo "Apply kubespray"
echo "############################################"
cd $WORKDIR/ansible/kubespray/
ansible-playbook -i ./inventory/diplom/inventory.yaml ./cluster.yml -b
echo ""
echo "############################################"
echo "Done!"
echo "############################################"

######
# Kuber block
######
echo ""
echo ""
echo "############################################"
echo "Copy config"
echo "############################################"
ssh -oStrictHostKeyChecking=no -l ubuntu $MASTER_IP "rm -rf ./.kube && mkdir ./.kube && sudo cp /etc/kubernetes/admin.conf ./.kube/config && sudo chmod 0666 ./.kube/config"
ssh -oStrictHostKeyChecking=no -l ubuntu $MASTER_IP "sed -i -e "s/127.0.0.1/$MASTER_IP/g" ./.kube/config"
ssh -oStrictHostKeyChecking=no -l ubuntu $MASTER_IP "kubectl get nodes"
echo ""
echo "############################################"
echo "Done!"
echo "############################################"


echo ""
echo ""
echo "############################################"
echo "Add monitoring"
echo "############################################"
ssh -oStrictHostKeyChecking=no -l ubuntu $MASTER_IP "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && helm repo update"
ssh -oStrictHostKeyChecking=no -l ubuntu $MASTER_IP "helm install stable prometheus-community/kube-prometheus-stack"
ssh -oStrictHostKeyChecking=no -l ubuntu $MASTER_IP "kubectl get services"
echo ""
echo "############################################"
echo "Done!"
echo "############################################"

echo "Master node IP: $MASTER_IP"
echo ""
echo "Grafana admin password: prom-operator"