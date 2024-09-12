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
                withCredentials([ 
                    string(credentialsId: 'azure-client-id', variable: 'CLIENT_ID'),
                    string(credentialsId: 'azure-client-secret', variable: 'CLIENT_SECRET'),
                    string(credentialsId: 'azure-subscription-id', variable: 'SUBSCRIPTION_ID'),
                    string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID')
                ]) {
                    sh '''
                    #!/bin/bash
                    az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID
                    az account set --subscription $SUBSCRIPTION_ID
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                #!/bin/bash
                terraform version
                terraform init -upgrade
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                #!/bin/bash
                terraform plan \
                    -var "subscription_id=${params.SUBSCRIPTION_ID}" \
                    -var "tenant_id=${params.TENANT_ID}" \
                    -var "resource_group_name=${params.RESOURCE_GROUP_NAME}" \
                    -var "aks_cluster_name=${params.AKS_CLUSTER_NAME}" \
                    -var "location=${params.LOCATION}" \
                    -var "node_count=${params.NODE_COUNT}" \
                    -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                #!/bin/bash
                terraform apply -auto-approve tfplan
                '''
            }
        }

        stage('Output') {
            steps {
                sh '''
                #!/bin/bash
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
