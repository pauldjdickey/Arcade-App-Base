//
//  ViewController.swift
//  Arcade App Base
//
//  Created by Paul Dickey on 12/3/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationsModel = LocationsModel()
    let locationManager = CLLocationManager()
    var previousPoints:Int = 0
    var counter = 0.0
    var timer = Timer()
    var isPlaying = false
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var checkInLabel: UIButton!
    @IBOutlet weak var pointLabel: UILabel!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = String(counter)
        pauseButton.isEnabled = false
        startButton.isHidden = true
        pauseButton.isHidden = true
        endButton.isHidden = true
        timeLabel.isHidden = true
    }
    @IBAction func checkInButton(_ sender: UIButton) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    @IBAction func startTimer(_ sender: Any) {
        if(isPlaying) {
            return
        }
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
    }
    @IBAction func pauseTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        timer.invalidate()
        isPlaying = false
    }
    @IBAction func resetTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        timer.invalidate()
        isPlaying = false
        let alert2 = UIAlertController(title: "Congratulations!", message: "You earned \(Int(counter/2)) points", preferredStyle: UIAlertController.Style.alert)
        alert2.addAction(UIAlertAction(title: "End Workout", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert2, animated: true, completion: nil)
        print(counter)
        pointLabel.text = ("\(previousPoints + Int(counter/2))")
        previousPoints += Int(counter/2)
        counter = 0.0
        timeLabel.text = String(counter)
        startButton.isHidden = true
        pauseButton.isHidden = true
        endButton.isHidden = true
        timeLabel.isHidden = true
        checkInLabel.isHidden = false
    }
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timeLabel.text = String(format: "%.1f", counter)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // This is the method that gets activated once the location manager has found a GPS coordinate // This saves the location into an array called [CLLocation] // This will create a bunch of locations, but the last value is the one that we want, as its most accurate for the user
        let location = locations[locations.count - 1] // This will find the last location put into the array
        
        if location.horizontalAccuracy > 0 { // This indicates that the lattitude and longitude is valid
            locationManager.stopUpdatingLocation() // This will then stop the GPS from looking, so it doesnt drain battery
            locationManager.delegate = nil // This will only bring back the 1 GPS coordinate, which means it only requests 1 GPS coordinate
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let check = locationsModel.canWeWorkout(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print(check)
            
            if check == true {
                print("Lets do it!")
                startButton.isHidden = false
                pauseButton.isHidden = false
                endButton.isHidden = false
                timeLabel.isHidden = false
                checkInLabel.isHidden = true
                
            } else {
                print("Gotta go to a gym first")
                let alert = UIAlertController(title: "Can't Start Workout", message: "You must be at a valid gym to check in and begin your workout.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

