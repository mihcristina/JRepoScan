//
//  UIColors+Extension.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Remove o "#" se existir
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        // Verifica se o hex tem 6 ou 8 caracteres (RGB ou ARGB)
        guard hexString.count == 6 || hexString.count == 8 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        if hexString.count == 6 {
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: 1.0
            )
        } else {
            self.init(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000FF) / 255.0
            )
        }
    }
}

enum AppColor: String {
    case background = "#1E1E2F"
    case accent = "#8E44AD"
    case star = "#F1C40F"
    case fork = "#2ECC71"
    case primary = "#E0E0E0"
    case secondary = "#A0A0B0"

    var color: UIColor? {
        return UIColor(hex: self.rawValue)
    }
}
