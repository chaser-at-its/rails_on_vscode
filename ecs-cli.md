# ecs-cli
クラスタ、ロードバランサー(ターゲットグループも)は先に作っておく。  
クラスタはecs-cliでも作れるが、何度も作るわけではないのでecs-cliを使わない。

## インストール
https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ECS_CLI_installation.html

## 初期設定
https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ECS_CLI_Configuration.html

## タスク
- タスク定義
```
ecs-cli compose -f docker-compose.yml create --cluster-config main
```

- タスク実行  
  テストのため。本番はサービスでデプロイする。
```
ecs-cli compose -f docker-compose.yml up --cluster-config main
```

- タスク終了
```
ecs-cli compose -f docker-compose.yml down --cluster-config main
```

## サービス
- サービス新規作成  
  実行はしない。タスク数は指定できない。タスク定義の検証に使う。
```
ecs-cli compose -f docker-compose.yml service create `
--deployment-min-healthy-percent 0 --deployment-max-percent 100 `
--target-group-arn arn:aws:elasticloadbalancing:ap-northeast-1:002782830721:targetgroup/tg-main/cafe7d12d5a821a7 `
--container-name web --container-port 80 --cluster-config main
```

- タスク数調整
```
ecs-cli compose -f docker-compose.yml service scale 1
```

- サービス実行  
  createをupに変えただけ。新規作成後の変更に使える。  
  **target-group-arnにロードバランサーのARN入れてないか確認すること。**
```
ecs-cli compose -f docker-compose.yml service up `
--deployment-min-healthy-percent 0 --deployment-max-percent 100 `
--target-group-arn arn:aws:elasticloadbalancing:ap-northeast-1:002782830721:targetgroup/tg-main/cafe7d12d5a821a7 `
--container-name web --container-port 80 --timeout 10 --cluster-config main
```
