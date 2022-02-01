//
//  MypageModel.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/02.
//

import UIKit

struct SettingsSection {
    var cells: [SettingsItem]
}

struct SettingsItem {
    var createdCell: () -> UITableViewCell
    var action: ((SettingsItem) -> Void)?
}

