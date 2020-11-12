//
//  UIImaviewView+Extensions.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import Foundation
import UIKit

extension UIImage {
    
    func icon(size: Int) -> UIImage {
        let sizeValue = CGSize(width: size, height: size)
        return self.resize(targetSize: sizeValue)
    }
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
