import { useAccount, useConnect, useDisconnect } from 'wagmi';

export const ConnectButton = () => {
  const { address } = useAccount();
  const { connectors, connect, isPending } = useConnect();
  const { disconnect } = useDisconnect();

  return (
    <div className="space-x-2">
      {address ? (
        <button onClick={() => disconnect()} className="underline">
          Disconnect ({address.slice(0, 6)}…{address.slice(-4)})
        </button>
      ) : (
        connectors.map((c) => (
          <button
            key={c.uid}
            disabled={!c.ready || isPending}
            onClick={() => connect({ connector: c })}
            className="underline"
          >
            {c.name}
          </button>
        ))
      )}
    </div>
  );
};
