# 43. 正規化：データの冗長性削減

## はじめに

前章でER図によるデータベース設計を学びました。しかし、ER図から作成したテーブル設計がそのまま最適とは限りません。データベースをより効率的で保守しやすくするために、「**正規化**」という技法が必要です。

正規化とは、**データの重複（冗長性）を取り除き、データの整合性を保ちやすい構造に変換する**プロセスです。正規化を行うことで、データの更新時の問題を防ぎ、ストレージ容量の節約にもつながります。

> **用語解説**：
> - **正規化（Normalization）**：データベースの構造を改善し、データの重複を排除するプロセスです
> - **冗長性（Redundancy）**：同じデータが複数の場所に重複して格納されている状態です
> - **整合性（Consistency）**：データベース内のデータが矛盾なく一貫している状態です
> - **関数従属（Functional Dependency）**：ある列の値が決まると、他の列の値が一意に決まる関係です
> - **部分関数従属（Partial Functional Dependency）**：複合主キーの一部だけで、他の列の値が決まってしまう関係です
> - **推移関数従属（Transitive Functional Dependency）**：A→B、B→Cの関係があるとき、A→Cが成り立つ関係です
> - **候補キー（Candidate Key）**：主キーになりうる属性（または属性の組み合わせ）です
> - **非キー属性（Non-key Attribute）**：どの候補キーにも含まれない属性です

この章では、学校システムの具体例を使って、正規化の各段階を詳しく学習し、実践的なスキルを身につけます。

## 正規化が必要な理由

### 正規化前の問題のあるテーブル例

以下のような「学生情報統合テーブル」があるとします：

```sql
CREATE TABLE student_info_bad (
    student_id BIGINT,
    student_name VARCHAR(64),
    teacher_id BIGINT,
    teacher_name VARCHAR(64),
    teacher_department VARCHAR(64),
    course_id VARCHAR(16),
    course_name VARCHAR(128),
    grade_type VARCHAR(32),
    score DECIMAL(5,2),
    submission_date DATE
);

-- サンプルデータ
INSERT INTO student_info_bad VALUES
(301, '田中太郎', 101, '佐藤先生', '情報学部', '1', 'プログラミング基礎', 'テスト', 85.0, '2025-05-15'),
(301, '田中太郎', 101, '佐藤先生', '情報学部', '1', 'プログラミング基礎', 'レポート', 90.0, '2025-05-20'),
(301, '田中太郎', 102, '鈴木先生', '数学科', '2', 'データベース', 'テスト', 78.0, '2025-05-18'),
(302, '山田花子', 101, '佐藤先生', '情報学部', '1', 'プログラミング基礎', 'テスト', 92.0, '2025-05-15'),
(302, '山田花子', 102, '鈴木先生', '数学科', '2', 'データベース', 'レポート', 88.0, '2025-05-22');
```

### このテーブルの問題点

#### 1. **更新異常（Update Anomaly）**
佐藤先生の名前を「佐藤太郎先生」に変更したい場合、複数の行を更新する必要があります。1つでも更新し忘れると、データの不整合が発生します。

```sql
-- 間違った更新：一部の行だけ更新してしまった場合
UPDATE student_info_bad 
SET teacher_name = '佐藤太郎先生' 
WHERE student_id = 301 AND course_id = '1' AND grade_type = 'テスト';

-- 結果：同じ教師ID 101に対して異なる名前が存在してしまう
```

#### 2. **挿入異常（Insert Anomaly）**
新しい教師情報だけを登録したい場合、学生や成績の情報がないと登録できません。

```sql
-- 不可能：教師情報だけでは挿入できない
INSERT INTO student_info_bad (teacher_id, teacher_name, teacher_department) 
VALUES (103, '高橋先生', '英語科');
-- エラー：student_idなど他の列にもNULLでない値が必要
```

#### 3. **削除異常（Delete Anomaly）**
学生301番がプログラミング基礎の成績をすべて削除すると、佐藤先生の情報も一緒に消えてしまう可能性があります。

#### 4. **ストレージの無駄**
同じ教師情報、学生情報、講座情報が何度も重複して格納されます。

## 正規化の段階

正規化は段階的に行われ、それぞれの段階を「**正規形**」と呼びます。主要な正規形は以下の通りです：

1. **第1正規形（1NF）**：反復項目の除去
2. **第2正規形（2NF）**：部分関数従属の除去
3. **第3正規形（3NF）**：推移関数従属の除去
4. **ボイス・コッド正規形（BCNF）**：すべての関数従属の正規化
5. **第4正規形（4NF）**、**第5正規形（5NF）**：多値従属性の処理

実用的には、第3正規形まで行えば十分なケースがほとんどです。

## 第1正規形（1NF）

### 定義
**第1正規形**とは、テーブルのすべての列が**原子的な値**（これ以上分割できない単一の値）を持っている状態です。

