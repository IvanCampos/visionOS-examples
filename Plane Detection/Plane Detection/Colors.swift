import UIKit
import ARKit

enum ColorName: String {
    case matrix = "#00ff2b"
    case tiffany = "#00FFEC"
    case darkG = "#474747"
    case lightG = "#f4f4f8"
    case coffee = "#be9b7b"
    case tone = "#f1c27d"
    case blueGray = "#6497b1"
    case supreme = "#FF0400"

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

func colorForPlaneClassification(classification: PlaneAnchor.Classification) -> UIColor {
    switch(classification) {
    case .ceiling:
        return UIColor(hex: ColorName.tiffany.rawValue)!
    case .door:
        return UIColor(hex: ColorName.coffee.rawValue)!
    case .floor:
        return UIColor(hex: ColorName.tone.rawValue)!
    case .notAvailable:
        return .clear
    case .seat:
        return UIColor(hex: ColorName.matrix.rawValue)!
    case .table:
        return UIColor(hex: ColorName.lightG.rawValue)!
    case .undetermined:
        return .black
    case .unknown:
        return UIColor(hex: ColorName.darkG.rawValue)!
    case .wall:
        return UIColor(hex: ColorName.supreme.rawValue)!
    case .window:
        return UIColor(hex: ColorName.blueGray.rawValue)!
    @unknown default:
        return UIColor(hex: ColorName.darkG.rawValue)!
    }
}
