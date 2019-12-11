//
//  Duration.swift
//  BHAsyncTests
//
//  Created by Oleg Pavlichenkov on 09/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

// Отдельный таргет для асинхронных тестов?? :wat?:

public func duration(_ block: () -> Void) -> TimeInterval {
    let startTime = Date()
    block()
    return Date().timeIntervalSince(startTime)
}
