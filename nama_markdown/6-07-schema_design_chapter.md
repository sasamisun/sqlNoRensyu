# 38. スキーマ設計：正規化と非正規化

## はじめに

前章では、マテリアライズドビューによるパフォーマンス向上について学習しました。この章では、データベース設計の基礎となる「正規化」と、実際の運用で必要となる「非正規化」について詳しく学習します。

正規化は、データベース設計における最も重要な概念の一つで、データの冗長性を排除し、更新異常を防ぐための理論的基盤です。一方、非正規化は、パフォーマンス要件を満たすために意図的に冗長性を導入する実践的な手法です。

スキーマ設計が重要となる場面の例：
- 「新しい学校管理システムのデータベースを設計したい」
- 「既存のシステムでデータの不整合が頻繁に発生している」
- 「複雑なクエリの実行時間を短縮したい」
- 「データの冗長性を排除してストレージを効率化したい」
- 「データの整合性を保ちつつ高速なアクセスを実現したい」
- 「システムの拡張性を考慮した設計にしたい」
- 「レポート機能の高速化が必要」

この章では、理論的な正規化の原則から、実践的な非正規化の手法まで、バランスの取れたスキーマ設計について学んでいきます。

## 正規化とは

正規化は、データベースの設計において、データの冗長性を排除し、データの整合性を保つためのプロセスです。エドガー・F・コッド博士によって提唱された理論で、複数の正規形が定義されています。

> **用語解説**：
> - **正規化（Normalization）**：データの冗長性を排除し、整合性を保つためのデータベース設計手法です。
> - **正規形（Normal Form）**：正規化の各段階を表す形式です（1NF、2NF、3NF、BCNF等）。
> - **非正規化（Denormalization）**：パフォーマンス向上のために意図的に冗長性を導入することです。
> - **冗長性（Redundancy）**：同じデータが複数の場所に重複して格納されている状態です。
> - **関数従属（Functional Dependency）**：あるカラムの値が決まると別のカラムの値が一意に決まる関係です。
> - **部分関数従属（Partial Dependency）**：複合主キーの一部のカラムに従属する関係です。
> - **推移関数従属（Transitive Dependency）**：A→B→Cという間接的な従属関係です。
> - **更新異常（Update Anomaly）**：データ更新時に発生する不整合や問題です。
> - **挿入異常（Insert Anomaly）**：新しいデータを挿入する際の問題です。
> - **削除異常（Delete Anomaly）**：データ削除時に必要な情報まで失われる問題です。

## 正規化の目的と利点

### 正規化の目的
1. **データの冗長性排除**：同じ情報の重複を避ける
2. **更新異常の防止**：データ更新時の不整合を防ぐ
3. **ストレージ効率化**：無駄な容量使用を削減
4. **データ整合性の向上**：一貫性のあるデータ管理

### 正規化の利点と課題

| 利点 | 課題 |
|------|------|
| データの整合性向上 | クエリの複雑化 |
| ストレージ使用量削減 | 結合処理による性能低下 |
| 更新処理の効率化 | 設計の複雑化 |
| 保守性の向上 | 理解の難しさ |

## 非正規化データの問題例

まず、正規化されていないデータの問題を確認しましょう。

```sql
-- 非正規化された学生成績テーブル（問題のある設計）
CREATE TABLE bad_student_grades (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT,
    student_name VARCHAR(100),
    student_email VARCHAR(255),
    course_id VARCHAR(16),
    course_name VARCHAR(128),
    teacher_id BIGINT,
    teacher_name VARCHAR(64),
    teacher_email VARCHAR(255),
    grade_type VARCHAR(32),
    score DECIMAL(5,2),
    max_score DECIMAL(5,2),
    submission_date DATE
);

-- 問題のあるサンプルデータ
INSERT INTO bad_student_grades VALUES
(1, 301, '黒沢春馬', 'kurosawa@school.com', '1', 'ITのための基礎知識', 101, '寺内鞍', 'terauchi@school.com', '中間テスト', 85.0, 100.0, '2025-05-15'),
(2, 301, '黒沢春馬', 'kurosawa@school.com', '1', 'ITのための基礎知識', 101, '寺内鞍', 'terauchi@school.com', 'レポート1', 90.0, 100.0, '2025-05-20'),
(3, 301, '黒沢春馬', 'kurosawa@school.com', '2', 'UNIX入門', 102, '佐野真', 'sano@school.com', '中間テスト', 78.0, 100.0, '2025-05-18'),
(4, 302, '新垣愛留', 'aragaki@school.com', '1', 'ITのための基礎知識', 101, '寺内鞍', 'terauchi@school.com', '中間テスト', 92.0, 100.0, '2025-05-15');

-- この設計の問題点を確認
SELECT * FROM bad_student_grades;
```

### 非正規化データの問題点

```sql
-- 問題1：冗長性（同じ情報の重複）
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT student_name) as unique_students,
    COUNT(DISTINCT course_name) as unique_courses,
    COUNT(DISTINCT teacher_name) as unique_teachers
FROM bad_student_grades;

-- 問題2：更新異常（学生名を変更する場合）
UPDATE bad_student_grades 
SET student_name = '黒沢春馬（更新）' 
WHERE student_id = 301 AND record_id = 1;  -- 一部のレコードのみ更新

-- 不整合の発生確認
SELECT student_id, student_name, COUNT(*) as count
FROM bad_student_grades 
WHERE student_id = 301
GROUP BY student_id, student_name;

-- 問題3：挿入異常（学生情報だけを登録したい場合）
-- 成績データなしに学生情報だけを入れることができない

-- 問題4：削除異常（最後の成績レコードを削除すると学生情報も失われる）
```

## 第1正規形（1NF）

第1正規形は、すべてのカラムが原子値（分割できない値）を持ち、繰り返しグループがない状態です。

### 1NFの条件
1. **原子値**：各カラムには分割できない単一の値のみ
2. **繰り返しグループなし**：同じ種類のデータを複数のカラムに分けない
3. **一意な行**：各行が一意に識別できる

### 1NF違反の例と修正

```sql
-- 1NF違反の例（繰り返しグループと複合値）
CREATE TABLE unnormalized_courses (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128),
    teacher_names TEXT,  -- 複数の教師名をカンマ区切りで格納（1NF違反）
    student_list TEXT,   -- 複数の学生IDをカンマ区切りで格納（1NF違反）
    schedule_info VARCHAR(500)  -- 複合情報（曜日、時限、教室を一つのカラムに）
);

-- 1NF違反データの例
INSERT INTO unnormalized_courses VALUES
('1', 'ITのための基礎知識', '寺内鞍,佐野真', '301,302,303,304', '月曜日1限:101A,水曜日2限:102B');

-- 1NFに修正したテーブル設計
CREATE TABLE courses_1nf (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL
);

CREATE TABLE course_teachers_1nf (
    course_id VARCHAR(16),
    teacher_id BIGINT,
    PRIMARY KEY (course_id, teacher_id)
);

CREATE TABLE course_students_1nf (
    course_id VARCHAR(16),
    student_id BIGINT,
    enrollment_date DATE,
    PRIMARY KEY (course_id, student_id)
);

CREATE TABLE course_schedules_1nf (
    schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(16),
    day_of_week TINYINT,  -- 1=月曜日
    period TINYINT,       -- 時限
    classroom_id VARCHAR(16)
);

-- 1NFに準拠したデータ挿入
INSERT INTO courses_1nf VALUES ('1', 'ITのための基礎知識');

INSERT INTO course_teachers_1nf VALUES 
('1', 101), ('1', 102);

INSERT INTO course_students_1nf VALUES 
('1', 301, '2025-04-01'),
('1', 302, '2025-04-01'),
('1', 303, '2025-04-01');

INSERT INTO course_schedules_1nf VALUES 
(1, '1', 1, 1, '101A'),
(2, '1', 3, 2, '102B');
```

## 第2正規形（2NF）

第2正規形は、1NFであり、かつ非キー属性が主キー全体に完全関数従属している状態です。

### 2NFの条件
1. **1NFである**
2. **部分関数従属がない**：複合主キーの一部分だけに依存するカラムがない

### 2NF違反の例と修正

```sql
-- 2NF違反の例（部分関数従属がある）
CREATE TABLE student_course_grades_not_2nf (
    student_id BIGINT,
    course_id VARCHAR(16),
    grade_type VARCHAR(32),
    
    -- 主キー（複合キー）
    PRIMARY KEY (student_id, course_id, grade_type),
    
    -- 以下のカラムに部分関数従属がある
    student_name VARCHAR(100),    -- student_idのみに依存（部分関数従属）
    student_email VARCHAR(255),   -- student_idのみに依存（部分関数従属）
    course_name VARCHAR(128),     -- course_idのみに依存（部分関数従属）
    teacher_name VARCHAR(64),     -- course_idのみに依存（部分関数従属）
    
    -- 以下は主キー全体に依存（完全関数従属）
    score DECIMAL(5,2),
    max_score DECIMAL(5,2),
    submission_date DATE
);

-- 部分関数従属の確認
INSERT INTO student_course_grades_not_2nf VALUES
(301, '1', '中間テスト', '黒沢春馬', 'kurosawa@school.com', 'ITのための基礎知識', '寺内鞍', 85.0, 100.0, '2025-05-15'),
(301, '1', 'レポート1', '黒沢春馬', 'kurosawa@school.com', 'ITのための基礎知識', '寺内鞍', 90.0, 100.0, '2025-05-20'),
(301, '2', '中間テスト', '黒沢春馬', 'kurosawa@school.com', 'UNIX入門', '佐野真', 78.0, 100.0, '2025-05-18');

-- 問題の確認：冗長性と更新異常
SELECT student_id, student_name, course_id, course_name, COUNT(*) as duplicates
FROM student_course_grades_not_2nf
GROUP BY student_id, student_name, course_id, course_name;

-- 2NFに修正したテーブル設計
CREATE TABLE students_2nf (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(255) UNIQUE
);

CREATE TABLE courses_2nf (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT NOT NULL
);

CREATE TABLE teachers_2nf (
    teacher_id BIGINT PRIMARY KEY,
    teacher_name VARCHAR(64) NOT NULL
);

CREATE TABLE grades_2nf (
    student_id BIGINT,
    course_id VARCHAR(16),
    grade_type VARCHAR(32),
    score DECIMAL(5,2),
    max_score DECIMAL(5,2),
    submission_date DATE,
    
    PRIMARY KEY (student_id, course_id, grade_type),
    FOREIGN KEY (student_id) REFERENCES students_2nf(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_2nf(course_id)
);

-- 2NFに準拠したデータ挿入
INSERT INTO teachers_2nf VALUES (101, '寺内鞍'), (102, '佐野真');
INSERT INTO students_2nf VALUES (301, '黒沢春馬', 'kurosawa@school.com');
INSERT INTO courses_2nf VALUES ('1', 'ITのための基礎知識', 101), ('2', 'UNIX入門', 102);

INSERT INTO grades_2nf VALUES
(301, '1', '中間テスト', 85.0, 100.0, '2025-05-15'),
(301, '1', 'レポート1', 90.0, 100.0, '2025-05-20'),
(301, '2', '中間テスト', 78.0, 100.0, '2025-05-18');
```

