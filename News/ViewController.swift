//
//  ViewController.swift
//  News
//
//  Created by Bogdan Mishura on 9/11/19.
//  Copyright © 2019 Bogdan Mishura. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    private var newsListVM: NewsListViewModel!
    
    private var refreshControl: UIRefreshControl?
    
    private var filteredNews = NewsListViewModel.init()
    
    @IBOutlet private weak var myTableView: UITableView!
    
   private var page = 1
    
   private let searchController = UISearchController(searchResultsController: nil)
    
   private let urlFiltered = ScopeButtonsFilter()
    
   private var urlFromScope = "https://newsapi.org/v2/everything?q=Apple&from=2019-09-11&sortBy=popularity&apiKey=feb88f4f27b745f1a0838027633f1cf3"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupRefreshControl()
        setupSearchController()
        setupScopeButtons()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData(fromPage: page, from: urlFromScope)
        
    }
    
    //MARK: - Get news
    private func fetchData(fromPage: Int, from url: String) {
        NetworkManager.shared.getNews(fromPage: String(fromPage), url: urlFromScope) { (articles) in
            if let articles = articles {
                switch fromPage {
                case 0...1:
                    self.newsListVM = NewsListViewModel(articlesArray: articles)
                case 2...100:
                    self.newsListVM.articlesArray += articles
                default:
                    break
                }
                print(self.newsListVM.articles.count)                
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
        
    }
    //MARK: - setupRefreshControl
   private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        myTableView.tableFooterView = UIView(frame: .zero)
        refreshControl?.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
        myTableView.refreshControl = refreshControl
        
    }
    //MARK: - refreshTableView
    @objc private func refreshTableView(sender: UIRefreshControl) {
        newsListVM = nil
        page = 1
        fetchData(fromPage: page, from: urlFromScope)
        myTableView.reloadData()
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
    //MARK: - create SFSafari view controller for detail news
   private func showSafariVC(url: String) {
        let url = URL(string: url)
        if let urlForWeb = url {
            let webVC = SFSafariViewController(url: urlForWeb)
            present(webVC, animated: true, completion: nil)
        }
    }
    //MARK: - setupSearchController
   private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Text for search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    //MARK: - setupScopeButtons
   private func setupScopeButtons() {
        searchController.searchBar.scopeButtonTitles = urlFiltered.type
        searchController.searchBar.delegate = self
    }
    
   private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
   private func filteredContentForSearchText(_ searchText: String, scope: String = "category") {
        filteredNews.articlesArray = newsListVM.articles.filter({ (news: ArticlesModel) -> Bool in
            if let filteredText = (news.description?.lowercased().contains(searchText.lowercased())) {
                return filteredText
            }
            return false
        })
        myTableView.reloadData()
    }
    
   private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredNews.numberOfRowsInSection(section)
        }
        return self.newsListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as?  MyTableViewCell else { fatalError("MyCell not found") }
        
        if isFiltering() {
            let filteredNewsVM = filteredNews.articleAtIndex(indexPath.row)
            cell.imageFromNews.image = nil
            cell.tag = indexPath.row
            cell.configure(for: filteredNewsVM, indexPath: indexPath)
            
        } else {
            let newsVM = self.newsListVM.articleAtIndex(indexPath.row)
            cell.imageFromNews.image = nil
            cell.tag = indexPath.row
            cell.configure(for: newsVM, indexPath: indexPath)
            
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.newsListVM == nil ? 0 : self.newsListVM.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsListVM.articles.count - 1 {
            page += 1
            fetchData(fromPage: page, from: urlFromScope)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            let urlFromFilteredNews = filteredNews.articles[indexPath.row].url
            if urlFromFilteredNews != nil {
                showSafariVC(url: urlFromFilteredNews!)
            }
            
        } else {
            let urlForSafari = newsListVM.articles[indexPath.row].url
            if urlForSafari != nil {
                showSafariVC(url: urlForSafari!)
            }
        }
    }
}

//MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text!)
    }
    
    
}

//MARK: - UISearchBarDelegate, changing news cat
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        urlFromScope = urlFiltered.scopeButtonsAndURLArr[selectedScope]
        newsListVM = nil
        page = 1
        fetchData(fromPage: page, from: urlFromScope)
        myTableView.reloadData()
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
}
