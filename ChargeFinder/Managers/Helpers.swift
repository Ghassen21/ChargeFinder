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

func convertDateFormat(_ dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: date)
    } else {
        return nil
    }
}
extension Sequence {
    func removingDuplicates<T: Hashable>(withSame keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { element in
            guard seen.insert(element[keyPath: keyPath]).inserted else { return false }
            return true
        }
    }
}

