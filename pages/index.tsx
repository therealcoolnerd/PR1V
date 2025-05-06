import { ConnectButton } from '../components/ConnectButton';

export default function Home(){
  return (
    <main className="min-h-screen flex flex-col items-center justify-center gap-6">
      <h1 className="text-4xl">PR1V Wallet Connect Demo</h1>
      <ConnectButton/>
    </main>
  )
}
