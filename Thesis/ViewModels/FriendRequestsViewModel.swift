//
//  FriendRequestsViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 11/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class FriendRequestsViewModel:NSObject{
    
    @IBOutlet var apiClient : ApiClientUsers!
    var requests : [User]?
    var count : [Int]?
    
    func GetFriendName(for indexPath:IndexPath) -> String{
        return (requests?[indexPath.row].Username) ?? ""
    }
    
    func GetFriendId(for indexPath:IndexPath) -> String{
        return (requests?[indexPath.row].Id) ?? ""
    }
    
    func GetCount() -> Int{
        return requests?.count ?? 0
    }
    
    func GetNumberOfCommonFriends(for indexPath:IndexPath) -> String {
        if let c = count?[indexPath.row]{
            if c == 1 {
                return "\(String(c)) common friend"
            }else {
                return "\(String(c)) common friends"
            }
        
        }
        else { return "No common friends" }
    }
    
    func AcceptRequest(for indexPath:IndexPath,completion:@escaping (Bool) -> Void){
        if let userId = self.requests?[indexPath.row].Id{
            self.apiClient.AcceptRequest(userId: userId) { (ok) in
                DispatchQueue.main.async {
                    completion(ok)
                }
            }
        }
    }
    
    func RejectRequest(for indexPath:IndexPath,completion:@escaping (Bool) -> Void){
        if let userId = self.requests?[indexPath.row].Id{
            self.apiClient.RejectRequest(userId: userId) { (ok) in
                DispatchQueue.main.async {
                    completion(ok)
                }
            }
        }
    }
    
    func GetFriendRequests(completion:@escaping ()->Void){
        apiClient.GetFriendRequests{ (users,count) in
            DispatchQueue.main.async {
                self.requests = users
                self.count = count
                completion()
            }
        }
    }
    
    func RemoveFromArray(at indexPath:IndexPath){
        self.requests?.remove(at: indexPath.row)
    }
}
