//
//  KFQueue.swift
//  KnightsFee
//
//  Created by Fredrik Sjöberg on 04/03/15.
//  Copyright (c) 2015 Knights Fee. All rights reserved.
//

import Foundation

class KFQueue<T: AnyObject> {
    // http://nshipster.com/swift-collection-protocols/
    
    private var head: KFQueueNode<T>!
    private var tail: KFQueueNode<T>!
    private var internalCount: Int = 0
    
    init() {
        
    }
    
    init(array: Array<T>) {
        for t in array {
            enqueue(t)
        }
    }
    
    func enqueue(key: T) {
        // Check if the queue is empty
        if isEmpty() {
            head = KFQueueNode(key: key)
            tail = head
        }
        else {
            let newItem = KFQueueNode(key: key)
            
            tail.nextItem = newItem
            newItem.previousItem = tail
            tail = newItem
        }
        internalCount++
    }
    
    func dequeue() -> T? {
        if isEmpty() {
            return nil
        }
        
        let current = head
        
        // Queue the next item
        if let next = current?.nextItem {
            head = next
        }
        else {
            head = nil
            tail = nil
        }
        internalCount--
        
        return current?.key
    }
    
    func peek() -> T? {
        return head?.key
    }
    
    func isEmpty() -> Bool {
        return internalCount == 0
    }
    
    func count() -> Int {
        return internalCount
    }
    
    private func node(key: T) -> KFQueueNode<T>? {
        if isEmpty() {
            return nil
        }
        
        var current = head
        if current.key === key {
            return current
        }
        
        while current != nil {
            if current.key === key {
                return current
            }
            current = current.nextItem
        }
        return nil
    }
}

extension KFQueue: SequenceType {
    func generate() -> KFQueueGenerator<T> {
        return KFQueueGenerator(head: head)
    }
}

struct KFQueueGenerator<T>: GeneratorType {
    var current: KFQueueNode<T>
    
    init(head: KFQueueNode<T>) {
        current = head
    }
    
    mutating func next() -> T? {
        current = current.nextItem!
        return current.key
    }
}

// MARK: - KFDynamicQueue
class KFDynamicQueue<T: AnyObject>: KFQueue<T> {
    var keys: NSMutableSet = NSMutableSet()
    
    override init(array: Array<T>) {
        super.init(array: array)
    }
    
    override func enqueue(key: T) {
        if (!contains(key)) {
            super.enqueue(key)
            keys.addObject(key)
        }
    }
    
    override func dequeue() -> T? {
        if let key = super.dequeue() {
            keys.removeObject(key)
            return key
        }
        return nil
    }
    
    func invalidate(key: T) {
        if let node = node(key) {
            if node !== head {
                let previous = node.previousItem
                let next = node.nextItem
                
                previous?.nextItem = next
                next?.previousItem = previous
                
                head.previousItem = node
                node.nextItem = head
                
                head = node
            }
            
            dequeue()
        }
    }
    
    func contains(key: T) -> Bool {
        return keys.containsObject(key)
    }
}


// MARK: - KFQueueNode
class KFQueueNode<T> {
    let key: T
    var previousItem: KFQueueNode?
    var nextItem: KFQueueNode?
    
    init(key: T) {
        self.key = key
    }
}

