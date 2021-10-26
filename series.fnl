(import-macros co (: ... :gsub "(.*)%.series$" "%1.coroutine"))

(fn fibonacci []
  (co.wrap
    (fn fibonacci-helper [m n]
      (co.yield n)
      (fibonacci-helper n (+ m n)))
    (fibonacci-helper 0 1)))

{: fibonacci}