> **用語解説**：
> - **原子的な値（Atomic Value）**：それ以上分割できない最小単位の値です
> - **反復項目（Repeating Group）**：同じ種類のデータが複数個、1つの行に格納されている状態です

### 第1正規形に違反している例

```sql
-- NG：第1正規形に違反
CREATE TABLE students_bad_1nf (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(64),
    courses VARCHAR(200),  -- 複数の講座が1つの列に格納されている
    phone_numbers VARCHAR(100)  -- 複数の電話番号が1つの列に格納されている
);

INSERT INTO students_bad_1nf VALUES
(301, '田中太郎', 'プログラミング基礎,データベース,ネットワーク', '090-1234-5678,03-1234-5678'),
(302, '山田花子', 'プログラミング基礎,Webデザイン', '080-9876-5432');
```

**問題点**：
- 特定の講座を受講している学生を検索するのが困難
- 講座の追加・削除が複雑
- データの整合性チェックが困難

### 第1正規形への変換

#### 方法1：行の複製
```sql
-- OK：第1正規形に準拠（ただし他の問題あり）
CREATE TABLE students_1nf_v1 (
    student_id BIGINT,
    student_name VARCHAR(64),
    course VARCHAR(64),
    phone_number VARCHAR(20)
);

INSERT INTO students_1nf_v1 VALUES
(301, '田中太郎', 'プログラミング基礎', '090-1234-5678'),
(301, '田中太郎', 'プログラミング基礎', '03-1234-5678'),
(301, '田中太郎', 'データベース', '090-1234-5678'),
(301, '田中太郎', 'データベース', '03-1234-5678'),
(301, '田中太郎', 'ネットワーク', '090-1234-5678'),
(301, '田中太郎', 'ネットワーク', '03-1234-5678'),
(302, '山田花子', 'プログラミング基礎', '080-9876-5432'),
(302, '山田花子', 'Webデザイン', '080-9876-5432');
```

#### 方法2：テーブルの分割（推奨）
```sql
-- 学生基本情報テーブル
CREATE TABLE students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(64)
);

-- 学生電話番号テーブル
CREATE TABLE student_phones (
    student_id BIGINT,
    phone_number VARCHAR(20),
    phone_type ENUM('mobile', 'home', 'work') DEFAULT 'mobile',
    PRIMARY KEY (student_id, phone_number),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- 学生受講テーブル
CREATE TABLE student_courses (
    student_id BIGINT,
    course_id VARCHAR(16),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
```

## 第2正規形（2NF）

### 定義
**第2正規形**とは、第1正規形を満たし、かつ**部分関数従属**がない状態です。

**部分関数従属**とは、複合主キーの一部だけで、非キー属性の値が決まってしまう関係のことです。

### 第2正規形に違反している例

```sql
-- NG：第2正規形に違反
CREATE TABLE enrollment_bad_2nf (
    student_id BIGINT,
    course_id VARCHAR(16),
    student_name VARCHAR(64),    -- student_idだけで決まる（部分関数従属）
    course_name VARCHAR(128),    -- course_idだけで決まる（部分関数従属）
    teacher_name VARCHAR(64),    -- course_idだけで決まる（部分関数従属）
    enrollment_date DATE,        -- 複合主キー全体で決まる
    grade CHAR(1),              -- 複合主キー全体で決まる
    
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO enrollment_bad_2nf VALUES
(301, '1', '田中太郎', 'プログラミング基礎', '佐藤先生', '2025-04-01', 'A'),
(301, '2', '田中太郎', 'データベース', '鈴木先生', '2025-04-01', 'B'),
(302, '1', '山田花子', 'プログラミング基礎', '佐藤先生', '2025-04-01', 'A');
```

**関数従属の分析**：
- `student_id → student_name`（部分関数従属）
- `course_id → course_name, teacher_name`（部分関数従属）
- `(student_id, course_id) → enrollment_date, grade`（完全関数従属）

**問題点**：
- 学生名や講座名の変更時に複数行を更新する必要
- 同じ学生・講座情報の重複格納
- 新しい学生や講座だけを登録できない

### 第2正規形への変換

部分関数従属を除去するために、テーブルを分割します：

```sql
-- 学生テーブル
CREATE TABLE students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(64) NOT NULL
);

-- 講座テーブル
CREATE TABLE courses (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_name VARCHAR(64) NOT NULL
);

-- 受講テーブル（関連情報のみ）
CREATE TABLE enrollments (
    student_id BIGINT,
    course_id VARCHAR(16),
    enrollment_date DATE NOT NULL,
    grade CHAR(1),
    
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- データ投入
INSERT INTO students VALUES
(301, '田中太郎'),
(302, '山田花子');

INSERT INTO courses VALUES
('1', 'プログラミング基礎', '佐藤先生'),
('2', 'データベース', '鈴木先生');

INSERT INTO enrollments VALUES
(301, '1', '2025-04-01', 'A'),
(301, '2', '2025-04-01', 'B'),
(302, '1', '2025-04-01', 'A');
```

