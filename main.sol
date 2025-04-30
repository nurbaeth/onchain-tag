// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract OnchainTag {
    uint8 constant GRID_SIZE = 10;

    struct Player {
        uint8 x;
        uint8 y;
        bool isTagged;
        bool isActive;
    }

    mapping(address => Player) public players;
    address[] public playerList;
    address public it; // кто водит

    modifier onlyActive() {
        require(players[msg.sender].isActive, "Not an active player");
        _;
    }

    function joinGame() external {
        require(!players[msg.sender].isActive, "Already joined");

        uint8 x = uint8(uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp))) % GRID_SIZE);
        uint8 y = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % GRID_SIZE);

        players[msg.sender] = Player(x, y, false, true);
        playerList.push(msg.sender);

        if (it == address(0)) {
            it = msg.sender;
            players[msg.sender].isTagged = true;
        }
    }

    function move(int8 dx, int8 dy) external onlyActive {
        Player storage player = players[msg.sender];
        require(dx >= -1 && dx <= 1 && dy >= -1 && dy <= 1, "Invalid move");
        require(!(dx == 0 && dy == 0), "Must move");

        // Обновление позиции, не выходя за пределы GRID_SIZE
        int8 newX = int8(player.x) + dx;
        int8 newY = int8(player.y) + dy;

        require(newX >= 0 && newX < int8(GRID_SIZE), "X out of bounds");
        require(newY >= 0 && newY < int8(GRID_SIZE), "Y out of bounds");

        player.x = uint8(newX);
        player.y = uint8(newY);

        // Если водящий — проверяем попытку тега
        if (msg.sender == it) {
            for (uint i = 0; i < playerList.length; i++) {
                address other = playerList[i];
                if (other == msg.sender || !players[other].isActive) continue;

                Player storage target = players[other];
                if (target.x == player.x && target.y == player.y) {
                    players[it].isTagged = false;
                    players[other].isTagged = true;
                    it = other;
                    break;
                }
            }
        }
    }

    function getPosition(address player) external view returns (uint8, uint8) {
        return (players[player].x, players[player].y);
    }

    function getAllPlayers() external view returns (address[] memory) {
        return playerList;
    }
}
