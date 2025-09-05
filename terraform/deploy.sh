#!/bin/bash
set -e  # Script bricht sofort ab, wenn ein Fehler auftritt

# 🔧 Variablen
TFVARS_FILE="terraform.tfvars"   # Variablen-Datei
PLAN_FILE="plan.tfplan"          # gespeicherter Plan
OUTPUT_FILE="out.json"           # Ergebnis vom Lambda-Test
TEST_MESSAGE="Hallo #testlambda, ich komme aus Lambda 🚀"

echo "🚀 Starte Deployment..."

# 1. Terraform initialisieren (Provider laden, Backend einrichten)
terraform init

# 2. Terraform-Plan erstellen (Unterschiede zu AWS prüfen)
terraform plan -var-file=$TFVARS_FILE -out=$PLAN_FILE

# 3. Terraform-Apply (ändert AWS entsprechend dem Plan)
terraform apply -auto-approve $PLAN_FILE

# 4. Lambda-Infos auslesen
FUNCTION_NAME=$(terraform output -raw lambda_name)
REGION=$(terraform output -raw region)

echo "✅ Deployment abgeschlossen"
echo "Lambda-Funktion: $FUNCTION_NAME"
echo "Region: $REGION"

# 5. Lambda automatisch testen
echo "🧪 Teste Lambda mit Nachricht an Slack..."
aws lambda invoke \
  --function-name $FUNCTION_NAME \
  --region $REGION \
  --payload "{\"text\":\"$TEST_MESSAGE\"}" \
  --cli-binary-format raw-in-base64-out \
  $OUTPUT_FILE >/dev/null

cat $OUTPUT_FILE
echo -e "\n✅ Test abgeschlossen – prüfe Slack-Kanal 🎉"
