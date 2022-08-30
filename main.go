package main

import (
	// GetBlock "eth_crawler/pkg/get_block_data"
	GetLog "eth_crawler/pkg/get_log_data"
	// GetTxPool "eth_crawler/pkg/get_tx_pool"
	// GetTx "eth_crawler/pkg/get_tx"
	// CallContract "eth_crawler/pkg/call_contract"
)

func main() {
	GetLog.Get_log_source_data_main()
	// GetLog.Get_log_source_data_main()
	// GetBlock.Get_block_data_main()
	// GetTxPool.Get_tx_pool_main()
	// GetTx.Get_multi_wallet_tx_main()
	// CallContract.CallContract()

	// GetTx.Get_tx_to_target_contract_main()
}
