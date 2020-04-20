//
//  ViewController.swift
//  Outfit Recommender
//
//  Created by Pranav Mukund on 4/2/20.
//  Copyright © 2020 Pranav Mukund. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard //Userdefaults to store clothing preferences
    @IBOutlet weak var seventyabovefield: UITextField! //Outlets to connect buttons and text fields
    @IBOutlet weak var fortyabovefield: UITextField!
    @IBOutlet weak var fortybelowfield: UITextField!
    @IBOutlet weak var textdisplay: UITextView!
    
    struct Keys {
        static let seventyaboveweather = "seventyaboveweather"
        static let fortyaboveweather = "fortyaboveweather"
        static let fortybelowweather = "fortybelowweather"
    } //To prevent spelling errors in keys for Defaults
    

    func shorten12Temp(array: [Weather]) -> Array<Double>  {
        
        var temperaturearray = [Double]()
        var itemcount = 0
            
        for items in array {

            if itemcount < 12 {
                temperaturearray.append(items.apparentTemperature) //Appends temperature(double) into a new array
                itemcount = itemcount + 1
            }

        }

        return(temperaturearray)
    } //Function that shortens list of 48 hourly data objects to 12- takes in array of weather objects and outputs array of doubles
    
    func shorten12Time(array: [Weather]) -> Array<Double> {
        
        var timearray = [Double]()
        var itemcount = 0
        
        for items in array {

            if itemcount < 12 {
                timearray.append(items.time)//Appends times(double) into a new array
                itemcount = itemcount + 1
            }

        } //Function that shortens list of 48 hourly data objects to 12- takes in array of weather objects and outputs array of doubles

        return(timearray)
        
    }

    func unixConverter(timearray : Array<Double>) -> Array<String> {
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
    }// Function that converts UNIX-style times into hour-minute formats
    
    func predictClothes(temp12: Array<Double>, times : Array<String>) -> Array<String> {
        
        let seventyabove = defaults.value(forKey: Keys.seventyaboveweather) as? String ?? "" //Preferences from User Defaults
        let fortyabove = defaults.value(forKey: Keys.fortyaboveweather) as? String ?? ""
        let fortybelow = defaults.value(forKey: Keys.fortybelowweather) as? String ?? ""
        
        var totalsum = 0 //Used for average calculation
        var itemcount = 0 //Used to count the total number of items in order to calculate average
        var thresholdmin : Double = 0 //Used to determine levels for temperature classification
        var thresholdmax : Double = 0
        var index = 0 //Simple index for use in for loops
        var tempspikeresults = [String]() //Array for addition of strings
        var clothespredictorarray = [String]()
        var dictindex = 0 //For domain jumps in spikes/dips
        var prevstring:String = "" //For comparisons to previous weather spikes
        
        
        for hours in temp12 {
            totalsum = totalsum + Int(hours)
            itemcount = itemcount + 1
        }//Averaging function
        
        let average = (totalsum / itemcount)
        
        /* The following chunk of code is a general predictor for clothes based on the average temperature over the next 12 hours. It also establishes the ranges for certain types of clothing*/
        if average > 70 {
            clothespredictorarray.append("Average Temperature over the next 12 hours = \(average). Wear \(seventyabove)") //Adds general clothing reccomendation to final clothing array
            thresholdmin = 70
            thresholdmax = 120
            dictindex = 1
        }
        if average < 70 && average > 40 {
            clothespredictorarray.append("Average Temperature over the next 12 hours = \(average). Wear \(fortyabove)")
            thresholdmin = 40
            thresholdmax = 70
            dictindex = 2
            
        }
        if average < 40 {
            clothespredictorarray.append("Average Temperature over the next 12 hours = \(average). Wear \(fortybelow)")
            thresholdmin = 0
            thresholdmax = 40
            dictindex = 3
        }

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
            
            if items == "Temperature returns to average" {
                
                if index == 0 {
                    prevstring = items
                }
                
            }
            
            if items == "Temperature raises" {
                
                if index == 0 || items != prevstring {
                    dictindex = dictindex - 1
                }

                if dictindex == 1 {
                    clothespredictorarray.append("\(items) at \(times[index]). Wear \(seventyabove)")
                }

                if dictindex == 2 {
                    clothespredictorarray.append("\(items) at \(times[index]). Wear \(fortyabove)")
                }
                
            }
            
            if items == "Temperature dips" {
                
                if index == 0 || items != prevstring {
                    dictindex = dictindex - 1
                }
                
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seventyabovefield.delegate = self
        fortyabovefield.delegate = self
        fortybelowfield.delegate = self
        
        checkForSavedPreferences()

    }//Sets delegates and fills in saved preferences
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveWeatherPreferences()
    } //Calls WeatherPReferences
    
    func saveWeatherPreferences() {
        defaults.set(seventyabovefield.text!, forKey: Keys.seventyaboveweather)
        defaults.set(fortyabovefield.text!, forKey: Keys.fortyaboveweather)
        defaults.set(fortybelowfield.text!, forKey: Keys.fortybelowweather)

    } //Sets input information as default
    
    func checkForSavedPreferences() {
        let seventyaboveclothingpreference = defaults.value(forKey: Keys.seventyaboveweather) as? String ?? ""
        let fortyaboveclothingpreference = defaults.value(forKey: Keys.fortyaboveweather) as? String ?? ""
        let fortybelowclothingpreference = defaults.value(forKey: Keys.fortybelowweather) as? String ?? ""
        seventyabovefield.text = seventyaboveclothingpreference
        fortyabovefield.text = fortyaboveclothingpreference
        fortybelowfield.text = fortybelowclothingpreference
    } //Fills in default information when app is opened
    
    @IBAction func predictButtonTapped(_ sender: UIButton) {
        
        var forecastData = [Weather]() //Array to import weather objects into
        var temperaturearray = [Double]()
        var timearray = [Double]()
        var clothespredictorarray = [String]()
        var timestrings = [String]()

        Weather.forecast(withLocation: "32.7767,-96.7970") { (results:[Weather]) in

                temperaturearray = self.shorten12Temp(array:results) //Caling shorten 12 by passing an array, called "array" of results

                timearray = self.shorten12Time(array: results) //Calling shorten12 for the times

                timestrings = self.unixConverter(timearray: timearray)//Calling unixConverter

                clothespredictorarray = self.predictClothes(temp12: temperaturearray, times: timestrings)
                            
                let joinedclothespredictorarray = clothespredictorarray.joined(separator: "\n")
                            
                DispatchQueue.main.async {
                    self.textdisplay.text = "\(joinedclothespredictorarray)"
                }//Displays clothespredictorarray on phone screen

        }
        
    }//When predictButton is tapped, the main code is run with the algorithm.

}
    
    
    
//extension ViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
