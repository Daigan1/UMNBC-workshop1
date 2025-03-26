output=$(cast wallet list --dir ../wallets)



walletIds=$(echo "$output" | sed 's/ (Local)//g')
wallet_array=($walletIds)


for wallet in "${wallet_array[@]}"; do
    address=$(cast wallet address --keystore ../wallets/${wallet} --password $1)
	echo $address:
	echo $(cast balance --ether --rpc-url  https://rpc-amoy.polygon.technology ${address})
done
