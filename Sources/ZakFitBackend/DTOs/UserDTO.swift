//
//  UserDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 27/11/2025.
//

import Vapor

// DTO pour afficher l'utilisateur (sans mot de passe)
struct UserDTO: Content {
    var id: UUID?
    var name: String
    var lastName: String
    var email: String
    var height: Int
    var weight: Int
    var birthDate: Date
    var goals: String?
    var diet: String?
    var gender: String?
}

// DTO pour créer un utilisateur
struct UserCreateDTO: Content {
    var name: String
    var lastName: String
    var email: String
    var password: String
    var height: Int
    var weight: Int
    var birthDate: String  // Format: yyyy-MM-dd
    var goals: String?
    var diet: String?
    var gender: String?
}

// DTO pour mettre à jour partiellement
struct PartialUserDTO: Content {
    var name: String?
    var lastName: String?
    var email: String?
    var password: String?
    var height: Int?
    var weight: Int?
    var birthDate: String?
    var goals: String?
    var diet: String?
    var gender: String?
}

// DTO pour le login
struct LoginRequest: Content {
    let email: String
    let password: String
}
