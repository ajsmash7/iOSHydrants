//
//  HydrantStore.swift
//  Hydrants
//
//  Created by AJMac on 4/22/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import Foundation
import MapKit

class HydrantStore {
    
    var hydrantUpdates: [HydrantUpdate] = []
    var imageStore: ImageStore
    
    let hydrantArchiveURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectory.first!
        return documentDirectory.appendingPathComponent("hydrants.archive")
    }()
    
    init() {
        imageStore = ImageStore()
    
        do {
            let data = try Data(contentsOf: hydrantArchiveURL)
            let archivedItems = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [HydrantUpdate]
            hydrantUpdates = archivedItems!
        } catch {
            print("Error Unarchiving: \(error)")
        }
    
    }
    
    func addHydrantUpdate(hydrant: HydrantUpdate, image: UIImage) {
        hydrantUpdates.append(hydrant)
        imageStore.setImage(image, forKey: hydrant.imageKey)
        archiveChanges()
    }
    
    func getImage(forKey: String) -> UIImage? {
        return imageStore.image(forKey: forKey)
    }
    
    func archiveChanges() {
        
        do {
            let data = NSKeyedArchiver.archivedData(withRootObject: hydrantUpdates)
            try data.write(to: hydrantArchiveURL)
            print("archived items to \(hydrantArchiveURL)")
        } catch {
            print("Error archiving items: \(error)")
        }
    }
}
