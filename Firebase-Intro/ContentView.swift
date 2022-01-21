//
//  ContentView.swift
//  Firebase-Intro
//
//  Created by David Svensson on 2021-12-21.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var viewModel = ItemsViewModel()
    var auth = Auth.auth()
    
    var body: some View {
        VStack {
            ItemListView(viewModel: viewModel)
            AddItemView(viewModel: viewModel)
        }.onAppear() {
            Auth.auth().signInAnonymously { authResult, error in
                guard let user = authResult?.user else { return }
                
                viewModel.listenToFirestore(uid: user.uid)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ItemListView: View {
    @ObservedObject var viewModel : ItemsViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Button(action: {
                        viewModel.toggle(item: item)
                    }, label: {
                        Image(systemName: item.done ? "checkmark.square" : "square")
                    })
                }
            }.onDelete() { indexSet in
                viewModel.deleteItem(at: indexSet)
            }
        }
    }
}

struct AddItemView: View {
    @State var newItemName = ""
    var viewModel : ItemsViewModel
    
    var body: some View {
        HStack {
            TextField("Item name",text: $newItemName ).padding()
            Spacer()
            Button(action: {
                viewModel.saveToFirestore(itemName: newItemName)
                newItemName = ""
            }, label: {
                Text("Save")
            }).padding()
        }
    }
}
