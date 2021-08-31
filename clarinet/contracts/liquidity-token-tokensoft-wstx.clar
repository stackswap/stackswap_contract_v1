;; ;; we implement the sip-010 + a mint function
(impl-trait 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.liquidity-token-trait.liquidity-token-trait)

;; ;; we can use an ft-token here, so use it!
(define-fungible-token tokensoft-stx-token)

(define-constant no-acccess-err u40)

;; implement all functions required by sip-010

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (ft-transfer? tokensoft-stx-token amount tx-sender recipient)
  )
)

(define-read-only (get-name)
  (ok "xBTC wSTX liquidity")
)

(define-read-only (get-symbol)
  (ok "xbtc-wstx-liquidity")
)

;; the number of decimals used
(define-read-only (get-decimals)
  (ok u6)  ;; arbitrary, or ok?
)

(define-read-only (get-balance-of (owner principal))
  (ok (ft-get-balance tokensoft-stx-token owner))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply tokensoft-stx-token))
)

(define-read-only (get-token-uri)
  (ok (some u"https://swapr.finance/tokens/tokensoft-stx-token.json"))
)

;; one stop function to gather all the data relevant to the liquidity token in one call
(define-read-only (get-data (owner principal))
  (ok {
    name: (unwrap-panic (get-name)),
    symbol: (unwrap-panic (get-symbol)),
    decimals: (unwrap-panic (get-decimals)),
    uri: (unwrap-panic (get-token-uri)),
    supply: (unwrap-panic (get-total-supply)),
    balance: (unwrap-panic (get-balance-of owner))
  })
)

;; the extra mint method used by STACKSWAP when adding liquidity
;; can only be used by STACKSWAP main contract
(define-public (mint (recipient principal) (amount uint))
  (begin
    (print "token-liquidity.mint")
    (print contract-caller)
    (print amount)
    (asserts! (is-eq contract-caller (unwrap-panic (contract-call? 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-dao get-qualified-name-by-name "swap"))) (err no-acccess-err))
    (ft-mint? tokensoft-stx-token amount recipient)
  )
)


;; the extra burn method used by STACKSWAP when removing liquidity
;; can only be used by STACKSWAP main contract
(define-public (burn (recipient principal) (amount uint))
  (begin
    (print "token-liquidity.burn")
    (print contract-caller)
    (print amount)
    (asserts! (is-eq contract-caller (unwrap-panic (contract-call? 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-dao get-qualified-name-by-name "swap"))) (err no-acccess-err))
    (ft-burn? tokensoft-stx-token amount recipient)
  )
)
