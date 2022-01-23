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

class SMSAuthViewModel {
    var phoneNumberText = BehaviorRelay<String>(value: "")
    var phoneNumberValid = BehaviorRelay<Bool>(value: false)
    var verifyID = PublishSubject<String?>()
    
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
    
    func smsAuth() {
        let auth = Auth.auth()
        auth.languageCode = "ko" //한국: ko, 미국: en
        
        PhoneAuthProvider.provider(auth: auth).verifyPhoneNumber("+82\(phoneNumberText.value)", uiDelegate: nil) { [weak self] (varification, error) in
            guard let self = self else { return }
            if error == nil {
                print("인증번호: \(varification)")
                self.verifyID.onNext(varification)
            }
            else {
                self.verifyID.onNext("에러")
                print("Phone Verification Error: \(error.debugDescription.last)")
                print("Phone 로컬라이제이션 Error: \(error?.localizedDescription)")
                if error!.localizedDescription == "We have blocked all requests from this device due to unusual activity. Try again later." {
                    print("너무 많은 요청")
                }
                
            }
        }

        
//        else {
//            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID ?? "", verificationCode: phoneNumberTextField.text ?? "")
//
//            Auth.auth().signIn(with: credential) { [weak self] (success, error) in
//                if error == nil {
//                    let currentUser = Auth.auth().currentUser
//                    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
//                      if let error = error {
//                        // Handle error
//                          print("에러")
//                        return;
//                      }
//
//                      // Send token to your backend via HTTPS
//                      // ...
//                        print("\(idToken)")
//                        print("성공")
//                    }
//                }
//                else {
//                    print(error.debugDescription)
//                }
//            }
//        }
    }
}
