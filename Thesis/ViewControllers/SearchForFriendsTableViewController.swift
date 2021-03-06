//
//  SearchForFriendsTableViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 12/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class SearchForFriendsTableViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var viewModel : SearchForFriendsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchBar.delegate = self
        self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title="Find friends"
        self.tabBarController?.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: BackButtonHelper.GetBackButton(controller: self, selector: #selector(backAction(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.GetCount()
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchForFriendsCell", for: indexPath) as! SearchForFriendsTableViewCell

        // Configure the cell...
        cell.nameLabel.text = viewModel.GetFriendName(for: indexPath)
        if !viewModel.isAlreadyAFriend(at: indexPath){
            cell.action = {
                self.viewModel.AddFriend(at: indexPath, completion: { (success) in
                    switch success{
                    case true:
                        AlertMessageHelper.displayMessage(message: "Successfully added friend", title: "Add friend", controller: self)
                        self.viewModel.RemoveFromArray(at: indexPath)
                        self.tableView.reloadData()
                    case false:
                        AlertMessageHelper.displayMessage(message: "Could not add friend", title: "Add friend", controller: self)
                    }
                })
            }
        }else{
            cell.addButton.isEnabled = false
            cell.addButton.setTitleColor(.gray, for: .disabled)
            
        }

        return cell
    }
    
    @objc func backAction(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    

    //MARK: Search bar methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let query = searchBar.text{
            searchBar.resignFirstResponder()
            self.viewModel.FindFriends(query: query) {
                self.tableView.reloadData()
            }
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
