//
//  FoodListViewController.swift
//  UIKit Navigation
//
//  Created by Raees Rajwani on 07/10/2023.
//

import UIKit
import SwiftUI

class FoodListViewController: UIViewController {
    
    let foods = ["Pizza 🍕", "Burger 🍔", "Pasta 🍝", "Salad 🥗", "Steak 🥩"]
    var hostingController: UIHostingController<AnyView>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the navigation title
        self.title = "Foods"

        // Embed the SwiftUI view into the view controller
        let listView = self.createListView()
        hostingController = UIHostingController(rootView: AnyView(listView))
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }

    func createListView() -> some View {
        List(foods, id: \.self) { food in
            Button(action: {
                self.showDetail(for: food)
                
            }) {
                HStack {
                    Text(food)
                    Spacer()
                }
            }
        }.listStyle(.plain)
                
    }

    func showDetail(for food: String) {
        let detailView = FoodDetailView(foodName: food)
        let detailHostingController = UIHostingController(rootView: detailView)
        detailHostingController.navigationItem.title = food
        self.navigationController?.pushViewController(detailHostingController, animated: true)
    }
}

#Preview {
    FoodListViewController()
}

