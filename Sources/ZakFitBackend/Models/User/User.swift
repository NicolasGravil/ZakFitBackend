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

    @Field(key: "User_Name")
    var name: String

    @Field(key: "User_LastName")
    var lastName: String

    @Field(key: "User_Mail")
    var email: String

    @Field(key: "User_Password")
    var password: String

    @Field(key: "User_Height")
    var height: Int

    @Field(key: "User_Weight")
    var weight: Int

    @Field(key: "User_BirthDate")
    var birthDate: Date

    @Field(key: "User_Goals")
    var goals: String?

    @Field(key: "User_Diet")
    var diet: String?

    @Field(key: "User_Gender")
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
        self.id = id ?? UUID()
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
        return UserDTO(
            id: self.id,
            name: self.name,
            lastName: self.lastName,
            email: self.email,
            height: self.height,
            weight: self.weight,
            birthDate: self.birthDate,
            goals: self.goals,
            diet: self.diet,
            gender: self.gender
        )
    }
}

