//
//  MealTypeDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//
import Fluent
import Vapor

struct MealTypeDTO: Content {
    let id: UUID?
    let name: String
}

struct MealTypeCreateDTO: Content {
    let name: String
}
