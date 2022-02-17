//
//  FindVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/15.
//

import UIKit

import SnapKit

final class FindVC: BaseVC {

    private var tapView: CustomTapView!
    private var changeHobbyButton: CustomButton = CustomButton(text: "취미 변경하기")
    private var refreshButton: CustomButton = CustomButton()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeHobbyButton, refreshButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 2
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpLayout()
    }
    
    override func configure() {
        title = "새싹 찾기"
        tapView = CustomTapView(frame: .zero, buttonTitle: ["주변 새싹", "받은 요청"])
        tapView.backgroundColor = .clear
        changeHobbyButton.buttonStatus = .fill
        let config = UIImage.SymbolConfiguration(textStyle: .title2)
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: config), for: .normal)
        refreshButton.tintColor = .CustomColor.green
        refreshButton.setTitle("", for: .normal)
        refreshButton.buttonStatus = .outline
        
        view.addSubview(tapView)
        view.addSubview(buttonStackView)
    }
    
    private func setUpLayout() {
        tapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(refreshButton.snp.height)
            make.top.bottom.right.equalToSuperview()
        }
        
        changeHobbyButton.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(refreshButton.snp.left).offset(-15)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(refreshButton.snp.height)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
}
