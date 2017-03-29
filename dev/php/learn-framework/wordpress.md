# Wordpress
[Document](https://tw.wordpress.org/about/)

## 安装
1. 下载[wordpress压缩包]（https://tw.wordpress.org/wordpress-4.7.3-zh_TW.zip）
2. 安装vagrant 虚拟机环境（可略过）
3. 安装Nginx

    sudo apt install nginx

4. 安装Mysql(注意保存设置的root密码)

    sudo apt install mysql-server mysql-client

5. 安装PHP及其扩展

    sudo apt install php7.0 php-mysql

6. 添加Nginx配置文件
    server {
        listen       80;
        server_name  dev.test.com;
        root  /vagrant/wordpress;
        index index.html index.htm index.php;

        access_log /var/log/nginx/ajax.wm.com-access.log;
        error_log  /var/log/nginx/ajax.wm.com-error.log;

        location / {
            try_files $uri $uri/ /index.php?$args;
        }

        location ~ .*\.(php|php5)?$ {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        }

        location ~ /\.(ht|svn|git) {
                deny all;
        }
    }

7. 在本地host文件添加dev.test.com的路由

    192.168.33.10  dev.test.com

8. 创建数据库

    CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
