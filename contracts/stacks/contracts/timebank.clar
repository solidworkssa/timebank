;; ────────────────────────────────────────
;; TimeBank v1.0.0
;; Author: solidworkssa
;; License: MIT
;; ────────────────────────────────────────

(define-constant VERSION "1.0.0")

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-ALREADY-EXISTS (err u409))
(define-constant ERR-INVALID-INPUT (err u422))

;; TimeBank Clarity Contract
;; Time-based skill exchange platform.


(define-map credits principal uint)

(define-public (mint (recipient principal) (amount uint))
    (begin
        (map-set credits recipient (+ (default-to u0 (map-get? credits recipient)) amount))
        (ok true)
    )
)

(define-public (transfer (recipient principal) (amount uint))
    (let ((balance (default-to u0 (map-get? credits tx-sender))))
        (asserts! (>= balance amount) (err u100))
        (map-set credits tx-sender (- balance amount))
        (map-set credits recipient (+ (default-to u0 (map-get? credits recipient)) amount))
        (ok true)
    )
)

