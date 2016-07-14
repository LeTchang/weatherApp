//
//  Weather.swift
//  weatherApp
//
//  Created by Tchang on 12/07/16.
//  Copyright © 2016 Tchang. All rights reserved.
//

import UIKit
import RealmSwift

class Weather: Object {

    dynamic var icon = ""
    dynamic var id = ""
    dynamic var main = ""
    dynamic var descri = ""
    dynamic var time = ""
    dynamic var tMax = 0
    dynamic var tMin = 0
    dynamic var t = 0
}

class Day: Object {
    
    dynamic var date = ""
    let weathers = List<Weather>()
}

class Meteo: Object {
    
    dynamic var created: NSDate? = nil
    let meteo = List<Day>()
    
    func show() {
        print(meteo)
    }
}