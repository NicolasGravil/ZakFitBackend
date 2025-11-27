//
//  UserDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 27/11/2025.
//

//
//  UserDTO.swift
//  ZakFitBackend
//
import Vapor

// DTO exposé au client (sans mot de passe)
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

// DTO pour création complète (POST /users/register)
struct UserCreateDTO: Content {
    var name: String
    var lastName: String
    var email: String
    var password: String
    var height: Int
    var weight: Int
    var birthDate: String  // format "yyyy-MM-dd"
    var goals: String?
    var diet: String?
    var gender: String?
}

// DTO pour mise à jour partielle (PATCH)
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

// DTO pour login
struct LoginRequest: Content {
    let email: String
    let password: String
}
