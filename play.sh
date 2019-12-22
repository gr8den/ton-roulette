# 5.26% house edge for American

# CONTRACT="kQDpgasejCQgh7pdtEq2WJw9RMyKcQ2RPpK_qdJaBEX3LT-m" # has stats
# gas_used:(var_uint len:2 value:13245
# bet is 0.1 at odd
# on lost:
# Fees: -.016931026000000 (-16.93102600000000000000 %)
# on win:
# Fees: -.019706023000000 (-19.70602300000000000000 %)

# CONTRACT="kQCjZLiTT4tuvC05S3aKiDrs7ihOEvfWFuNK2bKA1DL-a-fh" # no stats
# gas_used:(var_uint len:2 value:8723)
# bet is 0.1 at odd
# on lost:
# Fees: -.01180708000000102 (-11.80708000000102000000 %)
# on win:
# Fees: -.01518402300000004 (-15.18402300000004000000 %)

# win 1 at odd - Fees: -.015364026 (-1.53640260000000000000 %)
# loss 1 at event - Fees: -.011987033000002 (-1.19870330000020000000 %)
# Contract balance after:
# 6.438493753 | delta: .993373969
# 100 - (.993373969 / 1 * 100) = 0.6626030999999983 %

# CONTRACT="kQDQz448SBawB1tobm4Mded2nzJMcNT8ih8JTy6GyWDL7Klj" # no stats + optimizations
# 0.1 at odd
# gas_used:(var_uint len:2 value:5543) 0.005543 gram
# You LOST :(
# Contract balance after:
# 0.167957764 | delta: .094456938
# Wallet balance after:
# 20.057314139000002 | delta: -.105361003999998
# Fees: -.010904065999998 (-10.90406599999800000000 %)
# You LOST :(
# Contract balance after:
# 0.264491582 | delta: .096533818
# Wallet balance after:
# 19.951953126000003 | delta: -.105361012999999
# Fees: -.008827194999999 (-8.82719499999900000000 %)
# You WIN :)
# Contract balance after:
# 0.261025473 | delta: -.100000029
# Wallet balance after:
# 19.934588116 | delta: .087995996
# Fees: -.012004033 (-12.00403300000000000000 %)

# 1.0 at black
# You WIN :)
# Wait for TX with prize from Smart Contract..... OK
# Contract balance after:
# 9.059557172 | delta: -1.000000031
# Wallet balance after:
# 21.096832093 | delta: .986251997
# Fees: -.013748034 (-1.37480340000000000000 %)

CONTRACT="kQCEZbJF3x0xF2d9T1TLfR4Y0nB8jSiQKH6dc1J-WjKIGcLk"

WALLET="my-wallet-v2"
BET="black"
AMOUNT="1"
SLEEP="1"

CONTRACT_BALANCE_BEFORE=`get-balance $CONTRACT`
echo "Contract balance before: "
echo $CONTRACT_BALANCE_BEFORE

WALLET_BALANCE_BEFORE=`wallet-balance $WALLET`
echo "Wallet balance before: "
echo $WALLET_BALANCE_BEFORE


echo "Bet GR\$${AMOUNT} at $BET"
fift-run play.fif $BET > /dev/null || exit 1
send-funds $WALLET $CONTRACT $AMOUNT play-query.boc > /dev/null


# echo "Sleep $SLEEP sec..."
# sleep $SLEEP

printf "Wait for sending player query"
WALLET_BALANCE_AFTER0=`wallet-balance $WALLET`
while [[ $WALLET_BALANCE_AFTER0 = $WALLET_BALANCE_BEFORE ]];
do
  printf "."
  sleep $SLEEP
  WALLET_BALANCE_AFTER0=`wallet-balance $WALLET`
done
echo " OK"

printf "Wait for Smart Contract processing"
CONTRACT_BALANCE_AFTER=`get-balance $CONTRACT`
while [[ $CONTRACT_BALANCE_AFTER = $CONTRACT_BALANCE_BEFORE ]];
do
  printf "."
  sleep $SLEEP
  CONTRACT_BALANCE_AFTER=`get-balance $CONTRACT`
done
echo " OK"


CONTRACT_DELTA=`echo "$CONTRACT_BALANCE_AFTER - $CONTRACT_BALANCE_BEFORE" | bc`
IS_WIN=`echo "$CONTRACT_DELTA < 0" | bc`

if [[ 1 -eq $IS_WIN ]]; then
  echo "You WIN :)"

  printf "Wait for TX with prize from Smart Contract"
  WALLET_BALANCE_AFTER=`wallet-balance $WALLET`
  while [[ $WALLET_BALANCE_AFTER = $WALLET_BALANCE_AFTER0 ]];
  do
    printf "."
    sleep $SLEEP
    WALLET_BALANCE_AFTER=`wallet-balance $WALLET`
  done
  echo " OK"  
else # lost
  WALLET_BALANCE_AFTER=$WALLET_BALANCE_AFTER0
  echo "You LOST :("
fi


echo "Contract balance after: "
echo "$CONTRACT_BALANCE_AFTER | delta: $CONTRACT_DELTA"

WALLET_DELTA=`echo "$WALLET_BALANCE_AFTER - $WALLET_BALANCE_BEFORE" | bc`
echo "Wallet balance after: "
echo "$WALLET_BALANCE_AFTER | delta: $WALLET_DELTA"

FEES=`echo "$CONTRACT_DELTA + $WALLET_DELTA" | bc`
FEES_PERCENT=`echo "$FEES / $AMOUNT * 100.0" | bc -l`
echo "Fees: $FEES ($FEES_PERCENT %)"
