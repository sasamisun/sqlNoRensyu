# 35. 制約：主キー、外部キー、CHECK制約

## はじめに

前章では、テーブルの削除とクリアについて学習しました。この章では、データベースの整合性と品質を保つための「制約（Constraint）」について詳しく学習します。

制約は、テーブルに格納されるデータが満たすべき条件や規則を定義する仕組みです。制約を適切に設定することで、不正なデータの挿入を防ぎ、データベース全体の整合性を保つことができます。

制約が重要となる場面の例：
- 「学生IDは重複してはいけない（一意性の保証）」
- 「成績の点数は0点以上100点以下でなければならない（値の範囲制限）」
- 「学生の受講記録は、実在する学生と講座を参照しなければならない（参照整合性）」
- 「教師名は必須項目であり、空白は許可しない（必須項目の保証）」
- 「メールアドレスは一意でなければならない（重複防止）」
- 「入学日は現在日より前でなければならない（論理的整合性）」
- 「学年は1年から6年の範囲内でなければならない（値の妥当性）」

この章では、MySQLの主要な制約である主キー制約、外部キー制約、CHECK制約、UNIQUE制約、NOT NULL制約について詳しく学んでいきます。

## 制約とは

制約（Constraint）は、テーブルのカラムやテーブル全体に対して設定する、データの整合性を保つための規則です。制約に違反するデータの挿入や更新は自動的に拒否され、エラーが発生します。

> **用語解説**：
> - **制約（Constraint）**：データベースに格納されるデータが満たすべき条件や規則です。
> - **主キー制約（PRIMARY KEY）**：テーブル内の各行を一意に識別するための制約です。
> - **外部キー制約（FOREIGN KEY）**：他のテーブルとの関連性を保証する制約です。
> - **CHECK制約**：カラムの値が特定の条件を満たすことを保証する制約です。
> - **UNIQUE制約**：カラムの値が一意（重複なし）であることを保証する制約です。
> - **NOT NULL制約**：カラムにNULL値の格納を禁止する制約です。
> - **DEFAULT制約**：カラムの値が指定されなかった場合のデフォルト値を設定する制約です。
> - **参照整合性**：外部キーによって関連付けられたテーブル間でデータの整合性が保たれている状態です。
> - **カスケード動作**：参照先の変更時に参照元も自動的に変更される動作です。
> - **制約違反**：データが制約の条件を満たさない状態で、エラーが発生します。

## 制約の種類と概要

| 制約の種類 | 目的 | 例 |
|-----------|------|-----|
| **PRIMARY KEY** | 行の一意識別 | 学生ID、講座ID |
| **FOREIGN KEY** | テーブル間の関連性保証 | 成績テーブルの学生ID |
| **UNIQUE** | 値の一意性保証 | メールアドレス、学籍番号 |
| **NOT NULL** | 必須項目の保証 | 学生名、講座名 |
| **CHECK** | 値の範囲・条件制限 | 成績（0-100点）、学年（1-6年） |
| **DEFAULT** | デフォルト値の設定 | 登録日時、ステータス |

## 主キー制約（PRIMARY KEY）

### 1. 主キー制約の基本概念

主キー制約は、テーブル内の各行を一意に識別するためのカラム（または複数カラムの組み合わせ）を指定します。

#### 主キーの特性
- **一意性**：同じ値を持つ行は存在できません
- **NOT NULL**：NULL値は許可されません
- **不変性**：一度設定された主キー値は変更すべきではありません
- **単一性**：1つのテーブルに1つだけ設定できます

### 2. 主キー制約の設定方法

#### テーブル作成時の設定

```sql
-- 方法1: カラム定義時に指定
CREATE TABLE students_pk_demo (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

-- 方法2: テーブル制約として指定
CREATE TABLE teachers_pk_demo (
    teacher_id BIGINT NOT NULL,
    teacher_name VARCHAR(100) NOT NULL,
    
    PRIMARY KEY (teacher_id)
);

-- 方法3: 複合主キー（複数カラムの組み合わせ）
CREATE TABLE enrollment_pk_demo (
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    enrollment_date DATE NOT NULL,
    
    PRIMARY KEY (student_id, course_id)
);
```

#### AUTO_INCREMENTとの組み合わせ

```sql
-- 自動増加する主キー
CREATE TABLE auto_pk_demo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- データ挿入（IDは自動設定）
INSERT INTO auto_pk_demo (data) VALUES ('データ1'), ('データ2');

-- 結果確認
SELECT * FROM auto_pk_demo;
```

### 3. 既存テーブルへの主キー追加

```sql
-- 主キーなしのテーブル作成
CREATE TABLE no_pk_table (
    id INT,
    name VARCHAR(100)
);

-- データ挿入
INSERT INTO no_pk_table VALUES (1, 'データ1'), (2, 'データ2');

-- 主キー制約の追加
ALTER TABLE no_pk_table ADD PRIMARY KEY (id);

-- 確認
DESCRIBE no_pk_table;
```

### 4. 主キー制約のエラー例

