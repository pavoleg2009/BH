//
//  UIViewController+Extensions.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 31/03/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func fromStoryboard<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: Bundle.main
        )
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: String(describing: self)
            ) as? T else {
                fatalError()
        }
        return vc
    }
}
