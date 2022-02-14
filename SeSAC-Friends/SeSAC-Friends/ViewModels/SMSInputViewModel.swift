//
//  SMSInputViewModel.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import Foundation

import FirebaseAuth
import RxSwift
import RxCocoa

class SMSInputViewModel {
    var smsAuthText = BehaviorRelay<String>(value: "")
    var smsAuthValid = BehaviorRelay<Bool>(value: false)
    var verifyID = PublishSubject<String?>()
    
    func smsAuthInput(verifyID: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: smsAuthText.value)

        Auth.auth().signIn(with: credential) { [weak self] (success, error) in
            if error == nil {
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                  if let error = error {
                    // Handle error
                      print("에러")
                      self?.verifyID.onNext("에러")
                    return
                  }

                  // Send token to your backend via HTTPS
                  // ...
                    
                    print("\(idToken)")
                    print("성공")
                    
                    self?.verifyID.onNext(idToken)
                }
            }
            else {
                print(error.debugDescription)
                self?.verifyID.onNext("에러")
            }
        }

    }
}
