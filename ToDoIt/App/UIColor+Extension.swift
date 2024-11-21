//
//  UIColor+Extension.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import UIKit

extension UIColor {
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        var red, green, blue, alpha: CGFloat
        if hexSanitized.count == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        } else if hexSanitized.count == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
            alpha = 1.0
        } else {
            return nil
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
