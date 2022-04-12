//
//  MGColors.swift
//  MyGro
//
//  Created by Hut on 2021/12/10.
//  Copyright © 2021 Growatt New Energy Technology CO.,LTD. All rights reserved.
//

import UIKit

// MARK: - 颜色相关

var kThemeGradientColor_startColor: UIColor {
    return kHexColor("#69B836")
}

var kThemeGradientColor_endColor: UIColor {
    return kHexColor("#04CBD9")
}

var kThemeColor_color: UIColor {
    return kHexColor("#69B836")
}

var kThemeViewBackgroundColor_PPower_content: UIColor {
    return kHexColor("#FFFFFF")
}


func kRGBAColor(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b, alpha: a)
}
func kRGBColor(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
}
func kHexColorA(_ HexString: String,_ a: CGFloat) ->UIColor {
    return UIColor.colorWith(hexString: HexString, alpha: a)
}

func kHexColor(_ HexString: String) ->UIColor {
    return UIColor.colorWith(hexString: HexString)
}

// MARK: - 颜色相关
extension UIColor {
    // MARK: - Convert hex string to a UIColor instance
    class func colorWith(hexString:String, alpha: CGFloat = 1.0) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
