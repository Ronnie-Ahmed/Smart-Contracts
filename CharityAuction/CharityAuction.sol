// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts@4.9.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.9.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.9.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.9.0/security/Pausable.sol";
contract CharityAuction is ERC721URIStorage,Pausable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _itemsSold;
    address public Contractowner;
    address public arbiter;
    constructor(address _arbiter)ERC721("CharityAuction","CA"){
        Contractowner=msg.sender;
        arbiter=_arbiter;
        estate=State.Created;        
    }
    enum State{
        Created,
        ItemMint,
        CreateAuction,
        StartBid,
        Locked,
        Released,
        AuctionEnd
    }
    State public estate;
    mapping(uint256 =>State) public state;
    struct DonatedItem{
        address owner;
        address donar;
        uint256 itemId;
        uint256 auctionstart;
        uint256 auctionend;
        uint256 highestbid;
        address highestbidder;
        address[] allbidder;
        string tokenuri;
        uint256 startingPrice;
        uint256[] relatedItem;
        bool isListed;
        bool isAuctionEnd;
         uint256 bidCount;
    }
    mapping(uint256=> mapping(address=>uint256)) public bidamount;
    event Mint(
        address owner,
        address indexed donar,
        uint256 itemId,
        uint256 auctionstart,
        uint256 auctionend,
        uint256 highestbid,
        address highestbidder,
        string tokenuri,
        uint256 startingPrice,
        bool isListed,
        bool isAuctionEnd
    );
    mapping(address=>DonatedItem) public donaraddress;
    mapping(uint256=>DonatedItem) public idtodonar;
    mapping(uint256 => address[]) allbidder;
    function mintItem(string memory _tokenuri,uint256 _startingPrice)external {
        require(estate==State.Created,"Havn't Crated the Contract");
        uint256 tokenId=_tokenIdCounter.current();
        uint256[] memory temprealteditem=new uint256[](1);
        address[] memory tempbidder=new address[](1);
        tempbidder[0]=address(0);
        temprealteditem[0]=tokenId;
        idtodonar[tokenId]=DonatedItem(
            Contractowner,
            msg.sender,
            tokenId,
            block.timestamp,
            0,
            0,
            address(0),
            tempbidder,
            _tokenuri,
            _startingPrice,
            temprealteditem,
            true,
            false,
            0
        );
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenuri); 
        _tokenIdCounter.increment();
        emit Mint(
            Contractowner,
            msg.sender,
            tokenId,
            block.timestamp,
            0,
            0,
            address(0),
            _tokenuri,
            _startingPrice,
            true,
            false
        );
        state[tokenId]=State.ItemMint;
    }
    event CreateAuction(
        address indexed auctionowner,
        uint256 _auctionduration,
        uint256 _auctionId
    );
    function createAuction(uint256 tokenId,uint256 _duration)external {
        require(state[tokenId]==State.ItemMint,"Haven't Minted the Item");
        require(_exists(tokenId),"TokenId does not exists");
        require( idtodonar[tokenId].donar==msg.sender,"You are not the Owner of this donation");
        uint256 _auctionend=block.timestamp + _duration;
        idtodonar[tokenId].auctionend=_auctionend;
        emit CreateAuction(msg.sender,_auctionend,tokenId);
        state[tokenId]=State.CreateAuction;
    }
    function bidStart(uint256 tokenId)external payable{
        require( state[tokenId]==State.CreateAuction || state[tokenId]==State.StartBid ,"Auction haven't been created yet");
        require(_exists(tokenId),"TokenId does not exists");
         require( idtodonar[tokenId].donar!=msg.sender,"Owner can not bid his own donation");
         require(msg.value>idtodonar[tokenId].highestbid,"Bid Higher");
         require(block.timestamp <=idtodonar[tokenId].auctionend,"Auction has Already Ended");
         require( idtodonar[tokenId].isAuctionEnd!=true,"Auction has already ended");
         uint256 length=idtodonar[tokenId].bidCount;
         bidamount[tokenId][msg.sender]+=msg.value;
         for(uint i=0;i<length;i++){
             if(msg.sender!=idtodonar[tokenId].allbidder[i]){
                 idtodonar[tokenId].bidCount++;
                 idtodonar[tokenId].allbidder[idtodonar[tokenId].bidCount-1]=msg.sender;
             }
         }       
         if( idtodonar[tokenId].highestbidder!=address(0)){
              idtodonar[tokenId].highestbid+=msg.value;
              idtodonar[tokenId].highestbidder=msg.sender;
         }
         idtodonar[tokenId].highestbid=msg.value;
         idtodonar[tokenId].highestbidder=msg.sender;
         state[tokenId]=State.StartBid;
    }
    function endAuction(uint256 tokenId) external payable{
        require(state[tokenId]==State.StartBid,"Biding haven't been started yet");
        require(msg.sender==idtodonar[tokenId].donar,"Only Item Owner can call this fuctnion");
        require(block.timestamp>idtodonar[tokenId].auctionend,"Auction has time left");
        require(idtodonar[tokenId].isAuctionEnd!=true,"Auction is still going");
        DonatedItem storage tempitem= idtodonar[tokenId];
        uint256 amount= tempitem.highestbid;
        (bool success,)=arbiter.call{value:amount}("");
        require(success,"Token Transfer Failed");
        _approve(arbiter, tokenId);       
        safeTransferFrom(msg.sender, arbiter, tokenId);  
        state[tokenId]=State.Locked;
    }
    function releaseFund(uint256 tokenId)private{
        require(state[tokenId]==State.Locked);
        require(msg.sender==arbiter,"Only Arbiter can call this function");
        uint256 amount=idtodonar[tokenId].highestbid;
        (bool success,)=idtodonar[tokenId].highestbidder.call{value:amount}("");
        require(success,"Transfer fund complete");
        _approve(idtodonar[tokenId].highestbidder, tokenId);       
        safeTransferFrom(msg.sender, idtodonar[tokenId].highestbidder, tokenId); 
        _itemsSold.increment();
        idtodonar[tokenId].isAuctionEnd=true;
        state[tokenId]=State.Released;
    }
    function withdraw(uint256 tokenId)external {
        require(state[tokenId]==State.Released);
        require(_exists(tokenId),"Item Does not exist");
        require(msg.sender==Contractowner,"Only contract Owner can call this function");
        require(idtodonar[tokenId].isAuctionEnd==true,"Auction is Still going");
        uint256 bidnumber=idtodonar[tokenId].bidCount;
        for(uint256 i=0;i<bidnumber;i++){
            uint256 amount=0;
            if(idtodonar[tokenId].allbidder[i]!=idtodonar[tokenId].highestbidder){
                amount= bidamount[tokenId][idtodonar[tokenId].allbidder[i]];
                (bool success,)=idtodonar[tokenId].allbidder[i].call{value:amount}("");
                require(success,"Transfer Failed");        
            }
        }
        _burn(tokenId);     
    }
    
}
//Incomplete