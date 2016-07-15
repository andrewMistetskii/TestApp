//
//  Car.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/15/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import Foundation
import CoreData

public final class Car: NSManagedObject, CoreDataModel {
    
    public var photos: [CarPhoto]?  {
        get {
            return photoSet?.array as? [CarPhoto]
        }
        
        set {
            if let value = newValue {
                photoSet = NSOrderedSet(array: value)
            }
        }
    }
    
    
    // MARK: - Initializers
    
    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: self.dynamicType.coreDataStack.managedObjectContext)
    }
    
    public convenience init() {
        let context = self.dynamicType.coreDataStack.managedObjectContext
        let name = self.dynamicType.entityName
        
        guard let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context) else {
            fatalError("Cannot create model")
        }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

// MARK: - CoreData Properties

extension Car {
    @NSManaged public var model: String?
    @NSManaged public var price: String?
    @NSManaged public var engine: String?
    @NSManaged public var transmission: String?
    @NSManaged public var condition: String?
    @NSManaged public var carDescription: String?
    @NSManaged private var photoSet: NSOrderedSet?
    //@NSManaged private var photoSet: NSSet?
}

