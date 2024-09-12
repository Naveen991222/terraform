pipeline {
    agent any

    parameters {
        string(name: 'RESOURCE_GROUP_NAME', defaultValue: 'my-resource-group', description: 'The name of the Azure resource group.')
        string(name: 'AKS_CLUSTER_NAME', defaultValue: 'my-aks-cluster', description: 'The name of the AKS cluster.')
        string(name: 'LOCATION', defaultValue: 'East US', description: 'The Azure region to deploy resources.')
        string(name: 'NODE_COUNT', defaultValue: '1', description: 'The number of nodes in the AKS cluster.')
    }

    environment {
        AZURE_SERVICE_PRINCIPAL = credentials('my-service-principal') // Ensure you have this credential in Jenkins
        CLIENT_ID = "${CLIENT_ID}"
        CLIENT_SECRET = "${CLIENT_SECRET}"
        SUBSCRIPTION_ID = "${SUBSCRIPTION_ID}"
        TENANT_ID = "${TENANT_ID}"
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
                script {
                    def azureCreds = env.AZURE_SERVICE_PRINCIPAL.split(':')
                    def clientId = azureCreds[0]
                    def clientSecret = azureCreds[1]

                    sh """
                    #!/bin/bash
                    az login --service-principal -u ${clientId} -p ${clientSecret} --tenant ${AZURE_TENANT_ID}
                    az account set --subscription ${AZURE_SUBSCRIPTION_ID}
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh '''
                    #!/bin/bash
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
                        -var "subscription_id=${AZURE_SUBSCRIPTION_ID}" \
                        -var "tenant_id=${AZURE_TENANT_ID}" \
                        -var "resource_group_name=${RESOURCE_GROUP_NAME}" \
                        -var "aks_cluster_name=${AKS_CLUSTER_NAME}" \
                        -var "location=${LOCATION}" \
                        -var "node_count=${NODE_COUNT}" \
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
                    terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Output') {
            steps {
                script {
                    sh '''
                    #!/bin/bash
                    terraform output -raw kube_config > kube_config.yaml
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean up workspace after the job finishes
        }
    }
}