## 第3正規形（3NF）

### 定義
**第3正規形**とは、第2正規形を満たし、かつ**推移関数従属**がない状態です。

**推移関数従属**とは、「A → B」かつ「B → C」の関係があるとき、「A → C」が成り立つ関係のことです。

### 第3正規形に違反している例

第2正規形のcoursesテーブルを詳しく見てみましょう：

```sql
-- NG：第3正規形に違反
CREATE TABLE courses_bad_3nf (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT NOT NULL,
    teacher_name VARCHAR(64) NOT NULL,    -- 推移関数従属
    teacher_department VARCHAR(64) NOT NULL,  -- 推移関数従属
    classroom_id VARCHAR(16) NOT NULL,
    classroom_name VARCHAR(64) NOT NULL,  -- 推移関数従属
    building VARCHAR(32) NOT NULL        -- 推移関数従属
);
```

**関数従属の分析**：
- `course_id → teacher_id`
- `teacher_id → teacher_name, teacher_department`（推移関数従属）
- `course_id → classroom_id`
- `classroom_id → classroom_name, building`（推移関数従属）

**問題点**：
- 教師名や教室名の変更時に複数の講座レコードを更新する必要
- 同じ教師・教室情報の重複格納
- 講座がない教師や教室の情報を単独で管理できない

### 第3正規形への変換

推移関数従属を除去するために、さらにテーブルを分割します：

```sql
-- 教師テーブル
CREATE TABLE teachers (
    teacher_id BIGINT PRIMARY KEY,
    teacher_name VARCHAR(64) NOT NULL,
    teacher_department VARCHAR(64) NOT NULL
);

-- 教室テーブル
CREATE TABLE classrooms (
    classroom_id VARCHAR(16) PRIMARY KEY,
    classroom_name VARCHAR(64) NOT NULL,
    building VARCHAR(32) NOT NULL,
    capacity INT
);

-- 講座テーブル（第3正規形）
CREATE TABLE courses (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT NOT NULL,
    classroom_id VARCHAR(16) NOT NULL,
    
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id)
);

-- データ投入
INSERT INTO teachers VALUES
(101, '佐藤先生', '情報学部'),
(102, '鈴木先生', '数学科');

INSERT INTO classrooms VALUES
('A101', 'コンピュータ室1', 'A棟', 30),
('B201', '講義室B', 'B棟', 50);

INSERT INTO courses VALUES
('1', 'プログラミング基礎', 101, 'A101'),
('2', 'データベース', 102, 'A101');
```

## ボイス・コッド正規形（BCNF）

### 定義
**ボイス・コッド正規形**とは、第3正規形を満たし、かつ**すべての関数従属の決定項が候補キーである**状態です。

> **用語解説**：
> - **決定項（Determinant）**：関数従属「A → B」において、Aの部分です
> - **従属項（Dependent）**：関数従属「A → B」において、Bの部分です

### BCNFに違反している例

以下のような「講座時間割テーブル」を考えます：

```sql
-- NG：BCNFに違反
CREATE TABLE course_schedule_bad_bcnf (
    course_id VARCHAR(16),
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),
    time_slot INT,
    teacher_id BIGINT,
    classroom_id VARCHAR(16),
    
    PRIMARY KEY (course_id, day_of_week, time_slot)
);
```

**想定する制約**：
- 1つの講座は特定の教師が担当する：`course_id → teacher_id`
- 1つの教室の特定時間は1つの講座のみ：`(classroom_id, day_of_week, time_slot) → course_id`

**問題**：
- `course_id → teacher_id`の決定項`course_id`は候補キーではない（候補キーの一部）
- このため、同じ講座が複数の時間に開講される場合、教師情報が重複格納される

### BCNFへの変換

```sql
-- 講座基本情報テーブル
CREATE TABLE courses (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT NOT NULL,
    
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- 講座スケジュールテーブル
CREATE TABLE course_schedules (
    course_id VARCHAR(16),
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),
    time_slot INT,
    classroom_id VARCHAR(16),
    
    PRIMARY KEY (course_id, day_of_week, time_slot),
    UNIQUE KEY unique_classroom_time (classroom_id, day_of_week, time_slot),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id)
);
```

## 学校システムの完全正規化例

学校システム全体を第3正規形まで正規化した例を示します：