## 第3正規形（3NF）

第3正規形は、2NFであり、かつ推移関数従属がない状態です。

### 3NFの条件
1. **2NFである**
2. **推移関数従属がない**：非キー属性が他の非キー属性を通じて主キーに依存しない

### 3NF違反の例と修正

```sql
-- 3NF違反の例（推移関数従属がある）
CREATE TABLE courses_with_department_not_3nf (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT NOT NULL,
    teacher_name VARCHAR(64),        -- teacher_idに依存（推移関数従属）
    department_id INT,               -- teacher_idに依存（推移関数従属）
    department_name VARCHAR(100),    -- department_idに依存（推移関数従属）
    department_building VARCHAR(50)  -- department_idに依存（推移関数従属）
);

-- 推移関数従属のあるデータ
INSERT INTO courses_with_department_not_3nf VALUES
('1', 'ITのための基礎知識', 101, '寺内鞍', 1, '情報工学科', 'A棟'),
('2', 'UNIX入門', 102, '佐野真', 1, '情報工学科', 'A棟'),
('3', 'データベース基礎', 101, '寺内鞍', 1, '情報工学科', 'A棟');

-- 推移関数従属の確認
-- course_id → teacher_id → teacher_name (推移関数従属)
-- course_id → teacher_id → department_id → department_name (推移関数従属)
SELECT 
    teacher_id, teacher_name, department_id, department_name,
    COUNT(DISTINCT course_id) as course_count
FROM courses_with_department_not_3nf
GROUP BY teacher_id, teacher_name, department_id, department_name;

-- 3NFに修正したテーブル設計
CREATE TABLE departments_3nf (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_building VARCHAR(50)
);

CREATE TABLE teachers_3nf (
    teacher_id BIGINT PRIMARY KEY,
    teacher_name VARCHAR(64) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments_3nf(department_id)
);

CREATE TABLE courses_3nf (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES teachers_3nf(teacher_id)
);

-- 3NFに準拠したデータ挿入
INSERT INTO departments_3nf VALUES (1, '情報工学科', 'A棟'), (2, '数学科', 'B棟');

INSERT INTO teachers_3nf VALUES 
(101, '寺内鞍', 1),
(102, '佐野真', 1),
(103, '田中教授', 2);

INSERT INTO courses_3nf VALUES
('1', 'ITのための基礎知識', 101),
('2', 'UNIX入門', 102),
('3', 'データベース基礎', 101);

-- 正規化後のクエリ例（結合が必要）
SELECT 
    c.course_id,
    c.course_name,
    t.teacher_name,
    d.department_name,
    d.department_building
FROM courses_3nf c
JOIN teachers_3nf t ON c.teacher_id = t.teacher_id
JOIN departments_3nf d ON t.department_id = d.department_id;
```

## 正規化の実践例：学校データベースの段階的設計

### ステップ1：要件分析

```sql
-- 学校データベースで管理したい情報
-- 1. 学生情報（ID、名前、メール、学年、専攻）
-- 2. 教師情報（ID、名前、所属学科、研究分野）
-- 3. 講座情報（ID、名前、単位数、難易度）
-- 4. 受講情報（学生と講座の関係、受講日）
-- 5. 成績情報（学生、講座、評価タイプ、点数）
-- 6. 教室情報（ID、名前、収容人数、設備）
-- 7. 授業スケジュール（講座、教室、日時）
```

### ステップ2：1NFの適用

```sql
-- 原子値の確保、繰り返しグループの排除
CREATE TABLE entities_1nf (
    -- 学生エンティティ
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(255) UNIQUE,
    student_grade INT,
    student_major VARCHAR(100),
    
    -- 教師エンティティ  
    teacher_id BIGINT,
    teacher_name VARCHAR(64),
    teacher_department VARCHAR(100),
    teacher_specialty VARCHAR(200),
    
    -- 講座エンティティ
    course_id VARCHAR(16),
    course_name VARCHAR(128),
    course_credits INT,
    course_difficulty ENUM('beginner', 'intermediate', 'advanced'),
    
    -- 受講関係
    enrollment_date DATE,
    
    -- 成績情報
    grade_type VARCHAR(32),
    score DECIMAL(5,2),
    max_score DECIMAL(5,2),
    
    -- 教室情報
    classroom_id VARCHAR(16),
    classroom_name VARCHAR(64),
    classroom_capacity INT,
    
    -- スケジュール情報
    schedule_date DATE,
    schedule_period INT
);

-- この設計は1NFだが、まだ最適ではない
```

### ステップ3：2NFの適用

```sql
-- 部分関数従属を排除した設計

-- 学生テーブル
CREATE TABLE students_normalized (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(255) UNIQUE,
    student_grade INT CHECK (student_grade >= 1 AND student_grade <= 6),
    student_major VARCHAR(100)
);

-- 教師テーブル
CREATE TABLE teachers_normalized (
    teacher_id BIGINT PRIMARY KEY,
    teacher_name VARCHAR(64) NOT NULL,
    teacher_department VARCHAR(100),
    teacher_specialty VARCHAR(200)
);

-- 講座テーブル
CREATE TABLE courses_normalized (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    course_credits INT DEFAULT 2,
    course_difficulty ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    teacher_id BIGINT,
    FOREIGN KEY (teacher_id) REFERENCES teachers_normalized(teacher_id)
);

-- 教室テーブル
CREATE TABLE classrooms_normalized (
    classroom_id VARCHAR(16) PRIMARY KEY,
    classroom_name VARCHAR(64) NOT NULL,
    classroom_capacity INT,
    classroom_equipment TEXT
);

-- 受講テーブル（多対多関係の解決）
CREATE TABLE enrollments_normalized (
    student_id BIGINT,
    course_id VARCHAR(16),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('enrolled', 'completed', 'dropped') DEFAULT 'enrolled',
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students_normalized(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_normalized(course_id)
);

-- 成績テーブル
CREATE TABLE grades_normalized (
    student_id BIGINT,
    course_id VARCHAR(16),
    grade_type VARCHAR(32),
    score DECIMAL(5,2),
    max_score DECIMAL(5,2) DEFAULT 100.0,
    submission_date DATE,
    PRIMARY KEY (student_id, course_id, grade_type),
    FOREIGN KEY (student_id) REFERENCES students_normalized(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_normalized(course_id)
);

-- スケジュールテーブル
CREATE TABLE schedules_normalized (
    schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(16),
    classroom_id VARCHAR(16),
    schedule_date DATE,
    schedule_period INT,
    FOREIGN KEY (course_id) REFERENCES courses_normalized(course_id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms_normalized(classroom_id),
    UNIQUE KEY unique_schedule (classroom_id, schedule_date, schedule_period)
);
```

### ステップ4：3NFの適用

```sql
-- 推移関数従属を排除した最終設計

-- 学科テーブルの分離
CREATE TABLE departments_final (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    department_building VARCHAR(50),
    department_head_teacher_id BIGINT
);

-- 専攻テーブルの分離
CREATE TABLE majors_final (
    major_id INT AUTO_INCREMENT PRIMARY KEY,
    major_name VARCHAR(100) NOT NULL UNIQUE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments_final(department_id)
);

-- 教師テーブル（3NF準拠）
CREATE TABLE teachers_final (
    teacher_id BIGINT PRIMARY KEY,
    teacher_name VARCHAR(64) NOT NULL,
    teacher_email VARCHAR(255) UNIQUE,
    department_id INT,
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments_final(department_id)
);

-- 学生テーブル（3NF準拠）
CREATE TABLE students_final (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(255) UNIQUE,
    student_grade INT CHECK (student_grade >= 1 AND student_grade <= 6),
    major_id INT,
    admission_date DATE,
    FOREIGN KEY (major_id) REFERENCES majors_final(major_id)
);

-- 講座テーブル（3NF準拠）
CREATE TABLE courses_final (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    course_description TEXT,
    course_credits INT DEFAULT 2,
    course_difficulty ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    teacher_id BIGINT NOT NULL,
    department_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teachers_final(teacher_id),
    FOREIGN KEY (department_id) REFERENCES departments_final(department_id)
);

-- サンプルデータの挿入
INSERT INTO departments_final (department_name, department_building) VALUES
('情報工学科', 'A棟'),
('数学科', 'B棟'),
('物理学科', 'C棟');

INSERT INTO majors_final (major_name, department_id) VALUES
('コンピュータサイエンス', 1),
('情報システム', 1),
('応用数学', 2),
('理論物理', 3);

INSERT INTO teachers_final (teacher_id, teacher_name, teacher_email, department_id, hire_date) VALUES
(101, '寺内鞍', 'terauchi@school.com', 1, '2020-04-01'),
(102, '佐野真', 'sano@school.com', 1, '2019-04-01'),
(103, '田中教授', 'tanaka@school.com', 2, '2018-04-01');

INSERT INTO students_final (student_id, student_name, student_email, student_grade, major_id, admission_date) VALUES
(301, '黒沢春馬', 'kurosawa@school.com', 2, 1, '2024-04-01'),
(302, '新垣愛留', 'aragaki@school.com', 2, 2, '2024-04-01'),
(303, '柴崎春花', 'shibasaki@school.com', 1, 1, '2025-04-01');

INSERT INTO courses_final (course_id, course_name, course_description, course_credits, teacher_id, department_id) VALUES
('CS101', 'ITのための基礎知識', 'コンピュータとITの基礎概念を学習', 2, 101, 1),
('CS102', 'UNIX入門', 'UNIXシステムの基本操作と概念', 2, 102, 1),
('MATH201', '微分積分学', '1変数および多変数の微分積分', 4, 103, 2);

-- 正規化後の複雑なクエリ例
SELECT 
    s.student_name,
    s.student_grade,
    m.major_name,
    d.department_name,
    c.course_name,
    c.course_credits,
    t.teacher_name
FROM students_final s
JOIN majors_final m ON s.major_id = m.major_id
JOIN departments_final d ON m.department_id = d.department_id
JOIN enrollments_normalized e ON s.student_id = e.student_id
JOIN courses_final c ON e.course_id = c.course_id
JOIN teachers_final t ON c.teacher_id = t.teacher_id
WHERE s.student_grade = 2
ORDER BY s.student_name, c.course_name;
```

