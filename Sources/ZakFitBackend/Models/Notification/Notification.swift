//
//  Notification.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Fluent
import Vapor

final class Notification: Model, Content, @unchecked Sendable  {
    static let schema = "notifications"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "title")
    var title: String

    @Field(key: "message")
    var message: String

    @Field(key: "date")
    var date: Date

    @Field(key: "isRead")
    var isRead: Bool

    init() {}

    init(id: UUID? = nil, userID: UUID, title: String, message: String, date: Date, isRead: Bool) {
        self.id = id
        self.$user.id = userID
        self.title = title
        self.message = message
        self.date = date
        self.isRead = isRead
    }
}
