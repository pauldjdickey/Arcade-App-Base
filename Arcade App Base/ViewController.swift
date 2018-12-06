//
//  ViewController.swift
//  Arcade App Base
//
//  Created by Paul Dickey on 12/3/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UIApplicationDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationsModel = LocationsModel()
    let locationManager = CLLocationManager()
    let currentDateTime = Date()
    var geofenceRegion = CLCircularRegion()
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
        self.locationManager.requestAlwaysAuthorization()
        timeLabel.text = String(counter)
        pauseButton.isEnabled = false
        startButton.isHidden = true
        pauseButton.isHidden = true
        endButton.isHidden = true
        timeLabel.isHidden = true
        NotificationCenter.default.addObserver(self, selector:#selector(upDateTimeDifference), name: UIApplication.willEnterForegroundNotification, object: nil)
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
        print(appDelegate.arriveTime - appDelegate.leaveTime)
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
        self.locationManager.stopMonitoring(for: geofenceRegion)
        print("User has ended the workout, and the monitor for geofence has stopped")
    }
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timeLabel.text = String(format: "%.1f", counter)
    }
    @objc func upDateTimeDifference(){
        print("User Loaded Back")
        if isPlaying == true {
            print("Timer is running and now updated")
        counter = counter + appDelegate.timeDifference
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // This is the method that gets activated once the location manager has found a GPS coordinate // This saves the location into an array called [CLLocation] // This will create a bunch of locations, but the last value is the one that we want, as its most accurate for the user
        let location = locations[locations.count - 1] // This will find the last location put into the array
        
        if location.horizontalAccuracy > 0 { // This indicates that the lattitude and longitude is valid
            locationManager.stopUpdatingLocation() // This will then stop the GPS from looking, so it doesnt drain battery
            locationManager.delegate = nil // This will only bring back the 1 GPS coordinate, which means it only requests 1 GPS coordinate
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            //let check = locationsModel.canWeWorkout(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let check = locationsModel.canWeWorkout(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let savedLatitude = location.coordinate.latitude
            let savedLongitude = location.coordinate.longitude
            //Use this one when testing on computer.
            print(check)
            
            if check == true {
                let geofenceRegionCenter = CLLocationCoordinate2D(
                    latitude: savedLatitude,
                    longitude: savedLongitude
                    // This sets up our geofence and will not change until workout is complete.
                    // If we are ready to start a workout, it creates a geofence based on the current location (Have to put location.coordinate.latitude/longitude in)
                )
                /* Create a region centered on desired location,
                 choose a radius for the region (in meters)
                 choose a unique identifier for that region */
                    geofenceRegion = CLCircularRegion(
                    center: geofenceRegionCenter,
                    radius: 100,
                    identifier: "UniqueIdentifier"
                )
                // This creates the parameters for our geolocation w/ an identifier (We can add 20 geofences)
                //geofenceRegion.notifyOnEntry = true
                geofenceRegion.notifyOnExit = true
                // This will only notify us or do something when we have left
                self.locationManager.startMonitoring(for: geofenceRegion)
                print("Monitoring for geolocation with center \(location.coordinate.latitude) \(location.coordinate.latitude) has started")
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


