// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts@4.9.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.9.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.9.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.9.0/security/Pausable.sol";

contract CharityAuction is ERC721URIStorage, Pausable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _itemsSold;
    address public Contractowner;
    address public arbiter;

    constructor(address _arbiter) ERC721("CharityAuction", "CA") {
        Contractowner = msg.sender;
        arbiter = _arbiter;
        estate = State.Created;
    }

    enum State {
        Created,
        ItemMint,
        CreateAuction,
        StartBid,
        Locked,
        Released,
        AuctionEnd
    }
    State public estate;
    mapping(uint256 => State) public state;
    struct DonatedItem {
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
        bool isListed;
        bool isAuctionEnd;
        uint256 bidCount;
    }
    mapping(uint256 => mapping(address => uint256)) public bidamount;
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
    mapping(uint256 => DonatedItem) public idtodonar;

    function mintItem(
        string memory _tokenuri,
        uint256 _startingPrice
    ) external {
        require(estate == State.Created, "Havn't Crated the Contract");
        uint256 tokenId = _tokenIdCounter.current();
        address[] memory tempbidder = new address[](1);
        tempbidder[0] = address(0);
        idtodonar[tokenId] = DonatedItem(
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
        state[tokenId] = State.ItemMint;
    }

    event CreateAuction(
        address indexed auctionowner,
        uint256 _auctionduration,
        uint256 _auctionId
    );

    function createAuction(uint256 tokenId, uint256 _duration) external {
        require(state[tokenId] == State.ItemMint, "Haven't Minted the Item");
        require(_exists(tokenId), "TokenId does not exists");
        require(
            idtodonar[tokenId].donar == msg.sender,
            "You are not the Owner of this donation"
        );
        uint256 _auctionend = block.timestamp + _duration;
        idtodonar[tokenId].auctionend = _auctionend;
        emit CreateAuction(msg.sender, _auctionend, tokenId);
        state[tokenId] = State.CreateAuction;
    }

    function bidStart(uint256 tokenId) external payable {
        require(
            state[tokenId] == State.CreateAuction ||
                state[tokenId] == State.StartBid,
            "Auction haven't been created yet"
        );
        require(_exists(tokenId), "TokenId does not exists");
        require(
            idtodonar[tokenId].donar != msg.sender,
            "Owner can not bid his own donation"
        );
        require(msg.value > idtodonar[tokenId].highestbid, "Bid Higher");
        require(
            block.timestamp <= idtodonar[tokenId].auctionend,
            "Auction Time's UP"
        );
        require(
            idtodonar[tokenId].isAuctionEnd != true,
            "Auction has already ended"
        );
        bidamount[tokenId][msg.sender] += msg.value;
        if (idtodonar[tokenId].bidCount == 0) {
            idtodonar[tokenId].bidCount++;
            idtodonar[tokenId].allbidder[0] = msg.sender;
        } else {
            uint256 length = idtodonar[tokenId].bidCount;
            for (uint i = 0; i < length; i++) {
                if (msg.sender != idtodonar[tokenId].allbidder[i]) {
                    idtodonar[tokenId].bidCount++;
                    idtodonar[tokenId].allbidder.push(msg.sender);
                }
            }
        }
        if (idtodonar[tokenId].highestbidder != address(0)) {
            idtodonar[tokenId].highestbid += msg.value;
            idtodonar[tokenId].highestbidder = msg.sender;
        }
        idtodonar[tokenId].highestbid = msg.value;
        idtodonar[tokenId].highestbidder = msg.sender;
        state[tokenId] = State.StartBid;
    }

    function endAuction(uint256 tokenId) external payable {
        require(
            state[tokenId] == State.StartBid,
            "Biding haven't been started yet"
        );
        require(
            msg.sender == idtodonar[tokenId].donar,
            "Only Item Owner can call this fuctnion"
        );
        require(
            block.timestamp > idtodonar[tokenId].auctionend,
            "Auction has time left"
        );
        require(
            idtodonar[tokenId].isAuctionEnd != true,
            "Auction is still going"
        );
        DonatedItem storage tempitem = idtodonar[tokenId];
        uint256 amount = tempitem.highestbid;
        (bool success, ) = arbiter.call{value: amount}("");
        require(success, "Token Transfer Failed");
        _approve(arbiter, tokenId);
        safeTransferFrom(msg.sender, arbiter, tokenId);
        state[tokenId] = State.Locked;
    }

    function releaseFund(uint256 tokenId) external payable {
        require(msg.value == idtodonar[tokenId].highestbid);
        require(state[tokenId] == State.Locked);
        require(msg.sender == arbiter, "Only Arbiter can call this function");

        (bool success, ) = idtodonar[tokenId].highestbidder.call{
            value: msg.value
        }("");
        require(success, "Token Transfer Failed");
        _approve(idtodonar[tokenId].highestbidder, tokenId);
        safeTransferFrom(msg.sender, idtodonar[tokenId].highestbidder, tokenId);
        _itemsSold.increment();
        idtodonar[tokenId].isAuctionEnd = true;
        state[tokenId] = State.Released;
    }

    function withdraw(uint256 tokenId) external {
        require(state[tokenId] == State.Released);
        require(_exists(tokenId), "Item Does not exist");
        require(
            idtodonar[tokenId].isAuctionEnd == true,
            "Auction is Still going"
        );
        require(msg.sender != idtodonar[tokenId].highestbidder, "Nope");

        uint256 bidnumber = idtodonar[tokenId].allbidder.length;
        if (bidnumber == 0) {
            _burn(tokenId);
        }
        uint256 amount = bidamount[tokenId][msg.sender];
        if (amount > 0) {
            bidamount[tokenId][msg.sender] = 0;
            (bool success, ) = msg.sender.call{value: amount}("");
            require(success, "Withdraw Failed");
        }
        for (uint256 i = 0; i < bidnumber; i++) {
            require(
                msg.sender != idtodonar[tokenId].allbidder[i],
                "You are Not a Bidder"
            );
            if (msg.sender == idtodonar[tokenId].allbidder[i]) {
                idtodonar[tokenId].allbidder[i] = idtodonar[tokenId].allbidder[
                    bidnumber - 1
                ];
                idtodonar[tokenId].allbidder.pop();
            }
        }
    }

    function bidwinner(uint256 tokenId) public view returns (address, uint256) {
        return (
            idtodonar[tokenId].highestbidder,
            idtodonar[tokenId].highestbid
        );
    }

    function viewallbids(
        uint256 tokenId
    ) public view returns (address[] memory) {
        return idtodonar[tokenId].allbidder;
    }

    function reset() external {
        require(msg.sender == Contractowner);
        estate = State.Created;
    }
}
