pipeline {
    agent { label 'ansible-agent' }

    environment {
        // Updated IP and Path for your Midterm
        REMOTE_HOST = "178.128.93.188"
        REMOTE_USER = "root"
        REMOTE_PASS = credentials('server-password') 
        DEPLOY_PATH = "/var/www/html/Midterm-2026/Sokhom_Panha"
        APP_URL     = "[http://178.128.93.188/Midterm-2026/Sokhom_Panha](http://178.128.93.188/Midterm-2026/Sokhom_Panha)"
    }

    stages {
        stage('Build Spring Boot') {
            steps {
                // Navigates to your project folder and builds the JAR
                dir('midterm') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                sh """
                # 1. Create Inventory
                echo "[webserver]\n${REMOTE_HOST} ansible_user=${REMOTE_USER} ansible_password=${REMOTE_PASS} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" > inventory.ini
                
                # 2. Ensure directory exists (Fixes the 404 issue)
                ansible webserver -i inventory.ini -m file -a "path=${DEPLOY_PATH} state=directory mode=0755"
                
                # 3. Upload the Spring Boot JAR
                ansible webserver -i inventory.ini -m copy -a "src=midterm/target/*.jar dest=${DEPLOY_PATH}/app.jar"
                
                # 4. Stop any old instance to free up the port
                ansible webserver -i inventory.ini -m shell -a "pkill -f app.jar || true"

                # 5. Start the Spring Boot App in the background
                ansible webserver -i inventory.ini -m shell -a "chdir=${DEPLOY_PATH} nohup java -jar app.jar > log.txt 2>&1 &"
                """
            }
        }
    }

    post {
        success {
            // Requirement #4: Success email with the website URL
            emailext (
                subject: "SUCCESS: Midterm Build # ${env.BUILD_NUMBER}",
                body: "Your Spring Boot app is live: ${env.APP_URL}",
                to: "your-email@gmail.com" 
            )
        }
        failure {
            // Requirement #2: Email sent on build failure
            emailext (
                subject: "FAILED: Midterm Build # ${env.BUILD_NUMBER}",
                body: "Build failed. Check logs: ${env.BUILD_URL}",
                to: "your-email@gmail.com"
            )
        }
    }
}