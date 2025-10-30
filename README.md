# Simple NFT Marketplace

A decentralized marketplace for listing, buying, and selling ERC721 Non-Fungible Tokens (NFTs). This project consists of two main contracts: an ERC721 NFT contract (`ArtNFT.sol`) and the `Marketplace.sol` contract that facilitates trades.

## Description

This project demonstrates the powerful concept of contract-to-contract interaction. Users can mint an NFT from the `ArtNFT` contract, approve the `Marketplace` contract to manage it, and then list it for sale. Another user can then purchase the NFT, with the marketplace securely handling the transfer of both the NFT and the payment.

## Features

-   **Two-Contract System:** A dedicated contract for the NFT collection and another for the marketplace logic.
-   **ERC721 Compliant:** Uses OpenZeppelin's battle-tested ERC721 implementation.
-   **Approval-Based Transfers:** Leverages the `approve` mechanism of the ERC721 standard, a core concept in DeFi and NFTs.
-   **Secure Transactions:** Safely transfers the NFT to the buyer and the Ether to the seller in a single atomic transaction.
-   **Listing Management:** Sellers can list their items and cancel their listings if they change their mind.

## Concepts Demonstrated

-   **Contract Interaction:** The `Marketplace` contract calls functions on the `ArtNFT` contract.
-   **Interfaces (`IERC721`):** Using an interface to interact with any standard ERC721 contract, making the marketplace generic.
-   **OpenZeppelin Library:** Integration of industry-standard, secure smart contracts.
-   **ERC721 `approve` and `safeTransferFrom`:** The fundamental mechanics of NFT trading.
-   **Payable Functions:** The `buyItem` function's ability to receive Ether.
-   **Nested Mappings:** A more complex data structure for organizing listings efficiently.

## Getting Started

### Prerequisites

-   An Ethereum development environment like [Remix IDE](https://remix.ethereum.org/).
-   For local development, you will need to install OpenZeppelin contracts (`npm install @openzeppelin/contracts`). In Remix, you can import them directly via URL or GitHub.

### Usage Flow with Remix IDE

1.  **Deploy Contracts:**
    -   Create and compile both `ArtNFT.sol` and `Marketplace.sol` in Remix.
    -   Deploy `ArtNFT.sol` first.
    -   Then, deploy `Marketplace.sol`.

2.  **Mint an NFT (as User A):**
    -   Interact with the deployed `ArtNFT` contract.
    -   Call the `safeMint` function, passing your own address (User A) as the `to` parameter. You will mint an NFT with `tokenId` 1.

3.  **Approve the Marketplace (as User A):**
    -   Still interacting with the `ArtNFT` contract.
    -   Call the `approve` function.
    -   For the `to` address, paste the address of your deployed `Marketplace` contract.
    -   For the `tokenId`, enter `1`. This gives the marketplace permission to move your NFT.

4.  **List the NFT for Sale (as User A):**
    -   Now, interact with the deployed `Marketplace` contract.
    -   Call the `listItem` function.
    -   `_nftContract`: The address of your deployed `ArtNFT` contract.
    -   `_tokenId`: `1`.
    -   `_price`: The desired price in Wei (e.g., `1000000000000000000` for 1 Ether).

5.  **Buy the NFT (as User B):**
    -   In Remix, switch the active account to a different address (User B).
    -   Interact with the `Marketplace` contract.
    -   In the "Value" field, enter the price you set in the previous step (e.g., 1 Ether).
    -   Call the `buyItem` function with the `ArtNFT` contract address and `tokenId` `1`.
    -   The transaction will succeed. User A will receive 1 Ether, and User B will become the new owner of the NFT. You can verify this by calling `ownerOf` in the `ArtNFT` contract.

## License

This project is licensed under the MIT License.
