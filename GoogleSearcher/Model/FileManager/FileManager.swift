import Foundation

/**
 Class for interacting with file system(files in bundle).
 Loads and prepares data for using at the launch time.
 */

class FileManager {
    
    private let fileName = "application"
    private let fileExtansion = "plist"
    private let keyForAPIkey = "APIkey"
    private let keyForEngine = "searchEngine"
    private let keyForHttpGetRequest = "httpGetRequest"
    private let keyForMaxLinesNumber = "maxLinesNumber"
    private let decoder = PropertyListDecoder()
    private let fileDataType = Dictionary<String, String>.self
    private var fileContent =  Dictionary<String, String>()
    
    init() throws {
        do{
            let path = try getFilePath()
            let data = try loadDataFromFile(path: path)
            fileContent = try decodeData(data: data)
        }
    }
    
    private func getFilePath() throws -> URL {
        if let filePath = Bundle.main.url(forResource: fileName, withExtension: fileExtansion){
            return filePath
        }
        else{
            throw LoadingFromFileErrors.noFileInDirectory
        }
    }
    
    private func loadDataFromFile(path: URL) throws -> Data {
        do{
            let data = try Data(contentsOf: path)
            return data
        }
    }
    
    private func decodeData(data: Data) throws -> Dictionary<String, String> {
        do{
            let content = try decoder.decode(fileDataType, from: data)
            return content
        }
    }
    
    /**
     Returns apikey loaded from file with application properties.
     Throws an exception if there is no available data.
    */
    
    func getAPIkey() throws -> String {
        if let apiKey = fileContent[keyForAPIkey]{
            if !apiKey.isEmpty{
                return apiKey
            }
            else{
                throw LoadingFromFileErrors.noAPIkey
            }
        }
        else{
            throw LoadingFromFileErrors.noAPIkey
        }
    }
    
    /**
     Returns searchEngine loaded from file with application properties.
     Throws an exception if there is no available data.
     */
    
    func getSearchEngine() throws -> String {
        if let searchEngine = fileContent[keyForEngine]{
            if !searchEngine.isEmpty{
                return searchEngine
            }
            else{
                throw LoadingFromFileErrors.noSearchEngine
            }
        }
        else{
            throw LoadingFromFileErrors.noSearchEngine
        }
    }
    
    /**
     Returns httpGetRequest from file with application properties.
     Throws an exception if there is no available data.
     */
    
    func getHttpGetRequestURL() throws -> String {
        if let httpGetRequest = fileContent[keyForHttpGetRequest]{
            if !httpGetRequest.isEmpty{
                return httpGetRequest
            }
            else{
                throw LoadingFromFileErrors.noHttpGetRequestURL
            }
        }
        else{
            throw LoadingFromFileErrors.noHttpGetRequestURL
        }
    }
    
    /**
     Returns max number of lines for displaying results.
     Throws an exception if there is no available data.
    */
    func getMaxLinesNumber() throws -> Int {
        if let maxNumber = fileContent[keyForMaxLinesNumber]{
            if let number = Int(maxNumber){
                return number
            }
            else{
                throw LoadingFromFileErrors.wrongMaxLinesNumber
            }
        }
        else{
            throw LoadingFromFileErrors.noMaxLineNumber
        }
    }
    
}
