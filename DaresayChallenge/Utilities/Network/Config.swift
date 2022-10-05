//
//  Config.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-10-05.
//

import Foundation

struct Config {
    static let urlSession: URLSession = isUITesting ? SeededURLProtocol().createURLSession() : URLSession.shared
}

private var isUITesting: Bool! {
    ProcessInfo.processInfo.arguments.contains("UI_TESTING")
}
