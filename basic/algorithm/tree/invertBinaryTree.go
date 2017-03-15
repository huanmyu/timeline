// Invert a binary tree.
//
//      4
//    /   \
//   2     7
//  / \   / \
// 1   3 6   9
// to
//      4
//    /   \
//   7     2
//  / \   / \
// 9   6 3   1

//Definition for a binary tree node.
type TreeNode struct {
  Val int
  Left *TreeNode
  Right *TreeNode
}

func invertTree(root *TreeNode) *TreeNode {
  if root == nil {
      return nil
  }
  root.Left = invertTree(root.Left)
  root.Right = invertTree(root.Right)
  tempNode := root.Left
  root.Left = root.Right
  root.Right = tempNode
  return root
}
