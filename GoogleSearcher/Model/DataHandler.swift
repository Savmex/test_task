import Foundation
import UIKit

/**
 A class coortinating all the operations with model(data). Also interact with UI.
 */

class DataHandler: NSObject, InputFieldDelegate, ButtonViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    private let cellIdentifier = "resultCell"
    
    private let operationQueue = OperationQueue()
    private let dataServer = DataServer()
    private let dataConverter = DataConverter()
    
    private let noSearchParameterError = "enter text"
    private let noResultsError = "no results"
    
    weak var delegate: DataHandlerDelegate?
    weak var dataSource: DataHandlerDataSource?
    
    private var results : [FetchedItem]?
    
    override init() {
        super.init()
    }

    func inputFieldShouldReturn(inputField: InputField) -> Bool{
        unbind()
        return true
    }
    
    func ButtonPressed(button: ButtonView) {
        if operationQueue.operations.count == 0 {
            unbind()
        }
        else{
            cancelAllOperations()
        }
    }
    
    /**
     - returns: number of rows in Results table view.
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = results?.count{
            return count
        }
        else{
            return 0
        }
    }
    
    /**
     - returns: Cell of ResultCell type.
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultCell
        if let item = results?[indexPath.item]{
            cell.item = item
        }
        return cell
    }
    
    
    /**
     Loads current UI state to model and initiates data Loading.
    */
    
    func unbind() {
        delegate?.startedLoading(self)
        if let text = dataSource?.searchParemeter(self){
            initDataLoading(parameter: text)
        }
        else{
            reportAboutError(text: noSearchParameterError)
            bind()
        }
    }
 
    private func initDataLoading(parameter: String) {
        let operation = BlockOperation {
            let data = self.dataServer.searchRequest(parameter: parameter)
            if let results = self.dataConverter.convertData(data: data){
                self.results = results
            }
            else{
                self.reportAboutError(text: self.noResultsError)
            }
        }
        operation.completionBlock = {
            if !operation.isCancelled{
                self.bind()
            }
            else{
                self.results?.removeAll()
                self.bind()
            }
        }
        operationQueue.addOperation(operation)
    }
    
    private func reportAboutError(text: String){
        OperationQueue.main.addOperation {
            self.delegate?.errorOccured(self, errorText: text)
        }
    }
 
    /**
     Tells delegate to update UI according to model changes.
    */
    
    func bind(){
        OperationQueue.main.addOperation {
            self.delegate?.finishedLoading(self)
        }
    }
    
    private func cancelAllOperations() {
        operationQueue.cancelAllOperations()
        OperationQueue.main.cancelAllOperations()
    }
    
}
