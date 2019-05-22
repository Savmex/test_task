import Foundation

/**
 Class for interacting with file system(files in bundle).
 Loads and prepares data for using at the launch time.
 */

class FileManager {
    
    private let fileName = "application.properties"
    private let fileExtansion = "txt"
    private let keyForAPIkey = "APIkey"
    private let keyForEngine = "searchEngine"
    private let keyForHttpGetRequest = "httpGetRequest"
    private let keyForMaxLinesNumber = "maxLinesNumber"
    private let pairsSeparator = "\n"
    private let keyAndValueSeparator = "="
    private let keyIndex = 0
    private let valueIndex = 1
    private var fileContent =  Dictionary<String, String>()
    private let fileDataEncoding = String.Encoding.utf8
    
    init() throws {
        do{
            let path = try getFilePath()
            let data = try loadDataFromFile(path: path)
            fileContent = try parseData(data: data)
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
    
    private func loadDataFromFile(path: URL) throws -> String {
        do{
            let data = try String(contentsOf: path, encoding: fileDataEncoding)
            return data
        }
    }
    
    private func parseData(data: String) throws -> Dictionary<String, String> {
        do{
            var dictionary = Dictionary<String, String>()
            let keyValuesPairs = data.components(separatedBy: pairsSeparator)
            print(keyValuesPairs)
            for pair in keyValuesPairs where pair != "" {
                let keyAndValue = pair.components(separatedBy: keyAndValueSeparator)
                guard keyAndValue.count == 2 else { throw LoadingFromFileErrors.wrongFileDataStructure }
                let key = keyAndValue[keyIndex]
                let value = keyAndValue[valueIndex]
                dictionary[key] = value
            }
            return dictionary
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
