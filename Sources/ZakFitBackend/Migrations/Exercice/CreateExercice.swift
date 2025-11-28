//
//  Exercice.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.

import Fluent

struct CreateExercise: Migration {
    func prepare(on db: any Database) -> EventLoopFuture<Void> {
        db.schema(Exercise.schema)
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("exerciseType_id", .uuid, .required, .references("exerciseType", "id"))
            .field("name", .string, .required)
            .field("duration", .int, .required)
            .field("calories", .int)
            .field("date", .date, .required)
            .create()
    }

    func revert(on db: any Database) -> EventLoopFuture<Void> {
        db.schema(Exercise.schema).delete()
    }
}
