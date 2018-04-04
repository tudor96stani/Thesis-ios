//
//  ExtensionMethods.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import KeychainSwift
import UIKit
extension KeychainSwift{
    enum Keys{
        static let Token = "token"
        static let Username = "username"
        static let Password = "password"
    }
}

extension UserDefaults {
    enum Keys {
        static let UserId = "userid"
        static let Books = "books"
        static let Authors = "authors"
        static let Operations = "Operations"
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
