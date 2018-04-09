//
//  AddNewBookViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 08/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class AddNewBookViewModel:NSObject{
    var apiClient : ApiClientBooks = ApiClientBooks()
    var book: Book!
    
    init(book:Book){
        self.book = book
    }
    
    func GetTile()->String{
        return self.book.Title
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
    
    func AddBook(completion:@escaping (Bool,String?)->Void){
        var authorsStrings = [String]()
        if let authors = book.Authors{
            for author in authors{
                authorsStrings.append(author.FullName)
            }
        }
        apiClient.AddNewBookToLibrary(title: book.Title, year: book.Year, publisher: book.Publisher, authors: authorsStrings, cover: book.CoverUrl) { (ok, msg) in
            DispatchQueue.main.async {
                completion(ok,msg)
            }
        }
    }
    
    func SetNew(title:String)
    {
        self.book.Title = title
    }
    
    func SetNew(authors:String){
        book.Authors = [Author]()
        let authorsArr = authors.components(separatedBy: ",")
        for authorStr in authorsArr{
            book.Authors?.append(Author(fullname: authorStr))
        }
    }
}
