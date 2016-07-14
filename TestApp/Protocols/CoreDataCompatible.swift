//
//  CoreDataCompatible.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/14/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit
import CoreData

public protocol CoreDataCompatible {
    var coreDataStack: CoreDataStack! { get set }
}
