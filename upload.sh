echo "Cleanup..."
rm -f new-contract-query.boc
# rm -f contract.pk

echo "Building..."
func-build contract || exit 1

output=`fift-run new-contract.fif` || (echo "$output" && exit 2)
echo "$output"
initAddress=`echo "$output" | grep "Non-bounceable address (for init):" | awk '{print $5}'`
address=`echo "$output" | grep "Bounceable address:" | awk '{print $3}'`

echo "Send funds"
# 0.05 - 0.015967997 (after init balance) = ~0.034 grams for init
amount=0.5
send-funds my-wallet-v2 $initAddress $amount || exit 3
watch-wallet-until-create $initAddress || exit 4

echo "Address has funds. Wait 10 sec..."
sleep 10

echo "Uploading..."
run-lite-client sendfile $PWD/new-contract-query.boc

watch-wallet-until-init $address || exit 6

echo "DONE!"
