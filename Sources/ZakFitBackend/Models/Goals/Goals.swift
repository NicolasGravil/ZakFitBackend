//
//  Goals.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent
import Vapor

final class Goal: Model, Content, @unchecked Sendable {
    static let schema = "goals"
    
    @ID(key: .id) var id: UUID?
      @Parent(key: "user_id") var user: User
      @Field(key: "type") var type: String
      @Field(key: "targetWeight") var targetWeight: Int?
      @Field(key: "deadline") var deadline: Date?

      init() {}

      init(id: UUID? = nil, userID: UUID, type: String, targetWeight: Int?, deadline: Date?) {
          self.id = id
          self.$user.id = userID
          self.type = type
          self.targetWeight = targetWeight
          self.deadline = deadline
      }
}

