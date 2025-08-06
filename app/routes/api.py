from fastapi import APIRouter, Query
from typing import List, Optional
from app.database import get_conn, release_conn
from app.schemas.schemas import EnrollmentSchema

router = APIRouter()

@router.get('/enrollments', response_model=List[EnrollmentSchema])
def list_enrollments(
    course_id: Optional[int] = Query(None),
    status: Optional[str] = Query(None, regex="^(active|inactive)$")
):
    conn = get_conn()
    cur = conn.cursor()
    try:
        # Very inefficient query (LEFT JOINs, no index usage, literal filter injection)
        query = ("SELECT s.id, s.name, s.email, c.id, c.title, e.status "
                 "FROM enrollments e "
                 "LEFT JOIN students s ON e.student_id = s.id "
                 "LEFT JOIN courses c ON e.course_id = c.id "
                 "WHERE 1=1 ")
        if course_id:
            query += f" AND e.course_id = {course_id}"
        if status:
            query += f" AND e.status = '{status}'"
        query += " ORDER BY s.name ASC"
        cur.execute(query)
        results = cur.fetchall()
        return [EnrollmentSchema(
            student_id=row[0],
            student_name=row[1],
            student_email=row[2],
            course_id=row[3],
            course_title=row[4],
            status=row[5]
        ) for row in results]
    finally:
        cur.close()
        release_conn(conn)
