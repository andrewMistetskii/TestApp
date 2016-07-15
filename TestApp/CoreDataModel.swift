//
//  CoreDataModel.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/15/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

public protocol CoreDataModel {
    
    static var entityName: String { get }
    static var coreDataStack: CoreDataStack! { get }
}

extension CoreDataModel {
    
    public static var coreDataStack: CoreDataStack! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    }
    
    public static var entityName: String {
        return String(Self.self)
    }
}
