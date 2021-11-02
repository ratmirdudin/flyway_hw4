-- Группы
CREATE TABLE groups
(
    number INT PRIMARY KEY CHECK ( number > 0 ),
    name   VARCHAR NOT NULL UNIQUE
);

-- Студенты
CREATE TABLE students
(
    id           SERIAL PRIMARY KEY,
    surname      VARCHAR NOT NULL,
    firstname    VARCHAR NOT NULL,
    patronymic   VARCHAR NOT NULL,
    group_number INT REFERENCES groups (number) ON UPDATE CASCADE ON DELETE CASCADE,
    passport     VARCHAR NOT NULL UNIQUE
);

-- Преподаватели
CREATE TABLE teachers
(
    id         SERIAL PRIMARY KEY,
    surname    VARCHAR NOT NULL,
    firstname  VARCHAR NOT NULL,
    patronymic VARCHAR NOT NULL
);

-- Дисциплины
CREATE TABLE disciplines
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE
);

-- Отношение дисциплина - преподаватель
CREATE TABLE discipline_teacher
(
    discipline_id INT REFERENCES disciplines (id) ON UPDATE CASCADE ON DELETE CASCADE,
    teacher_id    INT REFERENCES teachers (id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (discipline_id, teacher_id)
);

-- Отношение дисциплина - студент
CREATE TABLE discipline_student
(
    discipline_id INT REFERENCES disciplines (id) ON UPDATE CASCADE ON DELETE CASCADE,
    student_id    INT REFERENCES students (id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (discipline_id, student_id)
);

-- Таблица lessons хранит заданное фиксированное время для порядкового номера занятия
-- чтобы избежать ошибок времени в расписании, например:
-- 1     8.45  - 10.20
-- 2     10.30 - 12.05
-- 3     12.15 - 13.50
-- 4     14.35 - 16.10
-- 5     16.20 - 17.55
-- таким образом атрибут lesson_id таблицы schedule
-- будет ссылаться на атрибут id таблицы lesson,
-- что позволит избежать ошибок со временем при составлении расписания
CREATE TABLE lessons
(
    id   INT     NOT NULL UNIQUE CHECK ( id > 0 ),
    time VARCHAR NOT NULL UNIQUE
);

-- Расписание
CREATE TABLE schedule
(
    id            SERIAL PRIMARY KEY,
    group_number  INT REFERENCES groups (number) ON UPDATE CASCADE ON DELETE CASCADE,
    discipline_id INT REFERENCES disciplines (id) ON UPDATE CASCADE ON DELETE CASCADE,
    day_of_week   INT NOT NULL CHECK ( day_of_week BETWEEN 1 AND 6),
    lesson_id     INT REFERENCES lessons (id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (group_number, day_of_week, lesson_id)
);

-- attendance - посещаемость
-- score - успеваемость
CREATE TABLE magazine
(
    id               SERIAL PRIMARY KEY,
    discipline_id    INT REFERENCES disciplines (id) ON UPDATE CASCADE ON DELETE CASCADE,
    number_of_lesson INT NOT NULL,
    student_id       INT REFERENCES students (id) ON UPDATE CASCADE ON DELETE CASCADE,
    attendance       INT NOT NULL DEFAULT 0 CHECK ( attendance = 0 OR attendance = 1 ),
    score            INT NOT NULL DEFAULT 0 CHECK ( score > 0 ),
    UNIQUE (discipline_id, number_of_lesson, student_id)
);
