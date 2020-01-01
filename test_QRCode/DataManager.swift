//
//  DataManager.swift
//  test_QRCode
//
//  Created by Gravman on 28.12.2019.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistenContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer (name: "QRCode_Model")
        container.loadPersistentStores(completionHandler: {(NSPersistentStoreDescription, handleError)
            in
            if let error = handleError {
                fatalError("Unnable to load persistantStore")
            }
        })
        return container
    }()
    
}
