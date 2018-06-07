//
//  BaseTableViewCell.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    
    internal func convertDate(date: String, type: Int) -> String{
        var stringDate = ""
        if (date == ""){
            stringDate = "--/--"
        }else{
            let dateString = date
            let dateStringArr = dateString.components(separatedBy: " ")
            let day = dateStringArr[0]
            let time = dateStringArr[1]
            let dateArr = day.components(separatedBy: "-")
            let timeArr = time.components(separatedBy: ":")
            if (type == 0){
                stringDate = dateArr[2] + "/" + dateArr[1]
            }else if (type == 1){
                stringDate = dateArr[2] + "/" + dateArr[1] + "/" + dateArr[0].deletingPrefix("20")
            }else{
                stringDate = timeArr[0] + ":" + timeArr[1] + " " + dateArr[2] + "/" + dateArr[1] + "/" + dateArr[0].deletingPrefix("20")
            }
            
        }
        return stringDate
    }
}
