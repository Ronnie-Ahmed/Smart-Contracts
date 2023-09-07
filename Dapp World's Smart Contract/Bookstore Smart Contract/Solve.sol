// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Bookstore {
    error TransactionFailed();

    // Owner of the contract
    address owner;

    // Counter for book IDs
    uint bookid = 1;

    // Struct to store book details
    struct BookDetails {
        uint id;
        string title;
        string author;
        string publication;
        bool available;
    }

    // Array to store all book details
    BookDetails[] private bookDetails;

    // Mapping to quickly access book details by ID
    mapping(uint => BookDetails) private idToBookDetails;

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to the owner only
    modifier OnlyOwner() {
        require(msg.sender == owner, "Only Owner can call This Function");
        _;
    }

    // Function to add a book (accessible by owner)
    function addBook(
        string memory title,
        string memory author,
        string memory publication
    ) public OnlyOwner {
        idToBookDetails[bookid] = BookDetails(
            bookid,
            title,
            author,
            publication,
            true
        );

        BookDetails memory newBook = BookDetails(
            bookid,
            title,
            author,
            publication,
            true
        );

        bookDetails.push(newBook);
        bookid += 1;
    }

    // Function to make a book unavailable (accessible by owner)
    function removeBook(uint id) public OnlyOwner {
        require(id > 0, "Transaction Failed");
        require(idToBookDetails[id].available == true, "Transaction Failed");
        require(id <= bookDetails.length, "Transaction Failed");
        idToBookDetails[id].available = false;
    }

    // Function to update book details (accessible by owner)
    function updateDetails(
        uint id,
        string memory title,
        string memory author,
        string memory publication,
        bool available
    ) public OnlyOwner {
        require(id > 0, "Transaction Failed");
        require(id <= bookDetails.length, "Transaction Failed");
        idToBookDetails[id].id = id;
        idToBookDetails[id].title = title;
        idToBookDetails[id].author = author;
        idToBookDetails[id].publication = publication;
        idToBookDetails[id].available = available;
    }

    // Function to find book IDs by title
    function findBookByTitle(
        string memory title
    ) public view returns (uint[] memory) {
        uint[] memory ownerbookIds = new uint[](bookDetails.length);
        uint[] memory bookIds = new uint[](bookDetails.length);
        uint[] memory resultArray = new uint[](bookDetails.length);
        uint count = 0;
        uint count2 = 0;

        for (uint i = 0; i < bookDetails.length; i++) {
            if (
                keccak256(abi.encodePacked(idToBookDetails[i + 1].title)) ==
                keccak256(abi.encodePacked(title))
            ) {
                ownerbookIds[count] = idToBookDetails[i + 1].id;
                count++;
                if (idToBookDetails[i + 1].available == true) {
                    bookIds[count2] = idToBookDetails[i + 1].id;
                    count2++;
                }
            }
        }

        assembly {
            mstore(ownerbookIds, count)
        }

        assembly {
            mstore(bookIds, count2)
        }

        if (msg.sender == owner) {
            for (uint i = 0; i < ownerbookIds.length; i++) {
                resultArray[i] = ownerbookIds[i];
            }

            assembly {
                mstore(resultArray, count)
            }
        } else if (msg.sender != owner) {
            for (uint i = 0; i < bookIds.length; i++) {
                resultArray[i] = bookIds[i];
            }

            assembly {
                mstore(resultArray, count2)
            }
        }

        return resultArray;
    }

    // Function to find all books with a given publication
    function findAllBooksOfPublication(
        string memory publication
    ) public view returns (uint[] memory) {
        uint[] memory ownerbookIds = new uint[](bookDetails.length);
        uint[] memory bookIds = new uint[](bookDetails.length);
        uint[] memory resultArray = new uint[](bookDetails.length);
        uint count = 0;
        uint count2 = 0;

        for (uint i = 0; i < bookDetails.length; i++) {
            if (
                keccak256(
                    abi.encodePacked(idToBookDetails[i + 1].publication)
                ) == keccak256(abi.encodePacked(publication))
            ) {
                ownerbookIds[count] = idToBookDetails[i + 1].id;
                count++;
                if (idToBookDetails[i + 1].available == true) {
                    bookIds[count2] = idToBookDetails[i + 1].id;
                    count2++;
                }
            }
        }

        assembly {
            mstore(ownerbookIds, count)
        }

        assembly {
            mstore(bookIds, count2)
        }

        if (msg.sender == owner) {
            for (uint i = 0; i < ownerbookIds.length; i++) {
                resultArray[i] = ownerbookIds[i];
            }

            assembly {
                mstore(resultArray, count)
            }
        } else if (msg.sender != owner) {
            for (uint i = 0; i < bookIds.length; i++) {
                resultArray[i] = bookIds[i];
            }

            assembly {
                mstore(resultArray, count2)
            }
        }

        return resultArray;
    }

    // Function to find all books by a given author
    function findAllBooksOfAuthor(
        string memory author
    ) public view returns (uint[] memory) {
        uint[] memory ownerbookIds = new uint[](bookDetails.length);
        uint[] memory bookIds = new uint[](bookDetails.length);
        uint[] memory resultArray = new uint[](bookDetails.length);
        uint count = 0;
        uint count2 = 0;

        for (uint i = 0; i < bookDetails.length; i++) {
            if (
                keccak256(abi.encodePacked(idToBookDetails[i + 1].author)) ==
                keccak256(abi.encodePacked(author))
            ) {
                ownerbookIds[count] = idToBookDetails[i + 1].id;
                count++;
                if (idToBookDetails[i + 1].available == true) {
                    bookIds[count2] = idToBookDetails[i + 1].id;
                    count2++;
                }
            }
        }

        assembly {
            mstore(ownerbookIds, count)
        }

        assembly {
            mstore(bookIds, count2)
        }

        if (msg.sender == owner) {
            for (uint i = 0; i < ownerbookIds.length; i++) {
                resultArray[i] = ownerbookIds[i];
            }

            assembly {
                mstore(resultArray, count)
            }
        } else if (msg.sender != owner) {
            for (uint i = 0; i < bookIds.length; i++) {
                resultArray[i] = bookIds[i];
            }

            assembly {
                mstore(resultArray, count2)
            }
        }

        return resultArray;
    }

    // Function to get details of a book by its ID
    function getDetailsById(
        uint id
    )
        public
        view
        returns (
            string memory title,
            string memory author,
            string memory publication,
            bool available
        )
    {
        require(id > 0, "Transaction Failed");
        require(id <= bookDetails.length, "Transaction Failed");

        if (
            (idToBookDetails[id].available == false && msg.sender == owner) ||
            ((idToBookDetails[id].available == true && msg.sender == owner))
        ) {
            return (
                idToBookDetails[id].title,
                idToBookDetails[id].author,
                idToBookDetails[id].publication,
                idToBookDetails[id].available
            );
        } else if (idToBookDetails[id].available == true) {
            return (
                idToBookDetails[id].title,
                idToBookDetails[id].author,
                idToBookDetails[id].publication,
                idToBookDetails[id].available
            );
        } else if (idToBookDetails[id].available == false) {
            revert TransactionFailed();
        }
    }
}
