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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlet
    @IBOutlet weak var meteoTableView: UITableView!

    let Paris = City(name: "Paris", country: "FR", id: 6455259, long: 2.35236, lat: 48.856461)
    let key = "8a25d66f07d77f5b66bdf01bb8f25dda"
    var meteo:Results<Meteo>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(imageLiteral: "background"))
        self.meteoTableView.backgroundColor = UIColor.clearColor()
//        try! myRealm.write {
//            myRealm.deleteAll()
//        }
        checkData()
    }
    
    func checkData() {
        meteo = myRealm.objects(Meteo.self)
        if meteo!.first == nil {
            print("No data. Updating new one")
            updateData() {}
        } else {
            print("Data found. No need to reload")
            meteo!.first?.show()
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
                        newWeather.descri = json["list"][x]["weather"][0]["description"].string!
                        newWeather.time = time
                        newWeather.tMax = (json["list"][x]["main"]["temp_max"].float?.celcius)!
                        newWeather.tMin = (json["list"][x]["main"]["temp_min"].float?.celcius)!
                        newWeather.t = (json["list"][x]["main"]["temp"].float?.celcius)!
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
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (meteo?.first?.meteo.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell") as! customTableviewCell
        var temps = "Min: " + String((meteo?.first?.meteo[indexPath.row].weathers[0].tMin)!)
        temps += " | Max: " + String((meteo?.first?.meteo[indexPath.row].weathers[0].tMax)!)
        
        cell.backgroundColor = UIColor.clearColor()
        cell.dateText.backgroundColor = UIColor.clearColor()
        cell.descriptionText.backgroundColor = UIColor.clearColor()
        cell.minMaxTempText.backgroundColor = UIColor.clearColor()
        cell.tempText.backgroundColor = UIColor.clearColor()
        
        cell.dateText.borderStyle = UITextBorderStyle.None
        cell.descriptionText.borderStyle = UITextBorderStyle.None
        cell.minMaxTempText.borderStyle = UITextBorderStyle.None
        cell.tempText.borderStyle = UITextBorderStyle.None
        
        cell.dateText.text = meteo?.first?.meteo[indexPath.row].date
        cell.descriptionText.text = meteo?.first?.meteo[indexPath.row].weathers[0].descri
        cell.minMaxTempText.text = temps
        cell.tempText.text = String((meteo?.first?.meteo[indexPath.row].weathers[0].t)!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("nextSegue", sender: nil)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextSegue" {
            print("Content View called")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}