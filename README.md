[![CircleCI](https://dl.circleci.com/status-badge/img/gh/dairin007/mc_paper_server/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/dairin007/mc_paper_server/tree/master)

This project is in reference to sksat minecraft [repository](https://github.com/sksat/mc.yohane.su)

- my minecraft paper server

crontab で scripts/download_pligin.sh を定期実行させる

# 更新手順

1. itgz のイメージの sha256 を更新(docker-compose.yaml 内,test も)
2. paper で動かす version を更新(docker-compose.yaml 内,test も)

# plugin の更新

1. download_plugin.sh のバージョンの更新
