https://github.com/tomadimitrie/FLCD-lab

# Finite automata

Class fields:
- states
- inputs (alphabet)
- initial state
- final state
- transitions
  - a dictionary where the key is the source and the value is another dictionary where the key is the input and the value is an array of destinations
  
  The isDeterministic function checks if there is only one path from the input to the next state
  The isAccepted function checks if the sequence conforms to the finite automata, by checking if it can be reached using the available transitions
  
The FA file structure:
- line 1: states
- line 2: inputs
- line 3: initial state
- line 4: final states
- line 5+: transition functions
EBNF:
digit ::= 0 | 1 | ... | 9
letter ::= a | b | ... | z | A | B | ... | Z
specialCharacter ::= + | - | _
alphabet ::= digit | letter | specialCharacter
state ::= letter {digit}
states ::= state {state}
initialState ::= state
finalStates ::= states
transition ::= "(" state "," alphabet ")" "->" state

The FA is used to detect the constants and identifiers, replacing the previous regex solution

# Hashtable

I implemented a hashtable in Swift and tested it.
The hashtable is generic, allowing any type that conforms to the HashTableHashable protocol to be used as a key, with any value.
The protocol has only one required function, the hashcode, which has the capacity as a parameter
The add function adds an element if the key does not exist yet, and the find function returns the value for a key or nil if the key does not exist

The scanner first reads the tokens from a file and splits them into their corresponding categories.
Then reads the user's program character by character, stopping at whitespaces and separators. Whitespaces are ignored, while separators are taken into consideration.
It groups the characters into tokens, adds them to the PIF, then depending on their type, if they are identifiers or constants, they are added to the corresponding hashtable.
The invalid characters throw an exception (e.g. p1err - 3a, nrDigits$)
The PIF and the 2 hashtables are written into separate files at the end. The number tuples represent the hashcode and the position in the linked list of that hashcode. -1 is reserved for tokens that are not identifiers nor constants.
