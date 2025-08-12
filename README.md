# 📊 SQL Joins & Aggregations — Mini Project

A compact SQL practice project demonstrating different types of joins, handling `NULL`, formatting outputs, and using aggregation functions like `AVG` with `CASE`.  
Perfect for showcasing SQL skills to recruiters.

---

## 🗄 Schema

```sql
CREATE TABLE students (
  id INT AUTO_INCREMENT,
  first_name VARCHAR(100),
  PRIMARY KEY (id)
);

CREATE TABLE papers (
  title VARCHAR(100),
  grade DECIMAL(8,2),
  student_id INT,
  FOREIGN KEY(student_id) REFERENCES students(id)
);

🌱 Seed Data

INSERT INTO students (first_name) 
VALUES ('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');

INSERT INTO papers (student_id, title, grade ) 
VALUES  
(1, 'My First Book Report', 60),
(1, 'My Second Book Report', 75),
(2, 'Russian Lit Through The Ages', 94),
(2, 'De Montaigne and The Art of The Essay', 98),
(4, 'Borges and Magical Realism', 89);


💡 Queries & Solutions
1️⃣ Inner Join — Students with their submitted papers
Goal: Show only students who have submitted at least one paper, sorted by grade (highest first).
SELECT first_name, title, grade
FROM students s
JOIN papers p
  ON s.id = p.student_id
ORDER BY grade DESC;

2️⃣ Left Join — Include students with no papers
Goal: Show all students and their papers. Students with no papers will have NULL for paper info.
SELECT first_name, title, grade
FROM students s
LEFT JOIN papers p
  ON s.id = p.student_id;

3️⃣ Replace NULLs with defaults
Goal: Replace missing paper titles with 'MISSING' and grades with 0.
SELECT first_name,
       IFNULL(title, 'MISSING') AS title,
       IFNULL(grade, 0)         AS grade
FROM students s
LEFT JOIN papers p
  ON s.id = p.student_id;

4️⃣ Average grade per student (NULL → 0)
Goal: Calculate the average grade per student. Students without papers get 0.
SELECT first_name,
       IFNULL(AVG(grade), 0) AS average
FROM students s
LEFT JOIN papers p
  ON s.id = p.student_id
GROUP BY first_name
ORDER BY average DESC;

5️⃣ Show 0 instead of 0.0000 for no papers
Goal: Keep decimal places for real grades, but show a clean 0 for students without papers.
SELECT first_name, 
       CASE 
         WHEN AVG(grade) IS NULL THEN 0 
         ELSE AVG(grade) 
       END AS average
FROM students s 
LEFT JOIN papers p 
  ON s.id = p.student_id 
GROUP BY first_name 
ORDER BY average DESC;

6️⃣ Pass/Fail classification
Goal: Add a PASSING or FAILING label based on a threshold average of 75.
SELECT first_name,
       IFNULL(AVG(grade), 0) AS average,
       CASE
         WHEN IFNULL(AVG(grade), 0) > 75 THEN 'PASSING'
         ELSE 'FAILING'
       END AS passing_status 
FROM students s
LEFT JOIN papers p
  ON s.id = p.student_id
GROUP BY first_name
ORDER BY average DESC;

7️⃣ Combined — Clean 0 + Pass/Fail
Goal: Show average grade with clean 0 for no papers, plus pass/fail status.
SELECT 
  -- Student name
  s.first_name,

  -- Average grade:
  -- If no papers (AVG = NULL) → 0, else actual average
  CASE
    WHEN AVG(p.grade) IS NULL THEN 0
    ELSE AVG(p.grade)
  END AS average,

  -- Pass/Fail:
  CASE
    WHEN IFNULL(AVG(p.grade), 0) > 75 THEN 'PASSING'
    ELSE 'FAILING'
  END AS passing_status 

FROM students s
LEFT JOIN papers p 
  ON s.id = p.student_id
GROUP BY s.first_name
ORDER BY average DESC;

🏆 Skills Demonstrated
✅ INNER JOIN vs LEFT JOIN

✅ Handling NULL with IFNULL and CASE

✅ Aggregation with AVG + GROUP BY

✅ Sorting results with ORDER BY

✅ Conditional formatting (Pass/Fail logic)

✅ Output formatting for cleaner presentation
