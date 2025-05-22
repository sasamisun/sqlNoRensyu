# 33. テーブル構造の変更：ALTER TABLE文

## はじめに

前章では、CREATE TABLE文を使用してテーブルを作成する方法を学びました。しかし、実際のシステム運用では、要件の変更や機能追加により、既存のテーブル構造を変更する必要が頻繁に発生します。この章では、既存テーブルの構造を安全に変更するための「ALTER TABLE文」について学習します。

ALTER TABLE文は、既存のテーブルに対してカラムの追加・削除・変更、制約の追加・削除、インデックスの管理など、テーブル構造のあらゆる変更を行うことができる非常に強力なSQL文です。

ALTER TABLE文が必要となる場面の例：
- 「学生テーブルに新しく『出身地』カラムを追加したい」
- 「成績テーブルの点数カラムのデータ型を変更したい」
- 「講座テーブルに受講者数制限の制約を追加したい」
- 「不要になったカラムを削除してテーブルを整理したい」
- 「システム改修でテーブル名を変更したい」
- 「パフォーマンス向上のためにインデックスを追加したい」
- 「セキュリティ強化のため、新しい制約を追加したい」

この章では、ALTER TABLE文の基本構文から、実践的な使用方法、注意点まで詳しく学んでいきます。

## ALTER TABLE文とは

ALTER TABLE文は、既存のテーブル構造（スキーマ）を変更するためのSQL文です。テーブルを削除・再作成することなく、カラムや制約、インデックスなどを動的に変更できます。

> **用語解説**：
> - **ALTER TABLE文**：既存テーブルの構造を変更するDDL文です。
> - **カラムの追加（ADD COLUMN）**：テーブルに新しいカラムを追加することです。
> - **カラムの削除（DROP COLUMN）**：テーブルから不要なカラムを削除することです。
> - **カラムの変更（MODIFY/CHANGE）**：既存カラムのデータ型や制約を変更することです。
> - **制約の追加（ADD CONSTRAINT）**：テーブルに新しい制約を追加することです。
> - **制約の削除（DROP CONSTRAINT）**：既存の制約を削除することです。
> - **インデックスの追加（ADD INDEX）**：検索性能向上のためのインデックスを追加することです。
> - **テーブル名変更（RENAME TO）**：テーブル名を変更することです。
> - **スキーマ変更**：テーブルの構造定義を変更することです。
> - **DDLロック**：ALTER TABLE実行中にテーブルがロックされることです。

## ALTER TABLE文の基本構文

### 基本的な構文パターン

```sql
-- カラムの追加
ALTER TABLE テーブル名 ADD COLUMN カラム名 データ型 [制約];

-- カラムの削除
ALTER TABLE テーブル名 DROP COLUMN カラム名;

-- カラムの変更
ALTER TABLE テーブル名 MODIFY COLUMN カラム名 新しいデータ型 [制約];
ALTER TABLE テーブル名 CHANGE COLUMN 古いカラム名 新しいカラム名 データ型 [制約];

-- 制約の追加
ALTER TABLE テーブル名 ADD CONSTRAINT 制約名 制約内容;

-- 制約の削除
ALTER TABLE テーブル名 DROP CONSTRAINT 制約名;

-- インデックスの追加
ALTER TABLE テーブル名 ADD INDEX インデックス名 (カラム名);

-- インデックスの削除
ALTER TABLE テーブル名 DROP INDEX インデックス名;

-- テーブル名の変更
ALTER TABLE 古いテーブル名 RENAME TO 新しいテーブル名;
```

## カラムの操作

### 1. カラムの追加（ADD COLUMN）

#### 基本的なカラム追加

```sql
-- studentsテーブルに出身地カラムを追加
ALTER TABLE students ADD COLUMN hometown VARCHAR(100);

-- 追加されたカラムの確認
DESCRIBE students;

-- デフォルト値付きでカラムを追加
ALTER TABLE students ADD COLUMN grade_level INT DEFAULT 1;

-- 必須カラムの追加（既存データに影響するため注意）
ALTER TABLE students ADD COLUMN student_status VARCHAR(20) NOT NULL DEFAULT 'active';
```

