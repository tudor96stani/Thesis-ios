//
//  RegisterViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 12/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class RegisterViewModel:NSObject{
    @IBOutlet var apiClient:ApiClientUsers!
    
    func Register(username:String,password:String,completion:@escaping (Bool) -> Void){
        self.apiClient.Register(username: username, password: password) { (ok) in
            DispatchQueue.main.async {
                completion(ok)
            }
        }
    }
}
