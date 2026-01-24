def call(Closure body) {
  kubernetes {
    label "ci-agent"
    defaultContainer 'jnlp'
    yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:4.13-1-jdk17
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    tty: true
  - name: helm
    image: alpine/helm:3.14.0
    tty: true
  - name: trivy
    image: ghcr.io/aquasecurity/trivy:latest
    tty: true
  - name: sonar
    image: sonarsource/sonar-scanner-cli:latest
    tty: true
"""
  }
  body()
}