#### 特定の位置にカラムを追加

```sql
-- 最初の位置にカラムを追加
ALTER TABLE students ADD COLUMN student_code VARCHAR(20) FIRST;

-- 特定のカラムの後に追加
ALTER TABLE students ADD COLUMN middle_name VARCHAR(50) AFTER student_name;

-- 確認
DESCRIBE students;
```

#### 複数カラムの同時追加

```sql
-- 複数のカラムを一度に追加
ALTER TABLE students 
ADD COLUMN birth_place VARCHAR(100),
ADD COLUMN guardian_name VARCHAR(100),
ADD COLUMN guardian_phone VARCHAR(20);
```

### 2. カラムの削除（DROP COLUMN）

```sql
-- 不要なカラムの削除
ALTER TABLE students DROP COLUMN middle_name;

-- 複数カラムの同時削除
ALTER TABLE students 
DROP COLUMN student_code,
DROP COLUMN birth_place;

-- 削除の確認
DESCRIBE students;
```

### 3. カラムの変更

#### データ型の変更（MODIFY）

```sql
-- gradesテーブルのscoreカラムのデータ型を変更
-- 変更前の確認
DESCRIBE grades;

-- DECIMAL(5,2)からDECIMAL(6,2)に変更（より大きな値に対応）
ALTER TABLE grades MODIFY COLUMN score DECIMAL(6,2);

-- 文字列カラムの長さを変更
ALTER TABLE courses MODIFY COLUMN course_name VARCHAR(200);

-- 変更後の確認
DESCRIBE grades;
DESCRIBE courses;
```

#### カラム名とデータ型の同時変更（CHANGE）

```sql
-- カラム名を変更しながらデータ型も変更
ALTER TABLE students 
CHANGE COLUMN hometown home_prefecture VARCHAR(50);

-- 確認
DESCRIBE students;
```

#### 制約の追加・削除

```sql
-- カラムにNOT NULL制約を追加
-- まず既存のNULL値を適切な値に更新
UPDATE students SET guardian_name = '未登録' WHERE guardian_name IS NULL;

-- NOT NULL制約を追加
ALTER TABLE students MODIFY COLUMN guardian_name VARCHAR(100) NOT NULL;

-- NOT NULL制約を削除（NULL許可に変更）
ALTER TABLE students MODIFY COLUMN guardian_phone VARCHAR(20) NULL;
```

## 制約の操作

### 1. 主キー制約の操作

#### 主キーの追加

```sql
-- 新しいテーブルを作成（主キーなし）
CREATE TABLE temp_table (
    id INT,
    name VARCHAR(100)
);

-- 主キーを追加
ALTER TABLE temp_table ADD PRIMARY KEY (id);

-- 確認
DESCRIBE temp_table;
```

#### 主キーの削除と変更

```sql
-- 主キーの削除
ALTER TABLE temp_table DROP PRIMARY KEY;

-- 複合主キーの追加
ALTER TABLE temp_table ADD PRIMARY KEY (id, name);

-- 再度主キーを削除
ALTER TABLE temp_table DROP PRIMARY KEY;

-- AUTO_INCREMENT付き主キーの追加
ALTER TABLE temp_table 
MODIFY COLUMN id INT AUTO_INCREMENT,
ADD PRIMARY KEY (id);
```

### 2. 外部キー制約の操作

#### 外部キー制約の追加

```sql
-- 既存のstudent_coursesテーブルに外部キー制約を追加
-- まず制約名を指定して追加
ALTER TABLE student_courses 
ADD CONSTRAINT fk_student_courses_student 
FOREIGN KEY (student_id) REFERENCES students(student_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE student_courses 
ADD CONSTRAINT fk_student_courses_course 
FOREIGN KEY (course_id) REFERENCES courses(course_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- 制約の確認
SHOW CREATE TABLE student_courses;
```

