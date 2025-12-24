{{/*
Common name for microservices
*/}}
{{- define "microservice-common.name" -}}
{{ .Chart.Name }}
{{- end }}

{{/*
Full release name
*/}}
{{- define "microservice-common.fullname" -}}
{{ .Release.Name }}
{{- end }}

{{/*
Service account name (IRSA ready)
*/}}
{{- define "microservice-common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{ default (include "microservice-common.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
default
{{- end }}
{{- end }}
