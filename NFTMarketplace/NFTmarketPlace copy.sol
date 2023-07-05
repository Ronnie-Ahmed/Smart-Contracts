// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.9.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.9.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.9.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.9.0/security/Pausable.sol";

contract NFTmarketPlace is ERC721URIStorage,Pausable {
     using Counters for Counters.Counter;
     uint256 listingPrice=1 ether;

    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _itemsSold;
    address payable owner;
    constructor()ERC721("NFTToken","NT"){
        owner=payable(msg.sender);
    }
    function pause()external{
       
    }
    struct NFT{
        address payable seller;
        uint256 price;
        uint256 tokenid;
        uint256 timestamp;
        string tokenuri;
        uint256[] relatedTokens;
    }
    mapping(address=>NFT) private addresstonft;
    mapping(uint256=>NFT) public idtonft;
    event NFTCreated (
        address indexed seller,
        uint256 price,
        uint256 indexed tokenid,
        uint256 timestamp,
        string tokenuri,
        uint256[] relatedTokens
    );
    event NFTbuy(
        address indexed buyer,
        uint256 price,
        uint256 indexed tokenid,
        uint256 timestamp
    );
    function mintToken(uint256 _price,string memory _tokenuri)external payable {
        _price=_price*1 ether;
        require(msg.value >= listingPrice,"Please send listing price");
        uint256 tokenID=_tokenIdCounter.current();
        _tokenIdCounter.increment();
      
        uint256[] memory nfttokenarray=new uint256[](1);
        nfttokenarray[0]=tokenID;
        
        (bool success, )=owner.call{value:msg.value}("");
        require(success,"Minting Transaction failed");
        idtonft[tokenID]=NFT(payable(msg.sender),_price,tokenID,block.timestamp,_tokenuri,nfttokenarray);
        emit NFTCreated(msg.sender,_price,tokenID,block.timestamp,_tokenuri,nfttokenarray);
        _safeMint(msg.sender, tokenID);
         _setTokenURI(tokenID, _tokenuri);
    }
    function buytoken(uint256 _tokenID)external payable{
        require(_exists(_tokenID),"TokenId does Not exist in the marketplace");  
        NFT storage nft=idtonft[_tokenID];
        require(msg.sender!=nft.seller,"You can not buy your own token");
        require(msg.value==nft.price,"Price does not match");
        //    bool approved=true;
        // _setApprovalForAll(idtonft[_tokenID].seller, msg.sender, approved);
          (bool success,)=payable(nft.seller).call{value:msg.value}("");
        require(success,"Transaction Failed");
        _approve(msg.sender, _tokenID);
        safeTransferFrom(nft.seller, msg.sender, _tokenID);
         _itemsSold.increment();
         nft.seller=payable(msg.sender);
         nft.timestamp=block.timestamp;
        uint256[] memory nfttokenarray=new uint256[](1);
         nfttokenarray[0]=_tokenID;
        nft.relatedTokens=nfttokenarray;
        emit NFTbuy(msg.sender,nft.price,_tokenID,block.timestamp);
    }
   
    function changeTokenPrice(uint256 tokenID,uint256 _price)external { 
        require(msg.sender==idtonft[tokenID].seller,"YOu are not the owner");
        idtonft[tokenID].price=_price;
    }
    function destroymytoken(uint256 tokenID)external{
        require(msg.sender==idtonft[tokenID].seller,"YOu are not the owner");
        _burn(tokenID); 
    }
   
    function pausecontract()external  {
        require(msg.sender==owner,"Only owner can call this function");
        _pause();
    }
    function unpausecontract() external {
                require(msg.sender==owner,"Only owner can call this function");

        _unpause();
    }
    function getAllnfts()external view returns(NFT[] memory){
        uint256 length=_tokenIdCounter.current();
        NFT[] memory tokens=new NFT[](length);
        for(uint256 i=0;i<length;i++){
            NFT storage tempnft=idtonft[i];
            tokens[i]=tempnft;
        }
        return tokens;
    }
    function getMYnft()external view returns(NFT[] memory){
        uint256 length=_tokenIdCounter.current();
        uint256 netoken=0;
        for(uint256 i=0;i<length;i++){

            if(idtonft[i].seller==msg.sender){
            netoken++;}
            
        }
        NFT[] memory tempnft=new NFT[](netoken);
        uint token1=0;
        for(uint i=0;i<length;i++){
           if(idtonft[i].seller==msg.sender){
            tempnft[token1]=idtonft[i];
            token1++;}
        }
        return tempnft;
    }
    function createAuction(uint256 time,uint256 _expectedPrice)external {

    }
    function time()external view returns(uint256){
        return block.timestamp;

    }
  

}