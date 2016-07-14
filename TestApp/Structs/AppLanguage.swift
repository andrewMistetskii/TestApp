//
//  AppLanguage.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/14/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import Foundation

public struct AppLanguage {
    
    // MARK: - Properties
    
    public private(set) var locale: NSLocale?
    
    public var languageCode: String? {
        return locale?.objectForKey(NSLocaleLanguageCode) as? String
    }
    
    public var languageName: String? {
        guard let languageCode = languageCode else { return nil }
        return locale?.displayNameForKey(NSLocaleIdentifier, value: languageCode)?.capitalizedString
    }
    
    public var localeIdentifier: String? {
        return locale?.localeIdentifier
    }
    
    // MARK: - Initializers
    
    public init(locale: NSLocale) {
        self.locale = locale
    }
    
    public init(localeIdentifier: String) {
        self.locale = NSLocale(localeIdentifier: localeIdentifier)
    }
}

