//
//  ContentView.swift
//  ChargeFinder
//
//  Created by Ghassen on 11.02.2024.
//

import SwiftUI

struct StationsList: View {
    @State  var stationsList : [StationsDataResponseModel.EVSEDataModel.EVSEDataRecordModel]
    @State private var isCircleRotating = true
    @State private var animateStart = true
    @State private var animateEnd = true
    @State private var showingAlert = false

    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            if isCircleRotating {
                //Display activity indicator while fetching stations List data
                Circle()
                    .stroke(lineWidth: 10)
                    .fill(Color.init(red: 0.96, green: 0.96, blue: 0.96))
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: animateStart ? 1/3 : 1/9, to: animateEnd ? 2/5 : 1)
                    .stroke(lineWidth: 10)
                    .rotationEffect(.degrees(isCircleRotating ? 360 : 0))
                    .frame(width: 150, height: 150)
                    .foregroundColor(Color.green)
                Text("Loading")
                    .font(.title)
                    .fontWeight(.bold)
                    .onAppear() {
                        withAnimation(Animation
                            .linear(duration: 1)
                            .repeatForever(autoreverses: false)) {
                                
                            }
                        withAnimation(Animation
                            .linear(duration: 1)
                            .delay(0.5)
                            .repeatForever(autoreverses: true)) {
                                self.animateStart.toggle()
                            }
                        withAnimation(Animation
                            .linear(duration: 1)
                            .delay(1)
                            .repeatForever(autoreverses: true)) {
                                self.animateEnd.toggle()
                            }
                    }
                
            } else {
                List {
                    ForEach(self.stationsList){ stationItem in
                        StationItemRow(stationItem: stationItem)
                    }
                }
            }
            
        }.onAppear {
            LocationServiceManager.shared.getStationListWithinRadius { result, error in
                if error == nil {
                    if result != nil{
                        self.stationsList = result!
                        self.isCircleRotating = false
                        animateStart = false
                        animateEnd = true
                    }
                }else {
                    if !NetworkManagerReachability().isReachable(){
                        // show alert to notify the user that internet is not reachable
                        showingAlert = true
                        self.stationsList = PersistenceManger().readStationList() ?? []
                        self.isCircleRotating = false
                        animateStart = false
                        animateEnd = true
                    }
                }
            }
        }.alert("Please check you internet connection", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .onReceive(timer) { _  in
            // Trigger another round of station fetching when the timer passes 1 minute
            self.refetchStationsListData()
        }
    }
    
   
    func refetchStationsListData() {
        LocationServiceManager.shared.getStationListWithinRadius { result, error in
            if error == nil {
                if result != nil{
                    self.stationsList = result!
                }
            }
        }
    }
}





