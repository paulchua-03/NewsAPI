//
//  NewsViewModel.swift
//  NewsAPI
//
//  Created by Paul Angelo Chua on 7/21/21.
//  Copyright © 2021 Paul Angelo Chua. All rights reserved.
//

import Foundation

class NewsViewModel {
    
    // MARK: - VARIABLES
    var apiHandler = APIHandler()
    var articleArray = [Article]()
    typealias completionBlock = ([Article]) -> ()

    // MARK: - FUNCTIONS
    func getDataFromAPIHandler(url: String, completionBlock: @escaping completionBlock) {
        // Call API Handler
        apiHandler.getAPIRequest(withUrl: url) { [weak self] (articles) in
            self?.articleArray = articles
            completionBlock(articles)
        }
    }
    
    func getNumberOfRowsInSection() -> Int {
        // Return Articles count
        return articleArray.count
    }
    
    func getArticleAtIndex(index: Int) -> Article {
        // Return Article object
        let article = articleArray[index]
        return article
    }
}