```sql
-- 1. 基本エンティティテーブル

-- 学生テーブル
CREATE TABLE students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(64) NOT NULL,
    email VARCHAR(100) UNIQUE,
    admission_date DATE NOT NULL
);

-- 教師テーブル
CREATE TABLE teachers (
    teacher_id BIGINT PRIMARY KEY,
    teacher_name VARCHAR(64) NOT NULL,
    department VARCHAR(64),
    email VARCHAR(100) UNIQUE
);

-- 教室テーブル
CREATE TABLE classrooms (
    classroom_id VARCHAR(16) PRIMARY KEY,
    classroom_name VARCHAR(64) NOT NULL,
    building VARCHAR(32) NOT NULL,
    capacity INT NOT NULL,
    facilities TEXT
);

-- 学期テーブル
CREATE TABLE terms (
    term_id VARCHAR(16) PRIMARY KEY,
    term_name VARCHAR(64) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- 授業時間テーブル
CREATE TABLE class_periods (
    period_id INT PRIMARY KEY,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

-- 2. 関連テーブル

-- 講座テーブル
CREATE TABLE courses (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT NOT NULL,
    term_id VARCHAR(16) NOT NULL,
    credits INT DEFAULT 1,
    
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (term_id) REFERENCES terms(term_id)
);

-- 学生受講テーブル（多対多の解決）
CREATE TABLE student_courses (
    student_id BIGINT,
    course_id VARCHAR(16),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 授業スケジュールテーブル
CREATE TABLE course_schedule (
    schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(16) NOT NULL,
    classroom_id VARCHAR(16) NOT NULL,
    period_id INT NOT NULL,
    schedule_date DATE NOT NULL,
    status ENUM('scheduled', 'completed', 'cancelled') DEFAULT 'scheduled',
    
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id),
    FOREIGN KEY (period_id) REFERENCES class_periods(period_id),
    
    UNIQUE KEY unique_classroom_time (classroom_id, period_id, schedule_date)
);

-- 出席テーブル
CREATE TABLE attendance (
    schedule_id BIGINT,
    student_id BIGINT,
    status ENUM('present', 'absent', 'late') NOT NULL,
    comment TEXT,
    
    PRIMARY KEY (schedule_id, student_id),
    FOREIGN KEY (schedule_id) REFERENCES course_schedule(schedule_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- 成績テーブル
CREATE TABLE grades (
    student_id BIGINT,
    course_id VARCHAR(16),
    grade_type VARCHAR(32),
    score DECIMAL(5,2) NOT NULL,
    max_score DECIMAL(5,2) NOT NULL,
    submission_date DATE DEFAULT CURRENT_DATE,
    
    PRIMARY KEY (student_id, course_id, grade_type),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

## 正規化の利点と欠点

### 利点

#### 1. **データ整合性の向上**
```sql
-- 教師名の変更が1箇所だけで済む
UPDATE teachers SET teacher_name = '佐藤太郎先生' WHERE teacher_id = 101;

-- 正規化前なら複数箇所の更新が必要で、更新漏れのリスクがあった
```

#### 2. **ストレージ容量の節約**
```sql
-- 正規化前：同じ教師情報が各講座レコードに重複
-- 正規化後：教師情報は1回だけ格納、講座テーブルでは教師IDのみ参照
```

#### 3. **挿入・削除・更新の柔軟性**
```sql
-- 新しい教師を講座と関係なく登録可能
INSERT INTO teachers VALUES (103, '高橋先生', '英語科', 'takahashi@school.ac.jp');

-- 講座を削除しても教師情報は残る
DELETE FROM courses WHERE course_id = '1';
```

### 欠点

#### 1. **複雑なクエリが必要**
```sql
-- 正規化前：1つのテーブルで完結
SELECT * FROM student_info_bad WHERE student_name = '田中太郎';

