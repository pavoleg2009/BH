//
//  TestingAppDelegate.swift
//  BHUnitTests
//
//  Created by Oleg Pavlichenkov on 06/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

final class TestingAppDelegate: UIResponder, UIApplicationDelegate {
    
//    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(FileManager.documentDirectory)
        return true
    }
}
