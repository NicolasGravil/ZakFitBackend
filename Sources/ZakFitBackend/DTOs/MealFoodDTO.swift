//
//  MealFoodDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//
import Vapor
import Fluent

struct MealFoodDTO: Content {
    let id: UUID?
    let mealID: UUID
    let foodID: UUID
    let quantity: Double
}

struct MealFoodCreateDTO: Content {
    let mealID: UUID
    let foodID: UUID
    let quantity: Double
}
