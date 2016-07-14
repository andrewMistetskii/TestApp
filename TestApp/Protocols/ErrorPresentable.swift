//
//  ErrorPresentable.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/13/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import Foundation
import UIKit

public protocol ErrorPresentable {
    
}

public extension ErrorPresentable {
    
    var errorPresenter: ErrorPresenter {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).errorPresenter
    }
}
