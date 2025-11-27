//
//  Exercice.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.

import Fluent
import Vapor

struct CreateExercise: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Exercise.schema)
            .id() // UUID
            .field("name", .string, .required)
            .field("duration_min", .int, .required)
            .field("calories", .int)
            .field("date", .date, .required)
            .field("user_id", .uuid, .required)
            .field("exercise_type_id", .uuid, .required)
            .foreignKey("user_id", references: User.schema, "id", onDelete: .cascade)
            .foreignKey("exercise_type_id", references: ExerciseType.schema, "id")
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Exercise.schema).delete()
    }
}

