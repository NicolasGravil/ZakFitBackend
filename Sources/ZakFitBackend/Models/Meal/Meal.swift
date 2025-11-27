//
//  Meal.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.


import Vapor
import Fluent

final class Meal: Model, Content, @unchecked Sendable {
    static let schema = "meals"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "date") var date: Date
    @Parent(key: "user_id") var user: User
    @Parent(key: "meal_type_id") var mealType: MealType
    
    init() {}
    init(id: UUID? = nil, date: Date, userID: UUID, mealTypeID: UUID) {
        self.id = id
        self.date = date
        self.$user.id = userID
        self.$mealType.id = mealTypeID
    }
}

