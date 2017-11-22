import UIKit

class MasterViewController: UITableViewController {

    var musicRecords = [MusicRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestData()
    }
    
    func parseJson(_ json: [String: Any]) -> MusicRecord? {
        guard let artist = json["artist"] as? String,
            let album = json["album"] as? String,
            let genre = json["genre"] as? String,
            let year = json["year"] as? Int,
            let tracks = json["tracks"] as? Int
            else {
                return nil
        }
        return MusicRecord(artist, album, genre, year, tracks)
    }
    
    func requestData() {
        let session = URLSession.shared
        let url = URL.init(string: "https://isebi.net/albums.php")
        
        session.dataTask(with: url!, completionHandler: { (maybeData: Data?, _, _) in
            if let data = maybeData,
                let maybeJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                let json = maybeJson {
                for singleRecord in json {
                    if let newRecord = self.parseJson(singleRecord){
                        self.musicRecords.append(newRecord)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    func updateRecords(_ records: [MusicRecord]){
        self.musicRecords = records
        DispatchQueue.main.async { self.tableView.reloadData()  }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! TableViewController
                controller.musicRecords = musicRecords
                controller.index = indexPath.row
                controller.masterViewController = self
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "add" {
            let controller = (segue.destination as! UINavigationController).topViewController as! TableViewController
            controller.musicRecords = musicRecords
            controller.index = musicRecords.count - 1
            controller.masterViewController = self
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    @IBAction func addNewRecord(_ sender: Any) {
        musicRecords.append(MusicRecord("", "", "", 0, 0))
        performSegue(withIdentifier: "add", sender: sender)
    }
    
    @IBAction
    func delete(for segue: UIStoryboardSegue) {
        let detailView = segue.source as! TableViewController
        if (detailView.index >= 0) {
            detailView.artistField.text = ""
            detailView.titleField.text = ""
            detailView.genreField.text = ""
            detailView.yearField.text = ""
            detailView.tracksField.text = ""
            detailView.navLabel.title = ""

            self.musicRecords.remove(at: detailView.index)
            self.tableView.reloadData()

            detailView.index = -1;
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicRecords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
        let album = musicRecords[indexPath.row]
        cell.AlbumField.text = album.album
        cell.ArtistField.text = album.artist
        cell.YearField.text = String(album.year)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
