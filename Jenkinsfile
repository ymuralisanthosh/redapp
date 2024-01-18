pipeline {
    agent any
    environment {
        ARTIFACTORY_URL = 'http://13.201.102.58:8082/artifactory/application/'
        ARTIFACTORY_REPO = 'application/'
        ARTIFACTORY_PATH = 'http://13.201.102.58:8082/artifactory/application/com/example/red-app/1.0-SNAPSHOT/'
        AWS_REGION = 'ap-south-1'
        ECR_REPO_NAME = 'redapp'
        AWS_ACCOUNT_ID = '709087243859'
        ECR_REPO_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"
        DOCKER_IMAGE_NAME = 'application/redapp-image'
        DOCKER_IMAGE_TAG = "${ECR_REPO_URL}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
    }
    stages {
        stage('checkout') {
            steps {
                echo 'checkout starting'
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ymuralisanthosh/redapp.git']])
                echo 'checkout completed'
            }
        }
        stage('Build') {
            steps {
                script {
                    echo 'build starting'
                    sh 'mvn clean install'
                    echo 'build completed'
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    echo 'deploy starting'
                    sh 'mvn clean deploy'
                    echo 'deploy completed'
                }
            }
        }
        stage('push to jfrog-artifactory') {
            steps {
                dir('/var/lib/jenkins/workspace/Redapp/target') {
                    script {
                        def buildNumber = env.BUILD_NUMBER
                        rtServer (
                            id: 'Artifactory-1',
                            url: 'http://13.201.102.58:8082/artifactory',
                            username: 'ymsanthosh',
                            password: 'Viratkohli_18',
                            bypassProxy: true,
                            timeout: 300
                        )
                        rtUpload (
                            serverId: 'Artifactory-1',
                            spec: '''{
                                  "files": [
                                    {
                                      "pattern": "red-app.jar",
                                      "target": "application/${buildNumber}/"
                                     }
                                  ]
                            }''',
                        )
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def dockerBuildArgs = "--build-arg ARTIFACTORY_URL=${env.ARTIFACTORY_URL} --build-arg ARTIFACTORY_REPO=${env.ARTIFACTORY_REPO} --build-arg ARTIFACTORY_PATH=${env.ARTIFACTORY_PATH}"

                    // Generate a unique tag for each build (timestamp-based)
                    def buildTag = env.BUILD_NUMBER
        
                    // Build the Docker image with the new tag
                    sh "docker build ${dockerBuildArgs} -t ${ECR_REPO_URL}:${buildTag} ."
                    
                    // Push the Docker image to ECR with the new tag
                    sh "docker push ${ECR_REPO_URL}:${buildTag}"
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY', credentialsId: '709087243859']]) {
                        // Login to ECR
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URL}"

                        // Generate a unique tag for each build (timestamp-based)
                        def buildTag = env.BUILD_NUMBER

                        // Tag the Docker image
                        sh "docker tag ${ECR_REPO_URL}:${buildTag} ${ECR_REPO_URL}:latest"
                        // Push the Docker image to ECR
                        sh "docker push ${ECR_REPO_URL}:${buildTag}"
                    }
                }
            }
        }
    }
}
