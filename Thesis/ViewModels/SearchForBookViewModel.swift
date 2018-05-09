//
//  SearchForBookViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 07/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
class SearchForBookViewModel:NSObject{
    var results : [Book]?
    @IBOutlet var apiClient : ApiClientBooks!
    func Search(query:String,completion:@escaping ()->Void){
        apiClient.Search(by: query) { (books) in
            DispatchQueue.main.async {
                self.results = books
                completion()
            }
        }
    }
    
    func GetCount()->Int{
        return self.results?.count ?? 0
    }
    
    func GetBookId(for indexPath:IndexPath) -> UUID?{
        return self.results?[indexPath.row].Id ?? nil
    }
    
    func GetTitleAndAuthor(for indexPath:IndexPath) -> String{
        if let book = self.results?[indexPath.row]{
            return book.Title + ", " + self.GetAuthorsNames(for:indexPath)
        }
        return ""
    }
    
    private func GetAuthorsNames(for indexPath:IndexPath) -> String{
        var names = ""
        let book = self.results?[indexPath.row]
        for author in book!.Authors!{
            names += author.FullName + ","
        }
        if !names.isEmpty{
            let indexOfEnd = names.index(names.endIndex, offsetBy: -1)
            return String(names[..<indexOfEnd])
        }
        return ""
    }
    
    func BookCoverToDisplay(for indexPath:IndexPath) -> UIImage {
        if let cover = self.results?[indexPath.row].Cover{
            return UIImage(data:cover as Data)!
        }
        return UIImage(named: "default_cover")!
    }
    
    func GetBook(by id:UUID) -> Book{
        return (self.results?.first(where: { (book) -> Bool in
            book.Id==id
        }))!
    }
    
    func SendToOCRApi(image: UIImage, completion:@escaping (String?) -> Void){
        apiClient.CallOCR(imageData: UIImagePNGRepresentation(image)! as NSData) { (result) in
            if let text = result {
                let test = String(text.filter { !"\r\n".contains($0) })
                completion(test)
            }else{
                completion(result)
            }
        }
    }
}
