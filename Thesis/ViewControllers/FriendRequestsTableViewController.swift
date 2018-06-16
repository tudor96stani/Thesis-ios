//
//  FriendRequestsTableViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 11/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class FriendRequestsTableViewController: UITableViewController {

    @IBOutlet var viewModel : FriendRequestsViewModel!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        self.tableView.tableFooterView = UIView()
        self.tabBarController?.title="Friend requests"
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: BackButtonHelper.GetBackButton(controller: self, selector: #selector(backAction(_:))))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
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
        return self.viewModel.GetCount()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as! FriendRequestsTableViewCell

        // Configure the cell...
        cell.nameLabel.text = self.viewModel.GetFriendName(for: indexPath)
        
        cell.acceptBtn.layer.cornerRadius = 10
        cell.acceptBtn.clipsToBounds = true
        cell.declineBtn.layer.cornerRadius = 10
        cell.declineBtn.clipsToBounds = true
        cell.commonFriendsLabel.text = viewModel.GetNumberOfCommonFriends(for: indexPath)
        cell.acceptAction = {
            self.viewModel.AcceptRequest(for: indexPath, completion: { (success) in
                if !success {
                    AlertMessageHelper.displayMessage(message: "Something went wrong", title: "Accept request", controller: self)
                }
                else{
                    AlertMessageHelper.displayMessage(message: "Request successfully accepted!", title: "Accept request", controller: self)
                    self.viewModel.RemoveFromArray(at: indexPath)
                    self.tableView.reloadData()
                }
            })
        }
        return cell
    }
 
    
    func reloadData(){
        ActivityIndicatorHelper.start(activityIndicator: self.activityIndicator, controller: self)
        self.viewModel.GetFriendRequests {
            ActivityIndicatorHelper.stop(activityIndicator: self.activityIndicator)
            if self.viewModel.GetCount() == 0{
                let footer = UIView()
                let image = UIImage(named: "minus.png")!
                let resizedImage = ImageResizeHelper.resizeImage(image: image, newWidth: 70)!
                let imageView = UIImageView(image: resizedImage)
                imageView.frame = CGRect(x: 150, y: 130, width: 70, height: 70)
                imageView.contentMode = .scaleAspectFit
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                label.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
                label.textAlignment = .center
                label.text = "No friend requests"
                
                footer.addSubview(imageView)
                footer.addSubview(label)
                self.tableView.tableFooterView = footer
            }
            else{
                self.tableView.tableFooterView = UIView()
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backAction(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
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
