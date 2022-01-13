-- GROUP BY

-- 1. Contare quanti iscritti ci sono stati ogni anno
    SELECT YEAR(enrolment_date), COUNT(*) 
    FROM students 
    GROUP BY YEAR(enrolment_date);

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
    SELECT office_address, COUNT(*) 
    FROM teachers 
    GROUP BY office_address;

-- 3. Calcolare la media dei voti di ogni appello d'esame
    SELECT exam_id, round (AVG(vote), 2) 
    FROM exam_student 
    GROUP BY exam_id;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
    SELECT departments.name, COUNT(*) 
    FROM departments 
        JOIN degrees 
            ON departments.id = degrees.department_id 
    GROUP BY departments.name
    
-- JOIN

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
    SELECT *
    FROM degrees
        JOIN students
            ON degrees.id = students.degree_id
    WHERE degrees.name 
        LIKE 'Corso di Laurea in Economia';


-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
    SELECT * 
    FROM departments 
        JOIN degrees 
            ON departments.id = degrees.department_id 
    WHERE departments.name 
        LIKE 'Dipartimento di Neuroscienze';

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
    SELECT * 
    FROM teachers 
        JOIN course_teacher 
            ON teachers.id = course_teacher.teacher_id 
        JOIN courses 
            ON courses.id = course_teacher.course_id 
    WHERE teachers.name like 'Fulvio' 
        AND teachers.surname like 'Amato';
    
    -- altra soluzione ricerca x id WHERE teachers.id = 44

-- 4. Selezionare tutti gli studenti con relativo corso di laurea e relativo dipartimento,in ordine alfabetico per cognome e nome
    SELECT * 
    FROM students 
        JOIN degrees 
            ON degrees.id = students.degree_id 
        JOIN departments 
            ON departments.id = degrees.department_id
    ORDER BY students.surname, students.name;
            
-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
    SELECT degrees.name AS 'Corso di Laurea', courses.name AS 'Nome Corso', teachers.name AS 'Nome Docente'
    FROM degrees
        JOIN courses
            ON degrees.id = courses.degree_id
        JOIN course_teacher
            ON courses.id = course_teacher.course_id
        JOIN teachers
            ON teachers.id = course_teacher.teacher_id;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
    SELECT  DISTINCT departments.name, teachers.name, teachers.surname
    FROM teachers
        JOIN course_teacher
            ON teachers.id = course_teacher.teacher_id
        JOIN courses
            ON courses.id = course_teacher.course_id
        JOIN degrees
            ON degrees.id = courses.degree_id
        JOIN departments
            ON departments.id = degrees.department_id
    WHERE departments.name LIKE 'Dipartimento di Matematica';

-- 7. BONUS: Selezionare per ogni studente quanti tentativi d'esame ha sostenuto per superare ciascuno dei suoi esami
    SELECT students.name,students.surname, courses.name AS 'Corso', COUNT(courses.id) AS 'Tentativi'
    FROM students
        JOIN exam_student
            ON students.id = exam_student.student_id
        JOIN exams 
            ON exams.id = exam_student.exam_id
        JOIN courses
            ON courses.id = exams.course_id
    GROUP BY students.name, students.surname, courses.name;

    -- Tentativi Totali per ogni studente senza considerare i diversi corsi
    SELECT students.name, students.surname, COUNT(students.id) AS 'tentativi'
    FROM students
        JOIN exam_student
            ON students.id = exam_student.student_id
        JOIN exams 
            ON exams.id = exam_student.exam_id
        JOIN courses
            ON courses.id = exams.course_id
    GROUP BY students.name, students.surname,students.id