//
//  CityTableViewCell.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonPlay: UIButton!
    
    var playPressed: (()->Void)?
    
    override var reuseIdentifier: String {
        return TrackTableViewCell.className
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func passData(title: String) {
        self.labelTitle.text = title
    }
    
    @IBAction
    private func playPressed(_ sender: UIButton) {
        self.playPressed?()
    }

}

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
