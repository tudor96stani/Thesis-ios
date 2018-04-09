//
//  AddNewBookViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 08/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class AddNewBookViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var coverVIew: UIImageView!
    @IBOutlet weak var authorsField: UITextField!
    
    var viewModel : AddNewBookViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleField.text = viewModel.GetTile()
        self.authorsField.text = viewModel.GetAuthors()
        let image = ImageResizeHelper.imageWithImage(sourceImage: viewModel.GetBookCover(), scaledToWidth: self.coverVIew.bounds.size.width)
        self.coverVIew.image = image
        self.coverVIew.addShadow()
        
        titleField.delegate = self
        authorsField.delegate = self
        titleField.tag = 0
        authorsField.tag = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: BackButtonHelper.GetBackButton(controller: self, selector: #selector(backAction(_:))))
        let addBtn = UIButton(type: .custom)
        addBtn.setTitle("Add to library", for: [])
        addBtn.setTitleColor(addBtn.tintColor, for: [])
        addBtn.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:addBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func backAction(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addAction(_ sender: UIBarButtonItem){
        guard let editedTitle = self.titleField.text else {
            return
        }
        guard let editedAuthor = self.authorsField.text else{
            return
        }
        self.viewModel.SetNew(title: editedTitle)
        self.viewModel.SetNew(authors: editedAuthor)
        viewModel.AddBook { (ok, msg) in
            if ok{
                AlertMessageHelper.displayMessage(message: "Book added to your library", title: "Add book", controller: self)
            }
            else{
                AlertMessageHelper.displayMessage(message: "Could not add " + (msg ?? ""), title: "Add book", controller: self)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
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
