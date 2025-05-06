import '@/styles/globals.css';
import type { AppProps } from 'next/app';
import { WagmiProvider, createConfig, http } from 'wagmi';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { mainnet, sepolia } from 'wagmi/chains';
import { metaMask } from 'wagmi/connectors';

const INFURA=process.env.NEXT_PUBLIC_INFURA_KEY||'';

const config=createConfig({
  ssr:true,
  chains:[mainnet,sepolia],
  connectors:[metaMask()],
  transports:{
    [mainnet.id]:http(`https://mainnet.infura.io/v3/${INFURA}`),
    [sepolia.id]:http(`https://sepolia.infura.io/v3/${INFURA}`)
  }
});
const queryClient=new QueryClient();

export default function App({Component,pageProps}:AppProps){
  return(
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <Component {...pageProps}/>
      </QueryClientProvider>
    </WagmiProvider>
  );
}
