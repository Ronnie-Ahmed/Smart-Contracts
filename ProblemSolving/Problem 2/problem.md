# Gavin and the Bookstore Smart Contract

Gavin is starting a new bookstore and wants to use a smart contract to securely store data and make the process easy for customers. Gavin needs functionalities to be enabled for customers to directly check the availability of books using the smart contract. He needs your help in implementing the smart contract with the following functionalities:

## Smart Contract Functions

The smart contract must contain the following public functions:

### `addBook(string title, string author, string publication)`

- Accessible by Gavin (owner).
- Gavin can add a book by specifying the title, author, and publication of the book respectively.
- The book is assigned a unique ID of type uint in the smart contract.
- The ID of the newly added book is one greater than the ID of the previously added book, or 1 if no books have been added yet.

### `removeBook(uint id)`

- Accessible by Gavin (owner).
- Gavin can make a book unavailable, e.g., in cases like the book being sold or damaged.

### `updateDetails(uint id, string title, string author, string publication, bool available)`

- Accessible by Gavin (owner).
- Gavin can modify the details of a book whose ID is `id`.
- If there is no book with ID `id` in the database, the transaction must fail.
- The smart contract can have a boolean indicating the availability of a book. This boolean value is `true` if the book is available and `false` if the book is not available.

## Function Outputs

The smart contract also has functions accessible to everyone:

### `findBookByTitle(string title) returns (uint[])`

- If Gavin (owner) calls this function, it returns an array of IDs of all books (available and unavailable) in the database that match the given title.
- If this function is accessed by any address other than Gavin's, it returns the IDs of only the available books that match the given title.

### `findAllBooksOfPublication(string publication) returns (uint[])`

- If Gavin (owner) calls this function, it returns an array of IDs of all books (available and unavailable) in the database that match the given publication.
- If this function is accessed by any address other than Gavin's, it returns the IDs of only the available books that match the given publication.

### `findAllBooksOfAuthor(string author) returns (uint[])`

- If Gavin (owner) calls this function, it returns an array of IDs of all books (available and unavailable) in the database that match the given author.
- If this function is accessed by any address other than Gavin's, it returns the IDs of only the available books that match the given author.

### `getDetailsById(uint id) returns (string title, string author, string publication, bool available)`

- Accessible by everyone.
- Returns details of the book with the given `id`, including title, author, publication, and availability.
- If there is no book with the given ID in the database, the transaction must fail.
- If this function is accessed by any address other than Gavin's, it returns the details only if the book is available, else the transaction must fail.

## Examples

Here are some examples of how the smart contract functions work:

| Example | Function            | Sender Address | Parameter                                            | Returns                                                     |
| ------- | ------------------- | -------------- | ---------------------------------------------------- | ----------------------------------------------------------- |
| 1       | `addBook()`         | Owner          | "Animal Farm", "George Orwell", "Secker and Warburg" | -                                                           |
| 1       | `getDetailsById()`  | Address 1      | 1                                                    | "Animal Farm", "George Orwell", "Secker and Warburg", true  |
| 1       | `findBookByTitle()` | Address 2      | "Animal Farm"                                        | [1]                                                         |
| 2       | `removeBook()`      | Address 1      | 1                                                    | (Transaction fails)                                         |
| 2       | `removeBook()`      | Owner          | 1                                                    | -                                                           |
| 2       | `getDetailsById()`  | Address 2      | 1                                                    | (Transaction fails)                                         |
| 2       | `getDetailsById()`  | Owner          | 1                                                    | "Animal Farm", "George Orwell", "Secker and Warburg", false |

In example 1, Gavin adds a book "Animal Farm" with the specified details. Then, two different addresses query the smart contract for details and book IDs.

In example 2, Gavin tries to remove a book using Address 1 (unsuccessful), then successfully removes the book using the owner's address. Subsequently, two different addresses query the smart contract for book details.
