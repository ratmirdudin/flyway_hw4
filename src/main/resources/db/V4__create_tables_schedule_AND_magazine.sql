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
