//
//  JSONParsers.swift
//  Thesis
//
//  Created by Tudor Stanila on 12/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON
extension JSON{
    func handleUserArray() -> [User] {
        var users = [User]()
        for(_,subJson) in self{
            users.append(User(json:subJson))
        }
        return users
    }
    
    func handleBookArray() -> [Book] {
        var books = [Book]()
        for(_,subJson) in self {
            books.append(Book(json:subJson))
        }
        return books
    }
    
    func handleBookArrayFromGoogle() -> [Book]{
        var books = [Book]()
        for(_,subJson) in self {
            books.append(Book(googleJson:subJson))
        }
        return books
    }
    
    func handleBorrowRequestArray() -> [BorrowRequest] {
        var requests = [BorrowRequest]()
        for(_,subJson) in self {
            requests.append(BorrowRequest(json:subJson))
        }
        return requests
    }
}


