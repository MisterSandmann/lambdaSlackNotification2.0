# Schöne Outputs nach dem Apply.

output "lambda_name" {
  description = "Name der bereitgestellten Lambda-Funktion"
  value       = aws_lambda_function.slack_notify.function_name
}

output "lambda_arn" {
  description = "ARN der bereitgestellten Lambda-Funktion"
  value       = aws_lambda_function.slack_notify.arn
}

# output "lambda_url" {
#   description = "Öffentliche URL (falls aws_lambda_function_url aktiviert ist)"
#   value       = aws_lambda_function_url.url.function_url
# }

output "region" {
    description = "Region, in der die Lambda läuft"
    value = var.region
}
