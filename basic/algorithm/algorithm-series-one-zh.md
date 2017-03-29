# 数据结构和算法
1. 通过一些真实的算法题目，来不断学习计算机的基础知识。希望可以对一些常见的数据结构和算法在一大段时间之后，可以有清醒的认识和理解；而不再遇到问题时，总是抓瞎。
2. 在整个算法的学习过程中会使用Go语言来进行编码，会省略package的定义及导入。
3. 接下来会是两道关于二叉树的算法题目，主要用到的数据结构是包含树节点的结构体，用到的算法思想是递归。

## 二叉树的算法题
首先是下面题目解答中会用到的代表二叉树节点的数据结构：

    //Definition for a binary tree node.
    type TreeNode struct {
      Val int
      Left *TreeNode
      Right *TreeNode
    }

### 反转二叉树
1. 第一个算法题目是反转二叉树，也即将类似下面的二叉树的左右节点进行互换：

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

2. 解题思路是使用递归的方式把二叉树的左右节点进行互换；实现代码的时候可以把二叉树想成只有一个节点，即只包含一个左节点和一个右节点，然后把左节点与右节点进行互换；然后就可以想的更多一些，对二叉树的每一个节点都递归地把它的左节点和右节点进行互换。代码如下：

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

### 获取二叉树的最长路径长度
1. 第二个算法题目是求二叉树的最长路径长度， 题目如下：

        // Given a binary tree
        //           1
        //          / \
        //         2   3
        //        / \
        //       4   5
        // Return 3, which is the length of the path [4,2,1,3] or [5,2,1,3].

2. 解题思路是使用递归的方式获取二叉树的每个节点的最大路径长度；实现代码的时候可以把每个节点都想成一个二叉树的根节点，这样问题就可以拆分成求二叉树的最大深度的问题，每个节点的左右最大深度的和就是经过该节点的最大路径长度。当经过该节点的最大路径长度，通过递归的方式获取节点自身，节点的左节点和节点的右节点的最大值就是问题的答案。代码如下：

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

        // 获取节点的最大深度
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
