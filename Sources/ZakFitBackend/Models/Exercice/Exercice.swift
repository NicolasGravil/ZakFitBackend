//
//  Exercice.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.

import Fluent
import Vapor

final class Exercise: Model, Content, @unchecked Sendable {
    static let schema = "exercise"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "user_id") var user: User
    @Parent(key: "exerciseType_id") var type: ExerciseType
    @Field(key: "name") var name: String
    @Field(key: "duration") var duration: Int
    @Field(key: "calories") var calories: Int?
    @Field(key: "date") var date: Date

    init() {}

    init(id: UUID? = nil, userID: UUID, typeID: UUID, name: String, duration: Int, calories: Int?, date: Date) {
        self.id = id
        self.$user.id = userID
        self.$type.id = typeID
        self.name = name
        self.duration = duration
        self.calories = calories
        self.date = date
    }
}

