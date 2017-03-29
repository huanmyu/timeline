//Definition for a binary tree node.
type TreeNode struct {
  Val int
  Left *TreeNode
  Right *TreeNode
}

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

// Given a binary tree
//           1
//          / \
//         2   3
//        / \
//       4   5
// Return 3, which is the length of the path [4,2,1,3] or [5,2,1,3].

func diameterOfBinaryTree(root *TreeNode) int {
    i := 0
    if root == nil {
        return i
    }

    if root.Left == nil && root.Right == nil {
        return i
    }

    i += diameterOneBinaryTree(root.Left)
    i += diameterOneBinaryTree(root.Right)

    l := diameterOfBinaryTree(root.Left)
    r := diameterOfBinaryTree(root.Right)
    if l > i && l > r {
      return l
    } else if r > i && r > l {
      return r
    } else {
      return i
    }
}

func diameterOneBinaryTree(root *TreeNode) int {
    if root == nil {
        return 0
    }

    left := diameterOneBinaryTree(root.Left)
    right := diameterOneBinaryTree(root.Right)

    if left > right {
      return left + 1
    } else {
      return right + 1
    }
}