#### 外部キー制約の削除

```sql
-- 外部キー制約の削除
ALTER TABLE student_courses DROP FOREIGN KEY fk_student_courses_student;
ALTER TABLE student_courses DROP FOREIGN KEY fk_student_courses_course;
```

### 3. UNIQUE制約の操作

```sql
-- 学生テーブルにメールアドレスカラムを追加
ALTER TABLE students ADD COLUMN email VARCHAR(255);

-- UNIQUE制約を追加
ALTER TABLE students ADD CONSTRAINT uk_students_email UNIQUE (email);

-- または短縮形で
ALTER TABLE students ADD UNIQUE (guardian_phone);

-- UNIQUE制約の削除
ALTER TABLE students DROP INDEX uk_students_email;
```

### 4. CHECK制約の操作（MySQL 8.0以降）

```sql
-- CHECK制約の追加
ALTER TABLE grades 
ADD CONSTRAINT chk_score_range 
CHECK (score >= 0 AND score <= 100);

-- CHECK制約の削除
ALTER TABLE grades DROP CHECK chk_score_range;
```

## インデックスの操作

### 1. インデックスの追加

```sql
-- 単一カラムインデックスの追加
ALTER TABLE students ADD INDEX idx_student_name (student_name);

-- 複合インデックスの追加
ALTER TABLE grades ADD INDEX idx_student_course (student_id, course_id);

-- 一意インデックスの追加
ALTER TABLE teachers ADD UNIQUE INDEX idx_teacher_email (teacher_name);

-- インデックスの確認
SHOW INDEX FROM students;
SHOW INDEX FROM grades;
```

### 2. インデックスの削除

```sql
-- インデックスの削除
ALTER TABLE students DROP INDEX idx_student_name;
ALTER TABLE grades DROP INDEX idx_student_course;
```

## テーブル名の変更

```sql
-- テーブル名の変更
ALTER TABLE temp_table RENAME TO sample_table;

-- 確認
SHOW TABLES LIKE 'sample%';

-- 元に戻す
ALTER TABLE sample_table RENAME TO temp_table;
```

## 実践的なALTER TABLE例

### 例1：学生テーブルの段階的拡張

```sql
-- 元のstudentsテーブル構造を確認
DESCRIBE students;

-- Phase 1: 基本的な個人情報の追加
ALTER TABLE students 
ADD COLUMN email VARCHAR(255),
ADD COLUMN phone VARCHAR(20),
ADD COLUMN birth_date DATE,
ADD COLUMN gender ENUM('male', 'female', 'other', 'prefer_not_to_say');

-- Phase 2: 学籍情報の追加
ALTER TABLE students 
ADD COLUMN student_number VARCHAR(20) UNIQUE,
ADD COLUMN admission_date DATE,
ADD COLUMN graduation_date DATE,
ADD COLUMN status ENUM('enrolled', 'graduated', 'withdrawn', 'suspended') DEFAULT 'enrolled';

-- Phase 3: 制約の追加
ALTER TABLE students 
ADD CONSTRAINT uk_student_email UNIQUE (email),
ADD CONSTRAINT chk_birth_date CHECK (birth_date <= CURRENT_DATE),
ADD CONSTRAINT chk_admission_date CHECK (admission_date >= '2000-01-01');

-- Phase 4: インデックスの追加
ALTER TABLE students 
ADD INDEX idx_student_number (student_number),
ADD INDEX idx_admission_date (admission_date),
ADD INDEX idx_status (status);

-- 最終的な構造確認
DESCRIBE students;
```

### 例2：成績テーブルの改良

