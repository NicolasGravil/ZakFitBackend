//
//  User.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Vapor
import Fluent

final class User: Model, Content, @unchecked Sendable {
    static let schema = "users" // nom de table en minuscule recommandé pour MySQL

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

    @Field(key: "User_Goals")
    var goals: String?

    @Field(key: "User_Diet")
    var diet: String?

    @Field(key: "User_Gender")
    var gender: String?

    // Initialisateur vide requis par Fluent
    init() {}

    // Initialisateur pratique pour créer un nouvel utilisateur
    init(id: UUID? = nil,
         name: String,
         lastName: String,
         email: String,
         password: String,
         height: Int,
         weight: Int,
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
        self.goals = goals
        self.diet = diet
        self.gender = gender
    }

    // Méthode optionnelle pour convertir en DTO si tu veux ne pas exposer le mot de passe
    func toDTO() -> UserDTO {
        return UserDTO(
            id: self.id,
            name: self.name,
            lastName: self.lastName,
            email: self.email,
            height: self.height,
            weight: self.weight,
            goals: self.goals,
            diet: self.diet,
            gender: self.gender
        )
    }
}

// DTO pour l'API (sans mot de passe)
struct UserDTO: Content {
    var id: UUID?
    var name: String
    var lastName: String
    var email: String
    var height: Int
    var weight: Int
    var goals: String?
    var diet: String?
    var gender: String?
}
