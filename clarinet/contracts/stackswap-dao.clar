(define-constant ERR_NOT_AUTHORIZED u4104)

(define-map contracts
  (string-ascii 256)
  {
    address: principal, 
    qualified-name: principal 
  }
)


(begin
  
  (map-set contracts
    "governance"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-governance-v1
    }
  )

  (map-set contracts
    "swap"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-swap-v1
    }
  )

  (map-set contracts
    "one-step-mint"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-one-step-mint-v1
    }
  )

  (map-set contracts
    "lp-deployer"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE
    }
  )

  (map-set contracts
    "farm-adder"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE
    }
  )

  (map-set contracts
    "staking"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-staking-v1
    }
  )

  (map-set contracts
    "oracle-l"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-oracle-v1-1
    }
  )

  (map-set contracts
    "mortgager-l"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-mortgager-v1-1
    }
  )

  (map-set contracts
    "stx-reserve-l"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-stx-reserve-v1-1
    }
  )

  (map-set contracts
    "sip10-reserve-l"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-sip10-reserve-v1-1
    }
  )

  (map-set contracts
    "stacker-l"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-stacker-v1-1
    }
  )
  (map-set contracts
    "stacker-l-2"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-stacker-2-v1-1
    }
  )
  (map-set contracts
    "stacker-l-3"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-stacker-3-v1-1
    }
  )
  (map-set contracts
    "stacker-l-4"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-stacker-4-v1-1
    }
  )

  (map-set contracts
    "collateral-types-l"
    {
      address: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE,
      qualified-name: 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-collateral-types-v1-1
    }
  )
)


(define-data-var dao-owner principal tx-sender)
(define-data-var payout-address principal (var-get dao-owner)) 

(define-read-only (get-dao-owner)
  (var-get dao-owner)
)

(define-read-only (get-payout-address)
  (var-get payout-address)
)

(define-public (set-dao-owner (address principal))
  (begin
    (asserts! (is-eq contract-caller (var-get dao-owner)) (err ERR_NOT_AUTHORIZED))
    (ok (var-set dao-owner address))
  )
)

(define-public (set-payout-address (address principal))
  (begin
    (asserts! (is-eq contract-caller (var-get dao-owner)) (err ERR_NOT_AUTHORIZED))
    (ok (var-set payout-address address))
  )
)

(define-read-only (get-contract-address-by-name (name (string-ascii 256)))
  (get address (map-get? contracts name))
)

(define-read-only (get-qualified-name-by-name (name (string-ascii 256)))
  (get qualified-name (map-get? contracts name))
)

(define-public (set-contract-address (name (string-ascii 256)) (address principal) (qualified-name principal))
  (let (
    (current-contract (map-get? contracts name))
  )
    (asserts! 
      (or 
        (is-eq (unwrap-panic (get-qualified-name-by-name "governance")) contract-caller)
        (is-eq (as-contract tx-sender) contract-caller)
      )
      (err ERR_NOT_AUTHORIZED))
    (map-set contracts name { address: address, qualified-name: qualified-name })
    (ok true)

  )
)

(define-public (execute-proposals (contract-changes 
      (list 10 (tuple (name (string-ascii 256)) (address principal) (qualified-name principal)))))
    (begin 
      (asserts! (is-eq (unwrap-panic (get-qualified-name-by-name "governance")) contract-caller) (err ERR_NOT_AUTHORIZED))
      (map execute-proposal-change-contract contract-changes)
    (ok true)
  )
)

(define-private (execute-proposal-change-contract (change (tuple (name (string-ascii 256)) (address principal) (qualified-name principal))))
  (let (
    (name (get name change))
    (address (get address change))
    (qualified-name (get qualified-name change))
  )
    (if (not (is-eq name ""))
      (begin
        (try! (set-contract-address name address qualified-name))
        (ok true)
      )
      (ok false)
    )
  )
)

