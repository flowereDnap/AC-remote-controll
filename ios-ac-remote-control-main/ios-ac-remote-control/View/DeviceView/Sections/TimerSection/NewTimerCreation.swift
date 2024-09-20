
import SwiftUI

enum weekDays: Hashable {
    case Mon(isOn: Bool)
    case Tue(isOn: Bool)
    case Wed(isOn: Bool)
    case Thu(isOn: Bool)
    case Fri(isOn: Bool)
    case Sat(isOn: Bool)
    case Sun(isOn: Bool)
    
    var name: String {
        switch self {
        case .Mon(_):
            "Mon"
        case .Tue(_):
            "Tue"
        case .Wed(_):
            "Wed"
        case .Thu(_):
            "Thu"
        case .Fri(_):
            "Fri"
        case .Sat(_):
            "Sat"
        case .Sun(_):
            "Sun"
        }
    }
}

struct NewTimerCreation: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var device: DeviceViewModel = DeviceViewModel.deviceViewModel
    @State var selectedTime = Date()
    @State var executionTypeOn: Bool = true
    @State var days: [Bool] = Array(repeating: false, count: 7)
    
    func dayName(day: Int ) -> String {
        switch day {
        case 0:
            "Mon"
        case 1:
            "Tue"
        case 2:
            "Wed"
        case 3:
            "Thu"
        case 4:
            "Fri"
        case 5:
            "Sat"
        case 6:
            "Sun"
        default:
            "sosubibu"
            
        }
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 20) {
                VStack(spacing: 12){
                    Text("Set The Time")
                        .font(.fontBold(size: 18))
                    
                    DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .environment(\.locale, .init(identifier: "en"))
                        .frame(width: 200)
                        .clipped()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 12)
                }
                
                HStack{
                    Text("Execution Type")
                        .font(.fontRegular(size: 16))
                        .padding()
                    Spacer()
                    
                            Button {
                        executionTypeOn.toggle()
                            } label: {
                                Text(executionTypeOn ? "On" : "Off")
                                            .foregroundColor(executionTypeOn ? .white : .black)
                                            .padding()
                            }
                            .background(executionTypeOn ? device.colors.main : device.colors.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                                
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 12){
                    
                    Text("Repeat")
                        .font(.fontRegular(size: 16))
                        .padding(.horizontal, 8)
                        .padding(.top, 12)
                    
                    HStack (spacing: 6.67){
                        ForEach(days.indices, id: \.self) { index in
                            
                            Button {
                                days[index].toggle()
                            } label: {
                                        Text(dayName(day: index))
                                            .foregroundColor(days[index] ? .white : .black)
                                            .font(.fontRegular(size: 14))
                                            .frame(width: 42)
                            }
                            .padding(.vertical, 8)
                            .background(days[index] ? device.colors.main : device.colors.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                Spacer()
                
                Button {
                    
                } label : {
                    Text("Save")
                        .font(.fontRegular(size: 16))
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(myButtonStyle(type: days.contains(true) ? .usual : .unavaliable, color: device.colors.main, secondaryColor: device.colors.secondary ))
                
                
            }
            .padding(.top, 38)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.DesignSystem.background)
        .navigationTitle("Add preset")
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
    NewTimerCreation()
}


