def call(Map cfg) {
  container('trivy') {
    sh """
      trivy image \
        --exit-code 0 \
        --severity HIGH,CRITICAL \
        ${cfg.imageRepo}:${cfg.imageTag}
    """
  }
}
