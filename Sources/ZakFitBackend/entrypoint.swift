import Vapor
import Logging
import NIOCore
import NIOPosix

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        
        let app = try await Application.make(env)

        do {
            try await configure(app)

            // ⚡ Ajoute ces deux lignes ici
            app.http.server.configuration.hostname = "0.0.0.0" // écoute toutes les interfaces
            app.http.server.configuration.port = 8080          // même port que dans ton APIService

            try await app.execute()
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }

        try await app.asyncShutdown()
    }
}

