//
//  CustomTextField.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/20.
//

import UIKit

enum TextFieldStatus {
    case inactive
    case focus
    case active
    case disable
    case error
    case success
}

class CustomTextField: UITextField {
    var textFieldStatus: TextFieldStatus = .success {
        didSet {
            switch self.textFieldStatus {
            case .inactive:
                self.setBottomLine(bottomLineColor: UIColor.CustomColor.gray3)
            case .focus:
                self.setBottomLine(bottomLineColor: UIColor.CustomColor.focus)
            case .active:
                self.setBottomLine(bottomLineColor: UIColor.CustomColor.gray3)
            case .disable:
                self.backgroundColor = UIColor.CustomColor.gray3
                layer.cornerRadius = 4
            case .error:
                self.setBottomLine(bottomLineColor: UIColor.CustomColor.error)
            case .success:
                self.setBottomLine(bottomLineColor: UIColor.CustomColor.success)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placeholder = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBottomLine(bottomLineColor: UIColor) {
        let bottomLine = UIView(frame: CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2))
        bottomLine.backgroundColor = bottomLineColor
        
        self.borderStyle = .none
        self.addSubview(bottomLine)
    }
}
