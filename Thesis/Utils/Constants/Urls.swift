//
//  Urls.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
enum Urls{
    static let BaseUrl = "http://home-server.go.ro/Thesis/api/v1/"
    
    //MARK: Users
    static let LoginUrl = "http://home-server.go.ro/Thesis/oauth/token"
    static let RefreshURL: String = "http://home-server.go.ro/Thesis/verify"
    static let GetFriends = BaseUrl + "user/friends?userId="
    
    //MARK: Books
    static let GetLibrary = BaseUrl + "books/"
    static let Search = BaseUrl + "books/search?query="
}
