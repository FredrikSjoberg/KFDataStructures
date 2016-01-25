//
//  Lineage.swift
//  KFDataStructures
//
//  Created by Fredrik Sjöberg on 24/09/15.
//  Copyright © 2015 Fredrik Sjoberg. All rights reserved.
//

import Foundation

public class Lineage<Element: Hashable> {
    let element: Element
    
    private weak var parent: Lineage?
    private var children: Set<Lineage>
    
    convenience init(element: Element) {
        self.init(element: element, parent: nil)
    }
    
    init(element: Element, parent: Lineage?) {
        self.element = element
        self.parent = parent
        children = Set()
    }
    
    var isLeaf: Bool {
        return children.isEmpty
    }
    
    var isOrigin: Bool {
        return parent == nil ? true : false
    }
    
    func contains(element: Element) -> Bool {
        guard node(element) != nil else {
            return false
        }
        return true
    }
    
    func link(parent: Element, child: Element) {
        guard let node = node(parent) else { return }
        node.children.insert(Lineage(element: child, parent: node))
    }
    
    /// Removes 'element' from the Lineage
    /// If 'repair' == true, transfers all children of 'element' to 'element.parent
    func unlink(element: Element, repair: Bool = false) -> Element? {
        guard let node = node(element) else { return nil }
        node.parent?.children.remove(node)
        
        if repair {
            node.parent?.children.unionInPlace(node.children)
            node.children.forEach{ $0.parent = node.parent }
        }
        else { node.children.removeAll() }
        node.parent = nil
        
        return node.element
    }
    
    /// Truncates 'element' if it is a leaf
    func prune(element: Element) -> Element? {
        guard let node = node(element) else { return nil }
        guard node.isLeaf else { return nil }
        node.parent?.children.remove(node)
        node.parent = nil
        
        return node.element
    }
    
    /// Path is from 'element' -> 'root'
    func rootPath(element: Element) -> [Element] {
        guard let node = node(element) else { return [] }
        if node.isOrigin { return [node.element] }
        
        var result: [Element] = [node.element]
        var parent = node.parent
        while parent != nil {
            result.append(parent!.element)
            parent = parent?.parent
        }
        return result
    }
    
    var leaves: [Element] {
        if isLeaf { return [element] }
        return children.flatMap{ $0.leaves }
    }
    
    private func node(element: Element) -> Lineage? {
        if self.element == element { return self }
        
        for c in children {
            if let node = c.node(element) {
                return node
            }
        }
        return nil
    }
}

extension Lineage : Hashable {
    public var hashValue: Int {
        return element.hashValue
    }
}

public func == <T: Hashable>(lhs: Lineage<T>, rhs: Lineage<T>) -> Bool {
    return lhs.element == rhs.element
}