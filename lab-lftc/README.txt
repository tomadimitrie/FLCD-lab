https://github.com/tomadimitrie/FLCD-lab

I implemented a hashtable in Swift and tested it.
The hashtable is generic, allowing any type that conforms to the HashTableHashable protocol to be used as a key, with any value.
The protocol has only one required function, the hashcode, which has the capacity as a parameter
The add function adds an element if the key does not exist yet, and the find function returns the value for a key or nil if the key does not exist

The scanner first reads the tokens from a file and splits them into their corresponding categories.
Then reads the user's program character by character, stopping at whitespaces and separators. Whitespaces are ignored, while separators are taken into consideration.
It groups the characters into tokens, adds them to the PIF, then depending on their type, if they are identifiers or constants, they are added to the corresponding hashtable.
The invalid characters throw an exception (e.g. p1err - 3a, nrDigits$)
The PIF and the 2 hashtables are written into separate files at the end. The number tuples represent the hashcode and the position in the linked list of that hashcode. -1 is reserved for tokens that are not identifiers nor constants.
