//
//  Notes.swift
//  piano101-test
//
//  Created by Mg  Good on 6/8/25.
//

import Foundation
import SwiftUI

protocol KeyNote: Identifiable {
    var id: UUID { get }
    var name: String { get }
    var modelName: String { get }
    
    
}

struct WhiteNote: KeyNote, Identifiable {
    var id = UUID()
    var name: String
    var modelName: String = "whiteNote"
    init(name: String) {
        self.name = name
    }
    func getName() -> String {
        return self.name
    }
}

struct BlackNote: KeyNote, Identifiable {
    var id = UUID()
    var name: String
    var modelName: String = "blackNote"
    init(name: String) {
        self.name = name
    }
    func getName() -> String {
        return self.name
    }
}
