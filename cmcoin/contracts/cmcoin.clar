(define-fungible-token cmcoin)

(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u101))

(define-data-var token-name (string-ascii 32) "CM Coin")
(define-data-var token-symbol (string-ascii 8) "CMCOIN")
(define-data-var token-decimals uint u6)
(define-data-var total-supply uint u0)
(define-data-var token-owner principal tx-sender)

(define-map allowances
  { owner: principal, spender: principal }
  { amount: uint })

(define-read-only (get-name)
  (ok (var-get token-name)))

(define-read-only (get-symbol)
  (ok (var-get token-symbol)))

(define-read-only (get-decimals)
  (ok (var-get token-decimals)))

(define-read-only (get-balance-of (who principal))
  (ok (ft-get-balance cmcoin who)))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-allowance (owner principal) (spender principal))
  (let
    ((entry (map-get? allowances { owner: owner, spender: spender })))
    (match entry allowance-data (ok (get amount allowance-data)) (ok u0))))

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (if (not (is-eq tx-sender sender))
        ERR-NOT-AUTHORIZED
        (let ((result (ft-transfer? cmcoin amount sender recipient)))
          (match result
            success (ok true)
            error (err error))))))

(define-public (transfer-from (amount uint) (owner principal) (recipient principal))
  (let ((entry (map-get? allowances { owner: owner, spender: tx-sender })))
    (match entry allowance-data
      (let ((current (get amount allowance-data)))
        (if (< current amount)
            ERR-INSUFFICIENT-BALANCE
            (let ((transfer-result (ft-transfer? cmcoin amount owner recipient)))
              (match transfer-result
                success
                  (begin
                    (map-set allowances
                      { owner: owner, spender: tx-sender }
                      { amount: (- current amount) })
                    (ok true))
                error (err error)))))
      ERR-INSUFFICIENT-BALANCE)))

(define-public (approve (spender principal) (amount uint))
  (begin
    (map-set allowances
      { owner: tx-sender, spender: spender }
      { amount: amount })
    (ok true)))

(define-public (mint (amount uint) (recipient principal))
  (begin
    (if (not (is-eq tx-sender (var-get token-owner)))
        ERR-NOT-AUTHORIZED
        (let ((result (ft-mint? cmcoin amount recipient)))
          (match result
            success
              (begin
                (var-set total-supply (+ (var-get total-supply) amount))
                (ok true))
            error (err error))))))

(define-public (burn (amount uint) (owner principal))
  (begin
    (if (not (is-eq tx-sender owner))
        ERR-NOT-AUTHORIZED
        (let ((result (ft-burn? cmcoin amount owner)))
          (match result
            success
              (begin
                (var-set total-supply (- (var-get total-supply) amount))
                (ok true))
            error (err error))))))
