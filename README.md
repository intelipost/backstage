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

docker image build --platform linux/amd64 . -f packages/backend/Dockerfile --tag 721642697306.dkr.ecr.us-east-1.amazonaws.com/backstage:1.0.0

docker push 721642697306.dkr.ecr.us-east-1.amazonaws.com/backstage:1.0.0
```