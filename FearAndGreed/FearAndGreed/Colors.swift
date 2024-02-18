//
//  Colors.swift
//  Swift Helpers
//
//  Created by IVAN CAMPOS on 2/13/24.
//

import UIKit

enum ColorName: String {
    case money = "#85bb65"
    case tron = "#18CAE6"
    case matrix = "#00ff2b"
    case offWhite = "#fffff0"
    case akira = "#9C3111"
    case dark = "#424242"
    case orange = "#E65100"
    case dolphinsAqua = "#008E97"
    case dolphinsOrange = "#FC4C02"
    case usRed = "#BF0A30"
    case usBlue = "#002868"
    case coolGrey = "#5E6167"
    case yeezy1 = "#EF4657"
    case foams = "#1E3F9F"
    case tiffany = "#00FFEC"
    case jordan1 = "#B01301"
    case volt = "#CEFF00"
    case violet = "#6B5B95"
    case sailor = "#2E4A62"
    case tomato = "#E94B3C"
    case ok = "#00ff7f"
    case seafoam = "#C4DFE6"
    case darkG = "#474747"
    case yellow = "#F7DB4F"
    case lightG = "#f4f4f8"
    case rb = "#251e3e"
    case blue = "#0392cf"
    case coffee = "#be9b7b"
    case tone = "#f1c27d"
    case fall = "#c9cba3"
    case blueGray = "#6497b1"
    case lightY = "#fdf498"
    case prBlue = "#50eee0"
    case prRed = "#ed0000"
    case dodgers = "#1e90ff"
    case nikeBox = "#ec4e33"
    case bitcoin = "#ff9900"
    case supreme = "#FF0400"
    case nvidia = "#76b900"
    case playstation = "#003087"
    case spotify = "#191414"
    case tesla = "#cc0000"
    
    var color: UIColor {
        return UIColor(hex: self.rawValue) ?? .black
    }
}

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
