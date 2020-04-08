//
//  algorithms.swift
//  Outfit Recommender
//
//  Created by Pranav Mukund on 4/2/20.
//  Copyright © 2020 Pranav Mukund. All rights reserved.
//

import Foundation


//Averaging Function
func average(tempHigh: Double, tempLow: Double) -> Double {
    let avg = (tempHigh + tempLow) / 2
    return avg
}

//Shortens Array to 12 Hours
func shorten12(results: Array<Double>) -> Array<Double> {
    
    var temperaturearray = [Double](arrayLiteral: 12)
    var itemcount = 0
        
    for items in results {
        
        if itemcount < 11 {
            temperaturearray[itemcount] = items
            itemcount = itemcount + 1
        }
        
        else {
            
        }
    }
    
    return(temperaturearray)
}

//Gives average + predicts spikes + reccomends clothes
func Predictclothes(temperaturearray: Array<Double>) -> Array<String> {
    
    let seventyabove = "shorts and T-shirt"
    let fortyabove = "jeans/pants and jacket"
    let fortybelow = "heavy coat"
    
    var totalsum = 0
    var itemcount = 0
    var thresholdmin : Double = 0
    var thresholdmax : Double = 0
    var index = 0
    var tempspikeresults = [String]()
    
    //Averaging func
    for hours in temperaturearray {
        totalsum = totalsum + Int(hours)
        itemcount = itemcount + 1
    }
    let average = (totalsum / itemcount)
    if average > 70 {
        print(seventyabove)
        thresholdmin = 70
        thresholdmax = 120
    }
    
    if average < 70 && average > 40 {
        print(fortyabove)
        thresholdmin = 40
        thresholdmax = 70
    }

    if average < 40 {
        print(fortybelow)
        thresholdmin = 0
        thresholdmax = 40
    }
    
    print("average = \(average)")
    print("threshold min == \(thresholdmin)")
    print("threshold max == \(thresholdmax)")
    
    let highnumber = thresholdmax + 30
    let lownumber = thresholdmin - 30
    
    for temp in temperaturearray {
        index = index + 1
        if temp > thresholdmin && temp < thresholdmax {
            tempspikeresults.append("just right")
        }
        
        if temp > thresholdmax && temp < highnumber {
            tempspikeresults.append("temp rises to higher domain")
        }
            
        if temp < thresholdmin && temp > lownumber {
            tempspikeresults.append("temp dips to lower domain")
        }
        
    }
    return(tempspikeresults)
}

