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
        port: 8889,                // ton port XAMPP
        username: "root",
        password: "",
        database: "ZakFit"
    ), as: .mysql)


    //app.migrations.add(CreateTodo())
    
    // Ajouter CORS
       app.middleware.use(CORSMiddleware(configuration: corsConfiguration))

       // Ajouter JWTMiddleware si nécessaire sur certaines routes
       // app.middleware.use(JWTMiddleware()) 

       // Migrations
       app.migrations.add(CreateUser())

    app.views.use(.leaf)

    // register routes
    try routes(app)
}
