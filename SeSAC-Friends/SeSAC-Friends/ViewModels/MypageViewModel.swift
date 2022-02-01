//
//  MypageViewModel.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/02.
//

import UIKit

class MypageViewModel: NSObject {
    
    static let ReuseIdentifier = "Cell"
    private weak var delegate: MypageViewModelDelegate?
    private var tableViewSections = [SettingsSection]()
    
    init(delegate: MypageViewModelDelegate) {
        super.init()
        self.delegate = delegate
        configureDatasource()
    }
    
    private func configureDatasource() {
        let getInTouchSection = SettingsSection(
            cells: [
                SettingsItem(
                    createdCell: {
                        let cell = ProfileTableViewCell(style: .default, reuseIdentifier: MypageViewModel.ReuseIdentifier)
                        
                        cell.label.text = "김새싹"
                        cell.accessoryType = .disclosureIndicator
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.myInfoCellTapped() }
                ),
                SettingsItem(
                    createdCell: {
                        let cell = SettingTableViewCell(style: .default, reuseIdentifier: MypageViewModel.ReuseIdentifier)
                        
                        cell.label.text = "공지사항"
                        cell.settingImageView.image = R.image.notice()
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.noticeCellTapped() }
                ),
                SettingsItem(
                    createdCell: {
                        let cell = SettingTableViewCell(style: .default, reuseIdentifier: MypageViewModel.ReuseIdentifier)
                        
                        cell.label.text = "자주 묻는 질문"
                        cell.settingImageView.image = R.image.faq()
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.frequentlyQuestionCellTapped() }
                ),
                SettingsItem(
                    createdCell: {
                        let cell = SettingTableViewCell(style: .default, reuseIdentifier: MypageViewModel.ReuseIdentifier)
                        
                        cell.label.text = "1:1 문의"
                        cell.settingImageView.image = R.image.qna()
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.questionCellTapped() }
                ),
                SettingsItem(
                    createdCell: {
                        let cell = SettingTableViewCell(style: .default, reuseIdentifier: MypageViewModel.ReuseIdentifier)
                        
                        cell.label.text = "알림설정"
                        cell.settingImageView.image = R.image.setting_alarm()
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.noticeSetCellTapped() }
                ),
                SettingsItem(
                    createdCell: {
                        let cell = SettingTableViewCell(style: .default, reuseIdentifier: MypageViewModel.ReuseIdentifier)
                        
                        cell.label.text = "이용약관"
                        cell.settingImageView.image = R.image.permit()
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.termCellTapped() }
                )
            ]
        )
        
        tableViewSections = [getInTouchSection]
    }
}

extension MypageViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewSections[indexPath.section].cells[indexPath.row]
        return cell.createdCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableViewSections[indexPath.section].cells[indexPath.row]
        cell.action?(cell)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 130
        }
        return 70
    }
}
