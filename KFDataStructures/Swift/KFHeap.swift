/*
Copyright (C) 2014-2015 Bouke Haarsma

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/*
Modifications by Fredrik Sjöber
*/
//
//  KFHeap.swift
//  KnightsFee
//
//  Created by Fredrik Sjöberg on 05/03/15.
//  Copyright (c) 2015 Knights Fee. All rights reserved.
//

import Foundation

public class KFHeap<T> {
    private final var heap: [T]
    private let compare: (T, T) -> Bool
    
    public init(compare: (T, T) -> Bool) {
        self.heap = []
        self.compare = compare
    }
    
    public func push(node: T) {
        heap.append(node)
        
        if heap.count == 1 {
            return
        }
        
        var current = heap.count - 1
        while current > 0 {
            var parent = (current - 1) >> 1
            if compare(heap[parent], heap[current]) {
                break
            }
            
            (heap[parent], heap[current]) = (heap[current], heap[parent])
            current = parent
        }
    }
    
    public func pop() -> T? {
        if heap.count == 0 {
            return nil
        }
        swap(&heap[0], &heap[heap.endIndex - 1])
        let pop = heap.removeLast()
        heapify(0)
        return pop
    }
    
    public func removeAll() {
        heap.removeAll()
    }
    
    private func heapify(index: Int) {
        let left = index * 2 + 1
        let right = index * 2 + 2
        var smallest = index
        
        let count = heap.count
        
        if left < count && compare(heap[left], heap[smallest]) {
            smallest = left
        }
        if right < count && compare(heap[right], heap[smallest]) {
            smallest = right
        }
        if smallest != index {
            swap(&heap[index], &heap[smallest])
            heapify(smallest)
        }
    }
    
    public var count: Int {
        return heap.count
    }
    
    public var isEmpty: Bool {
        return heap.isEmpty
    }
}


extension KFHeap: GeneratorType {
    typealias Element = T
    public func next() -> Element? {
        return pop()
    }
}

extension KFHeap: SequenceType {
    typealias Generator = KFHeap
    public func generate() -> Generator {
        return self
    }
}