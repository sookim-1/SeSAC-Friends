//
//  NicknameInputView.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit
import SnapKit

class NicknameInputView: UIView, ViewRepresentable {
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(text: "닉네임을 입력해 주세요", labelList: .nicknameLabel)
    
    lazy var nicknameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "10자 이내로 입력"
        textField.textFieldStatus = .inactive
        textField.keyboardType = .namePhonePad
        
        return textField
    }()
    
    let doneButton: CustomButton = CustomButton(text: "다음")
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, nicknameTextField, doneButton])
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
        
        nicknameTextField.textFieldStatus = .inactive
    }
    
    func configure() {
        self.addSubview(stackView)
        doneButton.buttonStatus = .disable
    }
    
    func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    

    
}