## 非正規化とは

非正規化は、パフォーマンス要件を満たすために、意図的にデータの冗長性を導入する設計手法です。

### 非正規化が必要な場面
1. **頻繁な結合クエリの最適化**
2. **リアルタイム性が要求される処理**
3. **大量データの集計処理**
4. **レポート機能の高速化**
5. **読み取り専用システムの最適化**

### 非正規化の手法

#### 1. 計算済み値の格納

```sql
-- 学生の成績統計を事前計算して格納
ALTER TABLE students_final 
ADD COLUMN total_credits INT DEFAULT 0,
ADD COLUMN gpa DECIMAL(3,2) DEFAULT 0.00,
ADD COLUMN total_courses INT DEFAULT 0;

-- 統計情報更新プロシージャ
DELIMITER //
CREATE PROCEDURE update_student_statistics(IN p_student_id BIGINT)
BEGIN
    DECLARE total_credits_val INT DEFAULT 0;
    DECLARE gpa_val DECIMAL(3,2) DEFAULT 0.00;
    DECLARE total_courses_val INT DEFAULT 0;
    
    -- 総単位数の計算
    SELECT COALESCE(SUM(c.course_credits), 0)
    INTO total_credits_val
    FROM enrollments_normalized e
    JOIN courses_final c ON e.course_id = c.course_id
    WHERE e.student_id = p_student_id AND e.status = 'completed';
    
    -- GPA計算（簡易版：平均点を4.0スケールに変換）
    SELECT COALESCE(AVG(g.score) / 25.0, 0.00)  -- 100点満点を4.0スケールに変換
    INTO gpa_val
    FROM grades_normalized g
    WHERE g.student_id = p_student_id;
    
    -- 総受講講座数
    SELECT COUNT(*)
    INTO total_courses_val
    FROM enrollments_normalized
    WHERE student_id = p_student_id;
    
    -- 学生テーブルを更新
    UPDATE students_final 
    SET 
        total_credits = total_credits_val,
        gpa = LEAST(gpa_val, 4.00),  -- 上限4.0
        total_courses = total_courses_val
    WHERE student_id = p_student_id;
END //
DELIMITER ;

-- 統計情報の更新
CALL update_student_statistics(301);
CALL update_student_statistics(302);
CALL update_student_statistics(303);

-- 高速な学生一覧取得（結合不要）
SELECT 
    student_name,
    student_grade,
    total_credits,
    gpa,
    total_courses
FROM students_final
WHERE gpa >= 3.5
ORDER BY gpa DESC;
```

#### 2. 頻繁にアクセスされる結合結果の事前計算

```sql
-- 講座詳細情報の非正規化テーブル
CREATE TABLE course_details_denormalized (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128),
    course_description TEXT,
    course_credits INT,
    course_difficulty ENUM('beginner', 'intermediate', 'advanced'),
    teacher_id BIGINT,
    teacher_name VARCHAR(64),
    teacher_email VARCHAR(255),
    department_id INT,
    department_name VARCHAR(100),
    department_building VARCHAR(50),
    enrolled_students_count INT DEFAULT 0,
    average_grade DECIMAL(5,2) DEFAULT 0.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 非正規化テーブルの初期化プロシージャ
DELIMITER //
CREATE PROCEDURE initialize_course_details_denormalized()
BEGIN
    TRUNCATE TABLE course_details_denormalized;
    
    INSERT INTO course_details_denormalized 
        (course_id, course_name, course_description, course_credits, course_difficulty,
         teacher_id, teacher_name, teacher_email, department_id, department_name, department_building,
         enrolled_students_count, average_grade)
    SELECT 
        c.course_id,
        c.course_name,
        c.course_description,
        c.course_credits,
        c.course_difficulty,
        c.teacher_id,
        t.teacher_name,
        t.teacher_email,
        d.department_id,
        d.department_name,
        d.department_building,
        COALESCE(student_count.count, 0) as enrolled_students_count,
        COALESCE(avg_grades.avg_score, 0.00) as average_grade
    FROM courses_final c
    JOIN teachers_final t ON c.teacher_id = t.teacher_id
    JOIN departments_final d ON c.department_id = d.department_id
    LEFT JOIN (
        SELECT course_id, COUNT(*) as count
        FROM enrollments_normalized
        WHERE status = 'enrolled'
        GROUP BY course_id
    ) student_count ON c.course_id = student_count.course_id
    LEFT JOIN (
        SELECT course_id, AVG(score) as avg_score
        FROM grades_normalized
        GROUP BY course_id
    ) avg_grades ON c.course_id = avg_grades.course_id;
END //
DELIMITER ;

-- 初期化実行
CALL initialize_course_details_denormalized();

-- 高速な講座検索（結合不要）
SELECT 
    course_name,
    teacher_name,
    department_name,
    enrolled_students_count,
    average_grade
FROM course_details_denormalized
WHERE department_name = '情報工学科'
  AND enrolled_students_count > 0
ORDER BY average_grade DESC;
```

#### 3. 履歴データの効率化

```sql
-- 月次成績サマリテーブル（レポート用）
CREATE TABLE monthly_grade_summary (
    summary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    year_month VARCHAR(7),  -- YYYY-MM
    student_id BIGINT,
    student_name VARCHAR(100),  -- 非正規化：名前を重複格納
    course_id VARCHAR(16),
    course_name VARCHAR(128),   -- 非正規化：講座名を重複格納
    grade_count INT DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0.00,
    highest_score DECIMAL(5,2) DEFAULT 0.00,
    lowest_score DECIMAL(5,2) DEFAULT 0.00,
    
    UNIQUE KEY unique_monthly_summary (year_month, student_id, course_id),
    INDEX idx_year_month (year_month),
    INDEX idx_student_performance (student_id, average_score)
);

-- 月次サマリ生成プロシージャ
DELIMITER //
CREATE PROCEDURE generate_monthly_grade_summary(IN target_year_month VARCHAR(7))
BEGIN
    -- 該当月のデータを削除
    DELETE FROM monthly_grade_summary WHERE year_month = target_year_month;
    
    -- 新しいサマリを生成
    INSERT INTO monthly_grade_summary 
        (year_month, student_id, student_name, course_id, course_name, 
         grade_count, average_score, highest_score, lowest_score)
    SELECT 
        target_year_month,
        s.student_id,
        s.student_name,  -- 非正規化
        c.course_id,
        c.course_name,   -- 非正規化
        COUNT(g.score) as grade_count,
        ROUND(AVG(g.score), 2) as average_score,
        MAX(g.score) as highest_score,
        MIN(g.score) as lowest_score
    FROM students_final s
    JOIN grades_normalized g ON s.student_id = g.student_id
    JOIN courses_final c ON g.course_id = c.course_id
    WHERE DATE_FORMAT(g.submission_date, '%Y-%m') = target_year_month
    GROUP BY s.student_id, s.student_name, c.course_id, c.course_name
    HAVING grade_count > 0;
END //
DELIMITER ;

-- 月次サマリ生成
CALL generate_monthly_grade_summary('2025-05');

-- 高速な月次レポート生成
SELECT 
    student_name,
    course_name,
    grade_count,
    average_score,
    CASE 
        WHEN average_score >= 90 THEN 'A'
        WHEN average_score >= 80 THEN 'B'
        WHEN average_score >= 70 THEN 'C'
        WHEN average_score >= 60 THEN 'D'
        ELSE 'F'
    END as letter_grade
FROM monthly_grade_summary
WHERE year_month = '2025-05'
ORDER BY student_name, average_score DESC;
```

## 正規化vs非正規化の判断基準

### 判断マトリックス

| 要因 | 正規化を選ぶ | 非正規化を選ぶ |
|------|-------------|-------------|
| **データ整合性** | 重要 | 許容範囲内 |
| **更新頻度** | 高い | 低い |
| **読み取り頻度** | 普通 | 非常に高い |
| **クエリの複雑さ** | 許容範囲 | 簡略化が必要 |
| **ストレージコスト** | 重要 | 二次的 |
| **保守性** | 重要 | パフォーマンス優先 |
| **レスポンス時間** | 許容範囲 | 厳しい要件 |

### 実践的な設計指針

