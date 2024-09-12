pipeline {
    agent any

    parameters {
        string(name: 'RESOURCE_GROUP_NAME', defaultValue: 'my-resource-group', description: 'The name of the Azure resource group.')
        string(name: 'AKS_CLUSTER_NAME', defaultValue: 'my-aks-cluster', description: 'The name of the AKS cluster.')
        string(name: 'LOCATION', defaultValue: 'East US', description: 'The Azure region to deploy resources.')
        string(name: 'NODE_COUNT', defaultValue: '1', description: 'The number of nodes in the AKS cluster.')
    }

    environment {
        AZURE_SUBSCRIPTION_ID = credentials('azure-subscription-id')
        AZURE_TENANT_ID = credentials('azure-tenant-id')
        AZURE_CLIENT_ID = credentials('azure-client-id')
        AZURE_CLIENT_SECRET = credentials('azure-client-secret')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Naveen991222/terraform-.git'
                sh 'ls -la' // Check files in workspace
            }
        }

        stage('Azure CLI Login and Subscription') {
            steps {
                script {
                    sh """
                    #!/bin/bash
                    echo "Logging in to Azure..."
                    az login --service-principal -u ${env.AZURE_CLIENT_ID} -p ${env.AZURE_CLIENT_SECRET} --tenant ${env.AZURE_TENANT_ID}
                    az account list --output table
                    az account set --subscription ${env.AZURE_SUBSCRIPTION_ID} || echo "Failed to set subscription. Check if the subscription ID is correct and the service principal has access."
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh '''
                    #!/bin/bash
                    set -e
                    terraform version
                    terraform init -upgrade
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh '''
                    #!/bin/bash
                    terraform plan \
                        -var "subscription_id=${env.AZURE_SUBSCRIPTION_ID}" \
                        -var "tenant_id=${env.AZURE_TENANT_ID}" \
                        -var "resource_group_name=${params.RESOURCE_GROUP_NAME}" \
                        -var "aks_cluster_name=${params.AKS_CLUSTER_NAME}" \
                        -var "location=${params.LOCATION}" \
                        -var "node_count=${params.NODE_COUNT}" \
                        -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh '''
                    #!/bin/bash
                    set -e
                    terraform apply \
                        -var "subscription_id=${env.AZURE_SUBSCRIPTION_ID}" \
                        -var "tenant_id=${env.AZURE_TENANT_ID}" \
                        -var "resource_group_name=${params.RESOURCE_GROUP_NAME}" \
                        -var "aks_cluster_name=${params.AKS_CLUSTER_NAME}" \
                        -var "location=${params.LOCATION}" \
                        -var "node_count=${params.NODE_COUNT}" \
                        -auto-approve
                    '''
                }
            }
        }

        stage('Output') {
            steps {
                script {
                    sh '''
                    #!/bin/bash
                    set -e
                    terraform output -raw kube_config > kube_config.yaml
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
