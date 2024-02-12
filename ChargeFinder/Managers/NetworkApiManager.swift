//
//  NetworkApiManager.swift
//  ChargeFinder
//
//  Created by Ghassen on 11.02.2024.
//

import Foundation
enum DataError: Error {
    case invalidData
    case decodeError
}

class APIManager {
    
    static let shared = APIManager()
    private let evsDataUrl = URL(string: "https://data.geo.admin.ch/ch.bfe.ladestellen-elektromobilitaet/data/ch.bfe.ladestellen-elektromobilitaet.json")
    private let evsDataStatusUrl = URL(string: "https://data.geo.admin.ch/ch.bfe.ladestellen-elektromobilitaet/status/ch.bfe.ladestellen-elektromobilitaet.json")
    
    private init() { }

    // Get all charging stations Data List
    func fetchChargingStationsData(completion: @escaping (Result<StationsDataResponseModel,Error>) -> Void) {
        URLSession.shared.dataTask(with: self.evsDataUrl!) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data else {
                completion(.failure(DataError.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let products = try decoder.decode(StationsDataResponseModel.self, from: data)
                completion(.success(products))
            }
            catch {
                completion(.failure(DataError.decodeError))
            }
        }.resume()
    }
    
    
    // get all charging stations availability status List
    func fetchChargingStationsAvailability(completion: @escaping (Result<ChargingStationStatusResponse,Error>) -> Void){
        URLSession.shared.dataTask(with: self.evsDataStatusUrl!) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let data else {
                completion(.failure(DataError.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let products = try decoder.decode(ChargingStationStatusResponse.self, from: data)
                completion(.success(products))
            }
            catch {
                completion(.failure(DataError.decodeError))
            }
        }.resume()
    }
}
