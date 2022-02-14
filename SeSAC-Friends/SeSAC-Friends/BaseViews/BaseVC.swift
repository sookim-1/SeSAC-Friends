//
//  BaseSignViewController.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/01.
//

import UIKit

import Toast_Swift

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        configure()
        hideKeyboard()
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
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
