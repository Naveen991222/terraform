pipeline {
    agent any

    parameters {
        string(name: 'RESOURCE_GROUP_NAME', defaultValue: 'my-resource-group', description: 'The name of the Azure resource group.')
        string(name: 'AKS_CLUSTER_NAME', defaultValue: 'my-aks-cluster', description: 'The name of the AKS cluster.')
        string(name: 'LOCATION', defaultValue: 'East US', description: 'The Azure region to deploy resources.')
        string(name: 'NODE_COUNT', defaultValue: '1', description: 'The number of nodes in the AKS cluster.')
    }

    environment {
        // Azure service principal credentials stored in Jenkins credentials
        ARM_CLIENT_ID = credentials('azure-client-id')
        ARM_CLIENT_SECRET = credentials('azure-client-secret')
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
        ARM_TENANT_ID = credentials('azure-tenant-id')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Naveen991222/terraform-.git'
                sh 'ls -la' // Check files in workspace
            }
        }

        stage('Azure CLI Login and Set Subscription') {
            steps {
                script {
                    sh """
                    #!/bin/bash
                    az login --service-principal -u ${env.ARM_CLIENT_ID} -p ${env.ARM_CLIENT_SECRET} --tenant ${env.ARM_TENANT_ID}
                    az account set --subscription ${env.ARM_SUBSCRIPTION_ID}
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh """
                    #!/bin/bash
                    terraform init
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh """
                    #!/bin/bash
                    terraform plan \
                        -var "subscription_id=${env.ARM_SUBSCRIPTION_ID}" \
                        -var "tenant_id=${env.ARM_TENANT_ID}" \
                        -var "resource_group_name=${params.RESOURCE_GROUP_NAME}" \
                        -var "aks_cluster_name=${params.AKS_CLUSTER_NAME}" \
                        -var "location=${params.LOCATION}" \
                        -var "node_count=${params.NODE_COUNT}" \
                        -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh """
                    #!/bin/bash
                    terraform apply -auto-approve tfplan
                    """
                }
            }
        }

        stage('Output') {
            steps {
                script {
                    sh """
                    #!/bin/bash
                    terraform output -raw kube_config > kube_config.yaml
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after job completes
        }
    }
}
