//
//  CarPhoto.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/15/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import Foundation
import CoreData

public final class CarPhoto: NSManagedObject, CoreDataModel {
    
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

extension CarPhoto {
    @NSManaged public var photoData: NSData?
}
