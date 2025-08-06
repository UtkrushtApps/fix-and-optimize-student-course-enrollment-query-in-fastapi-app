# Task Overview

Utkrusht's student management tool helps administrators view which students are enrolled in which courses, including each student's active or inactive enrollment status. The 'list students by course' API endpoint is needed daily by school staff, but currently experiences slow performance and occasional timeouts—especially when filtering by course with thousands of enrollments. This defect blocks timely reporting and frustrates users during busy periods.

## Guidance
- The primary performance problem is observed when fetching students for a particular course, especially with a filter on enrollment status (active/inactive).
- Inefficient SQL JOINs and absence of proper indexes on enrolling, querying, and filtering columns are leading to full table scans.
- Composite or single-column indexes are missing on key relationship columns between students, courses, and enrollments.
- You should focus on schema improvements (indexes and constraints), query tuning, and ensuring the FastAPI database integration code uses best practices.
- The application is already built and running with sample data; your work is to improve underlying database design and logic for better responsiveness.

## Database Access
- **Host:** <DROPLET_IP>
- **Port:** 5432
- **Database:** utkrusht_students
- **Username:** utkrusht_user
- **Password:** Proof123
- Use any PostgreSQL tool like pgAdmin, DBeaver, or psql for schema or query performance analysis.

## Objectives
- Reduce response times of "list students by course" API to sub-second for typical queries.
- Create efficient indexes and ensure constraints are defined for student, course, and enrollment relationships.
- Update the inefficient database logic in code so it takes advantage of indexes instead of performing table scans or slow joins.
- Maintain all existing API responses and data integrity; only the query code and schema should be changed.

## How to Verify
- Run the endpoint (e.g., `/api/enrollments?course_id=<id>&status=active`) before and after changes; response should improve from multi-second to sub-second.
- Use EXPLAIN in PostgreSQL to compare old vs. new execution plans—there should be an index scan rather than a sequential scan on enrollments.
- Confirm results are correct and API behavior is unchanged except for faster performance.
- Optionally, use pagination and filters to ensure queries remain efficient even as the data set grows.