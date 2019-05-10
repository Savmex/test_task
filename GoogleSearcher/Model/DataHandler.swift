import Foundation
import UIKit

/**
 Coordinates operations between UI and model(data). Notifies it's delegate about some events.
 */

class DataHandler: NSObject, InputFieldDelegate, ButtonViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    private let cellIdentifier = "itemCell"

    private var operationQueue = OperationQueue()
    private var dataServer = DataServer()
    private var fileManager: FileManager?
    private var dataConverter = DataConverter()
    
    private var maxLinesNumber: Int = 0
    
    weak var delegate: DataHandlerDelegate?
    weak var dataSource: DataHandlerDataSource?
    
    private var results : [Item]?
    
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
        catch LoadingFromFileErrors.noFileInDirectory{
            reportAboutError(text: "\(LoadingFromFileErrors.noFileInDirectory)")
        }
        catch LoadingFromFileErrors.noHttpGetRequestURL{
            reportAboutError(text: "\(LoadingFromFileErrors.noHttpGetRequestURL)")
        }
        catch LoadingFromFileErrors.noAPIkey{
            reportAboutError(text: "\(LoadingFromFileErrors.noAPIkey)")
        }
        catch LoadingFromFileErrors.noSearchEngine{
            reportAboutError(text: "\(LoadingFromFileErrors.noSearchEngine)")
        }
        catch LoadingFromFileErrors.noMaxLineNumber{
            reportAboutError(text: "\(LoadingFromFileErrors.noMaxLineNumber)")
        }
        catch let error{
            reportAboutError(text: error.localizedDescription)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ItemCell
        if let item = results?[indexPath.item]{
            cell.item = item
        }
        return cell
    }
    
    private func unbind() {
        delegate?.startedLoading(self)
        do{
            if let text = try dataSource?.searchParemeter(self){
                initDataLoading(parameter: text)
            }
        }
        catch DataHandlerDataSourceErrors.noSearchParameter{
            reportAboutError(text: "\(DataHandlerDataSourceErrors.noSearchParameter)")
            bind()
        }
        catch let error{
            reportAboutError(text: error.localizedDescription)
            bind()
        }
    }
 
    private func initDataLoading(parameter: String) {
        let operation = BlockOperation {
            do{
                let data = try self.dataServer.searchRequest(parameter: parameter)
                self.results = try self.dataConverter.convertData(data: data)
            }
            catch DataConvertingErrors.errorGettingItems{
                self.reportAboutError(text: "\(DataConvertingErrors.errorGettingItems)")
            }
            catch DataConvertingErrors.errorGettingItemTitle{
                self.reportAboutError(text: "\(DataConvertingErrors.errorGettingItemTitle)")
            }
            catch DataConvertingErrors.errorGettingItemURL {
                self.reportAboutError(text: "\(DataConvertingErrors.errorGettingItemURL)")
            }
            catch DataServerErrors.wrongURL{
                self.reportAboutError(text: "\(DataServerErrors.wrongURL)")
            }
            catch let error{
                self.reportAboutError(text: error.localizedDescription)
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
