//
//  MypageDelegate.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/02.
//

import Foundation

protocol MypageViewModelDelegate: AnyObject {
    func myInfoCellTapped()
    func noticeCellTapped()
    func frequentlyQuestionCellTapped()
    func questionCellTapped()
    func noticeSetCellTapped()
    func termCellTapped()
}
