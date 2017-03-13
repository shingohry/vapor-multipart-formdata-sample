import Vapor
import Foundation

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.post { req in
    guard let field = req.formData?["file"] else {
        return JSON(["result":"receive failure"])
    }
    
    do {
        let dest = URL(fileURLWithPath: field.filename!)
        try Data(field.part.body).write(to: dest)
    } catch {
        return JSON(["result":"save failure"])
    }
    
    return JSON(["result":"success"])
}

drop.resource("posts", PostController())

drop.run()
