//
//  AppDelegate.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/12/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private(set) var errorPresenter: ErrorPresenter!
    let coreDataStack = CoreDataStack()
    let localizationService = LocalizationService()

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let window = window {
            errorPresenter = ErrorPresenter(window: window)
        } else {
            errorPresenter = ErrorPresenter(application: application)
        }
        
        injectCoreDataStack()
        
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    private func injectCoreDataStack() {
        if let rootController = self.window!.rootViewController as? UINavigationController {
           var topController = rootController.topViewController as? CoreDataCompatible
                topController?.coreDataStack = coreDataStack
        }
    }
}

