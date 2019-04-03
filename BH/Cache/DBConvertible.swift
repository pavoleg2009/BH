//
//  DBConvertible.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 05/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RealmSwift

protocol DatabaseConvertible {
    
    associatedtype DatabaseType: DomainConvertible & Object
    
    func databaseModel() -> DatabaseType
}

protocol DomainConvertible {
    
    associatedtype DomainType
    
    func domainModel() -> DomainType
}
