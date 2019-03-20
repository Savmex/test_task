import UIKit
import Foundation

/*
 class ViewController:
 предназначен для отображения элементов основного окна приложения
*/

class ViewController: UIViewController{
    
    private let searcher = DataSearcher()
    private let errorMessages = ErrorMessages()
    private let heightsAndOffsets = HeightsAndOffsetsForVCElements()
    
    private let numOfsections = 1
    
    private let toastMessageParameters = ToastMessageParameters()
    
    private let searchLabelView = SearchLabelView()
    private let searchButtonView = SearchButtonView()
    private let progressView = SearchProgressView()
    private var tableView = SearchTableView()
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setUpViews()
    }
    
    private func setUpViews(){
        view.backgroundColor = UIColor.white
        view.addSubview(searchLabelView)
        searchLabelView.target = self
        view.addSubview(searchButtonView)
        searchButtonView.targetForButton = self
        view.addSubview(progressView)
        view.addSubview(tableView)
        
        createSearchLabelConstraints()
        createSearchButtonConstraints()
        createSearchProgressViewConstraints()
        createTableViewConstraints()
        
    }

    private func createSearchLabelConstraints(){
        let topOffset = heightsAndOffsets.topOffsetForLabelView
        searchLabelView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        searchLabelView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        searchLabelView.topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset).isActive = true
        let labelHeight = heightsAndOffsets.heightForLabelView
        searchLabelView.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
    }

    private func createSearchButtonConstraints(){
        searchButtonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        searchButtonView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        let height = heightsAndOffsets.heightForButtonView
        searchButtonView.heightAnchor.constraint(equalToConstant: height).isActive = true
        searchButtonView.topAnchor.constraint(equalTo: searchLabelView.bottomAnchor, constant: 0).isActive = true
    }
    
    private func createSearchProgressViewConstraints(){
        progressView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        let height = heightsAndOffsets.heightForProgressView
        progressView.heightAnchor.constraint(equalToConstant: height).isActive = true
        let offset = heightsAndOffsets.topOffsetForProgressView
        progressView.topAnchor.constraint(equalTo: searchButtonView.bottomAnchor, constant: offset).isActive = true
    }
    
    private func createTableViewConstraints(){
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: 0).isActive = true
        let topOffset = heightsAndOffsets.topOffsetForTableView
        tableView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: topOffset).isActive = true
        let bottomOffset = heightsAndOffsets.bottomOffsetForTableView
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomOffset).isActive = true
    }
    
    private func loadSearchResults(text: String){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global().async {
            if let results = self.searcher.searchRequest(text: text){
                self.tableView.setSearchResults(results: results)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchButtonView.changeButtonState()
                    self.progressView.setLoadingDataProgressValue()
                    self.progressView.isProgressViewHidden(true)
                }
                dispatchGroup.leave()
            }
            else{
                DispatchQueue.main.async {
                    self.tableView.removeAllSearchResults()
                    self.tableView.reloadData()
                    self.searchButtonView.changeButtonState()
                    self.showToast(message: self.errorMessages.errorGettingData)
                    self.progressView.isProgressViewHidden(true)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
    }
    
    /*
        функция searchButtonPressed,принимает значение enum Action и вызывает функцию обрабатывающую запрос по заданному критерию, является internal т.к вызывается классом SearchButtonView для реагирования на нажатие кнопки
     
    */
    func searchButtonPressed(action: Action){
        switch action {
        case .start:
            searchLabelView.resignFirstResponder()
            if let text = searchLabelView.getSearchLabelText(){
                if text != ""{
                    loadSearchResults(text: text)
                    progressView.isProgressViewHidden(false)
                    progressView.setStartLoadingProgressValue()
                    searchButtonView.changeButtonState()
                }
                else{
                    tableView.removeAllSearchResults()
                    tableView.reloadData()
                    showToast(message: errorMessages.noTextInLabelError)
                }
            }
        case .finish:
            searchLabelView.removeLabelText()
            tableView.removeAllSearchResults()
            tableView.reloadData()
            searcher.cancelAllOperations()
        }
    }
    
    private func showToast(message : String) {
        let width = toastMessageParameters.widthForToastMessage
        let height = toastMessageParameters.heightForToastMessage
        let x = toastMessageParameters.getX(width: view.bounds.width)
        let y = toastMessageParameters.getY(height: view.bounds.height)
        let toastLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        toastLabel.backgroundColor = ColorsForViewControllerElements.colors.colorForToastMessageBackground
        toastLabel.textColor = ColorsForViewControllerElements.colors.colorForToastMessageText
        toastLabel.textAlignment = .center;
        let fontName = toastMessageParameters.fontNameForToastMessage
        let fontSize = toastMessageParameters.fontSizeForToastMessage
        toastLabel.font = UIFont(name: fontName, size: fontSize)
        toastLabel.text = message
        let alpha = toastMessageParameters.toastLabelAlpha
        toastLabel.alpha = alpha
        toastLabel.layer.cornerRadius = toastMessageParameters.toastMessageCornerRadius;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        let duration = toastMessageParameters.animationDuration
        let delay = toastMessageParameters.delay
        let options = toastMessageParameters.options
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            toastLabel.alpha = self.toastMessageParameters.toastLabelAlphaAtStartOfAnimation
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}




