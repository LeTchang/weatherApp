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
import AlamofireImage
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlet
    @IBOutlet weak var meteoTableView: UITableView!
    

    // MARK: - Variables
    let Paris = City(name: "Paris", country: "FR", id: 6455259, long: 2.35236, lat: 48.856461)
    let key = "8a25d66f07d77f5b66bdf01bb8f25dda"
    var meteo:Results<Meteo>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(imageLiteral: "background"))
        self.meteoTableView.backgroundColor = UIColor.clearColor()
        checkData()
    }
    
    func checkData() {
        meteo = myRealm.objects(Meteo.self)
        if meteo!.first == nil {
            updateData() {
                completion in
                self.meteoTableView.reloadData()
            }
        }
    }
    
    // MARK: - Check and download all the data needed and save it
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
                let alert = UIAlertController(title: "Error while loading datas",
                    message: "Please check your internet connection and refresh",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                alert.view.setNeedsLayout()
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let check = meteo?.first?.meteo.count {
            return check
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell") as! customTableviewCell
        var temps = "Min: " + String((meteo?.first?.meteo[indexPath.row].weathers[0].tMin)!) + "°C"
        temps += " | Max: " + String((meteo?.first?.meteo[indexPath.row].weathers[0].tMax)!) + "°C"
        
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
        cell.tempText.text = String((meteo?.first?.meteo[indexPath.row].weathers[0].t)!) + "°C"
        
        let url = "http://openweathermap.org/img/w/" + (meteo?.first?.meteo[indexPath.row].weathers[0].icon)! + ".png"
        Alamofire.request(.GET, url).responseImage {
            response in
            if let image = response.result.value {
                cell.iconImage.image = image
            } else {
                cell.iconImage.image = nil
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("nextSegue", sender: nil)
    }
    
    // MARK: - IBActions
    @IBAction func onTrash(sender: AnyObject) {
        let alert = UIAlertController(title: "Delete all data",
                                      message: "Are you sure ?",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "DELETE", style: UIAlertActionStyle.Default, handler: { (action) in
            try! myRealm.write {
                myRealm.deleteAll()
                self.meteoTableView.reloadData()
            }
        }))
        alert.view.setNeedsLayout()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onRefresh(sender: AnyObject) {
        updateData() {
            completion in
            self.meteoTableView.reloadData()
        }
    }

    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextSegue" {
            let new = segue.destinationViewController as! DetailViewController
            let index = self.meteoTableView.indexPathForSelectedRow!
            new.index = index.row
            new.meteo = self.meteo
            self.meteoTableView.deselectRowAtIndexPath(index, animated: true)
        }
    }
}