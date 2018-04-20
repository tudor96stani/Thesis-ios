//
//  MyLibraryViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
class MyLibraryViewModel:NSObject{
    var books:[Book]?
    @IBOutlet var apiClient: ApiClientBooks!
    
    func GetBooks(UserId: UUID,completion: @escaping() -> Void)
    {
        apiClient.GetLibrary(for: UserId) { (books) in
            DispatchQueue.main.async {
                self.books = books
                completion()
            }
        }
    }
    
    func NumberOfItemsToDisplay(in section: Int)->Int
    {
        return books?.count ?? 0;
    }
    
    func BookTitleToDisplay(for indexPath: IndexPath)->String
    {
        return books?[indexPath.row].Title ?? "";
    }
    
    func BookAuthorToDisplay(for indexPath: IndexPath)->String{
        var authors = "";
        for author in (self.books?[indexPath.row].Authors)!{
            authors.append(author.FullName + " ")
        }
        return authors
    }
    
    func BookCoverToDisplay(for indexPath:IndexPath) -> UIImage {
        if let cover = self.books?[indexPath.row].Cover{
            return UIImage(data:cover as Data)!
        }
        return UIImage(named: "default_cover")!
    }
    
    func GetSource(for indexPath:IndexPath) -> String {
        var source = ""
        if let book = self.books?[indexPath.row] {
            if book.Borrowed{
                source = "Borrowed from " + book.BorrowedFrom.Username
            }
            else if book.Lent{
                source = "Lent to " + book.LentTo.Username
            }
            else{
                source = "In library"
            }
        }
        return source
    }
    
    func GetNumberOfBorrowRequests(completion:@escaping (Int) -> Void){
        apiClient.GetNumberOfBorrowRequest { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
//    func FindBookDetailsViewModel(for indexPath: IndexPath) -> BookDetailsViewModel?
//    {
//        if let book = books?[indexPath.row]
//        {
//            let viewmodel = BookDetailsViewModel(b:book)
//            return viewmodel
//        }
//        return nil
//    }
}
