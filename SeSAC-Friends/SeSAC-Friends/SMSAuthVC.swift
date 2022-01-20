//
//  ViewController.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/17.
//

import UIKit
import FirebaseAuth
import SnapKit
import RxSwift

class SMSAuthVC: UIViewController {

    lazy var doneButton: CustomButton = {
        let button = CustomButton()
        button.buttonStatus = .disable
        button.isEnabled = false
        button.setTitle("인증문자받기", for: .normal)
        
        return button
    }()
    lazy var phoneNumberTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        textField.textFieldStatus = .inactive
        textField.backgroundColor = .systemRed
        
        return textField
    }()
    lazy var authDescriptionLabel: UILabel = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .center
        
        let label = UILabel()
        label.font = UIFont.CustomFont.displayR20
        label.attributedText = NSMutableAttributedString(string: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요", attributes: [.kern: -0.5, .paragraphStyle: paragraphStyle])
        label.numberOfLines = 0

        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, phoneNumberTextField, doneButton])
        stackView.axis = .vertical
        stackView.spacing = view.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var viewModel = SMSAuthViewModel()
    let disposeBag = DisposeBag()

    private var verifyID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpConstraints()
        doneButton.addTarget(self, action: #selector(handleDoneBtn(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        phoneNumberTextField.textFieldStatus = .inactive
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        [doneButton, phoneNumberTextField, authDescriptionLabel].forEach { [weak self] subView in
            guard let self = self else { return }
            self.view.addSubview(subView)
        }
        view.addSubview(stackView)
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
    }

    @objc func handleDoneBtn(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTextField.text ?? "", uiDelegate: nil) { (varification, error) in
            if error == nil {
                self.verifyID = varification
            }
            else {
                print("Phone Verification Error: \(error.debugDescription)")
            }
        }
    }

}

