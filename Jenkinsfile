pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t vle9-healthcare:1.0 .'
            }
        }

        stage('SonarQube SAST') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner -Dsonar.projectKey=vle9-healthcare-app -Dsonar.sources=. -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_AUTH_TOKEN'
                }
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh 'trivy image --severity HIGH,CRITICAL --exit-code 0 vle9-healthcare:1.0'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'minikube image load vle9-healthcare:1.0'
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl get pods'
                sh 'kubectl get service vle9-healthcare-service'
            }
        }
    }
}
