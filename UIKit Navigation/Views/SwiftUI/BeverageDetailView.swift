//
//  BeverageDetailView.swift
//  UIKit Navigation
//
//  Created by Raees Rajwani on 08/10/2023.
//

import SwiftUI

struct BeverageDetailView: View {
    let beverageName: String

    var body: some View {
        VStack {
            Text("Ahh, refreshing \(beverageName)").padding()
            Spacer()
        }.navigationTitle(beverageName)
    }
}

#Preview {
    
    BeverageDetailView(beverageName: "Soda 🥤")
}
