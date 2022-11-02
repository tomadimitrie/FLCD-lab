class PIF {
    private var pif: [(token: String, position: (Int, Int))] = []
    
    func add(token: String, value: (Int, Int)) {
        self.pif.append((token: token, position: value))
    }
}

extension PIF: CustomStringConvertible {
    var description: String {
        pif.map { element in
            let (token, (hashPosition, hashIndex)) = element
            return "\(token) -> (\(hashPosition), \(hashIndex))"
        }.joined(separator: "\n")
    }
}
