def call(Map cfg) {
  container('sonar') {
    withSonarQubeEnv('SonarCloud') {
      withCredentials([
        string(credentialsId: cfg.sonarCredentialId, variable: 'SONAR_TOKEN')
      ]) {
        sh """
          sonar-scanner \
            -Dsonar.projectKey=${cfg.sonarProjectKey} \
            -Dsonar.organization=${cfg.sonarOrganization} \
            -Dsonar.projectBaseDir=src/${cfg.serviceName} \
            -Dsonar.sources=. \
            -Dsonar.host.url=https://sonarcloud.io \
            -Dsonar.login=${SONAR_TOKEN}
        """
      }
    }
  }
}
