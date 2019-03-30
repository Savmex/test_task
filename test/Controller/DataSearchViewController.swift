import UIKit
import Foundation
import CoreData

/**
 
 The ViewController class defines the shared behavior that is common to all view controllers.
 Used to display main app window.
 Main responsibilities:
    - In response to dataSearcher, updating the contents of the views:
        - labelView
        - buttonView
        - progressView
        - tableView
    - Responding to user interactions views.
    - Сoordinating with:
        - dataSearcher
        - toastMessageView
        - errorMessages
 */

class DataSearchViewController: UIViewController{
    
    private var searcher: DataSearcher!
    private var errorMessages: ErrorMessages!
    private var toastMessageView: ToastMessageView!

    /**
     The labelView object managed by current controller.
    */
    @IBOutlet weak var labelView: LabelView!
    
    /**
     The buttonView object managed by current controller.
     */
    @IBOutlet weak var buttonView: ButtonView!
    
    /**
     The progressView object managed by current controller.
     */
    @IBOutlet weak var progressView: LoadingProgressView!
    
    /**
     The tableView object managed by current controller.
     */
    @IBOutlet weak var tableView: ResultsTableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initComponents()
        setUpViews()
        
    }
    
    private func initComponents(){
        searcher = DataSearcher()
        errorMessages = ErrorMessages()
        toastMessageView = ToastMessageView(frame: CGRect.null)
    }
    
    private func setUpViews(){
        labelView.target = self
        buttonView.targetForButton = self
    }

    private func loadSearchResults(text: String){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global().async {
            if let results = self.searcher.searchRequest(text: text){
                self.tableView.setSearchResults(results: results)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.buttonView.changeButtonState()
                    self.progressView.setLoadingDataProgressValue()
                    self.progressView.isProgressViewHidden(true)
                }
                dispatchGroup.leave()
            }
            else{
                DispatchQueue.main.async {
                    self.tableView.removeAllSearchResults()
                    self.tableView.reloadData()
                    self.buttonView.changeButtonState()
                    self.toastMessageView.showToast(message: self.errorMessages.errorGettingData, controller: self)
                    self.progressView.isProgressViewHidden(true)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
    }
    
    /**
     Respond to request from labelView or ButtonView. If there is any text in labelView, initiates the request with the parameter in labelView.
     - parameters:
        - action: parameter of enum Action to choose the way to act
    */
    
    func searchButtonPressed(action: Action){
        switch action {
        case .start:
            labelView.resignFirstResponder()
            if let text = labelView.getLabelText(){
                if text != ""{
                    loadSearchResults(text: text)
                    progressView.isProgressViewHidden(false)
                    progressView.setStartLoadingProgressValue()
                    buttonView.changeButtonState()
                }
                else{
                    tableView.removeAllSearchResults()
                    tableView.reloadData()
                    toastMessageView.showToast(message: errorMessages.noTextInLabelError , controller: self)
                }
            }
        case .finish:
            labelView.removeLabelText()
            tableView.removeAllSearchResults()
            tableView.reloadData()
            searcher.cancelAllOperations()
        }
    }
}




