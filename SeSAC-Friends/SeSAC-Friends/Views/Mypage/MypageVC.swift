//
//  MypageVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit

final class MypageVC: UITableViewController {

    private let mainView = MypageView()
    private var viewModel: MypageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = MypageViewModel(delegate: self)
        
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "내정보"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        title = ""
    }

}

extension MypageVC: MypageViewModelDelegate {
    func myInfoCellTapped() {
        self.navigationController?.pushViewController(MyInfoVC(), animated: true)
    }
    
    func noticeCellTapped() {
        print("noticeCellTapped")
    }
    
    func frequentlyQuestionCellTapped() {
        print("frequentlyQuestionCellTapped")
    }
    
    func questionCellTapped() {
        print("questionCellTapped")
    }
    
    func noticeSetCellTapped() {
        print("noticeSetCellTapped")
    }
    
    func termCellTapped() {
        print("termCellTapped")
    }
}




