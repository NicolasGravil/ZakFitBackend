//
//  ExerciseDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//
import Vapor
import Fluent

struct ExerciseDTO: Content {
    let id: UUID?
    let userID: UUID
    let typeID: UUID
    let name: String
    let duration: Int
    let calories: Int?
    let date: Date
}

struct ExerciseCreateDTO: Content {
    let userID: UUID
    let typeID: UUID
    let name: String
    let duration: Int
    let calories: Int?
    let date: Date
}
