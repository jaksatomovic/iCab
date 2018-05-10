//
//  Colors.swift
//  eKorcula
//
//  Created by Jaksa Tomovic on 27/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit


typealias Pallete = UIColor
extension Pallete {
    class var palette_main: UIColor {
        return UIColor(red: 144/255, green: 19/255, blue: 254/255, alpha:1)
    }
    
    class var palette_blue: UIColor {
        return UIColor(red:0.22, green:0.49, blue:0.81, alpha:1)
    }
    
    class var palette_yellow: UIColor {
        return UIColor(red: 245.0/255.0, green: 192.0/255.0, blue: 24.0/255.0, alpha: 1)
    }
    
    class var palette_confirm: UIColor {
        return UIColor(red:0.6, green:0.8, blue:0.37, alpha:1)
    }
    
    class var palette_destructive: UIColor {
        return UIColor(red:0.75, green:0.22, blue:0.17, alpha:1)
    }
    
    class var palette_lightBlue: UIColor {
        return UIColor(red: 112/255, green: 200/255, blue: 224/255, alpha: 1.0)
    }
    
    class var palette_lightGray: UIColor {
        return UIColor(red:0.91, green:0.91, blue:0.92, alpha:1)
    }
    
    class var palette_buttonGray: UIColor {
        return UIColor(red:194/255, green:198/255, blue:218/255, alpha:1)
    }
    
    class var palette_extraLight: UIColor {
        return UIColor(red:249/255, green:249/255, blue:249/255, alpha:1)
    }
    
}

