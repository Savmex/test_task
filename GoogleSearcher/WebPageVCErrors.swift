import Foundation

enum WebPageVCErrors: Error {
    /**
     Thrown when given url is incorrect
    */
    case wrongURl
    /**
     Thrown when there is no title in Web Page Info
    */
    case noTitle
}
