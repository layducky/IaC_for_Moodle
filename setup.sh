#!/bin/bash

set -e

echo "=== 🔧 Starting environment setup for Terraform + AWS CLI ==="

# ---- Install required tools ----
sudo apt-get install -y curl unzip wget gnupg software-properties-common

# ---- Install AWS CLI if missing ----
if ! command -v aws &> /dev/null; then
  echo "[INFO] Installing AWS CLI v2..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
  echo "[OK] AWS CLI installed successfully."
else
  echo "[OK] AWS CLI already installed: $(aws --version)"
fi

# ---- Install Terraform (official repo) ----
if ! command -v terraform &> /dev/null; then
  echo "[INFO] Installing Terraform from HashiCorp official repository..."
  wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

  sudo apt-get update -y
  sudo apt-get install -y terraform
  echo "[OK] Terraform installed successfully."
else
  echo "[OK] Terraform already installed: $(terraform -version | head -n 1)"
fi

# ---- Configure AWS CLI ----
echo ""
echo "=== 🔑 AWS CLI Configuration ==="
if aws sts get-caller-identity &> /dev/null; then
  echo "[OK] AWS CLI is already configured and working."
else
  echo "[INFO] AWS credentials not found. Run the following command to configure:"
  echo "      aws configure"
  echo "Then enter:"
  echo "  AWS Access Key ID"
  echo "  AWS Secret Access Key"
  echo "  Default region (e.g., ap-southeast-1)"
  echo "  Output format (e.g., json)"
  exit 1
fi

# ---- Terraform initialization & apply ----
echo ""
echo "=== ⚙️ Terraform Execution ==="
if [ -f "main.tf" ]; then
  if [ ! -d ".terraform" ]; then
    echo "[INFO] Running terraform init..."
    terraform init
  else
    echo "[OK] Terraform already initialized."
  fi

  echo "[INFO] Running terraform apply..."
  terraform apply -auto-approve
else
  echo "[ERROR] No Terraform configuration (main.tf) found in current directory."
  echo "Please move this script into your Terraform project folder and rerun."
  exit 1
fi

echo ""
echo "✅ Setup complete!"
echo "You can verify resources on your AWS Console."
