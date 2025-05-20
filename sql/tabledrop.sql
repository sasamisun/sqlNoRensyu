-- =======================================
-- 学校データベース テーブル削除SQL
-- =======================================

-- 外部キー制約を持つテーブルから順に削除

-- 出席管理テーブル（授業スケジュールと学生に依存）
DROP TABLE IF EXISTS attendance;

-- 成績評価テーブル（学生と講座に依存）
DROP TABLE IF EXISTS grades;

-- 授業カレンダーテーブル（講座、授業時間、教室、教師に依存）
DROP TABLE IF EXISTS course_schedule;

-- 受講テーブル（学生と講座に依存）
DROP TABLE IF EXISTS student_courses;

-- 講師スケジュール管理テーブル（教師に依存）
DROP TABLE IF EXISTS teacher_unavailability;

-- 講座テーブル（教師に依存）
DROP TABLE IF EXISTS courses;

-- 以下は依存関係のないテーブル

-- 授業時間テーブル
DROP TABLE IF EXISTS class_periods;

-- 教室テーブル
DROP TABLE IF EXISTS classrooms;

-- 学生テーブル
DROP TABLE IF EXISTS students;

-- 教師テーブル
DROP TABLE IF EXISTS teachers;

-- 学期テーブル
DROP TABLE IF EXISTS terms;