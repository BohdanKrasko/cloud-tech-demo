@Library('github.com/releaseworks/jenkinslib') _

pipeline {
    agent any

    tools {
        terraform 'terraform'
    }

    parameters {
        choice (
            choices: ['deploy', 'build', 'destroy'],
            description: '',
            name: 'action'
        )
    }

    environment {
        // AWS Account settings
        AWS_ACCOUNT_ID = "196123732812"
        AWS_REGION = 'us-east-1'
        // AWS_PROFILE = "cloud-tech"

        // Locust specific environment variables
        REPO_NAME = "cloud-tech-demo"
        REPO_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
        // VERSION = ""
        
        // def buildDate = sh(script: "echo `date '+%Y-%m-%d_%H:%M:%S'`", returnStdout: true).trim()
    }

    stages {
        stage('Prepare tags for App') {
            when {
              expression { params.action == 'build'}
            }
            steps {
                script {
                    // Set the image version based on tag number
                    GitTagNumber = sh(returnStdout: true, script: 'git describe --tags --always').trim()
                    shortGitTagNumber = GitTagNumber.take(20)
                    VERSION = "${shortGitTagNumber}_${BUILD_NUMBER}"
                    echo VERSION
                }
            }
        }

        stage ('Login into ECR') {
            when {
              expression { params.action == 'build'}
            }
            steps {
                script {
                    withAWS(credentials:'cloud-tech', region:"${AWS_REGION}") {
                        def login = ecrLogin(registryIds: [AWS_ACCOUNT_ID])
                        sh login
                    }
                }
            }
        }

        stage ('Build DB image and push to ECR') {
            when {
              expression { params.action == 'build'}
            }
            steps {
                dir ('app/anketa/db') {
                    sh "docker build -t ${REPO_URI}:${REPO_NAME}-db-${VERSION} ."
                    sh "docker push ${REPO_URI}:${REPO_NAME}-db-${VERSION}"
                }
            }
        }
        // stage('Terraform init') {
        //     steps {
        //         dir('task_10') {
        //             withAWS(credentials:'cloud-tech', region:'us-east-1') {
        //                 sh 'terraform init'
        //             }
        //         }
        //     }
        // }

        // stage('Deploy infra') {
        //     when {
        //         expression { params.action == 'start'}
        //     }
        //     steps {
                
        //         dir('task_10') {
        //             withAWS(credentials:'cloud-tech', region:'us-east-1') {
        //                 sh 'terraform plan'
        //                 sh 'terraform apply -auto-approve'
        //             }
        //         }
        //     }
        // }

        // stage('Destroy infra') {
        //     when {
        //         expression { params.action == 'destroy'}
        //     }
        //     steps {
        //         dir('task_10') {
        //             withAWS(credentials:'cloud-tech', region:'us-east-1') {
        //                 sh 'terraform destroy -auto-approve'
        //             }
        //         }
        //     }
        // }
    }

    post {
        always {
            cleanWs()
        }
    }
}