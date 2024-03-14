//
//  ViewModel.swift
//  Battery Life
//
//  Created by IVAN CAMPOS on 3/13/24.
//

import SwiftUI

// BatteryViewModel.swift
class ViewModel: ObservableObject {
    @Published var batteryLevel: Float = UIDevice.current.batteryLevel
    @Published var batteryState: UIDevice.BatteryState = UIDevice.current.batteryState
    
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        updateBatteryStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBatteryStatus), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBatteryStatus), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    @objc private func updateBatteryStatus() {
        self.batteryLevel = UIDevice.current.batteryLevel
        self.batteryState = UIDevice.current.batteryState
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
