-- ============================================================
-- HANDS-ON 3: ADVANCED SQL - COMPLETE WORKING CODE
-- ============================================================
-- Name: Your Name
-- Date: 2026-07-02
-- Database: MySQL
-- ============================================================

USE college_db;

-- ============================================================
-- TASK 1: SUBQUERIES
-- ============================================================

-- 35. Students enrolled in more courses than average
SELECT s.student_id,
       s.first_name, 
       s.last_name, 
       COUNT(e.course_id) AS course_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) > (
    SELECT AVG(course_count)
    FROM (
        SELECT student_id, COUNT(course_id) AS course_count
        FROM enrollments
        GROUP BY student_id
    ) AS subquery
)
ORDER BY course_count DESC;

-- 36. Courses where all students got 'A'
SELECT c.course_id,
       c.course_name,
       c.course_code
FROM courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM enrollments e
    WHERE e.course_id = c.course_id
    AND e.grade != 'A'
)
AND EXISTS (
    SELECT 1
    FROM enrollments e
    WHERE e.course_id = c.course_id
);

-- 37. Highest salary professor in each department
SELECT d.dept_name, 
       p.prof_name, 
       p.salary
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE p.salary = (
    SELECT MAX(salary)
    FROM professors p2
    WHERE p2.department_id = p.department_id
)
ORDER BY d.dept_name;

-- 38. Departments where average salary > 85,000
SELECT dept_name, avg_salary
FROM (
    SELECT d.dept_name, 
           ROUND(AVG(p.salary), 2) AS avg_salary
    FROM departments d
    JOIN professors p ON d.department_id = p.department_id
    GROUP BY d.department_id, d.dept_name
) AS dept_avg
WHERE avg_salary > 85000
ORDER BY avg_salary DESC;

-- ============================================================
-- TASK 2: USING VIEWS
-- ============================================================

-- 39. View already created above - query it
SELECT * FROM vw_student_enrollment_summary;

-- 40. View already created above - query it
SELECT * FROM vw_course_stats;

-- 41. Students with GPA > 3.0
SELECT full_name, department, courses_enrolled, gpa
FROM vw_student_enrollment_summary 
WHERE gpa > 3.0
ORDER BY gpa DESC;

-- 42. Test view updatability (this will fail)
/*
UPDATE vw_student_enrollment_summary 
SET department = 'Computer Science' 
WHERE full_name = 'Arjun Mehta';
*/

-- 43. Recreate views with additional columns
DROP VIEW IF EXISTS vw_student_enrollment_summary;

CREATE VIEW vw_student_enrollment_summary AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    d.dept_name AS department,
    COUNT(e.course_id) AS courses_enrolled,
    ROUND(AVG(
        CASE 
            WHEN e.grade = 'A' THEN 4.0
            WHEN e.grade = 'B' THEN 3.0
            WHEN e.grade = 'C' THEN 2.0
            WHEN e.grade = 'D' THEN 1.0
            WHEN e.grade = 'F' THEN 0.0
            ELSE NULL
        END
    ), 2) AS gpa,
    GROUP_CONCAT(DISTINCT c.course_code ORDER BY c.course_code SEPARATOR ', ') AS courses_taken
FROM students s
JOIN departments d ON s.department_id = d.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id
GROUP BY s.student_id, s.first_name, s.last_name, d.dept_name;

-- ============================================================
-- TASK 3: STORED PROCEDURES
-- ============================================================

-- Create department_transfer_log table
DROP TABLE IF EXISTS department_transfer_log;

CREATE TABLE department_transfer_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    old_department_id INT,
    new_department_id INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 44. Stored procedure to enroll student
DROP PROCEDURE IF EXISTS sp_enroll_student;

DELIMITER $$

CREATE PROCEDURE sp_enroll_student(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_enrollment_date DATE,
    OUT p_result VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT;
    
    SELECT COUNT(*) INTO v_exists
    FROM enrollments
    WHERE student_id = p_student_id AND course_id = p_course_id;
    
    IF v_exists > 0 THEN
        SET p_result = 'Error: Student already enrolled in this course';
    ELSE
        INSERT INTO enrollments (student_id, course_id, enrollment_date)
        VALUES (p_student_id, p_course_id, p_enrollment_date);
        SET p_result = 'Enrollment successful';
    END IF;
END$$

DELIMITER ;

-- Test the procedure
CALL sp_enroll_student(1, 3, '2024-01-01', @result);
SELECT @result AS enrollment_result;

-- Test duplicate enrollment (should fail)
CALL sp_enroll_student(1, 3, '2024-01-01', @result);
SELECT @result AS duplicate_result;

-- 45. Procedure to transfer student
DROP PROCEDURE IF EXISTS sp_transfer_student;

DELIMITER $$

CREATE PROCEDURE sp_transfer_student(
    IN p_student_id INT,
    IN p_new_department_id INT,
    OUT p_result VARCHAR(255)
)
BEGIN
    DECLARE v_old_department_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'Error: Transfer failed';
    END;
    
    START TRANSACTION;
    
    SELECT department_id INTO v_old_department_id
    FROM students WHERE student_id = p_student_id;
    
    UPDATE students 
    SET department_id = p_new_department_id
    WHERE student_id = p_student_id;
    
    INSERT INTO department_transfer_log (student_id, old_department_id, new_department_id)
    VALUES (p_student_id, v_old_department_id, p_new_department_id);
    
    COMMIT;
    SET p_result = 'Transfer successful';
END$$

DELIMITER ;

-- Test the transfer
CALL sp_transfer_student(1, 2, @result);
SELECT @result AS transfer_result;

-- Check transfer log
SELECT * FROM department_transfer_log;

-- 46. Test transaction with error
-- Try to transfer to non-existent department (should rollback)
CALL sp_transfer_student(2, 999, @result);
SELECT @result AS failed_transfer;

-- 47. SAVEPOINT test
START TRANSACTION;

INSERT INTO enrollments (student_id, course_id, enrollment_date) 
VALUES (1, 3, '2024-01-01');

SAVEPOINT after_first;

-- This will fail if course_id 4 doesn't exist
INSERT INTO enrollments (student_id, course_id, enrollment_date) 
VALUES (1, 4, '2024-01-01');

ROLLBACK TO SAVEPOINT after_first;
COMMIT;

-- Verify only first insert exists
SELECT * FROM enrollments WHERE student_id = 1 AND course_id = 3;

-- ============================================================
-- FINAL VERIFICATION
-- ============================================================

-- Show all tables
SHOW TABLES;

-- Show all views
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Show all stored procedures
SHOW PROCEDURE STATUS WHERE Db = 'college_db';

-- Count all records
SELECT 'Departments' AS Table_Name, COUNT(*) AS Count FROM departments
UNION ALL
SELECT 'Students', COUNT(*) FROM students
UNION ALL
SELECT 'Courses', COUNT(*) FROM courses
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM enrollments
UNION ALL
SELECT 'Professors', COUNT(*) FROM professors
UNION ALL
SELECT 'Transfer Log', COUNT(*) FROM department_transfer_log;