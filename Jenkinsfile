pipeline {
    agent any

    parameters {
        string(name: 'RESOURCE_GROUP_NAME', defaultValue: 'my-resource-group', description: 'The name of the Azure resource group.')
        string(name: 'AKS_CLUSTER_NAME', defaultValue: 'my-aks-cluster', description: 'The name of the AKS cluster.')
        string(name: 'LOCATION', defaultValue: 'East US', description: 'The Azure region to deploy resources.')
        string(name: 'NODE_COUNT', defaultValue: '1', description: 'The number of nodes in the AKS cluster.')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Naveen991222/terraform.git'
                sh 'ls -la' // Verify the files in the workspace
            }
        }

        stage('Azure CLI Login and Subscription') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: 'my-service-principal', clientIdVariable: 'CLIENT_ID', clientSecretVariable: 'CLIENT_SECRET', tenantIdVariable: 'TENANT_ID', subscriptionIdVariable: 'SUBSCRIPTION_ID')]) {
                    sh """
                    az login --service-principal -u ${CLIENT_ID} -p ${CLIENT_SECRET} --tenant ${TENANT_ID}
                    az account set --subscription ${SUBSCRIPTION_ID}
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                terraform version
                terraform init -upgrade
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                terraform plan \
                    -var "subscription_id=${SUBSCRIPTION_ID}" \
                    -var "tenant_id=${TENANT_ID}" \
                    -var "client_id=${CLIENT_ID}" \
                    -var "client_secret=${CLIENT_SECRET}" \
                    -var "resource_group_name=${RESOURCE_GROUP_NAME}" \
                    -var "aks_cluster_name=${AKS_CLUSTER_NAME}" \
                    -var "location=${LOCATION}" \
                    -var "node_count=${NODE_COUNT}" \
                    -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                terraform apply -auto-approve tfplan
                '''
            }
        }

        stage('Output') {
            steps {
                sh '''
                terraform output -raw kube_config > kube_config.yaml
                '''
            }
        }
    }

    post {
        always {
            cleanWs() // Clean up workspace after the job finishes
        }
    }
}
