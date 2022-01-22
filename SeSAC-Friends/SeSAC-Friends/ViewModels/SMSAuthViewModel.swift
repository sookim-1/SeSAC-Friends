//
//  SMSAuthViewModel.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/20.
//

import Foundation
import RxSwift
import RxCocoa

class SMSAuthViewModel {
    func isValidPhoneNumber(text: String) -> Bool {
        let phoneNumberRegEx = "^01([0-9])([0-9]{3,4})([0-9]{4})$"
        let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        
        return phoneNumberTest.evaluate(with: text)
    }
    
    func convertHypen(text: String) -> String {
        if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive)
        {
            let modString = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(text.startIndex..., in: text), withTemplate: "$1-$2-$3")
            
            return modString
        }
        return text
    }
}
