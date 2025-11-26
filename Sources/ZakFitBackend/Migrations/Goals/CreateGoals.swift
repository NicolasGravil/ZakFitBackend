//
//  Goals.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//


import Fluent
import Vapor

struct CreateGoal: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Goal.schema)
            .id()
            .field("type", .string, .required)
            .field("target_weight", .int)
            .field("deadline", .date)
            .field("user_id", .uuid, .required)
            .foreignKey("user_id", references: User.schema, "id", onDelete: .cascade)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Goal.schema).delete()
    }
}
