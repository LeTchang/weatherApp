//
//  ViewController.swift
//  weatherApp
//
//  Created by Tchang on 12/07/16.
//  Copyright © 2016 Tchang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {

    let Paris = City(name: "Paris", country: "FR", id: 2988507, long: 2.35236, lat: 48.856461)
    let key = "8a25d66f07d77f5b66bdf01bb8f25dda"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    func initData() {
        let url = "http://api.openweathermap.org/data/2.5/forecast?id=" + String(Paris.id) + "&APPID=" + key
        print(url)
        Alamofire.request(.POST, url).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json.description)
                }
            case .Failure:
                print("Error while loading datas")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

