//
//  ReviewVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/23.
//

import UIKit

class ReviewVC: UITableViewController {

    var reviews: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "새싹 리뷰"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        print(reviews)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.textLabel?.text = "\(reviews![indexPath.row])"
        
        return cell
        
    }
}
