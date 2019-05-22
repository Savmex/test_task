import Foundation
import UIKit

/**
 Coordinates operations between UI and model(data). Notifies it's delegate about some events.
 */

class DataHandler: NSObject, InputFieldDelegate, ButtonViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    private let cellIdentifier = "webPageInfoCell"

    private var operationQueue = OperationQueue()
    private var dataServer = DataServer()
    private var fileManager: FileManager?
    private var dataConverter = DataConverter()
    
    private var maxLinesNumber: Int = 0
    
    private var webPageSegueIdentifier = "webPage"
    
    weak var delegate: DataHandlerDelegate?
    weak var dataSource: DataHandlerDataSource?
    
    private var results : [WebPageInfoItem]?
    
    override init() {
        super.init()
        setUpOptions()
    }
    
    private func setUpOptions(){
        do{
            fileManager = try FileManager()
            let reqestURL = try fileManager?.getHttpGetRequestURL()
            let apiKey = try fileManager?.getAPIkey()
            let searchEngine = try fileManager?.getSearchEngine()
            dataServer = DataServer(httpRequest: reqestURL!, apiKey: apiKey!, searchEngine: searchEngine!)
            maxLinesNumber = try fileManager!.getMaxLinesNumber()
        }
        catch let error{
            handleError(error: error)
        }
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
            if count <= maxLinesNumber{
                return count
            }
            else{
                return maxLinesNumber
            }
        }
        else{
            return 0
        }
    }
    
    /**
     - returns: Cell of ResultCell type.
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WebPageInfoCell
        if let item = results?[indexPath.item]{
            cell.item = item
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WebPageInfoCell
        cell.isSelected = false
        let item = cell.item!
        delegate?.shouldPerformSegue(self, with: item, with: webPageSegueIdentifier)
    }

    private func unbind() {
        delegate?.startedLoading(self)
        do{
            if let text = try dataSource?.searchParemeter(self){
                initDataLoading(parameter: text)
            }
        }
        catch let error{
            handleError(error: error)
            bind()
        }
    }
    
    private func handleError(error: Error) {
        if let convertingError = error as? DataConvertingErrors {
            switch convertingError {
                case DataConvertingErrors.errorGettingItems:
                    self.reportAboutError(text: "\(DataConvertingErrors.errorGettingItems)")
                case DataConvertingErrors.errorGettingItemTitle:
                    self.reportAboutError(text: "\(DataConvertingErrors.errorGettingItemTitle)")
                case DataConvertingErrors.errorGettingItemURL:
                    self.reportAboutError(text: "\(DataConvertingErrors.errorGettingItemURL)")
            }
        }
        if let loadingFromFileError = error as? LoadingFromFileErrors {
            switch loadingFromFileError {
            case LoadingFromFileErrors.noAPIkey:
                self.reportAboutError(text: "\(LoadingFromFileErrors.noAPIkey)")
            case LoadingFromFileErrors.noFileInDirectory:
                self.reportAboutError(text: "\(LoadingFromFileErrors.noFileInDirectory)")
            case LoadingFromFileErrors.noHttpGetRequestURL:
                self.reportAboutError(text: "\(LoadingFromFileErrors.noHttpGetRequestURL)")
            case LoadingFromFileErrors.noMaxLineNumber:
                self.reportAboutError(text: "\(LoadingFromFileErrors.noMaxLineNumber)")
            case LoadingFromFileErrors.noSearchEngine:
                self.reportAboutError(text: "\(LoadingFromFileErrors.noSearchEngine)")
            case LoadingFromFileErrors.wrongMaxLinesNumber:
                self.reportAboutError(text: "\(LoadingFromFileErrors.wrongMaxLinesNumber)")
            case LoadingFromFileErrors.wrongFileDataStructure:
                self.reportAboutError(text: "\(LoadingFromFileErrors.wrongFileDataStructure)")
            }
        }
        if let serverError = error as? DataServerErrors {
            switch serverError{
            case DataServerErrors.wrongURL:
                self.reportAboutError(text: "\(DataServerErrors.wrongURL)")
            }
        }
        if let dataSourceError = error as? DataHandlerDataSourceErrors {
            switch dataSourceError{
            case DataHandlerDataSourceErrors.noSearchParameter:
                self.reportAboutError(text: "\(DataHandlerDataSourceErrors.noSearchParameter)")
            }
        }
        else{
            self.reportAboutError(text: error.localizedDescription)
        }
    }
 
    private func initDataLoading(parameter: String) {
        let operation = BlockOperation {
            do{
                let data = try self.dataServer.searchRequest(parameter: parameter)
                self.results = try self.dataConverter.convertData(data: data)
            }
            catch let error{
                self.handleError(error: error)
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
 
    private func bind(){
        OperationQueue.main.addOperation {
            self.delegate?.finishedLoading(self)
        }
    }
    
    private func cancelAllOperations() {
        operationQueue.cancelAllOperations()
        OperationQueue.main.cancelAllOperations()
    }
    
}
