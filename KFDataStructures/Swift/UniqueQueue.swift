//
//  UniqueQueue.swift
//  KFDataStructures
//
//  Created by Fredrik Sjöberg on 24/09/15.
//  Copyright © 2015 Fredrik Sjoberg. All rights reserved.
//

import Foundation

public struct UniqueQueue<Element: Hashable> {
    fileprivate var contents:[Element]
    fileprivate var uniques: Set<Element>
    
    
    public init() {
        contents = []
        uniques = Set()
    }
}

extension UniqueQueue : DynamicQueueType {
    public mutating func push(element: Element) {
        if !uniques.contains(element) {
            contents.append(element)
            uniques.insert(element)
        }
    }
    
    public mutating func pop() -> Element? {
        guard !contents.isEmpty else { return nil }
        let element = contents.removeFirst() // NOTE: removeFirst() is O(self.count), we need O(1). Doubly-Linked-List?
        uniques.remove(element)
        return element
    }
    
    public mutating func invalidate(element: Element) {
        guard !contents.isEmpty else { return }
        guard let index = contents.index(of: element) else { return }
        contents.remove(at: index)
        uniques.remove(element)
    }
    
    public func peek() -> Element? {
        return contents.first
    }
}


extension UniqueQueue : Collection {
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
}


extension UniqueQueue : ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        uniques = Set(elements)
        contents = []
        contents += elements.filter{ uniques.contains($0) }
    }
}

extension UniqueQueue : CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { return contents.description }
    public var debugDescription: String { return contents.debugDescription }
}
