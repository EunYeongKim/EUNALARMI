//
//  UserDefaultsExtension.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/21.
//  Copyright © 2020 60080252. All rights reserved.
//

import Foundation

extension UserDefaults {
    func modelData<T>(by key: String, type: T.Type) -> T? where T: Decodable {
        if let data = data(forKey: key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    func setModel<T: Codable>(by key: String, newValue: T) {
        let data = try? JSONEncoder().encode(newValue)
        set(data, forKey: key)
    }
    
    func arrayModelData<T>(by key: String, type: T.Type) -> [T] where T: Decodable {
        guard let data = array(forKey: key) as? [Data] else { return [] }
        
        return data.map { try! JSONDecoder().decode(T.self, from: $0) }
    }
    
    func setArrayModel<T: Codable>(by key: String, newValue: [T]) {
        let data = newValue.map { try? JSONEncoder().encode($0) }
        set(data, forKey: key)
    }
}
