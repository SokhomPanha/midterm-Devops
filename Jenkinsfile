pipeline {
    agent { label 'ansible-agent' }

    environment {
        // Updated IP and Path for your Midterm
        REMOTE_HOST = "178.128.93.188"
        REMOTE_USER = "root"
        REMOTE_PASS = credentials('server-password') 
        DEPLOY_PATH = "/var/www/html/Midterm-2026/sokhom_panha"
        APP_URL     = "[http://178.128.93.188/Midterm-2026/sokhom_panha]"
    }

    stages {
        stage('Build Spring Boot') {
            steps {
                dir('midterm') {
                    // Add -DskipTests to avoid the PostgreSQL connection error
                    sh './mvnw clean package -DskipTests'
                }
            }
        }

        stage('Build & Deploy') {
            steps {
                dir('midterm') {
                    // 1. Build ignoring database tests
                    sh './mvnw clean package -DskipTests'
                    
                    // 2. Upload and Start the JAR
                    sh """
                    ansible webserver -i inventory.ini -m copy -a "src=target/*.jar dest=${DEPLOY_PATH}/app.jar"
                    ansible webserver -i inventory.ini -m shell -a "pkill -f app.jar || true"
                    ansible webserver -i inventory.ini -m shell -a "chdir=${DEPLOY_PATH} nohup java -jar app.jar --server.port=8081 > log.txt 2>&1 &"
                    """
                }

            }
        }
        stage('Deploy') {
            steps {
                sh '''
                scp midterm/target/*.war root@178.128.93.188:/var/www/html/Midterm-2026/sokhom_panha/app.war
                ssh root@178.128.93.188 "pkill -f app.war || true; nohup java -jar /var/www/html/Midterm-2026/sokhom_panha/app.war --spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration > /var/www/html/Midterm-2026/sokhom_panha/log.txt 2>&1 &"
                '''
            }
        }
    }

    post {
        success {
            // Requirement #4: Success email with the website URL
            emailext (
                subject: "SUCCESS: Midterm Build # ${env.BUILD_NUMBER}",
                body: "Your Spring Boot app is live: ${env.APP_URL}",
                to: "sokhompanha70@gmail.com" 
            )
        }
        failure {
            // Requirement #2: Email sent on build failure
            emailext (
                subject: "FAILED: Midterm Build # ${env.BUILD_NUMBER}",
                body: "Build failed. Check logs: ${env.BUILD_URL}",
                to: "sokhompanha70@gmail.com"
            )
        }
    }
}