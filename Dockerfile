FROM jenkins/jenkins:lts-slim-jdk17
RUN jenkins-plugin-cli --plugins blueocean kubernetes
