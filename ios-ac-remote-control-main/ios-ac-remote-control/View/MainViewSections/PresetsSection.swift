//
//  PresetsSection.swift
//  ios-ac-remote-control
//
//  Created by mac on 23.04.2024.
//

import SwiftUI

struct MainSection1: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        
            
            
            
            
            HStack (spacing:16) {
                VStack(alignment: .leading) {
                    Button {
                        if viewModel.currentPreset.name == "home" {
                            viewModel.currentPreset = viewModel.presets.first(where: {$0.name == "current"})!
                        } else {
                            viewModel.currentPreset = viewModel.presets.first(where: {$0.name == "home"})!
                        }
                    } label: {
                        Text("Home")
                            .frame(maxWidth: .infinity)
                            .font(.fontBold(size: 16))
                            .padding()
                    }
                    .buttonStyle(myButtonStyle(type: (viewModel.currentPreset.name == "home") ? .usual : .usualBorderOnly))
                    
                    NavigationLink {
                        EditPresetView(presetViewModelCopy: viewModel.presets.first{$0.name ==
                            "home"}!.copyWithSamemanager())
                        
                    } label: {
                        HStack(spacing: 4) {
                            Image("icon_edit_")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12)
                            // Adjust the size as needed
                            Text("Edit")
                                .font(.fontMedium(size: 14))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                
                VStack (alignment: .leading) {
                    Button {
                        if viewModel.currentPreset.name == "away" {
                            viewModel.currentPreset = viewModel.presets.first(where: {$0.name == "current"})!
                        } else {
                            viewModel.currentPreset = viewModel.presets.first(where: {$0.name == "away"})!
                        }
                    } label: {
                        // Action to perform when the button is tapped
                        Text("Away")
                            .frame(maxWidth: .infinity)
                            .font(.fontBold(size: 16))
                            .padding()
                    }
                    .buttonStyle(myButtonStyle(type: viewModel.currentPreset.name == "away" ? .usual : .usualBorderOnly))
                    
                    NavigationLink {
                        EditPresetView(presetViewModelCopy: viewModel.presets.first{$0.name ==
                            "home"}!.copyWithSamemanager())
                    } label: {
                        HStack(spacing: 4) {
                            Image("icon_edit_")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12) // Adjust the size as needed
                            Text("Edit")
                                .font(.fontMedium(size: 14))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
            }
            .padding(.bottom, 40)
        
    }
}

#Preview {
    MainSection1()
        .environmentObject(HomeViewModel.viewModel)
}
