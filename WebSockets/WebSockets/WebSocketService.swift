//
//  WebSocketService.swift
//  WebSockets
//
//  Created by IVAN CAMPOS on 1/28/24.
//

import Foundation
import SwiftUI

class WebSocketService: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private let url = URL(string: "wss://ws-feed.exchange.coinbase.com")!
    
    @Published var btcPrice: String = "Loading..."
    @Published var ethPrice: String = "Loading..."
    
    init() {
        
    }
    
    deinit {
        disconnect()
    }
    
    func connect() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        sendSubscriptionMessage()
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
    
    private func sendSubscriptionMessage() {
        let subscriptionMessage: [String: Any] = [
            "type": "subscribe",
            "product_ids": ["BTC-USD", "ETH-USD"],
            "channels": [["name": "ticker", "product_ids": ["BTC-USD", "ETH-USD"]]]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: subscriptionMessage, options: []) else {
            print("Error: Unable to serialize subscription message to JSON")
            return
        }
        
        webSocketTask?.send(.data(jsonData)) { error in
            if let error = error {
                print("Error in sending message: \(error)")
            }
        }
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
                    print("Received data: \(data)")
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
        if let data = text.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let type = jsonObject["type"] as? String, type == "ticker",
                   let productId = jsonObject["product_id"] as? String,
                   let price = jsonObject["price"] as? String {
                    DispatchQueue.main.async {
                        if productId == "BTC-USD" {
                            self.btcPrice = price
                        } else if productId == "ETH-USD" {
                            self.ethPrice = price
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
    }
    
}
