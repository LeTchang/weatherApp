//
//  ViewController.swift
//  weatherApp
//
//  Created by Tchang on 12/07/16.
//  Copyright © 2016 Tchang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let Paris = City(name: "Paris", country: "FR", id: 6455259, long: 2.35236, lat: 48.856461)

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "api.openweathermap.org/data/2.5/forecast?id=" + String(Paris.id)
        print(url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

