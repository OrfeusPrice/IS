(deffacts axts
(A (name "a"))
(A (name "b"))
(A (name "c"))
(A (name "d"))
(A (name "e"))
(A (name "f"))
(A (name "g"))
)

(defrule rule301
(fact(name "t4"))
(not(exists (fact (name "t2"))))
=>
(assert (fact (name "t2")))
(assert (sendmessage "t4 -> t2")))
(defrule rule302
(fact(name "t5"))
(not(exists (fact (name "t2"))))
=>
(assert (fact (name "t2")))
(assert (sendmessage "t5 -> t2")))
(defrule rule303
(fact(name "t6"))
(not(exists (fact (name "t3"))))
=>
(assert (fact (name "t3")))
(assert (sendmessage "t6 -> t3")))
(defrule rule304
(fact(name "t7"))
(not(exists (fact (name "t3"))))
=>
(assert (fact (name "t3")))
(assert (sendmessage "t7 -> t3")))
(defrule rule305
(fact(name "t8"))
(not(exists (fact (name "t4"))))
=>
(assert (fact (name "t4")))
(assert (sendmessage "t8 -> t4")))
(defrule rule306
(fact(name "t3"))
(not(exists (fact (name "t4"))))
=>
(assert (fact (name "t4")))
(assert (sendmessage "t3 -> t4")))
(defrule rule307
(fact(name "c"))
(not(exists (fact (name "t5"))))
=>
(assert (fact (name "t5")))
(assert (sendmessage "c -> t5")))
(defrule rule308
(fact(name "d"))
(not(exists (fact (name "t5"))))
=>
(assert (fact (name "t5")))
(assert (sendmessage "d -> t5")))
(defrule rule309
(fact(name "t2"))
(fact(name "e"))
(not(exists (fact (name "t6"))))
=>
(assert (fact (name "t6")))
(assert (sendmessage "t2, e -> t6")))
(defrule rule3010
(fact(name "f"))
(not(exists (fact (name "t7"))))
=>
(assert (fact (name "t7")))
(assert (sendmessage "f -> t7")))
(defrule rule3011
(fact(name "g"))
(not(exists (fact (name "t7"))))
=>
(assert (fact (name "t7")))
(assert (sendmessage "g -> t7")))
(defrule rule3012
(fact(name "a"))
(fact(name "b"))
(not(exists (fact (name "t8"))))
=>
(assert (fact (name "t8")))
(assert (sendmessage "a, b -> t8")))
(defrule rule3013
(fact(name "t2"))
(fact(name "t3"))
(not(exists (fact (name "t1"))))
=>
(assert (fact (name "t1")))
(assert (sendmessage "t2, t3 -> t1")))
