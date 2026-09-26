{{/* Nombre corto del chart padre. */}}
{{- define "sa-platform.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Nombre estable de los recursos compartidos. */}}
{{- define "sa-platform.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "sa-platform.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "sa-platform.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sa-platform.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sa-platform.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "sa-platform.labels" -}}
helm.sh/chart: {{ include "sa-platform.chart" . }}
{{ include "sa-platform.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: sa-platform
{{- end -}}

{{- define "sa-platform.secretName" -}}
{{- required "global.secret.name es obligatorio" (.Values.global.secret.name | default "") | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sa-platform.cronJobName" -}}
{{- printf "%s-%s" (include "sa-platform.fullname" .root) .name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sa-platform.cronLabels" -}}
helm.sh/chart: {{ include "sa-platform.chart" .root }}
app.kubernetes.io/name: {{ .name | quote }}
app.kubernetes.io/instance: {{ .root.Release.Name | quote }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
app.kubernetes.io/part-of: sa-platform
app.kubernetes.io/component: cronjob
{{- end -}}
