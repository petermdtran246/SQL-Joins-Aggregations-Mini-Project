-- 1️⃣ Inner Join — Students with their submitted papers
CREATE TABLE students (
  id INT AUTO_INCREMENT,
  first_name VARCHAR(100),
  PRIMARY KEY (id)
);

-- 🌱 Seed Data 
CREATE TABLE papers (
  title VARCHAR(100),
  grade DECIMAL(8),
  student_id INT,
  FOREIGN KEY(student_id) REFERENCES students(id)
);

INSERT INTO students (first_name) 
VALUES ('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');

INSERT INTO papers (student_id, title, grade ) 
VALUES  (1, 'My First Book Report', 60),
        (1, 'My Second Book Report', 75),
        (2, 'Russian Lit Through The Ages', 94),
        (2, 'De Montaigne and The Art of The Essay', 98),
        (4, 'Borges and Magical Realism', 89);

SELECT * FROM students;

SELECT * FROM papers;

-- 1️⃣ Inner Join — Students with their submitted papers
SELECT 
  first_name, 
  title, 
  grade 
FROM 
  students s 
  JOIN papers p ON s.id = p.student_id 
ORDER BY 
  grade DESC;


-- 2️⃣ Left Join — Include students with no papers
SELECT 
  first_name, 
  title, 
  grade 
FROM 
  students s 
  LEFT JOIN papers p ON s.id = p.student_id;


-- 3️⃣ Replace NULLs with defaults
SELECT 
  first_name, 
  IFNULL(title, 'MISSING') AS title, 
  IFNULL(grade, 0) AS grade 
FROM 
  students s 
  LEFT JOIN papers p ON s.id = p.student_id;


-- 4️⃣ Average grade per student (NULL → 0)
SELECT 
  first_name, 
  IFNULL(
    AVG(grade), 
    0
  ) AS average 
FROM 
  students s 
  LEFT JOIN papers p ON s.id = p.student_id 
GROUP BY 
  first_name 
ORDER BY 
  average DESC;


-- 5️⃣ Show 0 instead of 0.0000 for no papers
SELECT 
  first_name, 
  CASE WHEN AVG(grade) IS NULL THEN 0 ELSE AVG(grade) END AS average 
FROM 
  students s 
  LEFT JOIN papers p ON s.id = p.student_id 
GROUP BY 
  first_name 
ORDER BY 
  average DESC;

-- 6️⃣ Pass/Fail classification
SELECT 
  first_name, 
  IFNULL(
    AVG(grade), 
    0
  ) AS average, 
  CASE WHEN IFNULL(
    AVG(grade), 
    0
  ) > 75 THEN 'PASSING' ELSE 'FAILING' END AS passing_status 
FROM 
  students s 
  LEFT JOIN papers p ON s.id = p.student_id 
GROUP BY 
  first_name 
ORDER BY 
  average DESC;

-- 7️⃣ Combined — Clean 0 + Pass/Fail
SELECT 
  -- Student name
  s.first_name, 
  -- Average grade:
  -- If no papers (AVG = NULL) → 0, else actual average
  CASE WHEN AVG(p.grade) IS NULL THEN 0 ELSE AVG(p.grade) END AS average, 
  -- Pass/Fail:
  CASE WHEN IFNULL(
    AVG(p.grade), 
    0
  ) > 75 THEN 'PASSING' ELSE 'FAILING' END AS passing_status 
FROM 
  students s 
  LEFT JOIN papers p ON s.id = p.student_id 
GROUP BY 
  s.first_name 
ORDER BY 
  average DESC;



