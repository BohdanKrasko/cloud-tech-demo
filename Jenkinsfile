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
        choice (
            choices: ['stage', 'prod'],
            description: '',
            name: 'env'
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
        DB_CREDS = credentials('db_cred')
        SECRET_KEY = credentials('secret_key')

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
                    VERSION = "${shortGitTagNumber}-${BUILD_NUMBER}"
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

        stage('Update config/config.json') {
            steps {         
                dir ('app/anketa') {
                    //Update config/config.json file with secrets arn and save file into config/server.json
                    sh "rm config/server.json"
                    sh "sed -e \"s@%DB_HOST%@db-${params.env}-irc@g\"\
                        -e \"s@%DB_USERNAME%@${DB_CREDS_USR}@g\"\
                        -e \"s@%DB_PASSWORD%@${DB_CREDS_PSW}@g\"\
                        -e \"s@%SECRET_KEY%@${SECRET_KEY}@g\" config/server.json.tmp > config/server.json"       
                    sh "cat config/server.json"   
                }        
            }
        }

        // stage ('Build Backand image and push to ECR') {
        //     when {
        //       expression { params.action == 'build'}
        //     }
        //     steps {
        //         dir ('app/anketa/') {
        //             sh "docker build -t ${REPO_URI}:${REPO_NAME}-backend-${VERSION} ."
        //             sh "docker push ${REPO_URI}:${REPO_NAME}-backend-${VERSION}"
        //         }
        //     }
        // }
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