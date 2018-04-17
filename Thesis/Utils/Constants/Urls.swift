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
    static let GetNewsFeed = BaseUrl + "user/newsfeed?page="
    static let GetFriendRequests = BaseUrl + "user/requests"
    static let GetFriendRequestsNumber = BaseUrl + "user/requestsNumber"
    static let AcceptFriendRequest = BaseUrl + "user/requests/accept?userId="
    static let Register = BaseUrl + "user/register"
    static let FindUsers = BaseUrl + "user/find?query="
    static let AddFriend = BaseUrl + "user/requests/add?userid="
    
    //MARK: Books
    static let GetLibrary = BaseUrl + "books/"
    static let Search = BaseUrl + "books/search?query="
    static let AddToLibrary = BaseUrl + "books/add"
    static let CheckIfInLibrary = BaseUrl + "books/check?bookId="
    static let GoogleApiSearch = "https://www.googleapis.com/books/v1/volumes?q="
    static let AddNewBookToLibrary = BaseUrl + "books/addnew"
    static let GetOwnersOfBook = BaseUrl + "books/owners?bookId="
}