```sql
-- 現在のgradesテーブル構造を確認
DESCRIBE grades;

-- 成績システムの改良
-- 1. 新しい評価項目の追加
ALTER TABLE grades 
ADD COLUMN evaluation_method ENUM('exam', 'assignment', 'project', 'participation') DEFAULT 'exam',
ADD COLUMN weight DECIMAL(5,2) DEFAULT 100.00,
ADD COLUMN comments TEXT,
ADD COLUMN evaluated_by BIGINT,
ADD COLUMN evaluated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- 2. 外部キー制約の追加
ALTER TABLE grades 
ADD CONSTRAINT fk_grades_evaluated_by 
FOREIGN KEY (evaluated_by) REFERENCES teachers(teacher_id);

-- 3. CHECK制約の追加
ALTER TABLE grades 
ADD CONSTRAINT chk_weight_range CHECK (weight >= 0 AND weight <= 100),
ADD CONSTRAINT chk_max_score_positive CHECK (max_score > 0);

-- 4. インデックスの追加
ALTER TABLE grades 
ADD INDEX idx_evaluation_method (evaluation_method),
ADD INDEX idx_evaluated_at (evaluated_at),
ADD INDEX idx_student_course_method (student_id, course_id, evaluation_method);

-- 結果確認
DESCRIBE grades;
SHOW INDEX FROM grades;
```

### 例3：新機能追加のためのテーブル拡張

```sql
-- 出席管理システムの拡張
DESCRIBE attendance;

-- 出席管理の詳細化
ALTER TABLE attendance 
ADD COLUMN check_in_time TIME,
ADD COLUMN check_out_time TIME,
ADD COLUMN late_minutes INT DEFAULT 0,
ADD COLUMN excuse_reason TEXT,
ADD COLUMN approved_by BIGINT,
ADD COLUMN approved_at TIMESTAMP NULL;

-- 制約の追加
ALTER TABLE attendance 
ADD CONSTRAINT chk_late_minutes CHECK (late_minutes >= 0),
ADD CONSTRAINT chk_check_times CHECK (check_out_time IS NULL OR check_out_time >= check_in_time);

-- 外部キー制約の追加
ALTER TABLE attendance 
ADD CONSTRAINT fk_attendance_approved_by 
FOREIGN KEY (approved_by) REFERENCES teachers(teacher_id);

-- インデックスの追加
ALTER TABLE attendance 
ADD INDEX idx_check_in_time (check_in_time),
ADD INDEX idx_status_date (status, schedule_id);
```

## データの互換性を考慮した変更

### 1. データ型変更時の注意点

```sql
-- 安全なデータ型変更の例

-- Step 1: 現在のデータ範囲を確認
SELECT 
    MIN(score) as min_score,
    MAX(score) as max_score,
    COUNT(*) as total_records
FROM grades;

-- Step 2: 新しいデータ型が既存データを収容できることを確認
-- DECIMAL(5,2) → DECIMAL(6,2) は安全（より大きな範囲）
ALTER TABLE grades MODIFY COLUMN score DECIMAL(6,2);

-- Step 3: 変更後のデータ確認
SELECT 
    MIN(score) as min_score,
    MAX(score) as max_score,
    COUNT(*) as total_records
FROM grades;
```

### 2. NOT NULL制約追加時の対処

```sql
-- NOT NULL制約を安全に追加する手順

-- Step 1: NULL値の存在確認
SELECT COUNT(*) as null_count 
FROM students 
WHERE email IS NULL;

-- Step 2: NULL値がある場合は適切な値で更新
UPDATE students 
SET email = CONCAT('student_', student_id, '@school.example.com')
WHERE email IS NULL;

-- Step 3: NOT NULL制約の追加
ALTER TABLE students MODIFY COLUMN email VARCHAR(255) NOT NULL;

-- Step 4: 確認
SELECT COUNT(*) as null_count 
FROM students 
WHERE email IS NULL;
```

### 3. カラム削除前のデータ確認

