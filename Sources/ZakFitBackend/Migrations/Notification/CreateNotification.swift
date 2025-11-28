//
//  CreateNotification.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Fluent

struct CreateNotification: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Notification.schema)
            .id()
            .field("user_id", .uuid, .required, .references("users", .id))
            .field("title", .string, .required)
            .field("message", .string, .required)
            .field("date", .datetime, .required)
            .field("isRead", .bool, .required)
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Notification.schema).delete()
    }
}
