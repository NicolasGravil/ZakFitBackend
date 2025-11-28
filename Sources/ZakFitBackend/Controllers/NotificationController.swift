//
//  NotificationController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor
import Fluent

struct NotificationController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let notifications = routes.grouped("notifications")

        // Public - GET
        notifications.get(use: getAll)
        notifications.get(":id", use: getByID)

        // Protected
        let protected = notifications.grouped(JWTMiddleware())
        protected.post(use: create)
        protected.put(":id", use: update)
        protected.delete(":id", use: delete)
    }

    func getAll(req: Request) async throws -> [NotificationDTO] {
        let list = try await Notification.query(on: req.db).all()

        return list.map {
            NotificationDTO(
                id: $0.id,
                userID: $0.$user.id,
                title: $0.title,
                message: $0.message,
                date: $0.date,
                isRead: $0.isRead
            )
        }
    }

    func getByID(req: Request) async throws -> NotificationDTO {
        guard let id = req.parameters.get("id"),
              let uuid = UUID(uuidString: id),
              let notif = try await Notification.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        return NotificationDTO(
            id: notif.id,
            userID: notif.$user.id,
            title: notif.title,
            message: notif.message,
            date: notif.date,
            isRead: notif.isRead
        )
    }

    func create(req: Request) async throws -> NotificationDTO {
        let dto = try req.content.decode(NotificationCreateDTO.self)

        let notif = Notification(
            userID: dto.userID,
            title: dto.title,
            message: dto.message,
            date: dto.date,
            isRead: dto.isRead
        )

        try await notif.save(on: req.db)

        return NotificationDTO(
            id: notif.id,
            userID: notif.$user.id,
            title: notif.title,
            message: notif.message,
            date: notif.date,
            isRead: notif.isRead
        )
    }

    func update(req: Request) async throws -> NotificationDTO {
        guard let id = req.parameters.get("id"),
              let uuid = UUID(uuidString: id),
              let notif = try await Notification.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        let dto = try req.content.decode(NotificationCreateDTO.self)

        notif.$user.id = dto.userID
        notif.title = dto.title
        notif.message = dto.message
        notif.date = dto.date
        notif.isRead = dto.isRead

        try await notif.update(on: req.db)

        return NotificationDTO(
            id: notif.id,
            userID: notif.$user.id,
            title: notif.title,
            message: notif.message,
            date: notif.date,
            isRead: notif.isRead
        )
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id"),
              let uuid = UUID(uuidString: id),
              let notif = try await Notification.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        try await notif.delete(on: req.db)
        return .noContent
    }
}
