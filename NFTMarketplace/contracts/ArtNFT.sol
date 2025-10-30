// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// We import the necessary OpenZeppelin contracts.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title ArtNFT
 * @dev A simple ERC721 token contract for creating unique art pieces.
 */
contract ArtNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // The constructor sets the name and symbol for the NFT collection.
    constructor() ERC721("ArtNFT", "ART") Ownable(msg.sender) {}

    /**
     * @dev Mints a new NFT and assigns it to the specified address.
     * Can only be called by the contract owner.
     * @param to The address to receive the new NFT.
     * @return The ID of the newly minted token.
     */
    function safeMint(address to) public onlyOwner returns (uint256) {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        return tokenId;
    }
}
