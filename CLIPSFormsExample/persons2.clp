;========================================================================
; Этот блок реализует логику обмена информацией с графической оболочкой,
; а также механизм остановки и повторного пуска машины вывода
; Русский текст в комментариях разрешён!

(deftemplate ioproxy  ; шаблон факта-посредника для обмена информацией с GUI
	(slot Fact-id)        ; теоретически тут id факта для изменения
	(multislot answers)   ; возможные ответы
	(multislot messages)  ; исходящие сообщения
	(slot reaction)       ; возможные ответы пользователя
	(slot value)          ; выбор пользователя
	(slot restore)        ; забыл зачем это поле
)

; Собственно экземпляр факта ioproxy
(deffacts proxy-Fact
	(ioproxy
		(Fact-id 0112) ; это поле пока что не задействовано
		(value none)   ; значение пустое
		(messages)     ; мультислот messages изначально пуст
		(answers)
	)
)

(defrule clear-messages
	(declare (salience 90))
	?clear-msg-flg <- (clearmessage)
	?proxy <- (ioproxy)
	=>
	(modify ?proxy (messages))
	(retract ?clear-msg-flg)
	(printout t "Messages cleared ..." crlf)
)

(defrule set-output-and-halt
	(declare (salience 99))
	?current-message <- (sendmessagehalt ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(printout t "Message set : " ?new-msg " ... halting ..." crlf)
	(modify ?proxy (messages ?new-msg))
	(retract ?current-message)
	(halt)
)

(defrule set-output-and-proceed
	(declare (salience 100))
	?current-message <- (sendmessage ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(printout t "Message set : " ?new-msg " ... halting ..." crlf)
	(modify ?proxy (messages $?msg-list ?new-msg))
	(retract ?current-message)
)

(deftemplate answer
    (slot value)
    (slot type)
)

(defrule set-answer-and-halt
    (declare (salience 102))
    ?a <- (answer (value ?val))
    ?proxy <- (ioproxy)
    =>
    (modify ?proxy (answers ?val))
    (retract ?a)
    (halt)
)

(defrule clear-answers
    (declare (salience 101))
    ?proxy <- (ioproxy (answers $?answer-list&:(not(eq(length$ ?answer-list) 0))))
    =>
    (modify ?proxy (answers))
)

;======================================================================================
(deftemplate Input
	(multislot name)
)
(deftemplate Axiom
	(multislot name)
)
(deftemplate Fact
    (multislot name)
)

(defrule match-facts
	(declare (salience 9))
	(Axiom (name ?val))
	?a <- (Input (name ?n&?val))
	=>
	(retract ?a)
	(assert (Fact (name ?val)))
)

;=====================================================================================\
;AX

(deffacts axts
(Axiom (name "a"))
(Axiom (name "b"))
(Axiom (name "c"))
(Axiom (name "d"))
(Axiom (name "e"))
(Axiom (name "f"))
(Axiom (name "g"))
)

(defrule rule301
(Fact(name "t4"))
(not(exists (Fact (name "t2"))))
=>
(assert (Fact (name "t2")))
(assert (sendmessage "t4 -> t2")))
(defrule rule302
(Fact(name "t5"))
(not(exists (Fact (name "t2"))))
=>
(assert (Fact (name "t2")))
(assert (sendmessage "t5 -> t2")))
(defrule rule303
(Fact(name "t6"))
(not(exists (Fact (name "t3"))))
=>
(assert (Fact (name "t3")))
(assert (sendmessage "t6 -> t3")))
(defrule rule304
(Fact(name "t7"))
(not(exists (Fact (name "t3"))))
=>
(assert (Fact (name "t3")))
(assert (sendmessage "t7 -> t3")))
(defrule rule305
(Fact(name "t8"))
(not(exists (Fact (name "t4"))))
=>
(assert (Fact (name "t4")))
(assert (sendmessage "t8 -> t4")))
(defrule rule306
(Fact(name "t3"))
(not(exists (Fact (name "t4"))))
=>
(assert (Fact (name "t4")))
(assert (sendmessage "t3 -> t4")))
(defrule rule307
(Fact(name "c"))
(not(exists (Fact (name "t5"))))
=>
(assert (Fact (name "t5")))
(assert (sendmessage "c -> t5")))
(defrule rule308
(Fact(name "d"))
(not(exists (Fact (name "t5"))))
=>
(assert (Fact (name "t5")))
(assert (sendmessage "d -> t5")))
(defrule rule309
(Fact(name "t2"))
(Fact(name "e"))
(not(exists (Fact (name "t6"))))
=>
(assert (Fact (name "t6")))
(assert (sendmessage "t2, e -> t6")))
(defrule rule3010
(Fact(name "f"))
(not(exists (Fact (name "t7"))))
=>
(assert (Fact (name "t7")))
(assert (sendmessage "f -> t7")))
(defrule rule3011
(Fact(name "g"))
(not(exists (Fact (name "t7"))))
=>
(assert (Fact (name "t7")))
(assert (sendmessage "g -> t7")))
(defrule rule3012
(Fact(name "a"))
(Fact(name "b"))
(not(exists (Fact (name "t8"))))
=>
(assert (Fact (name "t8")))
(assert (sendmessage "a, b -> t8")))
(defrule rule3013
(Fact(name "t2"))
(Fact(name "t3"))
(not(exists (Fact (name "t1"))))
=>
(assert (Fact (name "t1")))
(assert (sendmessage "t2, t3 -> t1")))
