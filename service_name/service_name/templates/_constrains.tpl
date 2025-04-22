{{/*
A template to handel constrains.
*/}}

{{/*
Fail in case internal replicaCount is more than "0".
*/}}
{{- if gt (.Values.general.replicaCount | int) 0 }}
  {{ fail "Deployment replicaCount cannot be more than 0 in case internal database is used."}}
{{- end }}

{{/*
Only env old or new enabled.
*/}}
{{- if .Values.env.old.enabled }}
  {{- if .Values.env.new.enabled }}
  {{ fail "Deployment can't not have two env please checl again file value."}}
  {{- end }}
{{- end }}