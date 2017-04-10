// 名企笔试：美团点评2012研发工程师笔试卷（k链表翻转）
// 2017-03-30 算法爱好者
//
// 题目描述：
//
// 给出一个链表和一个数k，比如链表
// 1→2→3→4→5→6
//
// 当k=2，则翻转后链表为
// 2→1→4→3→6→5
//
// 当k=3，则翻转后链表为
// 3→2→1→6→5→4
//
// 当k=4，翻转后链表为
// 4→3→2→1→5→6
//
// 请用程序实现该算法。

type ListNode struct {
  Val int
  Next  *ListNode
}

var Head ListNode

func createList()  {
  NextNode := ListNode {
    Val: 2,
  }

  Head = ListNode {
    val : 1,
    Next : &NextNode
  }

  NNextNode := ListNode {
    Val: 3,
  }

  NextNode.Next = &NNextNode
}
