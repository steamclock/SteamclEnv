//
//  CISource.swift
//  
//
//  Created by Brendan Lensink on 2023-04-06.
//

import ArgumentParser
import Foundation

enum CISource: String, ExpressibleByArgument {
    case bitrise
    case xcode

    var name: String {
        switch self {
        case .bitrise: return "Bitrise"
        case .xcode: return "Xcode Cloud"
        }
    }
}
