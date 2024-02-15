//
//  APIResponseViewModel.swift
//  LLLM
//
//  Created by IVAN CAMPOS on 2/15/24.
//

import SwiftUI
import Combine

class APIResponseViewModel: ObservableObject {
    @Published var prompt: String = ""
    @Published var responseMessage: String = ""
    
    func fetchAPIResponse(with userPrompt: String) {
        APIService.fetchResponse(userPrompt: userPrompt) { response in
            DispatchQueue.main.async {
                self.responseMessage = response
            }
        }
    }
}

