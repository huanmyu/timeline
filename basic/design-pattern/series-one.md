## Visitor pattern
1. From Wikipedia: the visitor design pattern is a way of separating an algorithm from an object structure on which it operates. A practical result of this separation is the ability to add new operations to extant object structures without modifying the structures. It is one way to follow the open/closed principle. In essence, the visitor allows adding new virtual functions to a family of classes, without modifying the classes. Instead, a visitor class is created that implements all of the appropriate specializations of the virtual function. The visitor takes the instance reference as input, and implements the goal through double dispatch.
2. We now have a example to explain this design pattern.
  - First look our object structure, which is InputDevice, it contains a mouse and a keyboard. my mouse and keyboard have some operations, such as input, isLoadDrive, price:

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

  - Now we should have a visitor to visit the InputDevice, Look the Visitor interface, it have two visit operations which corresponding my InputDevice's two element:

          // Visitor visit my computer input device.
          type Visitor interface {
          	visitMouse(m Mouse)
          	visitKeyboard(k Keyboard)
          }

  - We may found the Visitor and the InputDevice have not any contact. In order to let them have a certain connection, we add a operation to the InputDevice and all InputDevice elements:

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

  - The Visitor and the InputDevice by `accept` operation establishing a connection, now we can use Visitor to visit all InputDevice elements. But the Visitor is interface, it do nothing, so we create two concrete visitor, which is IsLoadDriveVisitor and InputVisitor :

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

  - Now we can use our IsLoadDriveVisitor and InputVisitor to operation all InputDevice elements:

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

  - Last we will define a pointer visitor, which can accumulate a state of all InputDevice elements. In out example, we use PriceVisitor to count all InputDevice elements price:

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
