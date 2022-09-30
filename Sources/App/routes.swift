import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.post("generate") { req async -> Response in
        guard let contentFormat = try? (JSONSerialization.jsonObject(with: req.body.data!) as? [String: Any])?["contentFormat"] else {
            return Response(status: .badRequest, body: .init(stringLiteral: "Missing contentFormat"))
        }
        guard let responseData = try? JSONSerialization.data(withJSONObject: contentFormat) else {
            return Response(status: .internalServerError, body: .init(stringLiteral: "Unable to create response JSON"))
        }
        
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: HTTPMediaType.json.serialize())
        return Response(status: .ok, headers: headers, body: .init(string: String(decoding: responseData, as: UTF8.self)))
    }
}
