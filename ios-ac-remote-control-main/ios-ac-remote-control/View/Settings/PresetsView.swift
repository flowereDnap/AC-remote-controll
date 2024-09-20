

import SwiftUI

struct PresetsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var homeIsShowing = false
    @State var awayIsShowing = false
    
    
    var body: some View {
        ZStack{
            Color.DesignSystem.background.ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 12) {
                
                VStack(spacing: 0){
                    HStack {
                        Image("icon_smart_home_")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                        
                        
                        
                        Text("Home")
                            .font(.fontRegular(size: 14))
                            .foregroundColor(Color.DesignSystem.black)
                            .lineLimit(2)
                        Spacer()
                        Button {
                            homeIsShowing.toggle()
                        } label: {
                            Image("icon_back_")
                                .rotationEffect(.degrees(homeIsShowing ? 90 : -90))
                        }
                    }
                    
                    VStack {
                        Spacer().frame(height: 0)
                        Toggle(isOn: $homeIsShowing, label: {
                            Text("Turn On/Off")
                                .font(.fontRegular(size: 16))
                        })
                        
                        NavigationLink {
                            
                        } label: {
                            Text("Edit")
                                .font(.fontRegular(size: 16))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.DesignSystem.skyBlue)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            
                        }
                    }
                    .padding(.top, 24)
                    .frame(height: homeIsShowing ? nil : 0, alignment: .top)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                
                VStack(spacing: 0){
                    HStack {
                        Image("icon_car_")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                        Text("Away")
                            .font(.fontRegular(size: 14))
                            .foregroundColor(Color.DesignSystem.black)
                            .lineLimit(2)
                        Spacer()
                        Button {
                            awayIsShowing.toggle()
                        } label: {
                            Image("icon_back_")
                                .rotationEffect(.degrees(awayIsShowing ? 90 : -90))
                        }
                    }
                    
                    VStack {
                        Spacer().frame(height: 0)
                        Toggle(isOn: $awayIsShowing, label: {
                            Text("Turn On/Off")
                                .font(.fontRegular(size: 16))
                        })
                        
                        NavigationLink {
                            
                        } label: {
                            Text("Edit")
                                .font(.fontRegular(size: 16))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.DesignSystem.skyBlue)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            
                        }
                    }
                    .padding(.top, 24)
                    .frame(height: awayIsShowing ? nil : 0, alignment: .top)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            
            
        }
        .animation(.easeInOut(duration: 0.5), value: homeIsShowing)
        .animation(.easeInOut(duration: 0.5), value: awayIsShowing)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button {
                dismiss()
            } label: {
                Image("icon_back_")
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PresetsView()
}
