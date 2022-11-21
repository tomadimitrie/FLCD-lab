import Foundation

class FiniteAutomata {
    let states: [String]
    let inputs: [String]
    let initialState: String
    let finalStates: [String]
    var transitions = [String: [String: [String]]]()
    
    init(file: String) {
        let contents = try! String(contentsOfFile: file)
        let lines = contents.split(separator: "\n")
        let q = lines[0]
            .split(separator: "=")[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
        states = q
            .split(separator: " ")
            .map { String($0) }
        let e = lines[1]
            .split(separator: "=")[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
        inputs = e
            .split(separator: " ")
            .map { String($0) }
        initialState = lines[2]
            .split(separator: "=")[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let f = lines[3]
            .split(separator: "=")[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
        finalStates = f
            .split(separator: " ")
            .map { String($0) }
        for i in 5..<lines.count {
            let line = lines[i]
            let components = line
                .split(separator: "->")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            let destination = components[1]
            let tokens = components[0]
                .dropLast(1)
                .dropFirst(1)
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            let source = tokens[0]
            let input = tokens[1]
            transitions[
                source,
                default: [:]
            ][
                input,
                default: []
            ].append(destination)
        }
    }
    
    func isDeterministic() -> Bool {
        for (_, inputs) in transitions {
            for (_, destinations) in inputs {
                if destinations.count > 1 {
                    return false
                }
            }
        }
        return true
    }
    
    func isAccepted(sequence: String) -> Bool {
        if !isDeterministic() {
            return false
        }
        let characters = Array(sequence).map { String($0) }
        var currentState = initialState
        for character in characters {
            if let inputs = transitions[currentState], let destinations = inputs[character] {
                currentState = destinations.first!
            } else {
                return false
            }
        }
        return finalStates.contains(currentState)
    }
}

extension FiniteAutomata: CustomStringConvertible {
    var description: String {
        return """
        States: \(states)
        Inputs: \(inputs)
        Initial state: \(initialState)
        Final state: \(finalStates)
        Transitions: \(transitions)
        """
    }
}
