FROM jenkins/jenkins:lts

USER root

# Install tools for extraction, Docker CLI, and OpenJDK
RUN apt-get update && apt-get install -y wget lshw ca-certificates openjdk-25-jdk \
    && curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Set environment variables for Java
ENV JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Add jenkins user to docker group
RUN usermod -aG docker jenkins

USER jenkins