//
//  Helpers.swift
//  ChargeFinder
//
//  Created by Ghassen on 12.02.2024.
//

import Foundation
import CoreLocation


func convertCoordinatesFromString(coordinateString: String) -> CLLocationCoordinate2D? {
    // Split the string by space to separate latitude and longitude
    let components = coordinateString.components(separatedBy: " ")
    // Ensure there are exactly two components (latitude and longitude)
    guard components.count == 2,
          let latitude = Double(components[0]),
          let longitude = Double(components[1]) else {
        return nil
    }
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
}


