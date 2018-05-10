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
    var borrowedBooks:[Book]?
    var lentBooks:[Book]?
    @IBOutlet var apiClient: ApiClientBooks!
    var dataFilter: TableViewFilterCategories = .All
    func GetBooks(UserId: UUID,completion: @escaping() -> Void)
    {
        apiClient.GetLibrary(for: UserId) { (books) in
            DispatchQueue.main.async {
                self.books = books
                self.borrowedBooks = books?.filter({ (book) -> Bool in
                    book.Borrowed
                })
                self.lentBooks = books?.filter({ (book) -> Bool in
                    book.Lent
                })
                completion()
            }
        }
    }
    
    func changeFilter(newCategory: Int) {
        switch newCategory{
        case 0:
            dataFilter = .All
        case 1:
            dataFilter = .Borrowed
        case 2:
            dataFilter = .Lent
        default:
            dataFilter = .All
        }
    }
    
    func NumberOfItemsToDisplay(in section: Int)->Int
    {
        switch dataFilter{
        case .All:
            return books?.count ?? 0;
        case .Borrowed:
            return borrowedBooks?.count ?? 0;
        case .Lent:
            return lentBooks?.count ?? 0;
        }
    }
    
    func BookTitleToDisplay(for indexPath: IndexPath)->String
    {
        switch dataFilter {
        case .All:
            return books?[indexPath.row].Title ?? "";
        case .Borrowed:
            return borrowedBooks?[indexPath.row].Title ?? "";
        case .Lent:
            return lentBooks?[indexPath.row].Title ?? "";
        }
        //return books?[indexPath.row].Title ?? "";
    }
    
    func BookAuthorToDisplay(for indexPath: IndexPath)->String{
        switch dataFilter {
        case .All:
            var authors = "";
            for author in (self.books?[indexPath.row].Authors)!{
                authors.append(author.FullName + " ")
            }
            return authors
        case .Borrowed:
            var authors = "";
            for author in (self.borrowedBooks?[indexPath.row].Authors)!{
                authors.append(author.FullName + " ")
            }
            return authors
        case .Lent:
            var authors = "";
            for author in (self.lentBooks?[indexPath.row].Authors)!{
                authors.append(author.FullName + " ")
            }
            return authors
        }
    }
    
    func BookCoverToDisplay(for indexPath:IndexPath) -> UIImage {
        switch dataFilter{
        case .All:
            if let cover = self.books?[indexPath.row].Cover{
                return UIImage(data:cover as Data)!
            }
            return UIImage(named: "default_cover")!
        case .Borrowed:
            if let cover = self.borrowedBooks?[indexPath.row].Cover{
                return UIImage(data:cover as Data)!
            }
            return UIImage(named: "default_cover")!
        case .Lent:
            if let cover = self.lentBooks?[indexPath.row].Cover{
                return UIImage(data:cover as Data)!
            }
            return UIImage(named: "default_cover")!
        }
        
        
    }
    
    func GetSource(for indexPath:IndexPath) -> String {
        switch dataFilter {
        case .All:
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
        case .Borrowed:
            var source = ""
            if let book = self.borrowedBooks?[indexPath.row] {
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
        case .Lent:
            var source = ""
            if let book = self.lentBooks?[indexPath.row] {
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
