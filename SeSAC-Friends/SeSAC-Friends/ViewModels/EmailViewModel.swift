//
//  EmailViewModel.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class EmailViewModel {
    var emailText = BehaviorRelay<String>(value: "")
    var emailValid = BehaviorRelay<Bool>(value: false)
    
    func isValidEmail(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return emailTest.evaluate(with: text)
    }
}
