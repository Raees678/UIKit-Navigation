//
//  NextView.swift
//  UIKit Navigation
//
//  Created by Raees Rajwani on 07/10/2023.
//

import SwiftUI

struct FoodDetailView: View {
    let foodName: String
    let beverages = ["Soda 🥤", "Water 💧", "Juice 🧃"]
    
    var body: some View {
        return VStack {
            Text("On nom nom \(foodName)").padding()
            List {
                ForEach(beverages, id: \.self) { beverage in
                    NavigationLink(beverage) {
                        BeverageDetailView(beverageName: beverage)
                    }
                }
            }.listStyle(.plain)
            .navigationTitle(foodName)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    FoodDetailView(foodName: "Pizza 🍕")
}
