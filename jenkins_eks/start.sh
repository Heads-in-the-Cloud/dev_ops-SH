#!/bin/sh

# Creating kubectl secrets from environment variables
kubectl create secret generic db-info \
  --from-literal=db_user=$DB_USER \
  --from-literal=db_host=$DB_HOST \
  --from-literal=db_user_password=$DB_USER_PASSWORD
kubectl create secret generic secret-key \
  --from-literal=secret_key=$SECRET_KEY

# Bring up services and ingress
kubectl apply -f service.yaml -f ingress.yaml

# Modifying and launching deployments
sed -e 's/$AWS_REGION/'"$AWS_REGION"'/g' -e 's/$AWS_ACCOUNT_ID/'"$AWS_ACCOUNT_ID"'/g' deployment.yaml | kubectl -f -
