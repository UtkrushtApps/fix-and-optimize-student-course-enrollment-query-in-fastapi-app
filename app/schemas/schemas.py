from pydantic import BaseModel
class EnrollmentSchema(BaseModel):
    student_id: int
    student_name: str
    student_email: str
    course_id: int
    course_title: str
    status: str
