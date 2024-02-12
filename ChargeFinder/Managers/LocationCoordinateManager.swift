//
//  LocationCoordinateManager.swift
//  ChargeFinder
//
//  Created by Ghassen on 11.02.2024.
//

import Foundation
import CoreLocation

class LocationCoordinateManager: NSObject{
    
    static let shared = LocationCoordinateManager()
    private let locationManager = CLLocationManager()
    private var currentCoordinatesValue :CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 46.81418322454504, longitude: 7.150812603476325)
    private let radiusInKilometers: Double = 1.0
    var completionHandler :   (([StationsDataResponseModel.EVSEDataModel]?,Error?) -> ()?)? = nil
    
    override init() {
        super.init()
        self.setuplocationManagerAutorization()
    }
    
    func setuplocationManagerAutorization(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy  =  kCLLocationAccuracyNearestTenMeters
                self.locationManager.requestLocation()
            }
        }
    }
    
    //Indicates whether the target coordinates are within the radius of the source coordinates by calculating the distance between them.
    func isCoordinateInRadius(sourceCoordinate: CLLocationCoordinate2D, targetCoordinate: CLLocationCoordinate2D) -> Bool {
        let sourceLocation = CLLocation(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude)
        let targetLocation = CLLocation(latitude: targetCoordinate.latitude, longitude: targetCoordinate.longitude)
        let radiusInMeters = self.radiusInKilometers * 1000
        let distance = sourceLocation.distance(from: targetLocation)
        return distance <= radiusInMeters
    }
    
    // filters the nested object StationsDataResponseModel by the `coordinatesPoints` key based on a current given coordinate and a the radius:
    func filterStationsWithinRadius(stationsDataResponseModel: StationsDataResponseModel) -> [StationsDataResponseModel.EVSEDataModel] {
        var filteredStations: [StationsDataResponseModel.EVSEDataModel] = []
        
        for evseDataModel in stationsDataResponseModel.eVSEData {
            for evseDataRecordModel in evseDataModel.eVSEDataRecord {
                guard let stationCoordinate = evseDataRecordModel.geoCoordinates.coordinatesPoints else {
                    continue
                }
                let isCoordinateInRadius = isCoordinateInRadius(sourceCoordinate: self.currentCoordinatesValue!, targetCoordinate: stationCoordinate)
                if isCoordinateInRadius{
                    filteredStations.append(evseDataModel)
                    break
                }
            }
        }
        return filteredStations
    }
    
    
    func getStationListWithinRadius(completion : @escaping  ([StationsDataResponseModel.EVSEDataModel]?, Error?) -> Void)
    {
        self.completionHandler = completion
    }
    
}

extension LocationCoordinateManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager-didFailWithError :\(error)")
        
    }
    //Delegate to receive updated heading info locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let localValue : CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("LocationManager-didUpdateLocations-coodinates = \(localValue.latitude) \(localValue.longitude)")
        self.currentCoordinatesValue = localValue
        if locations.first != nil {
            if self.currentCoordinatesValue != nil
            {
                APIManager.shared.fetchChargingStationsData { result  in
                    switch result{
                    case .success(let stationsList):
                        let stationListInRadius = self.filterStationsWithinRadius(stationsDataResponseModel: stationsList)
                        self.completionHandler?(stationListInRadius, nil)
                        print ("LocationManager-Success to get stations  filterted List")
                    case .failure(let error):
                        self.completionHandler?(nil, error)
                        print ("LocationManager-failure  to get stations List \(error)")
                    }
                }
            }
        }
    }
}


