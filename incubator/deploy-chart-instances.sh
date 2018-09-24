#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --env=*)
      env="${1#*=}"
      ;;
    --name=*)
      name="${1#*=}"
      ;;
    --redis-name=*)
      redis_name="${1#*=}"
      ;;
    --redis-namespace=*)
      namespace="${1#*=}"
      ;;
    --redis-service-name=*)
      service_name="${1#*=}"
      ;;
    --redis-count=*)
      redis_count="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "* Expected ones are:      *\n"
      printf "*   --env                 *\n"
      printf "*   --name                *\n"
      printf "*   --redis-name          *\n"
      printf "*   --redis-namespace     *\n"
      printf "*   --redis-service-name  *\n"
      printf "*   --redis-count         *\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

if [ -z "$env" ]; then
  echo "the script expects a --env argument..."
  exit 1
fi

if [ -z "$name" ]; then
  echo "the script expects a --name argument..."
  exit 1
fi

if [ -z "$redis_name" ]; then
  echo "the script expects a --redis-name argument..."
  exit 1
fi

if [ -z "$namespace" ]; then
  echo "setting default namespace..."
  namespace="default"
fi

if [ -z "$service_name" ]; then
  echo "the script expects a --redis-service-name argument..."
  exit 1
fi

if [ -z "$redis_count" ]; then
  echo "the script expects a --redis-count argument..."
  exit 1
fi

# retrieve and set redis instances IPs
SLAVE_IP=$(gcloud compute addresses list --filter="name=redis-$name-slave-$env" --format="value(address)")
MASTER_IP=$(gcloud compute addresses list --filter="name=redis-$name-master-$env" --format="value(address)")
sed -e "s/masterIP:/masterIP: $MASTER_IP/g; s/slaveIP:/slaveIP: $SLAVE_IP/g; s/releaseName:/releaseName: $redis_name/g; s/releaseNamespace:/releaseNamespace: $namespace/g; s/serviceName:/serviceName: $service_name/g; s/replicaCount:/replicaCount: $redis_count/g" \
  ./haproxy-redis/values.yaml > prox-values.yaml
source ./ci/deploy-helm.sh --name=proxy-$name-$env --chart=haproxy-redis --values-file=prox-values.yaml
