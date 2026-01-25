;; TimeBank - Time-based skill exchange

(define-map time-balance principal uint)
(define-data-var exchange-counter uint u0)

(define-map exchanges uint {
    provider: principal,
    receiver: principal,
    hours: uint,
    timestamp: uint,
    completed: bool
})

(define-constant ERR-INSUFFICIENT (err u100))

(define-public (earn-time (hours uint))
    (let ((current-balance (default-to u0 (map-get? time-balance tx-sender))))
        (ok (map-set time-balance tx-sender (+ current-balance hours)))))

(define-public (create-exchange (provider principal) (hours uint))
    (let (
        (balance (default-to u0 (map-get? time-balance tx-sender)))
        (exchange-id (var-get exchange-counter)))
        (asserts! (>= balance hours) ERR-INSUFFICIENT)
        (map-set time-balance tx-sender (- balance hours))
        (map-set exchanges exchange-id {
            provider: provider,
            receiver: tx-sender,
            hours: hours,
            timestamp: block-height,
            completed: false
        })
        (var-set exchange-counter (+ exchange-id u1))
        (ok exchange-id)))

(define-public (complete-exchange (exchange-id uint))
    (let ((exchange (unwrap! (map-get? exchanges exchange-id) ERR-INSUFFICIENT)))
        (map-set exchanges exchange-id (merge exchange {completed: true}))
        (let ((provider-balance (default-to u0 (map-get? time-balance (get provider exchange)))))
            (ok (map-set time-balance (get provider exchange) (+ provider-balance (get hours exchange)))))))

(define-read-only (get-balance (user principal))
    (ok (default-to u0 (map-get? time-balance user))))
