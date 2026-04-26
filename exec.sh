#!/bin/bash

# devContainer (db サービス = mysql-container) 内で実行する想定
# 使い方: ./exec.sh <SQLファイルへのパス>
# 例:    ./exec.sh db/init/03_select_all_explain.sql

SQL_FILE="${1:-db/chapter07/04_select_correlated_subquery_weights.sql}"

if [ ! -f "$SQL_FILE" ]; then
  echo "SQLファイルが見つかりません: $SQL_FILE" >&2
  exit 1
fi

# -h で接続先サービス名を指定、--protocol=tcp で強制的にネットワーク経由にする
mysql -h mysql-container -u user -puserpass --protocol=tcp sample_db < "$SQL_FILE" > output.log 2>&1