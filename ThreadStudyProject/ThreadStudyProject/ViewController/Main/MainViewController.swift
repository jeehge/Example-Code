//
//  MainViewController.swift
//  ThreadStudyProject
//
//  Created by JH on 22/11/2019.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

enum ItemMenu: CustomStringConvertible {
    case thread
    
    var description: String {
        switch self {
        case .thread:
            return "Thread Study"
        }
    }
}

class MainViewController: BaseViewController {

    // MARK: - Property
    @IBOutlet weak var tableview: UITableView!
    
    let items: [ItemMenu] = [ItemMenu.thread]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
    }
    
    // MARK: - Initialize
    func initTableView() {
        tableview.delegate = self
        tableview.dataSource = self
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableview.dequeueReusableCell(withIdentifier: "itemCell")!
        cell.textLabel?.text = items[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // switch Int, String일 경우 default가 생김
        switch items[indexPath.row] {
        case .thread:
            let threadVC = ThreadMainViewController.viewController(from: "Thread")
            navigationController?.pushViewController(threadVC, animated: true)
        }
    }
}
