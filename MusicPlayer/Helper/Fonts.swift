//
//  Fonts.swift
//  MusicPlayer
//
//  Created by Гидаят Джанаева on 18.11.2024.
//

import SwiftUI

extension Text {
    func nameFont() -> some View {
        self
            .foregroundStyle(.black)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            
    }
    
    func nameFontMax() -> some View {
        self
            .foregroundStyle(.black)
            .font(.system(size: 25, weight: .bold, design: .rounded))
            
    }
    
    func artistFont() -> some View {
        self
            .foregroundStyle(.gray)
            .font(.system(size: 16, weight: .medium, design: .rounded))
            
    }
    
    func artistFontTwo() -> some View {
        self
            .foregroundStyle(.gray)
            .font(.system(size: 18, weight: .light, design: .rounded))
            
    }
}

struct Fonts: View {
    var body: some View {
        VStack {
            Text("Title")
                .nameFont()
            Text("author")
                .artistFont()
            HStack {
                Text("00:00")
                Spacer()
                Text("03:12")
            }
            .durationFont()
        }
    }
}

struct DurationFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.gray)
            .font(.system(size: 13, weight: .light, design: .rounded))
    }
}

extension View {
    func durationFont() -> some View {
        self.modifier(DurationFontModifier())
    }
}

extension UIImage {
    func dominantColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        let width = 1
        let height = 1
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var pixelData = [UInt8](repeating: 0, count: 4)
        let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        if pixelData[3] > 0 { // Avoid division by zero
            let red = CGFloat(pixelData[0]) / CGFloat(pixelData[3])
            let green = CGFloat(pixelData[1]) / CGFloat(pixelData[3])
            let blue = CGFloat(pixelData[2]) / CGFloat(pixelData[3])
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        return nil
    }
}

extension UIColor {
    var swiftUIColor: Color {
        return Color(self)
    }
}


#Preview {
    Fonts()
}
