//
//  Fonts+Extension.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

enum CustomFont: String {
    case robotoMedium = "RobotoMono-Medium"
    case robotoRegular = "RobotoMono-Regular"
    
    func withSize(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            fatalError("Fonte \(self.rawValue) não encontrada.")
        }
        return font
    }
}
