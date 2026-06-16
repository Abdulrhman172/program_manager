# Grades Monitoring Interface — Developer Documentation

> **Project:** Program Manager (Flutter + Supabase)
> **Module:** Grades Monitoring (`رصد الدرجات`)
> **Author:** Auto-generated for developer handoff
> **Date:** 2026-06-16

---

## 1. Overview

The **Grades Monitoring Interface** allows the Program Manager to view, enter, and save individual student grades for graduation research projects. Grades are organized by research **groups** and involve two grading roles:

| Role | Grade Scope | Max Score |
|---|---|---|
| **Supervisor** (`مشرف`) | Grades the group''s research | 60 points |
| **Program Manager** (`مسؤول البرنامج`) | Grades each student individually | 40 points |

The **Final Grade** (`المجموع`) is the combined total out of 100.

---

## 2. Database Tables

The interface reads from and writes to **four** database tables:

### 2.1 `program_manager_grades`

This is the **primary/main table** for the grades monitoring interface. It holds one record per research group per program.

| Column | Type | Description |
|---|---|---|
| `grade_id` | `integer` (PK) | Unique identifier for each grade record |
| `id_group` | `integer` (FK → `groups.group_id`) | Reference to the research group |
| `id_program` | `integer` (FK → program) | Reference to the academic program |
| `supervisor_grade` | `float` / `numeric` | Grade given by the supervisor (out of 60) |
| `program_manager_grade` | `float` / `numeric` | Average grade given by the program manager (out of 40) |
| `final_grade` | `float` / `numeric` | Total combined grade (out of 100) |
| `grade_status` | `text` | Workflow status (see Status Values below) |

**Status Values for `grade_status`:**

| Value (Arabic) | Meaning |
|---|---|
| `بانتظار المشرف` | Waiting for the supervisor to enter their grade |
| `بانتظار المسؤول` | Supervisor has graded; waiting for program manager |
| `مكتملة` | Both grades have been entered — grade is complete |

---

### 2.2 `student_grades`

This table holds **individual student grades** entered by the program manager.

| Column | Type | Description |
|---|---|---|
| `grade_id` | `integer` (PK) | Unique identifier |
| `id_student` | `integer` (FK → `student.stud_id`) | Reference to the student |
| `id_group` | `integer` (FK → `groups.group_id`) | Reference to the group the student belongs to |
| `program_manager_grade` | `float` / `numeric` | Grade entered by the program manager for this student (0–40) |

> **Note:** A student may or may not have a record in this table. The app checks for existence before deciding to INSERT or UPDATE.

---

### 2.3 `groups`

Used to resolve group names for display purposes.

| Column | Type | Description |
|---|---|---|
| `group_id` | `integer` (PK) | Unique group identifier |
| `group_name` | `text` | Display name of the research group |
| `id_program` | `integer` (FK) | The program this group belongs to |

---

### 2.4 `student`

Used to list all students belonging to a group so the program manager can enter individual grades.

| Column | Type | Description |
|---|---|---|
| `stud_id` | `integer` (PK) | Unique student identifier |
| `stud_name` | `text` | Full student name |
| `id_group` | `integer` (FK → `groups.group_id`) | The group the student belongs to |
| `id_program` | `integer` (FK) | The program the student is enrolled in |

---

## 3. Data Flow — Fetching Grades (READ)

When the grades screen loads, the controller executes **four sequential queries**:

### Step 1 — Fetch all grade records for the program

```sql
SELECT *
FROM program_manager_grades
WHERE id_program = :id_program;
```

- `id_program` is read from local device storage (SharedPreferences).
- Returns one row per research group.

---

### Step 2 — Fetch group names

```sql
SELECT group_id, group_name
FROM groups
WHERE id_program = :id_program;
```

- Used to map group_id → group_name for display in the UI.

---

### Step 3 — Fetch students in the program

```sql
SELECT stud_id, stud_name, id_group
FROM student
WHERE id_program = :id_program;
```

- Students are grouped in memory by id_group to build the list of students per research group.

---

### Step 4 — Fetch existing individual student grades

```sql
SELECT id_student, program_manager_grade
FROM student_grades
WHERE program_manager_grade IS NOT NULL;
```

- Retrieves already-entered grades to pre-populate the grade entry dialog.
- Results are stored in a Map<student_id, grade>.

---

### In-Memory Assembly

After all four queries complete, the controller:

1. Builds a Map of group_id → group_name.
2. Builds a Map of group_id → list of students.
3. Merges student grades from student_grades into each student object.
4. Constructs a final list of GradeModel objects, each containing:
   - Group info (id, name, program)
   - Supervisor grade, Program Manager average grade, final grade
   - Grade status
   - List of students with their individual grades

