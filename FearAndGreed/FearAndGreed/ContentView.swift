//
//  ContentView.swift
//  FearAndGreed
//
//  Created by IVAN CAMPOS on 2/16/24.
//

import SwiftUI

let EXTREME_FEAR = "EXTREME FEAR"
let FEAR = "FEAR"
let GREED = "GREED"
let EXTREME_GREED = "EXTREME GREED"

struct ContentView: View {
    @StateObject var viewModel = FearGreedIndexViewModel()
    
    var body: some View {
        VStack {
            RectangleView(classification: EXTREME_FEAR, currentClassification: $viewModel.classification)
            RectangleView(classification: FEAR, currentClassification: $viewModel.classification)
            RectangleView(classification: GREED, currentClassification: $viewModel.classification)
            RectangleView(classification: EXTREME_GREED, currentClassification: $viewModel.classification)
        }
    }
}

struct RectangleView: View {
    let classification: String
    @Binding var currentClassification: String
    
    var body: some View {
        
        var classificationColor = colorForClassification(classification)
        
        Text(classification)
            .bold()
            .font(.largeTitle)
            .frame(width: 400, height: 100)
            .background(classificationColor)
            .cornerRadius(10)
            .padding()
            .scaleEffect(currentClassification == classification ? 1.1 : 1.0)
            .shadow(color: classificationColor, radius: 12, x: 0, y: 0)
            .animation(.easeInOut(duration: 1).repeatForever(), value: currentClassification == classification)
    }
    
    func colorForClassification(_ classification: String) -> Color {
        guard classification == currentClassification else { return Color(uiColor: UIColor(hex: ColorName.coolGrey.rawValue)!) }
        switch classification {
        case EXTREME_FEAR:
            return Color(uiColor: UIColor(hex: ColorName.supreme.rawValue)!)
        case FEAR:
            return Color(uiColor: UIColor(hex: ColorName.yeezy1.rawValue)!)
        case GREED:
            return Color(uiColor: UIColor(hex: ColorName.ok.rawValue)!)
        case EXTREME_GREED:
            return Color(uiColor: UIColor(hex: ColorName.matrix.rawValue)!)
        default:
            return Color(uiColor: UIColor(hex: ColorName.coolGrey.rawValue)!)
        }
    }
}
