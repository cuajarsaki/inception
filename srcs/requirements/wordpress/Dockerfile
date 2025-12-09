FROM alpine:3.19

RUN apk update && apk upgrade && \
    apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-redis \
    php82-phar \
    php82-tokenizer \
    php82-session \
    php82-gd \
    php82-iconv \
    php82-simplexml \
    php82-xmlreader \
    php82-xmlwriter \
    php82-sodium \
    wget \
    curl \
    mariadb-client

# 必要なディレクトリを作成
RUN mkdir -p /var/www/html /run/php

# WP-CLIをダウンロードしてインストール
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# PHP-FPM設定ファイルをコピー
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

# WordPressセットアップスクリプトをコピー
COPY tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/tmp/setup.sh"]

CMD ["/usr/sbin/php-fpm82", "-F"]
