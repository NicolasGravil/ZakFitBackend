//
//  UserController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Vapor
import Fluent
import JWT

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        // Routes publiques
        users.post("register", use: create)
        users.post("login", use: login)
        
        // Routes protégées par JWT
        let protected = users.grouped(JWTMiddleware())
        protected.get("profile", use: profile)
        protected.put(":userID", use: update)
        protected.patch(":userID", use: patch)
        protected.delete(":userID", use: delete)
        
        // Routes admin (optionnel)
        users.get(use: getAll)
        users.get(":userID", use: getById)
    }
    
    struct LoginResponse: Content {
        let token: String
        let user: UserDTO
    }

    // POST /users/register
    func create(req: Request) async throws -> UserDTO {
        let userDTO = try req.content.decode(UserCreateDTO.self)
        
        if try await User.query(on: req.db).filter(\.$email == userDTO.email).first() != nil {
            throw Abort(.conflict, reason: "Email déjà utilisé")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let birthDate = formatter.date(from: userDTO.birthDate) else {
            throw Abort(.badRequest, reason: "Date invalide")
        }
        
        let user = User(
            name: userDTO.name,
            lastName: userDTO.lastName,
            email: userDTO.email,
            password: try Bcrypt.hash(userDTO.password),
            height: userDTO.height,
            weight: userDTO.weight,
            birthDate: birthDate,
            goals: userDTO.goals,
            diet: userDTO.diet,
            gender: userDTO.gender
        )
        
        try await user.save(on: req.db)
        return user.toDTO()
    }

    // POST /users/login
    func login(req: Request) async throws -> LoginResponse {
        let data = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$email == data.email).first(),
              try Bcrypt.verify(data.password, created: user.password) else {
            throw Abort(.unauthorized, reason: "Email ou mot de passe incorrect")
        }
        
        let payload = UserPayload(id: user.id!)
        let token = try req.jwt.sign(payload)
        
        return LoginResponse(token: token, user: user.toDTO())
    }

    // GET /users/profile
    func profile(req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        return user.toDTO()
    }

    // GET /users/:userID
    func getById(req: Request) async throws -> UserDTO {
        guard let userID = req.parameters.get("userID"),
              let uuid = UUID(uuidString: userID),
              let user = try await User.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        return user.toDTO()
    }

    // PUT /users/:userID
    func update(req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let userIDStr = req.parameters.get("userID"),
              let userID = UUID(uuidString: userIDStr),
              userID == payload.id else {
            throw Abort(.forbidden)
        }
        
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let dto = try req.content.decode(UserCreateDTO.self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let birthDate = formatter.date(from: dto.birthDate) else {
            throw Abort(.badRequest, reason: "Date invalide")
        }
        
        user.name = dto.name
        user.lastName = dto.lastName
        user.email = dto.email
        user.password = try Bcrypt.hash(dto.password)
        user.height = dto.height
        user.weight = dto.weight
        user.birthDate = birthDate
        user.goals = dto.goals
        user.diet = dto.diet
        user.gender = dto.gender
        
        try await user.update(on: req.db)
        return user.toDTO()
    }

    // PATCH /users/:userID
    func patch(req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let userIDStr = req.parameters.get("userID"),
              let userID = UUID(uuidString: userIDStr),
              userID == payload.id else {
            throw Abort(.forbidden)
        }
        
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let dto = try req.content.decode(PartialUserDTO.self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let name = dto.name { user.name = name }
        if let lastName = dto.lastName { user.lastName = lastName }
        if let email = dto.email { user.email = email }
        if let password = dto.password { user.password = try Bcrypt.hash(password) }
        if let height = dto.height { user.height = height }
        if let weight = dto.weight { user.weight = weight }
        if let goals = dto.goals { user.goals = goals }
        if let diet = dto.diet { user.diet = diet }
        if let gender = dto.gender { user.gender = gender }
        
        if let birthDateStr = dto.birthDate,
           let birthDate = formatter.date(from: birthDateStr) {
            user.birthDate = birthDate
        }
        
        try await user.update(on: req.db)
        return user.toDTO()
    }

    // DELETE /users/:userID
    func delete(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let userIDStr = req.parameters.get("userID"),
              let userID = UUID(uuidString: userIDStr),
              userID == payload.id else {
            throw Abort(.forbidden)
        }
        
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await user.delete(on: req.db)
        return .noContent
    }

    // GET /users (all)
    func getAll(req: Request) async throws -> [UserDTO] {
        let users = try await User.query(on: req.db).all()
        return users.map { $0.toDTO() }
    }
}
