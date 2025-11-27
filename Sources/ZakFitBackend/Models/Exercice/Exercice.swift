//
//  Exercice.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.

import Fluent
import Vapor

final class Exercise: Model, Content, @unchecked Sendable {
    static let schema = "exercises"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "duration_min") var durationMin: Int
    @Field(key: "calories") var calories: Int?
    @Field(key: "date") var date: Date
    @Parent(key: "user_id") var user: User
    @Parent(key: "exercise_type_id") var type: ExerciseType
    
    init() {}
    
    init(id: UUID? = nil, name: String, durationMin: Int, date: Date, userID: UUID, typeID: UUID) {
        self.id = id
        self.name = name
        self.durationMin = durationMin
        self.date = date
        self.$user.id = userID
        self.$type.id = typeID
    }
}

