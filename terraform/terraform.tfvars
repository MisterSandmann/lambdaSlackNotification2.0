# Kopiere diese Datei nach terraform.tfvars und fülle die Werte.
# WICHTIG: terraform.tfvars nicht einchecken, wenn Secrets drin stehen!

function_name    = "slack-notify-tf"
slack_bot_token  = ""  # oder leer lassen, wenn du Slack gerade nicht nutzt
slack_channel_id = ""      # oder leer lassen
region = ""
lambda_timeout = 10
lambda_memory  = 128
