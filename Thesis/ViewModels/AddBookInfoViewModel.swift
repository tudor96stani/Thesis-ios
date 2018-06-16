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
    var owners:[User]?
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
    
    func GetPublishYear() -> String {
        return "Published in \(String(book.Year))"
    }
    
    func GetPublisher() -> String {
        return "by \(book.Publisher)"
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
    
    func GetOwners(completion:@escaping ()->Void){
        apiClient.GetOwners(of: self.book.Id) { (users) in
            DispatchQueue.main.async{
                self.owners = users
                completion();
            }
        }
    }
    
    func GetOwnerName(for indexPath:IndexPath) -> String {
        return self.owners?[indexPath.row].Username ?? ""
    }
    
    func GetCount() -> Int {
        return self.owners?.count ?? 0
    }
    
    func SendBorrowRequest(to userAt:IndexPath, completion:@escaping (Bool)->Void){
        if let userId = self.owners?[userAt.row].Id {
            self.apiClient.SendBorrowRequest(from: userId, bookId: self.book.Id) { (success) in
                DispatchQueue.main.async{
                    completion(success)
                }
            }
        }
    }
    
    func CanBeBorrowed(from userId:String) -> Bool {
        //TODO
        return true;
    }
}