```sql
-- カラム削除前の安全確認

-- Step 1: 削除予定カラムの使用状況確認
SELECT 
    COUNT(*) as total_records,
    COUNT(guardian_name) as non_null_records,
    COUNT(*) - COUNT(guardian_name) as null_records
FROM students;

-- Step 2: 重要なデータがある場合はバックアップ
CREATE TABLE students_guardian_backup AS
SELECT student_id, guardian_name, guardian_phone
FROM students
WHERE guardian_name IS NOT NULL;

-- Step 3: カラムの削除
ALTER TABLE students 
DROP COLUMN guardian_name,
DROP COLUMN guardian_phone;
```

## パフォーマンスへの影響と対策

### 1. 大きなテーブルでの変更

```sql
-- 大量データテーブルでの安全な変更手順

-- 現在のテーブルサイズ確認
SELECT 
    COUNT(*) as record_count,
    ROUND(AVG(LENGTH(CONCAT_WS('', student_id, student_name)))) as avg_row_size
FROM students;

-- 変更中のロック時間を最小化するため、段階的に実行
-- Phase 1: インデックス追加（比較的高速）
ALTER TABLE students ADD INDEX idx_student_name (student_name);

-- Phase 2: カラム追加（高速）
ALTER TABLE students ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Phase 3: データ型変更（時間がかかる可能性）
-- 本番環境では事前にテストが必要
ALTER TABLE students MODIFY COLUMN student_name VARCHAR(150);
```

### 2. ALTER TABLEの進捗監視

```sql
-- MySQL 5.7以降での進捗確認
SELECT 
    THREAD_ID,
    PROCESSLIST_ID,
    PROCESSLIST_TIME,
    PROCESSLIST_STATE,
    PROCESSLIST_INFO
FROM performance_schema.threads 
WHERE PROCESSLIST_INFO LIKE 'ALTER TABLE%';

-- 実行中のクエリ確認
SHOW PROCESSLIST;
```

## ALTER TABLEのエラーと対処法

### 1. データ型変換エラー

```sql
-- エラー例：互換性のないデータ型変更
-- ALTER TABLE grades MODIFY COLUMN score VARCHAR(10);
-- エラー: 数値データが文字列に変換できない場合

-- 対処法1: 事前にデータ確認
SELECT score, COUNT(*)
FROM grades
GROUP BY score
ORDER BY score;

-- 対処法2: 段階的変更
-- まず新しいカラムを追加
ALTER TABLE grades ADD COLUMN score_text VARCHAR(10);

-- データを変換して新カラムに設定
UPDATE grades SET score_text = CAST(score AS CHAR);

-- 元のカラムを削除し、新カラムの名前を変更
ALTER TABLE grades DROP COLUMN score;
ALTER TABLE grades CHANGE COLUMN score_text score VARCHAR(10);
```

### 2. 外部キー制約エラー

```sql
-- エラー例：参照整合性違反
-- ALTER TABLE courses ADD CONSTRAINT fk_teacher 
-- FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id);
-- エラー: 存在しないteacher_idがある場合

-- 対処法: 事前にデータ整合性を確認・修正
SELECT c.course_id, c.teacher_id
FROM courses c
LEFT JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE t.teacher_id IS NULL;

-- 不整合データの修正
UPDATE courses 
SET teacher_id = 101  -- 存在する教師ID
WHERE teacher_id NOT IN (SELECT teacher_id FROM teachers);

-- 制約追加
ALTER TABLE courses 
ADD CONSTRAINT fk_courses_teacher 
FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id);
```

### 3. 容量不足エラー

```sql
-- 対処法: 一時的な容量確保
-- 不要なデータの削除
DELETE FROM log_table WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- テーブルの最適化
OPTIMIZE TABLE large_table;

-- 変更実行
ALTER TABLE large_table ADD COLUMN new_column TEXT;
```

## ALTER TABLEのベストプラクティス

### 1. 事前計画と準備

