//
//  LocationCoordinateManager.swift
//  ChargeFinder
//
//  Created by Ghassen on 11.02.2024.
//

import Foundation
import CoreLocation

class LocationServiceManager: NSObject{
    
    static let shared = LocationServiceManager()
    private let locationManager = CLLocationManager()
    private var currentCoordinatesValue :CLLocationCoordinate2D?
    private let radiusInKilometers: Double = 1.0
    var completionHandler :   (([StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel]?,Error?) -> ()?)? = nil
    
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
    func filterStationsWithinRadius(stationsDataResponseModel: StationsDataResponseModel) -> [StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel] {
        var filteredStations: [StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel] = []
        
        for evseDataModel in stationsDataResponseModel.eVSEData {
            for evseDataRecordModel in evseDataModel.eVSEDataRecord {
                guard let stationCoordinate = evseDataRecordModel.geoCoordinates.coordinatesPoints else {
                    continue
                }
                let isCoordinateInRadius = isCoordinateInRadius(sourceCoordinate: self.currentCoordinatesValue!, targetCoordinate: stationCoordinate)
                if isCoordinateInRadius{
                    filteredStations.append(evseDataRecordModel)
                    break
                }
            }
        }
        return filteredStations
    }
    
    
    func getStationListWithinRadius(completion : @escaping  ([StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel]?, Error?) -> Void)
    {
        self.completionHandler = completion
    }
    
}

extension LocationServiceManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager-didFailWithError :\(error)")
        
    }
    //Delegate to receive updated heading info locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let localValue : CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("LocationManager-didUpdateLocations coodinates = \(localValue.latitude) \(localValue.longitude)")
        self.currentCoordinatesValue = localValue
        if locations.first != nil {
            if self.currentCoordinatesValue != nil
            {
                APIManager.shared.fetchChargingStationsData { result  in
                    switch result{
                    case .success(let stationsList):
                        let stationListInRadius = self.filterStationsWithinRadius(stationsDataResponseModel: stationsList)
                        //Sort the stationListInRadius array in descending order based on the power (kW) of the charging facilities
                        let sortedStationListbyPowerValue = stationListInRadius.sorted { station1, station2 in
                            guard let power1 = station1.chargingFacilities.first?.power,
                                  let power2 = station2.chargingFacilities.first?.power else {
                                // If one or both power values are nil, handle it here
                                if station1.chargingFacilities.first?.power == nil && station2.chargingFacilities.first?.power == nil {
                                    // If both power values are nil, stations are considered equal
                                    return false
                                } else if station1.chargingFacilities.first?.power == nil {
                                    // If only power1 is nil, station1 comes after station2
                                    return false
                                } else {
                                    // If only power2 is nil, station2 comes after station1
                                    return true
                                }
                            }
                            switch (power1, power2) {
                            case (.intType(let valueInt1), .intType(let valueInt2)):
                                return valueInt1 > valueInt2
                            case (.intType(let valueInt1), .doubleType(let doubleTypeValue2)):
                                return Double(valueInt1) > doubleTypeValue2
                            case (.doubleType(let doubleTypeValue1), .intType(let intValue2)):
                                return doubleTypeValue1 > Double(intValue2)
                            case (.doubleType(let doubleTypeValue1), .doubleType(let doubleTypeValue2)):
                                return doubleTypeValue1 > doubleTypeValue2
                            }
                        }
                        //save station in user default 
                        PersistenceManger().saveStationsList(StationList: sortedStationListbyPowerValue)
                        self.completionHandler?(sortedStationListbyPowerValue, nil)
                    case .failure(let error):
                        self.completionHandler?(nil, error)
                        print ("LocationManager-failure  to get stations List \(error)")
                    }
                }
            }
        }
    }
}

