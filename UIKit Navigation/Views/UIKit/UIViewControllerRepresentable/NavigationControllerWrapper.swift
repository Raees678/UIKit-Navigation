//
//  NavigationControllerWrapper.swift
//  UIKit Navigation
//
//  Created by Raees Rajwani on 07/10/2023.
//

import UIKit
import SwiftUI

struct NavigationControllerWrapper: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        let rootViewController = FoodListViewController()
        let navigationController = PushNavigationController(rootViewController: rootViewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Handle updates if needed
    }

}

#Preview {
    NavigationControllerWrapper()
}
