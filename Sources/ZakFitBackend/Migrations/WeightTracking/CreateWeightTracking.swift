//
//  CreateWeightTracking.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Fluent

struct CreateWeightTracking: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(WeightTracking.schema)
            .id()
            .field("user_id", .uuid, .required, .references("users", .id))
            .field("weight", .double, .required)
            .field("date", .datetime, .required)
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(WeightTracking.schema).delete()
    }
}
