//
//  GoalDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//
import Vapor
import Fluent

struct GoalDTO: Content {
    let id: UUID?
    let userID: UUID
    let type: String
    let targetWeight: Int?
    let deadline: Date?
}

struct GoalCreateDTO: Content {
    let userID: UUID
    let type: String
    let targetWeight: Int?
    let deadline: Date?
}
