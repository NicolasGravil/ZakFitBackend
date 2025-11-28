//
//  MealFood.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent

struct CreateMealFood: Migration {
    func prepare(on db: any Database) -> EventLoopFuture<Void> {
        db.schema(MealFood.schema)
            .id()
            .field("meal_id", .uuid, .required, .references("meal", "id"))
            .field("food_id", .uuid, .required, .references("food", "id"))
            .field("quantity", .double, .required)
            .create()
    }

    func revert(on db: any Database) -> EventLoopFuture<Void> {
        db.schema(MealFood.schema).delete()
    }
}
