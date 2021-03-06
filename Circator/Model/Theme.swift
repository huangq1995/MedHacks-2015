
//
//  Theme.swift
//  Circator
//
//  Created by Sihao Lu on 10/1/15.
//  Copyright © 2015 Yanif Ahmad, Tom Woolf. All rights reserved.
//

import UIKit

class Theme: NSObject {
    static let universityDarkTheme = Theme(.White, .Blue, .White, .Custom(Color.White.color.colorWithAlphaComponent(0.75)), complementForegroundColors: [.Emerald, .Gray])!
    
    enum Color {
        case Blue
        case Emerald
        case White
        case Gray
        case Black
        case Custom(UIColor)
        
        var color: UIColor {
            switch self {
            case .Black:
                return UIColor.blackColor()
            case .Emerald:
                return UIColor(red: 71 / 255.0, green: 201 / 255.0, blue: 113 / 255.0, alpha: 1)
            case .White:
                return UIColor.whiteColor()
            case .Gray:
                return UIColor(white: 155 / 255.0, alpha: 1)
            case .Blue:
                return UIColor(red: 0, green: 45 / 255.0, blue: 114 / 255.0, alpha: 1)
            case .Custom(let color):
                return color
            }
        }
    }
    
    class ForegroundColorGroup: ArrayLiteralConvertible {
        let foregroundColors: [Color]
        
        required convenience init(arrayLiteral elements: Color...) {
            self.init(foregroundColors: elements)
        }
        
        init(foregroundColors: [Color]) {
            self.foregroundColors = foregroundColors.sort { c1, c2 -> Bool in
                var saturation1: CGFloat = 0
                var saturation2: CGFloat = 0
                c1.color.getHue(nil, saturation: &saturation1, brightness: nil, alpha: nil)
                c2.color.getHue(nil, saturation: &saturation2, brightness: nil, alpha: nil)
                return saturation1 < saturation2
            }
        }
        
        /**
            Returns a foreground color with desired vibrancy (saturation)
        
            - parameter vibrancy: The desired vibrancy, ranged from 0.0 to 1.0.
            - returns: A color with desired vibrancy.
        */
        func colorWithVibrancy(vibrancy: CGFloat) -> UIColor? {
            let index = Int(floor(vibrancy * CGFloat(foregroundColors.count)))
            if index < 0 {
                return foregroundColors.first?.color
            } else if index >= foregroundColors.count {
                return foregroundColors.last?.color
            } else {
                return foregroundColors[index].color
            }
        }
    }
    
    var foregroundColor: UIColor
    
    var backgroundColor: UIColor
    
    var titleTextColor: UIColor
    
    var bodyTextColor: UIColor
    
    var complementForegroundColors: ForegroundColorGroup?

    init?(_ colors: Color..., complementForegroundColors: ForegroundColorGroup? = nil) {
        guard colors.count >= 4 else {
            foregroundColor = UIColor()
            backgroundColor = UIColor()
            titleTextColor = UIColor()
            bodyTextColor = UIColor()
            super.init()
            return nil
        }
        foregroundColor = colors[0].color
        backgroundColor = colors[1].color
        titleTextColor = colors[2].color
        bodyTextColor = colors[3].color
        self.complementForegroundColors = complementForegroundColors
        super.init()
    }
    
}
