import { createPublicClient, createWalletClient, http, type Chain, type Transport } from 'viem'
import { mnemonicToAccount } from 'viem/accounts'
import { arbitrum } from 'viem/chains'

export const client = ({ chain, rpc }: { chain?: Chain; rpc: Transport | string }) =>
	createPublicClient({
		transport: typeof rpc === 'string' ? http(process.env[rpc]) : rpc,
		batch: {
			multicall: true,
		},
		chain,
		cacheTime: 0,
	})
export const arb = client({ chain: arbitrum, rpc: process.env.RPC_ARBITRUM_ALCHEMY! })
export const opt = client({ chain: arbitrum, rpc: process.env.RPC_OPTIMISM_ALCHEMY! })

export const wallet = ({ rpc, chain, env }: { rpc: Transport | string; chain?: Chain; env?: string }) =>
	createWalletClient({
		transport: typeof rpc === 'string' ? http(process.env[rpc]) : rpc,
		chain,
		account: mnemonicToAccount(env ? process.env[env]! : process.env.MNEMONIC!),
		cacheTime: 0,
	})
