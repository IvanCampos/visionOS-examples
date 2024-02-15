//
//  APIResponseService.swift
//  LLLM
//
//  Created by IVAN CAMPOS on 2/15/24.
//

import Foundation

struct APIService {
    static func fetchResponse(userPrompt: String, completion: @escaping (String) -> Void) {
        
        var isRunningOnSimulator: Bool {
                #if targetEnvironment(simulator)
                // Code runs on Simulator
                return true
                #else
                // Code runs on Device
                return false
                #endif
            }
        
        var domain = "localhost"
        if (isRunningOnSimulator == false) {
            // ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}'
            domain = "ENTER THE IP ADDRESS OF THE MACHINE RUNNING LM STUDIO HERE"
        }
        //print(domain)
        
        let url = URL(string: "http://\(domain):1234/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": userPrompt]
            ],
            "temperature": 0.7,
            "max_tokens": -1,
            "stream": false
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                if let message = decodedResponse.choices.first?.message.content {
                    DispatchQueue.main.async {
                        completion(message)
                    }
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }.resume()
    }
}

struct APIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let role: String
    let content: String
}
