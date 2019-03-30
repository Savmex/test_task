//
//  FetchedItem+CoreDataProperties.swift
//  test
//
//  Created by Savely Mikhnevich on 3/30/19.
//  Copyright © 2019 Macbook. All rights reserved.
//
//

import Foundation
import CoreData

/**
 Structure for fetched items data.
 */

extension FetchedItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FetchedItem> {
        return NSFetchRequest<FetchedItem>(entityName: "FetchedItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?

}
