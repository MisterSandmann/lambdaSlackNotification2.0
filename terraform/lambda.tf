# Baut automatisch ein ZIP-Archiv aus genau EINER Datei (index.js).
# Wenn du später mehr Dateien brauchst (node_modules, mehrere Files),
# nutze source_dir statt source_file.
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.lambda_source_file         # nimmt die index.js auf
  output_path = "${path.module}/function.zip"  # schreibt das ZIP neben die .tf-Dateien
}

# Die eigentliche Lambda-Funktion.
resource "aws_lambda_function" "slack_notify" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"     # erwartet in index.js: exports.handler = async (...) => { ... }
  runtime       = "nodejs20.x"        # Node 20.x wie in deinem Setup

  # Wir geben Terraform das ZIP aus dem archive_file-Data-Objekt.
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory
  architectures    = ["x86_64"]       # optional: ["arm64"] geht auch

  # Umgebungsvariablen (falls benötigt). Lässt du leer, wenn Slack gerade „außen vor“ ist.
  environment {
    variables = {
      SLACK_BOT_TOKEN  = var.slack_bot_token
      SLACK_CHANNEL_ID = var.slack_channel_id
    }
  }

  # Stelle sicher, dass die Rolle & deren Policy vorher „fertig“ sind.
  depends_on = [
    aws_iam_role_policy_attachment.basic_execution
  ]
}

# (Optional) HTTP-URL der Lambda (falls du sie später bequem aufrufen willst,
# ohne API Gateway voll zu konfigurieren). Standard: AuthType = NONE (nur für Tests).
# resource "aws_lambda_function_url" "url" {
#   function_name      = aws_lambda_function.slack_notify.function_name
#   authorization_type = "NONE"
# }

# (Optional) Ein „Test-Invoke“ nach dem Apply. Terraform ist deklarativ – Invokes sind
# eigentlich kein IaC, aber für einen Smoke-Test praktisch. Auskommentiert lassen,
# wenn du’s sauber halten willst. Erfordert AWS CLI lokal.
# resource "null_resource" "smoke_test" {
#   triggers = {
#     code_hash = data.archive_file.lambda_zip.output_base64sha256  # führe neu aus, wenn sich Code ändert
#   }
#   provisioner "local-exec" {
#     command = <<EOT
#       aws lambda invoke \
#         --function-name ${aws_lambda_function.slack_notify.function_name} \
#         --region ${data.aws_region.current.name} \
#         --payload '{"text":"Smoke-Test von Terraform 🚀"}' \
#         --cli-binary-format raw-in-base64-out \
#         out.json >/dev/null 2>&1 || true
#       echo "Smoke-Test (optional) ausgeführt."
#     EOT
#   }
#   depends_on = [aws_lambda_function.slack_notify]
# }

# Kleines Data-Objekt, um die aktuelle Region für das Smoke-Test-Command zu haben.
data "aws_region" "current" {}
