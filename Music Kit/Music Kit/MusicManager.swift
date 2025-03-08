//
//  MusicManager.swift
//  Music Kit
//
//  Created by IVAN CAMPOS on 2/22/25.
//

import Foundation
import MusicKit
import SwiftUI

/// Potential custom error types for your MusicManager
enum MusicManagerError: Error {
    case notAuthorized
}

/// Manages Apple Music authorization, data fetching, and playback.
@MainActor
class MusicManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published var albums: [Album] = []
    @Published var songs: [Song] = []
    @Published var customSongs: [Song] = []
    @Published var playlists: [Playlist] = []
    @Published var selectedTracks: [Track] = []
    @Published var isAuthorized: Bool = false
    
    // (Optional) You can store the last error so the UI can display it if needed
    @Published var lastError: Error?

    // MARK: - Private Properties
    private var player: ApplicationMusicPlayer = .shared
    private let requestLimit = 12

    // MARK: - Authorization
    func requestAuthorization() {
        Task {
            let status = await MusicAuthorization.request()
            isAuthorized = (status == .authorized)
            if isAuthorized {
                print("Authorization granted")
            } else {
                print("Authorization denied or restricted")
            }
        }
    }
    
    // MARK: - Generic Catalog Search
    /// A reusable method for searching Apple Music for any MusicCatalogSearchable type
    func searchCatalog<T: MusicCatalogSearchable>(
        ofType type: T.Type,
        for searchTerm: String,
        limit: Int? = nil
    ) async throws -> MusicCatalogSearchResponse {
        guard isAuthorized else {
            throw MusicManagerError.notAuthorized
        }
        var request = MusicCatalogSearchRequest(term: searchTerm, types: [T.self])
        request.limit = limit ?? requestLimit
        return try await request.response()
    }
    
    // MARK: - Specific Search Examples
    func searchAlbums(for searchTerm: String) async {
        do {
            let response: MusicCatalogSearchResponse =
                try await searchCatalog(ofType: Album.self, for: searchTerm)
            albums = Array(response.albums)
        } catch {
            handleError(error, message: "Error searching albums")
        }
    }
    
    func searchSongs(for searchTerm: String) async {
        do {
            let response: MusicCatalogSearchResponse =
                try await searchCatalog(ofType: Song.self, for: searchTerm)
            songs = Array(response.songs)
        } catch {
            handleError(error, message: "Error searching songs")
        }
    }
    
    func searchPlaylists(for searchTerm: String) async {
        do {
            let response: MusicCatalogSearchResponse =
                try await searchCatalog(ofType: Playlist.self, for: searchTerm)
            playlists = Array(response.playlists)
        } catch {
            handleError(error, message: "Error searching playlists")
        }
    }

    // MARK: - Fetching Detailed Resources
    func fetchTracks(for album: Album) {
        guard isAuthorized else {
            print("Not authorized to access Apple Music")
            return
        }
        Task {
            do {
                let detailedAlbum = try await album.with([.tracks])
                selectedTracks = Array(detailedAlbum.tracks ?? [])
            } catch {
                handleError(error, message: "Error fetching album tracks")
            }
        }
    }
    
    func fetchPlaylistItems(for playlist: Playlist) {
        guard isAuthorized else {
            print("Not authorized to access Apple Music")
            return
        }
        Task {
            do {
                let detailedPlaylist = try await playlist.with([.tracks])
                selectedTracks = Array(detailedPlaylist.tracks ?? [])
            } catch {
                handleError(error, message: "Error fetching playlist tracks")
            }
        }
    }

    // MARK: - Specific Custom Songs
    func getCustomSongs() async {
        // Just an example array of fixed IDs
        var request = MusicCatalogResourceRequest<Song>(matching: \.id, memberOf: ["1737281142", "1742262123", "1757581944", "1660487909", "1692289011", "1770737897", "1703356592", "1609402381", "1717738435", "1702984168",
            "1624618717", "1703356821"])
        request.limit = requestLimit
        
        do {
            let response = try await request.response()
            customSongs = Array(response.items)
        } catch {
            handleError(error, message: "Error getting custom songs")
        }
    }
    
    // MARK: - Playback
    func playTrack(_ track: Track) {
        guard isAuthorized else {
            print("Not authorized to access Apple Music")
            return
        }
        Task {
            do {
                player.queue = [track]
                try await player.play()
            } catch {
                handleError(error, message: "Error playing track")
            }
        }
    }
    
    func playSong(_ song: Song) {
        guard isAuthorized else {
            print("Not authorized to access Apple Music")
            return
        }
        Task {
            do {
                player.queue = [song]
                try await player.play()
            } catch {
                handleError(error, message: "Error playing song")
            }
        }
    }
    
    func stopPlayback() {
        Task {
            player.stop()
        }
    }
    
    func pausePlayback() {
        Task {
            player.pause()
        }
    }
    
    func getPlaybackStatus() -> MusicPlayer.PlaybackStatus {
        player.state.playbackStatus
    }
    
    func isPlaying() -> Bool {
        getPlaybackStatus() == .playing
    }
    
    // MARK: - Fetching Single Items or Music Videos
    func fetchSongMetadata(songID: MusicItemID) async throws -> Song? {
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: songID)
        let response = try await request.response()
        return response.items.first
    }

    func fetchMusicVideos(for artistName: String) async throws -> MusicItemCollection<MusicVideo> {
        let request = MusicCatalogSearchRequest(term: artistName, types: [MusicVideo.self])
        let response = try await request.response()
        return response.musicVideos
    }
    
    // MARK: - Fetch All Songs for an Artist
    func fetchSongsForArtist(artistName: String) async {
        do {
            // 1. Search for the artist
            var searchRequest = MusicCatalogSearchRequest(term: artistName, types: [Artist.self])
            searchRequest.limit = 1
            let searchResponse = try await searchRequest.response()
            
            guard let artist = searchResponse.artists.first else {
                print("Artist not found.")
                return
            }
            
            // 2. Fetch detailed artist info
            let artistRequest = MusicCatalogResourceRequest<Artist>(matching: \.id, equalTo: artist.id)
            let artistResponse = try await artistRequest.response()
            
            guard let detailedArtist = artistResponse.items.first else {
                print("Could not fetch detailed artist info.")
                return
            }
            
            // 3. Fetch the artist's songs
            var songsRequest = MusicCatalogSearchRequest(term: detailedArtist.name, types: [Song.self])
            songsRequest.limit = 25
            let songsResponse = try await songsRequest.response()
            
            let fetchedSongs = songsResponse.songs
            let filteredSongs = fetchedSongs.filter { $0.artistName.contains(detailedArtist.name) }
            
            // Modify customSongs (already published)
            customSongs.append(contentsOf: filteredSongs)
            
        } catch {
            handleError(error, message: "Error fetching songs for artist")
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: Error, message: String) {
        print("\(message): \(error)")
        lastError = error // Store if you'd like to display it in the UI
    }
}
