pipeline {
    agent any
    options {
        skipDefaultCheckout true
    }
    stages {
        stage('Build') {
            steps {
               cleanWs()
               git 'https://github.com/nareshanjuru/lighthouse.git'
                sh "docker build -t lighthouse:headless ."
            }
        }
        stage('Lighthouse Test') {
            steps {
                script {
                     // Run lighthouse
                        docker.image('lighthouse:headless').inside {
                            sh 'lighthouse --output html --quiet --chrome-flags="--headless --no-sandbox --disable-gpu" http://www.google.com/'
                        }
                }
            }
        }
        stage('Publish Report') {
            steps {
               // Archive HTML reports 
               archiveArtifacts artifacts: '**/*.html'
               publishHTML (target: [
                  allowMissing: false,
                  alwaysLinkToLastBuild: true,
                  keepAll: true,
                  reportDir: '',
                  reportFiles: '*.report.html',
                  reportName: "lighthouse"
                ])
            }
        }
    }
}
