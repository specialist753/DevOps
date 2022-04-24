Процедура СоздатьПредопределенныеЭлементы() Экспорт 
	
	ПоставляемыеЭлементы = НовыйПоставляемыеЭлементы();
	ЗаполнитьОписанияПоставляемыхЭлементов(ПоставляемыеЭлементы);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Аид_СтатусыКонтрагентов.Ссылка КАК Ссылка,
		|	Аид_СтатусыКонтрагентов.Наименование КАК Наименование,
		|	Аид_СтатусыКонтрагентов.Предопределенный КАК Предопределенный,
		|	Аид_СтатусыКонтрагентов.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.Аид_СтатусыКонтрагентов КАК Аид_СтатусыКонтрагентов
		|ГДЕ
		|	Аид_СтатусыКонтрагентов.Предопределенный
		|";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивПоставляемыеЭлементы = ПоставляемыеЭлементы.НайтиСтроки(Новый Структура("Наименование", Выборка.Наименование));
			//МассивПоставляемыеЭлементы = ПоставляемыеЭлементы.НайтиСтроки(Новый Структура("Имя", Выборка.ИмяПредопределенныхДанных));
			Если МассивПоставляемыеЭлементы.Количество() тогда
				МассивПоставляемыеЭлементы[0].Создавать = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	МассивПоставляемыеЭлементыСоздать = ПоставляемыеЭлементы.НайтиСтроки(Новый Структура("Создавать", Истина));	
	
	Если МассивПоставляемыеЭлементыСоздать.Количество() тогда
		
		НачатьТранзакцию();
	
		Попытка
	
			Для Каждого СтрокаМассива из МассивПоставляемыеЭлементыСоздать Цикл
				НовыйЭлемент = Справочники.Аид_СтатусыКонтрагентов.СоздатьЭлемент();
				НовыйЭлемент.Наименование              = СтрокаМассива.Наименование;
				//НовыйЭлемент.ИмяПредопределенныхДанных = СтрокаМассива.Имя;
				//НовыйЭлемент.Предопределенный          = СтрокаМассива.Предопределенный;
				
				Попытка
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(НовыйЭлемент, Истина, Истина);
				Исключение
					ИнформацияОбОшибке = ИнформацияОбОшибке();
					
					ЗаписьЖурналаРегистрации(
						ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
						УровеньЖурналаРегистрации.Ошибка,
						НовыйЭлемент.Метаданные(),
						,// Данных еще нет
						ИнформацияОбОшибке);
					
					ВызватьИсключение;
				КонецПопытки;
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры	

Функция НовыйПоставляемыеЭлементы()
	
	ОписаниеЗначений = Новый ТаблицаЗначений;
	ОписаниеЗначений.Колонки.Добавить("Имя",              ОбщегоНазначения.ОписаниеТипаСтрока(150));
	ОписаниеЗначений.Колонки.Добавить("Наименование",     ОбщегоНазначения.ОписаниеТипаСтрока(150));
	ОписаниеЗначений.Колонки.Добавить("Предопределенный", Новый ОписаниеТипов("Булево"));
	ОписаниеЗначений.Колонки.Добавить("Создавать",        Новый ОписаниеТипов("Булево"));
	
	Возврат ОписаниеЗначений;
	
КонецФункции

Процедура ЗаполнитьОписанияПоставляемыхЭлементов(ОписаниеЭлементов) Экспорт
	
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ПлатитПоСчетам",
		"Платит по своим счетам",
		Ложь,
		Истина);
	
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ДопускаетПросрочки",
		"Допускает просрочки",
		Ложь,
		Истина);
		
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ПросрочкаБолее90",
		"Допускает просрочки более 90 дней",
		Ложь,
		Истина);

КонецПроцедуры

Функция ДобавитьОписаниеПоставляемогоЭлемента(ОписаниеЭлементов, Имя, Наименование, Предопределенный = Ложь, Создавать = Ложь)
	
	ОписаниеЗначения = ОписаниеЭлементов.Добавить();
	ОписаниеЗначения.Имя              = Имя;
	ОписаниеЗначения.Наименование     = Наименование;
	ОписаниеЗначения.Предопределенный = Ложь;  //Предопределенный;
	ОписаниеЗначения.Создавать        = Создавать;
	
	Возврат ОписаниеЗначения;
	
КонецФункции
	