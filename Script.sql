USE master;
GO
IF DB_ID('CoffeeShopGraph') IS NOT NULL DROP DATABASE CoffeeShopGraph;
CREATE DATABASE CoffeeShopGraph;
GO
USE CoffeeShopGraph;
GO

CREATE TABLE Barista (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    experience_years INT NOT NULL,
    city NVARCHAR(30) NOT NULL
) AS NODE;

CREATE TABLE Supplier (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    country NVARCHAR(50) NOT NULL,
    specialty NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Customer (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    loyalty_level NVARCHAR(20) NOT NULL,
    registration_date DATE NOT NULL
) AS NODE;
GO

CREATE TABLE WorksWith (
    start_date DATE NOT NULL,
    volume_kg_per_month INT NOT NULL
) AS EDGE;
ALTER TABLE WorksWith ADD CONSTRAINT EC_WorksWith CONNECTION (Barista TO Supplier);

CREATE TABLE Serves (
    service_date DATE NOT NULL,
    rating INT NOT NULL
) AS EDGE;
ALTER TABLE Serves ADD CONSTRAINT EC_Serves CONNECTION (Barista TO Customer);

CREATE TABLE Prefers (
    preference_level INT NOT NULL,
    since_date DATE NOT NULL
) AS EDGE;
ALTER TABLE Prefers ADD CONSTRAINT EC_Prefers CONNECTION (Customer TO Supplier);
GO

INSERT INTO Barista (id, name, experience_years, city)
VALUES
(1, N'Анна',     5, N'Минск'),
(2, N'Борис',    3, N'Минск'),
(3, N'Виктория', 7, N'Гродно'),
(4, N'Глеб',     2, N'Брест'),
(5, N'Диана',    4, N'Гомель'),
(6, N'Евгений',  8, N'Минск'),
(7, N'Жанна',    1, N'Витебск'),
(8, N'Захар',    6, N'Могилёв'),
(9, N'Ирина',    9, N'Гродно'),
(10,N'Кирилл',  3, N'Брест');
GO

INSERT INTO Supplier (id, name, country, specialty)
VALUES
(1, N'Brazil Santos',       N'Бразилия', N'Арабика'),
(2, N'Colombia Supremo',   N'Колумбия', N'Арабика'),
(3, N'Ethiopia Yirgacheffe',N'Эфиопия',  N'Арабика'),
(4, N'Vietnam Robusta',     N'Вьетнам',  N'Робуста'),
(5, N'Guatemala Antigua',   N'Гватемала',N'Арабика'),
(6, N'India Monsooned',    N'Индия',    N'Монсунный кофе'),
(7, N'Kenya AA',           N'Кения',    N'Арабика'),
(8, N'Sumatra Mandheling', N'Индонезия',N'Арабика'),
(9, N'Costa Rica Tarrazu', N'Коста-Рика',N'Арабика'),
(10,N'Jamaica Blue Mountain',N'Ямайка',  N'Арабика');
GO

INSERT INTO Customer (id, name, loyalty_level, registration_date)
VALUES
(1, N'Иван',      N'Gold',   '2024-01-15'),
(2, N'Мария',     N'Silver', '2024-02-20'),
(3, N'Пётр',      N'Bronze', '2024-03-10'),
(4, N'Светлана',  N'Gold',   '2024-01-05'),
(5, N'Алексей',   N'Silver', '2024-04-01'),
(6, N'Ольга',     N'Bronze', '2024-05-12'),
(7, N'Дмитрий',   N'Gold',   '2023-12-01'),
(8, N'Елена',     N'Silver', '2024-06-18'),
(9, N'Сергей',    N'Bronze', '2024-07-22'),
(10,N'Татьяна',   N'Gold',   '2023-11-10');
GO

INSERT INTO WorksWith ($from_id, $to_id, start_date, volume_kg_per_month)
VALUES
((SELECT $node_id FROM Barista WHERE id = 1), (SELECT $node_id FROM Supplier WHERE id = 1), '2024-01-01', 120),
((SELECT $node_id FROM Barista WHERE id = 1), (SELECT $node_id FROM Supplier WHERE id = 3), '2024-02-01', 80),
((SELECT $node_id FROM Barista WHERE id = 2), (SELECT $node_id FROM Supplier WHERE id = 2), '2024-01-15', 150),
((SELECT $node_id FROM Barista WHERE id = 3), (SELECT $node_id FROM Supplier WHERE id = 1), '2024-03-01', 100),
((SELECT $node_id FROM Barista WHERE id = 3), (SELECT $node_id FROM Supplier WHERE id = 4), '2024-04-01', 90),
((SELECT $node_id FROM Barista WHERE id = 4), (SELECT $node_id FROM Supplier WHERE id = 5), '2024-02-10', 200),
((SELECT $node_id FROM Barista WHERE id = 5), (SELECT $node_id FROM Supplier WHERE id = 6), '2024-05-01', 110),
((SELECT $node_id FROM Barista WHERE id = 6), (SELECT $node_id FROM Supplier WHERE id = 7), '2024-01-20', 130),
((SELECT $node_id FROM Barista WHERE id = 7), (SELECT $node_id FROM Supplier WHERE id = 8), '2024-06-01', 70),
((SELECT $node_id FROM Barista WHERE id = 8), (SELECT $node_id FROM Supplier WHERE id = 9), '2024-07-01', 160),
((SELECT $node_id FROM Barista WHERE id = 9), (SELECT $node_id FROM Supplier WHERE id = 10),'2024-08-01', 50),
((SELECT $node_id FROM Barista WHERE id = 10),(SELECT $node_id FROM Supplier WHERE id = 2), '2024-09-01', 140);
GO

INSERT INTO Serves ($from_id, $to_id, service_date, rating)
VALUES
((SELECT $node_id FROM Barista WHERE id = 1), (SELECT $node_id FROM Customer WHERE id = 1), '2024-10-01', 9),
((SELECT $node_id FROM Barista WHERE id = 1), (SELECT $node_id FROM Customer WHERE id = 2), '2024-10-02', 8),
((SELECT $node_id FROM Barista WHERE id = 2), (SELECT $node_id FROM Customer WHERE id = 3), '2024-10-03', 7),
((SELECT $node_id FROM Barista WHERE id = 3), (SELECT $node_id FROM Customer WHERE id = 1), '2024-10-04', 10),
((SELECT $node_id FROM Barista WHERE id = 3), (SELECT $node_id FROM Customer WHERE id = 4), '2024-10-05', 9),
((SELECT $node_id FROM Barista WHERE id = 4), (SELECT $node_id FROM Customer WHERE id = 5), '2024-10-06', 8),
((SELECT $node_id FROM Barista WHERE id = 5), (SELECT $node_id FROM Customer WHERE id = 6), '2024-10-07', 7),
((SELECT $node_id FROM Barista WHERE id = 6), (SELECT $node_id FROM Customer WHERE id = 7), '2024-10-08', 9),
((SELECT $node_id FROM Barista WHERE id = 7), (SELECT $node_id FROM Customer WHERE id = 8), '2024-10-09', 6),
((SELECT $node_id FROM Barista WHERE id = 8), (SELECT $node_id FROM Customer WHERE id = 9), '2024-10-10', 8),
((SELECT $node_id FROM Barista WHERE id = 9), (SELECT $node_id FROM Customer WHERE id = 10),'2024-10-11', 10),
((SELECT $node_id FROM Barista WHERE id = 10),(SELECT $node_id FROM Customer WHERE id = 1), '2024-10-12', 9);
GO

INSERT INTO Prefers ($from_id, $to_id, preference_level, since_date)
VALUES
((SELECT $node_id FROM Customer WHERE id = 1), (SELECT $node_id FROM Supplier WHERE id = 1), 5, '2024-01-20'),
((SELECT $node_id FROM Customer WHERE id = 1), (SELECT $node_id FROM Supplier WHERE id = 3), 4, '2024-02-10'),
((SELECT $node_id FROM Customer WHERE id = 2), (SELECT $node_id FROM Supplier WHERE id = 2), 4, '2024-03-01'),
((SELECT $node_id FROM Customer WHERE id = 3), (SELECT $node_id FROM Supplier WHERE id = 4), 3, '2024-04-15'),
((SELECT $node_id FROM Customer WHERE id = 4), (SELECT $node_id FROM Supplier WHERE id = 5), 5, '2024-05-20'),
((SELECT $node_id FROM Customer WHERE id = 5), (SELECT $node_id FROM Supplier WHERE id = 6), 4, '2024-06-10'),
((SELECT $node_id FROM Customer WHERE id = 6), (SELECT $node_id FROM Supplier WHERE id = 7), 3, '2024-07-01'),
((SELECT $node_id FROM Customer WHERE id = 7), (SELECT $node_id FROM Supplier WHERE id = 8), 5, '2024-08-15'),
((SELECT $node_id FROM Customer WHERE id = 8), (SELECT $node_id FROM Supplier WHERE id = 9), 4, '2024-09-01'),
((SELECT $node_id FROM Customer WHERE id = 9), (SELECT $node_id FROM Supplier WHERE id = 10),3, '2024-10-01'),
((SELECT $node_id FROM Customer WHERE id = 10),(SELECT $node_id FROM Supplier WHERE id = 2), 5, '2024-11-01'),
((SELECT $node_id FROM Customer WHERE id = 3), (SELECT $node_id FROM Supplier WHERE id = 1), 2, '2024-12-01');
GO

SELECT
    Bar.name AS barista,
    Cust.name AS customer,
    Supp.name AS preferred_supplier,
    Pref.preference_level
FROM Barista AS Bar,
     Serves AS S,
     Customer AS Cust,
     Prefers AS Pref,
     Supplier AS Supp
WHERE MATCH(Bar-(S)->Cust-(Pref)->Supp)
  AND Bar.name = N'Анна';

SELECT
    Bar.name AS barista,
    Cust.name AS customer,
    Supp.name AS supplier,
    W.volume_kg_per_month,
    Pref.preference_level
FROM Barista AS Bar,
     WorksWith AS W,
     Supplier AS Supp,
     Prefers AS Pref,
     Customer AS Cust,
     Serves AS S
WHERE MATCH(Bar-(W)->Supp<-(Pref)-Cust AND Bar-(S)->Cust)
  AND Supp.name = N'Brazil Santos';

SELECT DISTINCT
    Supp.name AS supplier,
    Supp.country
FROM Customer AS Cust,
     Serves AS S,
     Barista AS Bar,
     WorksWith AS W,
     Supplier AS Supp
WHERE MATCH(Cust<-(S)-Bar-(W)->Supp)
  AND Cust.name = N'Иван';

SELECT
    Bar.name AS barista,
    Cust.name AS customer,
    Supp.name AS supplier,
    Supp.country
FROM Barista AS Bar,
     Serves AS S,
     Customer AS Cust,
     Prefers AS Pref,
     Supplier AS Supp
WHERE MATCH(Bar-(S)->Cust-(Pref)->Supp)
  AND Supp.country = N'Эфиопия'
ORDER BY Bar.name;

SELECT
    Cust.name AS customer,
    Cust.loyalty_level,
    Bar.name AS barista,
    Bar.experience_years,
    Supp.name AS preferred_supplier,
    Pref.preference_level
FROM Customer AS Cust,
     Serves AS S,
     Barista AS Bar,
     Prefers AS Pref,
     Supplier AS Supp
WHERE MATCH(Cust<-(S)-Bar AND Cust-(Pref)->Supp)
  AND Bar.experience_years > 5
ORDER BY Pref.preference_level DESC;

DECLARE @FromCustomer NVARCHAR(30) = N'Иван';
DECLARE @ToCustomer   NVARCHAR(30) = N'Татьяна';

WITH T1 AS (
    SELECT
        Person1.name AS StartName,
        STRING_AGG(ISNULL(Person2.name, '?'), ' -> ') WITHIN GROUP (GRAPH PATH) AS Path,
        LAST_VALUE(Person2.name) WITHIN GROUP (GRAPH PATH) AS LastNode
    FROM
        Customer           AS Person1,
        Prefers FOR PATH   AS Pref,
        Supplier FOR PATH  AS Supp,
        WorksWith FOR PATH AS W,
        Barista FOR PATH   AS Bar,
        Serves FOR PATH    AS S,
        Customer FOR PATH  AS Person2
    WHERE MATCH(
        SHORTEST_PATH(
            Person1(-(Pref)->Supp<-(W)-Bar-(S)->Person2)+
        )
    )
    AND Person1.name = @FromCustomer
)
SELECT StartName, Path
FROM T1
WHERE LastNode = @ToCustomer;

DECLARE @FromCustomer2 NVARCHAR(30) = N'Иван';
DECLARE @ToCustomer2   NVARCHAR(30) = N'Дмитрий';

WITH T2 AS (
    SELECT
        Person1.name AS StartName,
        STRING_AGG(ISNULL(Person2.name, '?'), ' --> ') WITHIN GROUP (GRAPH PATH) AS Path,
        LAST_VALUE(Person2.name) WITHIN GROUP (GRAPH PATH) AS LastNode
    FROM
        Customer           AS Person1,
        Prefers FOR PATH   AS Pref,
        Supplier FOR PATH  AS Supp,
        WorksWith FOR PATH AS W,
        Barista FOR PATH   AS Bar,
        Serves FOR PATH    AS S,
        Customer FOR PATH  AS Person2
    WHERE MATCH(
        SHORTEST_PATH(
            Person1(-(Pref)->Supp<-(W)-Bar-(S)->Person2){1,3}
        )
    )
    AND Person1.name = @FromCustomer2
)
SELECT StartName, Path
FROM T2
WHERE LastNode = @ToCustomer2;