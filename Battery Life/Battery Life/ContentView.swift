//
//  ContentView.swift
//  Battery Life
//
//  Created by IVAN CAMPOS on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text(batteryLevelText)
                .font(.custom("SFProDisplay-Regular", size: 100))
                .foregroundColor(batteryColor)
                .padding()
            
            Text(batteryStateText)
                .font(.custom("SFProDisplay-Regular", size: 50))
                .padding()
        }
    }
    
    private var batteryLevelText: String {
        let level = viewModel.batteryLevel
        return level >= 0 ? "\(Int(level * 100))%" : "Unknown"
    }
    
    private var batteryColor: Color {
        switch viewModel.batteryLevel {
        case 0.0..<0.2: return .red
        case 0.2..<0.4: return .orange
        case 0.4..<0.6: return .yellow
        default: return .green
        }
    }
    
    private var batteryStateText: String {
        switch viewModel.batteryState {
        case .charging: return "􀢋"
        case .unplugged: return "Unplugged"
        case .full: return "􀛨"
        default: return "Unknown"
        }
    }
}
