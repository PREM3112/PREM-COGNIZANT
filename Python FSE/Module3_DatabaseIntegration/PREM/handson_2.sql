-- ============================================================
-- HANDS-ON 2: WRITING SQL QUERIES - DML, JOINS & AGGREGATIONS
-- ============================================================
-- Name: Your Name
-- Date: 2026-07-02
-- Database: MySQL
-- Path: Python FSE/Database integration/YourName/hands_on_2.sql
-- ============================================================

USE college_db;

-- ============================================================
-- TASK 1: INSERT, UPDATE AND DELETE DATA
-- ============================================================

-- 15. Insert sample data

-- Insert departments
INSERT INTO departments (dept_name, head_of_dept, budget) VALUES
 ('Computer Science', 'Dr. Ramesh Kumar', 850000.00),
 ('Electronics', 'Dr. Priya Nair', 620000.00),
 ('Mechanical', 'Dr. Suresh Iyer', 540000.00),
 ('Civil', 'Dr. Ananya Sharma', 430000.00);

-- Insert students
INSERT INTO students (first_name, last_name, email, date_of_birth, department_id, enrollment_year) VALUES
 ('Arjun', 'Mehta', 'arjun.mehta@college.edu', '2003-04-12', 1, 2022),
 ('Priya', 'Suresh', 'priya.suresh@college.edu', '2003-07-25', 1, 2022),
 ('Rohan', 'Verma', 'rohan.verma@college.edu', '2002-11-08', 2, 2021),
 ('Sneha', 'Patel', 'sneha.patel@college.edu', '2004-01-30', 3, 2023),
 ('Vikram', 'Das', 'vikram.das@college.edu', '2003-09-14', 1, 2022),
 ('Kavya', 'Menon', 'kavya.menon@college.edu', '2002-05-17', 2, 2021),
 ('Aditya', 'Singh', 'aditya.singh@college.edu', '2004-03-22', 4, 2023),
 ('Deepika','Rao', 'deepika.rao@college.edu', '2003-08-09', 1, 2022);

-- Insert courses
INSERT INTO courses (course_name, course_code, credits, department_id) VALUES
 ('Data Structures & Algorithms', 'CS101', 4, 1),
 ('Database Management Systems', 'CS102', 3, 1),
 ('Object Oriented Programming', 'CS103', 4, 1),
 ('Circuit Theory', 'EC101', 3, 2),
 ('Thermodynamics', 'ME101', 3, 3);

-- Insert enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
 (1, 1, '2022-07-01', 'A'), (1, 2, '2022-07-01', 'B'),
 (2, 1, '2022-07-01', 'B'), (2, 3, '2022-07-01', 'A'),
 (3, 4, '2021-07-01', 'A'), (4, 5, '2023-07-01', NULL),
 (5, 1, '2022-07-01', 'C'), (5, 2, '2022-07-01', 'A'),
 (6, 4, '2021-07-01', 'B'), (7, 5, '2023-07-01', NULL),
 (8, 1, '2022-07-01', 'A'), (8, 3, '2022-07-01', 'B');

-- Insert professors
INSERT INTO professors (prof_name, email, department_id, salary) VALUES 
 ('Dr. Anand Krishnan', 'anand.k@college.edu', 1, 95000.00),
 ('Dr. Meena Pillai', 'meena.p@college.edu', 1, 88000.00),
 ('Dr. Sunil Rajan', 'sunil.r@college.edu', 2, 82000.00),
 ('Dr. Latha Gopal', 'latha.g@college.edu', 3, 79000.00),
 ('Dr. Kartik Bose', 'kartik.b@college.edu', 4, 76000.00);

-- 16. Insert two additional students
INSERT INTO students (first_name, last_name, email, date_of_birth, department_id, enrollment_year) VALUES
 ('Amit', 'Sharma', 'amit.sharma@college.edu', '2003-12-01', 2, 2022),
 ('Neha', 'Reddy', 'neha.reddy@college.edu', '2004-06-15', 3, 2023);

-- 17. Update grade for student_id = 5, course_id = 1 from 'C' to 'B'
UPDATE enrollments SET grade = 'B' 
WHERE student_id = 5 AND course_id = 1;

-- 18. Delete enrollments where grade IS NULL
DELETE FROM enrollments WHERE grade IS NULL;

-- 19. Verify row counts
SELECT 'Total Students' AS Description, COUNT(*) AS Count FROM students
UNION ALL
SELECT 'Total Enrollments', COUNT(*) FROM enrollments;

-- ============================================================
-- TASK 2: SINGLE-TABLE QUERIES AND FILTERING
-- ============================================================

-- 20. Retrieve all students enrolled in 2022, ordered by last_name
SELECT * FROM students 
WHERE enrollment_year = 2022 
ORDER BY last_name;

-- 21. Find all courses with more than 3 credits, sorted by credits descending
SELECT * FROM courses 
WHERE credits > 3 
ORDER BY credits DESC;

-- 22. List all professors whose salary is between 80,000 and 95,000
SELECT * FROM professors 
WHERE salary BETWEEN 80000 AND 95000;

