//
//  AppDelegate.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 30/11/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import RealmSwift

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Public properties
    
    var window: UIWindow?
    let router = AppCoordinator().anyRouter
    
    // MARK: Public methods
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        #if DEBUG
            Log(FileManager.documentDirectory)
        #endif
        
        let window = UIWindow()
        self.window = window
        router.setRoot(for: window)
    }
}
