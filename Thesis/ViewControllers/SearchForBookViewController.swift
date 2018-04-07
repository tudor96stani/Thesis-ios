//
//  SearchForBookViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 07/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class SearchForBookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.title="Search"
        
        //Setup right nav bar button
        let btnNotFound = UIBarButtonItem(title:"Not here?",style:.plain, target: self, action: #selector(SearchForBookViewController.notFoundBtnPress(_:)))
        self.tabBarController?.navigationItem.rightBarButtonItem=btnNotFound
        //Setup left nav bar button (back)
        self.tabBarController?.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: BackButtonHelper.GetBackButton(controller: self, selector: #selector(backAction(_:))))
    }
    
    @objc func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func notFoundBtnPress(_ sender: UIBarButtonItem){
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem=nil
        self.tabBarController?.navigationItem.rightBarButtonItem=nil
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
