//
//  RoomsAndDevicesSection.swift
//  ios-ac-remote-control
//
//  Created by mac on 24.04.2024.
//

import SwiftUI

struct RoomsAndDevicesSection: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State var chosenRoom: RoomViewModel? = nil
    
    var body: some View {
        HStack {
            Text("Your Devices")
            Spacer()
            NavigationLink{
                RoomsList().environmentObject(HomeViewModel.viewModel)
            } label: {
                Image("icon_menu_2_")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24) // Adjust the size as needed
            }
        }
        VStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    Button{
                        chosenRoom = nil
                    } label: {
                        Text("All")
                            .font(.fontMedium(size: 16))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                    }
                    .buttonStyle(myButtonStyle(type: chosenRoom == nil ? .usual : .usualBorderOnly))
                    
                    
                    ForEach(viewModel.currentPreset.rooms) { room in
                        
                        Button{
                            chosenRoom = room
                        } label: {
                            Text(room.name)
                                .font(.fontMedium(size: 16))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 14)
                        }
                        .buttonStyle(myButtonStyle(type: chosenRoom == room ? .usual : .usualBorderOnly))
                    
                    }
                    
                }
                .padding(2)
         
            }
         
            ScrollView(.vertical,showsIndicators: false) {
                VStack{
                    let devices = chosenRoom == nil ? viewModel.devices : chosenRoom!.devicesVM
                    if devices.count == 0 {
                        Image("no_devices_in_room")
                            .resizable()
                            .frame(width: 318, height: 226)
                            .padding(.top, 78)
                    } else {
                        ForEach(devices) { device in
                            DeviceListCell()
                                .environmentObject(device)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RoomsAndDevicesSection()
        .environmentObject(HomeViewModel.viewModel)
}
