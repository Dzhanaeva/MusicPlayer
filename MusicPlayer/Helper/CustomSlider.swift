//
//  CustomSlider.swift
//  MusicPlayer
//
//  Created by Гидаят Джанаева on 25.12.2024.
//

import SwiftUI

struct CustomProgressBar: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var onEditingEnded: ((Double) -> Void)?
    var trackColor: Color = .black

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 3)
                
                Rectangle()
                    .fill(trackColor)
                    .frame(width: CGFloat(value / (range.upperBound - range.lowerBound)) * geometry.size.width, height: 3)
            }
            .cornerRadius(2)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
               
                        let newValue = Double(gesture.location.x / geometry.size.width) * (range.upperBound - range.lowerBound)
                        value = max(range.lowerBound, min(range.upperBound, newValue))
                    }
                    .onEnded { gesture in
        
                        let newValue = Double(gesture.location.x / geometry.size.width) * (range.upperBound - range.lowerBound)
                        let clampedValue = max(range.lowerBound, min(range.upperBound, newValue))
                        onEditingEnded?(clampedValue)
                    }
            )
        }
        .frame(height: 20)
    }
}
