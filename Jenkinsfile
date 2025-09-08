pipeline {
    agent any
    tools{
        maven 'maven'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('git checkout') {
            steps {
             git branch: 'main', url: 'https://github.com/gowthamcloud268/Maven-app.git'
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table -o fs-report.html ."
            }
        }
        stage('Sonarqube') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=mavenapp -Dsonar.projectName=mavenapp"
                }
            }
        }
         stage('build'){
            steps{
                 sh 'mvn clean package'
            }
        }
        stage('docker build and tag image'){
            steps {
                sh 'docker build -t gowthamcloud268/mavenwebapp .'
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh "trivy image --format table -o image-report.html gowthamcloud268/mavenwebapp:latest"
            }
        }
        stage('Docker push image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub-creds') {
                        sh "docker push gowthamcloud268/mavenwebapp:latest"
                    }
                }
            }
        }
        stage('k8s deploy'){
            steps{
               sh 'kubectl apply -f k8s-deploy.yml'
            }
        }
    }
}
