//
//  CustomColor.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/20.
//

import UIKit

extension UIColor {
    enum CustomColor {
        static let white: UIColor = { R.color.white() ?? .white }()
        static let black: UIColor = { R.color.black() ?? .black }()
        static let green: UIColor = { R.color.green() ?? .green }()
        static let whiteGreen: UIColor = { R.color.whitegreen() ?? .green.withAlphaComponent(0.7) }()
        static let yellowGreen: UIColor = { R.color.yellowgreen() ?? .green.withAlphaComponent(0.3) }()
        static let gray1: UIColor = { R.color.gray1() ?? .systemGray }()
        static let gray2: UIColor = { R.color.gray2() ?? .systemGray2 }()
        static let gray3: UIColor = { R.color.gray3() ?? .systemGray3 }()
        static let gray4: UIColor = { R.color.gray4() ?? .systemGray4 }()
        static let gray5: UIColor = { R.color.gray5() ?? .systemGray5 }()
        static let gray6: UIColor = { R.color.gray6() ?? .systemGray6 }()
        static let gray7: UIColor = { R.color.gray7() ?? .darkGray }()
        static let success: UIColor = { R.color.success() ?? .systemBlue }()
        static let error: UIColor = { R.color.error() ?? .systemRed }()
        static let focus: UIColor = { R.color.focus() ?? .label }()
    }
}
