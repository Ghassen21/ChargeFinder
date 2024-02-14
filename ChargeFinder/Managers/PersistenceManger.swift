//
//  userDefaultManager.swift
//  ChargeFinder
//
//  Created by Ghassen on 14.02.2024.
//

import Foundation

struct PersistenceManger {
    
    let userDefaults = UserDefaults.standard

    func saveStationsList(StationList: [StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel]) {
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(StationList)
            userDefaults.set(data, forKey: "stationList")
        } catch {
            print("PersistenceManger-Unable to save  StationList (\(error))")
        }
    }
    
    func readStationList()-> [StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel]?{
        var  result : [StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel]?
        if let data = userDefaults.data(forKey: "stationList") {
            do {
                let decoder = JSONDecoder()
                 result = try decoder.decode([StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel].self, from: data)
            } catch {
                print("PersistenceManger-Unable to read stationsList (\(error))")
                result = nil
            }
        }
        return result
    }
    
    func saveStationAvailabilityStatus(StationsStatus: ChargingStationStatusResponse) {
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(StationsStatus)
            userDefaults.set(data, forKey: "status")
        } catch {
            print("PersistenceManger-Unable to save  vailabilityStatus List (\(error))")
        }
    }
    
    func readAvailabilityStatusList()-> ChargingStationStatusResponse?{
        var  result : ChargingStationStatusResponse?
        if let data = userDefaults.data(forKey: "status") {
            do {
                let decoder = JSONDecoder()
                 result = try decoder.decode(ChargingStationStatusResponse.self, from: data)
            } catch {
                print("PersistenceManger- Unable to read vailabilityStatus List (\(error))")
                result = nil
            }
        }
        return result
    }
}

