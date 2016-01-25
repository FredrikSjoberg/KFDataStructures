//
//  Queue.swift
//  KFDataStructures
//
//  Created by Fredrik Sjöberg on 23/09/15.
//  Copyright © 2015 Fredrik Sjoberg. All rights reserved.
//

import Foundation

public struct Queue<Element: Equatable> {
    private var contents:[Element]
    
    init() {
        contents = []
    }
    
    init(elements: [Element]) {
        contents = elements
    }
}

extension Queue : DynamicQueueType {
    public mutating func push(element: Element) {
        contents.append(element)
    }
    
    public mutating func pop() -> Element? {
        guard !contents.isEmpty else { return nil }
        return contents.removeFirst() // NOTE: removeFirst() is O(self.count), we need O(1). Doubly-Linked-List?
    }
    
    public mutating func invalidate(element: Element) {
        guard !contents.isEmpty else { return }
        guard let index = contents.indexOf(element) else { return }
        contents.removeAtIndex(index)
    }
    
    public func peek() -> Element? {
        return contents.first
    }
}

extension Queue : CollectionType, Indexable, SequenceType {
    public var startIndex: Int {
        return contents.startIndex
    }
    
    public var endIndex: Int {
        return contents.endIndex
    }
    
    public subscript(index: Int) -> Element {
        return contents[index]
    }
}

extension Queue : ArrayLiteralConvertible {
    public init(arrayLiteral elements: Element...) {
        contents = elements
    }
}

extension Queue : CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { return contents.description }
    public var debugDescription: String { return contents.debugDescription }
}