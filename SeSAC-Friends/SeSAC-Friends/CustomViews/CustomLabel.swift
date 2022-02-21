//
//  CustomLabel.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import UIKit

enum LabelList {
    case smsAuthLabel
    case smsInputLabel
    case nicknameLabel
    case birthdayLabel
    case emailLabel
    case genderLabel
    case descriptionLabel
}

class CustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(lineHeight: CGFloat = 1.05, text: String, labelList: LabelList) {
        super.init(frame: .zero)
        
        configure(lineHeight: lineHeight, text: text, labelList: labelList)
    }

    private func configure(lineHeight: CGFloat = 1.05, text: String = "", labelList: LabelList = .smsAuthLabel) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = .center
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([.kern: -0.5, .paragraphStyle: paragraphStyle], range:  NSRange(location: 0, length: attributedString.length))
        
        switch labelList {
        case .smsAuthLabel:
            font = UIFont.CustomFont.displayR20
            textColor = UIColor.CustomColor.black
        case .smsInputLabel:
            font = UIFont.CustomFont.title2R16
            textColor = UIColor.CustomColor.gray7
            attributedString.addAttributes([.kern: -0.5,
                                            .paragraphStyle: paragraphStyle,.foregroundColor: UIColor.CustomColor.black, .font: UIFont.CustomFont.displayR20],
                                           range: NSRange(location: 0, length: 16))
        case .nicknameLabel:
            font = UIFont.CustomFont.displayR20
            textColor = UIColor.CustomColor.black
        case .birthdayLabel:
            font = UIFont.CustomFont.title2R16
            textColor = UIColor.CustomColor.gray7
            attributedString.addAttributes([.kern: -0.5,
                                            .paragraphStyle: paragraphStyle,.foregroundColor: UIColor.CustomColor.black, .font: UIFont.CustomFont.displayR20],
                                           range: NSRange(location: 0, length: 11))
        case .emailLabel:
            font = UIFont.CustomFont.title2R16
            textColor = UIColor.CustomColor.gray7
            attributedString.addAttributes([.kern: -0.5,
                                            .paragraphStyle: paragraphStyle,.foregroundColor: UIColor.CustomColor.black, .font: UIFont.CustomFont.displayR20],
                                           range: NSRange(location: 0, length: 11))
        case .genderLabel:
            font = UIFont.CustomFont.title2R16
            textColor = UIColor.CustomColor.gray7
            attributedString.addAttributes([.kern: -0.5,
                                            .paragraphStyle: paragraphStyle,.foregroundColor: UIColor.CustomColor.black, .font: UIFont.CustomFont.displayR20],
                                           range: NSRange(location: 0, length: 11))
        case .descriptionLabel:
            font = UIFont.CustomFont.title4R14
            textColor = UIColor.CustomColor.gray7
            attributedString.addAttributes([.kern: -0.5,
                                            .paragraphStyle: paragraphStyle,.foregroundColor: UIColor.CustomColor.black, .font: UIFont.CustomFont.displayR20],
                                           range: NSRange(location: 0, length: 17))
        }

        numberOfLines = 0
        attributedText = attributedString
    }

}
