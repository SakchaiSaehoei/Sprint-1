pipeline {
    agent any
    // tools {
    //     nodejs '20.5.0'
    // }
    options {
        skipDefaultCheckout(true)
    }
    stages {
        stage('Clone git') {
            steps {
            git branch: '${REPO_BRANCH}',
            url: '${REPO_URL}'
            }
        }
         stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/ '
            }
        }
        stage('Push Image to ACR') {
            environment {
                ACR_SERVER = '${DOCKER_REG_URL}'
                ACR_CREDENTIAL = 'acr-credential'
            }
        steps{   
            script {
                docker.withRegistry(  "http://${ACR_SERVER}", ACR_CREDENTIAL ) {
                sh " docker image push ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} "
            }
        }
      }
     }

         stage('Remove build image') {
            steps {

                sh 'docker rmi ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool name: 'SonarQubeScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    withSonarQubeEnv('My SonarQube Server') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
        }
        
       
    
}