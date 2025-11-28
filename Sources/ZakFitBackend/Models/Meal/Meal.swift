//
//  Meal.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.


import Vapor
import Fluent

final class Meal: Model, Content, @unchecked Sendable {
    static let schema = "meal"
    
    @ID(key: .id) var id: UUID?
      @Parent(key: "user_id") var user: User
      @Parent(key: "mealType_id") var mealType: MealType
      @Field(key: "date") var date: Date

      init() {}

      init(id: UUID? = nil, userID: UUID, mealTypeID: UUID, date: Date) {
          self.id = id
          self.$user.id = userID
          self.$mealType.id = mealTypeID
          self.date = date
      }
}

