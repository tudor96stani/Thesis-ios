//
//  MyLibraryViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
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
            authors.append(author.FirstName + " " + author.LastName + " ")
        }
        return authors
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
