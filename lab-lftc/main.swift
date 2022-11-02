import Foundation

protocol HashTableHashable {
    func hashCode(for capacity: Int) -> Int
}

extension String: HashTableHashable {
    func hashCode(for capacity: Int) -> Int {
        self.map {
            Int($0.asciiValue ?? 0)
        }
        .reduce(0, +) % capacity
    }
}

extension Int: HashTableHashable {
    func hashCode(for capacity: Int) -> Int {
        self % capacity
    }
}

class HashTable<Key: HashTableHashable & Equatable> {
    enum AddState: Equatable {
        case added(Int, Int)
        case existing(Int, Int)
        
        func get() -> (Int, Int)? {
            switch self {
            case .existing(let outer, let inner):
                return (outer, inner)
            case .added(let outer, let inner):
                return (outer, inner)
            }
        }
    }
    
    var capacity: Int
    var items: [[Key]]
    
    init(capacity: Int) {
        self.capacity = capacity
        self.items = [[Key]](repeating: [], count: capacity)
    }
    
    @discardableResult
    func add(key: Key) -> AddState {
        let existing = self.find(key: key)
        if let existing {
            return .existing(existing.0, existing.1)
        }
        let hashCode = key.hashCode(for: self.capacity) % self.capacity
        self.items[hashCode].append(key)
        return .added(hashCode, self.items[hashCode].count - 1)
    }
    
    func find(key: Key) -> (Int, Int)? {
        let hashCode = key.hashCode(for: self.capacity) % self.capacity
        for (i, item) in self.items[hashCode].enumerated() {
            if item == key {
                return (hashCode, i)
            }
        }
        return nil
    }
}

extension HashTable: CustomStringConvertible {
    var description: String {
        var string = ""
        for (outerIndex, outer) in self.items.enumerated() {
            for (innerIndex, inner) in outer.enumerated() {
                string += "\(inner): (\(outerIndex), \(innerIndex))\n"
            }
        }
        return string
    }
}

({
    let identifiers = HashTable<String>(capacity: 5)
    assert(identifiers.add(key: "abc") == .added(4, 0))
    assert(identifiers.add(key: "123") == .added(0, 0))
    assert(identifiers.find(key: "xyz") == nil)
    let value = identifiers.find(key: "abc")
    assert(value != nil)
    assert(value! == (4, 0))
})()

({
    let constants = HashTable<String>(capacity: 5)
    assert(constants.add(key: "abc") == .added(4, 0))
    assert(constants.add(key: "cba") == .added(4, 1))
    let value = constants.find(key: "cba")
    assert(value != nil)
    assert(value! == (4, 1))
})()


for file in [
    "/Users/toma/Desktop/lab2/lab-lftc/test/p1.txt",
    "/Users/toma/Desktop/lab2/lab-lftc/test/p2.txt",
    "/Users/toma/Desktop/lab2/lab-lftc/test/p3.txt",
//    "/Users/toma/Desktop/lab2/lab-lftc/test/p1err.txt",
] {
    let scanner = Scanner(file: file)
    scanner.tokenize()
    scanner.write()
}
