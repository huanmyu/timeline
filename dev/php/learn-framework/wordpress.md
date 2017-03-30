# Wordpress
- [Document](https://cn.wordpress.org/)
- [Plugin Handbook](https://developer.wordpress.org/plugins/intro/)

## 安装
1. 下载[wordpress压缩包](https://cn.wordpress.org/wordpress-4.7.3-zh_CN.zip)
2. 安装vagrant 设置一个全新的虚拟机环境（可略过）
3. 安装Nginx

    sudo apt install nginx

4. 安装Mysql(注意保存设置的root密码)

    sudo apt install mysql-server mysql-client

5. 安装PHP及其扩展

    sudo apt install php7.0 php-mysql

6. 添加Nginx配置文件
    server {
        listen       80;
        server_name  dev.wm.com;
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

7. 在本地host文件添加dev.wm.com的路由

    192.168.33.10  dev.wm.com

8. 创建数据库

    CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

9. 本地访问http://dev.wm.com，根据页面提示，填写配置信息，保存进入系统后台。

## 额外
如果进行安装步骤的第二步，生成一个全新的环境。
### 安装Vagrant以及VirtualBox
1. 下载并安装[Vagrant](https://www.vagrantup.com/downloads.html)
2. 下载并安装[VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads)
3. 创建项目目录，wordpress可以放在里面，然后运行下面命令，创建虚拟机环境

    vagrant init ubuntu/xenial64; vagrant up --provider virtualbox

4. 修改Vagrantfile文件

    config.vm.network "forwarded_port", guest: 3306, host: 3306
    config.vm.network "private_network", ip: "192.168.33.3"

5. 执行上面3-8条命令，然后修改mysql配置文件/etc/mysql/mysql.conf.d/mysqld.cnf把bind-address设为0.0.0.0

    bind-address            = 0.0.0.0

6. Vagrant 常用命令
  - vagrant init    通过创建一个Vagrantfile文件来初始化一个新的Vagrant环境
  - vagrant halt    停掉Vagrant机器
  - vagrant up      启动并配置Vagrant环境
  - vagrant reload  重启Vagrant机器，并且加载Vagrantfile文件的新配置
