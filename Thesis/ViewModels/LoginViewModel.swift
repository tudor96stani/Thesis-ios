//
//  LoginViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class LoginViewModel:NSObject{
    var user:User?
    var errorMessage:String?
    @IBOutlet var apiClient:ApiClientUsers!
    
    func Login(username:String,password:String,completion:@escaping (Bool)->Void){
        apiClient.Login(username: username, password: password) { (user, msg, ok) in
            DispatchQueue.main.async {
                self.user=user
                self.errorMessage=msg
                completion(ok)
            }
        }
    }
}
