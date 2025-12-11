FROM alpine:3.19

RUN apk update && apk upgrade && \
    apk add --no-cache \
    mariadb \
    mariadb-client

# 必要なディレクトリを作成
RUN mkdir -p /var/lib/mysql /run/mysqld /var/log/mysql

# パーミッションを設定
RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld /var/log/mysql

# MariaDB設定ファイルをコピー
COPY conf/my.cnf /etc/my.cnf.d/my.cnf
RUN sed -i 's/^skip-networking/#skip-networking/' /etc/my.cnf.d/mariadb-server.cnf

# 初期化スクリプトをコピー
COPY tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

EXPOSE 3306

ENTRYPOINT ["/tmp/setup.sh"]

CMD ["mysqld", "--user=mysql", "--console"]
