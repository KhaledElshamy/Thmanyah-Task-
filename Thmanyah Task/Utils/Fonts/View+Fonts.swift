//
//  View+Fonts.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import SwiftUI

extension View {
    func scaledFont(name: FontsName, size: FontsSize, scale: Bool = true) -> some View {
        return modifier(ScaledFont(name: name, size: size.rawValue, scale: scale))
    }
    
    // Convenience methods for common font weights
    func thinFont(size: FontsSize, scale: Bool = true) -> some View {
        scaledFont(name: .ibmPlexSansArabicThin, size: size, scale: scale)
    }
    
    func extraLightFont(size: FontsSize, scale: Bool = true) -> some View {
        scaledFont(name: .ibmPlexSansArabicExtraLight, size: size, scale: scale)
    }
    
    func lightFont(size: FontsSize, scale: Bool = true) -> some View {
        scaledFont(name: .ibmPlexSansArabicLight, size: size, scale: scale)
    }
    
    func regularFont(size: FontsSize, scale: Bool = true) -> some View {
        scaledFont(name: .ibmPlexSansArabicRegular, size: size, scale: scale)
    }
    
    func textFont(size: FontsSize, scale: Bool = true) -> some View {
        scaledFont(name: .ibmPlexSansArabicText, size: size, scale: scale)
    }
    
    func mediumFont(size: FontsSize, scale: Bool = true) -> some View {
        scaledFont(name: .ibmPlexSansArabicMedium, size: size, scale: scale)
    }
    
    func semiBoldFont(size: FontsSize, scale: Bool = true) -> some View {
        scaledFont(name: .ibmPlexSansArabicSemiBold, size: size, scale: scale)
    }
    
    func boldFont(size: FontsSize, scale: Bool = true) -> some View {
        scaledFont(name: .ibmPlexSansArabicBold, size: size, scale: scale)
    }
}