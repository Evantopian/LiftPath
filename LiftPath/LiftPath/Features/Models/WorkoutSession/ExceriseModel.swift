//
//  ExceriseModel.swift
//  LiftPath
//
//  Created by Evan Huang on 12/6/24.
//

import Foundation

struct Exercise: Identifiable, Decodable, Encodable {
    var id: String { name }
    let name: String
    let target: String
    let gifUrl: String
    let equipment: String
    let instructions: [String]
    let secondaryMuscles: [String]
    var sets: Int?
    var reps: Int?
    var duration: Double? // for cardio potentially (next expansion)
}
