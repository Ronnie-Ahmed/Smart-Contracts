# Palindrome Checker Smart Contract

Implement a smart contract that checks if a given string is a palindrome.

## Palindrome Definition:

A palindrome is a word, phrase, number, or sequence of characters that can be read the same way forward and backward. It means that the sequence remains unchanged when read from left to right or from right to left. For example, the word "madam" is a palindrome because it reads the same way in both directions. Similarly, the word "racecar" is also a palindrome. On the other hand, the word "hello" is not a palindrome because it reads differently when reversed as "olleh".

In the world of palindromes, spaces, punctuation, and capitalization often don't matter. Palindromes are words or phrases that read the same forwards and backward, and when checking for them, we typically ignore spaces, punctuation (like commas and periods), and whether letters are uppercase or lowercase. For example, 'A man, a plan, a canal, Panama!' becomes 'amanaplanacanalpanama' when we remove spaces and punctuation, and 'Racecar' is a palindrome even with mixed capitalization. It's all about the letters and their sequence!

## Public Function

### `isPalindrome(string)`

- This is a pure function that takes a string as a parameter.
- Returns `true` if the string is a palindrome, otherwise returns `false`.

## Examples

1. **Example**

   - Function: `isPalindrome()`
   - Parameter: `""`
   - Returns: `true`

2. **Example**

   - Function: `isPalindrome()`
   - Parameter: `"aa"`
   - Returns: `true`

3. **Example**
   - Function: `isPalindrome()`
   - Parameter: `"ab"`
   - Returns: `false`
