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

    constructor() ERC721("CharityAuction", "CA") {}

    struct DonatedItem {
        address donar;
        uint256 itemId;
        uint256 auctionstart;
        uint256 auctionend;
        uint256 highestbid;
        address highestbidder;
        string tokenuri;
        uint256 startingPrice;
        uint256[] relatedItem;
        bool isListed;
        bool isAuctionEnd;
    }
    event Mint(
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
    mapping(address => DonatedItem) public donaraddress;
    mapping(uint256 => DonatedItem) public idtodonar;

    function mintItem(
        string memory _tokenuri,
        uint256 _startingPrice
    ) external {
        uint256 tokenId = _tokenIdCounter.current();
        uint256[] memory temprealteditem = new uint256[](1);
        temprealteditem[0] = tokenId;
        idtodonar[tokenId] = DonatedItem(
            msg.sender,
            tokenId,
            block.timestamp,
            0,
            0,
            address(0),
            _tokenuri,
            _startingPrice,
            temprealteditem,
            true,
            false
        );
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenuri);
        _tokenIdCounter.increment();
        emit Mint(
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
    }

    event CreateAuction(
        address indexed auctionowner,
        uint256 _auctionduration,
        uint256 _auctionId
    );

    function createAuction(uint256 tokenId, uint256 _duration) external {
        require(_exists(tokenId), "TokenId does not exists");
        require(
            idtodonar[tokenId].donar == msg.sender,
            "You are not the Owner of this donation"
        );
        uint256 _auctionend = block.timestamp + _duration;
        idtodonar[tokenId].auctionend = _auctionend;
        emit CreateAuction(msg.sender, _auctionend, tokenId);
    }

    function bidStart(uint256 tokenId) external payable {
        require(_exists(tokenId), "TokenId does not exists");
        require(
            idtodonar[tokenId].donar != msg.sender,
            "Owner can not bid his own donation"
        );
        require(msg.value > idtodonar[tokenId].highestbid, "Bid Higher");
        if (idtodonar[tokenId].highestbidder != address(0)) {
            idtodonar[tokenId].highestbid += msg.value;
            idtodonar[tokenId].highestbidder = msg.sender;
        }
        idtodonar[tokenId].highestbid = msg.value;
        idtodonar[tokenId].highestbidder = msg.sender;
    }
}
//INcomplete
