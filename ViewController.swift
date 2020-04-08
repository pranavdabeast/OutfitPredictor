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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         Weather.forecast(withLocation: "32.7767,-96.7970") { (results:[Weather]) in
//        for result in results{
//
//                print("\(result)\n\n")
//                    }
            
            print(results[0].apparentTemperature)
            
            
        // Do any additional setup after loading the view.
            }
        
        }
    
    

}


