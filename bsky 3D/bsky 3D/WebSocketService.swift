//
//  WebSocketService.swift
//  WebSockets
//
//  Created by IVAN CAMPOS on 11/24/24.
//

import Foundation
import SwiftUI

class WebSocketService: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    //ALL -> "wss://jetstream2.us-west.bsky.network/subscribe"
    //POSTS -> "wss://jetstream2.us-east.bsky.network/subscribe?wantedCollections=app.bsky.feed.post"
    /*
     "wss://jetstream2.us-west.bsky.network/subscribe?
     wantedCollections=app.bsky.feed.post&
     wantedCollections=app.bsky.feed.like&
     wantedCollections=app.bsky.graph.follow&
     wantedDids=did:plc:q6gjnaw2blty4crticxkmujt&
     cursor=1725519626134432"
    */
    private let url = URL(string: "wss://jetstream2.us-east.bsky.network/subscribe?wantedCollections=app.bsky.feed.post")!
    
    @Published var postText: String = "Loading..."
    
    init() {
        
    }
    
    deinit {
        disconnect()
    }
    
    func connect() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessage()
        
        // Setup a ping/pong mechanism to keep the connection alive or detect disconnections.
        setupHeartbeat()
    }
    
    private func setupHeartbeat() {
        // Send a ping at regular intervals
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.webSocketTask?.sendPing { error in
                if let error = error {
                    print("Ping failed: \(error.localizedDescription)")
                    self?.reconnect()
                }
            }
        }
    }
    
    private func reconnect() {
        disconnect()
        connect()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleMessage(text)
                case .data(let data):
                    //print("Received data: \(data)")
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleMessage(text)
                    }
                default:
                    break
                }
                
                self?.receiveMessage() // Keep listening
            }
        }
    }
    
    private func handleMessage(_ text: String) {
        guard let jsonData = text.data(using: .utf8) else {
            print("Invalid JSON string.")
            return
        }

        do {
            let root = try JSONDecoder().decode(Root.self, from: jsonData)
            
            guard let commit = root.commit else {
                print("Commit data is missing.")
                return
            }
            
            if let currentCollection = commit.collection, let currentRecord = commit.record?.text {
                // print("Collection: \(currentCollection), Record: \(currentRecord)")
                
                DispatchQueue.main.async {
                    if currentRecord.range(
                        of: "$AAPL|bitcoin|Vision Pro|visionOS|BTC|XG|Miami Dolphins|xgalx|Dodgers|Boston|xcode|swiftUI|realityKit|spatial comp|reality|XR|simulation|immers|virtual reality|augmented reality|mixed reality|extended reality|artificial intelligence|openAI|futur|ethereum|kendrick|3D|bluesky|midjourney|ai art|aiart|tesla|GPT|nike|ps5|$ETH|innovation|NFL|NBA|starter pack|𝕏||₿|matrix|inception|cyber|playstation|skynet|robot",
                        options: [.regularExpression, .caseInsensitive]) != nil {
                        self.postText = currentRecord
                    }
                }
            } else {
                print("Missing required fields: collection or record text.")
            }
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key.stringValue)' not found:", context.debugDescription)
        } catch let DecodingError.valueNotFound(type, context) {
            print("Value of type '\(type)' not found:", context.debugDescription)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type mismatch for type '\(type)':", context.debugDescription)
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted:", context.debugDescription)
        } catch {
            print("Unknown error: \(error.localizedDescription)")
        }
    }
}
