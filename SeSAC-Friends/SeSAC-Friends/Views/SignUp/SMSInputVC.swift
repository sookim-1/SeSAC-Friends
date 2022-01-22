//
//  SMSInputVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import UIKit
import SnapKit

class SMSInputVC: UIViewController {
    var limitTime: Int = 60
    
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(lineHeight: 1.5, text: "인증번호가 문자로 전송되었어요\n(최대 소모 20초)", labelList: .smsInputLabel)
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [phoneNumberTextField, sendButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var phoneNumberTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "인증번호 입력"
        textField.textFieldStatus = .inactive
        textField.keyboardType = .numberPad
        
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
        stackView.spacing = view.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        phoneNumberTextField.rightView = timerLabel
        phoneNumberTextField.rightViewMode = .always
        getSetTime()
        configure()
        setUpConstraints()
        setUpNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        phoneNumberTextField.textFieldStatus = .inactive
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")

        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        sendButton.buttonStatus = .fill
        doneButton.buttonStatus = .disable
        view.addSubview(stackView)
        doneButton.addTarget(self, action: #selector(authComplete), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
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
    
    @objc func authComplete() {
        navigationController?.pushViewController(NicknameInputVC(), animated: true)
    }
    
    @objc func getSetTime() {
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
    func secToTime(sec: Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            timerLabel.text = String(minute) + ":" + "0" + String(second)
        } else {
            timerLabel.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        }
        else if limitTime == 0 {
            timerLabel.isHidden = true
        }
    }
}