```sql
-- ハイブリッド設計の例

-- 1. メインデータは正規化を維持
CREATE TABLE core_students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(255) UNIQUE,
    major_id INT,
    admission_date DATE,
    FOREIGN KEY (major_id) REFERENCES majors_final(major_id)
);

-- 2. 頻繁にアクセスされる集計データは非正規化
CREATE TABLE student_performance_cache (
    student_id BIGINT PRIMARY KEY,
    current_gpa DECIMAL(3,2),
    total_credits INT,
    courses_completed INT,
    last_activity_date DATE,
    performance_rank INT,
    cache_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES core_students(student_id) ON DELETE CASCADE
);

-- 3. リアルタイム更新の仕組み
DELIMITER //
CREATE TRIGGER update_performance_cache_on_grade
AFTER INSERT ON grades_normalized
FOR EACH ROW
BEGIN
    -- 成績が追加されたら性能キャッシュを更新
    CALL refresh_student_performance_cache(NEW.student_id);
END //

CREATE TRIGGER update_performance_cache_on_grade_update
AFTER UPDATE ON grades_normalized
FOR EACH ROW
BEGIN
    -- 成績が更新されたら性能キャッシュを更新
    CALL refresh_student_performance_cache(NEW.student_id);
    IF OLD.student_id != NEW.student_id THEN
        CALL refresh_student_performance_cache(OLD.student_id);
    END IF;
END //

CREATE PROCEDURE refresh_student_performance_cache(IN p_student_id BIGINT)
BEGIN
    DECLARE new_gpa DECIMAL(3,2);
    DECLARE new_credits INT;
    DECLARE new_courses INT;
    DECLARE new_activity DATE;
    
    -- GPA計算
    SELECT ROUND(AVG(score) / 25.0, 2) INTO new_gpa
    FROM grades_normalized 
    WHERE student_id = p_student_id;
    
    -- 単位数計算
    SELECT COALESCE(SUM(c.course_credits), 0) INTO new_credits
    FROM enrollments_normalized e
    JOIN courses_final c ON e.course_id = c.course_id
    WHERE e.student_id = p_student_id AND e.status = 'completed';
    
    -- 完了講座数
    SELECT COUNT(*) INTO new_courses
    FROM enrollments_normalized
    WHERE student_id = p_student_id AND status = 'completed';
    
    -- 最終活動日
    SELECT MAX(submission_date) INTO new_activity
    FROM grades_normalized
    WHERE student_id = p_student_id;
    
    -- キャッシュ更新
    INSERT INTO student_performance_cache 
        (student_id, current_gpa, total_credits, courses_completed, last_activity_date)
    VALUES 
        (p_student_id, COALESCE(new_gpa, 0.00), COALESCE(new_credits, 0), 
         COALESCE(new_courses, 0), new_activity)
    ON DUPLICATE KEY UPDATE
        current_gpa = COALESCE(new_gpa, 0.00),
        total_credits = COALESCE(new_credits, 0),
        courses_completed = COALESCE(new_courses, 0),
        last_activity_date = new_activity,
        cache_updated_at = CURRENT_TIMESTAMP;
END //
DELIMITER ;

-- 高速な学生パフォーマンス取得
SELECT 
    s.student_name,
    s.student_email,
    p.current_gpa,
    p.total_credits,
    p.courses_completed,
    p.last_activity_date,
    DATEDIFF(CURRENT_DATE, p.last_activity_date) as days_since_last_activity
FROM core_students s
JOIN student_performance_cache p ON s.student_id = p.student_id
WHERE p.current_gpa >= 3.0
ORDER BY p.current_gpa DESC, p.total_credits DESC;
```

## パフォーマンス比較分析

### 正規化vs非正規化のベンチマーク

```sql
-- ベンチマーク用データ生成
DELIMITER //
CREATE PROCEDURE generate_benchmark_data()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE j INT DEFAULT 1;
    
    -- 大量の学生データ生成
    WHILE i <= 1000 DO
        INSERT INTO core_students (student_id, student_name, student_email, major_id, admission_date)
        VALUES (i, CONCAT('学生', i), CONCAT('student', i, '@school.com'), 
                (i % 4) + 1, DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * 1460) DAY));
        SET i = i + 1;
    END WHILE;
    
    -- 大量の成績データ生成
    SET i = 1;
    WHILE i <= 1000 DO
        SET j = 1;
        WHILE j <= 10 DO  -- 各学生10件の成績
            INSERT INTO grades_normalized (student_id, course_id, grade_type, score, submission_date)
            VALUES (i, CONCAT('CS10', (j % 3) + 1), 
                   CASE j % 4 
                       WHEN 0 THEN '中間テスト'
                       WHEN 1 THEN 'レポート1'
                       WHEN 2 THEN '課題1'
                       ELSE '期末テスト'
                   END,
                   60 + RAND() * 40,  -- 60-100点のランダム
                   DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * 30) DAY));
            SET j = j + 1;
        END WHILE;
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- パフォーマンステストプロシージャ
CREATE PROCEDURE benchmark_query_performance()
BEGIN
    DECLARE start_time TIMESTAMP(6);
    DECLARE end_time TIMESTAMP(6);
    DECLARE normalized_time INT;
    DECLARE denormalized_time INT;
    
    -- 正規化テーブルでの複雑なクエリ
    SET start_time = NOW(6);
    
    SELECT 
        s.student_name,
        AVG(g.score) as avg_score,
        COUNT(g.score) as grade_count,
        MAX(g.submission_date) as last_submission
    FROM core_students s
    JOIN grades_normalized g ON s.student_id = g.student_id
    WHERE s.major_id IN (1, 2)
    GROUP BY s.student_id, s.student_name
    HAVING avg_score >= 75
    ORDER BY avg_score DESC
    LIMIT 20;
    
    SET end_time = NOW(6);
    SET normalized_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time);
    
    -- 非正規化キャッシュでのクエリ
    SET start_time = NOW(6);
    
    SELECT 
        s.student_name,
        p.current_gpa * 25 as avg_score,  -- 4.0スケールを100点に戻す
        p.courses_completed as grade_count,
        p.last_activity_date as last_submission
    FROM core_students s
    JOIN student_performance_cache p ON s.student_id = p.student_id
    WHERE s.major_id IN (1, 2)
      AND p.current_gpa >= 3.0
    ORDER BY p.current_gpa DESC
    LIMIT 20;
    
    SET end_time = NOW(6);
    SET denormalized_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time);
    
    -- 結果出力
    SELECT 
        normalized_time as normalized_microseconds,
        denormalized_time as denormalized_microseconds,
        ROUND(normalized_time / denormalized_time, 2) as performance_ratio,
        normalized_time - denormalized_time as time_saved_microseconds;
END //
DELIMITER ;

-- ベンチマーク実行
-- CALL generate_benchmark_data();  -- 大量データ生成（注意：時間がかかります）
-- CALL benchmark_query_performance();
```

## 練習問題

### 問題38-1：正規化の段階的適用
以下の非正規化テーブルを1NF、2NF、3NFの順で正規化してください：
```sql
CREATE TABLE library_records_unnormalized (
    record_id INT PRIMARY KEY,
    book_isbn VARCHAR(20),
    book_title VARCHAR(200),
    book_authors TEXT,  -- カンマ区切りの複数著者
    publisher_name VARCHAR(100),
    publisher_address VARCHAR(200),
    publisher_phone VARCHAR(20),
    student_id BIGINT,
    student_name VARCHAR(100),
    student_email VARCHAR(255),
    student_department VARCHAR(100),
    loan_date DATE,
    return_date DATE,
    fine_amount DECIMAL(8,2)
);
```

### 問題38-2：関数従属の分析
以下のテーブルで関数従属関係を特定し、どの正規形に違反しているか分析してください：
```sql
CREATE TABLE course_enrollment_data (
    student_id BIGINT,
    course_id VARCHAR(16),
    semester VARCHAR(10),
    student_name VARCHAR(100),
    course_name VARCHAR(128),
    instructor_id BIGINT,
    instructor_name VARCHAR(64),
    department_id INT,
    department_name VARCHAR(100),
    grade CHAR(2),
    credit_hours INT,
    
    PRIMARY KEY (student_id, course_id, semester)
);
```

### 問題38-3：非正規化の設計
高頻度でアクセスされる以下のクエリを最適化するために、適切な非正規化テーブルを設計してください：
```sql
-- 頻繁に実行されるクエリ
SELECT 
    s.student_name,
    COUNT(DISTINCT e.course_id) as total_courses,
    AVG(g.score) as average_grade,
    SUM(c.course_credits) as total_credits,
    d.department_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
JOIN departments d ON s.department_id = d.department_id
WHERE e.status = 'completed'
GROUP BY s.student_id, s.student_name, d.department_name;
```

### 問題38-4：ハイブリッド設計
読み取り頻度が非常に高いレポートシステム用に、正規化されたメインテーブルと非正規化されたレポート用テーブルの両方を含むハイブリッド設計を作成してください。以下の要件を満たすこと：
1. メインデータは3NFを維持
2. レポート用の非正規化テーブルを作成
3. メインデータ更新時の自動同期機能
4. 月次・年次レポート高速生成

### 問題38-5：パフォーマンス最適化
以下の要件でテーブル設計を最適化してください：
- 学生の成績検索が1秒以内で完了すること
- 講座別統計の生成が3秒以内で完了すること
- データの整合性は保持すること
- ストレージ使用量は最小限に抑えること
正規化と非正規化の組み合わせによる最適解を提案してください。

### 問題38-6：複雑なスキーマ設計
オンライン学習プラットフォームのデータベーススキーマを設計してください：
- 学生、講師、コース、レッスン、課題、成績管理
- 動画視聴履歴、進捗管理
- 支払い情報、サブスクリプション管理
- リアルタイムの学習分析とレポート機能
正規化と非正規化を適切に組み合わせた包括的な設計を提示してください。

## 解答

### 解答38-1
```sql
-- Step 1: 第1正規形（1NF）への変換
-- 問題：book_authors が複数値を持っている

-- 1NF準拠テーブル
CREATE TABLE library_records_1nf (
    record_id INT PRIMARY KEY,
    book_isbn VARCHAR(20),
    book_title VARCHAR(200),
    book_author VARCHAR(100),  -- 単一著者
    publisher_name VARCHAR(100),
    publisher_address VARCHAR(200),
    publisher_phone VARCHAR(20),
    student_id BIGINT,
    student_name VARCHAR(100),
    student_email VARCHAR(255),
    student_department VARCHAR(100),
    loan_date DATE,
    return_date DATE,
    fine_amount DECIMAL(8,2)
);

-- 複数著者は別テーブルで管理
CREATE TABLE book_authors_1nf (
    book_isbn VARCHAR(20),
    author_name VARCHAR(100),
    author_order INT,
    PRIMARY KEY (book_isbn, author_name)
);

-- Step 2: 第2正規形（2NF）への変換
-- 問題：複合主キーに対する部分関数従属

-- 図書テーブル
CREATE TABLE books_2nf (
    book_isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(200) NOT NULL,
    publisher_name VARCHAR(100),
    publisher_address VARCHAR(200),
    publisher_phone VARCHAR(20)
);

-- 学生テーブル
CREATE TABLE students_2nf (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(255) UNIQUE,
    student_department VARCHAR(100)
);

-- 貸出記録テーブル
CREATE TABLE loan_records_2nf (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    book_isbn VARCHAR(20),
    student_id BIGINT,
    loan_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(8,2) DEFAULT 0.00,
    
    FOREIGN KEY (book_isbn) REFERENCES books_2nf(book_isbn),
    FOREIGN KEY (student_id) REFERENCES students_2nf(student_id)
);

-- 著者テーブル
CREATE TABLE book_authors_2nf (
    book_isbn VARCHAR(20),
    author_name VARCHAR(100),
    author_order INT DEFAULT 1,
    PRIMARY KEY (book_isbn, author_name),
    FOREIGN KEY (book_isbn) REFERENCES books_2nf(book_isbn)
);

-- Step 3: 第3正規形（3NF）への変換
-- 問題：publisher情報の推移関数従属

-- 出版社テーブル
CREATE TABLE publishers_3nf (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL UNIQUE,
    publisher_address VARCHAR(200),
    publisher_phone VARCHAR(20)
);

-- 学科テーブル
CREATE TABLE departments_3nf (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- 図書テーブル（3NF）
CREATE TABLE books_3nf (
    book_isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(200) NOT NULL,
    publisher_id INT,
    publication_date DATE,
    FOREIGN KEY (publisher_id) REFERENCES publishers_3nf(publisher_id)
);

-- 学生テーブル（3NF）
CREATE TABLE students_3nf (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(255) UNIQUE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments_3nf(department_id)
);

-- 貸出記録テーブル（3NF）
CREATE TABLE loan_records_3nf (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    book_isbn VARCHAR(20),
    student_id BIGINT,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(8,2) DEFAULT 0.00,
    
    FOREIGN KEY (book_isbn) REFERENCES books_3nf(book_isbn),
    FOREIGN KEY (student_id) REFERENCES students_3nf(student_id),
    CHECK (due_date >= loan_date),
    CHECK (return_date IS NULL OR return_date >= loan_date)
);

-- 著者テーブル（3NF）
CREATE TABLE book_authors_3nf (
    book_isbn VARCHAR(20),
    author_name VARCHAR(100),
    author_order INT DEFAULT 1,
    PRIMARY KEY (book_isbn, author_name),
    FOREIGN KEY (book_isbn) REFERENCES books_3nf(book_isbn)
);
```

