;========================================================================
; Этот блок реализует логику обмена информацией с графической оболочкой,
; а также механизм остановки и повторного пуска машины вывода
; Русский текст в комментариях разрешён!

(deftemplate ioproxy  ; шаблон факта-посредника для обмена информацией с GUI
	(slot fact-id)        ; теоретически тут id факта для изменения
	(multislot questions)   ; возможные ответы
	(multislot messages)  ; исходящие сообщения
	(slot reaction)       ; возможные ответы пользователя
	(slot value)          ; выбор пользователя
	(slot restore)        ; забыл зачем это поле
        (multislot answers)
)

; Собственно экземпляр факта ioproxy
(deffacts proxy-fact
	(ioproxy
		(fact-id 0112) ; это поле пока что не задействовано
		(value none)   ; значение пустое
		(messages)     ; мультислот messages изначально пуст
		(questions)
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

(deftemplate question
    (slot value)
    (slot type)
)

(defrule set-question-and-halt
    (declare (salience 102))
    ?q <- (question (value ?val))
    ?proxy <- (ioproxy)
    =>
    (modify ?proxy (questions ?val))
    (retract ?q)
    (halt)
)

(defrule clear-questions
    (declare (salience 101))
    ?proxy <- (ioproxy (questions $?question-list&:(not(eq(length$ ?question-list) 0))))
    =>
    (modify ?proxy (questions))
)

;======================================================================================
(deftemplate input-question
	(multislot name)
)
(deftemplate A
	(multislot name)
)
(deftemplate fact
    (multislot name)
)

(deftemplate target
    (multislot name)
)

(defrule match-facts
	(declare (salience 9))
	(A (name ?val))
	?q <- (input-question (name ?n&?val))
	=>
	(retract ?q)
	(assert (fact (name ?val)))
)

;=====================================================================================

(deffacts axioms
(A (name "Короткие серии"))
(A (name "Средние серии"))
(A (name "Долгие серии"))
(A (name "Русский"))
(A (name "СССР"))
(A (name "США"))
(A (name "Великобритания"))
(A (name "Турция"))
(A (name "Повседневность"))
(A (name "Смешной"))
(A (name "Весёлый"))
(A (name "Магия"))
(A (name "Драконы"))
(A (name "Эпический"))
(A (name "Динамичный"))
(A (name "Захватывающий"))
(A (name "Необычный"))
(A (name "Серьёзный"))
(A (name "Напряжённый"))
(A (name "Страшный"))
(A (name "Чувственный"))
(A (name "Трогательный"))
(A (name "Про любовь"))
(A (name "Грустный"))
(A (name "Трагический"))
(A (name "Про преступников"))
(A (name "Расследование"))
(A (name "Про докторов"))
(A (name "Спинофф"))
)

(defrule rule1
(fact(name "Короткие серии"))
(not(exists (fact (name "Серии по 20 минут"))))
=>
(assert (fact (name "Серии по 20 минут")))
(assert (sendmessage "Короткие серии -> Серии по 20 минут")))
(defrule rule2
(fact(name "Средние серии"))
(not(exists (fact (name "Серии по 40 минут"))))
=>
(assert (fact (name "Серии по 40 минут")))
(assert (sendmessage "Средние серии -> Серии по 40 минут")))
(defrule rule3
(fact(name "Долгие серии"))
(not(exists (fact (name "Серии по 60 минут"))))
=>
(assert (fact (name "Серии по 60 минут")))
(assert (sendmessage "Долгие серии -> Серии по 60 минут")))
(defrule rule4
(fact(name "Русский"))
(not(exists (fact (name "Отечественный"))))
=>
(assert (fact (name "Отечественный")))
(assert (sendmessage "Русский -> Отечественный")))
(defrule rule5
(fact(name "СССР"))
(not(exists (fact (name "Отечественный"))))
=>
(assert (fact (name "Отечественный")))
(assert (sendmessage "СССР -> Отечественный")))
(defrule rule6
(fact(name "США"))
(not(exists (fact (name "Иностранный"))))
=>
(assert (fact (name "Иностранный")))
(assert (sendmessage "США -> Иностранный")))
(defrule rule7
(fact(name "Великобритания"))
(not(exists (fact (name "Иностранный"))))
=>
(assert (fact (name "Иностранный")))
(assert (sendmessage "Великобритания -> Иностранный")))
(defrule rule8
(fact(name "Повседневность"))
(fact(name "Комедия"))
(not(exists (fact (name "Ситком"))))
=>
(assert (fact (name "Ситком")))
(assert (sendmessage "Повседневность, Комедия -> Ситком")))
(defrule rule9
(fact(name "Смешной"))
(not(exists (fact (name "Комедия"))))
=>
(assert (fact (name "Комедия")))
(assert (sendmessage "Смешной -> Комедия")))
(defrule rule10
(fact(name "Весёлый"))
(not(exists (fact (name "Комедия"))))
=>
(assert (fact (name "Комедия")))
(assert (sendmessage "Весёлый -> Комедия")))
(defrule rule11
(fact(name "Магия"))
(not(exists (fact (name "Волшебный"))))
=>
(assert (fact (name "Волшебный")))
(assert (sendmessage "Магия -> Волшебный")))
(defrule rule12
(fact(name "Драконы"))
(not(exists (fact (name "Мифологический"))))
=>
(assert (fact (name "Мифологический")))
(assert (sendmessage "Драконы -> Мифологический")))
(defrule rule13
(fact(name "Эпический"))
(fact(name "Динамичный"))
(fact(name "Захватывающий"))
(not(exists (fact (name "Боевик"))))
=>
(assert (fact (name "Боевик")))
(assert (sendmessage "Эпический, Динамичный, Захватывающий -> Боевик")))
(defrule rule14
(fact(name "Динамичный"))
(fact(name "Захватывающий"))
(not(exists (fact (name "Приключения"))))
=>
(assert (fact (name "Приключения")))
(assert (sendmessage "Динамичный, Захватывающий -> Приключения")))
(defrule rule15
(fact(name "Захватывающий"))
(fact(name "Необычный"))
(not(exists (fact (name "Фантастика"))))
=>
(assert (fact (name "Фантастика")))
(assert (sendmessage "Захватывающий, Необычный -> Фантастика")))
(defrule rule16
(fact(name "Серьёзный"))
(fact(name "Напряжённый"))
(not(exists (fact (name "Триллер"))))
=>
(assert (fact (name "Триллер")))
(assert (sendmessage "Серьёзный, Напряжённый -> Триллер")))
(defrule rule17
(fact(name "Напряжённый"))
(fact(name "Страшный"))
(not(exists (fact (name "Ужасы"))))
=>
(assert (fact (name "Ужасы")))
(assert (sendmessage "Напряжённый, Страшный -> Ужасы")))
(defrule rule18
(fact(name "Чувственный"))
(not(exists (fact (name "Мелодрама"))))
=>
(assert (fact (name "Мелодрама")))
(assert (sendmessage "Чувственный -> Мелодрама")))
(defrule rule19
(fact(name "Трогательный"))
(not(exists (fact (name "Мелодрама"))))
=>
(assert (fact (name "Мелодрама")))
(assert (sendmessage "Трогательный -> Мелодрама")))
(defrule rule20
(fact(name "Про любовь"))
(not(exists (fact (name "Романтичный"))))
=>
(assert (fact (name "Романтичный")))
(assert (sendmessage "Про любовь -> Романтичный")))
(defrule rule21
(fact(name "Романтичный"))
(not(exists (fact (name "Мелодрама"))))
=>
(assert (fact (name "Мелодрама")))
(assert (sendmessage "Романтичный -> Мелодрама")))
(defrule rule22
(fact(name "Грустный"))
(not(exists (fact (name "Драма"))))
=>
(assert (fact (name "Драма")))
(assert (sendmessage "Грустный -> Драма")))
(defrule rule23
(fact(name "Трагический"))
(not(exists (fact (name "Драма"))))
=>
(assert (fact (name "Драма")))
(assert (sendmessage "Трагический -> Драма")))
(defrule rule24
(fact(name "Про преступников"))
(not(exists (fact (name "Криминал"))))
=>
(assert (fact (name "Криминал")))
(assert (sendmessage "Про преступников -> Криминал")))
(defrule rule25
(fact(name "Расследование"))
(fact(name "Криминал"))
(not(exists (fact (name "Детектив"))))
=>
(assert (fact (name "Детектив")))
(assert (sendmessage "Расследование, Криминал -> Детектив")))
(defrule rule26
(fact(name "Расследование"))
(fact(name "Медицинский"))
(not(exists (fact (name "Детектив"))))
=>
(assert (fact (name "Детектив")))
(assert (sendmessage "Расследование, Медицинский -> Детектив")))
(defrule rule27
(fact(name "Волшебный"))
(not(exists (fact (name "Фэнтези"))))
=>
(assert (fact (name "Фэнтези")))
(assert (sendmessage "Волшебный -> Фэнтези")))
(defrule rule28
(fact(name "Мифологический"))
(not(exists (fact (name "Фэнтези"))))
=>
(assert (fact (name "Фэнтези")))
(assert (sendmessage "Мифологический -> Фэнтези")))
(defrule rule29
(fact(name "Триллер"))
(not(exists (fact (name "Плоттвисты"))))
=>
(assert (fact (name "Плоттвисты")))
(assert (sendmessage "Триллер -> Плоттвисты")))
(defrule rule30
(fact(name "Детектив"))
(not(exists (fact (name "Плоттвисты"))))
=>
(assert (fact (name "Плоттвисты")))
(assert (sendmessage "Детектив -> Плоттвисты")))
(defrule rule31
(fact(name "Мелодрама"))
(not(exists (fact (name "Эмоциональный"))))
=>
(assert (fact (name "Эмоциональный")))
(assert (sendmessage "Мелодрама -> Эмоциональный")))
(defrule rule32
(fact(name "Драма"))
(not(exists (fact (name "Эмоциональный"))))
=>
(assert (fact (name "Эмоциональный")))
(assert (sendmessage "Драма -> Эмоциональный")))
(defrule rule33
(fact(name "Серии по 20 минут"))
(fact(name "Ситком"))
(fact(name "Иностранный"))
(not(exists (fact (name "Друзья"))))
=>
(assert (fact (name "Друзья")))
(assert (sendmessage "Серии по 20 минут, Ситком, Иностранный -> Друзья")))
(defrule rule34
(fact(name "Отечественный"))
(fact(name "Серии по 20 минут"))
(fact(name "Ситком"))
(fact(name "Медицинский"))
(not(exists (fact (name "Интерны"))))
=>
(assert (fact (name "Интерны")))
(assert (sendmessage "Отечественный, Серии по 20 минут, Ситком, Медицинский -> Интерны")))
(defrule rule35
(fact(name "Серии по 20 минут"))
(fact(name "Ситком"))
(fact(name "Иностранный"))
(not(exists (fact (name "Теория большого взрыва"))))
=>
(assert (fact (name "Теория большого взрыва")))
(assert (sendmessage "Серии по 20 минут, Ситком, Иностранный -> Теория большого взрыва")))
(defrule rule36
(fact(name "Иностранный"))
(fact(name "Серии по 60 минут"))
(fact(name "Приключения"))
(fact(name "Фэнтези"))
(not(exists (fact (name "Игра Престолов"))))
=>
(assert (fact (name "Игра Престолов")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Приключения, Фэнтези -> Игра Престолов")))
(defrule rule37
(fact(name "Серии по 60 минут"))
(fact(name "Иностранный"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Сопрано"))))
=>
(assert (fact (name "Сопрано")))
(assert (sendmessage "Серии по 60 минут, Иностранный, Эмоциональный -> Сопрано")))
(defrule rule38
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Научная фантастика"))
(fact(name "Приключения"))
(fact(name "Эмоциональный"))
(fact(name "Комедия"))
(not(exists (fact (name "Доктор Кто"))))
=>
(assert (fact (name "Доктор Кто")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Научная фантастика, Приключения, Эмоциональный, Комедия -> Доктор Кто")))
(defrule rule39
(fact(name "Фэнтези"))
(fact(name "Ужасы"))
(fact(name "Плоттвисты"))
(fact(name "Эмоциональный"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(not(exists (fact (name "Дневники вампира"))))
=>
(assert (fact (name "Дневники вампира")))
(assert (sendmessage "Фэнтези, Ужасы, Плоттвисты, Эмоциональный, Иностранный, Серии по 40 минут -> Дневники вампира")))
(defrule rule40
(fact(name "Криминал"))
(fact(name "Эмоциональный"))
(fact(name "Плоттвисты"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(not(exists (fact (name "Во все тяжкие"))))
=>
(assert (fact (name "Во все тяжкие")))
(assert (sendmessage "Криминал, Эмоциональный, Плоттвисты, Иностранный, Серии по 40 минут -> Во все тяжкие")))
(defrule rule41
(fact(name "Фэнтези"))
(fact(name "Ужасы"))
(fact(name "Иностранный"))
(fact(name "Плоттвисты"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Сверхестественное"))))
=>
(assert (fact (name "Сверхестественное")))
(assert (sendmessage "Фэнтези, Ужасы, Иностранный, Плоттвисты, Эмоциональный -> Сверхестественное")))
(defrule rule42
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Плоттвисты"))
(not(exists (fact (name "Доктор Хаус"))))
=>
(assert (fact (name "Доктор Хаус")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Плоттвисты -> Доктор Хаус")))
(defrule rule43
(fact(name "Ситком"))
(fact(name "Серии по 20 минут"))
(fact(name "Иностранный"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Клиника"))))
=>
(assert (fact (name "Клиника")))
(assert (sendmessage "Ситком, Серии по 20 минут, Иностранный, Эмоциональный -> Клиника")))
(defrule rule44
(fact(name "Спинофф"))
(fact(name "Теория большого взрыва"))
(not(exists (fact (name "Детство Шелдона"))))
=>
(assert (fact (name "Детство Шелдона")))
(assert (sendmessage "Спинофф, Теория большого взрыва -> Детство Шелдона")))
(defrule rule45
(fact(name "Спинофф"))
(fact(name "Игра Престолов"))
(not(exists (fact (name "Дом дракона"))))
=>
(assert (fact (name "Дом дракона")))
(assert (sendmessage "Спинофф, Игра Престолов -> Дом дракона")))
(defrule rule46
(fact(name "Спинофф"))
(fact(name "Доктор Кто"))
(not(exists (fact (name "Торчвуд"))))
=>
(assert (fact (name "Торчвуд")))
(assert (sendmessage "Спинофф, Доктор Кто -> Торчвуд")))
(defrule rule47
(fact(name "Спинофф"))
(fact(name "Дневники вампира"))
(not(exists (fact (name "Наследие"))))
=>
(assert (fact (name "Наследие")))
(assert (sendmessage "Спинофф, Дневники вампира -> Наследие")))
(defrule rule48
(fact(name "Спинофф"))
(fact(name "Дневники вампира"))
(not(exists (fact (name "Древние"))))
=>
(assert (fact (name "Древние")))
(assert (sendmessage "Спинофф, Дневники вампира -> Древние")))
(defrule rule49
(fact(name "Спинофф"))
(fact(name "Во все тяжкие"))
(not(exists (fact (name "Лучше звоните Солу"))))
=>
(assert (fact (name "Лучше звоните Солу")))
(assert (sendmessage "Спинофф, Во все тяжкие -> Лучше звоните Солу")))
(defrule rule50
(fact(name "Серии по 20 минут"))
(fact(name "Отечественный"))
(fact(name "Ситком"))
(not(exists (fact (name "Воронины"))))
=>
(assert (fact (name "Воронины")))
(assert (sendmessage "Серии по 20 минут, Отечественный, Ситком -> Воронины")))
(defrule rule51
(fact(name "Серии по 60 минут"))
(fact(name "Отечественный"))
(fact(name "Боевик"))
(fact(name "Эмоциональный"))
(fact(name "Криминал"))
(not(exists (fact (name "Бригада"))))
=>
(assert (fact (name "Бригада")))
(assert (sendmessage "Серии по 60 минут, Отечественный, Боевик, Эмоциональный, Криминал -> Бригада")))
(defrule rule52
(fact(name "Спинофф"))
(fact(name "Бригада"))
(not(exists (fact (name "Бригада: Наследник"))))
=>
(assert (fact (name "Бригада: Наследник")))
(assert (sendmessage "Спинофф, Бригада -> Бригада: Наследник")))
(defrule rule53
(fact(name "Отечественный"))
(fact(name "Серии по 60 минут"))
(fact(name "Приключения"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Семнадцать мгновений весны"))))
=>
(assert (fact (name "Семнадцать мгновений весны")))
(assert (sendmessage "Отечественный, Серии по 60 минут, Приключения, Эмоциональный -> Семнадцать мгновений весны")))
(defrule rule54
(fact(name "Ужасы"))
(fact(name "Плоттвисты"))
(fact(name "Эмоциональный"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(not(exists (fact (name "Ходячие мертвецы"))))
=>
(assert (fact (name "Ходячие мертвецы")))
(assert (sendmessage "Ужасы, Плоттвисты, Эмоциональный, Иностранный, Серии по 40 минут -> Ходячие мертвецы")))
(defrule rule55
(fact(name "Спинофф"))
(fact(name "Ходячие мертвецы"))
(not(exists (fact (name "Бойтесь ходячих мертвецов"))))
=>
(assert (fact (name "Бойтесь ходячих мертвецов")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Бойтесь ходячих мертвецов")))
(defrule rule56
(fact(name "Спинофф"))
(fact(name "Ходячие мертвецы"))
(not(exists (fact (name "Мир за пределами"))))
=>
(assert (fact (name "Мир за пределами")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Мир за пределами")))
(defrule rule57
(fact(name "Спинофф"))
(fact(name "Ходячие мертвецы"))
(not(exists (fact (name "История о ходячих мертвецах"))))
=>
(assert (fact (name "История о ходячих мертвецах")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> История о ходячих мертвецах")))
(defrule rule58
(fact(name "Спинофф"))
(fact(name "Ходячие мертвецы"))
(not(exists (fact (name "Ходячие мертвецы: Дэрил Диксон"))))
=>
(assert (fact (name "Ходячие мертвецы: Дэрил Диксон")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Ходячие мертвецы: Дэрил Диксон")))
(defrule rule59
(fact(name "Спинофф"))
(fact(name "Ходячие мертвецы"))
(not(exists (fact (name "Ходячие мертвецы: Мёртвый город"))))
=>
(assert (fact (name "Ходячие мертвецы: Мёртвый город")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Ходячие мертвецы: Мёртвый город")))
(defrule rule60
(fact(name "Спинофф"))
(fact(name "Ходячие мертвецы"))
(not(exists (fact (name "Ходячие мертвецы: Выжившие"))))
=>
(assert (fact (name "Ходячие мертвецы: Выжившие")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Ходячие мертвецы: Выжившие")))
(defrule rule61
(fact(name "Доктор Кто"))
(fact(name "Спинофф"))
(not(exists (fact (name "Приключения Сары Джейн"))))
=>
(assert (fact (name "Приключения Сары Джейн")))
(assert (sendmessage "Доктор Кто, Спинофф -> Приключения Сары Джейн")))
(defrule rule62
(fact(name "Серии по 20 минут"))
(fact(name "Отечественный"))
(not(exists (fact (name "Универ"))))
=>
(assert (fact (name "Универ")))
(assert (sendmessage "Серии по 20 минут, Отечественный -> Универ")))
(defrule rule63
(fact(name "Спинофф"))
(fact(name "Универ"))
(not(exists (fact (name "СашаТаня"))))
=>
(assert (fact (name "СашаТаня")))
(assert (sendmessage "Спинофф, Универ -> СашаТаня")))
(defrule rule64
(fact(name "Фантастика"))
(not(exists (fact (name "Научная фантастика"))))
=>
(assert (fact (name "Научная фантастика")))
(assert (sendmessage "Фантастика -> Научная фантастика")))
(defrule rule65
(fact(name "Фантастика"))
(not(exists (fact (name "Супер-герои"))))
=>
(assert (fact (name "Супер-герои")))
(assert (sendmessage "Фантастика -> Супер-герои")))
(defrule rule66
(fact(name "Супер-герои"))
(not(exists (fact (name "Marvel"))))
=>
(assert (fact (name "Marvel")))
(assert (sendmessage "Супер-герои -> Marvel")))
(defrule rule67
(fact(name "Супер-герои"))
(not(exists (fact (name "DC"))))
=>
(assert (fact (name "DC")))
(assert (sendmessage "Супер-герои -> DC")))
(defrule rule68
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Драма"))
(not(exists (fact (name "Старгёрл"))))
=>
(assert (fact (name "Старгёрл")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Драма -> Старгёрл")))
(defrule rule69
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Детектив"))
(not(exists (fact (name "Флэш"))))
=>
(assert (fact (name "Флэш")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Детектив -> Флэш")))
(defrule rule70
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Детектив"))
(fact(name "Драма"))
(fact(name "Боевик"))
(not(exists (fact (name "Стрела"))))
=>
(assert (fact (name "Стрела")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Детектив, Драма, Боевик -> Стрела")))
(defrule rule71
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Криминал"))
(not(exists (fact (name "Бэтвумен"))))
=>
(assert (fact (name "Бэтвумен")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Криминал -> Бэтвумен")))
(defrule rule72
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Боевик"))
(not(exists (fact (name "Тайны Смолвиля"))))
=>
(assert (fact (name "Тайны Смолвиля")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Боевик -> Тайны Смолвиля")))
(defrule rule73
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Детектив"))
(not(exists (fact (name "Роковой Патруль"))))
=>
(assert (fact (name "Роковой Патруль")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Детектив -> Роковой Патруль")))
(defrule rule74
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Приключения"))
(not(exists (fact (name "Криптон"))))
=>
(assert (fact (name "Криптон")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Приключения -> Криптон")))
(defrule rule75
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Драма"))
(fact(name "Приключения"))
(not(exists (fact (name "Легенды завтрашнего дня"))))
=>
(assert (fact (name "Легенды завтрашнего дня")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Драма, Приключения -> Легенды завтрашнего дня")))
(defrule rule76
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Драма"))
(not(exists (fact (name "Супер Гёрл"))))
=>
(assert (fact (name "Супер Гёрл")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Драма -> Супер Гёрл")))
(defrule rule77
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Плоттвисты"))
(fact(name "Драма"))
(fact(name "Боевик"))
(not(exists (fact (name "Готэм"))))
=>
(assert (fact (name "Готэм")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Плоттвисты, Драма, Боевик -> Готэм")))
(defrule rule78
(fact(name "DC"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Драма"))
(fact(name "Приключения"))
(not(exists (fact (name "Супермэн и Лоис"))))
=>
(assert (fact (name "Супермэн и Лоис")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Драма, Приключения -> Супермэн и Лоис")))
(defrule rule79
(fact(name "Турция"))
(not(exists (fact (name "Иностранный"))))
=>
(assert (fact (name "Иностранный")))
(assert (sendmessage "Турция -> Иностранный")))
(defrule rule80
(fact(name "Эмоциональный"))
(fact(name "Плоттвисты"))
(fact(name "Иностранный"))
(fact(name "Ужасы"))
(fact(name "Серии по 40 минут"))
(not(exists (fact (name "Американская история ужасов"))))
=>
(assert (fact (name "Американская история ужасов")))
(assert (sendmessage "Эмоциональный, Плоттвисты, Иностранный, Ужасы, Серии по 40 минут -> Американская история ужасов")))
(defrule rule81
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Эмоциональный"))
(fact(name "Плоттвисты"))
(not(exists (fact (name "Как избежать наказания за убийство"))))
=>
(assert (fact (name "Как избежать наказания за убийство")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный, Плоттвисты -> Как избежать наказания за убийство")))
(defrule rule82
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Эмоциональный"))
(fact(name "Плоттвисты"))
(fact(name "Комедия"))
(not(exists (fact (name "Отчаянные домохозяйки"))))
=>
(assert (fact (name "Отчаянные домохозяйки")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный, Плоттвисты, Комедия -> Отчаянные домохозяйки")))
(defrule rule83
(fact(name "Эмоциональный"))
(fact(name "Иностранный"))
(fact(name "Серии по 60 минут"))
(not(exists (fact (name "Корона"))))
=>
(assert (fact (name "Корона")))
(assert (sendmessage "Эмоциональный, Иностранный, Серии по 60 минут -> Корона")))
(defrule rule84
(fact(name "Иностранный"))
(fact(name "Серии по 60 минут"))
(fact(name "Эмоциональный"))
(fact(name "Комедия"))
(fact(name "Супер-герои"))
(fact(name "Боевик"))
(not(exists (fact (name "Пацаны"))))
=>
(assert (fact (name "Пацаны")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Эмоциональный, Комедия, Супер-герои, Боевик -> Пацаны")))
(defrule rule85
(fact(name "Эмоциональный"))
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Плоттвисты"))
(fact(name "Ужасы"))
(not(exists (fact (name "Черное зеркало"))))
=>
(assert (fact (name "Черное зеркало")))
(assert (sendmessage "Эмоциональный, Иностранный, Серии по 40 минут, Плоттвисты, Ужасы -> Черное зеркало")))
(defrule rule86
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Комедия"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Дрянь"))))
=>
(assert (fact (name "Дрянь")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Комедия, Эмоциональный -> Дрянь")))
(defrule rule87
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Комедия"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Бесстыжие"))))
=>
(assert (fact (name "Бесстыжие")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Комедия, Эмоциональный -> Бесстыжие")))
(defrule rule88
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Эмоциональный"))
(fact(name "Плоттвисты"))
(fact(name "Боевик"))
(not(exists (fact (name "Бумажный дом"))))
=>
(assert (fact (name "Бумажный дом")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный, Плоттвисты, Боевик -> Бумажный дом")))
(defrule rule89
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Плоттвисты"))
(fact(name "Эмоциональный"))
(fact(name "Фантастика"))
(not(exists (fact (name "Твин пикс"))))
=>
(assert (fact (name "Твин пикс")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Плоттвисты, Эмоциональный, Фантастика -> Твин пикс")))
(defrule rule90
(fact(name "Иностранный"))
(fact(name "Эмоциональный"))
(fact(name "Серии по 60 минут"))
(fact(name "Приключения"))
(fact(name "Боевик"))
(not(exists (fact (name "Викинги"))))
=>
(assert (fact (name "Викинги")))
(assert (sendmessage "Иностранный, Эмоциональный, Серии по 60 минут, Приключения, Боевик -> Викинги")))
(defrule rule91
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Великолепный век"))))
=>
(assert (fact (name "Великолепный век")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный -> Великолепный век")))
(defrule rule92
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Постучись в мою дверь"))))
=>
(assert (fact (name "Постучись в мою дверь")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный -> Постучись в мою дверь")))
(defrule rule93
(fact(name "Иностранный"))
(fact(name "Серии по 60 минут"))
(fact(name "Фантастика"))
(fact(name "Плоттвисты"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "11.22.63"))))
=>
(assert (fact (name "11.22.63")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Фантастика, Плоттвисты, Эмоциональный -> 11.22.63")))
(defrule rule94
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Молокососы"))))
=>
(assert (fact (name "Молокососы")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный -> Молокососы")))
(defrule rule95
(fact(name "Иностранный"))
(fact(name "Серии по 60 минут"))
(fact(name "Фантастика"))
(fact(name "Плоттвисты"))
(fact(name "Боевик"))
(not(exists (fact (name "Видоизменённый углерод"))))
=>
(assert (fact (name "Видоизменённый углерод")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Фантастика, Плоттвисты, Боевик -> Видоизменённый углерод")))
(defrule rule96
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Эмоциональный"))
(fact(name "Фэнтези"))
(fact(name "Приключения"))
(not(exists (fact (name "Однажды в сказке"))))
=>
(assert (fact (name "Однажды в сказке")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный, Фэнтези, Приключения -> Однажды в сказке")))
(defrule rule97
(fact(name "Иностранный"))
(fact(name "Серии по 40 минут"))
(fact(name "Эмоциональный"))
(not(exists (fact (name " Бухта Доусона"))))
=>
(assert (fact (name " Бухта Доусона")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный ->  Бухта Доусона")))
(defrule rule98
(fact(name "Иностранный"))
(fact(name "Серии по 60 минут"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Бриджертоны"))))
=>
(assert (fact (name "Бриджертоны")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Эмоциональный -> Бриджертоны")))
(defrule rule99
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Эмоциональный"))
(fact(name "Приключения"))
(not(exists (fact (name "Мутанты Икс"))))
=>
(assert (fact (name "Мутанты Икс")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Приключения -> Мутанты Икс")))
(defrule rule100
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Ужасы"))
(not(exists (fact (name "Блэйд"))))
=>
(assert (fact (name "Блэйд")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Ужасы -> Блэйд")))
(defrule rule101
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Агенты Щ.И.Т."))))
=>
(assert (fact (name "Агенты Щ.И.Т.")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный -> Агенты Щ.И.Т.")))
(defrule rule102
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Криминал"))
(not(exists (fact (name "Агент Картер"))))
=>
(assert (fact (name "Агент Картер")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал -> Агент Картер")))
(defrule rule103
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Эмоциональный"))
(fact(name "Криминал"))
(not(exists (fact (name "Сверхспособности"))))
=>
(assert (fact (name "Сверхспособности")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Криминал -> Сверхспособности")))
(defrule rule104
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Криминал"))
(fact(name "Эмоциональный"))
(fact(name "Фэнтези"))
(not(exists (fact (name "Сорвиголова"))))
=>
(assert (fact (name "Сорвиголова")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Эмоциональный, Фэнтези -> Сорвиголова")))
(defrule rule105
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Криминал"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Джессика Джонс"))))
=>
(assert (fact (name "Джессика Джонс")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Эмоциональный -> Джессика Джонс")))
(defrule rule106
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Криминал"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Люк Кейдж"))))
=>
(assert (fact (name "Люк Кейдж")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Эмоциональный -> Люк Кейдж")))
(defrule rule107
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Эмоциональный"))
(fact(name "Приключения"))
(not(exists (fact (name "Плащ и Кинжал"))))
=>
(assert (fact (name "Плащ и Кинжал")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Приключения -> Плащ и Кинжал")))
(defrule rule108
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Эмоциональный"))
(fact(name "Плоттвисты"))
(not(exists (fact (name "Легион"))))
=>
(assert (fact (name "Легион")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Плоттвисты -> Легион")))
(defrule rule109
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Криминал"))
(fact(name "Фэнтези"))
(not(exists (fact (name "Железный кулак"))))
=>
(assert (fact (name "Железный кулак")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Фэнтези -> Железный кулак")))
(defrule rule110
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Криминал"))
(fact(name "Фэнтези"))
(fact(name "Приключения"))
(not(exists (fact (name "Защитники"))))
=>
(assert (fact (name "Защитники")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Фэнтези, Приключения -> Защитники")))
(defrule rule111
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Криминал"))
(fact(name "Эмоциональный"))
(fact(name "Плоттвисты"))
(not(exists (fact (name "Каратель"))))
=>
(assert (fact (name "Каратель")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Эмоциональный, Плоттвисты -> Каратель")))
(defrule rule112
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Приключения"))
(not(exists (fact (name "Сверхлюди"))))
=>
(assert (fact (name "Сверхлюди")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Приключения -> Сверхлюди")))
(defrule rule113
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Эмоциональный"))
(fact(name "Фэнтези"))
(not(exists (fact (name "Одарённые"))))
=>
(assert (fact (name "Одарённые")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Фэнтези -> Одарённые")))
(defrule rule114
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Эмоциональный"))
(not(exists (fact (name "Беглецы"))))
=>
(assert (fact (name "Беглецы")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный -> Беглецы")))
(defrule rule115
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Фэнтези"))
(fact(name "Приключения"))
(not(exists (fact (name "Локи"))))
=>
(assert (fact (name "Локи")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Фэнтези, Приключения -> Локи")))
(defrule rule116
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Эмоциональный"))
(fact(name "Ситком"))
(fact(name "Фэнтези"))
(not(exists (fact (name "Ванда/Вижн"))))
=>
(assert (fact (name "Ванда/Вижн")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Ситком, Фэнтези -> Ванда/Вижн")))
(defrule rule117
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Эмоциональный"))
(fact(name "Приключения"))
(not(exists (fact (name "Сокол и Зимний солдат"))))
=>
(assert (fact (name "Сокол и Зимний солдат")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Приключения -> Сокол и Зимний солдат")))
(defrule rule118
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(not(exists (fact (name "WHIH: Новостной фронт"))))
=>
(assert (fact (name "WHIH: Новостной фронт")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel -> WHIH: Новостной фронт")))
(defrule rule119
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(fact(name "Приключения"))
(fact(name "Эмоциональный"))
(fact(name "Фэнтези"))
(not(exists (fact (name "Агенты 'Щ.И.Т.': Йо-йо"))))
=>
(assert (fact (name "Агенты 'Щ.И.Т.': Йо-йо")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Приключения, Эмоциональный, Фэнтези -> Агенты 'Щ.И.Т.': Йо-йо")))
(defrule rule120
(fact(name "Серии по 40 минут"))
(fact(name "Иностранный"))
(fact(name "Marvel"))
(not(exists (fact (name "Агенты «Щ.И.Т.»: Академия"))))
=>
(assert (fact (name "Агенты «Щ.И.Т.»: Академия")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel -> Агенты «Щ.И.Т.»: Академия")))
(defrule rule121
(fact(name "Про докторов"))
(not(exists (fact (name "Медицинский"))))
=>
(assert (fact (name "Медицинский")))
(assert (sendmessage "Про докторов -> Медицинский")))
(defrule rule122
(fact(name "Детектив"))
(not(exists (fact (name "Медицинский"))))
=>
(assert (fact (name "Медицинский")))
(assert (sendmessage "Детектив -> Медицинский")))
