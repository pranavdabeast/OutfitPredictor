//
//  ViewController.swift
//  Outfit Recommender
//
//  Created by Pranav Mukund on 4/2/20.
//  Copyright © 2020 Pranav Mukund. All rights reserved.
//

import UIKit
var forecastData = [Weather]()

class ViewController: UIViewController {
    
    

    func shorten12(array: [Weather]) -> Array<Double> {

        var temperaturearray = [Double]()
        var itemcount = 0
            
        for items in array {

            if itemcount < 11 {
                temperaturearray.append(items.apparentTemperature)
                itemcount = itemcount + 1
            }

        }

        return(temperaturearray)
    }

   // var arraytemp = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var temperaturearray = [Double](arrayLiteral: 12)
        
         Weather.forecast(withLocation: "32.7767,-96.7970") { (results:[Weather]) in
            
          temperaturearray = self.shorten12(array:results)

            for tempitems in temperaturearray {
                print(tempitems)
            }

        for result in results{

        print(result)

            }
//            print(results[0].apparentTemperature)
//
            
        // Do any additional setup after loading the view.
            
            }
        
        }
    
    

}


