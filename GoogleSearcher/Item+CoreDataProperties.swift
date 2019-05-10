//
//  Item+CoreDataProperties.swift
//  GoogleSearcher
//
//  Created by Savely Mikhnevich on 5/10/19.
//  Copyright © 2019 Macbook. All rights reserved.
//
//

import Foundation
import CoreData

/**
  Structure for items data.
 */
extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?

}
