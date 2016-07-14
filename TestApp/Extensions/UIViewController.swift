//
//  UIViewController.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/14/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addBackButton() {
        if self.navigationController?.viewControllers.first != self {
            let backBarButton = UIBarButtonItem(image: UIImage(named: "Back"), style: .Plain, target: self, action: #selector(backButtonAction))
            backBarButton.tintColor = UIColor.whiteColor()
            navigationItem.leftBarButtonItem = backBarButton
        }
    }
    
    func backButtonAction() {
        navigationController?.popViewControllerAnimated(true)
    }
}