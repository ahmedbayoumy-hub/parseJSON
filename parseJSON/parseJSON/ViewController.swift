//
//  ViewController.swift
//  parseJSON
//
//  Created by Consultant on 12/20/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var result: Result?
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        parseJSON()
    }
    
    // TableView
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        result?.data[section].Title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return result?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = result {
            return result.data[section].Items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = result?.data[indexPath.section].Items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = text
        return cell
    }
    
    
    //JSON
    
    private func parseJSON() {
        guard let path = Bundle.main.path(forResource: "data",
                                          ofType: "json") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        
        
        do {
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode(Result.self, from: jsonData)
            
            if let result = result {
                print(result)
            } else {
                print ("failed to parse!")
            }
            
        } catch {
            print("Error: \(error)")
        }
    }


}

struct Result: Codable {
    let data: [ResultItem]
}

struct ResultItem: Codable {
    let Title: String
    let Items: [String]
}
