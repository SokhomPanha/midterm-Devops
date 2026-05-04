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