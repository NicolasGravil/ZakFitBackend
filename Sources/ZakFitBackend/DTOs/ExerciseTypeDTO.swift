//
//  ExerciseTypeDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 27/11/2025.
//
import Fluent
import Vapor

struct ExerciseTypeDTO: Content {
    let id: UUID?
    let name: String
}

struct ExerciseTypeCreateDTO: Content {
    let name: String
}
