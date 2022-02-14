//
//  AlertVC.swift
//  UIExpandable-practice
//
//  Created by sookim on 2022/02/02.
//

import UIKit

import SnapKit

class AlertVC: UIViewController {

    lazy var containerView = UIView()
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "정말 탈퇴하시겠습니까?"
        lbl.font = UIFont.CustomFont.body1M16
        
        return lbl
    }()
    lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요ㅠ"
        lbl.font = UIFont.CustomFont.title4R14
        
        return lbl
    }()
    
    let cancelBtn = CustomButton(text: "취소")
    let okBtn = CustomButton(text: "확인")
    lazy var btnStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelBtn, okBtn])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    lazy var fullStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, btnStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setUpLayout()
    }
    
    func configure() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        okBtn.buttonStatus = .fill
        
        view.addSubview(containerView)
        containerView.addSubview(fullStackView)
    }
    
    func setUpLayout() {
        cancelBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(okBtn.snp.left)
        }
        okBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(220)
        }
        
        fullStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15))
        }
        
        btnStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}
