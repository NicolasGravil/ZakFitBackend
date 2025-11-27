//
//  JWTMiddleware.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Vapor
import JWT

struct JWTMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Token manquant")
        }
        
        let payload = try request.jwt.verify(token, as: UserPayload.self)
        request.auth.login(payload)
        
        return try await next.respond(to: request)
    }
}

