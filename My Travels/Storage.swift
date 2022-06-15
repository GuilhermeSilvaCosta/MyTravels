//
//  Storage.swift
//  My Travels
//
//  Created by Guilherme Costa on 14/06/22.
//

import UIKit

class StorageClass {
    
    let key = "travels"
    var travels: [ Dictionary<String, String> ] = []
    let repository = UserDefaults.standard
    
    func save(travel: Dictionary<String, String>) {
        travels = list()
        travels.append(travel)
        repository.set(self.travels, forKey: key)
        repository.synchronize()
    }
    
    func list() -> [ Dictionary<String, String> ] {
        if let data = repository.object(forKey: key) {
            return data as! Array
        }
        return []
    }
    
    func remove(index: Int) {
        travels = list()
        travels.remove(at: index)
        
        repository.set(self.travels, forKey: key)
        repository.synchronize()
    }
}

let Storage = StorageClass()
