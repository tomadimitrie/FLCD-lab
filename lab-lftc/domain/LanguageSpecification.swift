import Foundation

class LanguageSpecification {
    let keywords: [String]
    let operators: [String]
    let separators: [String]
    let whitespace: [String]
    
    init() {
        let contents = try! String(contentsOfFile: "/Users/toma/Desktop/lab2/lab-lftc/test/tokens.txt")
        let batches = contents
            .components(separatedBy: "---")
            .map {
                $0
                    .split(separator: "\n")
                    .map {
                        [
                            "<space>": " ",
                            #"\n"#: "\n",
                            #"\t"#: "\t"
                        ][String($0)] ?? String($0)
                    }
            }
        self.keywords = batches[0]
        self.operators = batches[1]
        self.separators = batches[2]
        self.whitespace = batches[3]
    }
    
    func isKeyword(_ token: String) -> Bool {
        return self.keywords.contains(token)
    }
    
    func isOperator(_ token: String) -> Bool {
        return self.operators.contains(token)
    }
    
    func isSeparator(_ token: String) -> Bool {
        return self.separators.contains(token)
    }
    
    func isIdentifier(_ token: String) -> Bool {
        return token.matches(#"^[a-zA-Z]([a-z|A-Z|0-9|_])*$"#) && !self.isKeyword(token)
    }
    
    func isWhitespace(_ token: String) -> Bool {
        return self.whitespace.contains(token)
    }
    
    func isString(_ token: String) -> Bool {
        return token.matches(#"^"[a-zA-Z0-9!@#$%^&*()-=_+{}\[\]:;"'|\\<,>.?\/~`]*"$"#)
    }
    
    func isChar(_ token: String) -> Bool {
        return token.matches(#"^'[a-zA-Z0-9!@#$%^&*()-=_+{}\[\]:;"'|\\<,>.?\/~`]'$"#)
    }
    
    func isDecimalNumber(_ token: String) -> Bool {
        return token.matches(#"^0|(\+|-)?[1-9][0-9]*$"#)
    }
    
    func isHexNumber(_ token: String) -> Bool {
        return token.matches(#"^0x0|(\+|-)?0x[1-9a-fA-F][0-9a-fA-F]*$"#)
    }
    
    func isOctalNumber(_ token: String) -> Bool {
        return token.matches(#"^0o0|(\+|-)?0o[1-7][0-7]*$"#)
    }
    
    func isNumber(_ token: String) -> Bool {
        return self.isDecimalNumber(token) || self.isHexNumber(token) || self.isOctalNumber(token)
    }
    
    func isConstant(_ token: String) -> Bool {
        return self.isString(token) || self.isChar(token) || self.isNumber(token)
    }
}
