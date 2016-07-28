//
//  customTableviewCell.swift
//  weatherApp
//
//  Created by Tchang on 14/07/16.
//  Copyright © 2016 Tchang. All rights reserved.
//

import UIKit

class customTableviewCell: UITableViewCell {

    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var tempText: UITextField!
    @IBOutlet weak var minMaxTempText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clearColor()
        
        self.dateText.backgroundColor = UIColor.clearColor()
        self.descriptionText.backgroundColor = UIColor.clearColor()
        self.minMaxTempText.backgroundColor = UIColor.clearColor()
        self.tempText.backgroundColor = UIColor.clearColor()
        
        self.dateText.borderStyle = UITextBorderStyle.None
        self.descriptionText.borderStyle = UITextBorderStyle.None
        self.minMaxTempText.borderStyle = UITextBorderStyle.None
        self.tempText.borderStyle = UITextBorderStyle.None
        
        self.dateText.textColor = UIColor.whiteColor()
        self.descriptionText.textColor = UIColor.whiteColor()
        self.minMaxTempText.textColor = UIColor.whiteColor()
        self.tempText.textColor = UIColor.whiteColor()
        
        self.dateText.enabled = false
        self.descriptionText.enabled = false
        self.minMaxTempText.enabled = false
        self.tempText.enabled = false
    }
}
