//
//  MealDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//
import Vapor
import Fluent

struct MealDTO: Content {
    let id: UUID?
    let userID: UUID
    let mealTypeID: UUID
    let date: Date
}

struct MealCreateDTO: Content {
    let userID: UUID
    let mealTypeID: UUID
    let date: Date
}

struct MealFullDTO: Content {
    let id: UUID
    let userID: UUID
    let mealType: MealTypeDTO
    let date: Date
    let foods: [MealFoodDTO]  
}

