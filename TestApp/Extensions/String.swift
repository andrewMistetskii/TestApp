//
//  String.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/14/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

extension String {
    var localizedString: String {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let appLocalizer = appDelegate.localizationService
        
        return appLocalizer.localizedStringForKey(self)
    }
}