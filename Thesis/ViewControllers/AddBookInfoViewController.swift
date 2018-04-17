//
//  AddBookInfoViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 07/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit
//addBookInfoCell
class AddBookInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var viewModel : AddBookInfoViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var checkMarkImageViwe: UIImageView!
    @IBOutlet weak var alreadyInLibraryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.titleLabel.text = viewModel.GetTitle()
        self.authorsLabel.text = viewModel.GetAuthors()
        //let image = ImageResizeHelper.resizeImage(image: viewModel.GetBookCover(), newWidth: self.imageView.bounds.size.width)
        let image = ImageResizeHelper.imageWithImage(sourceImage: viewModel.GetBookCover(), scaledToWidth: self.imageView.bounds.size.width)
        self.imageView.image = image
        self.imageView.addShadow()
        self.alreadyInLibraryLabel.text = ""
        self.tableView.delegate=self
        self.tableView.dataSource=self
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: BackButtonHelper.GetBackButton(controller: self, selector: #selector(backAction(_:))))
        let addBtn = UIButton(type: .custom)
        addBtn.setTitle("Add to library", for: [])
        addBtn.setTitleColor(addBtn.tintColor, for: [])
        addBtn.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:addBtn)
        self.viewModel.CheckIfInLibrary { (result) in
            if result {
                self.alreadyInLibraryLabel.text = "Book already in your library"
                self.checkMarkImageViwe.image = ImageResizeHelper.imageWithImage(sourceImage: UIImage(named: "checkmark_green")!, scaledToWidth: self.checkMarkImageViwe.bounds.width)
                self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false;
                self.tabBarController?.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.gray], for: .disabled)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func backAction(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addAction(_ sender:UIBarButtonItem){
        self.viewModel.AddBookToLibrary { (success,msg) in
            if success{
                AlertMessageHelper.displayMessage(message: "Book successfully added to library", title: "Add book", controller: self)
            }
            else{
                AlertMessageHelper.displayMessage(message: "Could not add to library " + msg, title: "Add book", controller: self)
            }
           
        }
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.GetCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addBookInfoCell", for: indexPath) as! AddBookInfoOwnerTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = viewModel.GetOwnerName(for: indexPath)
        
        return cell
    }
    
    func reloadData() {
        self.viewModel.GetOwners {
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
