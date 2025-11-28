//
//  GoalController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor
import Fluent

struct GoalController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let goals = routes.grouped("goals")

        goals.get(use: getAll)
        goals.get(":goalID", use: getById)

        let protected = goals.grouped(JWTMiddleware())
        protected.post(use: create)
        protected.put(":goalID", use: update)
        protected.delete(":goalID", use: delete)
    }

    func getAll(req: Request) async throws -> [GoalDTO] {
        let list = try await Goal.query(on: req.db).all()
        return list.map { GoalDTO(id: $0.id, userID: $0.$user.id, type: $0.type, targetWeight: $0.targetWeight, deadline: $0.deadline) }
    }

    func getById(req: Request) async throws -> GoalDTO {
        guard let idString = req.parameters.get("goalID"),
              let uuid = UUID(uuidString: idString),
              let goal = try await Goal.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        return GoalDTO(id: goal.id, userID: goal.$user.id, type: goal.type, targetWeight: goal.targetWeight, deadline: goal.deadline)
    }

    func create(req: Request) async throws -> GoalDTO {
        let dto = try req.content.decode(GoalCreateDTO.self)
        let goal = Goal(userID: dto.userID, type: dto.type, targetWeight: dto.targetWeight, deadline: dto.deadline)
        try await goal.save(on: req.db)
        return GoalDTO(id: goal.id, userID: goal.$user.id, type: goal.type, targetWeight: goal.targetWeight, deadline: goal.deadline)
    }

    func update(req: Request) async throws -> GoalDTO {
        guard let idString = req.parameters.get("goalID"),
              let uuid = UUID(uuidString: idString),
              let goal = try await Goal.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        let dto = try req.content.decode(GoalCreateDTO.self)
        goal.$user.id = dto.userID
        goal.type = dto.type
        goal.targetWeight = dto.targetWeight
        goal.deadline = dto.deadline
        try await goal.update(on: req.db)
        return GoalDTO(id: goal.id, userID: goal.$user.id, type: goal.type, targetWeight: goal.targetWeight, deadline: goal.deadline)
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let idString = req.parameters.get("goalID"),
              let uuid = UUID(uuidString: idString),
              let goal = try await Goal.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        try await goal.delete(on: req.db)
        return .noContent
    }
}
