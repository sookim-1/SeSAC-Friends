//
//  BirthdatInputView.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit
import SnapKit

class BirthdayInputView: UIView, ViewRepresentable {
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(text: "생년월일을 알려주세요", labelList: .birthdayLabel)

    let doneButton: CustomButton = CustomButton(text: "다음")
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, textFieldStackView, doneButton])
        stackView.axis = .vertical
        stackView.spacing = self.frame.height * 0.08
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var yearTextField = CustomTextField()
    var monthTextField = CustomTextField()
    var dayTextField = CustomTextField()
    var yearLabel = UILabel()
    var monthLabel = UILabel()
    var dayLabel = UILabel()
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yearTextField, yearLabel, monthTextField, monthLabel, dayTextField, dayLabel])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.alignment = .center
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
    
    func configure() {
        addSubview(stackView)
        
        doneButton.buttonStatus = .disable
        yearLabel.text = "년"
        monthLabel.text = "월"
        dayLabel.text = "일"
    }
    
    func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
        
        textFieldStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
}
