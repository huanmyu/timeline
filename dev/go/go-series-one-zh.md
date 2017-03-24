# Go语言

## Go语言的历史
1. Go语言起源于Google工程师Robert Griesemer，Rob Pike 和 Ken Thompson的一项实验， 来设计一门新的编程语言， 以解决别的语言的一些共同的弱点，同时保留他们好的部分。新语言将拥有下面这些特点：
    - 基于静态类型，可以扩展到大型的系统（类似 Java 和 C++）。
    - 具有生产力和可读性，没有太多的强制性关键字和重复。
    - 不依赖工具，但可以很好支持工具开发。
    - 支持网络和多任务处理。
2. Go语言在2009年11月宣告诞生。
3. Go语言1.0在2012年3月发布。
4. Go语言1.5在2015年8月发布，同时实现自举。
5. 今年发布是的1.8的版本。

## Go语言的基础知识
1. [Go语言的安装](https://golang.org/doc/install)。
2. 项目的工作区-Go程序员一般需要保持所有的Go语言代码在单个工作区里面，包含一下目录：
  - 可执行go文件目录-bin目录
  - go包对象目录-pkg目录
  - go源代码文件-src目录
3. Go原生提供的工具。
  - fmt build run get test...
4. HelloWorld程序。

        package main

        import (
          "fmt"
        )

        func main() {
          fmt.Println("HelloWorld!")
        }

## Go语言的变量和类型

### 变量
1. 变量是一个包含值的存储空间。
2. 变量的声明和使用:

        var a int
        a = 3

        var a = 3

        a := 3

### 指针
1. 指针的值是变量的地址。
2. 指针的声明和使用:

        x := 1
        p := &x
        fmt.Println(*p) //"1"

        *p = 2
        fmt.Println(*p) // "2"

### 类型

### 基本数据类型
1. int8 int16 int32(rune) int64
2. uint8 uint16 unit32 unit64
3. float32 float64
4. complex64 complex128

        var x complex128 = complex(1, 2)

5. bool
6. string

        s := "hello, world"
        fmt.Println(len(s))
        fmt.Println(s[0], s[7])  // "104, 119" ('h' and 'w')
        fmt.Println(s[0:5] // "hello"

### 复杂数据类型
1. array

        var a [3] int
        fmt.Println(a[0])

2. slices（动态数组）

        var x []int
        x = append(x, 1)
        x = append(x, 2, 3)
        fmt.Println(x) // "[1, 2, 3]"

3. maps

        var ages map[string]int
        fmt.Println(ages == nil) // "true"
        ages = make(map[string]int)
        ages["bowen"] = 24

4. struct

        type Point struct{ X, Y int }
        p := Point{1, 2}

        // 嵌套字段
        type Circle struct {
            Center Point
            Radius int
        }

        // 匿名字段
        type Circle struct {
            Point
            Radius int
        }

## Go语言的方法和接口

### 方法和对象
1. Go语言中一个方法是一个关联一个特殊类型的函数， 对象是一个拥有方法的简单的值或者变量。
2. 方法的声明。

        package geometry

        import "math"

        type Point struct{ X, Y float64 }

        // package-level function
        func Distance(p, q Point) float64 {
            return math.Hypot(q.X-p.X, q.Y-p.Y)
        }

        // method of type Point
        func (p Point) Distance(q Point) float64 {
            return math.Hypot(q.X-p.X, q.Y-p.Y)
        }

3. 上面代码中p被叫method的接收者，p的命名规则一般取p类型名的首字母。
4. 方法的使用。

        p := Point{1, 2}
        q := Point{4, 6}
        fmt.Println(Distance(p, q)) // "5", function call
        fmt.Println(p.Distance(q))  // "5", method call

5. 方法的接受者可以是指针，节省内存空间。

        func (p *Point) ScaleBy(factor float64) {
            p.X *= factor
            p.Y *= factor
        }

6. 方法的组合

        //declarations
        import "image/color"

        type ColoredPoint struct {
            Point
            Color color.RGBA
        }

        //usage
        red := color.RGBA{255, 0, 0, 255}
        blue := color.RGBA{0, 0, 255, 255}
        var p = ColoredPoint{Point{1, 1}, red}
        var q = ColoredPoint{Point{5, 4}, blue}
        fmt.Println(p.Distance(q.Point)) // "5"
        p.ScaleBy(2)
        q.ScaleBy(2)
        fmt.Println(p.Distance(q.Point)) // "10"

7. 对象的封装，Go语言使用字母大小写来限定字段和变量的作用域

        type Point struct{ x, y float64 }

### 接口
1. Go语言的接口是一个抽象类型, 它只是声明一些方法。 接口定义了一组方法,一个具体类型需要拥有这些方法才能被认为是这个接口的实例。
2. 接口的声明

          package io

          type Writer interface {
              Writer(p []byte) (n int, err error)
          }

          type Reader interface {
              Read(p []byte) (n int, err error)
          }

          type Closer interface {
              Close() error
          }

3.  一个类型满足一个接口e，只有当这个类型实现了这个接口定义的所有方法。

          var w io.Writer
          w = os.Stdout              // ok
          w = new(bytes.Buffer)      // ok
          w = time.Second            // compile error

          var any interface{}
          any = true
          any = 12.24
          any = "hello"
          any = new(bytes.Buffer)
          any = time.Second

4. 接口的值包含两个部分，实现这个接口的类型，以及这个类型的值。

          var w io.Writer
          w = os.Stdout
          w = new(bytes.Buffer)
          w = nil

5. 接口类型的断定

          x.(T)

6. 类型转换

          switch x.(type) {
          case nil:
          case int, unint:
          case bool:
          case string:
          default:
          }

## Go语言的并发编程

### CSP(通信顺序进程)
CSP是一种并发模型，在这种模型中变量的值可以在不同的独立活动（goroutines）中进行传递，但是变量本身大部分仅限于单个活动。

#### Goroutines
1. 每个并发执行的活动被叫做一个goroutine.
2. go语言里面通过go关键字创建一个goroutine, main函数的执行也是一个goroutine。

          f() // call f(); wait for is to return
          go f() // create a new goroutine that calls f(); don't wait

3. Goroutine和线程的区分
  - 程序栈是一个工作区，用于保存被调用执行的函数的局部变量， 函数可以是正在被执行，也可以是由于另外一个函数被调用而被临时挂起。
  - 操作系统线程的栈有一个固定大小的内存（经常是2MB的大小）。
  - 一个goroutine的被创建时，它的栈比较小，一般是2KB的大小,它跟随程序的需要扩展和收缩。
  - 操作系统线程是被操作系统内核调度的，每隔几毫秒，一个硬件计时器会中断处理器，这会导致调用一个称为调度器的内核函数，去调度线程，这个过程中会有一个完整的上下文切换的花费。
  - Go语言的运行时包含它自己的调度器，被叫做m:n调度器。Go调度器不是由硬件定时器周期性地调用，而是由某些Go语言结构隐含地调用。

#### 通道（channels）
1. 一个通道是让一个goroutine发送数据给另外一个goroutine的通讯机制。
2. 每个通道(channel)是特定类型值的通道，称为通道的元件类型。

          // create a channel
          ch := make(chan int) // ch has type 'chan int', unbuffered channel
          ch := make(chan int, 3) // ch has type 'chan int' , buffered channel with capacity 3

          // send and receive operations
          ch <- x  // a send statement
          x = <-ch // a receive expression in an assignment statement

          <-ch
          //close operations
          close(ch)

4. 在非缓冲通道上发送数据会阻塞发送数据的goroutine，直到另外一个goroutine执行在相同的通道上一个相应的接收数据的操作。此时该数据就被发送到另外一个goroutine，并且两个goroutine都可以继续。
5. 在缓冲通道上具有一个元素队列，缓冲通道上的发送操作将一个元素插入队列后面，接收操作从前面移除一个元素。当队列满的时候会阻塞goroutine。
6. 多路复用选择器

          select {
          case <-ch1:
              // ...
          case x := <-ch2:
              // ...
          case ch3 <- y:
              // ...
          default:
              // ...
          }
