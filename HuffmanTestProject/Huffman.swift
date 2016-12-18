//
// Created by Md Sazzad Islam on 12/18/16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

class Huffman {
    typealias NodeIndex = Int

    struct Node {
        var count = 0
        var index: NodeIndex = -1
        var parent: NodeIndex = -1
        var left: NodeIndex = -1
        var right: NodeIndex = -1
    }

    var tree = [Node](repeating: Node(), count: 256)

    var root: NodeIndex = -1

    private func countByteFrequency(data: NSData) {
        //var ptr = UnsafePointer<UInt8>(data.bytes)
        var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
        for _ in 0..<data.length {
            let i = Int(ptr.pointee)
            tree[i].count += 1
            tree[i].index = i
            ptr = ptr.successor()
        }
    }

    struct Freq {
        var byte: UInt8 = 0
        var count = 0
    }

    func frequencyTable() -> [Freq] {
        var a = [Freq]()
        for i in 0..<256 where tree[i].count > 0 {
            a.append(Freq(byte: UInt8(i), count: tree[i].count))
        }
        return a
    }

    private func buildTree() {
        var queue = PriorityQueue<Node>(sort: { $0.count < $1.count })
        for node in tree where node.count > 0 {
            queue.enqueue(element: node)                            // 1
        }

        while queue.count > 1 {
            let node1 = queue.dequeue()!                   // 2
            let node2 = queue.dequeue()!

            var parentNode = Node()                        // 3
            parentNode.count = node1.count + node2.count
            parentNode.left = node1.index
            parentNode.right = node2.index
            parentNode.index = tree.count
            tree.append(parentNode)

            tree[node1.index].parent = parentNode.index    // 4
            tree[node2.index].parent = parentNode.index

            queue.enqueue(element: parentNode)                      // 5
        }

        let rootNode = queue.dequeue()!                  // 6
        root = rootNode.index
    }


    func compressData(data: NSData) -> NSData {
        countByteFrequency(data: data)
        buildTree()

        let writer = BitWriter()
        var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)

        for _ in 0..<data.length {
            let c = ptr.pointee
            let i = Int(c)
            traverseTree(writer: writer, nodeIndex: i, childIndex: -1)
            ptr = ptr.successor()
        }

        writer.flush()
        return writer.data
    }

    private func traverseTree(writer: BitWriter, nodeIndex h: Int, childIndex child: Int) {
        if tree[h].parent != -1 {
            traverseTree(writer: writer, nodeIndex: tree[h].parent, childIndex: h)
        }
        if child != -1 {
            if child == tree[h].left {
                writer.writeBit(bit: true)
            } else if child == tree[h].right {
                writer.writeBit(bit: false)
            }
        }
    }

    private func restoreTree(frequencyTable: [Freq]) {
        for freq in frequencyTable {
            let i = Int(freq.byte)
            tree[i].count = freq.count
            tree[i].index = i
        }
        buildTree()
    }


    func decompressData(data: NSData, frequencyTable: [Freq]) -> NSData {
        restoreTree(frequencyTable: frequencyTable)

        let reader = BitReader(data: data)
        let outData = NSMutableData()
        let byteCount = tree[root].count

        var i = 0
        while i < byteCount {
            var b = findLeafNode(reader: reader, nodeIndex: root)
            outData.append(&b, length: 1)
            i += 1
        }
        return outData
    }

    private func findLeafNode(reader: BitReader, nodeIndex: Int) -> UInt8 {
        var h = nodeIndex
        while tree[h].right != -1 {
            if reader.readBit() {
                h = tree[h].left
            } else {
                h = tree[h].right
            }
        }
        return UInt8(h)
    }
}