import Foundation

class UI {
    var fa: FiniteAutomata!

    func printMenu() {
        print("""
        0. Exit
        1. Scan file
        2. Scan default files
        3. Scan FA
        4. Print states
        5. Print alphabet
        6. Print transitions
        7. Print initial state
        8. Print final states
        9. Print all
        10. Check if sequence is accepted
        """)
    }

    func scanFile() {
        let scanner = Scanner(file: readLine()!)
        scanner.tokenize()
        scanner.write()
    }
    
    func scanDefaultFiles() {
        for file in [
            "/Users/toma/Desktop/FLCD-lab/lab-lftc/test/p1.txt",
            "/Users/toma/Desktop/FLCD-lab/lab-lftc/test/p2.txt",
            "/Users/toma/Desktop/FLCD-lab/lab-lftc/test/p3.txt",
        //    "/Users/toma/Desktop/FLCD-lab/lab-lftc/test/p1err.txt",
        ] {
            let scanner = Scanner(file: file)
            scanner.tokenize()
            scanner.write()
        }
    }

    func scanFA() {
        fa = FiniteAutomata(file: readLine()!)
    }

    func printStates() {
        print(fa.states)
    }

    func printAlphabet() {
        print(fa.inputs)
    }

    func printTransitions() {
        print(fa.transitions)
    }

    func printInitialState() {
        print(fa.initialState)
    }

    func printFinalStates() {
        print(fa.finalStates)
    }

    func printAll() {
        print(fa.description)
    }
    
    func checkSequence() {
        print(fa.isAccepted(sequence: readLine()!))
    }

    lazy var callbacks: [() -> Void] = [
        {
            exit(0)
        },
        scanFile,
        scanDefaultFiles,
        scanFA,
        printStates,
        printAlphabet,
        printTransitions,
        printInitialState,
        printFinalStates,
        printAll,
        checkSequence
    ]

    func mainLoop() {
        while true {
            printMenu()
            let choice = Int(readLine()!)!
            callbacks[choice]()
        }
    }
}