```sql
-- 変更前チェックリスト

-- 1. 現在のテーブル構造を記録
SHOW CREATE TABLE students;

-- 2. データ量とインデックスサイズを確認
SELECT 
    table_name,
    table_rows,
    data_length,
    index_length,
    (data_length + index_length) as total_size
FROM information_schema.tables 
WHERE table_schema = DATABASE() 
AND table_name = 'students';

-- 3. 依存関係の確認
SELECT 
    constraint_name,
    table_name,
    referenced_table_name,
    referenced_column_name
FROM information_schema.referential_constraints 
WHERE constraint_schema = DATABASE();

-- 4. 実行時間の見積もり（小規模テストテーブルで）
CREATE TABLE students_test LIKE students;
INSERT INTO students_test SELECT * FROM students LIMIT 1000;
-- テスト実行
ALTER TABLE students_test ADD COLUMN test_column VARCHAR(100);
DROP TABLE students_test;
```

### 2. 安全な実行手順

```sql
-- 本番環境での安全な変更手順

-- Step 1: バックアップの作成
CREATE TABLE students_backup AS SELECT * FROM students;

-- Step 2: トランザクション開始（可能な場合）
START TRANSACTION;

-- Step 3: 変更実行
ALTER TABLE students ADD COLUMN emergency_contact VARCHAR(100);

-- Step 4: 確認
DESCRIBE students;
SELECT COUNT(*) FROM students;

-- Step 5: 問題なければコミット
COMMIT;

-- Step 6: バックアップテーブルの削除（十分な確認後）
-- DROP TABLE students_backup;
```

### 3. 段階的なリリース

```sql
-- 大規模な変更の段階的実装

-- Release 1: カラム追加（NULL許可）
ALTER TABLE students ADD COLUMN new_feature_flag BOOLEAN DEFAULT NULL;

-- Release 2: デフォルト値設定
ALTER TABLE students MODIFY COLUMN new_feature_flag BOOLEAN DEFAULT FALSE;

-- Release 3: 既存データの更新
UPDATE students SET new_feature_flag = FALSE WHERE new_feature_flag IS NULL;

-- Release 4: NOT NULL制約追加
ALTER TABLE students MODIFY COLUMN new_feature_flag BOOLEAN NOT NULL DEFAULT FALSE;

-- Release 5: インデックス追加（必要に応じて）
ALTER TABLE students ADD INDEX idx_new_feature_flag (new_feature_flag);
```

## 練習問題

### 問題33-1：基本的なカラム操作
studentsテーブルに以下の変更を行ってください：
1. `nationality`カラム（VARCHAR(50)、デフォルト値'日本'）を追加
2. `birth_date`カラム（DATE型）を追加
3. `student_name`カラムのデータ型をVARCHAR(150)に変更
4. 変更後のテーブル構造を確認

### 問題33-2：制約の追加
teachersテーブルに以下の変更を行ってください：
1. `email`カラム（VARCHAR(255)）を追加
2. `hire_date`カラム（DATE型）を追加
3. `email`カラムにUNIQUE制約を追加
4. `hire_date`に対して2000年1月1日以降という CHECK制約を追加（MySQL 8.0以降）
5. `teacher_name`にNOT NULL制約が設定されていることを確認

### 問題33-3：インデックスの管理
gradesテーブルに以下のインデックスを追加してください：
1. `student_id`の単一インデックス（名前：idx_grades_student）
2. `course_id`と`grade_type`の複合インデックス（名前：idx_grades_course_type）
3. `submission_date`の単一インデックス（名前：idx_grades_submission_date）
4. 追加したインデックスを確認し、その後すべて削除

### 問題33-4：外部キー制約の追加
以下の手順で外部キー制約を追加してください：
1. attendanceテーブルとstudentsテーブルの関係を確認
2. `attendance.student_id`に対してstudentsテーブルへの外部キー制約を追加
3. CASCADE削除オプションを設定
4. 制約が正しく追加されたことを確認

