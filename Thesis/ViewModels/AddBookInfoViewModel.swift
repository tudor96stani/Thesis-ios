//
//  AddBookInfoViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 07/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//
import UIKit
import Foundation
class AddBookInfoViewModel:NSObject{
    
    var book: Book!
    var apiClient = ApiClientBooks()
    init(book:Book){
        self.book=book;
    }
    
    func GetTitle()-> String{
        return book.Title
    }
    
    func GetAuthors() -> String{
        var names = ""
        for author in book.Authors!{
            names += author.FullName + ","
        }
        if !names.isEmpty{
            let indexOfEnd = names.index(names.endIndex, offsetBy: -1)
            return String(names[..<indexOfEnd])
        }
        return ""
    }
    
    func GetBookCover() -> UIImage{
        if let cover = self.book.Cover{
            return UIImage(data:cover as Data)!
        }
        return UIImage(named: "default_cover")!
    }
    
    func AddBookToLibrary(completion:@escaping (Bool,String)->Void){
        apiClient.AddBookToLibrary(bookId: self.book.Id) { (success,msg) in
            DispatchQueue.main.async {
                completion(success,msg)
            }
        }
    }
    
    func CheckIfInLibrary(completion:@escaping (Bool)->Void){
        apiClient.CheckIfInLibrary(bookId: self.book.Id) { (result) in
            DispatchQueue.main.async{
                completion(result)
            }
        }
    }
}
