[![CircleCI](https://dl.circleci.com/status-badge/img/gh/dairin007/mc_paper_server/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/dairin007/mc_paper_server/tree/master)

This project is in reference to sksat minecraft [repository](https://github.com/sksat/mc.yohane.su)

# 概要
- mineraft用のサーバーの管理用リポジトリ
- 責任範囲はpluginの自動ダウンロード，サーバーの管理，バックアップサーバーの管理

# 更新手順
1. itgzのイメージの更新をするとき
- docker-compose.yml内でイメージをsha256で指定をしている．

  なのでdocker-compose.yml内のサーバー本体乃至はバックアップ用のイメージのハッシュ値を更新する

2. minecraftのバージョンを更新するとき
- この場合はdocker-compose.yml内とtest/starttest.sh内のversion指定を更新する．
  コケる場合は保留かpluginの更新を実施する

3. plugin の更新
- pluginのバージョンなどはscripts/download_plugin.shで指定している．
  なのでこの中のバージョン指定を更新する．

# 実行方法
1. git clone
2. .envにTCP, UDP, metricdのポートを記載
3. bash ./start_prod.sh
   (失敗するときはdocker-compose.yml内のworld指定を削除するとよさそう)