```sql
-- 重複エラーのテスト
CREATE TABLE pk_error_test (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO pk_error_test VALUES (1, 'データ1');
-- INSERT INTO pk_error_test VALUES (1, 'データ2');  -- エラー: Duplicate entry '1'

-- NULL値エラーのテスト
-- INSERT INTO pk_error_test VALUES (NULL, 'データ3');  -- エラー: Column 'id' cannot be null
```

## 外部キー制約（FOREIGN KEY）

### 1. 外部キー制約の基本概念

外部キー制約は、あるテーブルのカラムが別のテーブルの主キーを参照することを保証します。これにより、テーブル間の参照整合性が維持されます。

#### 外部キーの特性
- **参照整合性**：参照先のレコードが存在することを保証
- **カスケード動作**：参照先の変更時の動作を制御
- **パフォーマンス**：結合処理の最適化に貢献

### 2. 外部キー制約の設定方法

#### 基本的な外部キー設定

```sql
-- 親テーブル（参照される側）
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- 子テーブル（参照する側）
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dept_id INT,
    
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- テストデータ挿入
INSERT INTO departments VALUES (1, '営業部'), (2, '開発部'), (3, '総務部');
INSERT INTO employees VALUES (101, '田中太郎', 1), (102, '佐藤花子', 2);
```

#### カスケード動作の設定

```sql
-- カスケード動作付きの外部キー制約
CREATE TABLE students_fk_demo (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE
);

CREATE TABLE enrollments_fk_demo (
    enrollment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    course_name VARCHAR(100),
    enrollment_date DATE,
    
    FOREIGN KEY (student_id) REFERENCES students_fk_demo(student_id)
        ON DELETE CASCADE        -- 親が削除されたら子も削除
        ON UPDATE CASCADE        -- 親が更新されたら子も更新
);

-- テストデータ
INSERT INTO students_fk_demo VALUES (301, '山田次郎', 'yamada@example.com');
INSERT INTO enrollments_fk_demo (student_id, course_name, enrollment_date) 
VALUES (301, 'データベース基礎', '2025-04-01');

-- カスケード削除のテスト
DELETE FROM students_fk_demo WHERE student_id = 301;

-- 関連する enrollment レコードも自動削除されることを確認
SELECT * FROM enrollments_fk_demo WHERE student_id = 301;
```

### 3. カスケード動作の種類

| 動作 | 説明 | 使用場面 |
|------|------|----------|
| **CASCADE** | 親の変更に合わせて子も変更 | 強い関連性がある場合 |
| **SET NULL** | 親が削除されたら子はNULLに | 参照が必須でない場合 |
| **SET DEFAULT** | 親が削除されたらデフォルト値に | デフォルト値が設定されている場合 |
| **RESTRICT** | 子がある限り親の変更を禁止 | データ保護が重要な場合 |
| **NO ACTION** | RESTRICTと同様（MySQLでは同じ） | RESTRICTと同じ |

```sql
-- 異なるカスケード動作の例
CREATE TABLE courses_fk_demo (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

CREATE TABLE grades_fk_demo (
    grade_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT,
    course_id VARCHAR(16),
    score DECIMAL(5,2),
    
    FOREIGN KEY (student_id) REFERENCES students_fk_demo(student_id)
        ON DELETE SET NULL       -- 学生削除時はNULLに
        ON UPDATE CASCADE,       -- 学生ID更新時は追従
        
    FOREIGN KEY (course_id) REFERENCES courses_fk_demo(course_id)
        ON DELETE RESTRICT       -- 講座に成績がある場合は削除禁止
        ON UPDATE CASCADE        -- 講座ID更新時は追従
);
```

### 4. 外部キー制約のエラー例

```sql
-- 参照整合性エラーのテスト
-- INSERT INTO employees VALUES (103, '鈴木一郎', 99);  -- エラー: 存在しない部署ID

-- 親レコード削除エラーのテスト（RESTRICT設定時）
-- DELETE FROM departments WHERE dept_id = 1;  -- エラー: 参照している子レコードが存在
```

## CHECK制約（MySQL 8.0以降）

### 1. CHECK制約の基本概念

CHECK制約は、カラムに格納される値が特定の条件を満たすことを保証します。値の範囲制限や形式チェックに使用されます。

### 2. CHECK制約の設定方法

#### 基本的なCHECK制約

```sql
-- 成績管理テーブルのCHECK制約例
CREATE TABLE student_scores (
    score_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    subject VARCHAR(100) NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    grade_level INT NOT NULL,
    exam_date DATE NOT NULL,
    
    -- 点数の範囲制限
    CHECK (score >= 0 AND score <= 100),
    
    -- 学年の範囲制限
    CHECK (grade_level >= 1 AND grade_level <= 6),
    
    -- 試験日は現在日以前
    CHECK (exam_date <= CURRENT_DATE)
);

-- 有効なデータの挿入
INSERT INTO student_scores (student_id, subject, score, grade_level, exam_date)
VALUES (301, '数学', 85.5, 3, '2025-05-20');

-- 無効なデータの挿入（エラーになる）
-- INSERT INTO student_scores (student_id, subject, score, grade_level, exam_date)
-- VALUES (302, '英語', 105, 3, '2025-05-20');  -- エラー: score > 100
```

#### 複雑なCHECK制約

