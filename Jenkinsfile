pipeline {
    agent any
    tools {
        nodejs '20.5.0'
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
                sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/'
            }
        }
        }
       
    
}