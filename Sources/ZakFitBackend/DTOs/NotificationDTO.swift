//
//  NotificationDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor

struct NotificationCreateDTO: Content {
    let userID: UUID
    let title: String
    let message: String
    let date: Date
    let isRead: Bool
}

struct NotificationDTO: Content {
    let id: UUID?
    let userID: UUID
    let title: String
    let message: String
    let date: Date
    let isRead: Bool
}

