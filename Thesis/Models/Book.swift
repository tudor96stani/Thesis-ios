//
//  Book.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON
class Book{
    var Id:UUID
    var Title:String
    var Year:Int
    var Publisher:String
    var Authors:[Author]?
    var Cover:NSData?
    var CoverUrl:String!
    
    init(id:UUID,title:String,year:Int,pub:String){
        Id=id
        Title=title
        Year=year
        Publisher=pub
        Authors = [Author]()
    }
    
    init(json:JSON){
        Id=UUID(uuidString:json["id"].string ?? "00000000-0000-0000-0000-000000000000")!
        Title = json["title"].stringValue
        Year = json["year"].intValue
        Publisher = json["publisher"].stringValue
        Authors=[Author]()
        for(_,object) in json["authors"]{
            Authors?.append(Author(json:object))
        }
        let base64String = json["cover"].stringValue
        if base64String != ""
        {
            self.Cover = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0))
            
        }
    }
    
    init(googleJson:JSON){
        Id = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        Title = googleJson["volumeInfo"]["title"].stringValue
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let stringValueOfDate = googleJson["volumeInfo"]["publishedDate"].stringValue
        if let date = stringValueOfDate.toDate(dateFormat: "yyyy-MM-dd"),let year = calendar?.component(NSCalendar.Unit.year, from: date){
            Year = year
        }else{
            if let date=stringValueOfDate.toDate(dateFormat: "yyyy"),let year = calendar?.component(NSCalendar.Unit.year, from: date){
                Year = year
            }
            else{
                Year = 0
            }
        }
        
        Publisher = googleJson["volumeInfo"]["publisher"].stringValue
        if let url = googleJson["volumeInfo"]["imageLinks"]["thumbnail"].url{
            Cover = NSData(contentsOf:url)
            CoverUrl = googleJson["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
        }
        else{
            Cover=nil;
            CoverUrl = ""
        }
        self.Authors = [Author]()
        if let authors = googleJson["volumeInfo"]["authors"].array{
            for author in authors{
                self.Authors?.append(Author(fullname: author.stringValue))
            }
        }
    }
}
