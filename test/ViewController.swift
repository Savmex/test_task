import UIKit
import Foundation

/*
 protocol ViewControllerProtocol
 задает интерфейс для ViewController
 */

protocol ViewControllerProtocol{
    var searchLabel: UITextField{get set}
    var searchButton: UIButton {get set}
    var tableView: UITableView!{get set}
    var searchResults: [SearchItem] {get set}
    func setUpViews()
}

/*
 class ViewController:
 предназначен для отображения элементов основного окна приложения
 член класса searchResults является public т.к он соответствует протоколу ViewControllerProtocol
 методы tableView являются public т.к они соответствуют протоколам UITableViewDelegate и UITableViewDataSource
 метод textFieldShouldReturn является public т.к соответствует протоколу UITextFieldDelegate
 метод setUpViews является public т.к он унаследован от интерфейса ViewControllerProtocol
 члены tableView,progressView,searchButton,searchLabel являются public т.к они унаследованы от интерфейса ViewControllerProtocol
*/

class ViewController: UIViewController, ViewControllerProtocol, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var searchResults = [SearchItem]()
    private let searcher = DataSearcher()
    private let errorMessages = ErrorMessages()
    private let heightsAndOffsets = HeightsAndOffsetsForVCElements()
    private let cellIdentifier = "searchResult"
    
    var tableView: UITableView!
    
    var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = ColorsForViewControllerElements.colors.colorForProgressViewProgress
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
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(SearchButtonStatesTitles.titles.titleForNormalState, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = ColorsForViewControllerElements.colors.colorForNormalButtonState
        button.layer.cornerRadius = CGFloat(10)
        return button
    }()
    
    var searchLabel: UITextField = {
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
        view.backgroundColor = ColorsForViewControllerElements.colors.colorForSeparatingLines
        return view
    }()
    
    private let bottomLineForSearchLabel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorsForViewControllerElements.colors.colorForSeparatingLines
        return view
    }()
    
    private let bottomLineForSearchButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorsForViewControllerElements.colors.colorForSeparatingLines
        return view
    }()

    override func viewDidLoad(){
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews(){
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
        let topOffset = heightsAndOffsets.topOffsetForLabelContainerView
        let labelHeight = heightsAndOffsets.heightForLabelContainerView
        containerViewForLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        containerViewForLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        containerViewForLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        containerViewForLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset).isActive = true
    }

    private func createContainerViewForButtonConstraints(){
        containerViewForButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        containerViewForButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        let height = heightsAndOffsets.heightForButtonContainerView
        containerViewForButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        containerViewForButton.topAnchor.constraint(equalTo: containerViewForLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    private func createContainerViewForProgressViewConstraints(){
        containerViewForProgressView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        containerViewForProgressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        let height = heightsAndOffsets.heightForProgressViewContainerView
        containerViewForProgressView.heightAnchor.constraint(equalToConstant: height).isActive = true
        let offset = heightsAndOffsets.topOffsetForProgressViewContainerView
        containerViewForProgressView.topAnchor.constraint(equalTo: containerViewForButton.bottomAnchor, constant: offset).isActive = true
    }
    
    private func createTableViewConstraints(){
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: 0).isActive = true
        let topOffset = heightsAndOffsets.topOffsetForTableView
        tableView.topAnchor.constraint(equalTo: containerViewForProgressView.bottomAnchor, constant: topOffset).isActive = true
        let bottomOffset = heightsAndOffsets.bottomOffsetForTableView
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
        let heightForLine = heightsAndOffsets.heightForSeparatingLines
        topLineForSearchLabel.heightAnchor.constraint(equalToConstant: heightForLine).isActive = true
        
        let horizontalOffset = heightsAndOffsets.horizontalOffsetForLabel
        searchLabel.leftAnchor.constraint(equalTo: containerViewForLabel.leftAnchor, constant: horizontalOffset).isActive = true
        searchLabel.rightAnchor.constraint(equalTo: containerViewForLabel.rightAnchor, constant: -horizontalOffset).isActive = true
        searchLabel.topAnchor.constraint(equalTo: topLineForSearchLabel.bottomAnchor, constant: 0).isActive = true
        let heightForLabel = heightsAndOffsets.heightForSearchLabel
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
        
        let topOffsetForButton = heightsAndOffsets.topOffsetForSearchButton
        searchButton.topAnchor.constraint(equalTo: containerViewForButton.topAnchor, constant: topOffsetForButton).isActive = true
        let horizontalOffset = heightsAndOffsets.horizontalOffsetForSearchButton
        searchButton.leftAnchor.constraint(equalTo: containerViewForButton.leftAnchor, constant: horizontalOffset).isActive = true
        searchButton.rightAnchor.constraint(equalTo: containerViewForButton.rightAnchor,
                                            constant: -horizontalOffset).isActive = true
        let buttonHeight = heightsAndOffsets.heightForSearchButton
        searchButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        let topOffsetForLine = heightsAndOffsets.bottomOffsetForSearchButton
        bottomLineForSearchButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: topOffsetForLine).isActive = true
        bottomLineForSearchButton.leftAnchor.constraint(equalTo: containerViewForButton.leftAnchor, constant: 0).isActive = true
        bottomLineForSearchButton.rightAnchor.constraint(equalTo: containerViewForButton.rightAnchor, constant: 0).isActive = true
        let heightForLine = heightsAndOffsets.heightForSeparatingLines
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
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: cellIdentifier)
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
        let heightForRow = heightsAndOffsets.heightForTableViewRow
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchResultCell
            cell.item = searchResults[indexPath.item]
            return cell
    }

    private func changeButtonState(){
        if searchButton.backgroundColor == ColorsForViewControllerElements.colors.colorForNormalButtonState{
            progressView.isHidden = false
            searchButton.backgroundColor = ColorsForViewControllerElements.colors.colorForPressedButtonState
            searchButton.setTitle(SearchButtonStatesTitles.titles.titleForPressedState, for: .normal)
        }
        else{
            progressView.isHidden = true
            searcher.cancelAllOperations()
            searchButton.backgroundColor = ColorsForViewControllerElements.colors.colorForNormalButtonState
            searchButton.setTitle(SearchButtonStatesTitles.titles.titleForNormalState, for: .normal)
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
                    self.showToast(message: self.errorMessages.errorGettingData)
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
                showToast(message: errorMessages.noTextInLabelError)
            }
        }
        else{
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonPressed()
        searchLabel.resignFirstResponder()
        return true
    }
    
    private func showToast(message : String) {
        let width = heightsAndOffsets.widthForToastMessage
        let height = heightsAndOffsets.heightForSeparatingLines
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: width, height: height))
        toastLabel.backgroundColor = ColorsForViewControllerElements.colors.colorForToastMessageBackground
        toastLabel.textColor = ColorsForViewControllerElements.colors.colorForToastMessageText
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

