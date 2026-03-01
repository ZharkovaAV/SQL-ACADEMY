/*
Задание #1
Имена всех людей
Вывести имена всех людей, которые есть в базе данных авиакомпаний
Поля в результирующей таблице:
name
*/

SELECT name
FROM Passenger

/*
Задание #2
Названия всех авиакомпаний
Вывести названия всеx авиакомпаний
Поля в результирующей таблице:
name
*/

SELECT name
FROM Company

/*
Задание #3
Рейсы из Москвы
Вывести все рейсы, совершенные из Москвы
Поля в результирующей таблице:
*
*/

SELECT *
FROM Trip
WHERE town_from = 'Moscow'

/*
Задание #4
Имена, заканчивающиеся на "man"
Вывести имена людей, которые заканчиваются на "man"
Поля в результирующей таблице:
name
*/

SELECT name
FROM Passenger
WHERE name LIKE '%man'

/*
Задание #5
Количество рейсов на TU-134
Вывести количество рейсов, совершенных на TU-134
Используйте конструкцию "as count" для агрегатной функции подсчета количества рейсов. Это необходимо для корректной проверки.
Поля в результирующей таблице:
count
*/

SELECT COUNT(*) AS COUNT
FROM Trip
WHERE plane = 'TU-134'

/*
Задание #6
Компании, летавшие на Boeing
Какие компании совершали перелеты на Boeing
Поля в результирующей таблице:
name
*/

SELECT Company.name
FROM Trip
	LEFT JOIN Company ON Company.id = Trip.company
WHERE plane = 'Boeing'
GROUP BY company

/*
Задание #7
Самолеты, летящие в Москву
Вывести все названия самолётов, на которых можно улететь в Москву (Moscow)
Поля в результирующей таблице:
plane
*/

SELECT plane
FROM Trip
WHERE town_to = 'Moscow'
GROUP BY plane

/*
Задание #8
Полёты из Парижа
В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?
Используйте конструкцию "as flight_time" для вывода необходимого времени. Это необходимо для корректной проверки.
Формат для вывода времени: HH:MM:SS
Поля в результирующей таблице:
town_to
flight_time
*/

SELECT town_to,
	TIMEDIFF(time_in, time_out) AS flight_time
FROM Trip
WHERE town_from = 'Paris'

/*
Задание #9
Компании с рейсами из Владивостока
Какие компании организуют перелеты из Владивостока (Vladivostok)?
Поля в результирующей таблице:
name
*/

SELECT Company.name
FROM Trip
	LEFT JOIN Company ON Trip.company = Company.id
WHERE town_from = 'Vladivostok'
GROUP BY Company.name

/*
Задание #10
Вылеты в определенное время
Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.
Поля в результирующей таблице:
*
*/

SELECT *
FROM Trip
WHERE time_out BETWEEN '1900-01-01T10:00:00.000Z' AND '1900-01-01T14:00:00.000Z'

/*
Задание #11
Пассажиры с самым длинным ФИО
Выведите пассажиров с самым длинным ФИО. Пробелы, дефисы и точки считаются частью имени.
Поля в результирующей таблице:
name
*/

SELECT name
FROM passenger
WHERE LENGTH(name) = (
    SELECT MAX(LENGTH(name))
    FROM passenger)

/*
Задание #12
Количество пассажиров на рейсах
Выведите идентификаторы всех рейсов и количество пассажиров на них. Обратите внимание, что на каких-то рейсах пассажиров может не быть. В этом случае выведите число "0".
Используйте конструкцию "as count" для агрегатной функции подсчета количества пассажиров. Это необходимо для корректной проверки.
Поля в результирующей таблице:
id
count
*/

SELECT Trip.id, COUNT(Pass_in_trip.id) AS count
FROM Trip
LEFT JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
GROUP BY Trip.id

/*
Задание #13
Полные тёзки
Вывести имена людей, у которых есть полный тёзка среди пассажиров
Поля в результирующей таблице:
name
*/

SELECT name
FROM Passenger
GROUP BY name
HAVING COUNT(name) > 1

/*
Задание #14
Города, которые посетил Bruce Willis
В какие города летал Bruce Willis
Поля в результирующей таблице:
town_to
*/

SELECT town_to
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
	JOIN trip ON trip.id = Pass_in_trip.trip
WHERE name = 'Bruce Willis'

/*
Задание #15
Прибытие Steve Martin в Лондон
Выведите идентификатор пассажира Стив Мартин (Steve Martin) и дату и время его прилёта в Лондон (London)
Поля в результирующей таблице:
id
time_in
*/

SELECT Passenger.id,
	Trip.time_in
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
	JOIN Trip ON Pass_in_trip.trip = Trip.id
WHERE Passenger.name = 'Steve Martin'
	AND Trip.town_to = 'London'

/*
Задание #16
Сортировка пассажиров по количеству полетов
Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, совершивших хотя бы 1 полет.
Используйте конструкцию "as count" для агрегатной функции подсчета количества перелетов. Это необходимо для корректной проверки.
Поля в результирующей таблице:
name
count
*/
	
SELECT name,
	COUNT(name) AS COUNT
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
	JOIN Trip ON Pass_in_trip.trip = Trip.id
GROUP BY name
ORDER BY COUNT DESC,
	name ASC

/*
Задание #17
Траты членов семьи в 2005 году
Определить, сколько потратил в 2005 году каждый из членов семьи. В результирующей выборке не выводите тех членов семьи, которые ничего не потратили.
Используйте конструкцию "as costs" для отображения затраченной суммы членом семьи. Это необходимо для корректной проверки.
Поля в результирующей таблице:
member_name
status
costs
*/

SELECT member_name,
	STATUS,
	SUM(unit_price * amount) AS costs
FROM FamilyMembers
	JOIN Payments ON FamilyMembers.member_id = Payments.family_member
WHERE YEAR(DATE) = 2005
GROUP BY member_name,
	STATUS

/*
Задание #18
Самый старший человек
Выведите имя самого старшего человека. Если таких несколько, то выведите их всех.
Поля в результирующей таблице:
member_name
*/

SELECT member_name
FROM FamilyMembers
WHERE birthday = (
		SELECT MIN(birthday)
		FROM FamilyMembers
	)
