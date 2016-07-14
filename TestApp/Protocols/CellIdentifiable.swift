//
//  CellIdentifiable.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/13/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension CellIdentifiable {
    static var identifier: String {
        return String(self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

