# go-cloud-run
## GCRへのプッシュ
GCPのアカウント、プロジェクト指定
```
gcloud config set account $ACCOUNT_NAME
gcloud config set project $GCP_PROJECT
```

DockerコンテナのビルドとGCRへのプッシュ
```
docker build -t asia.gcr.io/$GCP_PROJECT/go-hello-world .
docker push asia.gcr.io/$GCP_PROJECT/go-hello-world:latest
```

## Cloud Run
Cloud Runへのデプロイ
```
gcloud run deploy go-hello-world --image asia.gcr.io/$GCP_PROJECT/go-hello-world \
    --platform managed \
    --region asia-northeast1 \
    --allow-unauthenticated \
    --service-account github-actions-cloud-run-sa
```

## Service account
カスタムロールの作成
```
gcloud iam roles create github_actions_cloud_run \
    --project=$PROJECT_ID \
    --title="GitHub Actions for Cloud Run"
```

サービスアカウントの作成
```
gcloud iam service-accounts create github-actions-cloud-run \
    --description="Github Actions Service Account to deply Cloud Run" \
    --display-name="github-actions-cloud-run-sa"
```

サービスアカウントのメールアドレスを環境変数に格納
```
SA_EMAIL=$(gcloud iam service-accounts list \
    --filter=displayName:github-actions-cloud-run-sa \
    --format='value(email)')
```

サービスアカウントに```roles/run.admin```ロールを追加する([link](https://cloud.google.com/run/docs/reference/iam/roles#gcloud))
```
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --role roles/run.admin \
    --member serviceAccount:$SA_EMAIL
```

```roles/storage.admin```ロールも追加
```
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --role roles/storage.admin \
    --member serviceAccount:$SA_EMAIL
```
```roles/iam.serviceAccountUser```ロールも追加
```
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --role roles/iam.serviceAccountUser \
    --member serviceAccount:$SA_EMAIL
```
サービスアカウントキーの作成
```
gcloud iam service-accounts keys create credentials/github-actions-cloud-run.json \
  --iam-account $SA_EMAIL
```

Githubのシークレットに登録するためにbase64エンコードを行う
```
cat credentials/github-actions-cloud-run.json | base64
```

## ローカルでサービスアカウントとしてgcloudコマンドを実行する方法
サービスアカウントキーでの認証
```
gcloud auth activate-service-account --key-file $PATH_TO_SA_KEY
```
アカウントの切り替え(ACCOUNT_NAMEはサービスアカウントもしくは個人IAMユーザーのメールアドレス)
```
gcloud config set account $ACCOUNT_NAME
```