//
//  CustomFont.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/19.
//

import UIKit

extension UIFont {
    enum CustomFont {
        static let displayR20: UIFont = { R.font.notoSansKRRegular(size: 20) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 20) }()
        static let title1M16: UIFont = { R.font.notoSansKRMedium(size: 16) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 16) }()
        static let title2R16: UIFont = { R.font.notoSansKRRegular(size: 16) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 16) }()
        static let title3M14: UIFont = { R.font.notoSansKRMedium(size: 14) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 14) }()
        static let title4R14: UIFont = { R.font.notoSansKRRegular(size: 14) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 14) }()
        static let title5M12: UIFont = { R.font.notoSansKRMedium(size: 12) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 12) }()
        static let title6R12: UIFont = { R.font.notoSansKRRegular(size: 12) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 12) }()
        static let body1M16: UIFont = { R.font.notoSansKRMedium(size: 16) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 16) }()
        static let body2R16: UIFont = { R.font.notoSansKRRegular(size: 16) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 16) }()
        static let body3R14: UIFont = { R.font.notoSansKRRegular(size: 14) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 14) }()
        static let body4R12: UIFont = { R.font.notoSansKRRegular(size: 12) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 12) }()
        static let captionR10: UIFont = { R.font.notoSansKRRegular(size: 10) ?? UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 10) }()
    }
}
