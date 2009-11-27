#!/bin/sh

# postgres
psql --user=postgres -c 'CREATE USER dm_is_reflective'
psql --user=postgres -c  "ALTER USER dm_is_reflective WITH PASSWORD 'godfat'"
createdb --user=postgres 'dm_is_reflective'
psql --user=postgres -c  'ALTER DATABASE dm_is_reflective OWNER TO dm_is_reflective'

# mysql
mysql5 -u root -p -e 'CREATE USER dm_is_reflective'
mysql5 -u root -p -e 'GRANT USAGE ON *.* TO dm_is_reflective@localhost IDENTIFIED BY "godfat"'
mysql5 -u root -p -e 'CREATE DATABASE dm_is_reflective'
mysql5 -u root -p -e 'GRANT ALL PRIVILEGES ON dm_is_reflective.* TO "dm_is_reflective"'