---

## 4. Data Flow — Saving Grades (WRITE)

When the program manager submits grades through the dialog, the controller performs a **two-phase write**:

### Phase 1 — Upsert individual student grades into `student_grades`

For **each student** in the group:

#### Check if student record exists:

```sql
SELECT grade_id
FROM student_grades
WHERE id_student = :student_id
LIMIT 1;
```

#### If record EXISTS → UPDATE:

```sql
UPDATE student_grades
SET program_manager_grade = :grade
WHERE id_student = :student_id;
```

#### If record DOES NOT EXIST → INSERT:

```sql
INSERT INTO student_grades (id_student, id_group, program_manager_grade)
VALUES (:student_id, :group_id, :grade);
```

---

### Phase 2 — Update the group average in `program_manager_grades`

After all individual grades are saved:

```sql
UPDATE program_manager_grades
SET program_manager_grade = :average_grade,
    grade_status = 'مكتملة'
WHERE grade_id = :grade_id
  AND id_program = :id_program;
```

- `average_grade` is calculated as:
  - `average = SUM(all student grades) / COUNT(students in group)`
- `grade_status` is set to `'مكتملة'` (Completed).

---

## 5. Grade Entry Validation Rules

The following validation is enforced **before** any database write:

| Rule | Description |
|---|---|
| All fields required | Every student in the group must have a grade entered |
| Numeric values only | Input must be parseable as a decimal number |
| Range: 0 – 40 | The program manager grade must be between 0 and 40 inclusive |

If validation fails, an error message is shown and **no database writes are made**.

---

## 6. Filtering & Search (In-Memory — No Extra DB Query)

| Filter | Behavior |
|---|---|
| All (الكل) | Shows all grade records |
| Waiting Supervisor (بانتظار المشرف) | Shows only groups where supervisor has not graded yet |
| Waiting Admin (بانتظار المسؤول) | Shows only groups where supervisor graded but PM has not |
| Completed (مكتملة) | Shows only fully completed grade records |

Search by group name is also done in-memory using a case-insensitive substring match on group_name.

---

## 7. Summary Statistics (In-Memory — No Extra DB Query)

| Stat | Logic |
|---|---|
| Total Researches | COUNT of all grade records |
| Waiting Supervisor | COUNT WHERE grade_status = 'بانتظار المشرف' |
| Waiting Admin | COUNT WHERE grade_status = 'بانتظار المسؤول' |
| Completed | COUNT WHERE grade_status = 'مكتملة' |

---

## 8. Business Rules & Constraints

1. The "Record Grades" button is **disabled** until the supervisor has entered their grade (supervisor_grade IS NOT NULL). The program manager cannot enter grades before the supervisor.
2. **Optimistic UI update**: The UI is updated immediately (before DB confirmation) to give instant feedback. The DB write happens asynchronously.
3. **One record per group**: Each research group has exactly one record in program_manager_grades.
4. **One grade per student**: Each student has at most one record in student_grades.
5. **Program scope**: All queries are scoped to id_program, stored in device local preferences at login.

---

## 9. Entity Relationship Diagram

```
program_manager_grades
  +---------------------------+
  | grade_id (PK)             |
  | id_group (FK)  -----------+-------> groups
  | id_program                |          +------------------+
  | supervisor_grade          |          | group_id (PK)    |
  | program_manager_grade     |          | group_name       |
  | final_grade               |          | id_program       |
  | grade_status              |          +------------------+
  +---------------------------+                  |
                                                 | (1 : N)
                                                 v
                                             student
                                       +------------------+
                                       | stud_id (PK)     |
                                       | stud_name        |
                                       | id_group (FK)    |
                                       | id_program       |
                                       +------------------+
                                                 |
                                                 | (1 : 0..1)
                                                 v
                                        student_grades
                                       +------------------------------+
                                       | grade_id (PK)               |
                                       | id_student (FK -> stud_id)  |
                                       | id_group (FK)               |
                                       | program_manager_grade       |
                                       +------------------------------+
```

---

## 10. Implementation File References

| File | Purpose |
|---|---|
| `lib/features/grades/model/grade_model.dart` | Data models: GradeModel, StudentGradeModel |
| `lib/features/grades/controller/grades_controller.dart` | Business logic, DB queries, state management |
| `lib/features/grades/view/grades_view.dart` | UI: list cards, dialog, filter chips, stat cards |

---

*End of Document*
