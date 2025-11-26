//
//  CORSMiddleware.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//


import Vapor
let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin: .all,
    allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
    allowedHeaders: [.accept, .authorization, .contentType, .origin],
    cacheExpiration: 800
)
