//
//  SMSAuthViewModel.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/20.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

final class SMSAuthViewModel {
    
    var phoneNumberText = BehaviorRelay<String>(value: "")
    var phoneNumberValid = BehaviorRelay<Bool>(value: false)
    var verifyID = PublishSubject<String>()
    
    func isValidPhoneNumber(text: String) -> Bool {
        let phoneNumberRegEx = "^01([0-9])-([0-9]{3,4})-([0-9]{4})$"
        let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        
        return phoneNumberTest.evaluate(with: text)
    }
    
    func smsAuth() {
        let auth = Auth.auth()
        auth.languageCode = "ko" //한국: ko, 미국: en
        
        PhoneAuthProvider.provider(auth: auth).verifyPhoneNumber("+82\(phoneNumberText.value)", uiDelegate: nil) { [weak self] (varification, error) in
            guard let self = self else { return }
            if error == nil {
                self.verifyID.onNext(varification!)
            }
            else {
                self.verifyID.onNext("에러")
            }
        }
    }
    
}
