-- SCHEMA: purposely suboptimal for performance
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT
);
CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    status VARCHAR(16) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- NO foreign keys, NO indexes, purposely bad for JOIN/filter performance
);
-- SAMPLE DATA
INSERT INTO students (name, email) VALUES ('Alice McPhee', 'alice@example.edu');
INSERT INTO students (name, email) VALUES ('Brian Kim', 'brian@example.edu');
INSERT INTO students (name, email) VALUES ('Chad Ngyuen', 'chad@example.edu');
DO $$
DECLARE
  i INTEGER;
BEGIN
  FOR i IN 1..1000 LOOP
    INSERT INTO courses (title, description) VALUES (
      'Course ' || i,
      'Sample description for course ' || i
    );
  END LOOP;
  FOR i IN 1..5000 LOOP
    INSERT INTO enrollments (student_id, course_id, status)
      VALUES ((i % 3) + 1, ((i % 1000) + 1), CASE WHEN i % 2 = 0 THEN 'active' ELSE 'inactive' END);
  END LOOP;
END$$;