### 解答38-2
```sql
-- 関数従属の分析

/*
主キー: (student_id, course_id, semester)

関数従属関係:
1. student_id → student_name (部分関数従属 - 2NF違反)
2. course_id → course_name (部分関数従属 - 2NF違反)
3. course_id → instructor_id (部分関数従属 - 2NF違反)
4. course_id → credit_hours (部分関数従属 - 2NF違反)
5. instructor_id → instructor_name (推移関数従属 - 3NF違反)
6. instructor_id → department_id (推移関数従属 - 3NF違反)
7. department_id → department_name (推移関数従属 - 3NF違反)

結論: このテーブルは1NFだが、2NFと3NFの両方に違反している
*/

-- 正規化された設計

-- 学科テーブル
CREATE TABLE departments_analysis (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- 教師テーブル
CREATE TABLE instructors_analysis (
    instructor_id BIGINT PRIMARY KEY,
    instructor_name VARCHAR(64) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments_analysis(department_id)
);

-- 学生テーブル
CREATE TABLE students_analysis (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

-- 講座テーブル
CREATE TABLE courses_analysis (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    instructor_id BIGINT,
    credit_hours INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors_analysis(instructor_id)
);

-- 受講・成績テーブル
CREATE TABLE enrollments_analysis (
    student_id BIGINT,
    course_id VARCHAR(16),
    semester VARCHAR(10),
    grade CHAR(2),
    
    PRIMARY KEY (student_id, course_id, semester),
    FOREIGN KEY (student_id) REFERENCES students_analysis(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_analysis(course_id)
);
```

### 解答38-3
```sql
-- 非正規化テーブルの設計
CREATE TABLE student_academic_summary (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,  -- 非正規化
    department_name VARCHAR(100),         -- 非正規化
    total_courses INT DEFAULT 0,
    total_credits INT DEFAULT 0,
    completed_credits INT DEFAULT 0,
    average_grade DECIMAL(5,2) DEFAULT 0.00,
    gpa DECIMAL(3,2) DEFAULT 0.00,
    highest_grade DECIMAL(5,2) DEFAULT 0.00,
    lowest_grade DECIMAL(5,2) DEFAULT 0.00,
    last_enrollment_date DATE,
    academic_standing ENUM('Good', 'Warning', 'Probation') DEFAULT 'Good',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_department (department_name),
    INDEX idx_gpa (gpa),
    INDEX idx_academic_standing (academic_standing)
);

-- サマリテーブル更新プロシージャ
DELIMITER //
CREATE PROCEDURE refresh_student_academic_summary(IN p_student_id BIGINT)
BEGIN
    DECLARE v_student_name VARCHAR(100);
    DECLARE v_department_name VARCHAR(100);
    DECLARE v_total_courses INT DEFAULT 0;
    DECLARE v_total_credits INT DEFAULT 0;
    DECLARE v_completed_credits INT DEFAULT 0;
    DECLARE v_average_grade DECIMAL(5,2) DEFAULT 0.00;
    DECLARE v_gpa DECIMAL(3,2) DEFAULT 0.00;
    DECLARE v_highest_grade DECIMAL(5,2) DEFAULT 0.00;
    DECLARE v_lowest_grade DECIMAL(5,2) DEFAULT 0.00;
    DECLARE v_last_enrollment DATE;
    DECLARE v_academic_standing ENUM('Good', 'Warning', 'Probation') DEFAULT 'Good';
    
    -- 基本情報取得
    SELECT s.student_name, d.department_name
    INTO v_student_name, v_department_name
    FROM students s
    JOIN departments d ON s.department_id = d.department_id
    WHERE s.student_id = p_student_id;
    
    -- 学習統計計算
    SELECT 
        COUNT(DISTINCT e.course_id),
        COALESCE(SUM(c.course_credits), 0),
        COALESCE(SUM(CASE WHEN e.status = 'completed' THEN c.course_credits ELSE 0 END), 0),
        COALESCE(AVG(g.score), 0.00),
        COALESCE(AVG(g.score) / 25.0, 0.00),  -- GPA計算
        COALESCE(MAX(g.score), 0.00),
        COALESCE(MIN(g.score), 0.00),
        MAX(e.enrollment_date)
    INTO 
        v_total_courses, v_total_credits, v_completed_credits,
        v_average_grade, v_gpa, v_highest_grade, v_lowest_grade, v_last_enrollment
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
    LEFT JOIN grades g ON e.student_id = g.student_id AND e.course_id = g.course_id
    WHERE e.student_id = p_student_id;
    
    -- 学習状況判定
    SET v_academic_standing = CASE 
        WHEN v_gpa >= 3.0 THEN 'Good'
        WHEN v_gpa >= 2.0 THEN 'Warning'
        ELSE 'Probation'
    END;
    
    -- サマリテーブル更新
    INSERT INTO student_academic_summary 
        (student_id, student_name, department_name, total_courses, total_credits,
         completed_credits, average_grade, gpa, highest_grade, lowest_grade,
         last_enrollment_date, academic_standing)
    VALUES 
        (p_student_id, v_student_name, v_department_name, v_total_courses, v_total_credits,
         v_completed_credits, v_average_grade, v_gpa, v_highest_grade, v_lowest_grade,
         v_last_enrollment, v_academic_standing)
    ON DUPLICATE KEY UPDATE
        student_name = v_student_name,
        department_name = v_department_name,
        total_courses = v_total_courses,
        total_credits = v_total_credits,
        completed_credits = v_completed_credits,
        average_grade = v_average_grade,
        gpa = v_gpa,
        highest_grade = v_highest_grade,
        lowest_grade = v_lowest_grade,
        last_enrollment_date = v_last_enrollment,
        academic_standing = v_academic_standing,
        last_updated = CURRENT_TIMESTAMP;
END //
DELIMITER ;

-- 高速クエリ例
SELECT 
    student_name,
    department_name,
    total_courses,
    completed_credits,
    gpa,
    academic_standing
FROM student_academic_summary
WHERE department_name = '情報工学科'
  AND academic_standing = 'Good'
ORDER BY gpa DESC, completed_credits DESC;
```

