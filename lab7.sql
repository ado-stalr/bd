-- 1. Добавить внешние ключи.
ALTER TABLE lesson
    ADD CONSTRAINT lesson_subject_id_subject_fk FOREIGN KEY (id_subject) REFERENCES subject (id_subject) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE lesson
    ADD CONSTRAINT lesson_group_id_group_fk FOREIGN KEY (id_group) REFERENCES `group` (id_group) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE lesson
    ADD CONSTRAINT lesson_teacher_id_teacher_fk FOREIGN KEY (id_teacher) REFERENCES teacher (id_teacher) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE student
    ADD CONSTRAINT student_group_id_group_fk FOREIGN KEY (id_group) REFERENCES `group` (id_group) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE mark
    ADD CONSTRAINT mark_student_id_student_fk FOREIGN KEY (id_student) REFERENCES student (id_student) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE mark
    ADD CONSTRAINT mark_lesson_id_lesson_fk FOREIGN KEY (id_lesson) REFERENCES lesson (id_lesson) ON DELETE CASCADE ON UPDATE CASCADE;

-- 2. Выдать оценки студентов по информатике если они обучаются данному
-- предмету. Оформить выдачу данных с использованием view.

CREATE VIEW student_marks AS
    SELECT student.name, mark.mark, lesson.date FROM mark
    JOIN student on mark.id_student = student.id_student
    JOIN lesson  on mark.id_lesson = lesson.id_lesson
    JOIN subject on lesson.id_subject = subject.id_subject
    WHERE subject.name = 'Информатика'
;

DROP VIEW student_marks;

SELECT * FROM student_marks;

-- 3. Дать информацию о должниках с указанием фамилии студента и названия
-- предмета. Должниками считаются студенты, не имеющие оценки по предмету,
-- который ведется в группе. Оформить в виде процедуры, на входе
-- идентификатор группы.

-- todo
-- todo done

DROP PROCEDURE `get_loosers`;

DELIMITER //
CREATE PROCEDURE `get_loosers` (IN input_group_id INT)
BEGIN
    SELECT student.name, subject.name
	FROM (
		SELECT student.id_student, subject.id_subject, COUNT(mark) AS counter, `group`.id_group
		FROM `group`
		LEFT JOIN student ON student.id_group = `group`.id_group
		LEFT JOIN lesson ON lesson.id_group = `group`.id_group
		LEFT JOIN mark ON mark.id_student = student.id_student AND mark.id_lesson = lesson.id_lesson
		LEFT JOIN subject ON subject.id_subject = lesson.id_subject
		GROUP BY student.id_student, subject.id_subject, `group`.id_group
		HAVING counter = 0
    ) AS loosers
	LEFT JOIN student ON student.id_student = loosers.id_student
	LEFT JOIN subject ON subject.id_subject = loosers.id_subject
	WHERE loosers.id_group = input_group_id;
END //

call `get_loosers`(3) ;

-- 4. Дать среднюю оценку студентов по каждому предмету для тех предметов, по
-- которым занимается не менее 35 студентов.
-- todo
-- todo done

SELECT subject.name, AVG(mark.mark) AS average_mark
FROM lesson
LEFT JOIN mark on mark.id_lesson = lesson.id_lesson
LEFT JOIN student on lesson.id_group = student.id_group
LEFT JOIN subject on lesson.id_subject = subject.id_subject
GROUP BY subject.id_subject
HAVING COUNT(DISTINCT student.id_student) >= 35;

