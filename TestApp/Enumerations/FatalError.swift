//
//  FatalError.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/14/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import Foundation

public enum FatalError {
    
    public static let noValueFound = "Unexpectedly found nil while unwrapping an Optional values"
    
    public enum CoreData {
        public static let fetchResultControllerFailtPerformRequest = "Core Data/UIKit: Fetch result controller failted to perform the fetch request."
        public static let genericError = "Core Data: generic error."
        public static let managedObjectContextFailedDeleteObject = "Core Data: Managed object context failed to delete the object."
        public static let managedObjectContextFailedExecuteFetchRequest = "Core Data: Managed object context failed to execute the fetch request."
        public static let managedObjectContextFailedSaveData = "Core Data: Managed object context failed to save data."
        public static let managedObjectModelNotContainFetchRequestWithTemplateName = "Core Data: Managed object model does not contain any fetch request with the template name."
    }
}