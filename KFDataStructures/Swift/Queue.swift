//
//  Queue.swift
//  KFDataStructures
//
//  Created by Fredrik Sjöberg on 23/09/15.
//  Copyright © 2015 Fredrik Sjoberg. All rights reserved.
//

import Foundation

public struct Queue<Element: Equatable> {
    fileprivate var contents:[Element]
    
    public init() {
        contents = []
    }
    
    public init(elements: [Element]) {
        contents = elements
    }
    
    public var isEmpty: Bool {
        return contents.isEmpty
    }
    
    public var count: Int {
        return contents.count
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
        guard let index = contents.index(of: element) else { return }
        contents.remove(at: index)
    }
    
    public func peek() -> Element? {
        return contents.first
    }
}

extension Queue : Collection {
    public var startIndex: Int {
        return contents.startIndex
    }
    
    public var endIndex: Int {
        return contents.endIndex
    }
    
    public subscript(index: Int) -> Element {
        return contents[index]
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
   /* /// Replaces the given index with its successor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    public func formIndex(after i: inout Self.Index)*/
}

extension Queue : ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        contents = elements
    }
}

extension Queue : CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { return contents.description }
    public var debugDescription: String { return contents.debugDescription }
}
