//
// Created by Md Sazzad Islam on 12/18/16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

public class BitReader {
    var ptr: UnsafePointer<UInt8>
    var inByte: UInt8 = 0
    var inCount = 8

    public init(data: NSData) {
        //ptr = UnsafePointer<UInt8>(data.bytes)
        ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
    }

    public func readBit() -> Bool {
        if inCount == 8 {
            inByte = ptr.pointee    // load the next byte
            inCount = 0
            ptr = ptr.successor()
        }
        let bit = inByte & 0x80  // read the next bit
        inByte <<= 1
        inCount += 1
        return bit == 0 ? false : true
    }
}
