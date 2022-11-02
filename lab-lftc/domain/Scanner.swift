import Foundation

class Scanner {
    let file: String
    let spec = LanguageSpecification()
    let identifiers = HashTable<String>(capacity: 100)
    let constants = HashTable<String>(capacity: 100)
    let pif = PIF()
    var isValid = true
    
    init(file: String) {
        self.file = file
    }
    
    func tokenize() {
        let contents = try! String(contentsOfFile: self.file)
        for (lineIndex, _line) in contents.split(separator: "\n").map({ $0 + "\n" }).enumerated() {
            let line = Array(_line)
            var charIndex = 0
            var token = ""
            while charIndex < line.count {
                let char = String(line[charIndex])

                defer {
                    if spec.isSeparator(char) {
                        try! self.parseToken(char, line: lineIndex)
                    }
                    charIndex += 1
                }
                
                if spec.isWhitespace(char) || spec.isSeparator(char) {
                    if token != "" {
                        try! self.parseToken(token, line: lineIndex)
                    }
                    token = ""
                    continue
                }
                
                token += char
            }
        }
    }
    
    private func parseToken(_ token: String, line: Int) throws {
        print(token)
        if spec.isIdentifier(token) {
            let position = self.identifiers.add(key: token).get()
            if let position {
                self.pif.add(token: token, value: position)
            }
        } else if spec.isConstant(token) {
            let position = self.constants.add(key: token).get()
            if let position {
                self.pif.add(token: token, value: position)
            }
        } else if spec.isKeyword(token) || spec.isSeparator(token) || spec.isOperator(token) {
            self.pif.add(token: token, value: (-1, -1))
        } else {
            throw "error at token \(token) at line \(line)"
        }
    }
    
    func write() {
        guard self.isValid else {
            return
        }
        self.writeIdentifiers()
        self.writeConstants()
        self.writePif()
    }
    
    private func writeIdentifiers() {
        var url = URL(string: self.file)!
        let last = url.lastPathComponent
        url.deleteLastPathComponent()
        url = url.appendingPathComponent(last.replacingOccurrences(of: ".txt", with: "identifiers.txt"))
        let string = self.identifiers.description
        try! string.write(toFile: url.absoluteString, atomically: true, encoding: .utf8)
    }
    
    private func writeConstants() {
        var url = URL(string: self.file)!
        let last = url.lastPathComponent
        url.deleteLastPathComponent()
        url = url.appendingPathComponent(last.replacingOccurrences(of: ".txt", with: "constants.txt"))
        let string = self.constants.description
        try! string.write(toFile: url.absoluteString, atomically: true, encoding: .utf8)
    }
    
    private func writePif() {
        var url = URL(string: self.file)!
        let last = url.lastPathComponent
        url.deleteLastPathComponent()
        url = url.appendingPathComponent(last.replacingOccurrences(of: ".txt", with: "pif.txt"))
        let string = self.pif.description
        try! string.write(toFile: url.absoluteString, atomically: true, encoding: .utf8)
    }
}
