// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract LibraryNFT is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _itemsSold;
    uint256 listingfee=0.001 ether;
    address public contractowner;
    constructor(address _owner)ERC721("Library","LNFT"){
        contractowner=_owner;
    }
    struct Book{
        address bookowner;
        uint256 tokenId;
        string bookId;
        string tokenuri;
        uint256 accessPrice;
    }
    mapping(uint256=>Book) public idtobook;
    mapping(uint256=>mapping(address=>bool))  _access;
    mapping(uint256 =>address[]) accesslist;
    function getListingFee() public view returns (uint256){
        return listingfee;
    }
    function changeListingFee(uint256 newfee) public {
        require(msg.sender==contractowner,"Only Contract owner can call this function");
        listingfee=newfee;
    }

    function mintbook(uint256 _price,string memory _tokenuri,string memory _bookId)public payable{
       
        require(msg.value >= listingfee,"Send the right amount of listing fee");
        (bool success,)=contractowner.call{value:msg.value}("");
        require(success,"Transaction failed");
        uint256 tokenId=_tokenIdCounter.current();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenuri);
        idtobook[tokenId]=Book(msg.sender,tokenId,_bookId,_tokenuri,_price);
        _tokenIdCounter.increment();
    }
    function getaccess(uint256 tokenId)public payable{
        require(_access[tokenId][msg.sender]!=true,"Already has access to this book");
        require(_exists(tokenId),"This book does not exists");
        require(msg.value>=idtobook[tokenId].accessPrice,"Not enough value");
        require(msg.sender!=idtobook[tokenId].bookowner,"Can Not Buy his own book");
        address to=idtobook[tokenId].bookowner;
        (bool success,)=to.call{value:msg.value}("");
        require(success,"Transaction access failed");
        _access[tokenId][msg.sender]=true;
        accesslist[tokenId].push(msg.sender);
    }
    function hasAccess(uint256 tokenId)public view returns(bool){
        require(_exists(tokenId),"This book does not exists");

        return _access[tokenId][msg.sender];     
    }
   function bookAccesslist(uint256 tokenId) public view returns(address[] memory){
       require(_exists(tokenId),"This book does not exists");

       return accesslist[tokenId];
   }
   function allListedBooks()public view returns(Book[] memory){
       uint256 length=_tokenIdCounter.current();
       Book[] memory tempbook=new Book[](length);
       for(uint256 i=0;i<length;i++){
           tempbook[i]=idtobook[i];
       }
       return tempbook;
   }
   function changeBookInfo(uint256 _tokenId,string memory _bookId,string memory _tokenUri,uint256 _price)public{
       require(_exists(_tokenId),"This book does not exists");

       require(msg.sender==idtobook[_tokenId].bookowner,"Only Book Owner can call this function");
       Book storage temp=idtobook[_tokenId];
       temp.bookId=_bookId;
       temp.tokenuri=_tokenUri;
       temp.accessPrice=_price;
   }

}
