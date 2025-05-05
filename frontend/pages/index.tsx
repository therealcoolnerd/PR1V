import { useConnect, useAccount, useDisconnect } from 'wagmi';

export default function Home() {
  const { connect, connectors } = useConnect();
  const { address, isConnected } = useAccount();
  const { disconnect } = useDisconnect();

  return (
    <div>
      <h1>Priv - Privacy Suite</h1>
      {/* TODO: Implement wallet connect UI and feature cards */}
    </div>
  );
}
