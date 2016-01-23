//
//  KFTreeMap.swift
//  KnightsFee
//
//  Created by Fredrik Sjöberg on 02/03/15.
//  Copyright (c) 2015 Knights Fee. All rights reserved.
//

import Foundation

// MARK: - KFTreeMap
class KFTreeMap<T: AnyObject> {
    var trees: [KFTreeNode<T>] // TODO: should be a SET
    var keys: NSMutableSet = NSMutableSet()
    
    init () {
        self.trees = [KFTreeNode]()
    }
    
    func addTree(root: T) {
        if !keys.containsObject(root) {
            let tree = KFTreeNode(rootKey: root)
            trees.append(tree)
            keys.addObject(root)
        }
    }
    
    func growBranch(branch: T, withKey key: T) {
        if !keys.containsObject(key) {
            if let node = findNode(branch) {
                let leaf = KFTreeNode(parent: node, withKey: key)
                node.addChild(leaf)
                keys.addObject(key)
            }
        }
    }
    
    func pathToRoot(key: T) -> KFTreePath<T>? {
        
        if let node = findNode(key) {
            let origin = KFTreePath(key: key, next: nil, previous: nil)
            var previous = origin
            
            var parent = node.parent
            while parent != nil {
                let current = KFTreePath(key: parent!.key, next: nil, previous: previous)
                previous.next = current
                previous = current
                
                parent = parent?.parent
            }
            return origin
        }
        return nil
    }
    
    func removeKey(key: T) {
        if keys.containsObject(key) {
            if let node = findNode(key) {
                if let parent = node.parent {
                    // Child node
                    if parent.removeChild(node) {
                        keys.removeObject(key)
                    }
                }
                else {
                    // Root node
                    if node.isLeaf {
                        if let index = trees.indexOf(node) {
                            trees.removeAtIndex(index)
                            keys.removeObject(key)
                        }
                    }
                }
            }
        }
    }
    
    func leaves() -> [T] {
        var list: [T] = [T]()
        for tree in trees {
            list += tree.leaves()
        }
        return list
    }
    
    private func findNode(key: T) -> KFTreeNode<T>? {
        for tree in trees {
            
            if let node = tree.findNode(key) {
                return node
            }
        }
        return nil
    }
    
    var count: Int {
        return keys.count
    }
    
    func contains(key: T) -> Bool {
        return keys.containsObject(key)
    }
}

// MARK: - KFTreeNode
class KFTreeNode<T: AnyObject>: Equatable {
    let key: T
    weak var parent: KFTreeNode?
    var children: [KFTreeNode] = [KFTreeNode]() // TODO: should be a SET
    
    
    init(rootKey root: T) {
        self.key = root
    }
    
    init(parent: KFTreeNode, withKey key: T) {
        self.parent = parent
        self.key = key
    }
    
    var isRoot: Bool {
        guard parent == nil else {
            return false
        }
        return true
    }
    
    var isLeaf: Bool {
        return children.count == 0
    }
    
    func addChild(leaf: KFTreeNode<T>) {
        children.append(leaf)
    }
    
    func removeChild(leaf: KFTreeNode<T>) -> Bool {
        if leaf.isLeaf {
            if let index = children.indexOf(leaf) {
                children.removeAtIndex(index)
                return true
            }
        }
        return false
    }
    
    func leaves() -> [T] {
        if isLeaf {
            return [self.key]
        }
        else {
            var leaves = [T]()
            for child in children {
                leaves += child.leaves()
            }
            return leaves
        }
    }
    
    func findNode(key: T) -> KFTreeNode? {
        if self.key === key {
            return self
        }
        
        for child in children {
            if let node = child.findNode(key) {
                return node
            }
        }
        return nil
    }
    
    var count: Int {
        var total = 0
        for child in children {
            total += child.count
        }
        return total
    }
    
    func contains(key: T) -> Bool {
        guard findNode(key) != nil else {
            return false
        }
        return true
    }
}

// MARK: Equatable
func ==<T: AnyObject>(lhs: KFTreeNode<T>, rhs: KFTreeNode<T>) -> Bool {
    return (lhs.key === rhs.key)
}


// MARK: - KFTreePath
class KFTreePath<T> {
    let key: T
    var next: KFTreePath?       // FIXME: weak?
    var previous: KFTreePath?   // FIXME: weak?
    
    init(key: T, next: KFTreePath?, previous: KFTreePath?) {
        self.key = key
        self.next = next
        self.previous = previous
    }
    
    func extend(forward forward: Bool, key: T) {
        if forward {
            let current = destination
            let next = KFTreePath(key: key, next: nil, previous: current)
            current.next = next
        }
        else {
            let current = origin
            let next = KFTreePath(key: key, next: current, previous: nil)
            current.previous = next
        }
    }
    
    func calculate<U>(transform: (T, T) -> U) -> [U] {
        var result = [U]()
        var current = self
        var next = current.next
        while next !== nil {
            result.append(transform(current.key, next!.key))
            current = next!
            next = current.next
        }
        return result
    }
    
    func slice(forward forward: Bool, end: (T) -> Bool) -> KFTreePath<T>? {
        if let destination = step(forward: forward, end: end) {
            let first = KFTreePath(key: self.key, next: nil, previous: nil)
            var previous = first
            
            var current = self.stepNext(forward)
            while current != nil {
                first.extend(forward: forward, key: current!.key)
                
                if current === destination {
                    return first
                }
                
                previous = current!
                current = current!.stepNext(forward)
            }
            
            return first
            
        }
        return nil
    }
    
    func step(forward forward: Bool, end: (T) -> Bool) -> KFTreePath<T>? {
        if end(self.key) {
            return self
        }
        else {
            if let next = stepNext(forward) {
                return next.step(forward: forward, end: end)
            }
            else {
                return nil
            }
        }
    }
    
    private func stepNext(forward: Bool) -> KFTreePath? {
        if forward {
            return next
        }
        else {
            return previous
        }
    }
    
    
    var stepsToDestination: Int {
        var total = 0
        var current = next
        while current != nil {
            total++
            current = current?.next
        }
        return total
    }
    
    var stepsToOrigin: Int {
        var total = 0
        var current = previous
        while current != nil {
            total++
            current = current?.previous
        }
        return total
    }
    
    var destination: KFTreePath<T> {
        if stepsToDestination == 0 {
            return self
        }
        return self.next!.destination
    }
    
    var origin: KFTreePath<T> {
        if stepsToOrigin == 0 {
            return self
        }
        return self.previous!.origin
    }
}


// MARK: SequenceType
extension KFTreePath: SequenceType {
    typealias Generator = AnyGenerator<T>
    
    func generate() -> Generator {
        var current = self
        return anyGenerator {
            if let next = current.next {
                current = next
                return current.key
            }
            return nil
        }
    }
}

// MARK: CollectionType
extension KFTreePath: CollectionType {
    typealias Index = Int
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        var length = 1
        var current = self.next
        while current !== nil {
            length++
            current = current?.next
        }
        return length
    }
    
    subscript(i: Int) -> T {
        var current: KFTreePath! = self
        var index = 1
        while index < i {
            current = current!.next
            index++
        }
        return current.key
    }
}
