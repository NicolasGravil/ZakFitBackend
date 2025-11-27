import NIOSSL
import Fluent
import FluentMySQLDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.mysql(
        hostname: "127.0.0.1",    // localhost marche aussi
        port: 3306,                // ton port XAMPP
        username: "root",
        password: "",
        database: "ZakFit"
    ), as: .mysql)


    //app.migrations.add(CreateTodo())
    
    // Ajouter CORS
       app.middleware.use(CORSMiddleware(configuration: corsConfiguration))

       // Ajouter JWTMiddleware si nécessaire sur certaines routes
       // app.middleware.use(JWTMiddleware())
    app.jwt.signers.use(.hs256(key: "OnePieceIsReal"))


       // Migrations
       app.migrations.add(CreateUser())
   
        app.migrations.add(CreateExerciseType())
        app.migrations.add(CreateExercise())
        app.migrations.add(CreateMealType())
        app.migrations.add(CreateMeal())
        app.migrations.add(CreateFood())
        app.migrations.add(CreateMealFood())
        app.migrations.add(CreateGoal())
//    app.migrations.add(CreateNotification()) // implement similar
//    app.migrations.add(CreateWeightTracking())
//
//    try app.autoMigrate().wait() // or run migrate manually


    app.views.use(.leaf)

    // register routes
    try routes(app)
}
