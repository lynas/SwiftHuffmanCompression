//
// Created by Md Sazzad Islam on 12/18/16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

public struct PriorityQueue<T> {
    fileprivate var heap: Heap<T>

    public init(sort: @escaping (T, T) -> Bool) {
        heap = Heap(sort: sort)
    }

    public var isEmpty: Bool {
        return heap.isEmpty
    }

    public var count: Int {
        return heap.count
    }

    public func peek() -> T? {
        return heap.peek()
    }

    public mutating func enqueue(element: T) {
        heap.insert(element)
    }

    public mutating func dequeue() -> T? {
        return heap.remove()
    }

    public mutating func changePriority(index i: Int, value: T) {
        return heap.replace(index: i, value: value)
    }
}
