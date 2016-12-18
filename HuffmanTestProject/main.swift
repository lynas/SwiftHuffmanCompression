//
//  main.swift
//  HuffmanTestProject
//
//  Created by Md Sazzad Islam on 12/18/16.
//  Copyright (c) 2016 Md Sazzad Islam. All rights reserved.
//

import Foundation

let s1 = "so much words wow many compression"
if let originalData = s1.data(using: String.Encoding.utf8) {
    let huffman1 = Huffman()
    let compressedData = huffman1.compressData(data: originalData as NSData)
    print(compressedData.length)
    print(compressedData)


    let frequencyTable = huffman1.frequencyTable()

    let huffman2 = Huffman()
    let decompressedData = huffman2.decompressData(data: compressedData, frequencyTable: frequencyTable)

    let s2 = String(data: decompressedData as Data, encoding: String.Encoding.utf8)!

    print(s2)
}