### 解答38-4
```sql
-- ハイブリッド設計：正規化メインテーブル + 非正規化レポートテーブル

-- 1. 正規化されたメインテーブル（3NF準拠）
CREATE TABLE main_students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    major_id INT,
    admission_date DATE,
    FOREIGN KEY (major_id) REFERENCES majors(major_id)
);

CREATE TABLE main_courses (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT,
    credits INT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE main_enrollments (
    student_id BIGINT,
    course_id VARCHAR(16),
    enrollment_date DATE,
    status ENUM('enrolled', 'completed', 'dropped'),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES main_students(student_id),
    FOREIGN KEY (course_id) REFERENCES main_courses(course_id)
);

CREATE TABLE main_grades (
    student_id BIGINT,
    course_id VARCHAR(16),
    grade_type VARCHAR(32),
    score DECIMAL(5,2),
    submission_date DATE,
    PRIMARY KEY (student_id, course_id, grade_type),
    FOREIGN KEY (student_id, course_id) REFERENCES main_enrollments(student_id, course_id)
);

-- 2. 非正規化レポートテーブル
CREATE TABLE report_monthly_summary (
    summary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    report_month DATE,  -- 月初日
    student_id BIGINT,
    student_name VARCHAR(100),      -- 非正規化
    major_name VARCHAR(100),        -- 非正規化
    courses_enrolled INT DEFAULT 0,
    courses_completed INT DEFAULT 0,
    total_assignments INT DEFAULT 0,
    assignments_submitted INT DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0.00,
    credits_earned INT DEFAULT 0,
    attendance_rate DECIMAL(5,2) DEFAULT 0.00,
    
    UNIQUE KEY unique_monthly_student (report_month, student_id),
    INDEX idx_report_month (report_month),
    INDEX idx_student_performance (student_id, average_score)
);

CREATE TABLE report_annual_summary (
    summary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    academic_year INT,
    student_id BIGINT,
    student_name VARCHAR(100),      -- 非正規化
    major_name VARCHAR(100),        -- 非正規化
    year_level INT,
    total_courses INT DEFAULT 0,
    completed_courses INT DEFAULT 0,
    cumulative_gpa DECIMAL(3,2) DEFAULT 0.00,
    total_credits INT DEFAULT 0,
    academic_status VARCHAR(50),
    honors_level VARCHAR(50),
    
    UNIQUE KEY unique_annual_student (academic_year, student_id),
    INDEX idx_academic_year (academic_year),
    INDEX idx_gpa (cumulative_gpa)
);

-- 3. 自動同期システム
DELIMITER //

-- 月次サマリ更新プロシージャ
CREATE PROCEDURE sync_monthly_summary(IN target_month DATE)
BEGIN
    DECLARE first_day DATE;
    DECLARE last_day DATE;
    
    SET first_day = DATE_FORMAT(target_month, '%Y-%m-01');
    SET last_day = LAST_DAY(first_day);
    
    -- 既存データ削除
    DELETE FROM report_monthly_summary WHERE report_month = first_day;
    
    -- 新データ生成
    INSERT INTO report_monthly_summary 
        (report_month, student_id, student_name, major_name, courses_enrolled,
         courses_completed, total_assignments, assignments_submitted, average_score, credits_earned)
    SELECT 
        first_day,
        s.student_id,
        s.student_name,
        m.major_name,
        COUNT(DISTINCT e.course_id) as courses_enrolled,
        COUNT(DISTINCT CASE WHEN e.status = 'completed' THEN e.course_id END) as courses_completed,
        COUNT(g.score) as total_assignments,
        COUNT(CASE WHEN g.score IS NOT NULL THEN 1 END) as assignments_submitted,
        COALESCE(AVG(g.score), 0.00) as average_score,
        COALESCE(SUM(CASE WHEN e.status = 'completed' THEN c.credits ELSE 0 END), 0) as credits_earned
    FROM main_students s
    JOIN majors m ON s.major_id = m.major_id
    LEFT JOIN main_enrollments e ON s.student_id = e.student_id 
        AND e.enrollment_date BETWEEN first_day AND last_day
    LEFT JOIN main_courses c ON e.course_id = c.course_id
    LEFT JOIN main_grades g ON s.student_id = g.student_id 
        AND g.submission_date BETWEEN first_day AND last_day
    GROUP BY s.student_id, s.student_name, m.major_name;
END //

-- 年次サマリ更新プロシージャ
CREATE PROCEDURE sync_annual_summary(IN target_year INT)
BEGIN
    DELETE FROM report_annual_summary WHERE academic_year = target_year;
    
    INSERT INTO report_annual_summary 
        (academic_year, student_id, student_name, major_name, year_level,
         total_courses, completed_courses, cumulative_gpa, total_credits, academic_status)
    SELECT 
        target_year,
        s.student_id,
        s.student_name,
        m.major_name,
        target_year - YEAR(s.admission_date) + 1 as year_level,
        COUNT(DISTINCT e.course_id) as total_courses,
        COUNT(DISTINCT CASE WHEN e.status = 'completed' THEN e.course_id END) as completed_courses,
        COALESCE(AVG(g.score) / 25.0, 0.00) as cumulative_gpa,
        COALESCE(SUM(CASE WHEN e.status = 'completed' THEN c.credits ELSE 0 END), 0) as total_credits,
        CASE 
            WHEN AVG(g.score) >= 90 THEN 'Excellent'
            WHEN AVG(g.score) >= 80 THEN 'Good'
            WHEN AVG(g.score) >= 70 THEN 'Satisfactory'
            ELSE 'Needs Improvement'
        END as academic_status
    FROM main_students s
    JOIN majors m ON s.major_id = m.major_id
    LEFT JOIN main_enrollments e ON s.student_id = e.student_id
    LEFT JOIN main_courses c ON e.course_id = c.course_id
    LEFT JOIN main_grades g ON s.student_id = g.student_id
    WHERE YEAR(s.admission_date) <= target_year
    GROUP BY s.student_id, s.student_name, m.major_name, year_level;
END //

-- 自動同期トリガー
CREATE TRIGGER sync_on_grade_insert
AFTER INSERT ON main_grades
FOR EACH ROW
BEGIN
    CALL sync_monthly_summary(NEW.submission_date);
END //

CREATE TRIGGER sync_on_enrollment_update
AFTER UPDATE ON main_enrollments
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        CALL sync_monthly_summary(CURRENT_DATE);
    END IF;
END //

DELIMITER ;

-- 4. 高速レポート生成
-- 月次レポート
SELECT 
    student_name,
    major_name,
    courses_enrolled,
    courses_completed,
    average_score,
    credits_earned
FROM report_monthly_summary
WHERE report_month = '2025-05-01'
ORDER BY average_score DESC;

-- 年次レポート
SELECT 
    major_name,
    COUNT(*) as student_count,
    AVG(cumulative_gpa) as avg_gpa,
    SUM(total_credits) as total_credits,
    academic_status,
    COUNT(*) as status_count
FROM report_annual_summary
WHERE academic_year = 2025
GROUP BY major_name, academic_status
ORDER BY major_name, avg_gpa DESC;
```

### 解答38-5
```sql
-- パフォーマンス最適化設計

-- 1. 正規化コアテーブル（データ整合性重視）
CREATE TABLE core_students_optimized (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    major_id INT,
    admission_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    
    INDEX idx_major_active (major_id, is_active),
    INDEX idx_admission_date (admission_date)
);

CREATE TABLE core_grades_optimized (
    grade_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    grade_type VARCHAR(32) NOT NULL,
    score DECIMAL(5,2),
    max_score DECIMAL(5,2) DEFAULT 100,
    submission_date DATE,
    
    FOREIGN KEY (student_id) REFERENCES core_students_optimized(student_id),
    INDEX idx_student_submission (student_id, submission_date),
    INDEX idx_course_type (course_id, grade_type),
    INDEX idx_score_range (score)
);

-- 2. 高速検索用非正規化テーブル
CREATE TABLE fast_student_grades (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100),           -- 非正規化
    major_name VARCHAR(100),             -- 非正規化
    total_grades INT DEFAULT 0,
    current_semester_avg DECIMAL(5,2) DEFAULT 0.00,
    cumulative_avg DECIMAL(5,2) DEFAULT 0.00,
    highest_score DECIMAL(5,2) DEFAULT 0.00,
    lowest_score DECIMAL(5,2) DEFAULT 0.00,
    last_grade_date DATE,
    grade_trend ENUM('improving', 'stable', 'declining') DEFAULT 'stable',
    performance_rank INT DEFAULT 0,
    cache_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_cumulative_avg (cumulative_avg),
    INDEX idx_performance_rank (performance_rank),
    INDEX idx_major_performance (major_name, cumulative_avg)
);

-- 3. 講座統計専用テーブル
CREATE TABLE fast_course_statistics (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128),            -- 非正規化
    teacher_name VARCHAR(64),            -- 非正規化
    enrolled_count INT DEFAULT 0,
    grades_count INT DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0.00,
    pass_rate DECIMAL(5,2) DEFAULT 0.00,
    difficulty_index DECIMAL(5,2) DEFAULT 0.00,
    completion_rate DECIMAL(5,2) DEFAULT 0.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_average_score (average_score),
    INDEX idx_pass_rate (pass_rate),
    INDEX idx_teacher_course (teacher_name, average_score)
);

-- 4. 高性能更新システム
DELIMITER //

-- 学生成績キャッシュ更新（最適化版）
CREATE PROCEDURE fast_update_student_cache(IN p_student_id BIGINT)
BEGIN
    DECLARE v_student_name VARCHAR(100);
    DECLARE v_major_name VARCHAR(100);
    DECLARE v_total_grades INT;
    DECLARE v_current_avg DECIMAL(5,2);
    DECLARE v_cumulative_avg DECIMAL(5,2);
    DECLARE v_highest DECIMAL(5,2);
    DECLARE v_lowest DECIMAL(5,2);
    DECLARE v_last_date DATE;
    DECLARE v_trend ENUM('improving', 'stable', 'declining');
    
    -- 効率的な一回のクエリで全統計を取得
    SELECT 
        s.student_name,
        m.major_name,
        COUNT(g.grade_id),
        COALESCE(AVG(CASE WHEN g.submission_date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH) 
                          THEN g.score END), 0),
        COALESCE(AVG(g.score), 0),
        COALESCE(MAX(g.score), 0),
        COALESCE(MIN(g.score), 0),
        MAX(g.submission_date)
    INTO v_student_name, v_major_name, v_total_grades, v_current_avg, 
         v_cumulative_avg, v_highest, v_lowest, v_last_date
    FROM core_students_optimized s
    LEFT JOIN majors m ON s.major_id = m.major_id
    LEFT JOIN core_grades_optimized g ON s.student_id = g.student_id
    WHERE s.student_id = p_student_id
    GROUP BY s.student_id, s.student_name, m.major_name;
    
    -- トレンド計算
    SET v_trend = CASE
        WHEN v_current_avg > v_cumulative_avg + 5 THEN 'improving'
        WHEN v_current_avg < v_cumulative_avg - 5 THEN 'declining'
        ELSE 'stable'
    END;
    
    -- キャッシュ更新
    INSERT INTO fast_student_grades 
        (student_id, student_name, major_name, total_grades, current_semester_avg,
         cumulative_avg, highest_score, lowest_score, last_grade_date, grade_trend)
    VALUES 
        (p_student_id, v_student_name, v_major_name, v_total_grades, v_current_avg,
         v_cumulative_avg, v_highest, v_lowest, v_last_date, v_trend)
    ON DUPLICATE KEY UPDATE
        student_name = v_student_name,
        major_name = v_major_name,
        total_grades = v_total_grades,
        current_semester_avg = v_current_avg,
        cumulative_avg = v_cumulative_avg,
        highest_score = v_highest,
        lowest_score = v_lowest,
        last_grade_date = v_last_date,
        grade_trend = v_trend;
END //

-- 講座統計更新（最適化版）
CREATE PROCEDURE fast_update_course_statistics(IN p_course_id VARCHAR(16))
BEGIN
    DECLARE v_course_name VARCHAR(128);
    DECLARE v_teacher_name VARCHAR(64);
    DECLARE v_enrolled_count INT;
    DECLARE v_grades_count INT;
    DECLARE v_average_score DECIMAL(5,2);
    DECLARE v_pass_rate DECIMAL(5,2);
    DECLARE v_completion_rate DECIMAL(5,2);
    
    SELECT 
        c.course_name,
        t.teacher_name,
        enrollment_stats.enrolled_count,
        grade_stats.grades_count,
        grade_stats.average_score,
        grade_stats.pass_rate,
        enrollment_stats.completion_rate
    INTO v_course_name, v_teacher_name, v_enrolled_count, v_grades_count,
         v_average_score, v_pass_rate, v_completion_rate
    FROM courses c
    JOIN teachers t ON c.teacher_id = t.teacher_id
    LEFT JOIN (
        SELECT 
            e.course_id,
            COUNT(*) as enrolled_count,
            COUNT(CASE WHEN e.status = 'completed' THEN 1 END) * 100.0 / COUNT(*) as completion_rate
        FROM enrollments e
        WHERE e.course_id = p_course_id
        GROUP BY e.course_id
    ) enrollment_stats ON c.course_id = enrollment_stats.course_id
    LEFT JOIN (
        SELECT 
            g.course_id,
            COUNT(*) as grades_count,
            AVG(g.score) as average_score,
            AVG(CASE WHEN g.score >= 60 THEN 100.0 ELSE 0 END) as pass_rate
        FROM core_grades_optimized g
        WHERE g.course_id = p_course_id
        GROUP BY g.course_id
    ) grade_stats ON c.course_id = grade_stats.course_id
    WHERE c.course_id = p_course_id;
    
    INSERT INTO fast_course_statistics 
        (course_id, course_name, teacher_name, enrolled_count, grades_count,
         average_score, pass_rate, completion_rate)
    VALUES 
        (p_course_id, v_course_name, v_teacher_name, COALESCE(v_enrolled_count, 0),
         COALESCE(v_grades_count, 0), COALESCE(v_average_score, 0),
         COALESCE(v_pass_rate, 0), COALESCE(v_completion_rate, 0))
    ON DUPLICATE KEY UPDATE
        course_name = v_course_name,
        teacher_name = v_teacher_name,
        enrolled_count = COALESCE(v_enrolled_count, 0),
        grades_count = COALESCE(v_grades_count, 0),
        average_score = COALESCE(v_average_score, 0),
        pass_rate = COALESCE(v_pass_rate, 0),
        completion_rate = COALESCE(v_completion_rate, 0);
END //

-- 自動更新トリガー（最適化版）
CREATE TRIGGER optimized_grade_update
AFTER INSERT ON core_grades_optimized
FOR EACH ROW
BEGIN
    -- 非同期的な更新のため、バッチ処理フラグを設定
    INSERT IGNORE INTO update_queue (table_name, record_id, update_type)
    VALUES ('student_cache', NEW.student_id, 'grade_change');
    
    INSERT IGNORE INTO update_queue (table_name, record_id, update_type)
    VALUES ('course_stats', NEW.course_id, 'grade_change');
END //

DELIMITER ;

-- 5. 高速検索クエリ例
-- 学生成績検索（1秒以内）
SELECT 
    student_name,
    major_name,
    cumulative_avg,
    grade_trend,
    performance_rank
FROM fast_student_grades
WHERE major_name = '情報工学科'
  AND cumulative_avg >= 80
ORDER BY performance_rank
LIMIT 50;

-- 講座統計生成（3秒以内）
SELECT 
    course_name,
    teacher_name,
    enrolled_count,
    average_score,
    pass_rate,
    difficulty_index
FROM fast_course_statistics
WHERE average_score >= 70
ORDER BY pass_rate DESC, average_score DESC;
```

