import UIKit

class TableViewController: UITableViewController {
    @IBOutlet weak var yearField: UITextField!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var genreField: UITextField!
    
    @IBOutlet weak var artistField: UITextField!
    
    @IBOutlet weak var tracksField: UITextField!
    
    @IBOutlet weak var navLabel: UINavigationItem!
    
    var musicRecords: [MusicRecord] = []
    var index: Int = -1
    var masterViewController:
        MasterViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (index >= 0) {
            showCurrentRecord()
            navLabel.title = "Edycja rekordu \(index + 1) z \(musicRecords.count)"
        } else {
            navLabel.title = ""
        }
    }
    
    func showCurrentRecord() {
        let record = musicRecords[index]
        yearField.text = "\(record.year)"
        titleField.text = record.album
        genreField.text = record.genre
        artistField.text = record.artist
        tracksField.text = "\(record.tracks)"
    }

    @IBAction func editingMode(_ sender: Any) {
        if (index >= 0) {
            let artist = artistField.text ?? ""
            let album = titleField.text ?? ""
            let genre = genreField.text ?? ""
            let year = Int(yearField.text ?? "0") ?? 0
            let tracks = Int(tracksField.text ?? "0") ?? 0
            
            let record = MusicRecord(artist, album, genre, year, tracks)
            
            musicRecords[index] = record
        }
        
        self.masterViewController?.updateRecords(musicRecords)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
