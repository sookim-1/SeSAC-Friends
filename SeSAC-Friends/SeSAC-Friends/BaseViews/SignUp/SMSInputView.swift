//
//  SMSInputView.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit
import SnapKit

class SMSInputView: UIView, ViewRepresentable {

    lazy var authDescriptionLabel: CustomLabel = CustomLabel(lineHeight: 1.5, text: "인증번호가 문자로 전송되었어요\n(최대 소모 20초)", labelList: .smsInputLabel)
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [smsAuthTextField, sendButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var smsAuthTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "인증번호 입력"
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        
        return textField
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.CustomColor.green
        return label
    }()
    
    let sendButton: CustomButton = CustomButton(text: "재전송")
    let doneButton: CustomButton = CustomButton(text: "인증하고 시작하기")
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, textFieldStackView, doneButton])
        stackView.axis = .vertical
        stackView.spacing = self.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        smsAuthTextField.textFieldStatus = .inactive
    }
    
    func configure() {
        addSubview(stackView)
        sendButton.buttonStatus = .fill
        doneButton.buttonStatus = .disable
        
        smsAuthTextField.rightView = timerLabel
        smsAuthTextField.rightViewMode = .always
    }
    
    func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
        
        smsAuthTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
    

}
