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
import RealmSwift

class ViewController: UIViewController {

    let Paris = City(name: "Paris", country: "FR", id: 6455259, long: 2.35236, lat: 48.856461)
    let key = "8a25d66f07d77f5b66bdf01bb8f25dda"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        try! myRealm.write {
//            myRealm.deleteAll()
//        }
        checkData()
    }
    
    func checkData() {
        let meteo = myRealm.objects(Meteo.self)
        if meteo.first == nil {
            print("No data. Updating new one")
            updateData() {}
        } else {
            print("Data found. No need to reload")
        }
    }
    
    // MARK: - This part is really toxic
    func updateData(completion: () -> Void) {
        let url = "http://api.openweathermap.org/data/2.5/forecast?id=" + String(Paris.id) + "&APPID=" + key
        let prevision = Meteo()
        var currentDay:String? = nil
        var dayNumber = 0
        var first = true
        prevision.created = NSDate()
        prevision.meteo.append(Day())
        Alamofire.request(.POST, url).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let n = json["list"].count
                    for x in 0 ..< n {
                        let newWeather = Weather()
                        let date = json["list"][x]["dt_txt"].string!
                        let day = date.componentsSeparatedByString(" ")[0]
                        let time = date.componentsSeparatedByString(" ")[1]
                        newWeather.icon = json["list"][x]["weather"][0]["icon"].string!
                        newWeather.id = String(json["list"][x]["weather"][0]["id"])
                        newWeather.main = json["list"][x]["weather"][0]["main"].string!
                        newWeather.icon = json["list"][x]["weather"][0]["description"].string!
                        newWeather.time = time
                        if (currentDay != day) {
                            currentDay = day
                            if first {
                                first = false
                            } else {
                                prevision.meteo.append(Day())
                                dayNumber += 1
                            }
                            prevision.meteo[dayNumber].date = day
                        }
                        prevision.meteo[dayNumber].weathers.append(newWeather)
                    }
                    try! myRealm.write {
                        myRealm.add(prevision)
                    }
                completion()
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