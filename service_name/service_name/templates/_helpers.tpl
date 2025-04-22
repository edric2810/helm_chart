{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default .Chart.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .Values.fullnameOverride .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Extend labels
*/}}
{{- define "common.podLabels" -}}
{{ with .Values.podLabels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "common.chart" . }}
{{ include "common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create Deployment define *Port*
*/}}
{{- define "common.deployment.ports" -}}
{{- range $value :=  .Values.service.ports }}
- name: {{ $value.name }}
  containerPort: {{ $value.targetPort }}
  protocol: {{ $value.protocol }}
{{- end }}
{{- end }}

{{/*
Create Service Ports for any type "ClusterIP" and "NodePort"
*/}}
{{- define "common.services.ports" -}}
{{- if eq .Values.service.type "ClusterIP" }}
{{- range $value :=  .Values.service.ports }}
- port: {{ $value.port }}
  targetPort: {{ $value.targetPort }}
  protocol: {{ $value.protocol }}
  name: {{ $value.name }}
{{- end }}
{{- end }}
{{- if eq .Values.service.type "NodePort"  }}
{{- range $value :=  .Values.service.ports }}
- port: {{ $value.port }}
  nodePort: {{ $value.nodePort }}
  targetPort: {{ $value.targetPort }}
  protocol: {{ $value.protocol }}
  name: {{ $value.name }}
{{- end }}
{{- end }}
{{- end }}

{{/* Define autoscaling */}}
{{- define "common.averageCpuByPercentage" -}}
{{ .Values.autoscaling.cpu.averagePercentage }}
{{- end -}}

{{- define "common.averageCpuValue" -}}
{{ .Values.autoscaling.cpu.averageValue }}
{{- end -}}

{{- define "common.averageMemoryByPercentage" -}}
{{ .Values.autoscaling.memory.averagePercentage }}
{{- end -}}

{{- define "common.averageMemoryValue" -}}
{{ .Values.autoscaling.memory.averageValue }}
{{- end -}}

{{/*Storage*/}}
{{- define "common.storage.className" }}
{{- default "" .Values.persistentVolumeClaim.storageClassName }}
{{- end -}}

{{- define "common.storage.accessModes" }}
{{- range $key, $value := .Values.persistentVolumeClaim.accessModes }}
- {{ $value | quote }}
{{- end }}
{{- end -}}



