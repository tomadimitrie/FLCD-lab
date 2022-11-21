import Foundation

class LanguageSpecification {
    let keywords: [String]
    let operators: [String]
    let separators: [String]
    let whitespace: [String]
    
    let stringFA: FiniteAutomata
    let intFA: FiniteAutomata
    let identifierFA: FiniteAutomata
    
    init() {
        stringFA = FiniteAutomata(file: "/Users/toma/Desktop/FLCD-lab/lab-lftc/test/fa-string.in")
        intFA = FiniteAutomata(file: "/Users/toma/Desktop/FLCD-lab/lab-lftc/test/fa-int.in")
        identifierFA = FiniteAutomata(file: "/Users/toma/Desktop/FLCD-lab/lab-lftc/test/fa-identifier.in")
        
        let contents = try! String(contentsOfFile: "/Users/toma/Desktop/FLCD-lab/lab-lftc/test/tokens.txt")
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
        return identifierFA.isAccepted(sequence: token) && !self.isKeyword(token)
    }
    
    func isWhitespace(_ token: String) -> Bool {
        return self.whitespace.contains(token)
    }
    
    func isString(_ token: String) -> Bool {
        return stringFA.isAccepted(sequence: token)
    }
    
    func isDecimalNumber(_ token: String) -> Bool {
        return intFA.isAccepted(sequence: token)
    }
    
    func isNumber(_ token: String) -> Bool {
        return self.isDecimalNumber(token)
    }
    
    func isConstant(_ token: String) -> Bool {
        return self.isString(token) || self.isNumber(token)
    }
}
