
&НаКлиенте
Процедура Аид_КонтактноеЛицоАИДВместо(Команда)
	ТекДанные = Элементы.Список.ТекущаяСтрока;
	Если ТекДанные = неопределено Тогда
		Возврат;
	КонецЕсли;
	Аид_КонтактноеЛицоАИДНаСервере(ТекДанные);
	Элементы.Список.Обновить();

КонецПроцедуры

&НаСервере
Процедура Аид_КонтактноеЛицоАИДНаСервере(КонтактноеЛицо)
	ЗаписьКонтЛицоАИД = РегистрыСведений.Аид_КонтактныеЛицаКонтрагентов.СоздатьМенеджерЗаписи();
	ЗаписьКонтЛицоАИД.Контрагент = КонтактноеЛицо.ОбъектВладелец;
	ЗаписьКонтЛицоАИД.КонтактноеЛицо = КонтактноеЛицо;
	ЗаписьКонтЛицоАИД.Записать(Истина);
	Аид_УстановитьУсловноеОформление(КонтактноеЛицо.ОбъектВладелец);
КонецПроцедуры

Процедура Аид_УстановитьУсловноеОформление(Контрагент) Экспорт
	Список.УсловноеОформление.Элементы.Очистить();
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Аид_ПолучитьКонтактноеЛицоПартнера(Контрагент);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина,,,,));
КонецПроцедуры

Функция Аид_ПолучитьКонтактноеЛицоПартнера(Контрагент) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.Текст = "ВЫБРАТЬ
	|	Аид_КонтактныеЛицаКонтрагентов.КонтактноеЛицо КАК КонтактноеЛицо
	|ИЗ
	|	РегистрСведений.Аид_КонтактныеЛицаКонтрагентов КАК Аид_КонтактныеЛицаКонтрагентов
	|ГДЕ
	|	Аид_КонтактныеЛицаКонтрагентов.Контрагент = &Контрагент";
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Возврат Результат.КонтактноеЛицо;
	КонецЕсли;
	Возврат Справочники.КонтактныеЛица.ПустаяСсылка();
КонецФункции



&НаСервере
Процедура Аид_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	Аид_УстановитьУсловноеОформление(Параметры.Отбор.ОбъектВладелец);

КонецПроцедуры

