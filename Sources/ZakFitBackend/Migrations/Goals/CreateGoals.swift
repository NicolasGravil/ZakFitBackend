//
//  Goals.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//


import Fluent
import Vapor

struct CreateGoal: Migration {
    func prepare(on db: any Database) -> EventLoopFuture<Void> {
        db.schema(Goal.schema)
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("type", .string, .required)
            .field("targetWeight", .int)
            .field("deadline", .date)
            .create()
    }

    func revert(on db: any Database) -> EventLoopFuture<Void> {
        db.schema(Goal.schema).delete()
    }
}

