//
//  NewsViewController.swift
//  NewsAPI
//
//  Created by Paul Angelo Chua on 7/20/21.
//  Copyright © 2021 Paul Angelo Chua. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK - IBOUTLETS
    @IBOutlet weak var countrySegmentedControl: UISegmentedControl!
    @IBOutlet weak var newsTableView: UITableView!
    
    // MARK - VARIABLES
    var newsArray: [NewsModel] = []
        
    // MARK - MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set Navigation Bar title
        self.title = Globals.appTitle
        
        // Set TableView methods
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        
        // Set selected Country name
        let countryIndex = self.countrySegmentedControl.selectedSegmentIndex
        guard let countryName = self.countrySegmentedControl.titleForSegment(at: countryIndex) else {
            return
        }
        guard let countryCode: String = getCountry(country: countryName) else {
            // Display error
            let alert = UIAlertController(title: Globals.appTitle, message: Errors.countrySelectionError, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Globals.close, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        print("Index: \(countryIndex)")
        print("Country: \(countryName)")
        
        // Call getNews function
        getNews(country: countryCode) { response, error in
            if (error == nil) {
                for article in response {
                    let newsModel = NewsModel(countryName: "US", title: article["title"].stringValue, description: article["description"].stringValue, imageUrl: article["urlToImage"].stringValue)
                    self.newsArray.append(newsModel)
                }
                self.newsTableView.reloadData()
            } else {
                // Display error
                let alert = UIAlertController(title: Globals.appTitle, message: Errors.getNewsFailed, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Globals.close, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
            
    }
    
    // MARK: - FUNCTIONS
    func getCountry(country: String) -> String {
        switch country {
            case "United States":
                return "us"
            case "Canada":
                return "ca"
            default:
                return "us"
        }
    }
    
    func getNews(country: String, completionHandler: @escaping ([JSON], NSError?) -> ()) {
        print("\(Globals.newsAPIUrl)country=\(country)&apikey=\(Globals.newsAPIKey)")
        sendRequest(url: "\(Globals.newsAPIUrl)country=\(country)&apikey=\(Globals.newsAPIKey)", completionHandler: completionHandler)
    }
    
    func sendRequest(url: String, completionHandler: @escaping ([JSON], NSError?) -> ()) {
        // Send GET News API request from server
        AF.request(url).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let responseJson = JSON(value)
                    print(responseJson)
                    completionHandler(responseJson["articles"].arrayValue, nil)
                case .failure(let error):
                    completionHandler([], error as NSError)
            }
        }
    }
    
    //MARK: - SEGMENTED CONTROL
    @IBAction func segmentControlPressed(_ sender: Any) {
        // Set selected Country name
        let countryIndex = self.countrySegmentedControl.selectedSegmentIndex
        guard let countryName = self.countrySegmentedControl.titleForSegment(at: countryIndex) else {
            return
        }
        guard let countryCode: String = getCountry(country: countryName) else {
            // Display error
            let alert = UIAlertController(title: Globals.appTitle, message: Errors.countrySelectionError, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Globals.close, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.newsArray = []
        
        // Call getNews function
        getNews(country: countryCode) { response, error in
            if (error == nil) {
                for article in response {
                    let newsModel = NewsModel(countryName: "US", title: article["title"].stringValue, description: article["description"].stringValue, imageUrl: article["urlToImage"].stringValue)
                    self.newsArray.append(newsModel)
                }
                self.newsTableView.reloadData()
            } else {
                // Display error
                let alert = UIAlertController(title: Globals.appTitle, message: Errors.getNewsFailed, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Globals.close, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - TABLE VIEW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set Custom Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for:  indexPath) as! NewsTableViewCell
        
        let newsModel = self.newsArray[indexPath.row]

        cell.articleTitleLabel?.text = newsModel.title
        cell.articleDescriptionLabel?.text = newsModel.description
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 120, height: 100), scaleMode: .fill)
        cell.articleImageView?.sd_setImage(with: URL(string: newsModel.imageUrl), placeholderImage: nil, options: SDWebImageOptions.refreshCached, context: [.imageTransformer
            : transformer])
            
        return cell
    }
    
}

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    
}
