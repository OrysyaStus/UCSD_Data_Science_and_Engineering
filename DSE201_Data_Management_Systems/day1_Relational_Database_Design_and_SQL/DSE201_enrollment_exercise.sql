-- Find first names and last names of all students
SELECT 
	first_name,
    last_name
FROM students
ORDER BY first_name

-- Find all students whose first name is John (list all their attributes)
SELECT *
FROM students
WHERE first_name = 'John'

-- Find the pid, name and MAS201 credits of students registered for MAS201
SELECT 
	S.pid,
    S.first_name,
    S.last_name,
    E.credits
FROM students AS S, enrollment AS E, classes AS C
WHERE C.number = 'MAS201' AND S.id = E.student AND E.class = C.id

-- Find the other classes taken by students who take MAS201 (list just the class names, uniquely)
SELECT DISTINCT C.name
FROM students AS S, enrollment AS E, classes AS C 
WHERE EXISTS (
    SELECT S.pid
    FROM students AS S, enrollment AS E, classes AS C
    WHERE C.number = 'MAS201' AND S.id = E.student AND E.class = C.id)
AND S.id = E.student AND E.class = C.id

-- Find the MAS201 students who take a Friday 11:00am class
SELECT *
FROM students AS S, enrollment AS E, classes AS C 
WHERE pid IN (
    SELECT S.pid
    FROM students AS S, enrollment AS E, classes AS C
    WHERE C.number = 'MAS201' AND S.id = E.student AND E.class = C.id) 
AND S.id = E.student AND E.class = C.id AND C.date_code = 'F' AND C.start_time = '11:00:00'

-- Find the enrolled students and total credits for which they have registered (output student id, first and last name, and total credits)
SELECT
	S.pid,
    S.first_name,
    S.last_name,
    SUM(E.credits) AS total_credits
FROM students AS S, enrollment AS E, classes AS C
WHERE S.id = E.student AND E.class = C.id
GROUP BY (S.pid, S.first_name, S.last_name)

