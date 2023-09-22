// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

library HexStrings {
    bytes16 internal constant ALPHABET = "0123456789abcdef";
    uint8 internal constant _ADDRESS_LENGTH = 20;

    /// @notice Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
    /// @dev Credit to Open Zeppelin under MIT license https://github.com/OpenZeppelin/openzeppelin-contracts/blob/243adff49ce1700e0ecb99fe522fb16cff1d1ddc/contracts/utils/Strings.sol#L55
    function toHexString(
        uint256 value,
        uint256 length
    ) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = ALPHABET[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    function toHexStringNoPrefix(
        uint256 value,
        uint256 length
    ) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length);
        for (uint256 i = buffer.length; i > 0; i--) {
            buffer[i - 1] = ALPHABET[value & 0xf];
            value >>= 4;
        }
        return string(buffer);
    }

    function toHexStringsArray(
        uint256 value
    ) internal pure returns (string[20] memory) {
        string[20] memory array;// = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""];
        uint length = _ADDRESS_LENGTH;
        uint valLength = length * 2;
        uint8 index = 19;
        for (uint256 i = valLength; i > 0; i -= 2) {
            //buffer[i - 1] = ALPHABET[value & 0xf];
            string memory br = string(abi.encodePacked(ALPHABET[value & 0xf]));
            value >>= 4;
            string memory bl = string(abi.encodePacked(ALPHABET[value & 0xf]));
            value >>= 4;
            array[index] = string(abi.encodePacked(bl, br));
            if(index > 0) index--;
        }
        return array;
    }

    // // ref: https://stackoverflow.com/questions/59243982/how-to-correct-convert-bytes-to-bytes32-and-then-convert-back
    // //string memory hex
    // function toBytes32Array()
    //     internal
    //     pure
    //     returns (bytes32[] memory)
    // {
    //     bytes memory data = abi.encodePacked("");//hex
    //     // Find 32 bytes segments nb
    //     uint256 dataNb = data.length / 32;
    //     // Create an array of dataNb elements
    //     bytes32[] memory dataList = new bytes32[](dataNb);
    //     // Start array index at 0
    //     uint256 index = 0;
    //     // Loop all 32 bytes segments
    //     for (uint256 i = 32; i <= data.length; i = i + 32) {
    //         bytes32 temp;
    //         // Get 32 bytes from data
    //         assembly {
    //             temp := mload(add(data, i))
    //         }
    //         // Add extracted 32 bytes to list
    //         dataList[index] = temp;
    //         index++;
    //     }
    //     // Return data list
    //     return (dataList);
    // }

    function fromHexChar(uint8 c) internal pure returns (uint8) {
        if (bytes1(c) >= bytes1("0") && bytes1(c) <= bytes1("9")) {
            return c - uint8(bytes1("0"));
        }
        if (bytes1(c) >= bytes1("a") && bytes1(c) <= bytes1("f")) {
            return 10 + c - uint8(bytes1("a"));
        }
        if (bytes1(c) >= bytes1("A") && bytes1(c) <= bytes1("F")) {
            return 10 + c - uint8(bytes1("A"));
        }
        revert("fromHexChar(): fail");
    }

    function fromHexCharByte(bytes1 b) internal pure returns (uint8) {
        if (b >= "0" && b <= "9") {
            return uint8(b) - uint8(bytes1("0"));
        }
        if (b >= "a" && b <= "f") {
            return 10 + uint8(b) - uint8(bytes1("a"));
        }
        if (b >= "A" && b <= "F") {
            return 10 + uint8(b) - uint8(bytes1("A"));
        }
        revert("fromHexChar(): fail");
    }

    function fromHex2(string memory s) internal pure returns (uint256) {
        // ref: https://ethereum.stackexchange.com/questions/39989/solidity-convert-hex-string-to-bytes
        // bytes memory ss = bytes(s);
        // require(ss.length == 2);
        // uint8 r = fromHexChar(uint8(ss[0])) * 16 + fromHexChar(uint8(ss[1]));
        // return r;

        // ref: https://ethereum.stackexchange.com/questions/128514/how-to-convert-hex-string-to-a-uint-in-solidity-8-0-0
        bytes memory b = bytes(s);
        uint256 number = 0;
        // 0
        number = number << 4; // or number = number * 16 
        number |= fromHexCharByte(b[0]); // or number += numberFromAscII(b[i]);
        // 1
        number = number << 4; // or number = number * 16 
        number |= fromHexCharByte(b[1]); // or number += numberFromAscII(b[i]);

        return number;
    }
}