### 解答38-6
```sql
-- オンライン学習プラットフォームの包括的スキーマ設計

-- 1. 正規化されたコアエンティティ（3NF準拠）

-- ユーザー管理
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('student', 'instructor', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE user_profiles (
    user_id BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    avatar_url VARCHAR(500),
    bio TEXT,
    timezone VARCHAR(50) DEFAULT 'UTC',
    language VARCHAR(10) DEFAULT 'en',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- カテゴリ・コース管理
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT,
    description TEXT,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

CREATE TABLE courses (
    course_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_title VARCHAR(200) NOT NULL,
    course_description TEXT,
    instructor_id BIGINT NOT NULL,
    category_id INT,
    difficulty_level ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    estimated_duration_hours INT,
    price DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_published BOOLEAN DEFAULT FALSE,
    
    FOREIGN KEY (instructor_id) REFERENCES users(user_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- レッスン・コンテンツ管理
CREATE TABLE lessons (
    lesson_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT NOT NULL,
    lesson_title VARCHAR(200) NOT NULL,
    lesson_description TEXT,
    lesson_order INT NOT NULL,
    content_type ENUM('video', 'text', 'quiz', 'assignment') NOT NULL,
    content_url VARCHAR(500),
    duration_minutes INT,
    is_preview BOOLEAN DEFAULT FALSE,
    
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_course_order (course_id, lesson_order)
);

CREATE TABLE lesson_content (
    content_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lesson_id BIGINT NOT NULL,
    content_type ENUM('video', 'text', 'pdf', 'code', 'quiz') NOT NULL,
    content_data JSON,  -- 柔軟なコンテンツ格納
    file_url VARCHAR(500),
    file_size BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id) ON DELETE CASCADE
);

-- 課題・評価管理
CREATE TABLE assignments (
    assignment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT NOT NULL,
    lesson_id BIGINT,
    assignment_title VARCHAR(200) NOT NULL,
    description TEXT,
    assignment_type ENUM('quiz', 'project', 'essay', 'code') NOT NULL,
    max_score DECIMAL(5,2) DEFAULT 100,
    time_limit_minutes INT,
    due_date TIMESTAMP,
    instructions JSON,
    
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id) ON DELETE SET NULL
);

-- 受講・進捗管理
CREATE TABLE enrollments (
    enrollment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    progress_percentage DECIMAL(5,2) DEFAULT 0.00,
    last_accessed TIMESTAMP,
    status ENUM('active', 'completed', 'paused', 'cancelled') DEFAULT 'active',
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (user_id, course_id)
);

CREATE TABLE lesson_progress (
    progress_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,
    watched_duration_seconds INT DEFAULT 0,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00,
    is_completed BOOLEAN DEFAULT FALSE,
    first_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id) ON DELETE CASCADE,
    UNIQUE KEY unique_lesson_progress (user_id, lesson_id)
);

-- 支払い・サブスクリプション管理
CREATE TABLE subscription_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    plan_type ENUM('monthly', 'yearly', 'lifetime') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    features JSON,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE payments (
    payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT,
    plan_id INT,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_method ENUM('credit_card', 'paypal', 'bank_transfer') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    transaction_id VARCHAR(100) UNIQUE,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE SET NULL,
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id) ON DELETE SET NULL,
    INDEX idx_user_payment (user_id, processed_at),
    INDEX idx_status (payment_status)
);

CREATE TABLE user_subscriptions (
    subscription_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    plan_id INT NOT NULL,
    payment_id BIGINT,
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP NOT NULL,
    status ENUM('active', 'expired', 'cancelled') DEFAULT 'active',
    auto_renewal BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id),
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id),
    INDEX idx_user_subscription (user_id, status),
    INDEX idx_expiry (end_date, status)
);

-- 2. 非正規化されたパフォーマンステーブル

-- 学習分析用高速テーブル
CREATE TABLE analytics_user_summary (
    user_id BIGINT PRIMARY KEY,
    username VARCHAR(50),                    -- 非正規化
    full_name VARCHAR(101),                  -- 非正規化（first_name + last_name）
    user_type ENUM('student', 'instructor', 'admin'),
    total_courses_enrolled INT DEFAULT 0,
    total_courses_completed INT DEFAULT 0,
    total_lessons_watched INT DEFAULT 0,
    total_watch_time_hours DECIMAL(8,2) DEFAULT 0.00,
    average_completion_rate DECIMAL(5,2) DEFAULT 0.00,
    last_learning_activity TIMESTAMP,
    learning_streak_days INT DEFAULT 0,
    skill_level ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    preferred_category_id INT,
    preferred_category_name VARCHAR(100),    -- 非正規化
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_completion_rate (average_completion_rate),
    INDEX idx_skill_level (skill_level),
    INDEX idx_category_preference (preferred_category_id)
);

-- コース統計用高速テーブル
CREATE TABLE analytics_course_summary (
    course_id BIGINT PRIMARY KEY,
    course_title VARCHAR(200),               -- 非正規化
    instructor_name VARCHAR(101),            -- 非正規化
    category_name VARCHAR(100),              -- 非正規化
    total_enrollments INT DEFAULT 0,
    active_enrollments INT DEFAULT 0,
    completion_count INT DEFAULT 0,
    completion_rate DECIMAL(5,2) DEFAULT 0.00,
    average_rating DECIMAL(3,2) DEFAULT 0.00,
    total_revenue DECIMAL(12,2) DEFAULT 0.00,
    avg_watch_time_per_lesson DECIMAL(8,2) DEFAULT 0.00,
    student_engagement_score DECIMAL(5,2) DEFAULT 0.00,
    last_enrollment_date TIMESTAMP,
    performance_trend ENUM('improving', 'stable', 'declining') DEFAULT 'stable',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_completion_rate (completion_rate),
    INDEX idx_rating (average_rating),
    INDEX idx_revenue (total_revenue)
);

-- リアルタイム学習活動ログ
CREATE TABLE analytics_learning_sessions (
    session_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    lesson_id BIGINT,
    session_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_end TIMESTAMP,
    duration_seconds INT,
    device_type ENUM('desktop', 'tablet', 'mobile') DEFAULT 'desktop',
    browser VARCHAR(50),
    ip_address VARCHAR(45),
    location_country VARCHAR(50),
    actions_taken JSON,                      -- クリック、一時停止、巻き戻し等
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_session (user_id, session_start),
    INDEX idx_course_session (course_id, session_start),
    PARTITION BY RANGE (UNIX_TIMESTAMP(session_start)) (
        PARTITION p_2025_01 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01')),
        PARTITION p_2025_02 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01')),
        PARTITION p_2025_03 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01')),
        PARTITION p_2025_04 VALUES LESS THAN (UNIX_TIMESTAMP('2025-05-01')),
        PARTITION p_2025_05 VALUES LESS THAN (UNIX_TIMESTAMP('2025-06-01')),
        PARTITION p_future VALUES LESS THAN MAXVALUE
    )
);

-- 3. 自動更新・同期システム
DELIMITER //

-- ユーザー学習サマリ更新
CREATE PROCEDURE update_user_analytics(IN p_user_id BIGINT)
BEGIN
    DECLARE v_username VARCHAR(50);
    DECLARE v_full_name VARCHAR(101);
    DECLARE v_user_type ENUM('student', 'instructor', 'admin');
    DECLARE v_total_enrolled INT DEFAULT 0;
    DECLARE v_total_completed INT DEFAULT 0;
    DECLARE v_total_lessons INT DEFAULT 0;
    DECLARE v_total_watch_time DECIMAL(8,2) DEFAULT 0.00;
    DECLARE v_avg_completion DECIMAL(5,2) DEFAULT 0.00;
    DECLARE v_last_activity TIMESTAMP;
    DECLARE v_preferred_category_id INT;
    DECLARE v_preferred_category_name VARCHAR(100);
    
    -- 基本情報取得
    SELECT 
        u.username,
        CONCAT(p.first_name, ' ', p.last_name),
        u.user_type
    INTO v_username, v_full_name, v_user_type
    FROM users u
    LEFT JOIN user_profiles p ON u.user_id = p.user_id
    WHERE u.user_id = p_user_id;
    
    -- 学習統計計算
    SELECT 
        COUNT(DISTINCT e.course_id),
        COUNT(DISTINCT CASE WHEN e.status = 'completed' THEN e.course_id END),
        COUNT(DISTINCT lp.lesson_id),
        COALESCE(SUM(lp.watched_duration_seconds) / 3600.0, 0),
        COALESCE(AVG(e.progress_percentage), 0),
        MAX(e.last_accessed)
    INTO 
        v_total_enrolled, v_total_completed, v_total_lessons,
        v_total_watch_time, v_avg_completion, v_last_activity
    FROM enrollments e
    LEFT JOIN lesson_progress lp ON e.user_id = lp.user_id
    WHERE e.user_id = p_user_id;
    
    -- 好みのカテゴリ分析
    SELECT 
        c.category_id,
        cat.category_name
    INTO v_preferred_category_id, v_preferred_category_name
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
    JOIN categories cat ON c.category_id = cat.category_id
    WHERE e.user_id = p_user_id
    GROUP BY c.category_id, cat.category_name
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    
    -- サマリテーブル更新
    INSERT INTO analytics_user_summary 
        (user_id, username, full_name, user_type, total_courses_enrolled,
         total_courses_completed, total_lessons_watched, total_watch_time_hours,
         average_completion_rate, last_learning_activity, preferred_category_id,
         preferred_category_name)
    VALUES 
        (p_user_id, v_username, v_full_name, v_user_type, v_total_enrolled,
         v_total_completed, v_total_lessons, v_total_watch_time,
         v_avg_completion, v_last_activity, v_preferred_category_id,
         v_preferred_category_name)
    ON DUPLICATE KEY UPDATE
        username = v_username,
        full_name = v_full_name,
        total_courses_enrolled = v_total_enrolled,
        total_courses_completed = v_total_completed,
        total_lessons_watched = v_total_lessons,
        total_watch_time_hours = v_total_watch_time,
        average_completion_rate = v_avg_completion,
        last_learning_activity = v_last_activity,
        preferred_category_id = v_preferred_category_id,
        preferred_category_name = v_preferred_category_name;
END //

-- コース統計更新
CREATE PROCEDURE update_course_analytics(IN p_course_id BIGINT)
BEGIN
    DECLARE v_course_title VARCHAR(200);
    DECLARE v_instructor_name VARCHAR(101);
    DECLARE v_category_name VARCHAR(100);
    DECLARE v_total_enrollments INT;
    DECLARE v_active_enrollments INT;
    DECLARE v_completion_count INT;
    DECLARE v_completion_rate DECIMAL(5,2);
    DECLARE v_total_revenue DECIMAL(12,2);
    DECLARE v_avg_watch_time DECIMAL(8,2);
    
    -- コース基本情報
    SELECT 
        c.course_title,
        CONCAT(p.first_name, ' ', p.last_name),
        cat.category_name
    INTO v_course_title, v_instructor_name, v_category_name
    FROM courses c
    JOIN users u ON c.instructor_id = u.user_id
    LEFT JOIN user_profiles p ON u.user_id = p.user_id
    LEFT JOIN categories cat ON c.category_id = cat.category_id
    WHERE c.course_id = p_course_id;
    
    -- 受講統計
    SELECT 
        COUNT(*),
        COUNT(CASE WHEN status = 'active' THEN 1 END),
        COUNT(CASE WHEN status = 'completed' THEN 1 END),
        CASE WHEN COUNT(*) > 0 
             THEN COUNT(CASE WHEN status = 'completed' THEN 1 END) * 100.0 / COUNT(*)
             ELSE 0 END
    INTO v_total_enrollments, v_active_enrollments, v_completion_count, v_completion_rate
    FROM enrollments
    WHERE course_id = p_course_id;
    
    -- 収益計算
    SELECT COALESCE(SUM(amount), 0)
    INTO v_total_revenue
    FROM payments
    WHERE course_id = p_course_id AND payment_status = 'completed';
    
    -- 平均視聴時間
    SELECT COALESCE(AVG(lp.watched_duration_seconds / 60.0), 0)
    INTO v_avg_watch_time
    FROM lesson_progress lp
    JOIN lessons l ON lp.lesson_id = l.lesson_id
    WHERE l.course_id = p_course_id;
    
    -- 統計テーブル更新
    INSERT INTO analytics_course_summary 
        (course_id, course_title, instructor_name, category_name,
         total_enrollments, active_enrollments, completion_count, completion_rate,
         total_revenue, avg_watch_time_per_lesson)
    VALUES 
        (p_course_id, v_course_title, v_instructor_name, v_category_name,
         v_total_enrollments, v_active_enrollments, v_completion_count, v_completion_rate,
         v_total_revenue, v_avg_watch_time)
    ON DUPLICATE KEY UPDATE
        course_title = v_course_title,
        instructor_name = v_instructor_name,
        category_name = v_category_name,
        total_enrollments = v_total_enrollments,
        active_enrollments = v_active_enrollments,
        completion_count = v_completion_count,
        completion_rate = v_completion_rate,
        total_revenue = v_total_revenue,
        avg_watch_time_per_lesson = v_avg_watch_time;
END //

-- リアルタイム更新トリガー
CREATE TRIGGER update_analytics_on_enrollment
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
    CALL update_user_analytics(NEW.user_id);
    CALL update_course_analytics(NEW.course_id);
END //

CREATE TRIGGER update_analytics_on_progress
AFTER UPDATE ON lesson_progress
FOR EACH ROW
BEGIN
    IF NEW.completion_percentage != OLD.completion_percentage THEN
        CALL update_user_analytics(NEW.user_id);
    END IF;
END //

DELIMITER ;

-- 4. 高速レポート・分析クエリ例

-- ダッシュボード用KPI取得
SELECT 
    'user_metrics' as metric_type,
    COUNT(DISTINCT user_id) as total_users,
    AVG(total_courses_enrolled) as avg_courses_per_user,
    AVG(average_completion_rate) as platform_completion_rate,
    SUM(total_watch_time_hours) as total_platform_hours
FROM analytics_user_summary
WHERE user_type = 'student'
UNION ALL
SELECT 
    'course_metrics',
    COUNT(DISTINCT course_id),
    AVG(total_enrollments),
    AVG(completion_rate),
    SUM(total_revenue)
FROM analytics_course_summary;

-- 人気コースランキング
SELECT 
    course_title,
    instructor_name,
    category_name,
    total_enrollments,
    completion_rate,
    average_rating,
    total_revenue
FROM analytics_course_summary
WHERE total_enrollments > 50
ORDER BY completion_rate DESC, total_enrollments DESC
LIMIT 20;

-- 学習者エンゲージメント分析
SELECT 
    preferred_category_name,
    skill_level,
    COUNT(*) as user_count,
    AVG(average_completion_rate) as avg_completion,
    AVG(total_watch_time_hours) as avg_watch_time,
    AVG(learning_streak_days) as avg_streak
FROM analytics_user_summary
WHERE user_type = 'student'
  AND last_learning_activity >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY preferred_category_name, skill_level
ORDER BY user_count DESC;

-- 収益分析
SELECT 
    DATE_FORMAT(processed_at, '%Y-%m') as month,
    COUNT(*) as transaction_count,
    SUM(amount) as total_revenue,
    AVG(amount) as avg_transaction_value,
    COUNT(DISTINCT user_id) as paying_users
FROM payments
WHERE payment_status = 'completed'
  AND processed_at >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(processed_at, '%Y-%m')
ORDER BY month DESC;

-- リアルタイム学習活動
SELECT 
    DATE_FORMAT(session_start, '%Y-%m-%d %H:00:00') as hour_bucket,
    COUNT(DISTINCT user_id) as active_users,
    COUNT(*) as total_sessions,
    AVG(duration_seconds / 60) as avg_session_minutes,
    device_type,
    COUNT(*) as device_sessions
FROM analytics_learning_sessions
WHERE session_start >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
GROUP BY hour_bucket, device_type
ORDER BY hour_bucket DESC, device_sessions DESC;
```

