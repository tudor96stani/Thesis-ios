//
//  BorrowRequestsTableViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 19/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class BorrowRequestsTableViewController: UITableViewController {

    @IBOutlet var viewModel : BorrowRequestsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      
        self.tableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        self.tableView.tableFooterView = UIView()
        
        self.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: BackButtonHelper.GetBackButton(controller: self, selector: #selector(backAction(_:))))
        self.tabBarController?.title="Borrow requests"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.GetCount()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "borrowRequestCell", for: indexPath) as! BorrowRequestsTableViewCell

        // Configure the cell...
        cell.nameLabel.text = viewModel.GetUsernameFor(requestAt: indexPath)
        cell.titleLabel.text = viewModel.GetTitle(requestAt: indexPath)
        cell.acceptAction = {
            self.viewModel.AcceptRequest(at: indexPath, completion: { (success) in
                if success {
                    AlertMessageHelper.displayMessage(message: "Request accepted", title: "Borrow request", controller: self)
                    self.reloadData()
                }
                else{
                    AlertMessageHelper.displayMessage(message: "Could not accept request", title: "Borrow request", controller: self)
                }
            })
        }
        cell.rejectAction = {
            self.viewModel.RejectRequest(at: indexPath, completion: { (success) in
                if success {
                    AlertMessageHelper.displayMessage(message: "Request rejected", title: "Borrow request", controller: self)
                    self.reloadData()
                }
                else{
                    AlertMessageHelper.displayMessage(message: "Could not reject request", title: "Borrow request", controller: self)
                }
            })
        }

        return cell
    }
    

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
    
    //MARK: - Methods
    func reloadData(){
        self.viewModel.GetRequests {
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Navigation
     @IBAction func backAction(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
     }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
