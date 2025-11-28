//
//  Food.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//
import Fluent
import Vapor

struct CreateFood: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(Food.schema)
            .id()
            .field("name", .string, .required)
            .field("calories_per_100g", .int, .required)
            .field("proteins_per_100g", .double, .required)
            .field("carbs_per_100g", .double, .required)
            .field("fats_per_100g", .double, .required)
            .field("category", .string)
            .field("is_custom", .bool, .required)
            .field("user_id", .uuid)
            .foreignKey("user_id", references: User.schema, "id", onDelete: .setNull)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(Food.schema).delete()
    }
}
