//
//  UITableViewCell+Extensions.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(_ identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}
