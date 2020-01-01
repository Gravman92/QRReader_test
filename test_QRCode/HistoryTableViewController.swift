//
//  HistoryTableViewController.swift
//  test_QRCode
//
//  Created by Gravman on 28.12.2019.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UIViewController {
    
    var history: [History] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     func update(history: History) {
         self.history.append(history)
         let newIndexPath = IndexPath(row: self.history.count - 1 , section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        
     }

    
     func fetchData(){
        let context = CoreDataManager.shared.persistenContainer.viewContext
         
         let fetchRequest = NSFetchRequest<History>(entityName: "History")
         
         do{
             let rowHistory = try context.fetch(fetchRequest)
             rowHistory.forEach { (row) in
                 self.history = rowHistory
                  self.tableView.reloadData()
             }
            
             print("FetchSuccess")
         } catch let fetchErr{
             print("Unnable to fetch: ", fetchErr)
         }
         
     }
}

extension HistoryTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let history = self.history[indexPath.row]
        
        guard let result = history.result else {return cell}
        guard let date = history.date else {return cell}
        cell.textLabel?.text = "\(indexPath.row+1 ) \(result) \(date)"
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }

}

extension HistoryTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (delete, indexPath) in
            let story = self.history[indexPath.row]
            
            self.history.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
            
            let context = CoreDataManager.shared.persistenContainer.viewContext
            
            context.delete(story)
            do {
                try context.save()
            } catch {
                print ("Can`t save")
            }
        }
        
    return [delete]
        
    }
    
    
}
