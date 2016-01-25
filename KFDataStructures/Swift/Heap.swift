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
    private var contents: [Element]
    
    var isEmpty: Bool {
        return contents.isEmpty
    }
    
    init(comparator: (Element, Element) -> Bool) {
        self.comparator = comparator
        contents = []
    }
    
    init(comparator: (Element, Element) -> Bool, contents: [Element]) {
        self.comparator = comparator
        self.contents = []
        contents.forEach{ push($0) }
    }
}

extension Heap {
    private mutating func swimHeap(var index: Int) {
        while index > 0 {
            let parent = (index - 1) >> 1
            if comparator(contents[parent], contents[index]) {
                break
            }
            
            swap(&contents[parent], &contents[index])
            
            index = parent
        }
    }
    
    private mutating func sinkHeap(index: Int) {
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
            sinkHeap(smallest)
        }
    }
}

extension Heap : QueueType {
    public mutating func push(element: Element) {
        contents.append(element)
        
        guard contents.count > 1 else { return }
        swimHeap(contents.count - 1)
    }
    
    public mutating func pop() -> Element? {
        guard !contents.isEmpty else { return nil }
        if contents.count == 1 { return contents.removeFirst() }
        
        swap(&contents[0], &contents[contents.endIndex - 1])
        let pop = contents.removeLast()
        sinkHeap(0)
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