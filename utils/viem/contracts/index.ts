import { erc20Abi } from 'viem'

export const addr = {
	safe: '0x266489Bde85ff0dfe1ebF9f0a7e6Fed3a973cEc3',
	pythEP: '0xff1a0f4744e8582DF1aE09D5611b887B6a12925C',
	krSOL: '0x96084d2E3389B85f2Dc89E321Aaa3692Aed05eD2',
	krJPY: '0xc4fEE1b0483eF73352447b1357adD351Bfddae77',
	krBTC: '0x11EF4EcF3ff1c8dB291bc3259f3A4aAC6e4d2325',
	krEUR: '0x83BB68a7437b02ebBe1ab2A0E8B464CC5510Aafe',
	krGBP: '0xdb274afDfA7f395ef73ab98C18cDf3D9C03b538C',
	krXAU: '0xe0A49C9215206f9cfb79981901bDF1f2716d3215',
	krETH: '0x24dDC92AA342e92f26b4A676568D04d2E3Ea0abc',
	akrETH: '0x3103570A28ca026e818c79608F1FF804F4Bde284',
	Data: '0xef5196c4bDd74356943dcC20A7d27eAdD0F9b9D7',
	DAI: '0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1',
	KISS: '0x6A1D6D2f4aF6915e6bBa8F2db46F442d18dB5C9b',
	GatingManager: '0x13f14aB44B434F16D88645301515C899d69A30Bd',
	MarketStatus: '0xf6188e085ebEB716a730F8ecd342513e72C8AD04',
	Factory: '0x000000000070AB95211e32fdA3B706589D3482D5',
	Kresko: '0x0000000000177abD99485DCaea3eFaa91db3fe72',
	Multicall: '0xC35A7648B434f0A161c12BD144866bdf93c4a4FC',
	USDC: '0xaf88d065e77c8cC2239327C5EDb3A432268e5831',
	'USDC.e': '0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8',
	Vault: '0x2dF01c1e472eaF880e3520C456b9078A5658b04c',
	WBTC: '0x2f2a2543B76A4166549F7aaB2e75Bef0aefC5B0f',
	WETH: '0x82aF49447D8a07e3bd95BD0d56f35241523fBab1',
	qfk: '0x1C04925779805f2dF7BbD0433ABE92Ea74829bF6',
	kreskian: '0xAbDb949a18d27367118573A217E5353EDe5A0f1E',
	kredits: '0x8E84a3B8e0b074c149b8277c753Dc6396bB95F48',
	wNative: '0x82aF49447D8a07e3bd95BD0d56f35241523fBab1',
} as const

export const tokenConfig = (asset: keyof typeof addr) => {
	return {
		abi: erc20Abi,
		addr: addr[asset],
	}
}
