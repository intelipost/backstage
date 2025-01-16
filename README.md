# [Backstage](https://backstage.io)

This is your newly scaffolded Backstage App, Good Luck!

To start the app, run:

```sh
yarn install
yarn dev
```

```
Send image to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 721642697306.dkr.ecr.us-east-1.amazonaws.com

yarn install --immutable

# tsc outputs type definitions to dist-types/ in the repo root, which are then consumed by the build
yarn tsc

# Build the backend, which bundles it all up into the packages/backend/dist folder.
yarn build:backend


docker image build --platform linux/amd64 . -f packages/backend/Dockerfile --tag 721642697306.dkr.ecr.us-east-1.amazonaws.com/backstage:1.0.16

docker push 721642697306.dkr.ecr.us-east-1.amazonaws.com/backstage:1.0.16
```