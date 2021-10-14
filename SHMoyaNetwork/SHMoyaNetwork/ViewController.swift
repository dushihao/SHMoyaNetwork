//
//  ViewController.swift
//  SHMoyaNetwork
//
//  Created by YYKJ on 2021/10/12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = [
        "EYun",
        "V2EX"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        tableView.register(SHListCell.self, forCellReuseIdentifier: "customCell")
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? SHListCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectString = self.dataSource[indexPath.row]
        switch selectString {
        case "EYun":
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "EYunViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        case "V2EX":
            let vc = V2EXViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print(selectString)
        }
    }
}
