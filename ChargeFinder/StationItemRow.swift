//
//  StationItemRow.swift
//  ChargeFinder
//
//  Created by Ghassen on 12.02.2024.
//

import SwiftUI

struct StationItemRow: View {
    
    var stationItem : StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel?
    @State  var stationItemStatus : String?
    
    var body: some View {
        HStack{
            Image("power-icon")
                .resizable()
                .frame(width:60,height:60)
                .padding(.all)
            VStack(alignment: .leading) {
                Text(stationItem!.chargingStationId)
                    .fontWeight(.regular)
                HStack{
                    Image("icons-power-kw")
                        .resizable()
                        .frame(width:25,height:25)
                    switch stationItem!.chargingFacilities.first?.power {
                    case.intType(let powerValue):
                        Text("\(powerValue)kW")
                            .fontWeight(.medium)
                    case .some(.doubleType(let powerValue)):
                        Text("\(powerValue)kW")
                            .fontWeight(.medium)
                    case .none:
                        Text("None")
                    }
                }
                HStack{
                    Image("icons-accessibility")
                        .resizable()
                        .frame(width:20,height:20)
                    Text("\(stationItem!.accessibility)")
                        .fontWeight(.light)
                }
                HStack{
                    Image(setAvailabilityStatusIcon(for: stationItemStatus))
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("\(stationItemStatus ?? "Unknown")")
                        .fontWeight(.medium)
                }
                HStack{
                    Image("icons-location")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("\(stationItem?.geoCoordinates.google ?? "Unknown")")
                        .fontWeight(.ultraLight)
                }
            }
        }.onAppear(perform: {
            APIManager.shared.fetchStatusForStation(stationId: stationItem!.chargingStationId) { status in
                if status != nil {
                    self.stationItemStatus = status
                }
            }
        })
    }
    // Function to set the appropriate availability  icon for a given status
    func setAvailabilityStatusIcon(for status: String?) -> String {
        switch status {
        case "Available": return "icons-green-status"
        case "OutOfService": return "icons-gray-status"
        case "Occupied": return "icons-red-status"
        default: return "icons-gray-status"
        }
    }
    
}

#Preview {
    StationItemRow()
}
