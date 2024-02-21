//
//  ContentView.swift
//  WebSockets
//
//  Created by IVAN CAMPOS on 1/28/24.
//

import SwiftUI


// Main ContentView
struct ContentView: View {
    @ObservedObject var webSocketService = WebSocketService()
    
    var body: some View {
        VStack {
            // BTC-USD
            VStack {
                Text("Bitcoin")
                    .font(.largeTitle)
                Text("")
                Text(formatAsCurrency(webSocketService.btcPrice))
                    .scaleEffect(1.5)
            }
            .padding()
            
            // ETH-USD
            VStack {
                Text("Ethereum")
                    .font(.largeTitle)
                Text("")
                Text(formatAsCurrency(webSocketService.ethPrice))
                    .scaleEffect(1.5)
            }
            .padding()
        }
        .onAppear {
            webSocketService.connect()
        }
        .onDisappear {
            webSocketService.disconnect()
        }
    }
    
    private func formatAsCurrency(_ priceString: String) -> String {
        guard let priceValue = Double(priceString) else { return priceString }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: priceValue)) ?? priceString
    }
    
}

