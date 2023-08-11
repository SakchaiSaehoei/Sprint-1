pipeline {
    agent any
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

        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             //  tool name of sonarQube scanner is in daskboard/Global tool congiuration -> sonarscanner in jenkins
        //             def scannerHome = tool name: 'SonarQubeScanner'
        //             // withSonarQubeEnv enter name of sonarQube server in jenkins
        //             withSonarQubeEnv('sonarqube-odisea-poc-client-sast-sonarqube-pipeline') {
        //                 sh "${scannerHome}/bin/sonar-scanner  \
        //                 -Dsonar.projectKey=odisea-poc-client-sast-sonarqube-pipeline \
        //                 -Dsonar.projectName=odisea-poc-client-sast-sonarqube-pipeline "
        //                 // Dsonar.login=${SONAR_TOKEN} \
        //             }
        //         }
        // }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/ '
            }
        }
        stage('Scan') {
      steps {
        sh 'trivy --no-progress --exit-code 1 --severity HIGH,CRITICAL ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/'
      }
        stage('Push Image to ACR') {
            environment {
                ACR_SERVER = '${DOCKER_REG_URL}'
                ACR_CREDENTIAL = 'acr-credentials'
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
       
       
    
}
}