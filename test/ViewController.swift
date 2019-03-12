import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var searchResults = [SearchItem]()
    private let searcher = DataSearcher()

    private var tableView: UITableView!
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return progressView
    }()
    
    private let containerViewForLabel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let containerViewForButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let containerViewForProgressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Google Search", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        let cornerRadiusForButton = CGFloat(10)
        button.layer.cornerRadius = cornerRadiusForButton
        return button
    }()
    
    private let searchLabel: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.placeholder = "Search..."
        let fontSizeForlabel = CGFloat(18)
        label.font = UIFont.systemFont(ofSize: fontSizeForlabel)
        return label
    }()
    
    private let topLineForSearchLabel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()
    
    private let bottomLineForSearchLabel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()
    
    private let bottomLineForSearchButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()

    override func viewDidLoad(){
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews(){
        setupTableView()
        setupSearchLabel()
        setupSearchButton()
        setupTableView()
        setupProgressView()
        setupContainerViews()
    }
    
    private func setupContainerViews(){
        view.backgroundColor = UIColor.white
        view.addSubview(containerViewForLabel)
        view.addSubview(containerViewForButton)
        view.addSubview(containerViewForProgressView)
        view.addSubview(tableView)
        
        createContainerViewForLabelConstraints()
        createContainerViewForButtonConstraints()
        createContainerViewForProgressViewConstraints()
        createTableViewConstraints()
    }
    
    private func createContainerViewForLabelConstraints(){
        let window = UIApplication.shared.windows[0]
        let topOffset = window.safeAreaInsets.top
        let bottomOffset = window.safeAreaInsets.bottom
        let labelHeight = CGFloat(40)
        containerViewForLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        containerViewForLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        containerViewForLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        containerViewForLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset).isActive = true
    }
    
    private func createContainerViewForButtonConstraints(){
        containerViewForButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        containerViewForButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        containerViewForButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        containerViewForButton.topAnchor.constraint(equalTo: containerViewForLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    private func createContainerViewForProgressViewConstraints(){
        let height = CGFloat(2)
        let offset = CGFloat(1)
        containerViewForProgressView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        containerViewForProgressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        containerViewForProgressView.heightAnchor.constraint(equalToConstant: height).isActive = true
        containerViewForProgressView.topAnchor.constraint(equalTo: containerViewForButton.bottomAnchor, constant: offset).isActive = true
    }
    
    private func createTableViewConstraints(){
        let window = UIApplication.shared.windows[0]
        let topOffset = CGFloat(1)
        let bottomOffset = window.safeAreaInsets.bottom
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: containerViewForProgressView.bottomAnchor, constant: topOffset).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomOffset).isActive = true
    }
    
    private func setupSearchLabel(){
        searchLabel.delegate = self
        containerViewForLabel.addSubview(topLineForSearchLabel)
        containerViewForLabel.addSubview(searchLabel)
        containerViewForLabel.addSubview(bottomLineForSearchLabel)
        
        topLineForSearchLabel.topAnchor.constraint(equalTo: containerViewForLabel.topAnchor, constant: 0).isActive = true
        topLineForSearchLabel.rightAnchor.constraint(equalTo: containerViewForLabel.rightAnchor, constant: 0).isActive = true
        topLineForSearchLabel.leftAnchor.constraint(equalTo: containerViewForLabel.leftAnchor, constant: 0).isActive = true
        let heightForLine = CGFloat(1)
        topLineForSearchLabel.heightAnchor.constraint(equalToConstant: heightForLine).isActive = true
        
        let horizontalOffset = CGFloat(20)
        searchLabel.leftAnchor.constraint(equalTo: containerViewForLabel.leftAnchor, constant: horizontalOffset).isActive = true
        searchLabel.rightAnchor.constraint(equalTo: containerViewForLabel.rightAnchor, constant: -horizontalOffset).isActive = true
        searchLabel.topAnchor.constraint(equalTo: topLineForSearchLabel.bottomAnchor, constant: 0).isActive = true
        let heightForLabel = CGFloat(38)
        searchLabel.heightAnchor.constraint(equalToConstant: heightForLabel).isActive = true
        
        bottomLineForSearchLabel.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 0).isActive = true
        bottomLineForSearchLabel.leftAnchor.constraint(equalTo: containerViewForLabel.leftAnchor, constant: 0).isActive = true
        bottomLineForSearchLabel.rightAnchor.constraint(equalTo: containerViewForLabel.rightAnchor, constant: 0).isActive = true
        bottomLineForSearchLabel.heightAnchor.constraint(equalToConstant: heightForLine).isActive = true
    }
    
    private func setupSearchButton(){
        searchButton.addTarget(target, action: #selector(searchButtonPressed), for: .touchDown)
        containerViewForButton.addSubview(searchButton)
        containerViewForButton.addSubview(bottomLineForSearchButton)
        
        let topOffsetForButton = CGFloat(2)
        searchButton.topAnchor.constraint(equalTo: containerViewForButton.topAnchor, constant: topOffsetForButton).isActive = true
        let horizontalOffset = CGFloat(70)
        searchButton.leftAnchor.constraint(equalTo: containerViewForButton.leftAnchor, constant: horizontalOffset).isActive = true
        searchButton.rightAnchor.constraint(equalTo: containerViewForButton.rightAnchor,
                                            constant: -horizontalOffset).isActive = true
        let buttonHeight = CGFloat(38)
        searchButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        let topOffsetForLine = CGFloat(2)
        bottomLineForSearchButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: topOffsetForLine).isActive = true
        bottomLineForSearchButton.leftAnchor.constraint(equalTo: containerViewForButton.leftAnchor, constant: 0).isActive = true
        bottomLineForSearchButton.rightAnchor.constraint(equalTo: containerViewForButton.rightAnchor, constant: 0).isActive = true
        let heightForLine = CGFloat(1)
        bottomLineForSearchButton.heightAnchor.constraint(equalToConstant: heightForLine).isActive = true
    }
    
    private func setupProgressView(){
        containerViewForProgressView.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: containerViewForProgressView.topAnchor, constant: 0).isActive = true
        progressView.leftAnchor.constraint(equalTo: containerViewForProgressView.leftAnchor, constant: 0).isActive = true
        progressView.rightAnchor.constraint(equalTo: containerViewForProgressView.rightAnchor, constant: 0).isActive = true
        progressView.bottomAnchor.constraint(equalTo: containerViewForProgressView.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: view.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResult")
        view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numOfSections = 1
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForRow = CGFloat(60)
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchResult", for: indexPath) as! SearchResultCell
            cell.item = searchResults[indexPath.item]
            return cell
    }

    private func changeButtonState(){
        if searchButton.backgroundColor == UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1){
            progressView.isHidden = false
            searchButton.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            searchButton.setTitle("Stop", for: .normal)
        }
        else{
            progressView.isHidden = true
            searcher.cancelAllOperations()
            searchButton.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            searchButton.setTitle("Search Google", for: .normal)
        }
    }
    
    private func hideKeyboard(){
        searchLabel.resignFirstResponder()
    }
    
    private func loadSearchResults(text: String){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global().async {
            if let results = self.searcher.searchRequest(text: text){
                self.searchResults = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.changeButtonState()
                }
                dispatchGroup.leave()
            }
            else{
                DispatchQueue.main.async {
                    self.searchResults.removeAll()
                    self.tableView.reloadData()
                    self.changeButtonState()
                    self.showToast(message: "error fetching data")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
    }
    
     @objc private func searchButtonPressed(){
        if let text = searchLabel.text{
            if text != ""{
                changeButtonState()
                hideKeyboard()
                loadSearchResults(text: text)
            }
            else{
                searchResults.removeAll()
                tableView.reloadData()
                showToast(message: "Enter text")
            }
        }
        else{
            return
        }
    }
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonPressed()
        searchLabel.resignFirstResponder()
        return true
    }
    
}


