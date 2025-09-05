# Name der Lambda-Funktion (frei wählbar).
variable "function_name" {
  description = "Name der Lambda Funktion"
  type        = string
  default     = ""
}

# Slack-Token als Variable (sensitiv). Wenn du das Slack-Thema gerade ausklammerst,
# kannst du hier auch einen Dummy setzen – Lambda braucht die Variablen nicht zwingend,
# solange dein Code ohne sie umgehen kann.
variable "slack_bot_token" {
  description = "Slack Bot Token"
  type        = string
  sensitive   = true
  default     = "" # leer lassen oder via tfvars befüllen
}

# Slack-Channel-ID (oder leer lassen, wenn du es nicht brauchst).
variable "slack_channel_id" {
  description = "Slack Channel ID"
  type        = string
  default     = "" # leer lassen oder via tfvars befüllen
}

# Optional: Timeout für die Lambda (Sekunden). 10 ist oft praxisnah.
variable "lambda_timeout" {
  description = "Timeout der Lambda in Sekunden"
  type        = number
  default     = 10
}

# Optional: Speicher der Lambda in MB.
variable "lambda_memory" {
  description = "Speicher der Lambda in MB"
  type        = number
  default     = 128
}

# Pfad zu deiner index.js (falls du sie an anderem Ort liegen hast).
variable "lambda_source_file" {
  description = "Pfad zur index.js"
  type        = string
}

variable "region" {
    description = "AWS Region, in der Ressourcen erstellt werden"
    type        =  string 
}
