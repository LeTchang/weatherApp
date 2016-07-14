//
//  extensionFloat.swift
//  weatherApp
//
//  Created by Tchang on 14/07/16.
//  Copyright © 2016 Tchang. All rights reserved.
//

import UIKit

extension Float {
    
    var celcius: Int {
        return Int(self - 273.15)
    }
}