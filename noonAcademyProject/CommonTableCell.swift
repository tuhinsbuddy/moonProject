//
//  CommonTableCell.swift
//  noonAcademyProject
//
//  Created by Tuhin Samui on 04/04/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class CommonTableCell: UITableViewCell {

    @IBOutlet weak var subjectDetailsMainStackView: UIStackView!
    @IBOutlet weak var subjectDescriptionLbl: UILabel!
    @IBOutlet weak var titleForTheCell: UILabel!
    @IBOutlet weak var imageForTheCell: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