-- 正規化後：複数テーブルのJOINが必要
SELECT s.student_name, c.course_name, t.teacher_name, g.score
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
WHERE s.student_name = '田中太郎';
```

#### 2. **パフォーマンスの低下**
- 多数のJOINが必要でクエリが重くなる場合がある
- 特に大量データの場合は影響が大きい

#### 3. **設計・開発の複雑化**
- テーブル数が増加し、関連が複雑になる
- 開発者の理解が必要

## 逆正規化（非正規化）

実際の運用では、パフォーマンスを重視して意図的に正規化を緩める「**逆正規化**」を行う場合があります。

> **用語解説**：
> - **逆正規化（Denormalization）**：パフォーマンス向上のために、意図的にデータの重複を許可する設計手法です

### 逆正規化の例

```sql
-- 頻繁にアクセスされる情報を重複格納
CREATE TABLE student_course_summary (
    student_id BIGINT,
    student_name VARCHAR(64),  -- 重複格納
    course_id VARCHAR(16),
    course_name VARCHAR(128),  -- 重複格納
    teacher_name VARCHAR(64),  -- 重複格納
    current_grade DECIMAL(5,2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (student_id, course_id),
    -- 元テーブルとの整合性は別途管理
    INDEX idx_student_name (student_name),
    INDEX idx_course_name (course_name)
);
```

### 逆正規化の注意点

1. **データ同期の管理**：元テーブルとの整合性を保つ仕組みが必要
2. **更新コストの増加**：複数箇所の更新が必要
3. **明確な目的**：パフォーマンス改善の明確な根拠が必要

## 正規化の実践的な指針

### 基本方針

1. **第3正規形を目標**：実用上、第3正規形で十分なケースがほとんど
2. **段階的な適用**：一度にすべて正規化せず、段階的に進める
3. **要件に応じた調整**：システムの要件に応じて柔軟に対応

### 正規化の判断基準

```sql
-- 正規化が有効なケース
-- 1. データの更新が頻繁
-- 2. データの整合性が重要
-- 3. ストレージ容量が限られている

-- 逆正規化を検討するケース
-- 1. 読み取り専用のデータ
-- 2. パフォーマンスが最重要
-- 3. データの更新が稀
```

## 正規化の検証方法

正規化が適切に行われているかを検証する手順：

### 1. 関数従属の確認

```sql
-- 各テーブルの関数従属を文書化
-- 例：students テーブル
-- student_id → student_name, email, admission_date
-- email → student_id, student_name, admission_date（候補キー）
```

### 2. 正規形の確認

```sql
-- チェックポイント
-- □ 第1正規形：すべての値が原子的か？
-- □ 第2正規形：部分関数従属がないか？
-- □ 第3正規形：推移関数従属がないか？
```

### 3. 制約の実装確認

```sql
-- 外部キー制約の確認
SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    CONSTRAINT_NAME, 
    REFERENCED_TABLE_NAME, 
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE 
WHERE REFERENCED_TABLE_SCHEMA = 'school_db'
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

## 練習問題

### 問題43-1：正規化レベルの判定

以下のテーブルがどの正規形まで満たしているかを判定し、問題点を指摘してください：

```sql
CREATE TABLE library_books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200),
    authors VARCHAR(300),  -- 複数著者をカンマ区切りで格納
    publisher_name VARCHAR(100),
    publisher_address VARCHAR(200),
    isbn VARCHAR(20),
    price DECIMAL(8,2),
    category VARCHAR(50)
);
```

**質問**：
1. このテーブルは第1正規形を満たしていますか？
2. 問題がある場合、どのように修正すべきですか？
3. 正規化後のテーブル構造を設計してください。

### 問題43-2：部分関数従属の除去

以下のテーブルを第2正規形に変換してください：

```sql
CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    customer_name VARCHAR(100),    -- order_idだけで決まる
    customer_address VARCHAR(200), -- order_idだけで決まる
    product_name VARCHAR(100),     -- product_idだけで決まる
    product_price DECIMAL(8,2),    -- product_idだけで決まる
    quantity INT,                  -- 複合主キー全体で決まる
    discount_rate DECIMAL(3,2),    -- 複合主キー全体で決まる
    
    PRIMARY KEY (order_id, product_id)
);
```

**課題**：
1. 部分関数従属を特定してください
2. 第2正規形に変換したテーブル構造を設計してください
3. 変換後のCREATE TABLE文を書いてください
4. 変換のメリットを3つ説明してください

### 問題43-3：推移関数従属の除去

以下のテーブルを第3正規形に変換してください：

```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(100),  -- department_idで決まる
    department_location VARCHAR(100), -- department_idで決まる
    manager_id INT,
    manager_name VARCHAR(100),     -- manager_idで決まる
    salary DECIMAL(10,2),
    hire_date DATE
);
```

**課題**：
1. 推移関数従属を特定してください
2. 第3正規形に変換したテーブル構造を設計してください
3. データの整合性を保つための制約を追加してください
4. 変換前後でのデータ更新の違いを具体例で説明してください

### 問題43-4：複雑な正規化問題

病院システムの以下のテーブルを第3正規形まで正規化してください：

```sql
CREATE TABLE patient_treatments (
    patient_id INT,
    treatment_date DATE,
    patient_name VARCHAR(100),
    patient_address VARCHAR(200),
    patient_phone VARCHAR(20),
    doctor_id INT,
    doctor_name VARCHAR(100),
    doctor_specialty VARCHAR(50),
    treatment_code VARCHAR(10),
    treatment_name VARCHAR(100),
    treatment_cost DECIMAL(8,2),
    medicine_codes VARCHAR(200),  -- 複数の薬をカンマ区切り
    medicine_names VARCHAR(500),  -- 複数の薬名をカンマ区切り
    total_cost DECIMAL(10,2),
    
    PRIMARY KEY (patient_id, treatment_date, treatment_code)
);
```

**課題**：
1. 第1正規形への変換から段階的に正規化してください
2. 各段階での問題点と解決方法を説明してください
3. 最終的なテーブル構造をER図で表現してください
4. 正規化後のテーブルで「特定の患者の治療履歴を取得する」クエリを書いてください

### 問題43-5：逆正規化の判断

オンラインショップのシステムで、以下の正規化されたテーブル構造があります：

```sql
-- 顧客テーブル
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    address VARCHAR(200)
);

-- 注文テーブル
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 商品テーブル
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(8,2),
    category VARCHAR(50)
);

-- 注文詳細テーブル
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(8,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

**業務要件**：
- 顧客の注文履歴表示が最も頻繁な処理（全体の70%）
- 在庫管理システムでリアルタイムに商品情報を参照
- 月次売上レポートで集計処理を実行

**課題**：
1. どのテーブルに逆正規化を適用すべきか判断してください
2. 逆正規化後のテーブル構造を設計してください
3. 逆正規化による利点と欠点を整理してください
4. データ整合性を保つための仕組みを提案してください

### 問題43-6：実践的な正規化設計

大学の時間割管理システムを設計してください。以下の要件を満たすテーブル構造を第3正規形で設計してください：

**要件**：
- 学生は複数の科目を履修できる
- 科目は複数の時間帯で開講される場合もある
- 各時間帯には教室と担当教員が割り当てられる
- 同じ科目でも時間帯によって担当教員が異なる場合がある
- 学生の履修登録と成績管理を行う
- 教室には収容人数の制限がある
- 時間割の重複チェックが必要（学生・教員・教室）

**管理したい情報**：
- 学生：学籍番号、氏名、学年、学部
- 教員：教員番号、氏名、所属学部、職位
- 科目：科目番号、科目名、単位数、必修/選択
- 教室：教室番号、建物、収容人数、設備
- 時間帯：曜日、時限、開始時間、終了時間
- 履修：履修年度、成績
- 時間割：開講年度、学期

**課題**：
1. 必要なエンティティを抽出してください
2. エンティティ間の関連を分析してください
3. 第3正規形のテーブル構造を設計してください
4. 時間割重複チェックのためのCHECK制約やトリガーを考案してください
5. よく使われるクエリ（学生の時間割表示、教室利用状況確認など）を作成してください

## 解答

### 解答43-1

1. **第1正規形の判定**：
   このテーブルは第1正規形を**満たしていません**。
   
   **理由**：`authors`列に複数の著者がカンマ区切りで格納されており、原子的な値ではありません。

2. **修正方法**：
   - 著者情報を別テーブルに分離
   - 本と著者の多対多関係を中間テーブルで解決

3. **正規化後のテーブル構造**：

```sql
-- 出版社テーブル
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL,
    publisher_address VARCHAR(200)
);

