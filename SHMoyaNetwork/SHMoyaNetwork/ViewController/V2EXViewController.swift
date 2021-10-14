//
//  V2EXViewController.swift
//  SHMoyaNetwork
//
//  Created by YYKJ on 2021/10/13.
//

import UIKit
import SwiftyJSON

class V2EXViewController: UIViewController {
    
    deinit {
        
    }
    
    var dataSource: [HotModel] = Array()
    let decoder = JSONDecoder()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.register(SHV2EXCell.self, forCellReuseIdentifier: SHV2EXCell.reuseIdentifired)
        return tableView
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "最热主题"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        hotRequest()
        //        lastestReqeust()
    }
    
    // MARK: - V2EX 接口
    func hotRequest() {
        V2EXProvider.request(.hot) { result in
            switch result {
            case let .success(moyaResponse):
                let body = moyaResponse.data
//                let statusCode = moyaResponse.statusCode
                
                do {
                    let models =  try self.decoder.decode([HotModel].self, from: body)
                    self.dataSource += models
                    self.tableView.reloadData()
                } catch  {
                    print(error)
                }
                
                
            case let .failure(moyaError):
                print(moyaError)
            }
        }
    }
    
    func lastestReqeust() {
        V2EXProvider.request(.latest) { result in
            
        }
    }

}

extension V2EXViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SHV2EXCell.reuseIdentifired, for: indexPath) as? SHV2EXCell else {
            fatalError("""
                Expected `\(SHV2EXCell.self)` type for reuseIdentifier "\(SHV2EXCell.reuseIdentifired)".
                Ensure that the `\(SHV2EXCell.self)` class was registered with the table view (being passed from the view controller).
                """
            )
        }
        
        let model = dataSource[indexPath.row]
        
        cell.textLabel?.text  = model.title
        cell.detailTextLabel?.text = model.content
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}
