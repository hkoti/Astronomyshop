{{- define "microservice.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "microservice-common.fullname" . }}
  labels:
    app.kubernetes.io/name: {{ include "microservice-common.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ include "microservice-common.name" . }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ include "microservice-common.name" . }}
        app.kubernetes.io/instance: {{ .Release.Name }}
    spec:
      serviceAccountName: {{ include "microservice-common.serviceAccountName" . }}

      {{- if .Values.initContainers }}
      initContainers:
{{ toYaml .Values.initContainers | indent 8 }}
      {{- end }}

      containers:
        - name: {{ include "microservice-common.name" . }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.service.port }}

          {{- if .Values.livenessProbe }}
          livenessProbe:
{{ toYaml .Values.livenessProbe | indent 12 }}
          {{- end }}

          {{- if .Values.readinessProbe }}
          readinessProbe:
{{ toYaml .Values.readinessProbe | indent 12 }}
          {{- end }}

          {{- if .Values.startupProbe }}
          startupProbe:
{{ toYaml .Values.startupProbe | indent 12 }}
          {{- end }}

          
          env:
{{ toYaml .Values.env | indent 12 }}
          resources:
{{ toYaml .Values.resources | indent 12 }}

      {{- if .Values.nodeSelector }}
      nodeSelector:
{{ toYaml .Values.nodeSelector | indent 8 }}
      {{- end }}

      {{- if .Values.tolerations }}
      tolerations:
{{ toYaml .Values.tolerations | indent 8 }}
      {{- end }}
{{- end }}
