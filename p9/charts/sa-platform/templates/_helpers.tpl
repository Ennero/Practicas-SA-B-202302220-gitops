{{- define "sa-platform.fullname" -}}
{{- default .Release.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sa-platform.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride -}}
{{- end -}}

{{- define "sa-platform.labels" -}}
app.kubernetes.io/part-of: sa-platform
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "sa-platform.configData" -}}
AUTH_URL: "http://auth:3001"
CUENTAS_URL: "http://cuentas:3002"
BENEFICIARIOS_URL: "http://beneficiarios:3003"
TRANSACCIONES_URL: "http://transacciones:3004"
NOTIFICACIONES_URL: "http://notificaciones:3005"
CORS_ORIGIN: {{ .Values.config.corsOrigin | quote }}
NODE_ENV: "production"
COOKIE_SECURE: "false"
LOG_LEVEL: {{ default "info" .Values.profile.logLevel | quote }}
{{- end -}}

{{- define "sa-platform.serviceImage" -}}
{{- if .root.Values.profile.imageRepository -}}
{{ .root.Values.profile.imageRepository }}:{{ default "1.25-alpine" .root.Values.profile.imageTag }}
{{- else if .root.Values.profile.imageTag -}}
p5-{{ .service.name }}:{{ .root.Values.profile.imageTag }}
{{- else -}}
{{ .service.image }}
{{- end -}}
{{- end -}}
