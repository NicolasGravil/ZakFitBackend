//
//  MealFood.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.


import Fluent
import Vapor

final class MealFood: Model, Content, @unchecked Sendable {
    static let schema = "mealFood"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "meal_id") var meal: Meal
    @Parent(key: "food_id") var food: Food
    @Field(key: "quantity") var quantity: Double
    
    init() {}
    
    init(id: UUID? = nil, mealID: UUID, foodID: UUID, quantity: Double) {
           self.id = id
           self.$meal.id = mealID
           self.$food.id = foodID
           self.quantity = quantity
       }
}

