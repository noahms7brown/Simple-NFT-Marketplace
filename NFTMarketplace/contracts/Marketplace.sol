// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// We need an interface to interact with any ERC721 contract.
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title Marketplace
 * @dev A simple marketplace for listing and buying ERC721 NFTs.
 */
contract Marketplace {

    // Struct to represent an item listed for sale
    struct Listing {
        address seller;
        uint256 price;
    }

    // A nested mapping to store listings:
    // NFT Contract Address -> Token ID -> Listing Details
    mapping(address => mapping(uint256 => Listing)) public listings;

    // Events
    event ItemListed(address indexed seller, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event ItemSold(address indexed buyer, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event ListingCancelled(address indexed seller, address indexed nftContract, uint256 indexed tokenId);

    /**
     * @dev Lists an NFT for sale on the marketplace.
     * @param _nftContract The address of the NFT contract.
     * @param _tokenId The ID of the token to list.
     * @param _price The selling price in WEI.
     */
    function listItem(address _nftContract, uint256 _tokenId, uint256 _price) public {
        require(_price > 0, "Price must be greater than zero.");
        
        IERC721 nft = IERC721(_nftContract);
        require(nft.ownerOf(_tokenId) == msg.sender, "You do not own this NFT.");
        
        // The marketplace contract must be approved to transfer the NFT on the seller's behalf.
        require(nft.getApproved(_tokenId) == address(this), "Marketplace not approved.");

        listings[_nftContract][_tokenId] = Listing({
            seller: msg.sender,
            price: _price
        });

        emit ItemListed(msg.sender, _nftContract, _tokenId, _price);
    }

    /**
     * @dev Buys a listed NFT.
     * The function must be sent with enough Ether to cover the price.
     * @param _nftContract The address of the NFT contract.
     * @param _tokenId The ID of the token to buy.
     */
    function buyItem(address _nftContract, uint256 _tokenId) public payable {
        Listing storage listing = listings[_nftContract][_tokenId];

        require(listing.price > 0, "Item is not listed for sale.");
        require(msg.value >= listing.price, "Not enough Ether sent to cover the price.");
        
        // Store seller before deleting the listing to prevent re-entrancy
        address payable seller = payable(listing.seller);
        
        // Remove the listing from the marketplace
        delete listings[_nftContract][_tokenId];
        
        // Transfer the NFT from the seller to the buyer (through the marketplace)
        IERC721(_nftContract).safeTransferFrom(seller, msg.sender, _tokenId);
        
        // Pay the seller
        (bool success, ) = seller.call{value: listing.price}("");
        require(success, "Failed to transfer Ether to seller.");
        
        emit ItemSold(msg.sender, _nftContract, _tokenId, listing.price);
    }

    /**
     * @dev Allows a seller to cancel their listing.
     * @param _nftContract The address of the NFT contract.
     * @param _tokenId The ID of the token to cancel.
     */
    function cancelListing(address _nftContract, uint256 _tokenId) public {
        Listing storage listing = listings[_nftContract][_tokenId];
        require(listing.seller == msg.sender, "You are not the seller of this item.");
        
        delete listings[_nftContract][_tokenId];
        
        emit ListingCancelled(msg.sender, _nftContract, _tokenId);
    }
}