```sql
-- より複雑な条件のCHECK制約
CREATE TABLE course_registrations (
    registration_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    registration_date DATE NOT NULL,
    status ENUM('pending', 'approved', 'rejected', 'cancelled') NOT NULL,
    semester ENUM('spring', 'summer', 'fall', 'winter') NOT NULL,
    academic_year INT NOT NULL,
    
    -- 年度の妥当性チェック
    CHECK (academic_year >= 2000 AND academic_year <= 2100),
    
    -- 登録日と年度の整合性チェック
    CHECK (YEAR(registration_date) = academic_year OR YEAR(registration_date) = academic_year - 1),
    
    -- ステータスと日付の論理チェック
    CHECK (status = 'pending' OR registration_date < CURRENT_DATE)
);
```

#### 文字列パターンのCHECK制約

```sql
-- 文字列形式のチェック
CREATE TABLE student_contacts (
    contact_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    postal_code VARCHAR(10),
    
    -- メールアドレスの形式チェック（簡単な例）
    CHECK (email IS NULL OR email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    
    -- 電話番号の形式チェック（日本の形式）
    CHECK (phone IS NULL OR phone REGEXP '^[0-9]{2,4}-[0-9]{2,4}-[0-9]{4}$'),
    
    -- 郵便番号の形式チェック（日本の形式）
    CHECK (postal_code IS NULL OR postal_code REGEXP '^[0-9]{3}-[0-9]{4}$')
);

-- 有効なデータの挿入
INSERT INTO student_contacts (student_id, email, phone, postal_code)
VALUES (301, 'student@example.com', '03-1234-5678', '100-0001');

-- 無効なデータの挿入テスト
-- INSERT INTO student_contacts (student_id, email, phone, postal_code)
-- VALUES (302, 'invalid-email', '123', 'invalid');  -- エラー: 形式違反
```

### 3. CHECK制約の管理

```sql
-- CHECK制約の追加
ALTER TABLE student_scores 
ADD CONSTRAINT chk_score_not_negative CHECK (score >= 0);

-- CHECK制約の削除
ALTER TABLE student_scores 
DROP CHECK chk_score_not_negative;

-- CHECK制約の確認
SELECT 
    constraint_name,
    check_clause
FROM information_schema.check_constraints 
WHERE constraint_schema = DATABASE();
```

## UNIQUE制約

### 1. UNIQUE制約の基本概念

UNIQUE制約は、カラムの値が一意（重複なし）であることを保証します。主キーとは異なり、NULL値は許可されます（ただし、複数のNULL値は許可される場合があります）。

### 2. UNIQUE制約の設定方法

#### 単一カラムのUNIQUE制約

```sql
-- 学生テーブルのUNIQUE制約例
CREATE TABLE students_unique_demo (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,           -- メールアドレスは一意
    student_number VARCHAR(20) UNIQUE,   -- 学籍番号は一意
    phone VARCHAR(20)
);

-- 有効なデータの挿入
INSERT INTO students_unique_demo VALUES 
(1, '田中太郎', 'tanaka@example.com', 'S2025001', '090-1234-5678'),
(2, '佐藤花子', 'sato@example.com', 'S2025002', '090-2345-6789');

-- UNIQUE制約違反のテスト
-- INSERT INTO students_unique_demo VALUES 
-- (3, '鈴木次郎', 'tanaka@example.com', 'S2025003', '090-3456-7890');  -- エラー: 重複email
```

#### 複合UNIQUE制約

```sql
-- 複数カラムの組み合わせでの一意性
CREATE TABLE class_schedules_unique (
    schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    classroom_id VARCHAR(16) NOT NULL,
    day_of_week TINYINT NOT NULL,
    period INT NOT NULL,
    course_id VARCHAR(16),
    
    -- 同じ教室、同じ曜日、同じ時限は重複不可
    UNIQUE KEY unique_classroom_time (classroom_id, day_of_week, period)
);

-- 有効なデータ
INSERT INTO class_schedules_unique (classroom_id, day_of_week, period, course_id)
VALUES ('101A', 1, 1, 'MATH001'), ('101A', 1, 2, 'ENG001'), ('102B', 1, 1, 'SCI001');

-- 重複エラーのテスト
-- INSERT INTO class_schedules_unique (classroom_id, day_of_week, period, course_id)
-- VALUES ('101A', 1, 1, 'HIST001');  -- エラー: 同じ教室・曜日・時限の重複
```

### 3. UNIQUE制約の管理

```sql
-- UNIQUE制約の追加
ALTER TABLE students_unique_demo 
ADD CONSTRAINT uk_phone UNIQUE (phone);

-- UNIQUE制約の削除
ALTER TABLE students_unique_demo 
DROP INDEX uk_phone;

-- UNIQUE制約の確認
SHOW INDEX FROM students_unique_demo WHERE Non_duplicate = 0;
```

## NOT NULL制約

### 1. NOT NULL制約の基本概念

NOT NULL制約は、カラムにNULL値の格納を禁止し、必ず何らかの値が入力されることを保証します。

### 2. NOT NULL制約の設定方法

