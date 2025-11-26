//
//  ExerciseType.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//
import Fluent
import Vapor

struct CreateExerciseType: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(ExerciseType.schema)
            .id()
            .field("name", .string, .required)
            .create()
    }
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(ExerciseType.schema).delete()
    }
}
