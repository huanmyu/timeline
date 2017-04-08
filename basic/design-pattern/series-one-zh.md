## 访问者设计模式
1. 根据中文维基百科： 访问者模式是一种将算法与对象结构分离的软件设计模式。这个模式的基本想法如下：首先我们拥有一个由许多对象构成的对象结构，这些对象的类都拥有一个accept方法用来接受访问者对象；访问者是一个接口，它拥有一个visit方法，这个方法对访问到的对象结构中不同类型的元素作出不同的反应；在对象结构的一次访问过程中，我们遍历整个对象结构，对每一个元素都实施accept方法，在每一个元素的accept方法中回调访问者的visit方法，从而使访问者得以处理对象结构的每一个元素。我们可以针对对象结构设计不同的实在的访问者类来完成不同的操作。访问者模式使得我们可以在传统的单分派语言（如Smalltalk、Java和C++）中模拟双分派技术。对于支持多分派的语言（如CLOS），访问者模式已经内置于语言特性之中了，从而不再重要。
2. 接下来我们将通过一个简单的实例来学习这种模式，我们就用我们经常使用的鼠标和键盘来做例子，当然还有其他的一些常用的电脑输入设备，就不一一列举。首先我们设定一个输入设备的对象结构，它包含一个鼠标对象和一个键盘对象，并且他们拥有一些常用的操作，例如输入一些信息到电脑中去，再输入信息之前需要检查电脑是否安装了相应的驱动信息，以及购买他们的时候花费的价格，让我们可以有机会计算出我们所有输入设备的总价格：

          // InputDevice represent my computer input device.
          type InputDevice struct {
          	Mouse
          	Keyboard
          }

          // Mouse represent my computer mouse.
          type Mouse struct {
          	name string
          }

          func (m Mouse) input() string {
          	return "my mouse input left, right or middle."
          }

          func (m Mouse) isLoadDrive() string {
          	return "my mouse drive have load."
          }

          func (m Mouse) price() int {
          	return 20
          }

          // Keyboard represent my computer keyboard.
          type Keyboard struct {
          	name string
          }

          func (k Keyboard) input() string {
          	return "my Keyboard input a-z or 0-9 or ... ."
          }

          func (k Keyboard) isLoadDrive() string {
          	return "my keyboard drive have not load."
          }

          func (k Keyboard) price() int {
          	return 200
          }

3. 我们有了输入设备的对象结构之后，应该有一个访问者，而且这个访问者应该拥有访问对象结构包含的所有子对象的操作，只有这样访问者才能通过这些操作来访问对象结构：

          // Visitor visit my computer input device.
          type Visitor interface {
          	visitMouse(m Mouse)
          	visitKeyboard(k Keyboard)
          }

4. 现在访问者和对象结构是完全分离，这就是上面说的双分派的意思，为了使访问者可以访问对象结构，我们需要在对象结构以及对象结构的所有子对象上面定义一个操作：

          func (m Mouse) accept(v Visitor) {
          	v.visitMouse(m)
          }

          func (k Keyboard) accept(v Visitor) {
            v.visitKeyboard(k)
          }

          func (input InputDevice) Accept(v Visitor) {
            input.Mouse.accept(v)
            input.Keyboard.accept(v)
          }

5. 访问者和对象结构通过`accept`操作建立了连接。因为现在访问者只是一个接口，并没有做实际的操作，所以接下来我们定义两个实现访问者的具体的访问者对象，通过这两个具体的访问者对象，我们就可以对数据结构进行操作：

          // IsLoadDriveVisitor used to check my computer input device is or not load device.
          type IsLoadDriveVisitor string

          func (vd IsLoadDriveVisitor) visitMouse(m Mouse) {
          	fmt.Println("IsLoadDriveVisitor visitor my computer mouse")
          	fmt.Println(m.isLoadDrive())
          }

          func (vd IsLoadDriveVisitor) visitKeyboard(k Keyboard) {
          	fmt.Println("IsLoadDriveVisitor visitor my computer keyboard.")
          	fmt.Println(k.isLoadDrive())
          }

          // InputVisitor used to make my computer input device input data.
          type InputVisitor string

          func (vi InputVisitor) visitMouse(m Mouse) {
          	fmt.Println("InputVisitor visitor my computer mouse.")
          	fmt.Println(m.input())
          }

          func (vi InputVisitor) visitKeyboard(k Keyboard) {
          	fmt.Println("InputVisitor visitor my computer keyboard.")
          	fmt.Println(k.input())
          }

6. 通过上面定义的是否加载驱动访问者对象和输入信息访问者对象，我们可以分别对对象结构执行是否加载驱动和输入信息的操作，具体代码通过测试的形式展示：

          func TestIsLoadDriveVisitor(t *testing.T) {
          	input := InputDevice{}
          	var v IsLoadDriveVisitor
          	input.Accept(v)
          }

          // output:
          //  IsLoadDriveVisitor visitor my computer mouse
          //  my mouse drive have load.
          //  IsLoadDriveVisitor visitor my computer keyboard.
          //  my keyboard drive have not load.

          func TestInputVisitor(t *testing.T) {
          	input := InputDevice{}
          	var v InputVisitor
          	input.Accept(v)
          }

          // output:
          //  InputVisitor visitor my computer mouse.
          //  my mouse input left, right or middle.
          //  InputVisitor visitor my computer keyboard.
          //  my Keyboard input a-z or 0-9 or ... .

7. 通过上面定义的两个具体的访问者对象，我们会发现我们只需要定义新的访问者对象就可以实现对对象结构的新操作，当然前提是对象结构所包含的元素都有足够多的功能接口。接下来我们来定义一个计算对象结构总价格的指针访问者，通过这个访问者我们可以发现访问者模式另外一个优点，就是它通过访问对象结构的每一个元素，从而可以累积对象结构的状态：

          // PriceVisitor used to calculation my computer input device total price.
          type PriceVisitor int

          func (vp *PriceVisitor) visitMouse(m Mouse) {
          	myMousePrice := m.price()
          	*vp = *vp + (PriceVisitor)(myMousePrice)
          }

          func (vp *PriceVisitor) visitKeyboard(k Keyboard) {
          	myKeyboardPrice := k.price()
          	*vp = *vp + (PriceVisitor)(myKeyboardPrice)
          }

          // Use the PriceVisitor which should be output 220.
          func TestPriceVisitor(t *testing.T) {
          	input := InputDevice{}
          	var v PriceVisitor
          	input.Accept(&v)
          	fmt.Println(v)
          }

          // output:
          //  220

8. 通过上面2-7段的实例，我们可以总结出访问者模式的一些优缺点：
  - 很容易增加新的操作，通过实现访问者接口。
  - 访问者集中相关操作，分离无关操作
  - 增加对象结构里面新的元素很困难，需要更改所有现有的访问者
  - 累积对象结构的状态
  - 需要对象结构的元素有足够多的功能接口，破坏封装

## 额外
上面内容部分参考
- [中文维基百科](https://zh.wikipedia.org/wiki/%E8%AE%BF%E9%97%AE%E8%80%85%E6%A8%A1%E5%BC%8F)
- 设计模式-可复用面向对象软件的基础的第五章
