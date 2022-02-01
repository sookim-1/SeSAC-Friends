//
//  SMSAuthView.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit
import SnapKit

class SMSAuthView: UIView, ViewRepresentable {
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(lineHeight: 1.08, text: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요", labelList: .smsAuthLabel)
    
    var phoneNumberTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let doneButton: CustomButton = CustomButton(text: "인증문자받기")

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, phoneNumberTextField, doneButton])
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
        
        phoneNumberTextField.textFieldStatus = .inactive
    }
    
    func configure() {
        addSubview(stackView)
        doneButton.buttonStatus = .disable
        phoneNumberTextField.becomeFirstResponder()
    }
    
    func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
}
