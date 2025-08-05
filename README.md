# 🏃‍♂️ Onchain Tag Game    
    
**Onchain Tag** is a decentralized version of the classic game of tag (догонялки), fully written in Solidity.     
All player actions — joining, moving, and tagging — are handled directly on the Ethereum blockchain. No backend. No off-chain logic. Pure on-chain fun.    
     
---   

## 🎮 Gameplay 
   
- The game takes place on a **10x10 grid**.   
- Players join the game and are randomly placed on the grid.    
- One player is automatically assigned as **"It"** (the tagger).  
- The "It" can move and **tag** another player by landing on the same grid cell.
- Once tagged, the other player becomes "It", and the cycle continues.  
 
---

## 📦 Features 
  
- ✅ 100% on-chain logic   
- ✅ Random spawn positions (based on `block.timestamp` and `msg.sender`) 
- ✅ Grid movement with bounds checking 
- ✅ Tagging system (auto handover of "It" status)
- ✅ Public state for all players 

---

## ✨ Smart Contract

Written in **Solidity ^0.8.24**  
Deployed on: _You choose the testnet or mainnet_

Main contract file: [`OnchainTag.sol`](./OnchainTag.sol)

---

## 📋 Functions

```solidity
function joinGame() external
