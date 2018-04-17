//
//  NewsFeedViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 10/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class NewsFeedViewModel:NSObject{
    @IBOutlet var apiClient : ApiClientUsers!
    var activities : [Activity] = [Activity]()
    var page = 0
    var moreDataRemaining = true
    
    func GetNewsFeed(completion:@escaping ([Activity]?) -> Void) {
        if moreDataRemaining{
            apiClient.GetNewsFeed(page: page + 1) { (result) in
                self.page += 1
                if let nextPage = result {
                    self.activities += nextPage
                }else{
                    self.moreDataRemaining = false
                }
                completion(result)
            }
        }else{
            completion(nil)
        }
    }
    
    func RestartPaging(){
        self.page = 0;
        self.moreDataRemaining = true;
        self.activities.removeAll()
    }
    
    func NumberOfItemsToDisplay(in section: Int)->Int
    {
        return activities.count;
    }
    
    func BookTitleToDisplay(for indexPath: IndexPath)->String
    {
        return activities[indexPath.row].book.Title;
    }
    
    func BookAuthorToDisplay(for indexPath: IndexPath)->String{
        var authors = "";
        for author in (self.activities[indexPath.row].book.Authors)!{
            authors.append(author.FullName + " ")
        }
        return authors
    }
    
    func BookCoverToDisplay(for indexPath:IndexPath) -> UIImage {
        if let cover = self.activities[indexPath.row].book.Cover{
            return UIImage(data:cover as Data)!
        }
        return UIImage(named: "default_cover")!
    }
    
    func OwnerActionToDisplay(for indexPath:IndexPath) -> NSMutableAttributedString{
        let action : String
        switch self.activities[indexPath.row].type{
        case .Added:
            action = "added to library"
        case .Borrowed:
            action = "borrowed"
        default:
            action = ""
        }
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold(self.activities[indexPath.row].owner.Username,size:17)
            .normal(" has " + action)
        
        
       return formattedString
    }
    
    func GetTimeSincePostCreated(for indexPath:IndexPath) -> String {
        let date = self.activities[indexPath.row].dateTime
        let dateFormatter = DateFormatter()
        if let unwrappedDate = date{
            let nsdate = unwrappedDate as NSDate
            let timeSince = dateFormatter.timeSince(from: nsdate, numericDates: true)
            return timeSince
        }
        return ""
    }
}
