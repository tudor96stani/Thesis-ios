//
//  FindFriendsViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 12/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class SearchForFriendsViewModel:NSObject{
    @IBOutlet var apiClient : ApiClientUsers!
    var users = [User]()
    var friends = [User]()
    
    func FindFriends(query:String, completion:@escaping ()->Void){
        apiClient.FindFriends(query: query) { (result) in
            DispatchQueue.main.async{
                if let users = result{
                    self.users = users
                }
                self.GetExistingFriends {
                    completion()
                }
            }
        }
    }
    
    func GetExistingFriends(completion:@escaping ()->Void){
        apiClient.GetFriends { (friends) in
            DispatchQueue.main.async{
                self.friends = friends ?? [User]()
                completion()
            }
        }
    }
    
    func GetFriendName(for indexPath:IndexPath) -> String{
        return (users[indexPath.row].Username)
    }
    
    func GetCount() -> Int{
        return users.count 
    }
    
    func AddFriend(at indexPath:IndexPath,completion:@escaping (Bool)->Void){
        let userid = users[indexPath.row].Id
        apiClient.AddFriend(userId: userid) { (ok) in
            DispatchQueue.main.async{
                completion(ok)
            }
        }
    }
    
    func RemoveFromArray(at indexPath:IndexPath){
        self.users.remove(at: indexPath.row)
    }
    
    func isAlreadyAFriend(at indexPath:IndexPath) -> Bool {
        let user = self.users[indexPath.row]
        return self.friends.contains(where: { (friend) -> Bool in
            friend.Id == user.Id
        })
        
    }
}
