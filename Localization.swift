//
//  Localization.swift
//  LocalizationDemo
//
//  Created by Dhawal Bera on 19/10/20.
//  Copyright © 2020 Dhawal Bera. All rights reserved.
//

import Foundation
import UIKit

private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {

     override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {

    static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()

    static func set(language: Language) {
        Bundle.once

        let isLanguageRTL = Locale.characterDirection(forLanguage: language.code) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight

        UserDefaults.standard.set(isLanguageRTL,   forKey: "AppleTe  zxtDirection")
        UserDefaults.standard.set(isLanguageRTL,   forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        guard let path = Bundle.main.path(forResource: language.code, ofType: "lproj") else {
            print("Failed to get a bundle path.")
            return
        }
        
        DispatchQueue.global().async {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        
    }
}


enum Language: Equatable {
    case english(English)
    case chinese(Chinese)
    case korean
    case japanese
    case indian(Indian)

    enum English {
        case us
        case uk
        case australian
        case canadian
    }

    enum Chinese {
        case simplified
        case traditional
        case hongKong
    }
    
    enum Indian {
        case hindi
        case english
    }
}

extension Language {

    public var code: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "en"
            case .uk:                return "en-GB"
            case .australian:        return "en-AU"
            case .canadian:          return "en-CA"
            }

        case .chinese(let chinese):
            switch chinese {
            case .simplified:       return "zh-Hans"
            case .traditional:      return "zh-Hant"
            case .hongKong:         return "zh-HK"
            }

        case .korean:               return "ko"
        case .japanese:             return "ja"
        case .indian(let indian):
            switch indian {
            case .hindi:
                return "hi"
            case .english:
                return "en-IN"
            }
            
        }
    }

    var name: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "English"
            case .uk:                return "English (UK)"
            case .australian:        return "English (Australia)"
            case .canadian:          return "English (Canada)"
            
            }

        case .chinese(let chinese):
            switch chinese {
            case .simplified:       return "简体中文"
            case .traditional:      return "繁體中文"
            case .hongKong:         return "繁體中文 (香港)"
            }

        case .korean:               return "한국어"
        case .japanese:             return "日本語"
        case .indian(let indian):
            switch indian {
            case .hindi:
                return "Hindi (India)"
            case .english:
                return "English (India)"
            }
        }
    }
}

extension Language {

    init?(languageCode: String?) {
        guard let languageCode = languageCode else { return nil }
        switch languageCode {
        case "en", "en-US":     self = .english(.us)
        case "en-GB":           self = .english(.uk)
        case "en-AU":           self = .english(.australian)
        case "en-CA":           self = .english(.canadian)

        case "zh-Hans":         self = .chinese(.simplified)
        case "zh-Hant":         self = .chinese(.traditional)
        case "zh-HK":           self = .chinese(.hongKong)

        case "ko":              self = .korean
        case "ja":              self = .japanese
            
        case "hi":              self = .indian(.hindi)
        case "en-IN":           self = .indian(.english)
        default:                return nil
        }
    }
}
