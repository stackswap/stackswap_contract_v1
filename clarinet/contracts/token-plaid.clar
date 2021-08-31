;; wrap the native STX token into an SRC20 compatible token to be usable along other tokens
(impl-trait 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.sip-010-trait.ft-trait)

(define-fungible-token plaid)

;; get the token balance of owner
(define-read-only (get-balance-of (owner principal))
  (ok (ft-get-balance plaid owner))
)

;; returns the total number of tokens
;; TODO(psq): we don't have access yet, but once POX is available, this should be a value that
;; is available from Clarity
(define-read-only (get-total-supply)
  (ok (ft-get-supply plaid))
)

;; returns the token name
(define-read-only (get-name)
  (ok "Plaid")
)

(define-read-only (get-symbol)
  (ok "PLD")
)

;; the number of decimals used
(define-read-only (get-decimals)
  (ok u8)  ;; because we can, and interesting for testing wallets and other clients
)

(define-read-only (get-token-uri)
  (ok (some u"https://swapr.finance/tokens/plaid.json"))
)



(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (print "plaid.transfer")
    (print amount)
    (print tx-sender)
    (print recipient)
    (asserts! (is-eq tx-sender sender) (err u255)) ;; too strict?
    (print (ft-transfer? plaid amount tx-sender recipient))
  )
)


(ft-mint? plaid u100000000000000 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE)
(ft-mint? plaid u100000000000000 'ST2SVRCJJD90TER037VCSAFA781HQTCPFK9YRA6J5)
(ft-mint? plaid u10000000000000 'ST20ATRN26N9P05V2F1RHFRV24X8C8M3W54E427B2)
