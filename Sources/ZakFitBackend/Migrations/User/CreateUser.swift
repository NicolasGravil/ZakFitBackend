//
//  CreateUser.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("User")
            .id()
            .field("User_Name", .string, .required)
            .field("User_LastName", .string, .required)
            .field("User_Mail", .string, .required)
            .unique(on: "User_Mail")
            .field("User_Password", .string, .required)
            .field("User_Height", .int, .required)
            .field("User_Weight", .int, .required)
            .field("User_Goals", .string)
            .field("User_Diet", .string)
            .field("User_Gender", .string)
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("User").delete()
    }
}
