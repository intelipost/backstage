#!/bin/bash

# Detect OS type (Mac or Linux)
if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "Running on MacOS"
  PLATFORM="--platform linux/amd64"
else
  echo "Running on Linux"
  PLATFORM=""
fi

# Verify if the project intelipost-deploy-eks-foundation exists
PROJECT_DIR="../intelipost-deploy-eks-foundation"
if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "Project intelipost-deploy-eks-foundation not found. Cloning..."
  cd ..
  git clone git@github.com:intelipost/intelipost-deploy-eks-foundation.git
  cd -
else
  echo "Project intelipost-deploy-eks-foundation already exists."
fi

# Authenticate with AWS ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 721642697306.dkr.ecr.us-east-1.amazonaws.com

# Check if GitHub CLI (gh) is installed and authenticated
if ! command -v gh &> /dev/null; then
  echo "GitHub CLI (gh) is not installed. Please install it before proceeding."
  exit 1
fi

if ! gh auth status &> /dev/null; then
  echo "GitHub CLI (gh) is not authenticated. Please authenticate using 'gh auth login'."
  exit 1
fi

# Update the version using yarn
yarn version patch
yarn install --immutable

# Compile TypeScript
yarn tsc

# Build the backend
yarn build:backend

# Get the current version from package.json
VERSION=$(npm pkg get version | tr -d '"')

# Build the Docker image
docker image build $PLATFORM . -f packages/backend/Dockerfile --tag 721642697306.dkr.ecr.us-east-1.amazonaws.com/backstage:$VERSION

# Push the Docker image
docker push 721642697306.dkr.ecr.us-east-1.amazonaws.com/backstage:$VERSION

# Navigate to the project directory
cd "$PROJECT_DIR" || { echo "Failed to navigate to $PROJECT_DIR"; exit 1; }

# Path to the kustomization file
KUSTOMIZATION_FILE="overlays/prd_us-east-1/application/backstage/kustomization.yaml"

# Create a new branch for this version
git checkout -b "backstage-$VERSION"

# Update the newTag in kustomization.yaml
if [[ -f "$KUSTOMIZATION_FILE" ]]; then
  echo "Updating newTag in kustomization.yaml to version $VERSION"
  sed -i.bak "s/newTag:.*/newTag: $VERSION/" "$KUSTOMIZATION_FILE"
  rm "$KUSTOMIZATION_FILE.bak"
else
  echo "kustomization.yaml not found at $KUSTOMIZATION_FILE"
  exit 1
fi

git add "$KUSTOMIZATION_FILE"
git commit -m "Update backstage newTag to version $VERSION"

git push --set-upstream origin "backstage-$VERSION"

# Create a Pull Request
gh pr create --base backstage --head "backstage-$VERSION" --title "Update backstage to version $VERSION" --body "This PR updates the backstage version to $VERSION."
