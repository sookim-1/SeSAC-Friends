//
//  BaseSignViewController.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit

class BaseSignVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        configure()
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.tintColor = .label
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
    }
}
