//
//  AlbumTableViewCell.swift
//  lab_splitview
//
//  Created by Avasil on 05/11/2017.
//  Copyright © 2017 Avasil. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var AlbumField: UILabel!
    
    @IBOutlet weak var YearField: UILabel!
    
    @IBOutlet weak var ArtistField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
