---
title: Bitcoin transactions
parent: Crypto
---

 > [!IMPORTANT]
 > All of the mechanics listed below are automated by most wallets. This is just the underlying logic.


When moving bitcoin around, you are always restricted to spending whole [UTXOs](/posts/utxos) as inputs.

> [!NOTE] Example
> Alice has one UTXO: 1.0BTC
>
> She pays Bob 0.4 BTC
> 
> ````
> Input: UTXO_A = 1.0 BTC (Alice)
> 
> Outputs: 
> 	0.4 BTC -> Bob (new UTXO)
> 	0.5990 BTC -> Alice (change, new UTXO)
> 	fee: 0.001 BTC (implicit, = 1.0 - 0.4 - 0.599)
> ````
> 
> `UTXO_A` is spent (kind of destroyed), and two new UTXOs exist and are unspent. Bob's wallet balance is now whatever UTXOs he holds, including this new 0.4BTC one. If he wants to transfer Carol 0.2BTC, he must spend the whole 0.4BTC UTXO as an input.
> 
> Transaction diagram:
> 
> ````
> UTXO_A (1.0 BTC, Alice)
>         │
>         ▼
>    ┌─────────────┐
>    │     Tx1     │
>    └─────────────┘
>         │
>    ┌────┴────┐
>    ▼         ▼
> 0.4 BTC   0.599 BTC
>  → Bob     → Alice
> (new UTXO) (new UTXO, change)
>    │
>    ▼
> ┌─────────────┐
> │     Tx2     │   (Bob spends his 0.4 BTC UTXO)
> └─────────────┘
>    │
> ┌──┴───┐
> ▼      ▼
> 0.1    0.2999
> →Carol  →Bob
> (new)   (change)
> 
> fee(Tx1) = 1.0 - 0.4 - 0.599 = 0.001 BTC
> fee(Tx2) = 0.4 - 0.1 - 0.2999 = 0.0001 BTC
> ````

# Common transaction forms

* Simple transaction
  * Exactly what's shown in the example above. Alice spends a UTXO into a payment and change. The payment goes to Bob, and the change goes back to Alice.
* Consolidation transaction
  * Where multiple UTXOs are spent on one transaction. Often, the transaction is reflexive (back to the spender), and is done in order to clean up lots of smaller UTXOs.
* Payment batching
  * The inverse of a consolidation transaction. Where one big UTXO is spent on multiple smaller transactions. Often done by commercial entities to distribute funds.

