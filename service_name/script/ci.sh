kubectl delete secret -n $NAMESPACE $SECRET_NAME
kubectl create secret docker-registry $SECRET_NAME\
  --docker-server=$DOCKER_SERVER \
  --docker-username=AWS \
  --docker-password=$(aws ecr --profile default --region $AWS_REGION get-login-password) \
  --namespace=$NAMESPACE 