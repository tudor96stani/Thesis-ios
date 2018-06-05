//
//  NewsFeedViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 10/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel:NewsFeedViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.tableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInsetAdjustmentBehavior = .never
     
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //self.reloadData()
        
        tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        // Set custom indicator margin
        //tableView.infiniteScrollIndicatorMargin = 40
        
        // Set custom trigger offset
        //tableView.infiniteScrollTriggerOffset = 500
        
        // Add infinite scroll handler
        tableView.addInfiniteScroll { [weak self] (tableView) -> Void in
            self?.reloadData() {
                tableView.finishInfiniteScroll()
                
            }
        }
        
        tableView.beginInfiniteScroll(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title="News feed"
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.NumberOfItemsToDisplay(in: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell", for: indexPath) as! NewsFeedTableViewCell
        cell.ownerActionLabel.attributedText = viewModel.OwnerActionToDisplay(for: indexPath)
        cell.titleLabel.text = viewModel.BookTitleToDisplay(for: indexPath)
        cell.authorsLabel.text = viewModel.BookAuthorToDisplay(for: indexPath)
        let image = ImageResizeHelper.resizeImage(image: viewModel.BookCoverToDisplay(for: indexPath), newWidth: cell.coverView!.bounds.size.width*2)
        cell.coverView?.image = image
        cell.dateLabel.text = viewModel.GetTimeSincePostCreated(for: indexPath)
        return cell
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //self.reloadData()
        viewModel.RestartPaging()
        refreshControl.endRefreshing()
        self.reloadData {
            //self.tableView.reloadData()
        }
    }

    
    func reloadData(_ completionHandler:(()->Void)?){
        self.viewModel.GetNewsFeed { (newActivities) in
            if newActivities != nil{
                // create new index paths
                let storyCount = self.viewModel.NumberOfItemsToDisplay(in: 1) - (newActivities?.count)!
                let (start, end) = (storyCount, (newActivities?.count)! + storyCount)
                let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                
                // update table view
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                self.tableView.endUpdates()
                
               
            }
            
            completionHandler?()
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
