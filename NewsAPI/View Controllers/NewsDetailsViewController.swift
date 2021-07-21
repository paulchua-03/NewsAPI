//
//  NewsDetailsViewController.swift
//  NewsAPI
//
//  Created by Paul Angelo Chua on 7/21/21.
//  Copyright © 2021 Paul Angelo Chua. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class NewsDetailsViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var urlImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    // MARK: - VARIABLES
    var article: Article?
        
    // MARK: - MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        displayData()
    }
    
    // MARK: - FUNCTIONS
    func displayData() {
        // Set UI properties        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 398, height: 150), scaleMode: .fill)
        urlImageView?.sd_setImage(with: URL(string: self.article?.urlToImage ?? ""), placeholderImage: nil, options: SDWebImageOptions.refreshCached, context: [.imageTransformer
            : transformer])
        titleLabel?.text = self.article?.title ?? ""
        authorLabel?.text = self.article?.author ?? ""
        publishedAtLabel?.text = self.article?.publishedAt ?? ""
        contentsLabel?.text = self.article?.content ?? ""
        urlLabel?.text = self.article?.url ?? ""
    }
    
}
