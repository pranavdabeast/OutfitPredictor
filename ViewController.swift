//
//  ViewController.swift
//  Outfit Recommender
//
//  Created by Pranav Mukund on 4/2/20.
//  Copyright © 2020 Pranav Mukund. All rights reserved.
//

import UIKit
var forecastData = [Weather]()

//func shorten12(array: [Weather]) -> Array<Double> {
//
//    var temperaturearray = [Double](arrayLiteral: 12)
//    var itemcount = 0
//
//    for items in array {
//
//        if itemcount < 11 {
//            temperaturearray[itemcount] = items
//            itemcount = itemcount + 1
//        }
//
//    }
//
//    return(temperaturearray)
//}

var arraytemp = [Double]()


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         Weather.forecast(withLocation: "32.7767,-96.7970") { (results:[Weather]) in
        var itemcounter = 0
        for result in results{

                print("\(result)\n\n")
            arraytemp[itemcounter] = results[itemcounter].apparentTemperature
                itemcounter = itemcounter + 1
                print(arraytemp[itemcounter])
            }
            
            print(results[0].apparentTemperature)
//            print(shorten12(results: results.apparentTemperature))
            
        // Do any additional setup after loading the view.
            
            
            }
        
        }
    
    

}


