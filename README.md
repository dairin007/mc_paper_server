[![CircleCI](https://dl.circleci.com/status-badge/img/gh/dairin007/mc_paper_server/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/dairin007/mc_paper_server/tree/master)

This project is in reference to sksat minecraft [repository](https://github.com/sksat/mc.yohane.su)

# 概要

- mineraft 用のサーバーの管理用リポジトリ
- 責任範囲は plugin の自動ダウンロード，サーバーの管理，バックアップサーバーの管理
- crontab で./scripts/autorestart.sh を毎日 4 時に実行して最新のコードを pull して再起動を実施

# 更新手順

1. itgz のイメージの更新をするとき

- docker-compose.yml 内でイメージを sha256 で指定をしている．

  なので docker-compose.yml 内のサーバー本体乃至はバックアップ用のイメージのハッシュ値を更新する

2. minecraft のバージョンを更新するとき

- この場合は docker-compose.yml 内と test/starttest.sh 内の version 指定を更新する．

  コケる場合は保留か plugin の更新を実施する

3. plugin の更新

- plugin のバージョンなどは scripts/download_plugin.sh で指定している．

  なのでこの中のバージョン指定を更新する．

# 実行方法

1. git clone
2. .env に TCP, UDP, metricd のポートを記載, discordsrv の config を置く（token とか）
3. bash ./start_prod.sh

   (失敗するときは docker-compose.yml 内の world 指定を削除するとよさそう)
