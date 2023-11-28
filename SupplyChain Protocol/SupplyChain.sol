// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

contract SupplyChain {
    address owner;
    uint256 productId;

    enum ProductStatus {
        Created,
        InTransit,
        Delivered
    }

    struct Product {
        address productOwner;
        address deliveredAddress;
        uint256 _productId;
        bytes32 productData;
        uint256 price;
        ProductStatus status;
    }

    mapping(uint256 => Product) productInfo;

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Only Owner can call This Function");
        _;
    }

    function created(
        address _owner,
        uint256 __price,
        string memory _productInfo,
        string memory location,
        string memory _OwnerNationalId,
        address _deliveredAddress
    ) external OnlyOwner returns (uint256, bytes32) {
        productId += 1;
        uint256 _price = __price * 1 ether;
        bytes32 messagehash = keccak256(
            abi.encodePacked(
                _owner,
                _price,
                _productInfo,
                location,
                _OwnerNationalId,
                _deliveredAddress,
                productId
            )
        );
        productInfo[productId] = Product(
            _owner,
            _deliveredAddress,
            productId,
            messagehash,
            _price,
            ProductStatus.Created
        );
        return (productId, messagehash);
    }

    function startShipping(uint256 _ProductId) external OnlyOwner {
        require(
            productInfo[_ProductId].status == ProductStatus.Created,
            "Product is not Initial States"
        );
        productInfo[_ProductId].status = ProductStatus.InTransit;
    }

    function delivered(uint256 _ProductId) external payable returns (bool) {
        require(
            productInfo[_ProductId].status == ProductStatus.InTransit,
            "Product is not Initial States"
        );
        address ownerAddress = productInfo[_ProductId].productOwner;
        address client = productInfo[_ProductId].deliveredAddress;

        require(
            msg.sender == client,
            "Only Delivered Address Can call this function"
        );
        uint256 _price = productInfo[_ProductId].price;
        productInfo[_ProductId].status = ProductStatus.Delivered;
        (bool success, ) = ownerAddress.call{value: _price}("");
        require(success, "Transaction Failed");
        return true;
    }

    function getInfo(uint256 _id) public view returns (Product memory) {
        return productInfo[_id];
    }

    function checkOwner() public view returns (address) {
        return owner;
    }
}
