//
//  ApiResponseModel.swift
//  ChargeFinder
//
//  Created by Ghassen on 11.02.2024.
//

import Foundation


enum powerValueType: Codable {
    case intType (Int)
    case floatType(Double)
}

struct  StationsDataResponseModel :Decodable {
    let eVSEData: [EVSEDataModel]
    
    enum CodingKeys: String, CodingKey {
        case eVSEData = "EVSEData"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eVSEData = try container.decode([StationsDataResponseModel.EVSEDataModel].self, forKey: .eVSEData)
    }
    
    struct EVSEDataModel: Decodable {
        let eVSEDataRecord: [EVSEDataRecordModel]
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
            operatorID = try container.decode(String.self, forKey: .operatorID)
            operatorName = try container.decode(String.self, forKey: .operatorName)
        }
        
        struct EVSEDataRecordModel: Decodable {
            let accessibilityLocation : String?
            let address: AddressModel?
            let authenticationModes: [String]
            let chargingFacilities: [ChargingFacilityModel]
            let isOpen24Hours: Bool
            let paymentOptions: [String]?
            let plugs: [String]?
            let accessibility: String
            let chargingStationId: String
            let geoCoordinates: GeoCoordinatesModel
            let lastUpdate: String?
            
            enum CodingKeys: String, CodingKey {
                
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
                
            }
            
            struct AddressModel: Decodable {
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
            }
            
            struct GeoCoordinatesModel: Decodable {
                let google: String
                
                enum CodingKeys: String, CodingKey {
                    case google = "Google"
                }
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    google =  try container.decode(String.self, forKey: .google)
                }
            }
            
            struct ChargingFacilityModel: Decodable {
                
                var  power: powerValueType?
                var  powertype: String?
                
                enum CodingKeys: String, CodingKey {
                    case power
                    case powertype
                }
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    powertype  = try container.decodeIfPresent(String.self, forKey: .powertype)
                    if let intType = try? container.decode(Int.self, forKey: .power) {
                        power = powerValueType.intType(intType)
                    } else if let floatType = try? container.decode(Double.self, forKey: .power) {
                        power = powerValueType.floatType(floatType)
                    }
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
