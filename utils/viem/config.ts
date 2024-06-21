import { http } from 'viem'

const alchemy = (key: 'arb-mainnet' | 'opt-mainnet' | 'arb-sepolia', checkFork = false) => {
  if (checkFork && process.env.VIEM_FORK) {
    return http(process.env.VIEM_FORK)
  }
  return http(process.env.RPC_ARBITRUM_ALCHEMY)
}

const localhost = http('http://localhost:8545')

export const transports = {
  1: http(),
  1337: localhost,
  421614: alchemy('arb-sepolia'),
  10: alchemy('opt-mainnet'),
  41337: localhost,
  42161: alchemy('arb-mainnet', false),
} as const
