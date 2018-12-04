//
//  DistanceCalculator.swift
//  Arcade App Base
//
//  Created by Paul Dickey on 12/3/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import Foundation
import CoreLocation


final public class Places : NSObject  {
    var title: String?
    var cllocation: CLLocation
    var regionRadius: Double
    var location: String?
    var type: String?
    var distance : Double?
    var coordinate : CLLocationCoordinate2D
    
    init(title:String ,
         cllocation: CLLocation ,
         regionRadius: Double,
         location: String,
         type: String ,
         distance:Double!,
         coordinate: CLLocationCoordinate2D){
        self.title = title
        self.cllocation = cllocation
        self.coordinate = coordinate
        self.regionRadius = regionRadius
        self.location = location
        self.type = type
        self.distance = distance
    }
    
    
    // Function to calculate the distance from
    // given location (current Location).
    
    func calculateDistance(fromLocation: CLLocation?) {
        distance = cllocation.distance(from: fromLocation!)
    }// calculate the distance based on the current location
}
