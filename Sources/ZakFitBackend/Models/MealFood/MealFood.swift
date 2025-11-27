//
//  MealFood.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.


import Fluent
import Vapor

final class MealFood: Model, Content, @unchecked Sendable {
    static let schema = "meal_foods"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "meal_id") var meal: Meal
    @Parent(key: "food_id") var food: Food
    @Field(key: "quantity_g") var quantityG: Double
    
    init() {}
}

