-- =======================================
-- 学校データベース テーブル作成SQL
-- =======================================

-- ---------------------------------------
-- 教師テーブル
-- ---------------------------------------
CREATE TABLE teachers (
  teacher_id BIGINT PRIMARY KEY,
  teacher_name VARCHAR(64)
);

-- ---------------------------------------
-- 学生テーブル
-- ---------------------------------------
CREATE TABLE students (
  student_id BIGINT PRIMARY KEY,
  student_name VARCHAR(64)
);

-- ---------------------------------------
-- 教室テーブル
-- ---------------------------------------
CREATE TABLE classrooms (
  classroom_id VARCHAR(16) PRIMARY KEY,
  classroom_name VARCHAR(64) NOT NULL,
  capacity INT,
  building VARCHAR(64),
  facilities TEXT
);

-- ---------------------------------------
-- 授業時間テーブル
-- ---------------------------------------
CREATE TABLE class_periods (
  period_id INT PRIMARY KEY,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL
);

-- ---------------------------------------
-- 学期テーブル
-- ---------------------------------------
CREATE TABLE terms (
  term_id VARCHAR(16) PRIMARY KEY,
  term_name VARCHAR(64) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  
  CONSTRAINT check_term_dates CHECK (end_date > start_date)
);

-- ---------------------------------------
-- 講座テーブル
-- ---------------------------------------
CREATE TABLE courses (
  course_id VARCHAR(16) PRIMARY KEY,
  course_name VARCHAR(128) NOT NULL,
  teacher_id BIGINT,
  FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- ---------------------------------------
-- 受講テーブル
-- ---------------------------------------
CREATE TABLE student_courses (
  course_id VARCHAR(16),
  student_id BIGINT,
  FOREIGN KEY (course_id) REFERENCES courses(course_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  PRIMARY KEY (course_id, student_id)
);

-- ---------------------------------------
-- 講師スケジュール管理テーブル
-- ---------------------------------------
CREATE TABLE teacher_unavailability (
  unavailability_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  teacher_id BIGINT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  reason VARCHAR(128),
  
  FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
  
  -- 終了日は開始日以降でなければならない
  CONSTRAINT check_date_order CHECK (end_date >= start_date)
);

-- ---------------------------------------
-- 授業カレンダーテーブル
-- ---------------------------------------
CREATE TABLE course_schedule (
  schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  course_id VARCHAR(16) NOT NULL,
  schedule_date DATE NOT NULL,
  period_id INT NOT NULL,
  classroom_id VARCHAR(16) NOT NULL,
  teacher_id BIGINT NOT NULL,
  status VARCHAR(16) DEFAULT 'scheduled', -- scheduled, cancelled, completed
  
  FOREIGN KEY (course_id) REFERENCES courses(course_id),
  FOREIGN KEY (period_id) REFERENCES class_periods(period_id),
  FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id),
  FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
  
  -- 同じ教室で同じ日時に複数の授業はスケジュールできない
  UNIQUE (schedule_date, period_id, classroom_id),
  -- 同じ講師が同じ日時に複数の授業を担当できない
  UNIQUE (schedule_date, period_id, teacher_id)
);

-- ---------------------------------------
-- 出席管理テーブル
-- ---------------------------------------
CREATE TABLE attendance (
  schedule_id BIGINT,
  student_id BIGINT,
  status VARCHAR(16) NOT NULL, -- present, absent, late
  comment TEXT,
  
  PRIMARY KEY (schedule_id, student_id),
  FOREIGN KEY (schedule_id) REFERENCES course_schedule(schedule_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- ---------------------------------------
-- 成績評価テーブル
-- ---------------------------------------
CREATE TABLE grades (
  student_id BIGINT,
  course_id VARCHAR(16),
  grade_type VARCHAR(32), -- exam, assignment, project, final
  score DECIMAL(5,2),
  max_score DECIMAL(5,2),
  submission_date DATE,
  
  PRIMARY KEY (student_id, course_id, grade_type),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);