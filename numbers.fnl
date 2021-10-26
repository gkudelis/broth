(fn even? [n] (= 0 (% n 2)))
(fn odd? [n] (not (even? n)))

{: even?
 : odd?}