-- 著者テーブル
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

-- 本テーブル
CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    publisher_id INT NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    price DECIMAL(8,2),
    category VARCHAR(50),
    
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

-- 本著者関係テーブル（多対多の解決）
CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    author_order INT DEFAULT 1,  -- 著者の順序
    
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);
```

### 解答43-2

1. **部分関数従属の特定**：
   - `order_id → customer_name, customer_address`
   - `product_id → product_name, product_price`

2. **第2正規形への変換**：

```sql
-- 顧客テーブル
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_address VARCHAR(200)
);

-- 注文テーブル
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 商品テーブル
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_price DECIMAL(8,2) NOT NULL
);

-- 注文詳細テーブル
CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    discount_rate DECIMAL(3,2) DEFAULT 0.00,
    
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

3. **変換のメリット**：
   - **データ整合性向上**：顧客情報の変更が1箇所で済む
   - **ストレージ効率**：重複データの削減
   - **保守性向上**：商品価格の変更が簡単

### 解答43-3

1. **推移関数従属の特定**：
   - `employee_id → department_id → department_name, department_location`
   - `employee_id → manager_id → manager_name`

2. **第3正規形への変換**：

```sql
-- 部署テーブル
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_location VARCHAR(100) NOT NULL
);

-- 従業員テーブル（第3正規形）
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    manager_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);
```

3. **整合性制約**：

```sql
-- セルフ参照制約（従業員は自分を管理者にできない）
ALTER TABLE employees 
ADD CONSTRAINT chk_manager_not_self 
CHECK (employee_id != manager_id);

-- 管理者は同じ部署または上位部署の従業員である制約
-- （複雑な制約はトリガーで実装）
```

4. **データ更新の違い**：

```sql
-- 変換前：部署名変更時（複数行更新が必要）
UPDATE employees 
SET department_name = '新情報システム部' 
WHERE department_id = 1;

-- 変換後：部署名変更時（1行更新で済む）
UPDATE departments 
SET department_name = '新情報システム部' 
WHERE department_id = 1;
```

### 解答43-4

1. **段階的正規化**：

#### 第1正規形への変換
```sql
-- 薬情報の分離
CREATE TABLE patient_treatment_medicines (
    patient_id INT,
    treatment_date DATE,
    treatment_code VARCHAR(10),
    medicine_code VARCHAR(10),
    medicine_name VARCHAR(100),
    
    PRIMARY KEY (patient_id, treatment_date, treatment_code, medicine_code)
);
```