```sql
-- NOT NULL制約の例
CREATE TABLE required_fields_demo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,              -- 必須項目
    email VARCHAR(255) NOT NULL,             -- 必須項目
    phone VARCHAR(20),                       -- オプション項目
    description TEXT,                        -- オプション項目
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP  -- 必須・デフォルト値あり
);

-- 有効なデータの挿入
INSERT INTO required_fields_demo (name, email, phone) 
VALUES ('山田太郎', 'yamada@example.com', '090-1111-2222');

-- NULL値挿入エラーのテスト
-- INSERT INTO required_fields_demo (name, phone) 
-- VALUES ('田中次郎', '090-3333-4444');  -- エラー: emailがNULL
```

### 3. NOT NULL制約の管理

```sql
-- NOT NULL制約の追加（既存データの確認が必要）
-- まずNULL値を適切な値で更新
UPDATE required_fields_demo SET phone = '未登録' WHERE phone IS NULL;

-- NOT NULL制約を追加
ALTER TABLE required_fields_demo 
MODIFY COLUMN phone VARCHAR(20) NOT NULL;

-- NOT NULL制約の削除（NULL許可に変更）
ALTER TABLE required_fields_demo 
MODIFY COLUMN phone VARCHAR(20);
```

## DEFAULT制約

### 1. DEFAULT制約の基本概念

DEFAULT制約は、INSERT文でカラムの値が指定されなかった場合に自動的に設定される値を定義します。

### 2. DEFAULT制約の設定方法

```sql
-- DEFAULT制約の例
CREATE TABLE default_values_demo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'active',              -- 文字列のデフォルト
    priority INT DEFAULT 1,                           -- 数値のデフォルト
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- 現在日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
               ON UPDATE CURRENT_TIMESTAMP,           -- 更新時自動更新
    is_enabled BOOLEAN DEFAULT TRUE,                  -- 真偽値のデフォルト
    discount_rate DECIMAL(5,2) DEFAULT 0.00          -- 小数のデフォルト
);

-- デフォルト値を使用した挿入
INSERT INTO default_values_demo (name) VALUES ('テストユーザー');

-- 結果確認
SELECT * FROM default_values_demo;

-- 明示的な値の指定
INSERT INTO default_values_demo (name, status, priority, is_enabled) 
VALUES ('カスタムユーザー', 'inactive', 5, FALSE);
```

### 3. DEFAULT制約の管理

```sql
-- DEFAULT制約の追加
ALTER TABLE default_values_demo 
ALTER COLUMN priority SET DEFAULT 3;

-- DEFAULT制約の削除
ALTER TABLE default_values_demo 
ALTER COLUMN priority DROP DEFAULT;

-- DEFAULT値の確認
DESCRIBE default_values_demo;
```

## 実践的な制約設計

### 例1：包括的な学生管理テーブル

```sql
-- 実際の学生管理システムの例
CREATE TABLE comprehensive_students (
    -- 主キー
    student_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- 基本情報（必須項目）
    student_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    
    -- 連絡先情報
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    
    -- 学籍情報
    admission_date DATE NOT NULL,
    graduation_date DATE,
    grade_level INT NOT NULL,
    status ENUM('enrolled', 'graduated', 'withdrawn', 'suspended') DEFAULT 'enrolled',
    
    -- 個人情報
    birth_date DATE,
    gender ENUM('male', 'female', 'other', 'prefer_not_to_say'),
    
    -- システム情報
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- CHECK制約
    CHECK (grade_level >= 1 AND grade_level <= 6),
    CHECK (birth_date <= CURRENT_DATE),
    CHECK (admission_date >= '2000-01-01'),
    CHECK (graduation_date IS NULL OR graduation_date >= admission_date),
    CHECK (email IS NULL OR email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    
    -- インデックス
    INDEX idx_student_number (student_number),
    INDEX idx_name (last_name, first_name),
    INDEX idx_grade_status (grade_level, status),
    INDEX idx_admission_date (admission_date)
);
```

### 例2：成績管理システムの制約設計

```sql
-- 包括的な成績管理テーブル
CREATE TABLE comprehensive_grades (
    -- 主キー
    grade_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- 外部キー
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    teacher_id BIGINT NOT NULL,
    
    -- 評価情報
    assessment_type ENUM('quiz', 'midterm', 'final', 'project', 'homework') NOT NULL,
    assessment_name VARCHAR(100) NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    max_score DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    weight DECIMAL(5,2) DEFAULT 1.00,
    
    -- 日付情報
    assessment_date DATE NOT NULL,
    submission_deadline DATETIME,
    submitted_at DATETIME,
    graded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- ステータス
    status ENUM('draft', 'submitted', 'graded', 'returned') DEFAULT 'draft',
    
    -- 追加情報
    comments TEXT,
    is_extra_credit BOOLEAN DEFAULT FALSE,
    
    -- 外部キー制約
    FOREIGN KEY (student_id) REFERENCES comprehensive_students(student_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- CHECK制約
    CHECK (score >= 0 AND score <= max_score),
    CHECK (max_score > 0),
    CHECK (weight >= 0 AND weight <= 10),
    CHECK (assessment_date <= CURRENT_DATE),
    CHECK (submitted_at IS NULL OR submitted_at <= CURRENT_TIMESTAMP),
    CHECK (submission_deadline IS NULL OR assessment_date <= DATE(submission_deadline)),
    
    -- UNIQUE制約（同一学生・講座・評価タイプ・評価名は一意）
    UNIQUE KEY unique_assessment (student_id, course_id, assessment_type, assessment_name),
    
    -- インデックス
    INDEX idx_student_course (student_id, course_id),
    INDEX idx_assessment_date (assessment_date),
    INDEX idx_teacher_course (teacher_id, course_id),
    INDEX idx_status (status)
);
```

