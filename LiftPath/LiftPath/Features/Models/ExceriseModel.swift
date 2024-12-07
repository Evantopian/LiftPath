//
//  ExceriseModel.swift
//  LiftPath
//
//  Created by Evan Huang on 12/6/24.
//

import Foundation

struct Exercise: Identifiable {
    var id: String { name }
    let name: String
    let target: String
    let gifUrl: String
}
