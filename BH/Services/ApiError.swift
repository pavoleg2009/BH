//
//  ApiError.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 12/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

enum ApiError: Error {
    
    case unknown
    case nsError(NSError)
    
    // MARK: Public methods
    
    func errorMessage() -> String {
        
        switch self {
        
        case .unknown:
            return "Unknown Errror"
            
        case .nsError(let nsError):
            return nsError.localizedDescription
        }
    }
}
