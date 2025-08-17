//
//  ScaledFont.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import SwiftUI

struct ScaledFont: ViewModifier {
    let name: FontsName
    let size: CGFloat
    let scale: Bool
    
    init(name: FontsName, size: CGFloat, scale: Bool = true) {
        self.name = name
        self.size = size
        self.scale = scale
    }
    
    func body(content: Content) -> some View {
        if scale {
            content
                .font(.custom(name.rawValue, size: size, relativeTo: .body))
        } else {
            content
                .font(.custom(name.rawValue, fixedSize: size))
        }
    }
}