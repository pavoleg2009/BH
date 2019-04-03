//
//  Log.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 01/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

enum LogLevel: String {
    
    case warning = "WARNING"
    case info = "INFO"
    case critical = "CRITICAL"
}

func Log(_ value: Any, prefix: String = "+++", logLevel: LogLevel = .info) {
    
    #if DEBUG
    Swift.print("\(prefix) \(logLevel.rawValue): \(value)")
    #endif
}
