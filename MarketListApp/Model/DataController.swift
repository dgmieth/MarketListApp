//
//  DataController.swift
//  MarketListApp
//
//  Created by Diego Mieth on 26/02/20.
//  Copyright © 2020 dgmieth. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer:NSPersistentCloudKitContainer
    
    var viewContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentCloudKitContainer(name: modelName)
    }
    
    func load(completion: (()-> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
        completion?()
    }
}
