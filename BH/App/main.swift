//
//  main.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 06/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

let testTagetName = "BHUnitTests"

let appDelegateClass: AnyClass? = NSClassFromString("\(testTagetName).TestingAppDelegate") ?? AppDelegate.self

let argc = CommandLine.argc
let argv = CommandLine.unsafeArgv

_ = UIApplicationMain(argc,
                      argv,
                      nil,
                      NSStringFromClass(appDelegateClass!))
