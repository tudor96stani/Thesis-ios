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

extension String {
    func toDate(dateFormat: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let date: Date? = dateFormatter.date(from: self)
        return date
    }
}

extension UIImageView{
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 7
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String,size:CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: size)]
        
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
