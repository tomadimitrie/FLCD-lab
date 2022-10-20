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

class HashTable<Key: HashTableHashable & Equatable, Value> {
    struct Node {
        let key: Key
        let value: Value
    }
    
    enum AddState {
        case added
        case existing
    }
    
    var capacity: Int
    var items: [[Node]]
    
    init(capacity: Int) {
        self.capacity = capacity
        self.items = [[Node]](repeating: [], count: capacity)
    }
    
    @discardableResult
    func add(key: Key, value: Value) -> AddState {
        if self.find(key: key) != nil {
            return .existing
        }
        let hashCode = key.hashCode(for: self.capacity) % self.capacity
        self.items[hashCode].append(.init(key: key, value: value))
        return .added
    }
    
    func find(key: Key) -> Value? {
        let hashCode = key.hashCode(for: self.capacity) % self.capacity
        for node in self.items[hashCode] {
            if node.key == key {
                return node.value
            }
        }
        return nil
    }
}

let identifiers = HashTable<String, String>(capacity: 5)
assert(identifiers.add(key: "abc", value: "ABC") == .added)
assert(identifiers.add(key: "123", value: "456") == .added)
assert(identifiers.find(key: "abc") == "ABC")
assert(identifiers.find(key: "xyz") == nil)
assert(identifiers.find(key: "123") == "456")
assert(identifiers.add(key: "abc", value: "AAA") == .existing)


let constants = HashTable<String, any Equatable>(capacity: 5)
assert(constants.add(key: "abc", value: 5) == .added)
assert(constants.add(key: "123", value: 10) == .added)
assert(constants.find(key: "abc") as! Int == 5)
assert(constants.find(key: "xyz") == nil)
assert(constants.find(key: "123") as! Int == 10)
assert(constants.add(key: "abc", value: 5) == .existing)
