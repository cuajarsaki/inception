# Inception

## 概要

Inceptionは、Dockerとコンテナ化に焦点を当てたシステム管理プロジェクトです。Docker Composeを使用して、特定のルールに基づいて異なるサービスで構成された小規模なインフラストラクチャをセットアップすることが目標です。このプロジェクトでは、NGINX、WordPress、MariaDBを使用したマルチコンテナアプリケーションを作成し、適切なネットワーキングとボリューム管理を行います。



## 使用方法

### 前提条件

- DockerとDocker Composeがインストールされていること
- 最低4GBの空きディスク容量
- `/etc/hosts`ファイルで`pchung.42.fr`を`127.0.0.1`に設定

### セットアップ

1. **hostsファイルの設定:**
   ```bash
   sudo echo "127.0.0.1 pchung.42.fr" >> /etc/hosts
   ```

2. **インフラストラクチャのビルドと起動:**
   ```bash
   make
   ```

3. **Webサイトへのアクセス:**
   - ブラウザで`https://pchung.42.fr`にアクセス
   - 自己署名SSL証明書の警告を承認
   - WordPressのインストール画面が表示されます

### 利用可能なコマンド

- `make` または `make all` - すべてのコンテナをビルドして起動
- `make build` - Dockerイメージをビルド
- `make up` - デタッチモードでコンテナを起動
- `make down` - コンテナを停止して削除
- `make stop` - コンテナを削除せずに停止
- `make start` - 停止したコンテナを起動
- `make clean` - コンテナを停止してDockerシステムをクリーンアップ
- `make fclean` - ボリュームとデータを含む完全なクリーンアップ
- `make re` - すべてを最初から再ビルド
- `make logs` - コンテナログを表示
- `make status` - コンテナのステータスを確認
