//
//  FindVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/15.
//

import UIKit

import SnapKit

final class FindVC: BaseVC, TapViewDelegate {


    private var tapView: CustomTapView!
    private var emptyView = EmptyView(text: "아쉽게도 주변에 새싹이 없어요ㅠ\n취미를 변경하거나 조금만 더 기다려 주세요!")
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpLayout()
    }
    
    override func configure() {
        title = "새싹 찾기"
        
        tapView = CustomTapView(frame: .zero, buttonTitle: ["주변 새싹", "받은 요청"])
        tapView.delegate = self
        tapView.backgroundColor = .clear

        view.addSubview(tapView)
        view.addSubview(emptyView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopFindRequest))
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FindTableViewCell.self, forCellReuseIdentifier: "FindTableViewCell")
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tapView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpLayout() {
        tapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(tapView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func change(to index: Int) {
        print(index)
        if index == 1 {
            emptyView.removeFromSuperview()
            
            configureTableView()
        }
    }
    
    @objc func stopFindRequest() {
        print("찾기중단")
    }
}

extension FindVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FindTableViewCell", for: indexPath) as? FindTableViewCell
        else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}
