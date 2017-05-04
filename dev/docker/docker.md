# [Docker简介](https://github.com/docker/labs)
使用docker之后，腰不酸腿不痛，然而并不代表终结。接下来简单介绍下docker的原理，有了大致印象之后，就可以慢慢地使用它，让我们的工作简化，方便。现在应该叫它Moby了。
docker是什么？Docker是世界领先的软件容器平台。
docker社区版安装衔接是https://store.docker.com/search?type=edition&offering=community，根据本机操作系统选择不同的方式来安装。
使用docker run hello-world命令来测试docker的安装。

简要介绍一下docker的整个生态系统
1. 镜像（image）－由文件系统和我们应用程序的配置组成，docker使用镜像来创建容器。一般来说我们使用docker pull命令来下载镜像到我们本地。我们也可以使用docker build命令来构建我们自己的镜像，这个时候我们需要创建一个Dockerfile文件。
2. 容器（container）－就是运行起来的docker镜像实例，我们使用docker容器来运行我们的应用程序，这就是docker的最终价值。我们可以使用docker run命令来运行我们的容器，使用docker ps命令来查看所有正在运行的容器。
3. Docker daemon－是执掌大权的人物，它可以说是docker的大脑，负责管理docker容器构建，运行，分发的实际工作，是幕后的英雄。
4. Docker client－是一个命令行工具，我们上面提及的所有与docker相关的命令，在docker内部都是通过docker client来实际与docker daemon进行交互，从而让docker daemon为我们工作。
5. Docker Hub－是一个共享docker镜像的好地方，是docker官方默认的镜像仓库，当我们使用docker pull加镜像名称下载镜像时，都是从Docker Hub上面下载镜像。它上面有无数的镜像，任我们使用。可以使用docker push命令把我们自己组建的镜像发布到Docker Hub上，从而让别人也可以使用；我们也可以自己搭建自己的私有仓库然后在团队内部使用。
6. Docker Composer－是一个强大的工具，一般来说我们的应用程序需要有多个容器来支撑，例如web服务容器，数据存储容器等。虽然通过多条docker命令可以使得多个容器运行起来，但是太耗神了。通过Docker Composer我们只需要维护一个yaml文件，就可以为我们的应用程序同时构建和运行多个需要的容器。
使用docker来运行java程序，同时熟悉docker的使用，需要自己安装maven。

1. 组建docker镜像
上面有提及过，当我们构建自己的镜像时，需要创建一个Dockerfile文件。当我们运行build命令时，docker会从Dockerfile文件中读取信息，依照信息来构建镜像。Dockerfile文件里面有一个常用的命令，FROM用来说明我们构建的镜像的基础，也可以说是来源。一般来说我们会使用Docker pull命令下载一个镜像，当我们想在这个镜像上添加一些专有的信息时，就可以用FROM命令指定我们基于的镜像。COPY命令用于把我们的一些程序文件和代码复制到容器里面。ENV命令可以用来设置一些环境变量。RUN命令用来执行命令。CMD命令用来执行容器。EXPOSE命令用来暴露端口，就像web服务总是基于80端口来提供服务，复杂一些的容器一般来说也需要暴露某些端口来提供服务。
一个简单的Dockerfile文件内容示例

    FROM ubuntu:latest　　　　　　　　　　　//基于ubuntu的基础镜像
    CMD ["/bin/echo", "hello world"]　　//使用echo程序提供输出hello world的服务

现在我们进行实际操作，创建一个hellodocker的目录，在里面创建一个Dockerfile文件，内容如上。
接着运行在里面运行docker build -t helloworld .命令，之后运行docker images就可以看到我们helloworld镜像，如下：
╰─$ docker images
REPOSITORY      TAG                 IMAGE ID            CREATED              SIZE
helloworld      latest              81e6ea406a2c        About a minute ago   117 MB

接下来使用docker run helloworld命令运行容器来验证我们的镜像。
╰─$ docker run helloworld
hello world
上面是一个简单容器构建运行的例子，接下来我们来构建我们的Java镜像，运行Java程序。

2. 创建一个简单的Java应用
使用mvn命令来生成
mvn archetype:generate -DgroupId=org.examples.java -DartifactId=helloworld -DinteractiveMode=false
然后进入helloworld目录打包
mvn　package
然后运行jar包
java -cp target/helloworld-1.0-SNAPSHOT.jar org.examples.java.App
结果如下：
╰─$ java -cp target/helloworld-1.0-SNAPSHOT.jar org.examples.java.App
Hello World!

3. 下载运行JDK镜像
docker pull openjdk
docker run -it openjdk

4. 仿照helloworld镜像，构建我们java版的helloworld镜像
Dockerfile文件放在helloworld目录里面，内容如下：

    FROM openjdk:latest　　//基于openjdk的镜像，下面两条命令分别是复制jar包到我们的容器里面，运行jar包。
    COPY target/helloworld-1.0-SNAPSHOT.jar /usr/src/helloworld-1.0-SNAPSHOT.jar
    CMD java -cp /usr/src/helloworld-1.0-SNAPSHOT.jar org.examples.java.App

接下来如第一步的步骤，我们构建一个叫做hello-java的镜像，然后运行容器，命令和结果一次如下：
    docker build -t hello-java .
    docker run hello-java
    Hello World!
