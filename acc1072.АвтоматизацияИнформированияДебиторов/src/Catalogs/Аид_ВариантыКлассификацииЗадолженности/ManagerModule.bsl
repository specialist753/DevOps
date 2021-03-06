#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// Выполняет первоначальное заполнение справочника
//
Процедура СоздатьВариантКлассификацииЗадолженностиПоУмолчаниюМонопольно() Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле
	|ИЗ
	|	Справочник.Аид_ВариантыКлассификацииЗадолженности КАК Аид_ВариантыКлассификацииЗадолженности");
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		// Режим отсрочки - по календарным дням
		ЭлементПоУмолчанию = Справочники.Аид_ВариантыКлассификацииЗадолженности.СоздатьЭлемент();
		
		ЭлементПоУмолчанию.Наименование = НСтр("ru = 'Стандартная классификация';
												|en = 'Standard classification'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 1;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 2;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru = 'От 1 до 2 дней';
													|en = '1 to 2 days'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 3;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 14;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru = 'От 3 до 14 дней';
													|en = '3 to 14 days'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 15;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 29;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru = 'От 15 до 29 дней';
													|en = '15 to 29 days'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 30;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 44;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru = 'От 30 до 44 дней';
													|en = '30 to 44 days'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 45;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 59;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru = 'От 45 до 59 дней';
													|en = '45 to 59 days'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 60;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 179;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru = 'От 60 до 179 дней';
													|en = '60 to 179 days'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 180;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 9999999999;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru = 'Свыше 180 дней';
													|en = 'Over 180 days'");
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЭлементПоУмолчанию);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
КонецПроцедуры

Функция ВариантКлассификацииЗадолженностиПоУмолчанию(ТолькоЕслиОдин = Ложь) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	ВариантКлассификацииЗадолженностиПоУмолчанию = Справочники.Аид_ВариантыКлассификацииЗадолженности.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Аид_ВариантыКлассификацииЗадолженности.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Аид_ВариантыКлассификацииЗадолженности КАК Аид_ВариантыКлассификацииЗадолженности
	|ГДЕ
	|	НЕ Аид_ВариантыКлассификацииЗадолженности.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ТолькоЕслиОдин И Выборка.Количество() = 1 
			Или Не ТолькоЕслиОдин Тогда
			ВариантКлассификацииЗадолженностиПоУмолчанию = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ВариантКлассификацииЗадолженностиПоУмолчанию;
КонецФункции

#КонецОбласти
