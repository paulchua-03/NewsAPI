//
//  APIHandler.swift
//  NewsAPI
//
//  Created by Paul Angelo Chua on 7/21/21.
//  Copyright © 2021 Paul Angelo Chua. All rights reserved.
//

import Foundation

class APIHandler {
    
    // MARK: - VARIABLES
    typealias completionBlock = ([Article]) -> ()
    
    // MARK: - FUNCTIONS
    func getAPIRequest(withUrl url: String, completionBlock: @escaping completionBlock) {
        if let apiUrl = URL(string: url) {
            // Perform API request
            URLSession.shared.dataTask(with: apiUrl, completionHandler: { (data, response, error) in
                if data != nil {
                    do {
                        // Decode data response to News model
                        let news = try JSONDecoder().decode(News.self, from: data!)
                        // Get array of Article models
                        let articleArray = news.articles
                        
                        if articleArray != nil {
                            completionBlock(articleArray)
                        } else {
                            let tmpArray = [Article]()
                            completionBlock(tmpArray)
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    let tmpArray = [Article]()
                    completionBlock(tmpArray)
                }
            }).resume()
        }
    }
    
    
}
