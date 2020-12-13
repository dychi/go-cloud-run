# go-cloud-run
## GCRへのプッシュ
GCPのアカウント、プロジェクト指定
```
gcloud config set account <account-name>
gcloud config set project <GCP_PROJECT>
```

DockerコンテナのビルドとGCRへのプッシュ
```
docker build -t asia.gcr.io/<GCP_PROJECT>/go-hello-world .
docker push asia.gcr.io/<GCP_PROJECT>/go-hello-world:latest
```

## Cloud Run

```
gcloud run deploy go-hello-world --image asia.gcr.io/<GCP_PROJECT>/go-hello-world \
    --platform managed \
    --region asia-northeast1 \
    --allow-unauthenticated
```