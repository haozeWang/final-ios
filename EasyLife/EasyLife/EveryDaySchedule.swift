//
//  EveryDaySchedule.swift
//  EasyLife
//
//  Created by 王昊泽 on 17/3/11.
//  Copyright © 2017年 Haoze Wang. All rights reserved.
//

import UIKit
import CoreData
class EveryDaySchedule: UITableViewController,UIActionSheetDelegate {
    
    var task: [Task]!
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
         let currdate = getstringfromdate(date: Date())
         task =  schedule.scheduleInstance.fetchDate(date: currdate)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return task.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Daytablecell", for: indexPath) as! EveryDayScheduleCell
        let issue = task[indexPath.row]
        cell.title.text = issue.title
        cell.fin_time.text = createstringfromdate(date: issue.fin_time as! Date)
        return cell
    }
    
 
    
    @IBAction func AddSchedule(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Use Map", style: .default)
        { void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSchedule") as UIViewController
            self.present(viewController, animated: true, completion: nil)

        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Do not use map", style: .default)
        { void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTask") as UIViewController
            self.present(viewController, animated: true, completion: nil)
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)

        /*
        let alertController = UIAlertController (title: "Type", message: "Choose which type of schedule you want to make", preferredStyle: .alert)
        
        let addTravel = UIAlertAction(title: "I need use map to estimate time and set path", style: .default) { (_) -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSchedule") as UIViewController
            self.present(viewController, animated: true, completion: nil)
        }
        
        let addTask = UIAlertAction(title: "I do not need map.", style: .default){(_) -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTask") as UIViewController
            self.present(viewController, animated: true, completion: nil)
        }
        alertController.addAction(addTravel)
        alertController.addAction(addTask)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
 */
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

func getstringfromdate(date : Date) -> String{
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = "MM/dd/yy"
    
    let now = dateformatter.string(from: date)
    return now
    
}

func createstringfromdate(date : Date)->String{
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = "MM/dd/EEE HH:mm"
    
    let now = dateformatter.string(from: date)
    return now
}



