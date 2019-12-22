# TON American Roulette

TON Smart Contract for American Roulette (can be easy converted to European)

## Smart contract address in testnet2
`kQCEZbJF3x0xF2d9T1TLfR4Y0nB8jSiQKH6dc1J-WjKIGcLk`

Min bet: 1 GRAM

Max bet: 100.0 GRAM

## Instruction for player

0. Fift and lite-client must be installed
1. Create wallet

    `./wallet-v2/new-wallet-v2.fif 0`

    Send inital amount (eg. 1 gram) to Non-bounceable address

    Send `new-wallet-query.boc` using lite-client

2. Create play query (eg. to red): 

    `./play.fif red`

    List all avaliable types of bets listed below

3. Create money send order with play query

    `./wallet-v2/wallet-v2.fif new-wallet kQCEZbJF3x0xF2d9T1TLfR4Y0nB8jSiQKH6dc1J-WjKIGcLk <seqno> <amount> -B play-query.boc`

4. Send `wallet-query.boc` using lite-client

5. Check wallet balance after ~40 sec

## Available types of bets:

| bet         | description | Payout |
|-------------|-------------|--------|
| straight N  | Bet on a single number N. N must be any in range 0 to 36 or 00 | 35 to 1
| 1st_dozen   | Bet on any number in range 1 - 12   | 2 to 1 |
| 2st_dozen   | Bet on any number in range 13 - 24  | 2 to 1 |
| 3st_dozen   | Bet on any number in range 25 - 36  | 2 to 1 |
| odd         | Bet on any odd number   | 1 to 1 |
| even        | Bet on any even number  | 1 to 1 |
| red         | Bet on any red number   | 1 to 1 |
| black       | Bet on any black number | 1 to 1 |
| 1to18       | Bet on any number in range 1 - 18   | 1 to 1 |
| 19to36      | Bet on any number in range 19 - 36  | 1 to 1 |

## Instruction if you want create own roulette contract:

1. ### Build contract (optional)

   `func-build contract`

1. ### Create contract

    Create new contract query: `./new-contract.fif`

    Send inital amount eg. 1 gram to Non-bounceable address

    Send new contract query 

1. ### Configure min & max bet
    `./admin-configure.fif <minBet> <maxBet> <seqno> <addr> [contract.pk]`
    
    Default min: 1 gram, max: 1000 gram

1. ### Send prize found by simple money transfer

1. ### Withdraw

    You can withdraw money from contract using `./admin-withdraw.fif <withdraw-to-addr> <amount> <seqno> <contract-addr> [contract.pk]`


## If you want use debug .sh scripts you may required install some path variables

  ```bash
  export TON="/Users/my-user/ton"
  export TON_SRC="$TON/ton"
  export TON_BUILD="$TON/ton-build"
  export PATH="$TON/bin:$TON_BUILD/crypto:$PATH"
  export FIFTPATH="$TON_SRC/crypto/fift/lib"
  ```

  `bin/` folder from this repo must be in `$TON/` folder


## PS. My TVM bug fixes:

Opcodes BALANCE & RANDSEED:
https://github.com/ton-blockchain/ton/pull/211
