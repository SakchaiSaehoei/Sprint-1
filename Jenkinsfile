pipeline {
    agent any
    tools {
        nodejs '20.5.0'
    }
    // stages {
    //     stage('Clone git') {
    //         steps {
    //         git branch: '${REPO_BRANCH}',
    //         url: '${REPO_URL}'
    //         }
    //     }
    //     }
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
      
    }
}