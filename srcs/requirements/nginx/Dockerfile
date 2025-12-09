FROM alpine:3.19

RUN apk update && apk upgrade && \
    apk add --no-cache \
    nginx \
    openssl

# 必要なディレクトリを作成
RUN mkdir -p /etc/nginx/ssl /var/www/html /run/nginx

# NGINX設定ファイルをコピー
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/http.d/default.conf

# SSL証明書生成スクリプトをコピー
COPY tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

# 自己署名SSL証明書を生成
RUN /tmp/setup.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
