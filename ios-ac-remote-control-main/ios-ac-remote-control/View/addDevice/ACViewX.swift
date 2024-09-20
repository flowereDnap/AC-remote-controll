//
//  ACViewX.swift
//  ios-ac-remote-control
//
//  Created by admin on 26.04.2024.
//

import SwiftUI

//
//  ACViews.swift
//  ios-ac-remote-control
//
//  Created by mac on 23.04.2024.
//

import SwiftUI

struct ACConnectionViewX: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State var stage: Int = 0
    @State var newDevice: DeviceViewModel = DeviceViewModel(properties: [:])

    @State var validInput: Bool = false
    @State var resetType: Int = 0
    @State var displayAlert = false
    @State var didConnectToDeviceWIFI: Bool = false
    @State var deviceHandshakeResponcePending = false
    @State var deviceHandshakeSuccess: Bool = false {
        didSet {
            deviceHandshakeResponcePending = false
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                if stage == 0 {
                    ACView1
                } else if  stage == 1 {
                    ACView2
                } else if  stage == 2 {
                    ACView3
                } else if  stage == 3 {
                    ACView4
                } else {
                    Text("FATAL")
                    let _ = print(#function, stage)
                }
            }
            .animation(.default)
            .padding(.horizontal, 20)
            
            if displayAlert {
                ACAlertView(isPresented: $displayAlert, resetType: $resetType)
            }

            if deviceHandshakeResponcePending {
                LoadingView(isPresented: $deviceHandshakeResponcePending)
            }
            
        }
        .animation(.default)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.DesignSystem.background)
        .navigationTitle("Connecting device")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button {
                if stage == 0 {
                    dismiss()
                } else if stage == 1{
                    stage -= 1
                    didConnectToDeviceWIFI = false
                } else {
                    stage -= 1
                }
            } label: {
                Image("icon_back_")
            }
        )
        .navigationBarBackButtonHidden(true)
    }

    var resetText: (f: String, s: String ) {
        switch resetType {
        case 0:
            return (f: "1. Use the remote controller to turn off the air conditioner.", s: "2. Press \"Mode\" and \"WiFi\" buttons simultaneously, and you will hear a beep, which means reset is succeeded.")
        case 1:
            return (f: "1. Use the remote controller to turn off the air conditioner.", s: "2. Press \"Mode\" and \"Turbo\" buttons simultaneously, and you will hear a beep, which means reset is succeeded.")
        case 2:
            return (f: "1. Press the button on the touch panel.", s: "2. When the unit is off, press \"Function\" and \"Fan\" buttons on its wired controller for 5s. If \"oC\" is displayed, reset is competed.")
        default:
            return (f: "", s: "")
        }
    }
    
    @ViewBuilder
    var ACView1: some View {
        Text("Reset AC Wi-Fi")
            .font(.fontRegular(size: 16))
            .padding(.top, 20)
        Spacer()
        VStack(spacing: 12) {
            VStack(alignment: .leading){
                Text(resetText.f)
                    .font(.fontRegular(size: 16))
                    .padding(.bottom, 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(resetText.s)
                    .font(.fontRegular(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(Color.DesignSystem.skyBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack(spacing: 12){
                Image("icon_info_")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Tips: Wi-Fi module can only release hot spot 2 minutes after it is reset.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.fontRegular(size: 16))
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color.DesignSystem.skyBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button {
                displayAlert = true
            } label: {
                HStack(spacing: 12){
                    Image(systemName: didConnectToDeviceWIFI ? "checkmark.circle" : "circle")
                        .resizable()
                        .foregroundColor(.black)
                        .tint(.black)
                        .frame(width: 24, height: 24)
                    
                    
                    Text("Switch to other reset ways")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .font(.fontRegular(size: 16))
                    
                }
                .padding(16)
            }
            .background(Color.DesignSystem.skyBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        
        Button {
                stage += 1
        } label: {
            Text("Next")
                .font(.fontRegular(size: 16))
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(myButtonStyle(type: .usual))
        .padding(.top, 8)

    }
    
    @ViewBuilder
    var ACView2: some View {
        
        Text("Connect to AC Wi-Fi")
            .font(.fontRegular(size: 16))
            .padding(.top, 20)
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Connect to device's Wi-Fi. \n(Note: name should be a 8-character alphanumeric, e.g. \"u34k5l166\")")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.fontRegular(size: 16))
                .padding(16) // Move the padding to the VStack
                .background(Color.DesignSystem.skyBlue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button {
                didConnectToDeviceWIFI.toggle()
            } label: {
                HStack(spacing: 12){
                    Image(systemName: didConnectToDeviceWIFI ? "checkmark.circle" : "circle")
                        .resizable()
                        .foregroundColor(.black)
                        .tint(.black)
                        .frame(width: 24, height: 24)
                    
                    
                    Text("I've connected")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .font(.fontRegular(size: 16))
                    
                }
                .padding(16)
            }
            .background(Color.DesignSystem.skyBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
        }
        
        Button {
            if didConnectToDeviceWIFI {
                
                deviceHandshakeResponcePending = true
                //TODO
                newDevice = homeVM.testStartDeviceCreation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    deviceHandshakeSuccess = true
                    stage += 1
                }
            } else {
                if let url = URL(string:"App-Prefs:root=WIFI") {
                    if UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
        } label: {
            Text(!didConnectToDeviceWIFI ? "Wi-Fi Settings" : "Next")
                .font(.fontRegular(size: 16))
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(myButtonStyle(type: .usual))
        .padding(.top, 8)

    }

    @ViewBuilder
    var ACView3: some View {
        Text("Сonfirm home Wi-FI")
            .font(.fontRegular(size: 16))
            .padding(.top, 20)
        Spacer()
        VStack(spacing: 12) {
            Text("not done yet")
        }
        
        Button {
                stage += 1
        } label: {
            Text("Next")
                .font(.fontRegular(size: 16))
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(myButtonStyle(type: .usual))
        .padding(.top, 8)
    }

    @ViewBuilder
    var ACView4: some View {
        Text("Сonfirm home Wi-FI")
            .font(.fontRegular(size: 16))
            .padding(.top, 20)
        Spacer()
        TextFieldView(text: $newDevice.name, validInput: $validInput, placeholder: "enter device name")
        
        VStack(spacing: 12) {
            NavigationLink {
                DevicesMoveView(belongingRoom: nil, devicesToMove: [newDevice])
            } label: {
                Text("Destribute to the room")
                    .font(.fontRegular(size: 16))
                    .padding()
                    .frame(maxWidth: .infinity)
            }
        }
        
        Button {
                dismiss()
        } label: {
            Text("Done")
                .font(.fontRegular(size: 16))
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(myButtonStyle(type: validInput ? .usual : .unavaliable))
        .padding(.top, 8)

    }
}


struct ACAlertViewX: View {
    @Binding var isPresented: Bool
    @Binding var resetType: Int
    
    init(isPresented: Binding<Bool>, resetType: Binding<Int>) {
        _isPresented = isPresented
        _resetType = resetType
    }
    
    var body: some View {
        ZStack {
            // Dimming background
            Color.gray.opacity(0.5).ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            
            // Alert view
            alertView
                .padding(.horizontal, 16)
        }
        .opacity(isPresented ? 1 : 0) // Show or hide the alert based on isPresented
        .animation(.default)
    }
    
    @ViewBuilder
    private var alertView: some View {
        VStack(spacing: 12) {
            Text("Select reset Type")
                .font(.fontRegular(size: 16))
                .padding(.bottom, 8)
            
            ForEach(Array(oprionText.enumerated()), id: \.offset) { index, text in
                Button {
                    resetType = index
                    isPresented = false
                } label: {
                    HStack(spacing: 12){
                        Image(systemName: index == resetType ? "checkmark.circle" : "circle")
                            .resizable()
                            .foregroundColor(.black)
                            .tint(.black)
                            .frame(width: 24, height: 24)
                        
                        
                        Text(text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                            .font(.fontRegular(size: 16))
                        
                        
                    }
                    .padding(16)
                }
                .background(index == resetType ? Color.DesignSystem.skyBlue : .white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(index != resetType ? Color.DesignSystem.blue : .clear, lineWidth: 1)
                )
                
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var oprionText: [String] = [
        "Remote controller (with Wi-Fi button)",
        
        "Remote controller (without Wi-Fi button)",
        
        "Wired controller"
    ]
}


struct PV_ACConnectionViewX: View {
    
    var body : some View {
        ACConnectionViewX()
            .environmentObject(HomeViewModel.viewModel)
    }
}

#Preview {
    PV_ACConnectionViewX()
}
