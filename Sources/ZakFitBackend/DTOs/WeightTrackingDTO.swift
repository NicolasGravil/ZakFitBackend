//
//  WeightTrackingDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor

struct WeightTrackingCreateDTO: Content {
    let userID: UUID
    let weight: Double
    let date: Date
}

struct WeightTrackingDTO: Content {
    let id: UUID?
    let userID: UUID
    let weight: Double
    let date: Date
}

