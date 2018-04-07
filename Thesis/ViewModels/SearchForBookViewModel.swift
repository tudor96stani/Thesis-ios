//
//  SearchForBookViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 07/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
class SearchForBookViewModel:NSObject{
    var results : [Book]?
    @IBOutlet var apiClient : ApiClientBooks!
    func Search(query:String,completion:@escaping ()->Void){
        apiClient.Search(by: query) { (books) in
            DispatchQueue.main.async {
                self.results = books
                completion()
            }
        }
    }
    
    func GetCount()->Int{
        return self.results?.count ?? 0
    }
    
    func GetTitleAndAuthor(for indexPath:IndexPath) -> String{
        if let book = self.results?[indexPath.row]{
            return book.Title + ", " + self.GetAuthorsNames(for:indexPath)
        }
        return ""
    }
    
    private func GetAuthorsNames(for indexPath:IndexPath) -> String{
        var names = ""
        let book = self.results?[indexPath.row]
        for author in (book?.Authors!)!{
            names += " " + author.FirstName + " " + author.LastName
        }
        return names
    }
    
    func BookCoverToDisplay(for indexPath:IndexPath) -> UIImage {
        if let cover = self.results?[indexPath.row].Cover{
            return UIImage(data:cover as Data)!
        }
        return UIImage(named: "default_cover")!
    }
}
