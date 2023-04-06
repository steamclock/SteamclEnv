//
//  ValueObfuscator.swift
//  
//
//  Created by Brendan Lensink on 2023-03-23.
//

import Foundation
import os

struct ValueObfuscator {
    private let salt: [UInt8]

    init() {
        var seed = UInt64.random(in: 0...UInt64.max)
        let bytePtr = withUnsafePointer(to: &seed) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<UInt64>.size) {
                UnsafeBufferPointer(start: $0, count: MemoryLayout<UInt64>.size)
            }
        }

        self.salt = Array(bytePtr)
    }

    var saltOutput: String {
        """
            private static let salt: [UInt8] = \(salt)

            private static func decode(_ encoded: [UInt8]) -> String {
              String(decoding: encoded.enumerated().map { (offset, element) in
                      element ^ salt[offset % salt.count]
                  }, as: UTF8.self
              )
            }\n
        
        """
    }

    func obfuscated(key: String, value: String) -> String {
        """
            static var \(key): String {
                let encoded: [UInt8] = \(self.encode(value))
                return decode(encoded)
            }\n
        """
    }

    private func encode(_ value: String) -> [UInt8] {
        let encoded = value.enumerated().map { offset, token in
            token.asciiValue! ^ salt[offset % salt.count]
        }

        return encoded
    }
}
