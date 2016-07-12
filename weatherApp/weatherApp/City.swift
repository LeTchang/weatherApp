//
//  File.swift
//  weatherApp
//
//  Created by Tchang on 12/07/16.
//  Copyright © 2016 Tchang. All rights reserved.
//

import UIKit

public struct City {
    
    let name: String
    let country: String
    let id: Int
    let long: Double
    let lat: Double
    
    init(name: String, country: String, id: Int, long: Double, lat: Double) {
        self.name = name
        self.country = country
        self.id = id
        self.long = long
        self.lat = lat
    }
}