### 問題33-5：テーブルの大幅な拡張
coursesテーブルを以下の要件で拡張してください：
1. `description`カラム（TEXT型）を追加
2. `credits`カラム（INT型、デフォルト値2）を追加
3. `max_students`カラム（INT型、デフォルト値30）を追加
4. `status`カラム（ENUM型：'active', 'inactive', 'planning'、デフォルト値'planning'）を追加
5. `created_at`カラム（TIMESTAMP型、現在日時がデフォルト）を追加
6. `updated_at`カラム（TIMESTAMP型、現在日時がデフォルト、更新時に自動更新）を追加
7. `credits`に対して1以上8以下のCHECK制約を追加
8. `max_students`に対して1以上200以下のCHECK制約を追加
9. 適切なインデックスを追加

### 問題33-6：複雑なデータ移行を伴う変更
以下の複雑な変更を安全に実行してください：
1. studentsテーブルの`student_name`を`first_name`と`last_name`に分割
2. 既存の`student_name`データを適切に分割して新しいカラムに移行
3. 元の`student_name`カラムを削除
4. 新しいカラムに適切な制約とインデックスを追加
5. 変更前後でデータの整合性を確認

## 解答

### 解答33-1
```sql
-- 1. nationalityカラムの追加
ALTER TABLE students ADD COLUMN nationality VARCHAR(50) DEFAULT '日本';

-- 2. birth_dateカラムの追加
ALTER TABLE students ADD COLUMN birth_date DATE;

-- 3. student_nameカラムのデータ型変更
ALTER TABLE students MODIFY COLUMN student_name VARCHAR(150);

-- 4. テーブル構造の確認
DESCRIBE students;
```

### 解答33-2
```sql
-- 1. emailカラムの追加
ALTER TABLE teachers ADD COLUMN email VARCHAR(255);

-- 2. hire_dateカラムの追加
ALTER TABLE teachers ADD COLUMN hire_date DATE;

-- 3. emailカラムにUNIQUE制約を追加
ALTER TABLE teachers ADD CONSTRAINT uk_teachers_email UNIQUE (email);

-- 4. hire_dateにCHECK制約を追加（MySQL 8.0以降）
ALTER TABLE teachers ADD CONSTRAINT chk_hire_date 
CHECK (hire_date >= '2000-01-01');

-- 5. teacher_nameのNOT NULL制約確認
DESCRIBE teachers;
-- または
SHOW CREATE TABLE teachers;
```

### 解答33-3
```sql
-- 1. student_idの単一インデックス追加
ALTER TABLE grades ADD INDEX idx_grades_student (student_id);

-- 2. course_idとgrade_typeの複合インデックス追加
ALTER TABLE grades ADD INDEX idx_grades_course_type (course_id, grade_type);

-- 3. submission_dateの単一インデックス追加
ALTER TABLE grades ADD INDEX idx_grades_submission_date (submission_date);

-- 4. インデックスの確認
SHOW INDEX FROM grades;

-- インデックスの削除
ALTER TABLE grades DROP INDEX idx_grades_student;
ALTER TABLE grades DROP INDEX idx_grades_course_type;
ALTER TABLE grades DROP INDEX idx_grades_submission_date;

-- 削除確認
SHOW INDEX FROM grades;
```

### 解答33-4
```sql
-- 1. テーブル関係の確認
DESCRIBE attendance;
DESCRIBE students;

-- 2. 外部キー制約の追加
ALTER TABLE attendance 
ADD CONSTRAINT fk_attendance_student 
FOREIGN KEY (student_id) REFERENCES students(student_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- 3. 制約の確認
SHOW CREATE TABLE attendance;

-- または制約一覧で確認
SELECT 
    constraint_name,
    table_name,
    referenced_table_name,
    delete_rule,
    update_rule
FROM information_schema.referential_constraints 
WHERE constraint_schema = DATABASE() 
AND table_name = 'attendance';
```

