//
//  ViewController.swift
//  Calender3.0
//
//  Created by Anthony Torres on 1/13/20.
//  Copyright © 2020 Anthony Torres. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    let DaysOfMonth = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var numberOfEmptyBox = Int() // Number of empty boxes at the start of the current month
    
    var nextNumberOfEmptyBox = Int() // the same with above but with the next month
    
    var previousNumberOfEmptyBox = 0 // the same with above but with prev month
    
    var direction = 0 // =0 if we are at the current month / =1 if we are in a future month / =-1 if we are in the past month
    
    var postionIndex = 0 //
    
    var leapYearCounter = 2
    
    var dayCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = Months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        
        if weekday == 0 {
            weekday = 7
        }
        
        getStartDateDatePosition()
    }
    
    @IBAction func next(_ sender: Any) {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            direction = 1
            if leapYearCounter < 5 {
                leapYearCounter += 1
            }
            if leapYearCounter == 4 {
                DaysInMonths[1] = 29
            }
            if leapYearCounter == 5 {
                leapYearCounter = 1
                DaysInMonths[1] = 28
            }
            getStartDateDatePosition()
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        default:
            direction = 1
            getStartDateDatePosition()
            month += 1
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            direction = -1
            if leapYearCounter > 0 {
                leapYearCounter -= 1
            }
            if leapYearCounter == 0 {
                DaysInMonths[1] = 29
                leapYearCounter = 4
            } else {
                DaysInMonths[1] = 28
            }
            getStartDateDatePosition()
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        default:
            month -= 1
            direction = -1
            getStartDateDatePosition()
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        }
    }
    
    func getStartDateDatePosition() {                   // this func gives us the number of empty boxes
        switch direction {
        case 0:                                         // if we at the current month
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter>0 {
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0 {
                    numberOfEmptyBox = 7
                }
            }
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            postionIndex = numberOfEmptyBox
        case 1...:                                      // if we are at the future month
            nextNumberOfEmptyBox = (postionIndex + DaysInMonths[month])%7
            postionIndex = nextNumberOfEmptyBox
            
        case -1:                                        // if we are at a past month
            previousNumberOfEmptyBox = (7 - (DaysInMonths[month] - postionIndex)%7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            postionIndex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return DaysInMonths[month] + numberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + nextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = UIColor.black
        
        if cell.isHidden {
            cell.isHidden = false
        }
        
        switch direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1...:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.dateLabel.text!)! < 1 { // hides every cell that is smaller than 1
            cell.isHidden = true
        }
        // show the weekdays in different colors
        switch indexPath.row { //weekend days color
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        if currentMonth == Months[Calendar.current.component(.month, from: date) - 1] && year == Calendar.current.component(.year, from: date) && indexPath.row + 1 - numberOfEmptyBox == day {
            cell.backgroundColor = UIColor.red
        }
        return cell
    }
}
