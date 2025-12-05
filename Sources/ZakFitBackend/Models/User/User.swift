//
//  User.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Vapor
import Fluent

final class User: Model, Content, @unchecked Sendable {

    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "lastName")
    var lastName: String

    @Field(key: "email")
    var email: String

    @Field(key: "password")
    var password: String

    @Field(key: "height")
    var height: Int

    @Field(key: "weight")
    var weight: Int

    @Field(key: "birthDate")
    var birthDate: Date

    @Field(key: "goals")
    var goals: String?

    @Field(key: "diet")
    var diet: String?

    @Field(key: "gender")
    var gender: String?

    init() {}

    init(id: UUID? = nil,
         name: String,
         lastName: String,
         email: String,
         password: String,
         height: Int,
         weight: Int,
         birthDate: Date,
         goals: String? = nil,
         diet: String? = nil,
         gender: String? = nil) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.email = email
        self.password = password
        self.height = height
        self.weight = weight
        self.birthDate = birthDate
        self.goals = goals
        self.diet = diet
        self.gender = gender
    }

    
    func toDTO() -> UserDTO {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return UserDTO(
            id: self.id,
            name: self.name,
            lastName: self.lastName,
            email: self.email,
            height: self.height,
            weight: self.weight,
            birthDate: formatter.string(from: self.birthDate),
            goals: self.goals,
            diet: self.diet,
            gender: self.gender
        )
    }
}
