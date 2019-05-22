import Foundation
import CoreData


extension WebPageInfoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WebPageInfoItem> {
        return NSFetchRequest<WebPageInfoItem>(entityName: "WebPageInfoItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?

}
