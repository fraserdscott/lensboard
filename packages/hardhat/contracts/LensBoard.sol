//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@aave/lens-protocol/contracts/interfaces/ILensHub.sol";

contract LensBoard is ERC721Holder, Ownable {
    address public lensHub;
    address public collectModule;
    bytes private constant collectModuleInitData = abi.encode(true);

    constructor(address _lensHub, address _collectModule) {
        lensHub = _lensHub;
        collectModule = _collectModule;
    }

    function post(uint256 profileId, string memory contentURI) public {
        ILensHub(lensHub).post(
            DataTypes.PostData(
                profileId,
                contentURI,
                collectModule,
                collectModuleInitData,
                address(0),
                ""
            )
        );
    }

    function transferProfile(address to, uint256 profileId) public onlyOwner {
        IERC721(lensHub).safeTransferFrom(address(this), to, profileId);
    }
}
