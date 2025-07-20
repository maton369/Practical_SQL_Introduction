#!/bin/bash

docker exec -i mysql-container \
  mysql -u user -puserpass sample_db < ./db/init/03_select_all_explain.sql \
  > output.log 2>&1