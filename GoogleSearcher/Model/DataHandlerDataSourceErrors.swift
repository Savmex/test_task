import Foundation

/**
 Contains errors can be thrown by DataHandler Data Source methods.
 */

enum DataHandlerDataSourceErrors: Error{
    /**
     Thrown when there is no search parameter in field.
    */
    case noSearchParameter
}
