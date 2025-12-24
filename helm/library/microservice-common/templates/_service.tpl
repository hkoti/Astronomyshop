{{- define "microservice.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "microservice-common.fullname" . }}
  labels:
    app.kubernetes.io/name: {{ include "microservice-common.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  type: {{ .Values.service.type }}
  selector:
    app.kubernetes.io/name: {{ include "microservice-common.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.port }}
      protocol: TCP
{{- end }}
