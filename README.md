Prerequisites
- kubectl
- aws cli
- docker
- terraform
- nodejs


Deploy terraform
```bash
cd terraform
# Modify and adjust the terraform provider file to use the backend of your choice
# On this case it uses S3. The bucket should already exists.
vim provider.tf
terraform init -reconfigure
terraform plan -var-file="variables_values.tfvars"
terraform apply -var-file="variables_values.tfvars" -auto-approve
```

Get kubeconfig file
```bash
aws eks update-kubeconfig --name [EKS_CLUSTER_NAME]

# If the sample variable files was used, then:
aws eks update-kubeconfig --name sandbox-eks-cluster
```

Validate access to K8s API
```bash
kubectl get pods --all-namespaces
kubectl label namespace default environment=sandbox
kubectl label namespace default name=default
```

Deploy base K8s resources
```bash
cd ../kubernetes
kubectl apply -f 0.1-frontend-namespace.yaml
kubectl apply -f 0.2-backend-namespace.yaml
### Modify the node selector to the dns record of the EC2 instance
kubectl apply -f 1.1-persistent-volume.yaml
kubectl apply -f 1.2-config-resources.yml
```

Build and push docker images
```bash
aws ecr get-login-password --region [AWS_REGION] | docker login --username AWS --password-stdin [AWS_ACCOUNT_NUMBER].dkr.ecr.[AWS_REGION].amazonaws.com
cd ../apps/backend
docker build -t ckad-sandbox-sandbox-backend .
docker tag ckad-sandbox-sandbox-backend:latest [AWS_ACCOUNT_NUMBER].dkr.ecr.[AWS_REGION].amazonaws.com/ckad-sandbox-sandbox-backend:latest
docker push [AWS_ACCOUNT_NUMBER].dkr.ecr.[AWS_REGION].amazonaws.com/ckad-sandbox-sandbox-backend:latest

cd ..
npx create-react-app frontend-sample
cp -rT frontend frontend-sample
cd frontend-sample
npm install aws-amplify @aws-amplify/ui-react
npm run build
docker build -t ckad-sandbox-sandbox-frontend .
docker tag ckad-sandbox-sandbox-frontend:latest [AWS_ACCOUNT_NUMBER].dkr.ecr.[AWS_REGION].amazonaws.com/ckad-sandbox-sandbox-frontend:latest
docker push [AWS_ACCOUNT_NUMBER].dkr.ecr.[AWS_REGION].amazonaws.com/ckad-sandbox-sandbox-frontend:latest
```

Deploy rest of K8s resources
```bash
cd ../../kubernetes
# Create and add here your token for the OpenAI API
kubectl create secret generic openai-secret --from-literal=token='OPENAI_TOKEN' -n backend
# Replace the AWS account and region for the ECR repositories in both backend and frontend resoucr YAML
kubectl apply -f 2.1-backend-resources.yaml
kubectl apply -f 2.2-frontend-resources.yaml
kubectl apply -f 3.1-job-resources.yaml
kubectl apply -f 4.1-network-resources.yaml
```

Delete environment
```bash
cd ../terraform
terraform destroy -var-file="variables_values.tfvars" -auto-approve
```
