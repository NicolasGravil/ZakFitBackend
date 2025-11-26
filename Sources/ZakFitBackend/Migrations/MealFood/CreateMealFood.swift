//
//  MealFood.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent
import Vapor

struct CreateMealFood: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(MealFood.schema)
            .id()
            .field("meal_id", .uuid, .required)
            .field("food_id", .uuid, .required)
            .field("quantity_g", .double, .required)
            .foreignKey("meal_id", references: Meal.schema, "id", onDelete: .cascade)
            .foreignKey("food_id", references: Food.schema, "id")
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(MealFood.schema).delete()
    }
}

