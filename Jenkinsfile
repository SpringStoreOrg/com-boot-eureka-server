def shortGitCommit
def microserviceName='eureka-server'
def dockerImageBaseName="fractalwoodstories/${microserviceName}"

pipeline {
    agent any

    stages {
        stage('Maven Package') {
            steps {
                sh 'mvn package  -DskipTests=true'
            }
        }
        stage('Maven Tests') {
             steps {
                 sh 'mvn test'
             }
         }
        stage('Docker Build') {
            steps {
                sh """
                    docker build . -t ${dockerImageBaseName}:arm64-latest
                """
            }
        }
        stage('Docker push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'fractalwoodstories-docker-hub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        shortGitCommit = env.GIT_COMMIT[0..7]
                        sh """
                            docker tag ${dockerImageBaseName}:arm64-latest ${dockerImageBaseName}:arm64-${shortGitCommit}
                            if [ "${env.BRANCH_NAME}" = "main" ] || [ "${env.BRANCH_NAME}" = "origin/main" ]; then
                                docker tag ${dockerImageBaseName}:arm64-latest ${dockerImageBaseName}:arm64-main-${shortGitCommit}
                            fi
                            docker login -u ${USERNAME} -p ${PASSWORD}
                            docker push --all-tags ${dockerImageBaseName}
                            docker logout
                        """
                    }
                }
            }
        }
        stage('Docker housekeeping') {
            steps {
                script {
                    sh """
                        IMAGE_SHA=`docker images -q ${dockerImageBaseName}:arm64-latest`
                        docker image rm --force \${IMAGE_SHA}
                    """
                }
            }
        }
        stage('Helm main') {
            when {
                expression { env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'origin/main' }
            }
            steps{
                sh """
                    helm upgrade --install ${microserviceName} --namespace fractalwoodstories --create-namespace ./helm/${microserviceName} --set image.tag=arm64-main-${shortGitCommit}
                """
            }
        }
    }
}
