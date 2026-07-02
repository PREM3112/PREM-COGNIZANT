-- ============================================================
-- HANDS-ON 4: QUERY OPTIMISATION - INDEXES & EXPLAIN
-- ============================================================
-- Name: Your Name
-- Date: 2026-07-02
-- Database: MySQL
-- Path: Python FSE/Database integration/YourName/hands_on_4.sql
-- ============================================================

USE college_db;

-- ============================================================
-- TASK 1: BASELINE PERFORMANCE
-- ============================================================

-- 48. Baseline EXPLAIN
EXPLAIN FORMAT=JSON
SELECT s.first_name, s.last_name, c.course_name 
FROM enrollments e 
JOIN students s ON s.student_id = e.student_id 
JOIN courses c ON c.course_id = e.course_id 
WHERE s.enrollment_year = 2022;

/*
============= BASELINE EXPLAIN OUTPUT =============
[Copy the EXPLAIN output here]
Look for:
- "type": "ALL" (full table scan)
- "rows": (number of rows examined)
- "Extra": "Using where; Using join buffer"

Expected baseline:
- students table: Full table scan (ALL)
- enrollments table: Full table scan (ALL)
- courses table: Full table scan (ALL)
===================================================
*/

-- ============================================================
-- TASK 2: ADD INDEXES AND COMPARE
-- ============================================================

-- 51. B-Tree index on enrollment_year
CREATE INDEX idx_students_enrollment_year ON students(enrollment_year);

-- 52. Composite UNIQUE index
CREATE UNIQUE INDEX idx_enrollments_student_course ON enrollments(student_id, course_id);

-- 53. Index on course_code
CREATE INDEX idx_courses_course_code ON courses(course_code);

-- 54. Re-run EXPLAIN to compare
EXPLAIN FORMAT=JSON
SELECT s.first_name, s.last_name, c.course_name 
FROM enrollments e 
JOIN students s ON s.student_id = e.student_id 
JOIN courses c ON c.course_id = e.course_id 
WHERE s.enrollment_year = 2022;

/*
============= AFTER INDEXES EXPLAIN OUTPUT =============
[Copy the EXPLAIN output here]
Compare with baseline:
- Should show "ref" or "index" instead of "ALL"
- "rows" should be significantly lower
- "Extra" should show "Using index"

Expected after indexes:
- students table: Index scan on idx_students_enrollment_year
- enrollments table: Index scan on idx_enrollments_student_course
=======================================================
*/

-- 55. Additional performance indexes
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX idx_students_department_id ON students(department_id);
CREATE INDEX idx_courses_department_id ON courses(department_id);

-- Show all indexes
SHOW INDEX FROM students;
SHOW INDEX FROM enrollments;
SHOW INDEX FROM courses;
SHOW INDEX FROM departments;

-- ============================================================
-- TASK 3: N+1 PROBLEM (Python script - see n1_problem.py)
-- ============================================================

-- ============================================================
-- EXPECTED OUTCOMES:
-- ============================================================
-- 48: Baseline shows full table scans on all tables
-- 51-53: Indexes created successfully
-- 54: After indexes, query uses Index Scan instead of Full Table Scan
-- 55: All indexes created
-- ============================================================