#### 第2正規形への変換
```sql
-- 患者テーブル
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    patient_address VARCHAR(200),
    patient_phone VARCHAR(20)
);

-- 医師テーブル
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    doctor_specialty VARCHAR(50)
);

-- 治療テーブル
CREATE TABLE treatments (
    treatment_code VARCHAR(10) PRIMARY KEY,
    treatment_name VARCHAR(100) NOT NULL,
    treatment_cost DECIMAL(8,2)
);

-- 薬テーブル
CREATE TABLE medicines (
    medicine_code VARCHAR(10) PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL
);
```

#### 第3正規形（最終形）
```sql
-- 診療記録テーブル
CREATE TABLE patient_treatments (
    treatment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    treatment_date DATE NOT NULL,
    treatment_code VARCHAR(10) NOT NULL,
    total_cost DECIMAL(10,2),
    
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (treatment_code) REFERENCES treatments(treatment_code)
);

-- 診療薬剤テーブル
CREATE TABLE treatment_medicines (
    treatment_id BIGINT,
    medicine_code VARCHAR(10),
    
    PRIMARY KEY (treatment_id, medicine_code),
    FOREIGN KEY (treatment_id) REFERENCES patient_treatments(treatment_id),
    FOREIGN KEY (medicine_code) REFERENCES medicines(medicine_code)
);
```

2. **特定患者の治療履歴取得クエリ**：
```sql
SELECT 
    pt.treatment_date,
    d.doctor_name,
    d.doctor_specialty,
    t.treatment_name,
    t.treatment_cost,
    GROUP_CONCAT(m.medicine_name) as medicines,
    pt.total_cost
FROM patient_treatments pt
JOIN doctors d ON pt.doctor_id = d.doctor_id
JOIN treatments t ON pt.treatment_code = t.treatment_code
LEFT JOIN treatment_medicines tm ON pt.treatment_id = tm.treatment_id
LEFT JOIN medicines m ON tm.medicine_code = m.medicine_code
WHERE pt.patient_id = 12345
GROUP BY pt.treatment_id
ORDER BY pt.treatment_date DESC;
```

### 解答43-5

1. **逆正規化の適用判断**：
   最も頻繁な処理（注文履歴表示）を最適化するため、以下に逆正規化を適用：

```sql
-- 注文履歴サマリーテーブル（逆正規化）
CREATE TABLE order_history_summary (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),    -- 重複格納
    customer_email VARCHAR(100),   -- 重複格納
    order_date DATE,
    total_amount DECIMAL(10,2),
    item_count INT,
    status VARCHAR(20),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_customer_date (customer_id, order_date)
);
```

2. **利点と欠点**：

**利点**：
- 注文履歴表示が高速化（JOINが不要）
- 顧客情報への負荷軽減
- シンプルなクエリで済む

**欠点**：
- 顧客情報変更時の同期が必要
- ストレージ使用量の増加
- データ不整合のリスク

3. **整合性保持の仕組み**：

```sql
-- トリガーによる自動同期
DELIMITER //
CREATE TRIGGER update_order_summary_on_customer_change
AFTER UPDATE ON customers
FOR EACH ROW
BEGIN
    UPDATE order_history_summary 
    SET customer_name = NEW.customer_name,
        customer_email = NEW.email,
        last_updated = CURRENT_TIMESTAMP
    WHERE customer_id = NEW.customer_id;
END //
DELIMITER ;

-- 定期的な整合性チェック用クエリ
SELECT o.order_id 
FROM order_history_summary o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.customer_name != c.customer_name 
   OR o.customer_email != c.email;
```

### 解答43-6

1. **エンティティの抽出**：
   - 学生（Students）
   - 教員（Faculty）
   - 科目（Subjects）
   - 教室（Classrooms）
   - 時間帯（Time_Slots）
   - 学部（Departments）
   - 履修記録（Enrollments）
   - 時間割（Schedule）

2. **第3正規形のテーブル構造**：

