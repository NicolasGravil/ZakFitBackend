//
//  Meal.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent

struct CreateMeal: Migration {
    func prepare(on db: any Database) -> EventLoopFuture<Void> {
        db.schema(Meal.schema)
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("mealType_id", .uuid, .required, .references("mealType", "id"))
            .field("date", .datetime, .required)
            .create()
    }

    func revert(on db: any Database) -> EventLoopFuture<Void> {
        db.schema(Meal.schema).delete()
    }
}
