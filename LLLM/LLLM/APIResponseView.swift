//
//  APIResponseView.swift
//  LLLM
//
//  Created by IVAN CAMPOS on 2/15/24.
//

import SwiftUI

struct APIResponseView: View {
    @StateObject private var viewModel = APIResponseViewModel()
    
    var body: some View {
        VStack {
            
            SearchBar(text: $viewModel.prompt, onSearchButtonClicked: {
                viewModel.fetchAPIResponse(with: viewModel.prompt)
            })
            .padding()
            
            Button("Send Prompt") {
                viewModel.fetchAPIResponse(with: viewModel.prompt)
            }
            .padding()
            
            if !viewModel.responseMessage.isEmpty {
                Text("Response: \(viewModel.responseMessage)")
                    .padding()
            }
        }
    }
}
