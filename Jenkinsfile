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
                sh 'chmod +x mvnw'
                sh './mvnw clean package'
            }
        }

        stage('Deploy via Ansible') {
            steps {
                sh """
                # 1. Prepare the inventory
                echo "[webserver]\n${REMOTE_HOST} ansible_user=${REMOTE_USER} ansible_password=${REMOTE_PASS} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" > inventory.ini
                
                # 2. Ensure directory exists and upload the JAR
                ansible webserver -i inventory.ini -m file -a "path=${DEPLOY_PATH} state=directory mode=0755"
                ansible webserver -i inventory.ini -m copy -a "src=midterm/target/*.jar dest=${DEPLOY_PATH}/app.jar"
                
                # 3. Kill any old version of the app running (to avoid 'Port already in use' errors)
                ansible webserver -i inventory.ini -m shell -a "pkill -f app.jar || true"

                # 4. START THE APP (The Professional Way)
                # We use 'nohup' so the app keeps running after Jenkins finishes
                ansible webserver -i inventory.ini -m shell -a "chdir=${DEPLOY_PATH} nohup java -jar app.jar > log.txt 2>&1 &" sleep 5
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