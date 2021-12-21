//
//  ContentView.swift
//  Firebase-Intro
//
//  Created by David Svensson on 2021-12-21.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var db = Firestore.firestore()
    @State var items = [Item]()
    @State var newItemName = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Button(action: {
                            if let id = item.id {
                                db.collection("items").document(id).updateData(["done" : !item.done ] )
                            }
                        }, label: {
                            Image(systemName: item.done ? "checkmark.square" : "square")
                        })
                    }
                }.onDelete() { indexSet in
                    
                   // let indexes = indexSet.map{$0}
                    
                    for index in indexSet {
                        let item = items[index]
                        if let id = item.id {
                            db.collection("items").document(id).delete()
                        }
                    }
                }
            }
            HStack {
                TextField("Item name",text: $newItemName ).padding()
                Spacer()
                Button(action: {
                    saveToFirestore(itemName: newItemName)
                    newItemName = ""
                }, label: {
                    Text("Save")
                }).padding()
                .onAppear() {
                    listenToFirestore()
                }
            }
        }
    }
    
    func saveToFirestore(itemName: String) {
        let item = Item(name: itemName)
        
        do {
            _ = try db.collection("items").addDocument(from: item)
        } catch {
            print("Error saving to DB")
        }
       // db.collection("tmp").addDocument(data: ["name" : "David"])
    }
    
    func listenToFirestore() {
        db.collection("items").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                items.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Item.self)
                    }
                    switch result {
                    case .success(let item) :
                        if let item = item {
                            //print("Item: \(item)")
                            items.append(item)
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
