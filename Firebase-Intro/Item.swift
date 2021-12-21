//
//  Item.swift
//  Firebase-Intro
//
//  Created by David Svensson on 2021-12-21.
//

import Foundation
import FirebaseFirestoreSwift

struct Item : Codable , Identifiable{
    @DocumentID var id : String?
    var name : String
    var category : String = ""
    var done : Bool = false
}
