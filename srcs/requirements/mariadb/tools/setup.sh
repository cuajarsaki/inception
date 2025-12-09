#!/bin/sh

# シークレットファイルからパスワードを読み込む
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

# MariaDBデータディレクトリを初期化（未初期化の場合のみ）
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db > /dev/null

    # 一時的なMariaDBサーバーを起動してセットアップを実行
    mysqld --user=mysql --bootstrap --skip-networking=0 << EOF
USE mysql;
FLUSH PRIVILEGES;

-- rootパスワードを設定
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

-- WordPressデータベースを作成
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- WordPressユーザーを作成
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- 匿名ユーザーとテストデータベースを削除
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

FLUSH PRIVILEGES;
EOF

    echo "MariaDB initialization completed!"
else
    echo "MariaDB is already initialized."
fi

# MariaDBを起動
echo "Starting MariaDB..."
exec "$@"
