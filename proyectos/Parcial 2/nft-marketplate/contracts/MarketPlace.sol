// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Marketplace is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;

    struct Listing {
        address owner;
        uint96 price;
        bool isSold;
    }

    mapping(uint256 => Listing) public listings;
    mapping(address => uint256) public pendingWithdrawals;

    event ItemListed(uint256 tokenId, address seller, uint96 price);
    event ItemSold(uint256 tokenId, address buyer);

constructor() ERC721("NFTMarket", "NFTM") Ownable(msg.sender) {}

    function mintAndList(string memory _uri, uint96 _price) public {
        uint256 tokenId = nextTokenId++;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _uri);
        listings[tokenId] = Listing(msg.sender, _price, false);
        emit ItemListed(tokenId, msg.sender, _price);
    }

    function buy(uint256 _tokenId) public payable {
        Listing storage item = listings[_tokenId];
        require(!item.isSold, "Already sold");
        require(msg.value >= item.price, "Insufficient");

        _transfer(item.owner, msg.sender, _tokenId);
        item.isSold = true;
        pendingWithdrawals[item.owner] += msg.value;

        emit ItemSold(_tokenId, msg.sender);
    }

    function getListing(uint256 _tokenId) public view returns (address, uint96, bool) {
        Listing memory item = listings[_tokenId];
        return (item.owner, item.price, item.isSold);
    }

    function withdraw() public {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "Nothing to withdraw");
        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}

