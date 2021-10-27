(import-macros co (: ... :gsub "(.*)%.series$" "%1.coroutine"))

(fn fibonacci []
  (co.wrap
    (fn fibonacci-helper [m n]
      (co.yield n)
      (fibonacci-helper n (+ m n)))
    (fibonacci-helper 0 1)))

(fn primes []
  (co.wrap
    (fn prime-step [n divisors]
      (match (. divisors n)
        nil (do
              (co.yield n)
              (tset divisors (* 2 n) [n]))
        n-divs (do
                 (tset divisors n nil)
                 (each [_ div (ipairs n-divs)]
                   (match (. divisors (+ n div))
                     nil (tset divisors (+ n div) [div])
                     further-divs (table.insert further-divs div)))))
      (prime-step (+ 1 n) divisors))
    (prime-step 2 {})))

;(fn primes-noco []
;  (var divisors {})
;  (var n 2)
;  (fn prime-step []
;    (match (. divisors n)
;      nil (do
;            (tset divisors (* 2 n) [n])
;            (set n (+ 1 n))
;            (- n 1))
;      n-divs (do
;               (tset divisors n nil)
;               (each [_ div (ipairs n-divs)]
;                 (match (. divisors (+ n div))
;                   nil (tset divisors (+ n div) [div])
;                   further-divs (table.insert further-divs div)))
;               (set n (+ 1 n))
;               (prime-step)))))

{: fibonacci
; : primes-noco
 : primes}
