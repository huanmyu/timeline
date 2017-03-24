# Go

## Go History
1. Go originated as an experiment by Google engineers Robert Griesemer, Rob Pike, and Ken Thompson to design a new programming language that would resolve common criticisms of other languages while maintaining their positive characteristics. The new language was to:
    - be statically typed, scalable to large systems (as Java and C++).
    - be productive and readable, without too many mandatory keywords and repetition.
    - not require tooling, but support it well.
    - support networking and multiprocessing.
2. Go was announced in November 2009.
3. Go 1.0 was released in March 2012.
4. Go 1.5 was released in August 2015.
5. Go 1.8 was released in this year.

## Go Basic
1. [Go Install](https://golang.org/doc/install)
2. workspaces
  - bin
  - pkg
  - src
3. Go Tooling
  - fmt build run get test...
4. HelloWorld

        package main

        import (
          "fmt"
        )

        func main() {
          fmt.Println("HelloWorld!")
        }

## Go Variables And Types

### Variables
1. A variable is a piece of storage containing a value.
2. Variable declared and used example in go:

        var a int
        a = 3

        var a = 3

        a := 3

### Pointers
1. A pointer value is the address of a variable.
- pointer declared and used example in go:

        x := 1
        p := &x
        fmt.Println(*p) //"1"

        *p = 2
        fmt.Println(*p) // "2"

### Types

### Basic Data Types
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

### Composite Types
1. array

        var a [3] int
        fmt.Println(a[0])

2. slices

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

  - embedding and anonymous fields

            type Circle struct {
                Center Point
                Radius int
            }

            type Circle struct {
                Point
                Radius int
            }

## Go Methods And Interfaces

### Methods
1. Object is simply a value or variable that has methods, and a method is a function associated with a particular type.
2. Declarations

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

3. The p is called the method's receiver; A common choice is the fisrt letter of the type name, like p for Point.
4. Usage

        p := Point{1, 2}
        q := Point{4, 6}        fmt.Println(Distance(p, q)) // "5", function call        fmt.Println(p.Distance(q))  // "5", method call5. With a pointer receiver

        func (p *Point) ScaleBy(factor float64) {
            p.X *= factor
            p.Y *= factor
        }

6. Composition

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

7. Encapsulation

        type Point struct{ x, y float64 }

### Interfaces
1. An interface is an abstract type, it reveals only some of their methods. It specifies a set of methods that a concrete type must possess to be considered an instance of that interface.
2. Declarations

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

3.  Interface satisfaction
  - A type statisfies an interface if it possesses all the methods the interface requires.

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

4. Interface value
  - A value of an interface type has two components, a concrete type and a value of that type.

          var w io.Writer
          w = os.Stdout
          w = new(bytes.Buffer)
          w = nil

5. Type assertions
  - A type assertion is an operation applied to an interface value.

          x.(T)

6. Type switchs

          switch x.(type) {
          case nil:
          case int, unint:
          case bool:
          case string:
          default:
          }

## Go Concurrent Programming

### CSP(communocating sequential process)
- A model of concurrency in which values are passed between independent activities(goroutines) but variables are for the most part confined to a single activity.

#### Goroutines
1. Each concurrently executing activity is called a goroutine.
2. It created by the go statement, main function is also a goroutine.

          f() // call f(); wait for is to return
          go f() // create a new goroutine that calls f(); don't wait

3. Distinguish Threads
  - Stack is a work area where is saves the local variables of function calls that are in progress or temporarily suspended while another function is called.
  - OS thread has a fixed-size block of memory(often as large as 2MB) for its stack.
  - A goroutine starts life with a small stack, typically 2KB. Its not fixed, it grows and shrinks as needed.
  - OS threads are scheduled by the OS kernel. Every few milliseconds, a hardware timer interrupts the processor, which causes a kernel function called the scheduler to be invoked, which have a full context switch.
  - The Go runtime contains its own scheduler that known as m:n scheduling (it multiplexes m goroutines on n OS threads, is analogous to the kernel scheduler); the Go scheduler is not invoked periodically by a hardware timer, but implicitly by certain Go language constructs.GOMAXPROCS is the n in m:n scheduling. It's default value is the number of CPUs on the machine.

#### Channels
1. A channel is a communication mechanism that lets one goroutine send values to another goroutine.
2. Each channel is a conduit for values of a particular type, called the channel's element type.
3. The type of a channle whose elements have type int is written chan int.

          // create a channel
          ch := make(chan int) // ch has type 'chan int', unbuffered channel
          ch := make(chan int, 3) // ch has type 'chan int' , buffered channel with capacity 3

          // send and receive operations
          ch <- x  // a send statement
          x = <-ch // a receive expression in an assignment statement

          <-ch
          //close operations
          close(ch)

4. A send operation on an unbuffered channel blocks the sending goroutine until another goroutine executes a corresponding receive on the same channel, at which point the value is transmitted and both goroutines may continue. which produce communication causes synchronize.
5. A buffered channel has a queue of elements, a send operation on a buffered channel inserts an element at the back of the queue, and a receive operation removes an element from the front. which produce full will blocks.
6. multiplexing with select

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

### Mutual Exclusion
1. A approach is to allow many goroutines to access the variable, but only one at a time.
