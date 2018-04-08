//
//  GoogleResultViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 08/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
class GoogleResultViewModel:NSObject{
    @IBOutlet var apiClient: ApiClientBooks!
    var results : [Book] = [Book]()
    var query:String!    
    fileprivate var page:  Int = 0
    var finished = false
    func Search(completion:@escaping ([Book]?)->Void){
        apiClient.SearchGoogleApi(query: self.query,pageToDisplay: page+1) { (books) in
            DispatchQueue.main.async {
                self.page += 1
                self.results += books ?? [Book]()
                if books == nil {
                    self.finished = true
                }
                completion(books)
            }
        }
    }
    
    func GetCount()->Int{
        return self.page*10
    }
    
    func GetBookId(for indexPath:IndexPath) -> UUID?{
        return self.results[indexPath.row].Id
    }
    
    func GetTitleAndAuthor(for indexPath:IndexPath) -> String {
        if indexPath.row >= 0 && indexPath.row < results.count{
            return results[indexPath.row].Title + ", " + self.GetAuthorsNames(for:indexPath)
        }
        return ""
    }
    
    private func GetAuthorsNames(for indexPath:IndexPath) -> String{
        var names = ""
        if indexPath.row >= 0 && indexPath.row < results.count{
            let book = self.results[indexPath.row]
            for author in (book.Authors!){
                names += " " + author.FirstName + " " + author.LastName
            }
        }
        return names
    }
    
    func BookCoverToDisplay(for indexPath:IndexPath) -> UIImage {
        if indexPath.row >= 0 && indexPath.row < results.count{
            if let cover = self.results[indexPath.row].Cover{
                return UIImage(data:cover as Data)!
            }
        }
        return UIImage(named: "default_cover")!
    }
    
    func GetBook(by id:UUID) -> Book{
        return (self.results.first(where: { (book) -> Bool in
            book.Id==id
        }))!
    }
}
