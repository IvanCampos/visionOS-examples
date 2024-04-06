//
//  Extensions.swift
//  Countdown
//
//  Created by IVAN CAMPOS on 3/17/24.
//

import SwiftUI

// Function to create UIColor from hex string
extension UIColor {
    convenience init(hex: String) {
        
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
