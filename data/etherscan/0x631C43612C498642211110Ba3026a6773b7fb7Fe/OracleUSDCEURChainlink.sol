{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "london",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 1000000
    },
    "remappings": [],
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    }
  },
  "sources": {
    "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ninterface AggregatorV3Interface {\n\n  function decimals()\n    external\n    view\n    returns (\n      uint8\n    );\n\n  function description()\n    external\n    view\n    returns (\n      string memory\n    );\n\n  function version()\n    external\n    view\n    returns (\n      uint256\n    );\n\n  // getRoundData and latestRoundData should both raise \"No data present\"\n  // if they do not have data to report, instead of returning unset values\n  // which could be misinterpreted as actual reported values.\n  function getRoundData(\n    uint80 _roundId\n  )\n    external\n    view\n    returns (\n      uint80 roundId,\n      int256 answer,\n      uint256 startedAt,\n      uint256 updatedAt,\n      uint80 answeredInRound\n    );\n\n  function latestRoundData()\n    external\n    view\n    returns (\n      uint80 roundId,\n      int256 answer,\n      uint256 startedAt,\n      uint256 updatedAt,\n      uint80 answeredInRound\n    );\n\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/Strings.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\n/**\n * @dev String operations.\n */\nlibrary Strings {\n    bytes16 private constant _HEX_SYMBOLS = \"0123456789abcdef\";\n\n    /**\n     * @dev Converts a `uint256` to its ASCII `string` decimal representation.\n     */\n    function toString(uint256 value) internal pure returns (string memory) {\n        // Inspired by OraclizeAPI's implementation - MIT licence\n        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol\n\n        if (value == 0) {\n            return \"0\";\n        }\n        uint256 temp = value;\n        uint256 digits;\n        while (temp != 0) {\n            digits++;\n            temp /= 10;\n        }\n        bytes memory buffer = new bytes(digits);\n        while (value != 0) {\n            digits -= 1;\n            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));\n            value /= 10;\n        }\n        return string(buffer);\n    }\n\n    /**\n     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.\n     */\n    function toHexString(uint256 value) internal pure returns (string memory) {\n        if (value == 0) {\n            return \"0x00\";\n        }\n        uint256 temp = value;\n        uint256 length = 0;\n        while (temp != 0) {\n            length++;\n            temp >>= 8;\n        }\n        return toHexString(value, length);\n    }\n\n    /**\n     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.\n     */\n    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {\n        bytes memory buffer = new bytes(2 * length + 2);\n        buffer[0] = \"0\";\n        buffer[1] = \"x\";\n        for (uint256 i = 2 * length + 1; i > 1; --i) {\n            buffer[i] = _HEX_SYMBOLS[value & 0xf];\n            value >>= 4;\n        }\n        require(value == 0, \"Strings: hex length insufficient\");\n        return string(buffer);\n    }\n}\n"
    },
    "contracts/external/AccessControl.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\n\npragma solidity ^0.8.7;\n\nimport \"@openzeppelin/contracts/utils/Context.sol\";\nimport \"@openzeppelin/contracts/utils/Strings.sol\";\n\nimport \"../interfaces/IAccessControl.sol\";\n\n/**\n * @dev This contract is fully forked from OpenZeppelin `AccessControl`.\n * The only difference is the removal of the ERC165 implementation as it's not\n * needed in Angle.\n *\n * Contract module that allows children to implement role-based access\n * control mechanisms. This is a lightweight version that doesn't allow enumerating role\n * members except through off-chain means by accessing the contract event logs. Some\n * applications may benefit from on-chain enumerability, for those cases see\n * {AccessControlEnumerable}.\n *\n * Roles are referred to by their `bytes32` identifier. These should be exposed\n * in the external API and be unique. The best way to achieve this is by\n * using `public constant` hash digests:\n *\n * ```\n * bytes32 public constant MY_ROLE = keccak256(\"MY_ROLE\");\n * ```\n *\n * Roles can be used to represent a set of permissions. To restrict access to a\n * function call, use {hasRole}:\n *\n * ```\n * function foo() public {\n *     require(hasRole(MY_ROLE, msg.sender));\n *     ...\n * }\n * ```\n *\n * Roles can be granted and revoked dynamically via the {grantRole} and\n * {revokeRole} functions. Each role has an associated admin role, and only\n * accounts that have a role's admin role can call {grantRole} and {revokeRole}.\n *\n * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means\n * that only accounts with this role will be able to grant or revoke other\n * roles. More complex role relationships can be created by using\n * {_setRoleAdmin}.\n *\n * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to\n * grant and revoke this role. Extra precautions should be taken to secure\n * accounts that have been granted it.\n */\nabstract contract AccessControl is Context, IAccessControl {\n    struct RoleData {\n        mapping(address => bool) members;\n        bytes32 adminRole;\n    }\n\n    mapping(bytes32 => RoleData) private _roles;\n\n    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;\n\n    /**\n     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`\n     *\n     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite\n     * {RoleAdminChanged} not being emitted signaling this.\n     *\n     * _Available since v3.1._\n     */\n    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);\n\n    /**\n     * @dev Emitted when `account` is granted `role`.\n     *\n     * `sender` is the account that originated the contract call, an admin role\n     * bearer except when using {_setupRole}.\n     */\n    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);\n\n    /**\n     * @dev Emitted when `account` is revoked `role`.\n     *\n     * `sender` is the account that originated the contract call:\n     *   - if using `revokeRole`, it is the admin role bearer\n     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)\n     */\n    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);\n\n    /**\n     * @dev Modifier that checks that an account has a specific role. Reverts\n     * with a standardized message including the required role.\n     *\n     * The format of the revert reason is given by the following regular expression:\n     *\n     *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/\n     *\n     * _Available since v4.1._\n     */\n    modifier onlyRole(bytes32 role) {\n        _checkRole(role, _msgSender());\n        _;\n    }\n\n    /**\n     * @dev Returns `true` if `account` has been granted `role`.\n     */\n    function hasRole(bytes32 role, address account) public view override returns (bool) {\n        return _roles[role].members[account];\n    }\n\n    /**\n     * @dev Revert with a standard message if `account` is missing `role`.\n     *\n     * The format of the revert reason is given by the following regular expression:\n     *\n     *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/\n     */\n    function _checkRole(bytes32 role, address account) internal view {\n        if (!hasRole(role, account)) {\n            revert(\n                string(\n                    abi.encodePacked(\n                        \"AccessControl: account \",\n                        Strings.toHexString(uint160(account), 20),\n                        \" is missing role \",\n                        Strings.toHexString(uint256(role), 32)\n                    )\n                )\n            );\n        }\n    }\n\n    /**\n     * @dev Returns the admin role that controls `role`. See {grantRole} and\n     * {revokeRole}.\n     *\n     * To change a role's admin, use {_setRoleAdmin}.\n     */\n    function getRoleAdmin(bytes32 role) public view override returns (bytes32) {\n        return _roles[role].adminRole;\n    }\n\n    /**\n     * @dev Grants `role` to `account`.\n     *\n     * If `account` had not been already granted `role`, emits a {RoleGranted}\n     * event.\n     *\n     * Requirements:\n     *\n     * - the caller must have ``role``'s admin role.\n     */\n    function grantRole(bytes32 role, address account) external override onlyRole(getRoleAdmin(role)) {\n        _grantRole(role, account);\n    }\n\n    /**\n     * @dev Revokes `role` from `account`.\n     *\n     * If `account` had been granted `role`, emits a {RoleRevoked} event.\n     *\n     * Requirements:\n     *\n     * - the caller must have ``role``'s admin role.\n     */\n    function revokeRole(bytes32 role, address account) external override onlyRole(getRoleAdmin(role)) {\n        _revokeRole(role, account);\n    }\n\n    /**\n     * @dev Revokes `role` from the calling account.\n     *\n     * Roles are often managed via {grantRole} and {revokeRole}: this function's\n     * purpose is to provide a mechanism for accounts to lose their privileges\n     * if they are compromised (such as when a trusted device is misplaced).\n     *\n     * If the calling account had been granted `role`, emits a {RoleRevoked}\n     * event.\n     *\n     * Requirements:\n     *\n     * - the caller must be `account`.\n     */\n    function renounceRole(bytes32 role, address account) external override {\n        require(account == _msgSender(), \"71\");\n\n        _revokeRole(role, account);\n    }\n\n    /**\n     * @dev Grants `role` to `account`.\n     *\n     * If `account` had not been already granted `role`, emits a {RoleGranted}\n     * event. Note that unlike {grantRole}, this function doesn't perform any\n     * checks on the calling account.\n     *\n     * [WARNING]\n     * ====\n     * This function should only be called from the constructor when setting\n     * up the initial roles for the system.\n     *\n     * Using this function in any other way is effectively circumventing the admin\n     * system imposed by {AccessControl}.\n     * ====\n     */\n    function _setupRole(bytes32 role, address account) internal {\n        _grantRole(role, account);\n    }\n\n    /**\n     * @dev Sets `adminRole` as ``role``'s admin role.\n     *\n     * Emits a {RoleAdminChanged} event.\n     */\n    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal {\n        emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);\n        _roles[role].adminRole = adminRole;\n    }\n\n    function _grantRole(bytes32 role, address account) internal {\n        if (!hasRole(role, account)) {\n            _roles[role].members[account] = true;\n            emit RoleGranted(role, account, _msgSender());\n        }\n    }\n\n    function _revokeRole(bytes32 role, address account) internal {\n        if (hasRole(role, account)) {\n            _roles[role].members[account] = false;\n            emit RoleRevoked(role, account, _msgSender());\n        }\n    }\n}\n"
    },
    "contracts/interfaces/IAccessControl.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\n\npragma solidity ^0.8.7;\n\n/// @title IAccessControl\n/// @author Forked from OpenZeppelin\n/// @notice Interface for `AccessControl` contracts\ninterface IAccessControl {\n    function hasRole(bytes32 role, address account) external view returns (bool);\n\n    function getRoleAdmin(bytes32 role) external view returns (bytes32);\n\n    function grantRole(bytes32 role, address account) external;\n\n    function revokeRole(bytes32 role, address account) external;\n\n    function renounceRole(bytes32 role, address account) external;\n}\n"
    },
    "contracts/oracle/OracleChainlinkMultiEfficient.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\n\npragma solidity ^0.8.7;\n\nimport \"@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol\";\nimport \"./utils/ChainlinkUtils.sol\";\n\n/// @title OracleChainlinkMultiEfficient\n/// @author Angle Core Team\n/// @notice Abstract contract to build oracle contracts looking at Chainlink feeds on top of\n/// @dev This is contract should be overriden with the correct addresses of the Chainlink feed\n/// and the right amount of decimals\nabstract contract OracleChainlinkMultiEfficient is ChainlinkUtils {\n    // =============================== Constants ===================================\n\n    uint256 public constant OUTBASE = 10**18;\n    uint256 public constant BASE = 10**18;\n\n    // =============================== Errors ======================================\n\n    error InvalidLength();\n    error ZeroAddress();\n\n    /// @notice Constructor of the contract\n    /// @param _stalePeriod Minimum feed update frequency for the oracle to not revert\n    /// @param guardians List of guardian addresses\n    constructor(uint32 _stalePeriod, address[] memory guardians) {\n        stalePeriod = _stalePeriod;\n        if (guardians.length == 0) revert InvalidLength();\n        for (uint256 i = 0; i < guardians.length; i++) {\n            if (guardians[i] == address(0)) revert ZeroAddress();\n            _setupRole(GUARDIAN_ROLE_CHAINLINK, guardians[i]);\n        }\n        _setRoleAdmin(GUARDIAN_ROLE_CHAINLINK, GUARDIAN_ROLE_CHAINLINK);\n    }\n\n    /// @notice Returns twice the value obtained from Chainlink feeds\n    function readAll() external view returns (uint256, uint256) {\n        uint256 quote = _quoteChainlink(BASE);\n        return (quote, quote);\n    }\n\n    /// @notice Returns the outToken value of 1 inToken\n    function read() external view returns (uint256 rate) {\n        rate = _quoteChainlink(BASE);\n    }\n\n    /// @notice Returns the value of the inToken obtained from Chainlink feeds\n    function readLower() external view returns (uint256 rate) {\n        rate = _quoteChainlink(BASE);\n    }\n\n    /// @notice Returns the value of the inToken obtained from Chainlink feeds\n    function readUpper() external view returns (uint256 rate) {\n        rate = _quoteChainlink(BASE);\n    }\n\n    /// @notice Converts a quote amount of inToken to an outToken amount using Chainlink rates\n    function readQuote(uint256 quoteAmount) external view returns (uint256) {\n        return _readQuote(quoteAmount);\n    }\n\n    /// @notice Converts a quote amount of inToken to an outToken amount using Chainlink rates\n    function readQuoteLower(uint256 quoteAmount) external view returns (uint256) {\n        return _readQuote(quoteAmount);\n    }\n\n    /// @notice Internal function to convert an in-currency quote amount to out-currency using Chainlink's feed\n    function _readQuote(uint256 quoteAmount) internal view returns (uint256) {\n        quoteAmount = (quoteAmount * BASE) / _inBase();\n        // We return only rates with base BASE\n        return _quoteChainlink(quoteAmount);\n    }\n\n    /// @notice Reads oracle price using a Chainlink circuit\n    /// @param quoteAmount The amount for which to compute the price expressed with base decimal\n    /// @return The `quoteAmount` converted in EUR\n    /// @dev If `quoteAmount` is `BASE_TOKENS`, the output is the oracle rate\n    function _quoteChainlink(uint256 quoteAmount) internal view returns (uint256) {\n        AggregatorV3Interface[2] memory circuitChainlink = _circuitChainlink();\n        uint8[2] memory circuitChainIsMultiplied = _circuitChainIsMultiplied();\n        uint8[2] memory chainlinkDecimals = _chainlinkDecimals();\n        for (uint256 i = 0; i < circuitChainlink.length; i++) {\n            (quoteAmount, ) = _readChainlinkFeed(\n                quoteAmount,\n                circuitChainlink[i],\n                circuitChainIsMultiplied[i],\n                chainlinkDecimals[i],\n                0\n            );\n        }\n        return quoteAmount;\n    }\n\n    /// @notice Returns the base of the inToken\n    /// @dev This function is a necessary function to keep in the interface of oracle contracts interacting with\n    /// the core module of the protocol\n    function inBase() external pure returns (uint256) {\n        return _inBase();\n    }\n\n    /// @notice Returns the array of the Chainlink feeds to look at\n    function _circuitChainlink() internal pure virtual returns (AggregatorV3Interface[2] memory);\n\n    /// @notice Base of the inToken\n    function _inBase() internal pure virtual returns (uint256);\n\n    /// @notice Amount of decimals of the Chainlink feeds of interest\n    /// @dev This function is initialized with a specific amounts of decimals but should be overriden\n    /// if a Chainlink feed does not have 8 decimals\n    function _chainlinkDecimals() internal pure virtual returns (uint8[2] memory) {\n        return [8, 8];\n    }\n\n    /// @notice Whether the Chainlink feeds should be multiplied or divided with one another\n    function _circuitChainIsMultiplied() internal pure virtual returns (uint8[2] memory) {\n        return [1, 0];\n    }\n}\n"
    },
    "contracts/oracle/implementations/OracleUSDCEURChainlink.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\n\npragma solidity ^0.8.7;\n\nimport \"@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol\";\nimport \"../OracleChainlinkMultiEfficient.sol\";\n\n/// @title OracleUSDCEURChainlink\n/// @author Angle Core Team\n/// @notice Gives the price of USDC in Euro in base 18 by looking at Chainlink USDC/USD and USD/EUR feeds\ncontract OracleUSDCEURChainlink is OracleChainlinkMultiEfficient {\n    string public constant DESCRIPTION = \"USDC/EUR Oracle\";\n\n    constructor(uint32 _stalePeriod, address[] memory guardians)\n        OracleChainlinkMultiEfficient(_stalePeriod, guardians)\n    {}\n\n    function _circuitChainlink() internal pure override returns (AggregatorV3Interface[2] memory) {\n        return [\n            // Oracle USDC/USD\n            AggregatorV3Interface(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6),\n            // Oracle EUR/USD\n            AggregatorV3Interface(0xb49f677943BC038e9857d61E7d053CaA2C1734C1)\n        ];\n    }\n\n    function _inBase() internal pure override returns (uint256) {\n        return 10**6;\n    }\n\n    // No need to override the `_chainlinkDecimals()` and `_circuitChainIsMultiplied()` functions\n}\n"
    },
    "contracts/oracle/utils/ChainlinkUtils.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\n\npragma solidity ^0.8.7;\n\nimport \"@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol\";\nimport \"../../external/AccessControl.sol\";\n\n/// @title ChainlinkUtils\n/// @author Angle Core Team\n/// @notice Utility contract that is used across the different module contracts using Chainlink\nabstract contract ChainlinkUtils is AccessControl {\n    /// @notice Represent the maximum amount of time (in seconds) between each Chainlink update\n    /// before the price feed is considered stale\n    uint32 public stalePeriod;\n\n    // Role for guardians and governors\n    bytes32 public constant GUARDIAN_ROLE_CHAINLINK = keccak256(\"GUARDIAN_ROLE\");\n\n    error InvalidChainlinkRate();\n\n    /// @notice Reads a Chainlink feed using a quote amount and converts the quote amount to\n    /// the out-currency\n    /// @param quoteAmount The amount for which to compute the price expressed with base decimal\n    /// @param feed Chainlink feed to query\n    /// @param multiplied Whether the ratio outputted by Chainlink should be multiplied or divided\n    /// to the `quoteAmount`\n    /// @param decimals Number of decimals of the corresponding Chainlink pair\n    /// @param castedRatio Whether a previous rate has already been computed for this feed\n    /// This is mostly used in the `_changeUniswapNotFinal` function of the oracles\n    /// @return The `quoteAmount` converted in out-currency (computed using the second return value)\n    /// @return The value obtained with the Chainlink feed queried casted to uint\n    function _readChainlinkFeed(\n        uint256 quoteAmount,\n        AggregatorV3Interface feed,\n        uint8 multiplied,\n        uint256 decimals,\n        uint256 castedRatio\n    ) internal view returns (uint256, uint256) {\n        if (castedRatio == 0) {\n            (uint80 roundId, int256 ratio, , uint256 updatedAt, uint80 answeredInRound) = feed.latestRoundData();\n            if (ratio <= 0 || roundId > answeredInRound || block.timestamp - updatedAt > stalePeriod)\n                revert InvalidChainlinkRate();\n            castedRatio = uint256(ratio);\n        }\n        // Checking whether we should multiply or divide by the ratio computed\n        if (multiplied == 1) quoteAmount = (quoteAmount * castedRatio) / (10**decimals);\n        else quoteAmount = (quoteAmount * (10**decimals)) / castedRatio;\n        return (quoteAmount, castedRatio);\n    }\n\n    /// @notice Changes the Stale Period\n    /// @param _stalePeriod New stale period (in seconds)\n    function changeStalePeriod(uint32 _stalePeriod) external onlyRole(GUARDIAN_ROLE_CHAINLINK) {\n        stalePeriod = _stalePeriod;\n    }\n}\n"
    }
  }
}}