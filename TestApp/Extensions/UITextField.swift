//
//  UITextField.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/14/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

extension UITextField {
    func setPlaceholder(placeholder: String, withColor color: UIColor) {
        let placeholderAttrs = [ NSForegroundColorAttributeName : color]
        let placeholder = NSAttributedString(string: placeholder, attributes: placeholderAttrs)
        
        self.attributedPlaceholder = placeholder
    }
}
