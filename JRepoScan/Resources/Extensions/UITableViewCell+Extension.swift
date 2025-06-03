//
//  UITableViewCell+Extension.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 28/05/25.
//

import UIKit

extension UITableViewCell {
    func isPortuguese(text: String) -> Bool {
        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        tagger.string = text
        let language = tagger.dominantLanguage
        return language == "pt"
    }
}
