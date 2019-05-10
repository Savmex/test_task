import Foundation

/**
 Contains enum of possible errors connected with loading data from files by FileManager.
*/
enum LoadingFromFileErrors: Error{
    case noFileInDirectory
    case noAPIkey
    case noSearchEngine
    case wrongMaxLinesNumber
    case noHttpGetRequestURL
    case noMaxLineNumber
}
