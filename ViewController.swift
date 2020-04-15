//
//  ViewController.swift
//  Outfit Recommender
//
//  Created by Pranav Mukund on 4/2/20.
//  Copyright © 2020 Pranav Mukund. All rights reserved.
//

import UIKit
import Foundation
var forecastData = [Weather]() //Array to impoort weather objects into

class ViewController: UIViewController {
    
//Function that shortens list of 48 hourly data objects to 12- takes in array of weather objects and outputs array of doubles
    func shorten12temp(array: [Weather]) -> Array<Double>  {
        
        var temperaturearray = [Double]()
        var itemcount = 0
            
        for items in array {

            if itemcount < 12 {
                temperaturearray.append(items.apparentTemperature) //appends temperature(double) into a new array
                itemcount = itemcount + 1
            }

        }

        return(temperaturearray)
    }
    
    func shorten12time(array: [Weather]) -> Array<Double> {
        
        var timearray = [Double]()
        var itemcount = 0
        
        for items in array {

            if itemcount < 12 {
                timearray.append(items.time)//appends temperature(double) into a new array
                itemcount = itemcount + 1
            }

        }

        return(timearray)
        
    }

    func UNIXconverter(timearray : Array<Double>) -> Array<String> {
        var timestrings = [String]()
        
        for times in timearray {
                                                  
                           let date = Date(timeIntervalSince1970: times)
                           let dateFormatter = DateFormatter()
                           dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                           dateFormatter.timeZone = .current
                           let localDate = dateFormatter.string(from: date)
                           timestrings.append(localDate)
                           
                   }
        return timestrings
    }
//Function that predicts clothes for 1)average temperature and 2) any temperature spikes or dips. Takes in array of 12 double values and ouputs array of strings
    func Predictclothes(temp12: Array<Double>, times : Array<String> /*timehour: Int*/) -> Array<String> {
        
        let seventyabove = "shorts and T-shirt" //Hypothetical preferences
        let fortyabove = "jeans/pants and jacket"
        let fortybelow = "heavy coat"
//        let dict = [1 : "shorts and T-shirt", 2 : "jeans/pants and jacket", 3 : "heavy coat"] // For potential use of dictionaries
        
        var totalsum = 0 //used for average calculation
        var itemcount = 0 //used ot count the total number of items in order to calculate average
        var thresholdmin : Double = 0 //used to determine levels for temperature classification
        var thresholdmax : Double = 0
        var index = 0 //simple index for use in for loops
        var tempspikeresults = [String]() //array for addition of strings
        var clothespredictorarray = [String]()
        var dictindex = 0 //for potential use of dictionaries
        var prevstring:String = "" //for comparisons in weather spikes
        
        //Averaging func
        for hours in temp12 {
            totalsum = totalsum + Int(hours)
            itemcount = itemcount + 1
        }
        let average = (totalsum / itemcount)
//        print("Average Temperature over the next 12 hours = \(average)")
        
        
        /* The following chunk of code is a general predictor for clothes based on the average temperature over the next 12 hours. It also establishes the ranges for certain types of clothing*/
        if average > 70 {
            clothespredictorarray.append("Average Temperature over the next 12 hours = \(average). Wear \(seventyabove)") //Adds general clothing reccomendation to final clothing array
            thresholdmin = 70
            thresholdmax = 120
            dictindex = 1 //for dictionary
        }
        if average < 70 && average > 40 {
            clothespredictorarray.append("Average Temperature over the next 12 hours = \(average). Wear \(fortyabove)")
            thresholdmin = 40
            thresholdmax = 70
            dictindex = 2 //for dictionary
            
        }
        if average < 40 {
            clothespredictorarray.append("Average Temperature over the next 12 hours = \(average). Wear \(fortybelow)")
            thresholdmin = 0
            thresholdmax = 40
            dictindex = 3 //for dictionary
        }
//        print("threshold min == \(thresholdmin)")
//        print("threshold max == \(thresholdmax)")
        
        
        
        let highnumber = thresholdmax + 30 //To establish boundaries for the other categories of temperature/clothing
        let lownumber = thresholdmin - 30
        
        //Checks if temperature jumps into a higher or lower category and appends the result to temperaturespikearray
        for temp in temp12 {
            
                if temp > thresholdmin && temp < thresholdmax {
                    tempspikeresults.append("Temperature returns to average")
                
                }
                
                if temp > thresholdmax && temp < highnumber {
                    tempspikeresults.append("Temperature raises")
                    
                }
                    
                if temp < thresholdmin && temp > lownumber {
                    tempspikeresults.append("Temperature dips")
                }
                
            index = index + 1
        }
        
        index = 0 //Re-using index
        
        
        //Appends time for each temperature spike or drop and reccomends clothing for those spikes or drops
        for items in tempspikeresults {
            
            if index == 0 {
                prevstring = items
            }
            
            if items == "Temperature returns to average" {
                
            }
            
            if items == "Temperature raises" {
                if items != prevstring {
                    dictindex = dictindex - 1
                }
//                clothespredictorarray.append("\(items) at \(times[index])") //Appends weather change notification + time to final array

                if dictindex == 1 {
                    clothespredictorarray.append("\(items) at \(times[index]). Wear \(seventyabove)")
                }

                if dictindex == 2 {
                    clothespredictorarray.append("\(items) at \(times[index]). Wear \(fortyabove)")
                }
                
            }
            
            if items == "Temperature dips" {
                
                if items != prevstring {
                    dictindex = dictindex + 1
                }
//                clothespredictorarray.append("\(items) at \(times[index]).") //Appends weather change notification + time to final array
                
                if dictindex == 2 {
                    clothespredictorarray.append("\(items) at \(times[index]). Wear \(fortyabove)")
                }
                
                if dictindex == 3 {
                    clothespredictorarray.append("\(items) at \(times[index]). Wear \(fortybelow)")
                }
                
            }
            
            index = index + 1
            prevstring = items
        }
        return(clothespredictorarray)
    }
    

   // var arraytemp = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var temperaturearray = [Double]()
        var timearray = [Double]()
        var clothespredictorarray = [String]()
        var timestrings = [String]()
        
//        // *** Create date ***
//        let date = Date()
//
//        // *** create calendar object ***
//        var calendar = Calendar.current
//
//        // *** Get components using current Local & Timezone ***
//        calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//
//        // *** define calendar components to use as well Timezone to UTC ***
//        calendar.timeZone = TimeZone(identifier: "UTC")!
//
//        // *** Get All components from date ***
//        let components = calendar.dateComponents([.hour, .year, .minute], from: date)
////        print("All Components : \(components)")
//
//        // *** Get Individual components from date ***
//        let UTChour = calendar.component(.hour, from: date)
//        let hour = UTChour - 5
        
         Weather.forecast(withLocation: "32.7767,-96.7970") { (results:[Weather]) in
            
            temperaturearray = self.shorten12temp(array:results) //Caling shorten 12 by passing an array, called "array" of results
            
            timearray = self.shorten12time(array: results) //Calling shorten12 for the times
            
            timestrings = self.UNIXconverter(timearray: timearray)
            
            clothespredictorarray = self.Predictclothes(temp12: temperaturearray, times: timestrings/*,timehour: hour*/)
            
            for items in clothespredictorarray {
                print(items)
            }
        
//            print(results[0].apparentTemperature)

        // Do any additional setup after loading the view.
            }
        }
}



