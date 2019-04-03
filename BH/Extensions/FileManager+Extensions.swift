//
//  FileManager+Ext.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 01/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

extension FileManager {
    
    public static var documentDirectory: URL {
        return self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
