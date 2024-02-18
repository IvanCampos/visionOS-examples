//
//  FearGreedIndexViewModel.swift
//  FearAndGreed
//
//  Created by IVAN CAMPOS on 2/16/24.
//

import Combine
import SwiftUI

class FearGreedIndexViewModel: ObservableObject {
    private var service = FearGreedIndexService()
    private var timer: Timer?
    
    @Published var classification: String = ""
    
    init() {
        fetchData()
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            self.fetchData()
        }
    }
    
    func fetchData() {
        self.classification = ""
        service.fetchIndex { [weak self] response in
            DispatchQueue.main.async {
                self?.classification = response?.data.first?.value_classification.uppercased() ?? ""
            }
        }
    }
}
