//
// Created by Md Sazzad Islam on 12/18/16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

public class BitWriter {
    public var data = NSMutableData()
    var outByte: UInt8 = 0
    var outCount = 0

    public func writeBit(bit: Bool) {
        if outCount == 8 {
            data.append(&outByte, length: 1)
            outCount = 0
        }
        outByte = (outByte << 1) | (bit ? 1 : 0)
        outCount += 1
    }

    public func flush() {
        if outCount > 0 {
            if outCount < 8 {
                let diff = UInt8(8 - outCount)
                outByte <<= diff
            }
            data.append(&outByte, length: 1)
        }
    }
}