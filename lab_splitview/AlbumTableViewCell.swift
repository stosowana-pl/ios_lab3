import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var AlbumField: UILabel!
    
    @IBOutlet weak var YearField: UILabel!
    
    @IBOutlet weak var ArtistField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
