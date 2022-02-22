//
//  EmptyView.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/21.
//

import UIKit

class EmptyView: UIView {

    var changeHobbyButton: CustomButton = CustomButton(text: "취미 변경하기")
    var refreshButton: CustomButton = CustomButton()
    private var placeHolder: UIImageView = UIImageView()
    private var descriptionLabel: CustomLabel!
    
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeHobbyButton, refreshButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 2
        
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure(text: "")
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        configure(text: text)
        setUpLayout()
    }
    
    func configure(text: String) {
        descriptionLabel = CustomLabel(lineHeight: 1.5, text: text, labelList: .descriptionLabel)
        
        addSubview(buttonStackView)
        addSubview(placeHolder)
        addSubview(descriptionLabel)
        
        placeHolder.image = UIImage(named: "emptyPlaceHolder.png")
        changeHobbyButton.buttonStatus = .fill
        let config = UIImage.SymbolConfiguration(textStyle: .title2)
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: config), for: .normal)
        refreshButton.tintColor = .CustomColor.green
        refreshButton.setTitle("", for: .normal)
        refreshButton.buttonStatus = .outline
    }
    
    func setUpLayout() {
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
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        placeHolder.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(68)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(self.snp.width).multipliedBy(0.8)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
        }
    }
}