# SELECT COUNT(*)
# FROM lesson
# LEFT JOIN `group` on lesson.id_group = `group`.id_group
# LEFT JOIN student on `group`.id_group = student.id_group
# LEFT JOIN subject on lesson.id_subject = subject.id_subject
# GROUP BY subject.id_subject , student.id_student
# ;
#
# SELECT DISTINCT subject.id_subject, subject.name AS subject
# FROM lesson
# JOIN subject ON lesson.id_subject = subject.id_subject
# JOIN `group` ON lesson.id_group = `group`.id_group
# WHERE `group`.name = 'ПС';
#
# SELECT subject.name, SUM(mark.mark) AS sum_marks
# FROM mark
# LEFT JOIN lesson on mark.id_lesson = lesson.id_lesson
# LEFT JOIN subject on lesson.id_subject = subject.id_subject
# GROUP BY subject.id_subject;
#
# SELECT subject.name, SUM(mark.mark) AS sum_marks, student_in_subject.students as students
# FROM mark
# LEFT JOIN lesson on mark.id_lesson = lesson.id_lesson
# LEFT JOIN subject on lesson.id_subject = subject.id_subject
# LEFT JOIN (
#     SELECT id_subject, SUM(T1.count_students) as students from (
#         SELECT `group`.id_group, COUNT(*) as count_students
#         FROM `group`
#         JOIN student on `group`.id_group = student.id_group
#         GROUP BY `group`.id_group
#     ) as T1
#     LEFT JOIN (
#         SELECT `group`.id_group as id_group, subject.id_subject as id_subject
#         FROM lesson
#         JOIN subject on lesson.id_subject = subject.id_subject
#         JOIN `group` on lesson.id_group = `group`.id_group
#         GROUP BY `group`.id_group, subject.name
#     ) as T2 ON T1.id_group = T2.id_group
#     group by T2.id_subject
#     HAVING students >= 35
# ) as student_in_subject ON lesson.id_subject = student_in_subject.id_subject
# GROUP BY subject.id_subject;
#
# SELECT id_subject, AVG(T1.count_students) as students from (
#     SELECT `group`.id_group, COUNT(*) as count_students
#     FROM `group`
#     JOIN student on `group`.id_group = student.id_group
#     GROUP BY `group`.id_group
# ) as T1
# LEFT JOIN (
#     SELECT `group`.id_group as id_group, subject.id_subject as id_subject
#     FROM lesson
#     JOIN subject on lesson.id_subject = subject.id_subject
#     JOIN `group` on lesson.id_group = `group`.id_group
#     GROUP BY `group`.id_group, subject.name
# ) as T2 ON T1.id_group = T2.id_group
# group by T2.id_subject
# HAVING students >= 35;
#
#
#
# SELECT `group`.id_group, COUNT(*)
# FROM `group`
# JOIN student on `group`.id_group = student.id_group
# GROUP BY `group`.id_group
# ;
#
# SELECT `group`.id_group as id_group, subject.id_subject as id_subject
# FROM lesson
# JOIN subject on lesson.id_subject = subject.id_subject
# JOIN `group` on lesson.id_group = `group`.id_group
# GROUP BY `group`.id_group, subject.name
# ;

-- 5. Дать оценки студентов специальности ВМ по всем проводимым предметам с
-- указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить
-- значениями NULL поля оценки.
-- todo
-- todo done
SELECT `group`.name, student.name, subject.name, lesson.date, mark.mark, lesson.*
FROM `group`
LEFT JOIN student on `group`.id_group = student.id_group
LEFT JOIN lesson on `group`.id_group = lesson.id_group
LEFT JOIN mark on student.id_student = mark.id_student and lesson.id_lesson = mark.id_lesson
LEFT JOIN subject on lesson.id_subject = subject.id_subject
WHERE `group`.name = 'ВМ';

-- 6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету
-- БД до 12.05, повысить эти оценки на 1 балл.

-- todo join
-- todo done

START TRANSACTION;

SELECT * FROM `group`
    LEFT JOIN student on `group`.id_group = student.id_group
    LEFT JOIN mark on student.id_student = mark.id_student
    LEFT JOIN lesson on mark.id_lesson = lesson.id_lesson
    LEFT JOIN subject on lesson.id_subject = subject.id_subject
WHERE `group`.name = 'ПС'
    AND subject.name = 'БД'
    AND lesson.date < '2019-05-12';

UPDATE `group`
    LEFT JOIN student on `group`.id_group = student.id_group
    LEFT JOIN mark on student.id_student = mark.id_student
    LEFT JOIN lesson on mark.id_lesson = lesson.id_lesson
    LEFT JOIN subject on lesson.id_subject = subject.id_subject
SET mark.mark = mark.mark + 1
WHERE `group`.name = 'ПС'
    AND subject.name = 'БД'
    AND lesson.date < '2019-05-12'
    AND mark.mark < 5;

ROLLBACK;

-- 7. Добавить необходимые индексы.

CREATE INDEX mark_id_lesson_index
    ON mark (id_lesson ASC);

CREATE INDEX mark_id_student_index
    ON mark (id_student ASC);

CREATE INDEX student_id_group_index
    ON student (id_group ASC);

CREATE INDEX lesson_id_teacher_index
    ON lesson (id_teacher ASC);

CREATE INDEX lesson_id_subject_index
    ON lesson (id_subject ASC);

CREATE INDEX lesson_id_group_index
    ON lesson (id_group ASC);



