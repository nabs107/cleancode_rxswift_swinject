//
//  UIViewController+Extensions.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import UIKit
import Swinject

extension UIViewController {
    
    var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    var container: Container {
        appDelegate.container
    }
    
}
