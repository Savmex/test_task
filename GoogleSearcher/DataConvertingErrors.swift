import Foundation

/**
 Contains errors can be thrown by DataConvetring due to some errors.
*/
enum DataConvertingErrors: Error {
    /**
     Thrown when items fetching fails.
    */
    case errorGettingItems
    /**
     Thrown when fetching item's title fails.
     */
    case errorGettingItemTitle
    /**
     Thrown when fetching item's url fails.
    */
    case errorGettingItemURL
}
