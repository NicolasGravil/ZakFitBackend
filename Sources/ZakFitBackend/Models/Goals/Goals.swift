//
//  Goals.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent
import Vapor

final class Goal: Model, Content, @unchecked Sendable {
    static let schema = "goals"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "type") var type: String
    @Field(key: "target_weight") var targetWeight: Int?
    @Field(key: "deadline") var deadline: Date?
    @Parent(key: "user_id") var user: User
    
    init() {}
}

