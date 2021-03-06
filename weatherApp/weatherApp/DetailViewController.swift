//
//  DetailViewController.swift
//  weatherApp
//
//  Created by Tchang on 14/07/16.
//  Copyright © 2016 Tchang. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet weak var detailTableView: UITableView!
    
    // MARK: - Variables
    var index = 0
    var meteo:Results<Meteo>? = nil
    
    override func viewDidLoad() {
        let cellNib = UINib(nibName: "customCellView", bundle: nil)
        self.detailTableView.registerNib(cellNib, forCellReuseIdentifier: "customCell")
        self.view.backgroundColor = UIColor(patternImage: UIImage(imageLiteral: "background"))
        self.detailTableView.backgroundColor = UIColor.clearColor()
        self.title = meteo?.first?.meteo[index].date
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let check = meteo?.first?.meteo[index].weathers.count {
            return check
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell") as! customTableviewCell
        var temps = "Min: " + String((meteo?.first?.meteo[index].weathers[indexPath.row].tMin)!) + "°C"
        temps += " | Max: " + String((meteo?.first?.meteo[index].weathers[indexPath.row].tMax)!) + "°C"
        
        cell.userInteractionEnabled = false
        
        cell.dateText.text = meteo?.first?.meteo[index].weathers[indexPath.row].time
        cell.descriptionText.text = meteo?.first?.meteo[index].weathers[indexPath.row].descri
        cell.minMaxTempText.text = temps
        cell.tempText.text = String((meteo?.first?.meteo[index].weathers[indexPath.row].t)!) + "°C"
        
        let url = "http://openweathermap.org/img/w/" + (meteo?.first?.meteo[index].weathers[indexPath.row].icon)! + ".png"
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
}
