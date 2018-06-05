//
//  SearchForBookViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 07/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class SearchForBookViewController: UIViewController,
            UICollectionViewDelegate,
            UICollectionViewDataSource,
            UITextFieldDelegate,
            UINavigationControllerDelegate,
            UIImagePickerControllerDelegate{
    
    @IBOutlet var viewModel : SearchForBookViewModel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var query : String?
    fileprivate var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource=self
        self.collectionView.delegate = self
        self.searchField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem=nil
        self.tabBarController?.navigationItem.rightBarButtonItem=nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title="Search"
        
        //Setup right nav bar button
        let btnNotFound = UIBarButtonItem(title:"Not here?",style:.plain, target: self, action: #selector(SearchForBookViewController.notFoundBtnPress(_:)))
        self.tabBarController?.navigationItem.rightBarButtonItem=btnNotFound
        //Setup left nav bar button (back)
        self.tabBarController?.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: BackButtonHelper.GetBackButton(controller: self, selector: #selector(backAction(_:))))
    }
    
    
    
    //MARK: CollectionView Overrides
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.GetCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResultCell", for: indexPath) as! SearchForBookCollectionViewCell
        cell.titleAuthorLabel.text = viewModel.GetTitleAndAuthor(for: indexPath)
        let image = ImageResizeHelper.resizeImage(image: viewModel.BookCoverToDisplay(for: indexPath), newWidth: cell.coverImageView!.bounds.size.width*2)
        guard let id = viewModel.GetBookId(for: indexPath)
            else{
                fatalError()
        }
        cell.bookId = id
        cell.coverImageView?.image = image
        cell.coverImageView?.addShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SearchForBookCollectionViewCell
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "addBookInfo") as! AddBookInfoViewController
        ViewController.viewModel = AddBookInfoViewModel(book:self.viewModel.GetBook(by: cell.bookId))
        self.navigationController?.pushViewController(ViewController, animated: true)
        
    }
    
    
    //MARK: Button press actions
    @objc func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func notFoundBtnPress(_ sender: UIBarButtonItem){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "googleResultCtrl") as! GoogleResultsCollectionViewController
        if let q = self.query,!q.isEmpty {
            ViewController.viewModel.query = q
        }else{
            if let search = self.searchField.text,!search.isEmpty{
                ViewController.viewModel.query = search
            }
            else{
                AlertMessageHelper.displayMessage(message: "Please enter a keyword", title: "Search", controller: self)
                return
            }
        }
        
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        self.viewModel.Search(query: textField.text!) {
            self.collectionView?.reloadData()
        }
        self.query = textField.text!
        textField.resignFirstResponder()
        return true;
    }
    
    
    //MARK: - Camera functions
    @IBAction func cameraBtnAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ActivityIndicatorHelper.start(activityIndicator: self.activityIndicator, controller: self)
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.dismiss(animated:true){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            if let smallImage = image.resizedTo1MB(){
                self.viewModel.SendToOCRApi(image: smallImage) { (result) in
                    ActivityIndicatorHelper.stop(activityIndicator: self.activityIndicator)
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let foundText = result,!foundText.isEmpty {
                        self.searchField.becomeFirstResponder()
                        self.searchField.text = foundText
                    }
                    else{
                        AlertMessageHelper.displayMessage(message: "No text found in photo", title: "Search", controller: self)
                    }
                }
            }
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