## 制約のエラーと対処法

### 1. 主キー制約違反

```sql
-- 重複エラーの対処
CREATE TABLE pk_conflict_test (
    id INT PRIMARY KEY,
    data VARCHAR(100)
);

INSERT INTO pk_conflict_test VALUES (1, 'データ1');

-- 重複挿入の試行
-- INSERT INTO pk_conflict_test VALUES (1, 'データ2');  -- エラー

-- 対処法1: INSERT IGNORE
INSERT IGNORE INTO pk_conflict_test VALUES (1, 'データ2');  -- エラーにならない

-- 対処法2: ON DUPLICATE KEY UPDATE
INSERT INTO pk_conflict_test VALUES (1, 'データ2更新')
ON DUPLICATE KEY UPDATE data = VALUES(data);

-- 結果確認
SELECT * FROM pk_conflict_test;
```

### 2. 外部キー制約違反

```sql
-- 参照整合性エラーの対処
CREATE TABLE fk_parent (id INT PRIMARY KEY, name VARCHAR(50));
CREATE TABLE fk_child (
    id INT PRIMARY KEY, 
    parent_id INT,
    data VARCHAR(50),
    FOREIGN KEY (parent_id) REFERENCES fk_parent(id)
);

INSERT INTO fk_parent VALUES (1, '親1'), (2, '親2');

-- 存在しない親への参照
-- INSERT INTO fk_child VALUES (1, 99, '子1');  -- エラー

-- 対処法1: 事前に親の存在確認
INSERT INTO fk_child (id, parent_id, data)
SELECT 1, 1, '子1'
WHERE EXISTS (SELECT 1 FROM fk_parent WHERE id = 1);

-- 対処法2: 親データの事前挿入
INSERT IGNORE INTO fk_parent VALUES (99, '新親');
INSERT INTO fk_child VALUES (2, 99, '子2');
```

### 3. CHECK制約違反

```sql
-- CHECK制約エラーの対処
CREATE TABLE check_error_test (
    id INT PRIMARY KEY,
    score INT,
    grade CHAR(1),
    CHECK (score >= 0 AND score <= 100),
    CHECK (grade IN ('A', 'B', 'C', 'D', 'F'))
);

-- 範囲外データの挿入
-- INSERT INTO check_error_test VALUES (1, 150, 'A');  -- エラー

-- 対処法1: データの事前検証と修正
INSERT INTO check_error_test 
SELECT 1, LEAST(GREATEST(score_input, 0), 100), grade_input
FROM (SELECT 150 as score_input, 'A' as grade_input) input;

-- 対処法2: 条件付き挿入
INSERT INTO check_error_test (id, score, grade)
SELECT 2, 85, 'B'
WHERE 85 BETWEEN 0 AND 100 AND 'B' IN ('A', 'B', 'C', 'D', 'F');
```

## 制約の確認と管理

### 1. 制約情報の確認

```sql
-- テーブルの制約一覧確認
SELECT 
    constraint_name,
    constraint_type,
    table_name
FROM information_schema.table_constraints 
WHERE table_schema = DATABASE() 
AND table_name = 'comprehensive_students';

-- 外部キー制約の詳細確認
SELECT 
    constraint_name,
    table_name,
    column_name,
    referenced_table_name,
    referenced_column_name,
    delete_rule,
    update_rule
FROM information_schema.key_column_usage k
JOIN information_schema.referential_constraints r 
    ON k.constraint_name = r.constraint_name
WHERE k.constraint_schema = DATABASE();

-- CHECK制約の確認
SELECT 
    constraint_name,
    check_clause
FROM information_schema.check_constraints 
WHERE constraint_schema = DATABASE();
```

### 2. 制約の無効化と有効化

```sql
-- 外部キー制約の一時無効化（注意深く使用）
SET FOREIGN_KEY_CHECKS = 0;

-- データの一括操作
-- ...

-- 外部キー制約の再有効化
SET FOREIGN_KEY_CHECKS = 1;

-- CHECK制約の無効化（MySQL 8.0.16以降）
-- ALTER TABLE table_name ALTER CHECK constraint_name NOT ENFORCED;
-- ALTER TABLE table_name ALTER CHECK constraint_name ENFORCED;
```

## ベストプラクティス

### 1. 制約設計の原則

