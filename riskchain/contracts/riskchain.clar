;; Decentralized Insurance Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-claim (err u101))
(define-constant err-insufficient-payment (err u102))
(define-constant err-not-insured (err u103))
(define-constant err-invalid-params (err u104))
(define-constant max-coverage u1000000000) ;; Maximum coverage amount
(define-constant max-duration u52560) ;; Maximum duration (about 1 year in blocks)
(define-constant min-premium u1000) ;; Minimum premium amount

;; Data Maps
(define-map insurance-policies
    principal
    {
        coverage-amount: uint,
        premium: uint,
        expiration: uint
    })

(define-map insurance-claims
    principal
    {
        amount: uint, 
        status: bool
    })

;; Variables
(define-data-var insurance-fund uint u0)

;; Admin Functions
(define-public (create-policy (coverage-amount uint) (premium uint) (duration uint))
    (let ((expiration (+ block-height duration)))
        (begin
            (asserts! (is-eq tx-sender contract-owner) err-owner-only)
            (asserts! (<= coverage-amount max-coverage) err-invalid-params)
            (asserts! (>= premium min-premium) err-invalid-params)
            (asserts! (<= duration max-duration) err-invalid-params)
            (map-set insurance-policies tx-sender
                {
                    coverage-amount: coverage-amount,
                    premium: premium,
                    expiration: expiration
                })
            (ok true))))

;; User Functions
(define-public (purchase-policy (coverage-amount uint) (duration uint))
    (let 
        ((policy-premium (* coverage-amount (/ u1 u100) duration))
         (expiration (+ block-height duration)))
        (begin
            (asserts! (<= coverage-amount max-coverage) err-invalid-params)
            (asserts! (<= duration max-duration) err-invalid-params)
            (asserts! (>= policy-premium min-premium) err-invalid-params)
            
            ;; Safe arithmetic operations with checks
            (asserts! (>= (+ (var-get insurance-fund) policy-premium) 
                         (var-get insurance-fund)) 
                     err-invalid-params)
            
            (try! (stx-transfer? policy-premium tx-sender (as-contract tx-sender)))
            (var-set insurance-fund (+ (var-get insurance-fund) policy-premium))
            (map-set insurance-policies tx-sender
                {
                    coverage-amount: coverage-amount,
                    premium: policy-premium,
                    expiration: expiration
                })
            (ok true))))

(define-public (file-claim (amount uint))
    (let 
        ((policy (unwrap! (map-get? insurance-policies tx-sender) (err err-not-insured))))
        (begin
            (asserts! (<= amount (get coverage-amount policy)) (err err-invalid-claim))
            (asserts! (is-ok (as-contract (stx-transfer? amount tx-sender tx-sender))) (err err-insufficient-payment))
            (var-set insurance-fund (- (var-get insurance-fund) amount))
            (map-set insurance-claims tx-sender
                {
                    amount: amount,
                    status: true
                })
            (ok true))))

;; Read-Only Functions
(define-read-only (get-policy-details (owner principal))
    (map-get? insurance-policies owner))

(define-read-only (get-claim-details (claimant principal))
    (map-get? insurance-claims claimant))

(define-read-only (get-fund-balance)
    (var-get insurance-fund))