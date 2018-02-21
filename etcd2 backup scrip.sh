#!/bin/bash -e

# Change as necessary
RESTORE_PATH=${RESTORE_PATH:-/tmp/member}

#Extract node data from etcd config
source /etc/etcd.env || source /etc/default/etcd
function with_retries {
  local retries=3
  set -o pipefail
  for try in $(seq 1 $retries); do
    ${@}
    [ $? -eq 0 ] && break
    if [[ "$try" == "$retries" ]]; then
      exit 1
    fi
    sleep 3
  done
  set +o pipefail
}

this_node=$ETCD_NAME
node_names=($(echo $ETCD_INITIAL_CLUSTER | \
  awk -F'[=,]' '{for (i=1;i<=NF;i+=2) { print $i }}'))
node_endpoints=($(echo $ETCD_INITIAL_CLUSTER | \
  awk -F'[=,]' '{for (i=2;i<=NF;i+=2) { print $i }}'))
node_ips=($(echo $ETCD_INITIAL_CLUSTER | \
  awk -F'://|:[0-9]' '{for (i=2;i<=NF;i+=2) { print $i }}'))
num_nodes=${#node_names[@]}

# Stop and purge etcd data
for i in `seq 0 $((num_nodes - 1))`; do
  ssh ${node_ips[$i]} sudo service etcd stop
  ssh ${node_ips[$i]} sudo docker rm -f ${node_names[$i]} \
    || : # Kargo specific
  ssh ${node_ips[$i]} sudo rm -rf /var/lib/etcd/member
done

# Restore on first node
if [[ "$this_node" == ${node_names[0]} ]]; then
  sudo cp -R $RESTORE_PATH /var/lib/etcd/
else
  rsync -vaz -e "ssh" --rsync-path="sudo rsync" \
    "$RESTORE_PATH" ${node_ips[0]}:/var/lib/etcd/
fi 

ssh ${node_ips[0]} "sudo etcd --force-new-cluster 2> \
  /tmp/etcd-restore.log" &
echo "Sleeping 5s to wait for etcd up"
sleep 5

# Fix member endpoint on first node
member_id=$(with_retries ssh ${node_ips[0]} \
  ETCDCTL_ENDPOINTS=https://localhost:2379 \
  etcdctl member list | cut -d':' -f1)
ssh ${node_ips[0]} ETCDCTL_ENDPOINTS=https://localhost:2379 \
  etcdctl member update $member_id ${node_endpoints[0]}
echo "Waiting for etcd to reconfigure peer URL"
sleep 4

# Add other nodes
initial_cluster="${node_names[0]}=${node_endpoints[0]}"
for i in `seq 1 $((num_nodes -1))`; do
  echo "Adding node ${node_names[$i]} to ETCD cluster..."
  initial_cluster=\
    "$initial_cluster,${node_names[$i]}=${node_endpoints[$i]}"
  with_retries ssh ${node_ips[0]} \
    ETCDCTL_ENDPOINTS=https://localhost:2379 \
    etcdctl member add ${node_names[$i]} ${node_endpoints[$i]}
  ssh ${node_ips[$i]} \
    "sudo etcd --initial-cluster="$initial_cluster" &>/dev/null" &
  sleep 5
  with_retries ssh ${node_ips[0]} \
    ETCDCTL_ENDPOINTS=https://localhost:2379 etcdctl member list
done

echo "Restarting etcd on all nodes"
for i in `seq 0 $((num_nodes -1))`; do
  ssh ${node_ips[$i]} sudo service etcd restart
done

sleep 5

echo "Verifying cluster health"
with_retries ssh ${node_ips[0]} \
  ETCDCTL_ENDPOINTS=https://localhost:2379 etcdctl cluster-health
  cluster config data f1 var echo et 
  Verifying 