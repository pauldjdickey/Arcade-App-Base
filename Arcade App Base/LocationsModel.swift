//
//  LocationsModel.swift
//  Arcade App Base
//
//  Created by Paul Dickey on 12/3/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsModel {
    
    func canWeWorkout(latitude: Double, longitude: Double) -> Bool {
        
        let fromLocation:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        var places:[Places] = [
            
            Places( title: "Alec",
                    cllocation: CLLocation( latitude :36.6157, longitude: -121.8285), regionRadius: 150.0, location: "Alec",
                    type: "Gym",distance : CLLocation( latitude :36.6157,
                                                        longitude: -121.8285).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6157,-121.8285)),
            
            Places( title: "Paul",
                    cllocation: CLLocation(latitude:36.6651,longitude:-121.8039), regionRadius:150.0, location:"Paul",
                    type: "Gym",distance : CLLocation(latitude:36.6651,
                                                       longitude:-121.8039).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6651,-121.8039)),
            Places( title: "Starbucks",
                    cllocation: CLLocation(latitude:36.6658,longitude:-121.8099), regionRadius:150.0, location:"Starbucks",
                    type: "Gym",distance : CLLocation(latitude:36.6658,
                                                      longitude:-121.8099).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6658,-121.8099))
        ]
        
        //Before sort the array
            for k in 0...(places.count-1) {
                print("\(places[k].distance!)")
        }
        //sort the array based on the current location to calculate the distance to compare the each and every array objects to sort the values
        for place in places {
            place.calculateDistance(fromLocation: fromLocation) // Replace YOUR_LOCATION with the location you want to calculate the distance to.
        }
        
        for k in 0...(places.count-1) {
        if places[k].distance! > 50 {
            print("Distance too far \(places[k].distance!)")
        } else {
            print("Distance close enough \(places[k].distance!)")
            return true
        }
        }
        return false
    }
}