```sql
-- 良い制約設計の例
CREATE TABLE best_practice_example (
    -- 1. 適切な主キー設計
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    uuid CHAR(36) UNIQUE DEFAULT (UUID()),
    
    -- 2. 必須項目の明確化
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    
    -- 3. 適切なデフォルト値
    status ENUM('active', 'inactive', 'pending') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- 4. 論理的な制約
    birth_date DATE,
    registration_date DATE DEFAULT (CURRENT_DATE),
    
    -- 5. 包括的なCHECK制約
    CHECK (birth_date IS NULL OR birth_date <= CURRENT_DATE),
    CHECK (registration_date >= birth_date OR birth_date IS NULL),
    CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    
    -- 6. 適切なインデックス
    INDEX idx_email (email),
    INDEX idx_status (status),
    INDEX idx_registration_date (registration_date)
);
```

### 2. 制約の段階的実装

```sql
-- Phase 1: 基本制約
CREATE TABLE gradual_constraints (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Phase 2: 一意性制約追加
ALTER TABLE gradual_constraints 
ADD COLUMN email VARCHAR(255) UNIQUE;

-- Phase 3: CHECK制約追加
ALTER TABLE gradual_constraints 
ADD COLUMN age INT,
ADD CONSTRAINT chk_age CHECK (age >= 0 AND age <= 150);

-- Phase 4: 外部キー制約追加
ALTER TABLE gradual_constraints 
ADD COLUMN department_id INT,
ADD FOREIGN KEY (department_id) REFERENCES departments(dept_id);
```

### 3. パフォーマンスを考慮した制約設計

```sql
-- パフォーマンスを考慮した制約設計
CREATE TABLE performance_optimized (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- 頻繁に検索されるカラムにインデックス付きUNIQUE制約
    code VARCHAR(20) UNIQUE,
    
    -- 複合インデックスを考慮したUNIQUE制約
    category_id INT,
    subcategory_id INT,
    item_name VARCHAR(100),
    
    -- 範囲検索に適したカラムの制約
    price DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    
    -- CHECK制約（インデックスは作成されない）
    CHECK (price >= 0),
    CHECK (stock_quantity >= 0),
    
    -- 複合UNIQUE制約（複合インデックスも作成）
    UNIQUE KEY unique_item (category_id, subcategory_id, item_name),
    
    -- 個別インデックス
    INDEX idx_price (price),
    INDEX idx_stock (stock_quantity)
);
```

## 練習問題

### 問題35-1：基本的な制約設定
以下の要件を満たすテーブル`library_books`を作成してください：
- 主キー：`book_id`（自動増加する整数）
- ISBN：`isbn`（13文字、必須、一意）
- タイトル：`title`（最大200文字、必須）
- 著者：`author`（最大100文字、必須）
- 出版年：`publication_year`（整数、1900年以上現在年以下）
- 価格：`price`（小数点2桁、0以上）
- ステータス：`status`（'available', 'borrowed', 'maintenance'のいずれか、デフォルト'available'）

### 問題35-2：外部キー制約の実装
以下の2つのテーブルを作成し、適切な外部キー制約を設定してください：
1. `categories`テーブル（category_id: 主キー、category_name: 必須）
2. `products`テーブル（product_id: 主キー、product_name: 必須、category_id: 外部キー）
外部キー制約には以下を設定：
- 親テーブル削除時：RESTRICT
- 親テーブル更新時：CASCADE

### 問題35-3：CHECK制約の活用
学生の個人情報テーブル`student_profiles`を作成してください：
- 学生ID：`student_id`（主キー）
- 生年月日：`birth_date`（現在日以前）
- 学年：`grade`（1-12の範囲）
- GPA：`gpa`（0.0-4.0の範囲）
- メールアドレス：`email`（基本的な形式チェック）
- 電話番号：`phone`（日本の形式：XXX-XXXX-XXXX）
- 郵便番号：`postal_code`（日本の形式：XXX-XXXX）

### 問題35-4：複合制約の設計
時間割管理テーブル`class_timetable`を作成してください：
- 主キー：`timetable_id`（自動増加）
- 教室ID：`classroom_id`（必須）
- 曜日：`day_of_week`（1-7の範囲、1=月曜日）
- 時限：`period`（1-8の範囲）
- 講座ID：`course_id`（外部キー、coursesテーブル参照）
- 教師ID：`teacher_id`（外部キー、teachersテーブル参照）
- 学期：`semester`（'spring', 'summer', 'fall', 'winter'）
- 年度：`academic_year`（2000年以降）
制約：同じ教室・曜日・時限・学期・年度の組み合わせは一意

### 問題35-5：制約エラーの対処
以下のシナリオで適切なエラー対処を実装してください：
1. 主キー重複エラーが発生した場合のINSERT IGNORE使用
2. 外部キー制約違反時の事前チェックと条件付き挿入
3. CHECK制約違反時のデータ補正と挿入
具体的なSQL文を書いて、エラーが発生する例と対処法を示してください。

### 問題35-6：包括的な制約設計
オンライン学習システムの`course_enrollments`テーブルを設計してください：
- 登録ID：`enrollment_id`（主キー、自動増加）
- 学生ID：`student_id`（外部キー、CASCADE削除）
- 講座ID：`course_id`（外部キー、RESTRICT削除）
- 登録日：`enrollment_date`（デフォルト：現在日）
- 開始日：`start_date`（登録日以降）
- 修了日：`completion_date`（開始日以降、NULL許可）
- ステータス：`status`（'enrolled', 'in_progress', 'completed', 'dropped'、デフォルト'enrolled'）
- 進捗率：`progress_percentage`（0-100の範囲、デフォルト0）
- 評価：`rating`（1-5の範囲、NULL許可）
- 支払い状況：`payment_status`（'pending', 'paid', 'refunded'、デフォルト'pending'）
すべての適切な制約を含めて設計してください。

