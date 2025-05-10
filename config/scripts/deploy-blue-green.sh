#!/bin/bash

source ~/midterm/.env

if [ -z "$PROJECT_PATH" ] || [ -z "$DEPLOY_PATH" ] || [ -z "$COLOR" ] || [ -z "$PORT" ]; then
  echo "Missing required environment variables. Please check your .env file."
  exit 1
fi

if [ "$COLOR" != "blue" ] && [ "$COLOR" != "green" ]; then
  echo "Invalid COLOR: $COLOR"
  echo "Usage: export COLOR=blue|green"
  exit 1
fi

echo "Starting deployment pipeline..."
echo "Project Path: $PROJECT_PATH"
echo "Deploy Path: $DEPLOY_PATH"
echo "Color: $COLOR"

echo "Building the JAR file with Gradle..."
cd "$PROJECT_PATH" || exit 1
./gradlew bootJar || { echo "❌ Gradle build failed"; exit 1; }
echo "JAR built successfully."

echo "Running Terraform..."
cd "$PROJECT_PATH/config/terraform" || exit 1
terraform init
terraform validate
terraform plan -var="deploy_path=$DEPLOY_PATH" -out=tfplan
terraform apply -auto-approve -var="deploy_path=$DEPLOY_PATH"
cd "$PROJECT_PATH" || exit 1

echo "Deploying $COLOR version with Ansible..."
ansible-playbook "$PROJECT_PATH/config/ansible/deploy.yml" \
  -i "$PROJECT_PATH/config/ansible/hosts" \
  --extra-vars "color=$COLOR project_path=$PROJECT_PATH"

echo "Performing health check..."
bash "$PROJECT_PATH/config/scripts/health-check.sh"
if [ $? -eq 0 ]; then
  echo "Health check passed. Activating $COLOR version..."
  ln -sfn "$DEPLOY_PATH/midterm-$COLOR" "$DEPLOY_PATH/midterm-current"
else
  echo "Health check failed. Rolling back..."

  OTHER_COLOR="blue"
  [ "$COLOR" == "blue" ] && OTHER_COLOR="green"

  echo "Deploying fallback: $OTHER_COLOR..."
  export COLOR=$OTHER_COLOR
  ansible-playbook "$PROJECT_PATH/config/ansible/deploy.yml" \
    -i "$PROJECT_PATH/config/ansible/hosts" \
    --extra-vars "color=$COLOR project_path=$PROJECT_PATH skip_build=true"

  echo "Retesting health..."
  bash "$PROJECT_PATH/config/scripts/health-check.sh"
  if [ $? -eq 0 ]; then
    echo "Rollback succeeded with $OTHER_COLOR."
    ln -sfn "$DEPLOY_PATH/midterm-$OTHER_COLOR" "$DEPLOY_PATH/midterm-current"
  else
    echo "Rollback failed too. Manual intervention needed."
    exit 1
  fi
fi

echo "Deployment pipeline complete."
