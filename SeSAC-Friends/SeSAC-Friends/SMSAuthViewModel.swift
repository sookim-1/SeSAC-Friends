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
    private func isValidPhoneNumber(text: String) -> Bool {
        let phoneNumberRegEx = "^01([0-9])([0-9]{3,4})([0-9]{4})$"
        let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        
        return phoneNumberTest.evaluate(with: text)
    }
}
