#!/bin/sh

# シークレットファイルからパスワードを読み込む
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# MariaDBが起動するまで待機
echo "Waiting for MariaDB to be ready..."
until mariadb -h mariadb -u"$MYSQL_USER" -p"$DB_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    sleep 2
done
echo "MariaDB is ready!"

# WordPressディレクトリに移動
cd /var/www/html

# WordPressをダウンロード（未設定の場合のみ）
if [ ! -f wp-config.php ]; then   
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    echo "Installing WordPress..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root

    echo "Creating additional WordPress user..."
else
    echo "WordPress is already configured."
fi

# 適切なパーミッションを設定
chown -R nobody:nobody /var/www/html
chmod -R 755 /var/www/html

echo "Starting PHP-FPM..."
exec "$@"
