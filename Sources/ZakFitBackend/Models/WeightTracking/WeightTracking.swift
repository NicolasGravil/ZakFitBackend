//
//  WeightTracking.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Fluent
import Vapor

final class WeightTracking: Model, Content, @unchecked Sendable {
    static let schema = "weightTracking"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "weight")
    var weight: Double

    @Field(key: "date")
    var date: Date

    init() {}

    init(id: UUID? = nil, userID: UUID, weight: Double, date: Date) {
        self.id = id
        self.$user.id = userID
        self.weight = weight
        self.date = date
    }
}
