//
//  SettingsTableViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 05/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit
import KeychainSwift
class SettingsTableViewController: UITableViewController {

    let keychain = KeychainSwift()
    let defaultValues = UserDefaults.standard
    @IBOutlet var viewModel : SettingsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)
        
        self.viewModel.GetFriendRequestsNumber {
            let cell = self.tableView.cellForRow(at: IndexPath(item: 1, section: 0))
            cell?.addBadge(number: self.viewModel.friendRequests)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let selectedRow = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title="Settings"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil;
        self.tabBarController?.navigationItem.leftBarButtonItem = nil;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
            case 0:
                return 3
            case 1:
                return 1
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0{
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "friendsTbl") as! FriendsTableViewController
                self.navigationController?.pushViewController(ViewController, animated: true)
            }
            else if indexPath.row == 1{
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "friendRequestsCtrl") as! FriendRequestsTableViewController
                self.navigationController?.pushViewController(ViewController, animated: true)
            }
            else if indexPath.row == 2{
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "searchFriendsCtrl") as! SearchForFriendsTableViewController
                self.navigationController?.pushViewController(ViewController, animated: true)
            }
        }
        else if indexPath.section==1 {
            if indexPath.row==0{
                self.keychain.delete(KeychainSwift.Keys.Token)
                self.keychain.delete(KeychainSwift.Keys.Username)
                self.keychain.delete(KeychainSwift.Keys.Password)
                self.defaultValues.removeObject(forKey: UserDefaults.Keys.UserId)
                if (self.navigationController?.popViewController(animated: true)) == nil{
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginCtrl") as! LoginViewController
                    let nav = UINavigationController(rootViewController: ViewController)
                    appdelegate.window!.rootViewController = nav
                }
            }
        }
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
