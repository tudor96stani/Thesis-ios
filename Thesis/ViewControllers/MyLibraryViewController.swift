//
//  MyLibraryViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit
import KeychainSwift


class MyLibraryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel:MyLibraryViewModel!
    
   
    
    let keychain = KeychainSwift()
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ReloadData()
        
        self.tableView.contentInsetAdjustmentBehavior = .never
        //self.tableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        self.tableView.tableFooterView = UIView()
        
        //Handle pull down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title="My books"
        
        let btn2 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MyLibraryViewController.goTo(_:)))
        self.tabBarController?.navigationItem.rightBarButtonItem=btn2
        
        let borrowRequestsBtn = UIButton(type: .custom)
        let borrowRequestBtnImage = UIImage(named: "videos_purchased")!
        borrowRequestsBtn.setImage(borrowRequestBtnImage, for: .normal)
        borrowRequestsBtn.addTarget(self, action: #selector(MyLibraryViewController.goToBorrowRequests(_:)), for: UIControlEvents.touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: borrowRequestsBtn)
        
        self.tabBarController?.navigationItem.leftBarButtonItem=leftBarButton
        //leftBarButton.addBadge(number: 0)
        self.viewModel.GetNumberOfBorrowRequests { (nbOfRequest) in
            leftBarButton.addBadge(number: nbOfRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.NumberOfItemsToDisplay(in: 1)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myLibraryCell", for: indexPath) as! MyLibraryViewCell
        cell.TitleLabel?.text = viewModel.BookTitleToDisplay(for: indexPath)
        cell.AuthorLabel?.text = viewModel.BookAuthorToDisplay(for: indexPath)
        let image = ImageResizeHelper.resizeImage(image: viewModel.BookCoverToDisplay(for: indexPath), newWidth: cell.CoverView!.bounds.size.width)
        cell.CoverView?.image = image
        cell.sourceLabel.text = viewModel.GetSource(for: indexPath)
        return cell
    }
    
    
    //MARK: - Methods
    
    func ReloadData(){
        viewModel.GetBooks(UserId: UUID(uuidString:UserDefaults.standard.string(forKey:UserDefaults.Keys.UserId)!)!) {
            self.tableView.reloadData()
        }
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.ReloadData()
        refreshControl.endRefreshing()
    }

    
     
    // MARK: - Navigation
    @objc func back(sender: UIBarButtonItem) {
        self.keychain.delete(KeychainSwift.Keys.Token)
        self.keychain.delete(KeychainSwift.Keys.Username)
        self.keychain.delete(KeychainSwift.Keys.Password)
        self.defaultValues.removeObject(forKey: UserDefaults.Keys.UserId)
        
        if (self.navigationController?.popViewController(animated: true)) != nil{
            
        }
        else{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginCtrl") as! LoginViewController
            let nav = UINavigationController(rootViewController: ViewController)
            appdelegate.window!.rootViewController = nav
        }
    }
    
    @objc func goTo(_ sender:UIBarButtonItem){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "searchBookCtrl") as! SearchForBookViewController
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    @objc func goToBorrowRequests(_ sender:UIButton){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "borrowRequestsCtrl") as! BorrowRequestsTableViewController
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
     
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
