//
//  CreateUser.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("lastName", .string, .required)
            .field("email", .string, .required)
            .unique(on: "email")
            .field("password", .string, .required)
            .field("height", .int, .required)
            .field("weight", .int, .required)
            .field("birthDate", .date, .required)
            .field("goals", .string)
            .field("diet", .string)
            .field("gender", .string)
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
