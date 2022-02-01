//
//  MypageVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit

class MypageVC: UITableViewController {

    let mainView = MypageView()
    private var viewModel: MypageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "내정보"
        viewModel = MypageViewModel(delegate: self) // We set the delegate of the protocol we defined earlier to this class
        
        // IMPORTANT. This transfer the responsibility of datasource and delegates to our ViewModel
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.tableFooterView = UIView()
    }

}

extension MypageVC: MypageViewModelDelegate {
    func myInfoCellTapped() {
        print("myInfoCellTapped")
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




