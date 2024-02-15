//
//  ApiResponseModel.swift
//  ChargeFinder
//
//  Created by Ghassen on 11.02.2024.
//

import Foundation
import CoreLocation


enum powerValueType: Codable {
    case intType (Int)
    case doubleType(Double)
}

struct  StationsDataResponseModel :Decodable  {
    let eVSEData: [EVSEDataModel]
    
    enum CodingKeys: String, CodingKey {
        case eVSEData = "EVSEData"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eVSEData = try container.decode([StationsDataResponseModel.EVSEDataModel].self, forKey: .eVSEData)
    }
    
    struct EVSEDataModel: Decodable,Identifiable {
        var id: String?
        
        var eVSEDataRecord: [EVSEDataRecordModel]
        let operatorID: String
        let operatorName: String
        
        enum CodingKeys: String, CodingKey {
            case eVSEDataRecord = "EVSEDataRecord"
            case operatorID = "OperatorID"
            case operatorName = "OperatorName"
        }
        
        //Each struct has a custom initializer (init(from decoder: Decoder)) to decode the JSON data into Swift objects in order to specify the keys for decoding.
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            eVSEDataRecord =  try container.decode([StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel].self, forKey: .eVSEDataRecord)
            //Remove depulicates element from array
            eVSEDataRecord = eVSEDataRecord.removingDuplicates(withSame: \.chargingStationId)
            operatorID = try container.decode(String.self, forKey: .operatorID)
            operatorName = try container.decode(String.self, forKey: .operatorName)
            id = operatorID
        }
        
        struct EVSEDataRecordModel: Decodable,Identifiable,Encodable{
            let id: String?
            var accessibilityLocation : String?
            let address: AddressModel?
            let authenticationModes: [String]
            let chargingFacilities: [ChargingFacilityModel]
            let isOpen24Hours: Bool
            let paymentOptions: [String]?
            let plugs: [String]?
            let accessibility: String
            let chargingStationId: String
            let geoCoordinates: GeoCoordinatesModel
            var lastUpdate: String?

            enum CodingKeys: String, CodingKey,Encodable {
                
                case accessibilityLocation = "AccessibilityLocation"
                case adddress = "Adddress"
                case authenticationModes = "AuthenticationModes"
                case chargingFacilities = "ChargingFacilities"
                case isOpen24Hours = "IsOpen24Hours"
                case paymentOptions = "PaymentOptions"
                case plugs = "Plugs"
                case accessibility = "Accessibility"
                case chargingStationId = "ChargingStationId"
                case geoCoordinates = "GeoCoordinates"
                case lastUpdate = "lastUpdate"
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                accessibilityLocation =  try container.decodeIfPresent(String.self, forKey: .accessibilityLocation)
                address = try container.decodeIfPresent(StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel.AddressModel.self, forKey: .adddress)
                authenticationModes = try container.decode([String].self, forKey: .authenticationModes)
                chargingFacilities  = try container.decode([StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel.ChargingFacilityModel].self, forKey: .chargingFacilities)
                isOpen24Hours = try container.decode(Bool.self, forKey: .isOpen24Hours)
                paymentOptions = try container.decodeIfPresent([String].self, forKey: .paymentOptions)
                plugs = try container.decodeIfPresent([String].self, forKey: .plugs)
                accessibility = try container.decode(String.self, forKey: .accessibility)
                chargingStationId = try container.decode(String.self, forKey: .chargingStationId)
                geoCoordinates = try container.decode(StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel.GeoCoordinatesModel.self, forKey: .geoCoordinates)
                lastUpdate = try container.decodeIfPresent(String.self, forKey: .lastUpdate)
                lastUpdate = convertDateFormat(lastUpdate ?? "")
                id = chargingStationId
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(accessibilityLocation, forKey: .accessibilityLocation)
                try container.encode(address, forKey: .adddress)
                try container.encode(authenticationModes, forKey: .authenticationModes)
                try container.encode(chargingFacilities, forKey: .chargingFacilities)
                try container.encode(isOpen24Hours, forKey: .isOpen24Hours)
                try container.encode(paymentOptions, forKey: .paymentOptions)
                try container.encode(plugs, forKey: .plugs)
                try container.encode(accessibility, forKey: .accessibility)
                try container.encode(chargingStationId, forKey: .chargingStationId)
                try container.encode(geoCoordinates, forKey: .geoCoordinates)
                try container.encode(lastUpdate, forKey: .lastUpdate)
                
                
            }
            
            
            struct AddressModel: Decodable ,Encodable {
                let houseNumber : String?
                let timeZone: String?
                let city: String
                let country: String
                let postalCode: String?
                let street: String
                let floor: String?
                let region: String?
                let parkingSpot: String?
                let parkingFacility: Bool?
                
