//
//  NoteBookCell.swift
//  NoteBookSchool
//
//  Created by نجود  on 23/09/1443 AH.
//

import UIKit

class NoteBookCell: UITableViewCell {

    @IBOutlet weak var noteTitleLable: UILabel!
    @IBOutlet weak var noteDateLable: UILabel!
    @IBOutlet weak var noteImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
