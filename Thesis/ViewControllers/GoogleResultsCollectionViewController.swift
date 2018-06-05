//
//  GoogleResultsCollectionViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 08/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit



class GoogleResultsCollectionViewController: UICollectionViewController {

    @IBOutlet var viewModel : GoogleResultViewModel!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        self.tabBarController?.title="Search for " + self.viewModel.query
        self.collectionView?.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        //self.collectionView?.contentInsetAdjustmentBehavior = .never
        collectionView?.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 90, width: 24, height: 24))
        
        // Set custom indicator margin
        //collectionView?.infiniteScrollIndicatorMargin = 80
        
        // Add infinite scroll handler
        collectionView?.addInfiniteScroll { [weak self] (scrollView) -> Void in
            self?.reloadData(){
                scrollView.finishInfiniteScroll()
            }
        }
        
        // load initial data
        collectionView?.beginInfiniteScroll(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: BackButtonHelper.GetBackButton(controller: self, selector: #selector(backAction(_:))))
        
    }
    
    private func reloadData(completion:@escaping () -> Void){
        if viewModel.finished{
            completion()
        }else{
            viewModel.Search() { (books) in
                // create new index paths
                let bookCount = self.viewModel.results.count - (books?.count ?? 0)
                let (start, end) = (bookCount, (books?.count ?? 0) + bookCount)
                let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                
                // update collection view
                self.collectionView?.performBatchUpdates({ () -> Void in
                    self.collectionView?.insertItems(at: indexPaths)
                }, completion: { (finished) -> Void in
                    completion();
                });
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.GetCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "googleResultCell", for: indexPath) as! GoogleResultCollectionViewCell
    
        // Configure the cell
        cell.titleAuthorLabel.text = viewModel.GetTitleAndAuthor(for: indexPath)
        let image = ImageResizeHelper.resizeImage(image: viewModel.BookCoverToDisplay(for: indexPath), newWidth: cell.coverView!.bounds.size.width*2)
        cell.coverView?.image = image
        cell.coverView?.addShadow()
        guard let id = viewModel.GetBookId(for: indexPath)
            else{
                fatalError()
        }
        cell.bookId = id
        return cell
    }
    
    

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "addNewBookCtrl") as! AddNewBookViewController
        ViewController.viewModel = AddNewBookViewModel(book:self.viewModel.GetBook(at: indexPath))
        self.navigationController?.pushViewController(ViewController, animated: true)
        
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    //MARK: Navigation
    @objc func backAction(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }

}
