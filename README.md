# docker-phpipam

![phpIPAM logo](http://phpipam.net/wp-content/uploads/2014/12/phpipam_logo_small.png)

phpIPAMはオープンソースのWeb型IPアドレス管理アプリケーションです。軽量でシンプルな操作が特徴です。  
phpIPAMは、Miha Petkovsekによって開発、保守されています。ライセンスはGPL v3です。  
プロジェクトのソースは[こちら](https://github.com/phpipam/phpipam)です。  
[phpIPAM homepage](http://phpipam.net)


## 使用方法

### Mysql

phpipam専用のMySQLデータベースを実行する。

```bash
$ docker run --name phpipam-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -v /my_dir/phpipam:/var/lib/mysql -d mysql:5.6
```

データを`/my_dir/phpipam`に保存し、DBのrootパスワードを設定する。

### phpipam 

```bash
$ docker run -ti -d -p 80:80 --name ipam --link phpipam-mysql:mysql pierrecdn/phpipam
```

2つのコンテナをリンクしてHTTPポート(80)を公開する。

### セットアップ

* Browse to `http://<ip>[:<port>]/install/`
* Step 1 : 'Automatic database installation' を選択

![step1](https://cloud.githubusercontent.com/assets/4225738/8746785/01758b9e-2c8d-11e5-8643-7f5862c75efe.png)

* Step 2 : DB認証情報の入力

![step2](https://cloud.githubusercontent.com/assets/4225738/8746789/0ad367e2-2c8d-11e5-80bb-f5093801e139.png)

* Note これら2つの最初のステップは、phpipamにパッチを当てて交換することができます (https://github.com/phpipam/phpipam/issues/25 を参照)
* Step 3 : 管理者ユーザ(admin)のパスワードを設定

![step3](https://cloud.githubusercontent.com/assets/4225738/8746790/0c434bf6-2c8d-11e5-9ae7-b7d1021b7aa0.png)

* 完了 ! 

![done](https://cloud.githubusercontent.com/assets/4225738/8746792/0d6fa34e-2c8d-11e5-8002-3793361ae34d.png)

### Docker compose 

```yaml
version: '2'

services:
  mysql:
    image: mysql:5.6
    environment:
      - MYSQL_ROOT_PASSWORD=Passw0rd!
    restart: always
    volumes:
      - db_data:/var/lib/mysql
  ipam:
    depends_on:
      - mysql
    image: kmd2kmd/phpipam
    environment:
      - MYSQL_ENV_MYSQL_ROOT_PASSWORD=Passw0rd!
    ports:
      - "80:80"
volumes:
  db_data:
```

## 今後の予定
DBの認証情報入力を自動化
SNMPモジュールの有効化
