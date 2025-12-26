{{- define "microservice.pdb" -}}
{{- if .Values.pdb.enabled }}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "microservice-common.fullname" . }}
  labels:
    app.kubernetes.io/name: {{ include "microservice-common.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ include "microservice-common.name" . }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  {{- if .Values.pdb.minAvailable }}
  minAvailable: {{ .Values.pdb.minAvailable }}
  {{- else if .Values.pdb.maxUnavailable }}
  maxUnavailable: {{ .Values.pdb.maxUnavailable }}
  {{- end }}
{{- end }}
{{- end }}
