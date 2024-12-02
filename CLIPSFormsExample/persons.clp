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

(deffacts axioms
(Axiom (name "Короткие серии"))
(Axiom (name "Средние серии"))
(Axiom (name "Долгие серии"))
(Axiom (name "Русский"))
(Axiom (name "СССР"))
(Axiom (name "США"))
(Axiom (name "Великобритания"))
(Axiom (name "Турция"))
(Axiom (name "Повседневность"))
(Axiom (name "Смешной"))
(Axiom (name "Весёлый"))
(Axiom (name "Магия"))
(Axiom (name "Драконы"))
(Axiom (name "Эпический"))
(Axiom (name "Динамичный"))
(Axiom (name "Захватывающий"))
(Axiom (name "Необычный"))
(Axiom (name "Серьёзный"))
(Axiom (name "Напряжённый"))
(Axiom (name "Страшный"))
(Axiom (name "Чувственный"))
(Axiom (name "Трогательный"))
(Axiom (name "Про любовь"))
(Axiom (name "Грустный"))
(Axiom (name "Трагический"))
(Axiom (name "Про преступников"))
(Axiom (name "Расследование"))
(Axiom (name "Про докторов"))
(Axiom (name "Спинофф"))
)

(defrule rule1
(Fact(name "Короткие серии"))
(not(exists (Fact (name "Серии по 20 минут"))))
=>
(assert (Fact (name "Серии по 20 минут")))
(assert (sendmessage "Короткие серии -> Серии по 20 минут")))
(defrule rule2
(Fact(name "Средние серии"))
(not(exists (Fact (name "Серии по 40 минут"))))
=>
(assert (Fact (name "Серии по 40 минут")))
(assert (sendmessage "Средние серии -> Серии по 40 минут")))
(defrule rule3
(Fact(name "Долгие серии"))
(not(exists (Fact (name "Серии по 60 минут"))))
=>
(assert (Fact (name "Серии по 60 минут")))
(assert (sendmessage "Долгие серии -> Серии по 60 минут")))
(defrule rule4
(Fact(name "Русский"))
(not(exists (Fact (name "Отечественный"))))
=>
(assert (Fact (name "Отечественный")))
(assert (sendmessage "Русский -> Отечественный")))
(defrule rule5
(Fact(name "СССР"))
(not(exists (Fact (name "Отечественный"))))
=>
(assert (Fact (name "Отечественный")))
(assert (sendmessage "СССР -> Отечественный")))
(defrule rule6
(Fact(name "США"))
(not(exists (Fact (name "Иностранный"))))
=>
(assert (Fact (name "Иностранный")))
(assert (sendmessage "США -> Иностранный")))
(defrule rule7
(Fact(name "Великобритания"))
(not(exists (Fact (name "Иностранный"))))
=>
(assert (Fact (name "Иностранный")))
(assert (sendmessage "Великобритания -> Иностранный")))
(defrule rule8
(Fact(name "Повседневность"))
(Fact(name "Комедия"))
(not(exists (Fact (name "Ситком"))))
=>
(assert (Fact (name "Ситком")))
(assert (sendmessage "Повседневность, Комедия -> Ситком")))
(defrule rule9
(Fact(name "Смешной"))
(not(exists (Fact (name "Комедия"))))
=>
(assert (Fact (name "Комедия")))
(assert (sendmessage "Смешной -> Комедия")))
(defrule rule10
(Fact(name "Весёлый"))
(not(exists (Fact (name "Комедия"))))
=>
(assert (Fact (name "Комедия")))
(assert (sendmessage "Весёлый -> Комедия")))
(defrule rule11
(Fact(name "Магия"))
(not(exists (Fact (name "Волшебный"))))
=>
(assert (Fact (name "Волшебный")))
(assert (sendmessage "Магия -> Волшебный")))
(defrule rule12
(Fact(name "Драконы"))
(not(exists (Fact (name "Мифологический"))))
=>
(assert (Fact (name "Мифологический")))
(assert (sendmessage "Драконы -> Мифологический")))
(defrule rule13
(Fact(name "Эпический"))
(Fact(name "Динамичный"))
(Fact(name "Захватывающий"))
(not(exists (Fact (name "Боевик"))))
=>
(assert (Fact (name "Боевик")))
(assert (sendmessage "Эпический, Динамичный, Захватывающий -> Боевик")))
(defrule rule14
(Fact(name "Динамичный"))
(Fact(name "Захватывающий"))
(not(exists (Fact (name "Приключения"))))
=>
(assert (Fact (name "Приключения")))
(assert (sendmessage "Динамичный, Захватывающий -> Приключения")))
(defrule rule15
(Fact(name "Захватывающий"))
(Fact(name "Необычный"))
(not(exists (Fact (name "Фантастика"))))
=>
(assert (Fact (name "Фантастика")))
(assert (sendmessage "Захватывающий, Необычный -> Фантастика")))
(defrule rule16
(Fact(name "Серьёзный"))
(Fact(name "Напряжённый"))
(not(exists (Fact (name "Триллер"))))
=>
(assert (Fact (name "Триллер")))
(assert (sendmessage "Серьёзный, Напряжённый -> Триллер")))
(defrule rule17
(Fact(name "Напряжённый"))
(Fact(name "Страшный"))
(not(exists (Fact (name "Ужасы"))))
=>
(assert (Fact (name "Ужасы")))
(assert (sendmessage "Напряжённый, Страшный -> Ужасы")))
(defrule rule18
(Fact(name "Чувственный"))
(not(exists (Fact (name "Мелодрама"))))
=>
(assert (Fact (name "Мелодрама")))
(assert (sendmessage "Чувственный -> Мелодрама")))
(defrule rule19
(Fact(name "Трогательный"))
(not(exists (Fact (name "Мелодрама"))))
=>
(assert (Fact (name "Мелодрама")))
(assert (sendmessage "Трогательный -> Мелодрама")))
(defrule rule20
(Fact(name "Про любовь"))
(not(exists (Fact (name "Романтичный"))))
=>
(assert (Fact (name "Романтичный")))
(assert (sendmessage "Про любовь -> Романтичный")))
(defrule rule21
(Fact(name "Романтичный"))
(not(exists (Fact (name "Мелодрама"))))
=>
(assert (Fact (name "Мелодрама")))
(assert (sendmessage "Романтичный -> Мелодрама")))
(defrule rule22
(Fact(name "Грустный"))
(not(exists (Fact (name "Драма"))))
=>
(assert (Fact (name "Драма")))
(assert (sendmessage "Грустный -> Драма")))
(defrule rule23
(Fact(name "Трагический"))
(not(exists (Fact (name "Драма"))))
=>
(assert (Fact (name "Драма")))
(assert (sendmessage "Трагический -> Драма")))
(defrule rule24
(Fact(name "Про преступников"))
(not(exists (Fact (name "Криминал"))))
=>
(assert (Fact (name "Криминал")))
(assert (sendmessage "Про преступников -> Криминал")))
(defrule rule25
(Fact(name "Расследование"))
(Fact(name "Криминал"))
(not(exists (Fact (name "Детектив"))))
=>
(assert (Fact (name "Детектив")))
(assert (sendmessage "Расследование, Криминал -> Детектив")))
(defrule rule26
(Fact(name "Расследование"))
(Fact(name "Медицинский"))
(not(exists (Fact (name "Детектив"))))
=>
(assert (Fact (name "Детектив")))
(assert (sendmessage "Расследование, Медицинский -> Детектив")))
(defrule rule27
(Fact(name "Волшебный"))
(not(exists (Fact (name "Фэнтези"))))
=>
(assert (Fact (name "Фэнтези")))
(assert (sendmessage "Волшебный -> Фэнтези")))
(defrule rule28
(Fact(name "Мифологический"))
(not(exists (Fact (name "Фэнтези"))))
=>
(assert (Fact (name "Фэнтези")))
(assert (sendmessage "Мифологический -> Фэнтези")))
(defrule rule29
(Fact(name "Триллер"))
(not(exists (Fact (name "Плоттвисты"))))
=>
(assert (Fact (name "Плоттвисты")))
(assert (sendmessage "Триллер -> Плоттвисты")))
(defrule rule30
(Fact(name "Детектив"))
(not(exists (Fact (name "Плоттвисты"))))
=>
(assert (Fact (name "Плоттвисты")))
(assert (sendmessage "Детектив -> Плоттвисты")))
(defrule rule31
(Fact(name "Мелодрама"))
(not(exists (Fact (name "Эмоциональный"))))
=>
(assert (Fact (name "Эмоциональный")))
(assert (sendmessage "Мелодрама -> Эмоциональный")))
(defrule rule32
(Fact(name "Драма"))
(not(exists (Fact (name "Эмоциональный"))))
=>
(assert (Fact (name "Эмоциональный")))
(assert (sendmessage "Драма -> Эмоциональный")))
(defrule rule33
(Fact(name "Серии по 20 минут"))
(Fact(name "Ситком"))
(Fact(name "Иностранный"))
(not(exists (Fact (name "Друзья"))))
=>
(assert (Fact (name "Друзья")))
(assert (sendmessage "Серии по 20 минут, Ситком, Иностранный -> Друзья")))
(defrule rule34
(Fact(name "Отечественный"))
(Fact(name "Серии по 20 минут"))
(Fact(name "Ситком"))
(Fact(name "Медицинский"))
(not(exists (Fact (name "Интерны"))))
=>
(assert (Fact (name "Интерны")))
(assert (sendmessage "Отечественный, Серии по 20 минут, Ситком, Медицинский -> Интерны")))
(defrule rule35
(Fact(name "Серии по 20 минут"))
(Fact(name "Ситком"))
(Fact(name "Иностранный"))
(not(exists (Fact (name "Теория большого взрыва"))))
=>
(assert (Fact (name "Теория большого взрыва")))
(assert (sendmessage "Серии по 20 минут, Ситком, Иностранный -> Теория большого взрыва")))
(defrule rule36
(Fact(name "Иностранный"))
(Fact(name "Серии по 60 минут"))
(Fact(name "Приключения"))
(Fact(name "Фэнтези"))
(not(exists (Fact (name "Игра Престолов"))))
=>
(assert (Fact (name "Игра Престолов")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Приключения, Фэнтези -> Игра Престолов")))
(defrule rule37
(Fact(name "Серии по 60 минут"))
(Fact(name "Иностранный"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Сопрано"))))
=>
(assert (Fact (name "Сопрано")))
(assert (sendmessage "Серии по 60 минут, Иностранный, Эмоциональный -> Сопрано")))
(defrule rule38
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Научная фантастика"))
(Fact(name "Приключения"))
(Fact(name "Эмоциональный"))
(Fact(name "Комедия"))
(not(exists (Fact (name "Доктор Кто"))))
=>
(assert (Fact (name "Доктор Кто")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Научная фантастика, Приключения, Эмоциональный, Комедия -> Доктор Кто")))
(defrule rule39
(Fact(name "Фэнтези"))
(Fact(name "Ужасы"))
(Fact(name "Плоттвисты"))
(Fact(name "Эмоциональный"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(not(exists (Fact (name "Дневники вампира"))))
=>
(assert (Fact (name "Дневники вампира")))
(assert (sendmessage "Фэнтези, Ужасы, Плоттвисты, Эмоциональный, Иностранный, Серии по 40 минут -> Дневники вампира")))
(defrule rule40
(Fact(name "Криминал"))
(Fact(name "Эмоциональный"))
(Fact(name "Плоттвисты"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(not(exists (Fact (name "Во все тяжкие"))))
=>
(assert (Fact (name "Во все тяжкие")))
(assert (sendmessage "Криминал, Эмоциональный, Плоттвисты, Иностранный, Серии по 40 минут -> Во все тяжкие")))
(defrule rule41
(Fact(name "Фэнтези"))
(Fact(name "Ужасы"))
(Fact(name "Иностранный"))
(Fact(name "Плоттвисты"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Сверхестественное"))))
=>
(assert (Fact (name "Сверхестественное")))
(assert (sendmessage "Фэнтези, Ужасы, Иностранный, Плоттвисты, Эмоциональный -> Сверхестественное")))
(defrule rule42
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Плоттвисты"))
(not(exists (Fact (name "Доктор Хаус"))))
=>
(assert (Fact (name "Доктор Хаус")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Плоттвисты -> Доктор Хаус")))
(defrule rule43
(Fact(name "Ситком"))
(Fact(name "Серии по 20 минут"))
(Fact(name "Иностранный"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Клиника"))))
=>
(assert (Fact (name "Клиника")))
(assert (sendmessage "Ситком, Серии по 20 минут, Иностранный, Эмоциональный -> Клиника")))
(defrule rule44
(Fact(name "Спинофф"))
(Fact(name "Теория большого взрыва"))
(not(exists (Fact (name "Детство Шелдона"))))
=>
(assert (Fact (name "Детство Шелдона")))
(assert (sendmessage "Спинофф, Теория большого взрыва -> Детство Шелдона")))
(defrule rule45
(Fact(name "Спинофф"))
(Fact(name "Игра Престолов"))
(not(exists (Fact (name "Дом дракона"))))
=>
(assert (Fact (name "Дом дракона")))
(assert (sendmessage "Спинофф, Игра Престолов -> Дом дракона")))
(defrule rule46
(Fact(name "Спинофф"))
(Fact(name "Доктор Кто"))
(not(exists (Fact (name "Торчвуд"))))
=>
(assert (Fact (name "Торчвуд")))
(assert (sendmessage "Спинофф, Доктор Кто -> Торчвуд")))
(defrule rule47
(Fact(name "Спинофф"))
(Fact(name "Дневники вампира"))
(not(exists (Fact (name "Наследие"))))
=>
(assert (Fact (name "Наследие")))
(assert (sendmessage "Спинофф, Дневники вампира -> Наследие")))
(defrule rule48
(Fact(name "Спинофф"))
(Fact(name "Дневники вампира"))
(not(exists (Fact (name "Древние"))))
=>
(assert (Fact (name "Древние")))
(assert (sendmessage "Спинофф, Дневники вампира -> Древние")))
(defrule rule49
(Fact(name "Спинофф"))
(Fact(name "Во все тяжкие"))
(not(exists (Fact (name "Лучше звоните Солу"))))
=>
(assert (Fact (name "Лучше звоните Солу")))
(assert (sendmessage "Спинофф, Во все тяжкие -> Лучше звоните Солу")))
(defrule rule50
(Fact(name "Серии по 20 минут"))
(Fact(name "Отечественный"))
(Fact(name "Ситком"))
(not(exists (Fact (name "Воронины"))))
=>
(assert (Fact (name "Воронины")))
(assert (sendmessage "Серии по 20 минут, Отечественный, Ситком -> Воронины")))
(defrule rule51
(Fact(name "Серии по 60 минут"))
(Fact(name "Отечественный"))
(Fact(name "Боевик"))
(Fact(name "Эмоциональный"))
(Fact(name "Криминал"))
(not(exists (Fact (name "Бригада"))))
=>
(assert (Fact (name "Бригада")))
(assert (sendmessage "Серии по 60 минут, Отечественный, Боевик, Эмоциональный, Криминал -> Бригада")))
(defrule rule52
(Fact(name "Спинофф"))
(Fact(name "Бригада"))
(not(exists (Fact (name "Бригада: Наследник"))))
=>
(assert (Fact (name "Бригада: Наследник")))
(assert (sendmessage "Спинофф, Бригада -> Бригада: Наследник")))
(defrule rule53
(Fact(name "Отечественный"))
(Fact(name "Серии по 60 минут"))
(Fact(name "Приключения"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Семнадцать мгновений весны"))))
=>
(assert (Fact (name "Семнадцать мгновений весны")))
(assert (sendmessage "Отечественный, Серии по 60 минут, Приключения, Эмоциональный -> Семнадцать мгновений весны")))
(defrule rule54
(Fact(name "Ужасы"))
(Fact(name "Плоттвисты"))
(Fact(name "Эмоциональный"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(not(exists (Fact (name "Ходячие мертвецы"))))
=>
(assert (Fact (name "Ходячие мертвецы")))
(assert (sendmessage "Ужасы, Плоттвисты, Эмоциональный, Иностранный, Серии по 40 минут -> Ходячие мертвецы")))
(defrule rule55
(Fact(name "Спинофф"))
(Fact(name "Ходячие мертвецы"))
(not(exists (Fact (name "Бойтесь ходячих мертвецов"))))
=>
(assert (Fact (name "Бойтесь ходячих мертвецов")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Бойтесь ходячих мертвецов")))
(defrule rule56
(Fact(name "Спинофф"))
(Fact(name "Ходячие мертвецы"))
(not(exists (Fact (name "Мир за пределами"))))
=>
(assert (Fact (name "Мир за пределами")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Мир за пределами")))
(defrule rule57
(Fact(name "Спинофф"))
(Fact(name "Ходячие мертвецы"))
(not(exists (Fact (name "История о ходячих мертвецах"))))
=>
(assert (Fact (name "История о ходячих мертвецах")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> История о ходячих мертвецах")))
(defrule rule58
(Fact(name "Спинофф"))
(Fact(name "Ходячие мертвецы"))
(not(exists (Fact (name "Ходячие мертвецы: Дэрил Диксон"))))
=>
(assert (Fact (name "Ходячие мертвецы: Дэрил Диксон")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Ходячие мертвецы: Дэрил Диксон")))
(defrule rule59
(Fact(name "Спинофф"))
(Fact(name "Ходячие мертвецы"))
(not(exists (Fact (name "Ходячие мертвецы: Мёртвый город"))))
=>
(assert (Fact (name "Ходячие мертвецы: Мёртвый город")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Ходячие мертвецы: Мёртвый город")))
(defrule rule60
(Fact(name "Спинофф"))
(Fact(name "Ходячие мертвецы"))
(not(exists (Fact (name "Ходячие мертвецы: Выжившие"))))
=>
(assert (Fact (name "Ходячие мертвецы: Выжившие")))
(assert (sendmessage "Спинофф, Ходячие мертвецы -> Ходячие мертвецы: Выжившие")))
(defrule rule61
(Fact(name "Доктор Кто"))
(Fact(name "Спинофф"))
(not(exists (Fact (name "Приключения Сары Джейн"))))
=>
(assert (Fact (name "Приключения Сары Джейн")))
(assert (sendmessage "Доктор Кто, Спинофф -> Приключения Сары Джейн")))
(defrule rule62
(Fact(name "Серии по 20 минут"))
(Fact(name "Отечественный"))
(not(exists (Fact (name "Универ"))))
=>
(assert (Fact (name "Универ")))
(assert (sendmessage "Серии по 20 минут, Отечественный -> Универ")))
(defrule rule63
(Fact(name "Спинофф"))
(Fact(name "Универ"))
(not(exists (Fact (name "СашаТаня"))))
=>
(assert (Fact (name "СашаТаня")))
(assert (sendmessage "Спинофф, Универ -> СашаТаня")))
(defrule rule64
(Fact(name "Фантастика"))
(not(exists (Fact (name "Научная фантастика"))))
=>
(assert (Fact (name "Научная фантастика")))
(assert (sendmessage "Фантастика -> Научная фантастика")))
(defrule rule65
(Fact(name "Фантастика"))
(not(exists (Fact (name "Супер-герои"))))
=>
(assert (Fact (name "Супер-герои")))
(assert (sendmessage "Фантастика -> Супер-герои")))
(defrule rule66
(Fact(name "Супер-герои"))
(not(exists (Fact (name "Marvel"))))
=>
(assert (Fact (name "Marvel")))
(assert (sendmessage "Супер-герои -> Marvel")))
(defrule rule67
(Fact(name "Супер-герои"))
(not(exists (Fact (name "DC"))))
=>
(assert (Fact (name "DC")))
(assert (sendmessage "Супер-герои -> DC")))
(defrule rule68
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Драма"))
(not(exists (Fact (name "Старгёрл"))))
=>
(assert (Fact (name "Старгёрл")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Драма -> Старгёрл")))
(defrule rule69
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Детектив"))
(not(exists (Fact (name "Флэш"))))
=>
(assert (Fact (name "Флэш")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Детектив -> Флэш")))
(defrule rule70
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Детектив"))
(Fact(name "Драма"))
(Fact(name "Боевик"))
(not(exists (Fact (name "Стрела"))))
=>
(assert (Fact (name "Стрела")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Детектив, Драма, Боевик -> Стрела")))
(defrule rule71
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Криминал"))
(not(exists (Fact (name "Бэтвумен"))))
=>
(assert (Fact (name "Бэтвумен")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Криминал -> Бэтвумен")))
(defrule rule72
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Боевик"))
(not(exists (Fact (name "Тайны Смолвиля"))))
=>
(assert (Fact (name "Тайны Смолвиля")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Боевик -> Тайны Смолвиля")))
(defrule rule73
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Детектив"))
(not(exists (Fact (name "Роковой Патруль"))))
=>
(assert (Fact (name "Роковой Патруль")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Детектив -> Роковой Патруль")))
(defrule rule74
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Криптон"))))
=>
(assert (Fact (name "Криптон")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Приключения -> Криптон")))
(defrule rule75
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Драма"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Легенды завтрашнего дня"))))
=>
(assert (Fact (name "Легенды завтрашнего дня")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Драма, Приключения -> Легенды завтрашнего дня")))
(defrule rule76
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Драма"))
(not(exists (Fact (name "Супер Гёрл"))))
=>
(assert (Fact (name "Супер Гёрл")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Драма -> Супер Гёрл")))
(defrule rule77
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Плоттвисты"))
(Fact(name "Драма"))
(Fact(name "Боевик"))
(not(exists (Fact (name "Готэм"))))
=>
(assert (Fact (name "Готэм")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Плоттвисты, Драма, Боевик -> Готэм")))
(defrule rule78
(Fact(name "DC"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Драма"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Супермэн и Лоис"))))
=>
(assert (Fact (name "Супермэн и Лоис")))
(assert (sendmessage "DC, Иностранный, Серии по 40 минут, Драма, Приключения -> Супермэн и Лоис")))
(defrule rule79
(Fact(name "Турция"))
(not(exists (Fact (name "Иностранный"))))
=>
(assert (Fact (name "Иностранный")))
(assert (sendmessage "Турция -> Иностранный")))
(defrule rule80
(Fact(name "Эмоциональный"))
(Fact(name "Плоттвисты"))
(Fact(name "Иностранный"))
(Fact(name "Ужасы"))
(Fact(name "Серии по 40 минут"))
(not(exists (Fact (name "Американская история ужасов"))))
=>
(assert (Fact (name "Американская история ужасов")))
(assert (sendmessage "Эмоциональный, Плоттвисты, Иностранный, Ужасы, Серии по 40 минут -> Американская история ужасов")))
(defrule rule81
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Эмоциональный"))
(Fact(name "Плоттвисты"))
(not(exists (Fact (name "Как избежать наказания за убийство"))))
=>
(assert (Fact (name "Как избежать наказания за убийство")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный, Плоттвисты -> Как избежать наказания за убийство")))
(defrule rule82
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Эмоциональный"))
(Fact(name "Плоттвисты"))
(Fact(name "Комедия"))
(not(exists (Fact (name "Отчаянные домохозяйки"))))
=>
(assert (Fact (name "Отчаянные домохозяйки")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный, Плоттвисты, Комедия -> Отчаянные домохозяйки")))
(defrule rule83
(Fact(name "Эмоциональный"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 60 минут"))
(not(exists (Fact (name "Корона"))))
=>
(assert (Fact (name "Корона")))
(assert (sendmessage "Эмоциональный, Иностранный, Серии по 60 минут -> Корона")))
(defrule rule84
(Fact(name "Иностранный"))
(Fact(name "Серии по 60 минут"))
(Fact(name "Эмоциональный"))
(Fact(name "Комедия"))
(Fact(name "Супер-герои"))
(Fact(name "Боевик"))
(not(exists (Fact (name "Пацаны"))))
=>
(assert (Fact (name "Пацаны")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Эмоциональный, Комедия, Супер-герои, Боевик -> Пацаны")))
(defrule rule85
(Fact(name "Эмоциональный"))
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Плоттвисты"))
(Fact(name "Ужасы"))
(not(exists (Fact (name "Черное зеркало"))))
=>
(assert (Fact (name "Черное зеркало")))
(assert (sendmessage "Эмоциональный, Иностранный, Серии по 40 минут, Плоттвисты, Ужасы -> Черное зеркало")))
(defrule rule86
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Комедия"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Дрянь"))))
=>
(assert (Fact (name "Дрянь")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Комедия, Эмоциональный -> Дрянь")))
(defrule rule87
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Комедия"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Бесстыжие"))))
=>
(assert (Fact (name "Бесстыжие")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Комедия, Эмоциональный -> Бесстыжие")))
(defrule rule88
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Эмоциональный"))
(Fact(name "Плоттвисты"))
(Fact(name "Боевик"))
(not(exists (Fact (name "Бумажный дом"))))
=>
(assert (Fact (name "Бумажный дом")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный, Плоттвисты, Боевик -> Бумажный дом")))
(defrule rule89
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Плоттвисты"))
(Fact(name "Эмоциональный"))
(Fact(name "Фантастика"))
(not(exists (Fact (name "Твин пикс"))))
=>
(assert (Fact (name "Твин пикс")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Плоттвисты, Эмоциональный, Фантастика -> Твин пикс")))
(defrule rule90
(Fact(name "Иностранный"))
(Fact(name "Эмоциональный"))
(Fact(name "Серии по 60 минут"))
(Fact(name "Приключения"))
(Fact(name "Боевик"))
(not(exists (Fact (name "Викинги"))))
=>
(assert (Fact (name "Викинги")))
(assert (sendmessage "Иностранный, Эмоциональный, Серии по 60 минут, Приключения, Боевик -> Викинги")))
(defrule rule91
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Великолепный век"))))
=>
(assert (Fact (name "Великолепный век")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный -> Великолепный век")))
(defrule rule92
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Постучись в мою дверь"))))
=>
(assert (Fact (name "Постучись в мою дверь")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный -> Постучись в мою дверь")))
(defrule rule93
(Fact(name "Иностранный"))
(Fact(name "Серии по 60 минут"))
(Fact(name "Фантастика"))
(Fact(name "Плоттвисты"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "11.22.63"))))
=>
(assert (Fact (name "11.22.63")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Фантастика, Плоттвисты, Эмоциональный -> 11.22.63")))
(defrule rule94
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Молокососы"))))
=>
(assert (Fact (name "Молокососы")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный -> Молокососы")))
(defrule rule95
(Fact(name "Иностранный"))
(Fact(name "Серии по 60 минут"))
(Fact(name "Фантастика"))
(Fact(name "Плоттвисты"))
(Fact(name "Боевик"))
(not(exists (Fact (name "Видоизменённый углерод"))))
=>
(assert (Fact (name "Видоизменённый углерод")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Фантастика, Плоттвисты, Боевик -> Видоизменённый углерод")))
(defrule rule96
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Эмоциональный"))
(Fact(name "Фэнтези"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Однажды в сказке"))))
=>
(assert (Fact (name "Однажды в сказке")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный, Фэнтези, Приключения -> Однажды в сказке")))
(defrule rule97
(Fact(name "Иностранный"))
(Fact(name "Серии по 40 минут"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name " Бухта Доусона"))))
=>
(assert (Fact (name " Бухта Доусона")))
(assert (sendmessage "Иностранный, Серии по 40 минут, Эмоциональный ->  Бухта Доусона")))
(defrule rule98
(Fact(name "Иностранный"))
(Fact(name "Серии по 60 минут"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Бриджертоны"))))
=>
(assert (Fact (name "Бриджертоны")))
(assert (sendmessage "Иностранный, Серии по 60 минут, Эмоциональный -> Бриджертоны")))
(defrule rule99
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Эмоциональный"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Мутанты Икс"))))
=>
(assert (Fact (name "Мутанты Икс")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Приключения -> Мутанты Икс")))
(defrule rule100
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Ужасы"))
(not(exists (Fact (name "Блэйд"))))
=>
(assert (Fact (name "Блэйд")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Ужасы -> Блэйд")))
(defrule rule101
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Агенты Щ.И.Т."))))
=>
(assert (Fact (name "Агенты Щ.И.Т.")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный -> Агенты Щ.И.Т.")))
(defrule rule102
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Криминал"))
(not(exists (Fact (name "Агент Картер"))))
=>
(assert (Fact (name "Агент Картер")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал -> Агент Картер")))
(defrule rule103
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Эмоциональный"))
(Fact(name "Криминал"))
(not(exists (Fact (name "Сверхспособности"))))
=>
(assert (Fact (name "Сверхспособности")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Криминал -> Сверхспособности")))
(defrule rule104
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Криминал"))
(Fact(name "Эмоциональный"))
(Fact(name "Фэнтези"))
(not(exists (Fact (name "Сорвиголова"))))
=>
(assert (Fact (name "Сорвиголова")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Эмоциональный, Фэнтези -> Сорвиголова")))
(defrule rule105
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Криминал"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Джессика Джонс"))))
=>
(assert (Fact (name "Джессика Джонс")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Эмоциональный -> Джессика Джонс")))
(defrule rule106
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Криминал"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Люк Кейдж"))))
=>
(assert (Fact (name "Люк Кейдж")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Эмоциональный -> Люк Кейдж")))
(defrule rule107
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Эмоциональный"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Плащ и Кинжал"))))
=>
(assert (Fact (name "Плащ и Кинжал")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Приключения -> Плащ и Кинжал")))
(defrule rule108
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Эмоциональный"))
(Fact(name "Плоттвисты"))
(not(exists (Fact (name "Легион"))))
=>
(assert (Fact (name "Легион")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Плоттвисты -> Легион")))
(defrule rule109
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Криминал"))
(Fact(name "Фэнтези"))
(not(exists (Fact (name "Железный кулак"))))
=>
(assert (Fact (name "Железный кулак")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Фэнтези -> Железный кулак")))
(defrule rule110
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Криминал"))
(Fact(name "Фэнтези"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Защитники"))))
=>
(assert (Fact (name "Защитники")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Фэнтези, Приключения -> Защитники")))
(defrule rule111
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Криминал"))
(Fact(name "Эмоциональный"))
(Fact(name "Плоттвисты"))
(not(exists (Fact (name "Каратель"))))
=>
(assert (Fact (name "Каратель")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Криминал, Эмоциональный, Плоттвисты -> Каратель")))
(defrule rule112
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Сверхлюди"))))
=>
(assert (Fact (name "Сверхлюди")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Приключения -> Сверхлюди")))
(defrule rule113
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Эмоциональный"))
(Fact(name "Фэнтези"))
(not(exists (Fact (name "Одарённые"))))
=>
(assert (Fact (name "Одарённые")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Фэнтези -> Одарённые")))
(defrule rule114
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Эмоциональный"))
(not(exists (Fact (name "Беглецы"))))
=>
(assert (Fact (name "Беглецы")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный -> Беглецы")))
(defrule rule115
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Фэнтези"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Локи"))))
=>
(assert (Fact (name "Локи")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Фэнтези, Приключения -> Локи")))
(defrule rule116
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Эмоциональный"))
(Fact(name "Ситком"))
(Fact(name "Фэнтези"))
(not(exists (Fact (name "Ванда/Вижн"))))
=>
(assert (Fact (name "Ванда/Вижн")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Ситком, Фэнтези -> Ванда/Вижн")))
(defrule rule117
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Эмоциональный"))
(Fact(name "Приключения"))
(not(exists (Fact (name "Сокол и Зимний солдат"))))
=>
(assert (Fact (name "Сокол и Зимний солдат")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Эмоциональный, Приключения -> Сокол и Зимний солдат")))
(defrule rule118
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(not(exists (Fact (name "WHIH: Новостной фронт"))))
=>
(assert (Fact (name "WHIH: Новостной фронт")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel -> WHIH: Новостной фронт")))
(defrule rule119
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(Fact(name "Приключения"))
(Fact(name "Эмоциональный"))
(Fact(name "Фэнтези"))
(not(exists (Fact (name "Агенты 'Щ.И.Т.': Йо-йо"))))
=>
(assert (Fact (name "Агенты 'Щ.И.Т.': Йо-йо")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel, Приключения, Эмоциональный, Фэнтези -> Агенты 'Щ.И.Т.': Йо-йо")))
(defrule rule120
(Fact(name "Серии по 40 минут"))
(Fact(name "Иностранный"))
(Fact(name "Marvel"))
(not(exists (Fact (name "Агенты «Щ.И.Т.»: Академия"))))
=>
(assert (Fact (name "Агенты «Щ.И.Т.»: Академия")))
(assert (sendmessage "Серии по 40 минут, Иностранный, Marvel -> Агенты «Щ.И.Т.»: Академия")))
(defrule rule121
(Fact(name "Про докторов"))
(not(exists (Fact (name "Медицинский"))))
=>
(assert (Fact (name "Медицинский")))
(assert (sendmessage "Про докторов -> Медицинский")))
(defrule rule122
(Fact(name "Детектив"))
(not(exists (Fact (name "Медицинский"))))
=>
(assert (Fact (name "Медицинский")))
(assert (sendmessage "Детектив -> Медицинский")))