## 解答

### 解答35-1
```sql
CREATE TABLE library_books (
    book_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    isbn CHAR(13) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publication_year INT,
    price DECIMAL(8,2),
    status ENUM('available', 'borrowed', 'maintenance') DEFAULT 'available',
    
    -- CHECK制約
    CHECK (publication_year >= 1900 AND publication_year <= YEAR(CURDATE())),
    CHECK (price >= 0)
);

-- テスト用データ挿入
INSERT INTO library_books (isbn, title, author, publication_year, price) VALUES
('9784123456789', 'データベース設計入門', '山田太郎', 2023, 2800.00),
('9784987654321', 'SQL実践ガイド', '佐藤花子', 2022, 3200.50);

-- 制約違反テスト（コメントアウト）
-- INSERT INTO library_books (isbn, title, author, publication_year, price) VALUES
-- ('9784111111111', 'テスト本', '著者名', 1800, 2000.00);  -- エラー: 出版年が1900年未満
```

### 解答35-2
```sql
-- 親テーブル作成
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 子テーブル作成（外部キー制約付き）
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category_id INT NOT NULL,
    
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- テストデータ挿入
INSERT INTO categories (category_name) VALUES ('電子機器'), ('書籍'), ('食品');
INSERT INTO products (product_name, category_id) VALUES 
('ノートパソコン', 1),
('データベース教科書', 2),
('有機野菜セット', 3);

-- 外部キー制約のテスト
-- 親テーブル更新（CASCADE）
UPDATE categories SET category_id = 10 WHERE category_id = 1;
SELECT * FROM products WHERE category_id = 10;  -- 自動更新確認

-- 親テーブル削除試行（RESTRICT）
-- DELETE FROM categories WHERE category_id = 10;  -- エラー: 参照されているため削除不可
```

### 解答35-3
```sql
CREATE TABLE student_profiles (
    student_id BIGINT PRIMARY KEY,
    birth_date DATE,
    grade INT,
    gpa DECIMAL(3,2),
    email VARCHAR(255),
    phone VARCHAR(15),
    postal_code VARCHAR(8),
    
    -- CHECK制約
    CHECK (birth_date <= CURRENT_DATE),
    CHECK (grade >= 1 AND grade <= 12),
    CHECK (gpa >= 0.0 AND gpa <= 4.0),
    CHECK (email IS NULL OR email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    CHECK (phone IS NULL OR phone REGEXP '^[0-9]{3}-[0-9]{4}-[0-9]{4}$'),
    CHECK (postal_code IS NULL OR postal_code REGEXP '^[0-9]{3}-[0-9]{4}$')
);

-- 有効データの挿入
INSERT INTO student_profiles VALUES 
(1001, '2005-04-15', 10, 3.75, 'student@example.com', '090-1234-5678', '100-0001');

-- 制約違反テスト（コメントアウト）
-- INSERT INTO student_profiles VALUES 
-- (1002, '2030-01-01', 10, 3.75, 'student@example.com', '090-1234-5678', '100-0001');  -- エラー: 未来の生年月日
```

### 解答35-4
```sql
CREATE TABLE class_timetable (
    timetable_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    classroom_id VARCHAR(16) NOT NULL,
    day_of_week TINYINT NOT NULL,
    period TINYINT NOT NULL,
    course_id VARCHAR(16),
    teacher_id BIGINT,
    semester ENUM('spring', 'summer', 'fall', 'winter') NOT NULL,
    academic_year INT NOT NULL,
    
    -- CHECK制約
    CHECK (day_of_week >= 1 AND day_of_week <= 7),
    CHECK (period >= 1 AND period <= 8),
    CHECK (academic_year >= 2000),
    
    -- 外部キー制約
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE SET NULL,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id) ON DELETE SET NULL,
    
    -- 複合UNIQUE制約
    UNIQUE KEY unique_classroom_schedule (classroom_id, day_of_week, period, semester, academic_year)
);

-- テストデータ挿入
INSERT INTO class_timetable (classroom_id, day_of_week, period, course_id, teacher_id, semester, academic_year)
VALUES ('101A', 1, 1, '1', 101, 'spring', 2025);

-- 重複エラーテスト（コメントアウト）
-- INSERT INTO class_timetable (classroom_id, day_of_week, period, course_id, teacher_id, semester, academic_year)
-- VALUES ('101A', 1, 1, '2', 102, 'spring', 2025);  -- エラー: 同じ時間割の重複
```

