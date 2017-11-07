//
//  MasterViewController.swift
//  lab_splitview
//
//  Created by Avasil on 04/11/2017.
//  Copyright © 2017 Avasil. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    var musicRecords = [MusicRecord]()
    var currentRecord: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
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
    
    func updateView(){
//        self.existingRecordView()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

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
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

