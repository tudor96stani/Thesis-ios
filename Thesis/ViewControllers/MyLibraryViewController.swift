//
//  MyLibraryViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class MyLibraryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel:MyLibraryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ReloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.NumberOfItemsToDisplay(in: 1)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myLibraryCell", for: indexPath) as! MyLibraryViewCell
        cell.TitleLabel?.text = viewModel.BookTitleToDisplay(for: indexPath)
        cell.AuthorLabel?.text = viewModel.BookAuthorToDisplay(for: indexPath)
        return cell
    }
    
   
    
    func ReloadData(){
        viewModel.GetBooks(UserId: UUID(uuidString:UserDefaults.standard.string(forKey:UserDefaults.Keys.UserId)!)!) {
            self.tableView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
