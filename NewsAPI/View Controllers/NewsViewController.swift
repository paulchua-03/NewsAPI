//
//  NewsViewController.swift
//  NewsAPI
//
//  Created by Paul Angelo Chua on 7/20/21.
//  Copyright © 2021 Paul Angelo Chua. All rights reserved.
//

import UIKit
import SDWebImage

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var countrySegmentedControl: UISegmentedControl!
    @IBOutlet weak var newsTableView: UITableView!
    
    // MARK: - VARIABLES
    var newsViewModel = NewsViewModel()
    var selectedArticle: Article?
    
    // MARK: - MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set Navigation Bar title
        self.title = Globals.appTitle
        
        // Set TableView methods
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
                
        // Call getNewsViewModel function
        getNewsViewModel()
    }
    
    // MARK: - FUNCTIONS
    func getNewsViewModel() {
        // Set selected Country name
        let countryIndex = self.countrySegmentedControl.selectedSegmentIndex

        guard let countryName = self.countrySegmentedControl.titleForSegment(at: countryIndex) else {
            // Display error
            let alert = UIAlertController(title: Globals.appTitle, message: Errors.countrySelectionError, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Globals.close, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        guard let countryCode: String = getCountry(country: countryName) else {
            // Display error
            let alert = UIAlertController(title: Globals.appTitle, message: Errors.countrySelectionError, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Globals.close, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        newsViewModel.getDataFromAPIHandler(url: "\(Globals.newsAPIUrl)country=\(countryCode)&apikey=\(Globals.newsAPIKey)") { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.newsTableView.reloadData()
            }
        }
    }
    
    func getCountry(country: String) -> String {
        // Set Country code
        switch country {
            case "United States":
                return "us"
            case "Canada":
                return "ca"
            default:
                return "us"
        }
    }
    
    //MARK: - SEGMENTED CONTROL
    @IBAction func segmentControlPressed(_ sender: Any) {
        // Call getNewsViewModel function
        getNewsViewModel()
    }
    
    // MARK: - SEGUE
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newsDetailsViewController = segue.destination as? NewsDetailsViewController
            else {
                return
            }

        // Set NewsViewModel instance to NewsDetailsViewController
        newsDetailsViewController.article = self.selectedArticle
    }
    
    // MARK: - TABLE VIEW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected Article
        selectedArticle = newsViewModel.getArticleAtIndex(index: indexPath.row)
        
        // Perform navigation segue
        performSegue(withIdentifier: "newsDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set Custom Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for:  indexPath) as! NewsTableViewCell
        
        let newsModel = newsViewModel.getArticleAtIndex(index: indexPath.row)

        cell.articleTitleLabel?.text = newsModel.title
        cell.articleDescriptionLabel?.text =  newsModel.articleDescription
        let transformer = SDImageResizingTransformer(size: CGSize(width: 120, height: 100), scaleMode: .fill)
        cell.articleImageView?.sd_setImage(with: URL(string: newsModel.urlToImage ?? ""), placeholderImage: nil, options: SDWebImageOptions.refreshCached, context: [.imageTransformer
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
