//
//  MealType.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Vapor
import Fluent

struct CreateMealType: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(MealType.schema)
            .id()
            .field("name", .string, .required)
            .create()
    }
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(MealType.schema).delete()
    }
}

