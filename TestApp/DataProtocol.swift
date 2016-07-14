//
//  DataProtocol.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/14/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import Foundation

protocol DataProtocol {
    typealias ManagedObjectType: ManagedObjectProtocol
    init(managedObject: ManagedObjectType)
}