### 解答35-5
```sql
-- テーブル作成
CREATE TABLE constraint_error_demo (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    score INT,
    foreign_ref INT,
    
    CHECK (score >= 0 AND score <= 100),
    FOREIGN KEY (foreign_ref) REFERENCES categories(category_id)
);

-- 1. 主キー重複エラーの対処
INSERT INTO constraint_error_demo VALUES (1, 'データ1', 85, 10);

-- 重複挿入（エラーになる）
-- INSERT INTO constraint_error_demo VALUES (1, 'データ2', 90, 10);  -- エラー

-- INSERT IGNOREで重複エラー回避
INSERT IGNORE INTO constraint_error_demo VALUES (1, 'データ2', 90, 10);  -- エラーにならない

-- ON DUPLICATE KEY UPDATEで更新
INSERT INTO constraint_error_demo VALUES (1, 'データ更新', 95, 10)
ON DUPLICATE KEY UPDATE name = VALUES(name), score = VALUES(score);

-- 2. 外部キー制約違反の対処
-- 存在チェック付き挿入
INSERT INTO constraint_error_demo (id, name, score, foreign_ref)
SELECT 2, 'データ3', 88, 2
WHERE EXISTS (SELECT 1 FROM categories WHERE category_id = 2);

-- 3. CHECK制約違反の対処
-- データ補正付き挿入
INSERT INTO constraint_error_demo (id, name, score, foreign_ref)
SELECT 3, 'データ4', LEAST(GREATEST(150, 0), 100), 2;  -- 150を100に補正

-- 結果確認
SELECT * FROM constraint_error_demo;
```

### 解答35-6
```sql
CREATE TABLE course_enrollments (
    enrollment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    start_date DATE,
    completion_date DATE,
    status ENUM('enrolled', 'in_progress', 'completed', 'dropped') DEFAULT 'enrolled',
    progress_percentage DECIMAL(5,2) DEFAULT 0.00,
    rating TINYINT,
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- 外部キー制約
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- CHECK制約
    CHECK (start_date >= enrollment_date),
    CHECK (completion_date IS NULL OR completion_date >= start_date),
    CHECK (progress_percentage >= 0.00 AND progress_percentage <= 100.00),
    CHECK (rating IS NULL OR (rating >= 1 AND rating <= 5)),
    
    -- 論理的制約
    CHECK (
        (status = 'completed' AND completion_date IS NOT NULL) OR
        (status != 'completed')
    ),
    CHECK (
        (status = 'completed' AND progress_percentage = 100.00) OR
        (status != 'completed')
    ),
    
    -- 複合UNIQUE制約（同じ学生が同じ講座を重複受講しない）
    UNIQUE KEY unique_student_course (student_id, course_id),
    
    -- インデックス
    INDEX idx_student_id (student_id),
    INDEX idx_course_id (course_id),
    INDEX idx_enrollment_date (enrollment_date),
    INDEX idx_status (status),
    INDEX idx_payment_status (payment_status)
);

-- テストデータ挿入
INSERT INTO course_enrollments (student_id, course_id, start_date, progress_percentage)
VALUES (301, '1', '2025-05-25', 25.50);

-- 制約のテスト
-- 進捗率100%で未完了ステータス（論理矛盾、エラーになる）
-- INSERT INTO course_enrollments (student_id, course_id, start_date, progress_percentage, status)
-- VALUES (302, '2', '2025-05-25', 100.00, 'in_progress');  -- エラー: 論理制約違反

-- 正しい完了データ
INSERT INTO course_enrollments (student_id, course_id, start_date, completion_date, progress_percentage, status)
VALUES (302, '2', '2025-05-25', '2025-06-20', 100.00, 'completed');

-- 結果確認
SELECT * FROM course_enrollments;
```

## まとめ

この章では、データベースの制約について詳しく学びました：

1. **制約の基本概念**：
   - データの整合性と品質保証の重要性
   - 制約違反時の自動エラー機能
   - 各制約の役割と特性

2. **主キー制約（PRIMARY KEY）**：
   - 一意性とNOT NULL保証
   - AUTO_INCREMENTとの組み合わせ
   - 複合主キーの活用

3. **外部キー制約（FOREIGN KEY）**：
   - 参照整合性の保証
   - カスケード動作の制御
   - テーブル間関係の明確化

4. **CHECK制約**：
   - 値の範囲と条件制限
   - 複雑な論理チェック
   - データ形式の検証

5. **UNIQUE制約**：
   - 重複防止機能
   - 単一・複合カラムでの一意性
   - 主キーとの使い分け

6. **NOT NULL・DEFAULT制約**：
   - 必須項目の保証
   - デフォルト値の自動設定
   - データ入力の簡略化

7. **実践的な制約設計**：
   - 包括的なテーブル設計
   - パフォーマンスとの両立
   - 段階的な制約実装

8. **エラー対処と管理**：
   - 制約違反エラーの解決方法
   - 事前チェックと条件付き操作
   - 制約情報の確認手順

9. **ベストプラクティス**：
   - 論理的で実用的な制約設計
   - パフォーマンスを考慮した実装
   - 保守性を重視した管理方法

制約は、データベースの信頼性を支える重要な機能です。適切に設計・実装することで、データの品質を保ち、アプリケーションの安定性を大幅に向上させることができます。

次の章では、「インデックス：パフォーマンス最適化」について学び、検索性能の向上方法を詳しく理解していきます。