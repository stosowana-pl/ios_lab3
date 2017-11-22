import Foundation

class MusicRecord {
    let artist: String
    let album: String
    let genre: String
    let year: Int
    let tracks: Int
    
    init(_ artist: String, _ album: String, _ genre: String, _ year: Int, _ tracks: Int) {
        
        self.artist = artist
        self.album = album
        self.genre = genre
        self.year = year
        self.tracks = tracks
    }
}
