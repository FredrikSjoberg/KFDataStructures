//
//  BinarySearchTree.swift
//  KFDataStructures
//
//  Created by Fredrik Sjöberg on 14/11/16.
//  Copyright © 2016 Fredrik Sjoberg. All rights reserved.
//

import Foundation

//: Playground - noun: a place where people can play

import UIKit


public class BinarySearchTree<T: Comparable> {
    fileprivate var root: BinarySearchNode<T>?
    
    public init(value: T) {
        self.root = BinarySearchNode(value: value)
    }
}

public enum BinarySearchTreeTraversalOrder {
    //In-order (or depth-first): first look at the left child of a node, then at the node itself, and finally at its right child.
    case inOrder
    
    //Pre-order: first look at a node, then its left and right children.
    case preOrder
    
    //Post-order: first look at the left and right children and process the node itself last.
    case postOrder
}

/// Find Items
extension BinarySearchTree {
    
    /// Finds the "highest" node with specified value
    /// Performance: O(h) where h is height of tree
    public func contains(value: T) -> Bool {
        guard let r = root else { return false }
        let t = r.node(for: value)
        return t != nil
    }
    
    /// Finds the minimum value
    /// Performance: O(h)
    public func min() -> T? {
        return root?.min().value
    }
    
    /// Finds the maximum value
    /// Performance: O(h)
    public func max() -> T? {
        return root?.max().value
    }
    
    
    public func traverse(order: BinarySearchTreeTraversalOrder, callback: (T) -> Void) {
        root?.traverse(order: order, callback: callback)
    }
}

/// Inserting items
extension BinarySearchTree {
    public func insert(value: T) {
        guard let root = root else {
            self.root = BinarySearchNode(value: value)
            return
        }
        root.insert(value: value)
    }
}

/// Removing items
extension BinarySearchTree {
    public func remove(value: T) {
        guard let root = root else { return }
        guard let present = root.node(for: value) else { return }
        guard let replacement = present.remove() else { return }
        if present === root {
            self.root = replacement
        }
        
    }
}

/// Node
fileprivate class BinarySearchNode<T: Comparable> {
    fileprivate(set) public var value: T
    
    fileprivate(set) var parent: BinarySearchNode?
    fileprivate(set) var left: BinarySearchNode?
    fileprivate(set) var right: BinarySearchNode?
    
    public init(value: T) {
        self.value = value
    }
}

/// Find items
extension BinarySearchNode {
    
    fileprivate func min() -> BinarySearchNode {
        return left?.min() ?? self
    }
    
    fileprivate func max() -> BinarySearchNode {
        return right?.max() ?? self
    }
    
    fileprivate func node(for value: T) -> BinarySearchNode? {
        if value < self.value {
            return left?.node(for: value)
        }
        else if value > self.value {
            return right?.node(for: value)
        }
        else {
            return self
        }
    }
    
    fileprivate var isLeftChild: Bool {
        return parent?.left === self
    }
    
    fileprivate var isRightChild: Bool {
        return parent?.right === self
    }
    
    fileprivate func traverse(order: BinarySearchTreeTraversalOrder, callback: (T) -> Void) {
        switch order {
        case .inOrder:
            traverse(inOrder: callback)
        case .preOrder:
            traverse(preOrder: callback)
        case .postOrder:
            traverse(postOrder: callback)
        }
    }
    
    fileprivate func traverse(inOrder callback: (T) -> Void) {
        left?.traverse(inOrder: callback)
        callback(value)
        right?.traverse(inOrder: callback)
    }
    
    fileprivate func traverse(preOrder callback: (T) -> Void) {
        callback(value)
        left?.traverse(preOrder: callback)
        right?.traverse(preOrder: callback)
    }
    
    fileprivate func traverse(postOrder callback: (T) -> Void) {
        left?.traverse(postOrder: callback)
        right?.traverse(postOrder: callback)
        callback(value)
    }
}

/// Inserting items
extension BinarySearchNode {
    fileprivate func insert(value: T) {
        if value < self.value {
            if let left = left {
                left.insert(value: value)
            } else {
                left = BinarySearchNode(value: value)
                left?.parent = self
            }
        } else {
            if let right = right {
                right.insert(value: value)
            } else {
                right = BinarySearchNode(value: value)
                right?.parent = self
            }
        }
    }
}

/// Deleting items
extension BinarySearchNode {
    /// Returns the node that replaces the removed one (or nil if removed was leaf node)
    fileprivate func remove() -> BinarySearchNode? {
        let replacement = findReplacement()
        if let parent = parent {
            if isLeftChild {
                parent.left = replacement
            }
            else {
                parent.right = replacement
            }
        }
        replacement?.parent = parent
        
        parent = nil
        left = nil
        right = nil
        
        return replacement
    }
    
    fileprivate func findReplacement() -> BinarySearchNode? {
        if let left = left {
            if let right = right {
                // This node has two children. It must be replaced by the smallest
                // child that is larger than this node's value, which is the leftmost
                // descendent of the right child.
                let successor = right.min()
                
                // If this in-order successor has a right child of its own (it cannot
                // have a left child by definition), then that must take its place.
                let _ = successor.remove()
                
                // Connect our left child with the new node.
                successor.left = left
                //left.parent = successor
                
                // Connect our right child with the new node. If the right child does
                // not have any left children of its own, then the in-order successor
                // *is* the right child.
                if right !== successor {
                    successor.right = right
                    //right.parent = successor
                } else {
                    successor.right = nil
                }
                
                // And finally, connect the successor node to our parent.
                return successor
            }
            else {
                return left
            }
        }
        else {
            return right
        }
    }
}
