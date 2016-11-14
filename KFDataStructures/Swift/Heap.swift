//
//  Heap.swift
//  KFDataStructures
//
//  Created by Fredrik Sjöberg on 24/09/15.
//  Copyright © 2015 Fredrik Sjoberg. All rights reserved.
//

import Foundation

public struct Heap<Element: Equatable> {
    public let comparator: (Element, Element) -> Bool
    fileprivate var contents: [Element]
    
    public var isEmpty: Bool {
        return contents.isEmpty
    }
    
    public func contains(element: Element) -> Bool {
        return contents.contains(element)
    }
    
    public init(comparator: @escaping (Element, Element) -> Bool) {
        self.comparator = comparator
        contents = []
    }
    
    public init(comparator: @escaping (Element, Element) -> Bool, contents: [Element]) {
        self.comparator = comparator
        self.contents = []
        contents.forEach{ push(element: $0) }
    }
}

extension Heap: Sequence, IteratorProtocol {
    public mutating func next() -> Element? {
        return pop()
    }
}

extension Heap {
    fileprivate mutating func swimHeap(index: Int) {
        var index = index
        while index > 0 {
            let parent = (index - 1) >> 1
            if comparator(contents[parent], contents[index]) {
                break
            }
            
            swap(&contents[parent], &contents[index])
            
            index = parent
        }
    }
    
    fileprivate mutating func sinkHeap(index: Int) {
        let left = index * 2 + 1
        let right = index * 2 + 2
        var smallest = index
        
        let count = contents.count
        
        if left < count && comparator(contents[left], contents[smallest]) {
            smallest = left
        }
        if right < count && comparator(contents[right], contents[smallest]) {
            smallest = right
        }
        if smallest != index {
            swap(&contents[index], &contents[smallest])
            sinkHeap(index: smallest)
        }
    }
}

extension Heap : QueueType {
    public mutating func push(element: Element) {
        contents.append(element)
        
        guard contents.count > 1 else { return }
        swimHeap(index: contents.count - 1)
    }
    
    public mutating func pop() -> Element? {
        guard !contents.isEmpty else { return nil }
        if contents.count == 1 { return contents.removeFirst() }
        
        swap(&contents[0], &contents[contents.endIndex - 1])
        let pop = contents.removeLast()
        sinkHeap(index: 0)
        return pop
    }
    
    public func peek() -> Element? {
        return contents.first
    }
}

extension Heap : HeapType { }

extension Heap : CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { return contents.description }
    public var debugDescription: String { return contents.debugDescription }
}
