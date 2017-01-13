-- Verify that data has been inserted correctly
SELECT * FROM classes;
SELECT * FROM students;
SELECT * FROM enrollment;

-- Find first names and last names of all students
SELECT  first_name, last_name
FROM    students;

-- Find all students whose first name is John
SELECT  *
FROM    students
WHERE   first_name = 'John';

-- Find the pid, name and MAS201 credits of students registered for MAS201
SELECT  students.pid, students.first_name, students.last_name, enrollment.credits
FROM    students, enrollment, classes
WHERE   number = 'MAS201'
        AND students.id = student
        AND class = classes.id;

-- Find the other classes taken by MAS201 students
SELECT  c_others.name, first_name, last_name
FROM    classes AS c_201, enrollment AS e_201, students, enrollment AS e_others, classes AS c_others
WHERE   c_201.number = 'MAS201'
        AND c_201.id = e_201.class
        AND e_201.student = students.id
        AND students.id = e_others.student
        AND e_others.class = c_others.id
        AND NOT (c_others.number = 'MAS201')


-- Find the other classes taken by students who take MAS201 (just the classes)
SELECT  DISTINCT c_others.name
FROM    classes AS c_201, enrollment AS e_201, enrollment AS e_others, classes AS c_others
WHERE   c_201.number = 'MAS201'
        AND c_201.id = e_201.class
        AND e_201.student = e_others.student
        AND e_others.class = c_others.id
        AND NOT (c_others.number = 'MAS201')

-- Find the MAS201 students who take a Friday 11:00am class
SELECT  first_name, last_name
FROM    students, enrollment, classes
WHERE   students.id = student
        AND class = classes.id
        AND number = 'MAS201'
        AND students.id IN 
        (
            SELECT  student
            FROM    enrollment, classes
            WHERE   classes.id = class
            AND     date_code = 'F'
            AND     start_time = '11:00' 
        )   


or

SELECT  s.first_name, s.last_name
FROM    students s, enrollment e, classes c
WHERE   s.id = e.student
        AND e.class = c.id
        AND c.number = 'MAS201'
        AND EXISTS 
        (
            SELECT  1
            FROM    enrollment e1, classes c1
            WHERE   e1.student = s.id
		    c1.id = e1.class
            AND     c1.date_code = 'F'
            AND     c1.start_time = '11:00' 
        )   

or

SELECT  s.first_name, s.last_name
FROM    students s, enrollment e, classes c, enrollment e1, classes c1
WHERE   s.id = e.student
        AND e.class = c.id
        AND c.number = 'MAS201'
        AND e1.student = s.id
	AND c1.id = e1.class
        AND c1.date_code = 'F'
        AND c1.start_time = '11:00'    


-- Find the enrolled students and total credits for which they have registered
SELECT   students.id, first_name, last_name, SUM(credits)
FROM     students, enrollment
WHERE    students.id = enrollment.student
GROUP BY students.id, first_name, last_name

-- Find all students and total credits for which they have registered
—- Make sure to list unenrolled students with a total of 0 credits
—- Contrast with the query above

SELECT   students.id, first_name, last_name, SUM(credits)
FROM     students LEFT OUTER JOIN enrollment ON students.id = enrollment.student 
GROUP BY students.id, first_name, last_name


-- Find students who take every class that John Smith takes
SELECT  s.first_name, s.last_name
FROM    students s
WHERE   NOT EXISTS 
    (
        SELECT  * 
        FROM    classes AS c
        WHERE   EXISTS 
            (
                SELECT  *
                FROM    enrollment AS ej, students AS j
                WHERE   ej.class = c.id
                        AND ej.student = j.id
                        AND j.first_name = 'John'
                        AND j.last_name = 'Smith'
            )
                AND s.id NOT IN
            (
                SELECT  es.student
                FROM    enrollment AS es
                WHERE   es.class = c.id
            )
    )
