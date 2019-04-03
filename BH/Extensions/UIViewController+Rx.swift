//
//  UIViewController+Rx.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 13/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var alertWithErrorString: Binder<String> {
        return Binder(base) { vc, string in
            
            if vc.presentedViewController != nil { return }
            
            let alertVC = UIAlertController(title: "Error", message: string, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(cancel)
            
            vc.present(alertVC, animated: true, completion: nil)
        }
    }
}
