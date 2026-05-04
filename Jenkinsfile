pipeline {
    agent { label 'spring-build' } // Ensure your agent node has this label

    environment {
        REMOTE_HOST = "178.128.93.188"
        REMOTE_USER = "root"
        REMOTE_PASS = "I4@2026GIC"
        DEPLOY_PATH = "/var/www/html/Midterm-2026/Sokhom_Panha"
    }

    stages {
        stage('Build & Test') {
            steps {
                // Using the Maven wrapper in your repo
                sh 'chmod +x mvnw && ./mvnw clean package'
            }
        }

        stage('Deploy via Ansible') {
            steps {
                sh """
                echo "[webserver]\n${REMOTE_HOST} ansible_user=${REMOTE_USER} ansible_password=${REMOTE_PASS} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" > inventory.ini
                ansible webserver -i inventory.ini -m file -a "path=${DEPLOY_PATH} state=directory"
                ansible webserver -i inventory.ini -m copy -a "src=target/*.jar dest=${DEPLOY_PATH}/app.jar"
                """
            }
        }
    }

    post {
        success {
            emailext (
                subject: "SUCCESS: Midterm-Project-Sokhom Panha",
                body: "Build #${env.BUILD_NUMBER} was successful. \nView deployed project at: http://${REMOTE_HOST}/Midterm-2026/Sokhom_Panha",
                to: 'sokhompanha70@gmail.com'
            )
        }
        failure {
            emailext (
                subject: "FAILURE: Midterm-Project-Sokhom Panha",
                body: "Build #${env.BUILD_NUMBER} failed. \nCheck console output at: ${env.BUILD_URL}console \n\nError details:\n${currentBuild.rawBuild.getLog(50).join('\n')}",
                to: 'sokhompanha70@gmail.com'
            )
        }
    }
}