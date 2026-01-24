def call(Map cfg) {
  container('kaniko') {
    sh """
      /kaniko/executor \
        --dockerfile=src/${cfg.serviceName}/Dockerfile \
        --context=. \
        --destination=${cfg.imageRepo}:${cfg.imageTag} \
        --cache=true \
        --cache-repo=${cfg.imageRepo}-cache
    """
  }
}