## まとめ

この章では、スキーマ設計における正規化と非正規化について詳しく学びました：

1. **正規化の理論と実践**：
   - 第1正規形（1NF）：原子値と繰り返しグループの排除
   - 第2正規形（2NF）：部分関数従属の排除
   - 第3正規形（3NF）：推移関数従属の排除
   - 段階的な正規化プロセス

2. **正規化の利点と課題**：
   - データ整合性の向上
   - 冗長性の排除
   - クエリの複雑化
   - パフォーマンスへの影響

3. **非正規化の戦略**：
   - 計算済み値の事前格納
   - 頻繁な結合結果の物理化
   - レポート専用テーブルの設計
   - キャッシュテーブルの活用

4. **ハイブリッド設計**：
   - 正規化コアテーブルの維持
   - 非正規化パフォーマンステーブルの追加
   - 自動同期システムの構築
   - 一貫性保証の仕組み

5. **設計判断基準**：
   - データ整合性要件
   - パフォーマンス要件
   - 更新頻度と読み取り頻度
   - 保守性とスケーラビリティ

6. **実践的な設計例**：
   - 学校管理システム
   - 図書館システム
   - オンライン学習プラットフォーム
   - 包括的なエンタープライズシステム

正規化と非正規化は対立する概念ではなく、システムの要件に応じて適切に組み合わせることが重要です。データの整合性を保ちつつ、必要なパフォーマンスを実現する**バランスの取れた設計**が、実用的なデータベースシステムの鍵となります。

これで第6章「データ定義言語（DDL）と管理」が完了しました。CREATE TABLE、ALTER TABLE、DROP/TRUNCATE、制約、AUTO_INCREMENT、マテリアライズドビュー、スキーマ設計まで、データベース構造の設計・管理に必要な包括的な知識を習得できました。