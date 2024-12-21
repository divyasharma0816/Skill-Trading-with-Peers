# Skill Trading with Peers


## Project Description:
The **Skill Trading with Peers** project is a decentralized platform where individuals can trade their skills and earn **Skill Tokens (SKT)** as rewards. The platform allows users to offer skills, request skills from others, and settle trades in a peer-to-peer manner using the blockchain. The platform facilitates the trading of various skills, such as teaching, coding, design, or language exchange, with the reward system based on the time spent on skill exchanges.

The project aims to create a fair, transparent, and decentralized ecosystem for skill exchange, leveraging blockchain technology to ensure security, trust, and rewarding token incentives for all participants.

## Contract Address:
0xA390F112046b68f6b7aB4FdC6C0729afE8abe506**
![Screenshot 2024-12-21 142902](https://github.com/user-attachments/assets/3c01cd88-4d7b-4d72-9dc8-55b3beb34672)


## Project Vision:
The vision of the **Skill Trading with Peers** platform is to empower individuals by providing a decentralized marketplace for skill exchanges. The platform aims to:
- Enable individuals to monetize their skills by offering them in exchange for tokens.
- Build a transparent, trustless environment where users can trade skills and resolve disputes efficiently.
- Reward participants for contributing to the platform and enhancing their skills through peer-to-peer exchanges.
- Foster a community where people can connect and collaborate on learning and sharing knowledge.

## Key Features:
1. **Create Skill Trades**: Users can create a trade offer by offering their skills in exchange for a skill they need, specifying the duration and details of the exchange.
   
2. **Token Rewards**: The provider of the skill is rewarded with **Skill Tokens (SKT)** based on the hours spent in the exchange. The token rate is adjustable by the contract owner.
   
3. **Dispute Resolution**: Both the requester and provider can raise a dispute if there are issues with the trade. A dispute can be raised before the trade is completed and within a specified dispute window (72 hours).
   
4. **Trade Completion**: Only the requester can mark the trade as completed once both parties fulfill the conditions. When the trade is completed, the tokens are minted and awarded to the provider.
   
5. **Maximum Trade Duration**: The trade duration is limited to a maximum of 168 hours (1 week).
   
6. **Non-Reentrancy**: The contract uses the `ReentrancyGuard` to prevent reentrancy attacks and ensures that funds are transferred securely during trades.
   
7. **Token Rate Management**: The contract owner can update the token rate, which defines how many tokens are awarded per hour of service. This allows the platform to adjust the reward system as needed.
   
8. **View User Trades**: Users can view all the trades they are involved in, either as a requester or provider, to track their skill exchanges.


## Future Enhancements:
- **Reputation System**: Implementing a reputation system based on user feedback and successful trade completions could improve trust and ensure quality service.
- **Skill Verification**: Adding a skill verification process would help ensure that the skills being traded are accurate and match the user’s profile.
- **Multi-party Trades**: Expanding the platform to allow multi-party trades, where users can exchange multiple skills simultaneously, would enhance the scope of the platform.
