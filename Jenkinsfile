pipeline {
    agent any

    environment {
        PROJECT_ID = 'instant-grove-458712-t6'
        CLUSTER_NAME = 'growcast-cluster'  // 수정됨
        ZONE = 'asia-northeast3-c'         // 수정됨 (원래 REGION → ZONE)
        DOCKER_IMAGE = 'yeonju7547/growcast'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/yeonju000/growcast-cicd.git', branch: 'main'
            }
        }

        stage('Build JAR') {
            steps {
                sh './gradlew clean build -x test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'aa103497-0a0f-4f24-94d4-40fe8e9d00b2') {
                        docker.image("${DOCKER_IMAGE}:${BUILD_ID}").push()
                        docker.image("${DOCKER_IMAGE}:${BUILD_ID}").push('latest')
                    }
                }
            }
        }

        stage('Deploy to GKE') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh "gcloud auth activate-service-account --key-file=\$GOOGLE_APPLICATION_CREDENTIALS"
                    sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${ZONE} --project ${PROJECT_ID}"  // 수정됨
                    sh "sed -i 's|image:.*|image: ${DOCKER_IMAGE}:${BUILD_ID}|' deployment.yaml"
                    sh "kubectl apply -f deployment.yaml"
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful'
        }
        failure {
            echo 'Deployment failed'
        }
    }
}
