import Foundation

/**
 Contains errors can be thrown by DataServer due to some errors.
*/

enum DataServerErrors: Error {
    /**
     Thrown when URL creating fails.
    */
    case wrongURL
}
