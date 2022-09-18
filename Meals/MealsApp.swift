//
//  MealsApp.swift
//  Meals
//
//  Created by Peng, Kevin [C] on 2022-09-17.
//

import SwiftUI

@main
struct MealsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView {
                DishesView()
                    .tabItem { Label("Dishes", systemImage: "fork.knife.circle") }
                NavigationView {
                    List {
                        IngredientsView(dish: nil)
                    }
                }
                .tabItem { Label("Ingredients", systemImage: "takeoutbag.and.cup.and.straw") }
                ShoppingCartView()
                    .tabItem { Label("Shopping Cart", systemImage: "cart") }
                FridgeView()
                    .tabItem { Label("Refridgerator", systemImage: "snowflake") }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
