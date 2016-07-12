//
//  Weather.swift
//  weatherApp
//
//  Created by Tchang on 12/07/16.
//  Copyright © 2016 Tchang. All rights reserved.
//

import UIKit

class Weather {

    let icon: String
    let id: String
    let main: String
    let description: String
    let time: String
    
    init(icon: String, id: String, main: String, description: String, time: String) {
        self.icon = icon
        self.id = id
        self.main = main
        self.description = description
        self.time = time
    }
}

class Day {
    
    let date: String
    var weathers: [Weather] = []
    
    init(date: String) {
        self.date = date
    }
}