```sql
-- 学部テーブル
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- 学生テーブル
CREATE TABLE students (
    student_id VARCHAR(20) PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    grade_level INT NOT NULL,
    department_id INT NOT NULL,
    
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 教員テーブル
CREATE TABLE faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    faculty_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    position ENUM('assistant', 'associate', 'professor') NOT NULL,
    
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 教室テーブル
CREATE TABLE classrooms (
    classroom_id VARCHAR(20) PRIMARY KEY,
    building VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    equipment TEXT
);

-- 時間帯テーブル
CREATE TABLE time_slots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday') NOT NULL,
    period INT NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    
    UNIQUE KEY unique_day_period (day_of_week, period)
);

-- 科目テーブル
CREATE TABLE subjects (
    subject_id VARCHAR(20) PRIMARY KEY,
    subject_name VARCHAR(128) NOT NULL,
    credits INT NOT NULL,
    subject_type ENUM('required', 'elective') NOT NULL
);

-- 時間割テーブル
CREATE TABLE schedules (
    schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20) NOT NULL,
    faculty_id INT NOT NULL,
    classroom_id VARCHAR(20) NOT NULL,
    slot_id INT NOT NULL,
    academic_year YEAR NOT NULL,
    semester ENUM('spring', 'fall') NOT NULL,
    
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id),
    FOREIGN KEY (slot_id) REFERENCES time_slots(slot_id),
    
    -- 重複防止制約
    UNIQUE KEY unique_classroom_time (classroom_id, slot_id, academic_year, semester),
    UNIQUE KEY unique_faculty_time (faculty_id, slot_id, academic_year, semester)
);

-- 履修記録テーブル
CREATE TABLE enrollments (
    student_id VARCHAR(20),
    schedule_id BIGINT,
    academic_year YEAR NOT NULL,
    grade ENUM('A+','A','B+','B','C+','C','D+','D','F') DEFAULT NULL,
    
    PRIMARY KEY (student_id, schedule_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id)
);
```

3. **重複チェック制約**：

```sql
-- 学生の時間割重複チェック用ビュー
CREATE VIEW student_schedule_conflicts AS
SELECT 
    e1.student_id,
    e1.schedule_id as schedule1_id,
    e2.schedule_id as schedule2_id,
    s1.academic_year,
    s1.semester
FROM enrollments e1
JOIN enrollments e2 ON e1.student_id = e2.student_id AND e1.schedule_id < e2.schedule_id
JOIN schedules s1 ON e1.schedule_id = s1.schedule_id
JOIN schedules s2 ON e2.schedule_id = s2.schedule_id
WHERE s1.slot_id = s2.slot_id 
AND s1.academic_year = s2.academic_year 
AND s1.semester = s2.semester;
```

4. **よく使われるクエリ**：

```sql
-- 学生の時間割表示
SELECT 
    ts.day_of_week,
    ts.period,
    ts.start_time,
    ts.end_time,
    sub.subject_name,
    f.faculty_name,
    c.classroom_id,
    c.building
FROM enrollments e
JOIN schedules s ON e.schedule_id = s.schedule_id
JOIN subjects sub ON s.subject_id = sub.subject_id
JOIN faculty f ON s.faculty_id = f.faculty_id
JOIN classrooms c ON s.classroom_id = c.classroom_id
JOIN time_slots ts ON s.slot_id = ts.slot_id
WHERE e.student_id = 'S2025001'
AND s.academic_year = 2025
AND s.semester = 'spring'
ORDER BY ts.day_of_week, ts.period;

-- 教室利用状況確認
SELECT 
    c.classroom_id,
    c.building,
    ts.day_of_week,
    ts.period,
    sub.subject_name,
    f.faculty_name,
    COUNT(e.student_id) as enrolled_students,
    c.capacity,
    ROUND(COUNT(e.student_id) * 100.0 / c.capacity, 1) as occupancy_rate
FROM schedules s
JOIN classrooms c ON s.classroom_id = c.classroom_id
JOIN time_slots ts ON s.slot_id = ts.slot_id
JOIN subjects sub ON s.subject_id = sub.subject_id
JOIN faculty f ON s.faculty_id = f.faculty_id
LEFT JOIN enrollments e ON s.schedule_id = e.schedule_id
WHERE s.academic_year = 2025 
AND s.semester = 'spring'
GROUP BY s.schedule_id
ORDER BY c.classroom_id, ts.day_of_week, ts.period;
```

## まとめ

この章では、データベース正規化について詳しく学習しました：

1. **正規化の目的**：
   - データの冗長性削除
   - 更新・挿入・削除異常の防止
   - データ整合性の向上
   - ストレージ効率の改善

2. **正規化の段階**：
   - **第1正規形（1NF）**：原子的な値、反復項目の除去
   - **第2正規形（2NF）**：部分関数従属の除去
   - **第3正規形（3NF）**：推移関数従属の除去
   - **ボイス・コッド正規形（BCNF）**：決定項が候補キーの制約

3. **実践的な考慮事項**：
   - パフォーマンスとのバランス
   - 逆正規化の適用場面
   - 業務要件に応じた調整

4. **設計指針**：
   - 第3正規形を基本目標とする
   - 段階的な適用
   - 明確な目的を持った逆正規化

正規化は、**保守性の高いデータベース設計の基礎**となる重要な技法です。ただし、盲目的に適用するのではなく、**システムの要件とパフォーマンスを考慮したバランスの取れた設計**が重要です。

次の章では、「キー：主キー、外部キー、候補キー」について学び、データベースの整合性を保つための制約について理解を深めていきます。