-- 23. Find all students whose email ends with '@college.edu'
SELECT * FROM students 
WHERE email LIKE '%@college.edu';

-- 24. Count the total number of students per enrollment_year
SELECT enrollment_year, COUNT(*) AS student_count 
FROM students 
GROUP BY enrollment_year
ORDER BY enrollment_year;

-- ============================================================
-- TASK 3: MULTI-TABLE JOINS
-- ============================================================

-- 25. List each student's full name alongside the name of their department
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name, 
       d.dept_name 
FROM students s 
INNER JOIN departments d ON s.department_id = d.department_id
ORDER BY s.last_name;

-- 26. Show each enrollment along with the student's name and the course name
SELECT e.enrollment_id, 
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_name,
       e.grade,
       e.enrollment_date
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses c ON e.course_id = c.course_id
ORDER BY e.enrollment_id;

-- 27. Find all students who are NOT enrolled in any course
SELECT s.student_id, s.first_name, s.last_name, s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

-- 28. Display every course along with the number of students enrolled in it
SELECT c.course_id,
       c.course_name, 
       c.course_code,
       COUNT(e.student_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.course_code
ORDER BY enrollment_count DESC;

-- 29. List each department along with its professors and their salaries
SELECT d.dept_name, 
       p.prof_name, 
       p.salary,
       p.email
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
ORDER BY d.dept_name, p.salary DESC;

-- ============================================================
-- TASK 4: AGGREGATIONS AND GROUPING
-- ============================================================

-- 30. Calculate the total number of enrollments per course
SELECT c.course_name, 
       c.course_code,
       COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.course_code
ORDER BY enrollment_count DESC;

-- 31. Find the average salary of professors per department
SELECT d.dept_name, 
       ROUND(AVG(p.salary), 2) AS avg_salary,
       COUNT(p.professor_id) AS professor_count
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.dept_name
ORDER BY avg_salary DESC;

-- 32. Find all departments where the total budget exceeds 600,000
SELECT * FROM departments 
WHERE budget > 600000
ORDER BY budget DESC;

-- 33. Show the grade distribution for course CS101
SELECT e.grade, 
       COUNT(*) AS grade_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM enrollments WHERE course_id = (SELECT course_id FROM courses WHERE course_code = 'CS101')), 2) AS percentage
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_code = 'CS101'
GROUP BY e.grade
ORDER BY e.grade;

-- 34. Using HAVING, list departments where more than 2 students are enrolled
SELECT d.dept_name, 
       COUNT(DISTINCT s.student_id) AS student_count
FROM departments d
INNER JOIN students s ON d.department_id = s.department_id
INNER JOIN enrollments e ON s.student_id = e.student_id
GROUP BY d.department_id, d.dept_name
HAVING COUNT(DISTINCT s.student_id) > 2
ORDER BY student_count DESC;

-- ============================================================
-- BONUS: Additional Verification Queries
-- ============================================================

-- Verify all tables have data
SELECT 'Departments' AS Table_Name, COUNT(*) AS Row_Count FROM departments
UNION ALL
SELECT 'Students', COUNT(*) FROM students
UNION ALL
SELECT 'Courses', COUNT(*) FROM courses
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM enrollments
UNION ALL
SELECT 'Professors', COUNT(*) FROM professors;

-- Show sample data from each table
SELECT '=== DEPARTMENTS ===' AS '';
SELECT * FROM departments;

SELECT '=== STUDENTS ===' AS '';
SELECT * FROM students;

SELECT '=== COURSES ===' AS '';
SELECT * FROM courses;

SELECT '=== ENROLLMENTS ===' AS '';
SELECT * FROM enrollments;

SELECT '=== PROFESSORS ===' AS '';
SELECT * FROM professors;

-- ============================================================
-- EXPECTED OUTCOMES SUMMARY
-- ============================================================
/*
============================================================
EXPECTED OUTCOMES FOR EACH QUERY
============================================================

TASK 1 - DML Operations:
- students: 10 rows (8 original + 2 inserted)
- enrollments: 10 rows (12 original - 2 deleted with NULL grades)
- student_id=5, course_id=1 grade updated to 'B'

TASK 2 - Single-Table Queries:
- Query 20: 6 students (enrollment_year = 2022)
- Query 21: 2 courses (credits > 3)
- Query 22: 3 professors (salary between 80,000-95,000)
- Query 23: 10 students (all have @college.edu email)
- Query 24: 3 rows (2021: 2, 2022: 6, 2023: 2)

TASK 3 - Multi-Table Joins:
- Query 25: 10 students with department names
- Query 26: 10 enrollments with student and course details
- Query 27: 0 students (all students have at least one enrollment)
- Query 28: 5 courses with enrollment counts
- Query 29: 4 departments with professors

TASK 4 - Aggregations and Grouping:
- Query 30: 5 courses with enrollment counts
- Query 31: 4 departments with average salaries
- Query 32: 2 departments (Computer Science, Electronics)
- Query 33: 3 grades (A:3, B:1, C:1)
- Query 34: 1 department (Computer Science)
============================================================
*/