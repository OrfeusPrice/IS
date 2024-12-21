;========================================================================
; Этот блок реализует логику обмена информацией с графической оболочкой,
; а также механизм остановки и повторного пуска машины вывода
; Русский текст в комментариях разрешён!

(deftemplate ioproxy  ; шаблон факта-посредника для обмена информацией с GUI
	(slot fact-id)        ; теоретически тут id факта для изменения
	(multislot answers)   ; возможные ответы
	(multislot messages)  ; исходящие сообщения
	(slot reaction)       ; возможные ответы пользователя
	(slot value)          ; выбор пользователя
	(slot restore)        ; забыл зачем это поле
)

; Собственно экземпляр факта ioproxy
(deffacts proxy-fact
	(ioproxy
		(fact-id 0112) ; это поле пока что не задействовано
		(value none)   ; значение пустое
		(messages)     ; мультислот messages изначально пуст
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
	?current-message <- (sendmessagehalt $?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(modify ?proxy (messages ?new-msg))
	(retract ?current-message)
	(halt)
)

(deftemplate factc
	(slot fact)
	(slot confidence (type NUMBER))
)


(deftemplate add-fact
	(slot fact)
	(slot confidence (type NUMBER))
)	

(deffunction combine-cf (?cf1 ?cf2)
    (if (and (> ?cf1 0) (> ?cf2 0))
        then
            (return (- (+ ?cf1 ?cf2) (* ?cf1 ?cf2)))
        else
        (if (and (< ?cf1 0) (< ?cf2 0))
            then
                (return (+ (+ ?cf1 ?cf2) (* ?cf1 ?cf2)))
            else
                (return (/ (+ ?cf1 ?cf2) (- 1 (min (abs ?cf1) (abs ?cf2)))))
	)
    )
)

(defrule add_confidence
	(declare (salience 20))
	?f1 <- (factc (fact ?fact) (confidence ?cf1))
	?f2 <- (factc (fact ?fact) (confidence ?cf2))
	(test (neq ?f1 ?f2))
	=>
	(bind ?new-cf (max (min (+ ?cf1 ?cf2) 1.0) -1.0))
	(retract ?f1)
	(retract ?f2)
	(assert (factc (fact ?fact) (confidence ?new-cf)))
	(assert (sendmessagehalt "Повтор факта:" ?fact "Коомбинация: " (str-cat ?new-cf)))
)

(defrule set-fact-and-halt
	(declare (salience 98))
	?proxy <- (add-fact (fact ?fact) (confidence ?confidence))
	=>
	(assert (factc (fact ?fact) (confidence ?confidence)))
	(retract ?proxy)
	(assert (sendmessagehalt "Добавлен факт:" ?fact  (str-cat ?confidence)))
	(halt)
)

;=====================================================================================\
;AX

;(Axiom (name "a"))
;(Axiom (name "b"))
;(Axiom (name "c"))
;(Axiom (name "d"))
;(Axiom (name "e"))
;(Axiom (name "f"))
;(Axiom (name "g"))

(defrule rule301
(declare (salience 3))
(factc (fact "t4") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.96))
(assert (factc (fact "t2") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t2 - " (str-cat ?resc)))
)
(defrule rule302
(declare (salience 3))
(factc (fact "t5") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.8))
(assert (factc (fact "t2") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t2 - " (str-cat ?resc)))
)
(defrule rule303
(declare (salience 3))
(factc (fact "t6") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.76))
(assert (factc (fact "t3") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t3 - " (str-cat ?resc)))
)
(defrule rule304
(declare (salience 3))
(factc (fact "t7") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.75))
(assert (factc (fact "t3") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t3 - " (str-cat ?resc)))
)
(defrule rule305
(declare (salience 3))
(factc (fact "t8") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.91))
(assert (factc (fact "t4") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t4 - " (str-cat ?resc)))
)
(defrule rule306
(declare (salience 3))
(factc (fact "t3") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.8))
(assert (factc (fact "t4") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t4 - " (str-cat ?resc)))
)
(defrule rule307
(declare (salience 3))
(factc (fact "c") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.77))
(assert (factc (fact "t5") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t5 - " (str-cat ?resc)))
)
(defrule rule308
(declare (salience 3))
(factc (fact "d") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.99))
(assert (factc (fact "t5") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t5 - " (str-cat ?resc)))
)
(defrule rule309
(declare (salience 3))
(factc (fact "t2") (confidence ?f1))
(factc (fact "e") (confidence ?f2))
=>
(bind ?minc (min 1.0 ?f2 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.98))
(assert (factc (fact "t6") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t6 - " (str-cat ?resc)))
)
(defrule rule310
(declare (salience 3))
(factc (fact "f") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.61))
(assert (factc (fact "t7") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t7 - " (str-cat ?resc)))
)
(defrule rule311
(declare (salience 3))
(factc (fact "g") (confidence ?f1))
=>
(bind ?minc (min 1.0 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.85))
(assert (factc (fact "t7") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t7 - " (str-cat ?resc)))
)
(defrule rule312
(declare (salience 3))
(factc (fact "a") (confidence ?f1))
(factc (fact "b") (confidence ?f2))
=>
(bind ?minc (min 1.0 ?f2 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.76))
(assert (factc (fact "t8") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t8 - " (str-cat ?resc)))
)
(defrule rule313
(declare (salience 3))
(factc (fact "t2") (confidence ?f1))
(factc (fact "t3") (confidence ?f2))
=>
(bind ?minc (min 1.0 ?f2 ?f1))
(bind ?minc (max 0 ?minc))
(bind ?resc (* ?minc 0.77))
(assert (factc (fact "t1") (confidence ?resc)))
(assert (sendmessagehalt "Выведено: t1 - " (str-cat ?resc)))
)
