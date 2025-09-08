pipeline {
    agent any
    
    tools{
        maven 'Maven-3.9.11'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('git checkout') {
            steps {
              git 'https://github.com/gowthamgandhari/Maven-app.git'
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table -o fs-report.html ."
            }
        }
        stage('Sonarqube') {
            steps {
                withSonarQubeEnv('sonar-token') {
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Campground -Dsonar.projectName=Campground"
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
                sh 'docker build -t gowthamgandhari/mavenwebapp .'
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh "trivy image --format table -o image-report.html gowthamgandhari/mavenwebapp:latest"
            }
        }
        stage('Docker push image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub-creds') {
                        sh "docker push gowthamgandhari/mavenwebapp:latest"
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
