# IAM-Rolle für Lambda: erlaubt es, die Rolle von Lambda anzunehmen (AssumeRole).
resource "aws_iam_role" "lambda_role" {
  name = "slack-lambda-role"

  # Vertrauensbeziehung: Nur der Lambda-Service darf diese Rolle annehmen.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Minimal notwendige Berechtigung für Logs: schreibt in CloudWatch Logs.
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.lambda_role.name
  # Managed Policy von AWS: Basis-Execution (Logs).
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
