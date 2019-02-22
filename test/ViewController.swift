import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchResults = [Item]()
    var operationQueue = OperationQueue()

    var tableView: UITableView!
    
    var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return progressView
    }()
    
    let containerViewForLabel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let containerViewForButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let containerViewForProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Google Search", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let searchLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "Search..."
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let topLineForSearchLabel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()
    
    let bottomLineForSearchLabel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()
    
    let bottomLineForSearchButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()

    override func viewDidLoad(){
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews(){
        setupSearchLabel()
        setupSearchButton()
        setupTableView()
        setupProgressView()
        setupContainerViews()
    }
    
    func setupContainerViews(){
        view.backgroundColor = UIColor.white
        view.addSubview(containerViewForLabel)
        view.addSubview(containerViewForButton)
        view.addSubview(containerViewForProgressView)
        view.addSubview(tableView)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: containerViewForLabel)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: containerViewForButton)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: containerViewForProgressView)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: tableView)
        let window = UIApplication.shared.windows[0]
        let topOffset = window.safeAreaInsets.top
        let bottomOffset = window.safeAreaInsets.bottom
        view.addConstraintWithFormat(format: "V:|-\(topOffset)-[v0(40)][v1(42)]-1-[v2(2)]-1-[v3]-\(bottomOffset)-|", views: containerViewForLabel, containerViewForButton, containerViewForProgressView,tableView)
    }
    
    func setupSearchLabel(){
        searchLabel.delegate = self
        containerViewForLabel.addSubview(topLineForSearchLabel)
        containerViewForLabel.addSubview(searchLabel)
        containerViewForLabel.addSubview(bottomLineForSearchLabel)
        containerViewForLabel.addConstraintWithFormat(format: "H:|[v0]|", views: topLineForSearchLabel)
        containerViewForLabel.addConstraintWithFormat(format: "H:|-20-[v0]-20-|", views: searchLabel)
        containerViewForLabel.addConstraintWithFormat(format: "H:|[v0]|", views: bottomLineForSearchLabel)
        containerViewForLabel.addConstraintWithFormat(format: "V:|[v0(1)][v1(38)][v2(1)]|", views: topLineForSearchLabel,searchLabel,bottomLineForSearchLabel)
    }
    
    func setupSearchButton(){
        searchButton.addTarget(target, action: #selector(searchButtonPressed), for: .touchDown)
        containerViewForButton.addSubview(searchButton)
        containerViewForButton.addSubview(bottomLineForSearchButton)
        containerViewForButton.addConstraintWithFormat(format: "H:|-70-[v0]-70-|", views: searchButton)
        containerViewForButton.addConstraintWithFormat(format: "H:|[v0]|", views: bottomLineForSearchButton)
        containerViewForButton.addConstraintWithFormat(format: "V:|-2-[v0(38)]-2-[v1(1)]|", views: searchButton,bottomLineForSearchButton)
    }
    
    func setupProgressView(){
        containerViewForProgressView.addSubview(progressView)
        containerViewForProgressView.addConstraintWithFormat(format: "H:|[v0]|", views: progressView)
        containerViewForProgressView.addConstraintWithFormat(format: "V:|[v0]|", views: progressView)
    }
    
    func setupTableView(){
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResult")
        view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchResult", for: indexPath) as! SearchResultCell
            cell.item = searchResults[indexPath.item]
            return cell
    }

    func searchRequest(text: String){
        let urlAdress = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBsnPhX_EwlimkglxKpjJe99lHBydcHuDs&cx=012395726208297425069:_np83nffj40&q=\(text)"
        if let url = URL(string: urlAdress){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data{
                    let operation = {
                            OperationQueue.main.addOperation {
                                self.searchResults.removeAll()
                                self.tableView.reloadData()
                                self.progressView.setProgress(0.4, animated: true)
                            }
                            do{
                                let json = try(JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()))
                                let loadedData = json as? Dictionary<String, Any>
                                let items = loadedData!["items"] as? [Dictionary<String,Any>]
                                for item in items!{
                                    let newItem = Item(url: item["formattedUrl"] as! String, title: item["title"] as! String)
                                    self.searchResults.append(newItem)
                                    OperationQueue.main.addOperation {
                                        self.progressView.setProgress(0.7, animated: true)
                                        self.tableView.reloadData()
                                    }
                                }
                            }catch let error{
                                print(error)
                                return
                            }
                    }
                    self.operationQueue.addOperation(operation) 
                    self.operationQueue.waitUntilAllOperationsAreFinished()
                    OperationQueue.main.addOperation {
                        self.progressView.setProgress(1, animated: true)
                        self.progressView.isHidden = true
                        self.changeButtonState()
                    }
                }
                else{
                    self.showToast(message: "No results")
                }
            }).resume()
        }
        else{
            progressView.isHidden = true
            showToast(message: "Error")
            changeButtonState()
            searchResults.removeAll()
            tableView.reloadData()
            return
        }
    }
    
    func changeButtonState(){
        if searchButton.backgroundColor == UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1){
            searchButton.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            searchButton.setTitle("Stop", for: .normal)
        }
        else{
            operationQueue.cancelAllOperations()
            URLSession.shared.invalidateAndCancel()
            OperationQueue.main.cancelAllOperations()
            searchButton.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            searchButton.setTitle("Search Google", for: .normal)
        }
    }
    
    func hideKeyboard(){
        searchLabel.resignFirstResponder()
    }
    
    @objc func searchButtonPressed(){
        if let text = searchLabel.text{
            if text != ""{
                changeButtonState()
                hideKeyboard()
                searchRequest(text: text)
                progressView.isHidden = false
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


