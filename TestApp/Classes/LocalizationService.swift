//
//  LocalizationService.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/14/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import Foundation

public final class LocalizationService {
    
    private enum Defaults {
        static let languageSettings = "com.testapp.language"
    }
    
    private enum NSCodingKey {
        static let currentLanguage = "com.testapp.AppLocalizer.currentLanguage"
    }
    
    // MARK: - Properties
    
    public let availableLanguages: [AppLanguage] = {
        let russion = AppLanguage(localeIdentifier: "ru-RU")
        let english = AppLanguage(localeIdentifier: "en-US")
        
        return [ russion, english ]
    }()
    
    public var currentLanguage: AppLanguage {
        didSet {
            if let locale = currentLanguage.locale {
                currentBundle = bundleForLocale(locale)
            }
        }
    }
    
    private var currentBundle = NSBundle.mainBundle()
    
    // MARK: - Initializers
    
    public init() {
        if let localeIdentifier = NSUserDefaults.standardUserDefaults().valueForKey(Defaults.languageSettings) as? String {
            let locale = NSLocale(localeIdentifier: localeIdentifier)
            currentLanguage = AppLanguage(locale: locale)
        } else {
            currentLanguage = AppLanguage(localeIdentifier: "en-US")
        }
        
        if let locale = currentLanguage.locale {
            currentBundle = bundleForLocale(locale)
        }
    }
    
    public init(defaultLocale: NSLocale) {
        currentLanguage = AppLanguage(locale: defaultLocale)
        
        if let locale = currentLanguage.locale {
            currentBundle = bundleForLocale(locale)
        }
    }
    
    // MARK: - Public Methods
    
    public func localizedStringForKey(key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: currentBundle, comment: "")
    }
    
    public func save() {
        if let locale = currentLanguage.locale?.localeIdentifier {
            NSUserDefaults.standardUserDefaults().setValue(locale, forKey: Defaults.languageSettings)
        }
    }
    
    // MARK: - Private Methods
    
    private func bundleForLocale(locale: NSLocale) -> NSBundle {
        return bundleForLocaleIdentifier(locale.localeIdentifier)
    }
    
    private func bundleForLocaleIdentifier(localeIdentifier: String) -> NSBundle {
        if let path = NSBundle.mainBundle().pathForResource(localeIdentifier, ofType: "lproj"),
            let bundle = NSBundle(path: path) {
            return bundle
        }
        
        return NSBundle.mainBundle()
    }
}

