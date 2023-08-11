pipeline {
    agent any
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
    }
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
        stage('OWASP Dependency-Check Vulnerabilities') {
            steps {
                dependencyCheck additionalArguments: ''' 
                            -o './'
                            -s './'
                            -f 'ALL' 
                            --prettyPrint''', odcInstallation: 'OWASP Dependency-Check Vulnerabilities'
                
                dependencyCheckPublisher pattern: 'dependency-check-report.xml'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    //  tool name of sonarQube scanner is in daskboard/Global tool congiuration -> sonarscanner in jenkins
                    def scannerHome = tool name: 'SonarQubeScanner'
                    // withSonarQubeEnv enter name of sonarQube server in jenkins
                    withSonarQubeEnv('odisea-poc-client-devsecops-pipeline') {
                        sh "${scannerHome}/bin/sonar-scanner  \
                        -Dsonar.projectKey=odisea-poc-client-devsecops-pipeline \
                        -Dsonar.projectName=odisea-poc-client-devsecops-pipeline "
                        // Dsonar.login=${SONAR_TOKEN} \
                    }
                }
        }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/ '
            }
        }
        stage('Container Security Scan') {
            steps {
            script{
        // sh 'trivy image ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} '
        // sh 'trivy image --no-progress --exit-code 1 --severity HIGH,CRITICAL ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} '
        def imageName = "${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}"
        def reportFileName = "${DOCKER_REG_URL}_${DOCKER_REG_NAME}_${APP_NAME}_${BUILD_NUMBER}_trivy_report.html"
        sh """trivy image --format template --template \"@/home/trivy/contrib/html.tpl\" --output ${reportFileName} ${imageName}"""
      }
      }
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
post { 
        always { 
            archiveArtifacts artifacts: "${DOCKER_REG_URL}_${DOCKER_REG_NAME}_${APP_NAME}_${BUILD_NUMBER}_trivy_report.html", fingerprint: true
                            
                        publishHTML (target: [
                            allowMissing: false,
                            alwaysLinkToLastBuild: false,
                            keepAll: true,
                            reportDir: '.',
                            reportFiles: '${DOCKER_REG_URL}_${DOCKER_REG_NAME}_${APP_NAME}_${BUILD_NUMBER}_trivy_report.html',
                            reportName: 'Trivy Scan Report',
                            ])
        }
    }
}