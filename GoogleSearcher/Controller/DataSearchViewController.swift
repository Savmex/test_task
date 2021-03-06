import UIKit
import Foundation
import CoreData

/**
Special view controller for managing group of custom views.

Managing next custom views:
  - InputField
  - ButtonView
  - LoadingProgressView
  - ResultsTableView
 */

class DataSearchViewController: UIViewController, DataHandlerDelegate, DataHandlerDataSource{
    
    private var toastMessageView: ToastMessageView!
    
    @IBOutlet weak var inputField: InputField!
    
    @IBOutlet weak var buttonView: ButtonView!
    
    @IBOutlet weak var loadingProgressView: LoadingProgressView!
    
    @IBOutlet weak var resultsTableView: ResultsTableView!
    
    private let progrValueForLoadingInit: Float = 0.3
    private let progrValueForFinishLoading: Float = 1
    
    private let dataHandler = DataHandler()
    
    /**
     Handles additional initialization.
    */
    
    override func viewDidLoad(){
        super.viewDidLoad()
        inputField.delegate = dataHandler
        buttonView.delegate = dataHandler
        resultsTableView.delegate = dataHandler
        resultsTableView.dataSource = dataHandler
        dataHandler.delegate = self
        dataHandler.dataSource = self
        initComponents()
    }
    
    func searchParemeter(_ forDataHandler: DataHandler) throws -> String {
        do{
            let text = try inputField.returnText()
            return text
        }
    }
    
    func finishedLoading(_ dataHandler: DataHandler) {
        buttonView.changeButtonState()
        loadingProgressView.setProgress(value: progrValueForFinishLoading)
        loadingProgressView.isProgressViewHidden(true)
        resultsTableView.reloadData()
    }
    
    func errorOccured(_ dataHandler: DataHandler, errorText: String) {
        toastMessageView.showToast(with: errorText, for: self)
    }
    
    func startedLoading(_ dataHandler: DataHandler) {
        buttonView.changeButtonState()
        loadingProgressView.setProgress(value: progrValueForLoadingInit)
        loadingProgressView.isProgressViewHidden(false)
        inputField.resignFirstResponder()
    }
    
    func shouldPerformSegue(_ dataHandler: DataHandler, with item: WebPageInfoItem, with segueIdentifier: String) {
        performSegue(withIdentifier: segueIdentifier, sender: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? WebPageViewController else { return }
        guard let item = sender as? WebPageInfoItem else { return }
        destination.setWebPageInfo(info: item)
    }
    
    private func initComponents(){
        toastMessageView = ToastMessageView(frame: CGRect.null)
    }
    
}




