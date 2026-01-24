def call(Map cfg) {
  container('helm') {
    sh """
      helm upgrade --install ${cfg.serviceName} ${cfg.helmChartPath} \
        --namespace ${cfg.environment} \
        --create-namespace \
        -f ${cfg.helmChartPath}/values.yaml \
        -f ${cfg.helmChartPath}/values-${cfg.environment}.yaml \
        --set image.repository=${cfg.imageRepo} \
        --set image.tag=${cfg.imageTag} \
        --atomic \
        --wait \
        --timeout 10m
    """
  }
}
