//
//  Meal.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent
import Vapor


struct CreateMeal: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Meal.schema)
            .id()
            .field("date", .date, .required)
            .field("user_id", .uuid, .required)
            .field("meal_type_id", .uuid, .required)
            .foreignKey("user_id", references: User.schema, "id", onDelete: .cascade)
            .foreignKey("meal_type_id", references: MealType.schema, "id")
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Meal.schema).delete()
    }
}

