//
//  WeightTrackingController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor
import Fluent

struct WeightTrackingController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let weights = routes.grouped("weights")

        // Public GET
        weights.get(use: getAll)
        weights.get(":id", use: getByID)

        // Protected POST/PUT/DELETE
        let protected = weights.grouped(JWTMiddleware())
        protected.post(use: create)
        protected.put(":id", use: update)
        protected.delete(":id", use: delete)
    }

    func getAll(req: Request) async throws -> [WeightTrackingDTO] {
        let list = try await WeightTracking.query(on: req.db).all()

        return list.map {
            WeightTrackingDTO(
                id: $0.id,
                userID: $0.$user.id,
                weight: $0.weight,
                date: $0.date
            )
        }
    }

    func getByID(req: Request) async throws -> WeightTrackingDTO {
        guard let id = req.parameters.get("id"),
              let uuid = UUID(uuidString: id),
              let entry = try await WeightTracking.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        return WeightTrackingDTO(
            id: entry.id,
            userID: entry.$user.id,
            weight: entry.weight,
            date: entry.date
        )
    }

    func create(req: Request) async throws -> WeightTrackingDTO {
        let dto = try req.content.decode(WeightTrackingCreateDTO.self)

        let entry = WeightTracking(
            userID: dto.userID,
            weight: dto.weight,
            date: dto.date
        )

        try await entry.save(on: req.db)

        return WeightTrackingDTO(
            id: entry.id,
            userID: entry.$user.id,
            weight: entry.weight,
            date: entry.date
        )
    }

    func update(req: Request) async throws -> WeightTrackingDTO {
        guard let id = req.parameters.get("id"),
              let uuid = UUID(uuidString: id),
              let entry = try await WeightTracking.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        let dto = try req.content.decode(WeightTrackingCreateDTO.self)

        entry.$user.id = dto.userID
        entry.weight = dto.weight
        entry.date = dto.date

        try await entry.update(on: req.db)

        return WeightTrackingDTO(
            id: entry.id,
            userID: entry.$user.id,
            weight: entry.weight,
            date: entry.date
        )
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id"),
              let uuid = UUID(uuidString: id),
              let entry = try await WeightTracking.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        try await entry.delete(on: req.db)
        return .noContent
    }
}

