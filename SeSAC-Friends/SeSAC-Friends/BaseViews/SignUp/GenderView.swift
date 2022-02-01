//
//  GenderView.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit
import SnapKit

class GenderView: UIView, ViewRepresentable {
    lazy var authDescriptionLabel: CustomLabel = CustomLabel(lineHeight: 1.5, text: "성별을 선택해 주세요\n새싹 찾기 기능을 이용하기 위해서 필요해요!", labelList: .genderLabel)
    
    lazy var manView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.CustomColor.gray3.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    lazy var womanView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.CustomColor.gray3.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    let manImageView = UIImageView(image: UIImage(named: "man"))
    let manLabel = UILabel()
    let womanImageView = UIImageView(image: UIImage(named: "woman"))
    let womanLabel = UILabel()

    
    let doneButton: CustomButton = CustomButton(text: "다음")
    
    lazy var manStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [manView, womanView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authDescriptionLabel, manStackView, doneButton])
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
    
    func configure() {
        addSubview(stackView)
        doneButton.buttonStatus = .disable
        
        manLabel.text = "남자"
        womanLabel.text = "여자"
        manView.addSubview(manImageView)
        manView.addSubview(manLabel)
        womanView.addSubview(womanImageView)
        womanView.addSubview(womanLabel)
    }
    
    func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
        
        manStackView.snp.makeConstraints { make in
            make.size.equalTo(120)
        }
        
        manImageView.snp.makeConstraints { make in
            make.centerX.equalTo(manView.snp.centerX)
            make.top.equalTo(manView.snp.top)
            make.width.equalTo(manImageView.snp.height).multipliedBy(1.0 / 1.0)
            make.bottom.equalTo(manLabel.snp.top)
        }
    
        manLabel.snp.makeConstraints { make in
            make.centerX.equalTo(manView.snp.centerX)
            make.bottom.equalTo(manView.snp.bottom)
        }
        
        womanImageView.snp.makeConstraints { make in
            make.centerX.equalTo(womanView.snp.centerX)
            make.top.equalTo(womanView.snp.top)
            make.width.equalTo(womanImageView.snp.height).multipliedBy(1.0 / 1.0)
            make.bottom.equalTo(womanLabel.snp.top)
        }
    
        womanLabel.snp.makeConstraints { make in
            make.centerX.equalTo(womanView.snp.centerX)
            make.bottom.equalTo(womanView.snp.bottom)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
}