### 解答33-5
```sql
-- coursesテーブルの拡張
ALTER TABLE courses 
ADD COLUMN description TEXT,
ADD COLUMN credits INT DEFAULT 2,
ADD COLUMN max_students INT DEFAULT 30,
ADD COLUMN status ENUM('active', 'inactive', 'planning') DEFAULT 'planning',
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- CHECK制約の追加
ALTER TABLE courses 
ADD CONSTRAINT chk_credits_range CHECK (credits >= 1 AND credits <= 8),
ADD CONSTRAINT chk_max_students_range CHECK (max_students >= 1 AND max_students <= 200);

-- インデックスの追加
ALTER TABLE courses 
ADD INDEX idx_courses_status (status),
ADD INDEX idx_courses_credits (credits),
ADD INDEX idx_courses_created_at (created_at);

-- 結果確認
DESCRIBE courses;
SHOW INDEX FROM courses;
```

### 解答33-6
```sql
-- 複雑なデータ移行を伴う変更

-- Step 1: バックアップ作成
CREATE TABLE students_name_backup AS 
SELECT student_id, student_name FROM students;

-- Step 2: 新しいカラムを追加
ALTER TABLE students 
ADD COLUMN first_name VARCHAR(50),
ADD COLUMN last_name VARCHAR(50);

-- Step 3: 既存データの分割（簡単な例：スペースで分割）
UPDATE students 
SET 
    last_name = SUBSTRING_INDEX(student_name, ' ', 1),
    first_name = CASE 
        WHEN LOCATE(' ', student_name) > 0 
        THEN SUBSTRING(student_name, LOCATE(' ', student_name) + 1)
        ELSE student_name
    END
WHERE student_name IS NOT NULL;

-- Step 4: データ整合性確認
SELECT 
    student_id,
    student_name,
    last_name,
    first_name
FROM students 
LIMIT 10;

-- Step 5: 新しいカラムに制約を追加
ALTER TABLE students 
MODIFY COLUMN first_name VARCHAR(50) NOT NULL,
MODIFY COLUMN last_name VARCHAR(50) NOT NULL;

-- Step 6: インデックスを追加
ALTER TABLE students 
ADD INDEX idx_students_last_name (last_name),
ADD INDEX idx_students_full_name (last_name, first_name);

-- Step 7: 元のカラムを削除
ALTER TABLE students DROP COLUMN student_name;

-- Step 8: 最終確認
DESCRIBE students;
SELECT 
    student_id,
    last_name,
    first_name,
    CONCAT(last_name, ' ', first_name) as full_name
FROM students 
LIMIT 10;

-- Step 9: 問題がなければバックアップテーブル削除
-- DROP TABLE students_name_backup;
```

## まとめ

この章では、ALTER TABLE文について詳しく学びました：

1. **ALTER TABLE文の基本概念**：
   - 既存テーブル構造の動的変更
   - DDLロックとパフォーマンスへの影響
   - スキーマ変更の重要性

2. **カラムの操作**：
   - ADD COLUMNによる新しいカラムの追加
   - DROP COLUMNによるカラムの削除
   - MODIFYとCHANGEによるカラムの変更
   - 位置指定（FIRST、AFTER）の活用

3. **制約の管理**：
   - 主キー制約の追加・削除
   - 外部キー制約の設定とカスケードオプション
   - UNIQUE制約とCHECK制約の活用
   - NOT NULL制約の安全な追加

4. **インデックスの管理**：
   - パフォーマンス向上のためのインデックス追加
   - 複合インデックスの設計
   - 不要インデックスの削除

5. **実践的な変更手法**：
   - 段階的なテーブル拡張
   - データ移行を伴う変更
   - 大規模テーブルでの安全な変更

6. **エラー対処と予防**：
   - データ型変換エラーの回避
   - 外部キー制約エラーの解決
   - 事前のデータ整合性確認

7. **ベストプラクティス**：
   - 変更前の十分な計画と準備
   - バックアップの作成
   - 段階的なリリース戦略
   - パフォーマンス影響の最小化

ALTER TABLE文は非常に強力ですが、既存データへの影響やシステムの可用性を慎重に考慮する必要があります。特に本番環境では、十分なテストと計画的な実行が重要です。

次の章では、「DROP/TRUNCATE：テーブルの削除とクリア」について学び、テーブルの削除と初期化の方法を理解していきます。