//
//  FearGreedIndexService.swift
//  FearAndGreed
//
//  Created by IVAN CAMPOS on 2/16/24.
//

import Foundation

class FearGreedIndexService {
    func fetchIndex(completion: @escaping (FearGreedIndex?) -> Void) {
        guard let url = URL(string: "https://api.alternative.me/fng/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let response = try? JSONDecoder().decode(FearGreedIndex.self, from: data)
            completion(response)
        }.resume()
    }
}

struct FearGreedIndex: Decodable {
    let data: [IndexData]
    
    struct IndexData: Decodable {
        let value_classification: String
    }
}