                enum CodingKeys: String, CodingKey {
                    
                    case houseNumber = "HouseNum"
                    case timeZone = "TimeZone"
                    case city = "City"
                    case country = "Country"
                    case postalCode = "PostalCode"
                    case street = "Street"
                    case floor = "Floor"
                    case region = "Region"
                    case parkingSpot = "ParkingSpot"
                    case parkingFacility = "ParkingFacility"
                }
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    houseNumber =  try container.decodeIfPresent(String.self, forKey: .houseNumber)
                    timeZone =  try container.decodeIfPresent(String.self, forKey: .timeZone)
                    city = try container.decode(String.self, forKey: .city)
                    country = try container.decode(String.self, forKey: .country)
                    postalCode  = try container.decodeIfPresent(String.self, forKey: .postalCode)
                    street = try container.decode(String.self, forKey: .street)
                    floor = try container.decodeIfPresent(String.self, forKey: .floor)
                    region = try container.decodeIfPresent(String.self, forKey: .region)
                    parkingSpot = try container.decodeIfPresent(String.self, forKey: .parkingSpot)
                    parkingFacility = try container.decodeIfPresent(Bool.self, forKey: .parkingFacility)
                }
                
                func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: CodingKeys.self)
                    try container.encode(houseNumber, forKey: .houseNumber)
                    try container.encode(timeZone, forKey: .timeZone)
                    try container.encode(city, forKey: .city)
                    try container.encode(country, forKey: .country)
                    try container.encode(postalCode, forKey: .postalCode)
                    try container.encode(street, forKey: .street)
                    try container.encode(floor, forKey: .floor)
                    try container.encode(region, forKey: .region)
                    try container.encode(parkingSpot, forKey: .parkingSpot)
                    try container.encode(parkingFacility, forKey: .parkingFacility)
                }
                
                
                
            }
            
            struct GeoCoordinatesModel: Decodable ,Encodable{
                let google: String
                var coordinatesPoints :CLLocationCoordinate2D?
                
                enum CodingKeys: String, CodingKey {
                    case google = "Google"
                }
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    google =  try container.decode(String.self, forKey: .google)
                    coordinatesPoints  = convertCoordinatesFromString(coordinateString: google)
                    
                }
                
                func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: CodingKeys.self)
                    try container.encode(google, forKey: .google)
                }
            }
            
            struct ChargingFacilityModel: Decodable,Encodable {
                
                var  power: powerValueType?
                var  powertype: String?
                
                enum CodingKeys: String, CodingKey {
                    case power
                    case powertype
                }
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    powertype  = try container.decodeIfPresent(String.self, forKey: .powertype)
                    if let intTypeValue = try? container.decode(Int.self, forKey: .power) {
                        power = powerValueType.intType(intTypeValue)
                    } else if let doubeTypeValue = try? container.decode(Double.self, forKey: .power) {
                        power = powerValueType.doubleType(doubeTypeValue)
                    }
                }
                func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: CodingKeys.self)
                    switch power {
                    case .intType(let value):
                        try container.encode(value, forKey: .power)
                    case .doubleType(let value):
                        try container.encode(value, forKey: .power)
                    case .none:
                        break
                    }
                    try container.encode(powertype, forKey: .powertype)
                }
                
            }
        }
    }
}

struct ChargingStationStatusResponse: Codable {
    let evseStatuses: [EVSEStatus]
    
    enum CodingKeys: String, CodingKey {
        case evseStatuses = "EVSEStatuses"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        evseStatuses = try container.decode([ChargingStationStatusResponse.EVSEStatus].self, forKey: .evseStatuses)
    }
    struct EVSEStatus: Codable {
        let evseStatusRecord: [EVSEStatusRecord]
        
        enum CodingKeys: String, CodingKey {
            case evseStatusRecord = "EVSEStatusRecord"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            evseStatusRecord = try container.decode([ChargingStationStatusResponse.EVSEStatus.EVSEStatusRecord].self, forKey: .evseStatusRecord)
        }
        
        struct EVSEStatusRecord: Codable {
            let evseID: String
            let evseStatus: String
            
            enum CodingKeys: String, CodingKey {
                case evseID = "EvseID"
                case evseStatus = "EVSEStatus"
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                evseID = try container.decode(String.self, forKey: .evseID)
                evseStatus = try container.decode(String.self, forKey: .evseStatus)
            }
        }
    }
}
