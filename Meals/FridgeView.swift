//
//  FridgeView.swift
//  Meals
//
//  Created by Peng, Kevin [C] on 2022-09-17.
//

import SwiftUI

struct FridgeView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest
    private var items: FetchedResults<Ingredient>

    @State private var error = ""
    @State private var showError = false

    init() {
        let request = Ingredient.fetchRequest()
        request.predicate = NSPredicate(format: "isInFridge = true")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]
        _items = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        List(items) { item in
            HStack {
                Text(item.name!)
                Button(action: { remove(ingredient: item) }) {
                    Label("Remove", systemImage: "minus.circle")
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        }
    }

    func remove(ingredient: Ingredient) {
        ingredient.isInFridge = false
    }

    func saveData() {
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            self.error = error.localizedDescription
            showError = true
        }
    }
}

struct FridgeView_Previews: PreviewProvider {
    static var previews: some View {
        FridgeView()
    }
}
