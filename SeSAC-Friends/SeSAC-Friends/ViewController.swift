//
//  ViewController.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/17.
//

import UIKit
import FirebaseAuth
import SnapKit

class ViewController: UIViewController {

    var doneButton = CustomButton()
    var sendButton = CustomButton()
    var varificationCodeTextField = UITextField()
    var phoneNumberTextField = UITextField()
    
    private var verifyID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configure()
        doneButton.buttonStatus = .inactive
        sendButton.buttonStatus = .disable
        doneButton.addTarget(self, action: #selector(handleDoneBtn(_:)), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(handleSendVarification(_:)), for: .touchUpInside)
    }

    @objc func handleDoneBtn(_ sender: Any) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID ?? "", verificationCode: varificationCodeTextField.text ?? "")
        
        Auth.auth().signIn(with: credential) { (success, error) in
            if error == nil {
                print(success ?? "")
                print("인증완료")
            }
            else {
                print(error.debugDescription)
            }
        }
    }

    @objc func handleSendVarification(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTextField.text ?? "", uiDelegate: nil) { (varification, error) in
            if error == nil {
                print("인증번호: \(varification)")
                self.verifyID = varification
            }
            else {
                print("Phone Verification Error: \(error.debugDescription)")
            }
        }
    }
    
    private func configure() {
        [doneButton, sendButton, varificationCodeTextField, phoneNumberTextField].forEach { value in
            value.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(value)
        }
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .systemGreen
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = .systemBlue
        varificationCodeTextField.placeholder = "인증번호텍스트필드"
        phoneNumberTextField.placeholder = "전화번호텍스트필드"
        
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 150),
            doneButton.widthAnchor.constraint(equalToConstant: 150),
            
            sendButton.heightAnchor.constraint(equalToConstant: 150),
            sendButton.widthAnchor.constraint(equalToConstant: 150),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 10),
            
            varificationCodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            varificationCodeTextField.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 10),
            
            phoneNumberTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneNumberTextField.topAnchor.constraint(equalTo: varificationCodeTextField.bottomAnchor, constant: 10)
        ])
    }
    
}

