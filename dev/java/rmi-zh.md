# 远程过程调用（英语：Remote Procedure Call，缩写为 RPC）
1. 在分布式计算环境中，一个远程过程调用就是一个计算程序调用在另一个地址空间（通常实在共享网络的另一个计算机上）的一个远程程序（子程序），程序员不需要明确地编写与远程程序交互的细节，只需要像编写一个正常（本地）过程调用那样编写代码就可以了。它属于客户端－服务器交互的一种形式（调用者是客户端，远程程序执行者是服务端）。

2. 在20世纪90年代，随着面向对象编程的普及，一种叫做远程方法调用（RMI）的替代模型被广泛实现，　如通用对象请求代理体系结构(CORBA)和Java远程方法调用，下面会重点关注Java的RMI.

## RMI
RMI应用程序通常由两个单独的程序组成：服务器和客户端。 一个典型的服务器应用程序会创建一些远程对象，使这些远程对象可以被远程访问，并等待客户端调用这些远程对象上的方法。 典型的客户端应用程序获取对服务器中一个或多个远程对象的远程引用，然后调用它们上的方法。 RMI提供了服务器和客户端来回传递信息的机制。 这样的应用有时被称为分布式对象应用。

### Java 远程方法调用（英语：Java Remote Method Invocation，缩写为 Java RMI)
1. Java远程方法调用系统允许在一个Java虚拟机中运行的对象调用在另一个Java虚拟机中运行的对象的方法。RMI提供用Java编程语言编写的程序之间的远程通信。

2. 根据上面的说法设想我们现在要完成一个远程方法调用，应该包含一个在本地Java虚拟机（VM）中运行的对象，即客户端；在远程Java虚拟机（VM）中运行的对象，即服务器端；由于客户端需要知道要调用的远程对象的位置，也即需要一个管理远程对象位置的注册表，客户端可以通过这个注册表去查找远程对象；一般来说，客户端通过注册表找到远程对象之后，就可以调用远程对象的方法，客户端可能会发送一些参数给远程对象，然后远程对象执行被调用的方法，并把结果返回给客户端。

3. Java里面的RMI功能是由java.rmi包提供的。它包含Remote接口和RemoteObject, 以及RemoteExcetion，任何对象必须实现Remote接口才能使用Java RMI的机制；远程对象的创建以及导出（可以被客户端发现）是通过RemoteObject及其子类实现的；当客户端调用这样对象（远程）的方法时，客户端传递的参数被编组（写入和传输）到远程对象的方法里面（从本地的虚拟机发送到远程对象所在虚拟机）, 然后参数被解组（读取），从而可以进行正常调用。当方法执行完，　执行结果会从远程对象放在虚拟机发送到客户端所在的虚拟机。如果方法调用的过程中出现异常，远程对象会向客户端返回RemoteExcetion异常。

4. 接下来是一个简单的实现，我们简单完成一个Hello, World的功能。
首先我们定义一个Hello的接口，它实现Remote接口。

    public interface Hello extends Remote {
    	String sayHello() throws RemoteException;
    }

它实现java.rmi.Remote接口，并且抛出java.rmi.RemoteException异常

然后我们定义一个Hello接口的实现类HelloWorld，它仅仅返回Hello, World!的字符串，并且它是属于服务端程序的。

    public class HelloWorld implements Hello {
    	public String sayHello() throws RemoteException　{
    		return "Hello, World!";
    	}
    }

接下来我们定义服务端程序的入口Server类

    public class Server {
    	public static void main(String[] args) {
           try {
                String name = "Hello";

                //创建和导出helloworld对象
                HelloWorld helloworld = new HelloWorld();
                Hello stub = (Hello) UnicastRemoteObject.exportObject(helloworld, 0);

                // 获取注册表并在它上绑定导出对象
                Registry registry = LocateRegistry.getRegistry();
                registry.bind(name, stub);

                System.err.println("Server ready");
           } catch (Exception e) {
        	   System.err.println("Server exception: " + e.toString());
                e.printStackTrace();
            }
        }
    }

它通过RemoteObject的子类java.rmi.server.UnicastRemoteObject来创建和导出helloworld对象。接着使用java.rmi.registry.LocateRegistry的getRegistry()获取注册表，然后在注册表上绑定导出对象。

最后我们定义客户端程序Client类

    public class Client {
    	public static void main(String[] args) {
    		try {
                // 获取注册表,根据给定名称查找绑定的远程对象引用
                Registry registry = LocateRegistry.getRegistry();
                Hello stub = (Hello) registry.lookup("Hello");

                // 调用远程对象的方法，并打印结果
                String response = stub.sayHello();
                System.out.println("response: " + response);
            } catch (Exception e) {
                System.err.println("Client exception: " + e.toString());
                e.printStackTrace();
            }
    	}
    }

5. 需要借助jdk的rmiregistry命令，该命令在当前主机的指定端口上创建并启动远程对象注册表。 如果省略端口，则注册表在端口1099上启动。运行rmiregistry命令之后，我们就可以使用LocateRegistry.getRegistry方法获取注册表。

6. 使用下面命令来运行测试程序

        git clone https://github.com/bowenchen6/java-rmi.git
        cd java-rmi/example/rmi/
        javac -d classes/ *.java
        cd classes/
        rmiregistry & (在windows平台使用　start rmiregistry)
        java example.rmi.Server // output: `Server ready`

        //打开另外一个终端，在classes目录下运行下面命令即可获取程序运行结果。
        java example.rmi.Client　　// output: `response: Hello, World!`

7. 之后会再深入的学习，完成和spring的对接。

# 参考衔接
1. [维基百科-RPC](https://en.wikipedia.org/wiki/Remote_procedure_call)
2. oracle 相关文档
    https://docs.oracle.com/javase/8/docs/platform/rmi/spec/rmiTOC.html
    https://docs.oracle.com/javase/tutorial/rmi/
    http://docs.oracle.com/javase/7/docs/technotes/tools/solaris/rmiregistry.html
    https://docs.oracle.com/javase/8/docs/api/java/rmi/package-summary.html
5. [Michael的博文](http://miknight.blogspot.com/2005/09/how-to-get-java-rmi-going-on-mac-os-x.html)
