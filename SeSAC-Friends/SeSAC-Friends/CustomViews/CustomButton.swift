//
//  CustomButton.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/20.
//

import UIKit

enum ButtonStatus {
    case inactive
    case fill
    case outline
    case cancel
    case disable
}

class CustomButton: UIButton {
    var buttonStatus: ButtonStatus = .inactive {
        didSet {
            switch self.buttonStatus {
            case .inactive:
                self.configureToStatusWithBorder(backgroundColor: UIColor.CustomColor.white, borderColor: UIColor.CustomColor.gray4.cgColor)
                self.setTitleColor(UIColor.CustomColor.black, for: .normal)
            case .fill:
                self.configureToStatus(backgroundColor: UIColor.CustomColor.green)
                self.setTitleColor(UIColor.CustomColor.white, for: .normal)
            case .outline:
                self.configureToStatusWithBorder(backgroundColor: UIColor.CustomColor.white, borderColor: UIColor.CustomColor.green.cgColor)
                self.setTitleColor(UIColor.CustomColor.green, for: .normal)
            case .cancel:
                self.configureToStatus(backgroundColor: UIColor.CustomColor.white)
                self.setTitleColor(UIColor.CustomColor.black, for: .normal)
            case .disable:
                self.configureToStatus(backgroundColor: UIColor.CustomColor.gray6)
                self.setTitleColor(UIColor.CustomColor.gray3, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureDefault(text: "입력")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        
        configureDefault(text: text)
        self.configureToStatusWithBorder(backgroundColor: UIColor.CustomColor.white, borderColor: UIColor.CustomColor.gray4.cgColor)
        self.setTitleColor(UIColor.CustomColor.black, for: .normal)
    }
    
    private func configureDefault(text: String) {
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.CustomFont.body3R14
    }

    private func configureToStatusWithBorder(backgroundColor: UIColor, borderColor: CGColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = borderColor
    }

    private func configureToStatus(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 8
    }
    
}
