# 32. テーブル作成：CREATE TABLE文

## はじめに

前章までで、データの操作と管理について詳しく学習しました。第6章からは、「データ定義言語（DDL：Data Definition Language）」について学習していきます。DDLは、データベースの構造そのものを定義・変更するためのSQL文群です。

この章では、データベースの基礎となる「テーブル」を作成するための「CREATE TABLE文」について学習します。CREATE TABLE文は、データベースに新しいテーブルを作成し、そのテーブルの構造（カラム名、データ型、制約など）を定義するためのSQL文です。

CREATE TABLE文が必要となる場面の例：
- 「新しい学校システムを構築するため、学生テーブルを作成したい」
- 「既存システムに新機能を追加するため、新しいテーブルが必要」
- 「データ移行のため、一時的なテーブルを作成したい」
- 「レポート用の集計テーブルを作成したい」
- 「ログデータを保存するためのテーブルを作成したい」
- 「テスト環境用のテーブルを作成したい」

この章では、CREATE TABLE文の基本構文から、データ型の選択、制約の設定、実践的な設計方法まで詳しく学んでいきます。

## CREATE TABLE文とは

CREATE TABLE文は、データベースに新しいテーブルを作成するためのSQL文です。テーブルの構造（スキーマ）を定義し、どのような種類のデータをどのような形式で格納するかを決定します。

> **用語解説**：
> - **DDL（Data Definition Language）**：データベースの構造を定義するためのSQL文の分類です。CREATE、ALTER、DROPなどが含まれます。
> - **テーブル**：データベース内でデータを格納する基本的な構造で、行（レコード）と列（カラム）で構成されます。
> - **スキーマ**：データベースやテーブルの構造定義のことです。
> - **カラム（列）**：テーブル内の縦方向のデータ項目です。例：学生名、学生ID など。
> - **データ型**：各カラムに格納できるデータの種類を指定します。例：整数型、文字列型、日付型など。
> - **制約（Constraint）**：カラムに格納されるデータの条件や規則を定義します。例：NOT NULL、PRIMARY KEYなど。
> - **主キー（Primary Key）**：テーブル内の各行を一意に識別するためのカラムまたはカラムの組み合わせです。
> - **外部キー（Foreign Key）**：他のテーブルの主キーを参照するキーで、テーブル間の関連性を定義します。

## CREATE TABLE文の基本構文

### 基本的な構文

```sql
CREATE TABLE テーブル名 (
    カラム名1 データ型 [制約],
    カラム名2 データ型 [制約],
    カラム名3 データ型 [制約],
    ...
    [テーブル制約]
);
```

### 構文の要素

- **テーブル名**：作成するテーブルの名前を指定します
- **カラム名**：テーブル内の各カラム（列）の名前を指定します
- **データ型**：そのカラムに格納できるデータの種類を指定します
- **制約**：データの整合性を保つための規則を指定します（オプション）

## MySQLの主要データ型

CREATE TABLE文では、各カラムのデータ型を適切に選択することが重要です。

### 1. 数値型

| データ型 | 説明 | 格納範囲 | 使用例 |
|----------|------|----------|--------|
| **TINYINT** | 小さな整数 | -128 ～ 127 | フラグ、ステータス |
| **INT/INTEGER** | 整数 | -2,147,483,648 ～ 2,147,483,647 | ID、数量 |
| **BIGINT** | 大きな整数 | -9,223,372,036,854,775,808 ～ 9,223,372,036,854,775,807 | 大きなID |
| **DECIMAL(M,D)** | 固定小数点数 | M：全体桁数、D：小数点以下桁数 | 金額、正確な数値 |
| **FLOAT** | 単精度浮動小数点数 | 約7桁の精度 | 概算値 |
| **DOUBLE** | 倍精度浮動小数点数 | 約15桁の精度 | 科学計算 |

### 2. 文字列型

| データ型 | 説明 | 最大長 | 使用例 |
|----------|------|--------|--------|
| **CHAR(n)** | 固定長文字列 | 255文字 | 固定長コード |
| **VARCHAR(n)** | 可変長文字列 | 65,535文字 | 名前、説明 |
| **TEXT** | 長い文字列 | 65,535文字 | 長い説明文 |
| **MEDIUMTEXT** | より長い文字列 | 16,777,215文字 | 記事本文 |
| **LONGTEXT** | 非常に長い文字列 | 4,294,967,295文字 | 大容量テキスト |

### 3. 日付・時刻型

| データ型 | 説明 | 形式 | 使用例 |
|----------|------|------|--------|
| **DATE** | 日付 | YYYY-MM-DD | 生年月日、開始日 |
| **TIME** | 時刻 | HH:MM:SS | 開始時刻、終了時刻 |
| **DATETIME** | 日付と時刻 | YYYY-MM-DD HH:MM:SS | 登録日時、更新日時 |
| **TIMESTAMP** | タイムスタンプ | YYYY-MM-DD HH:MM:SS | 自動更新される日時 |
| **YEAR** | 年 | YYYY | 年度、卒業年 |

### 4. その他の型

| データ型 | 説明 | 使用例 |
|----------|------|--------|
| **BOOLEAN/BOOL** | 真偽値 | フラグ（TRUE/FALSE） |
| **ENUM('値1','値2',...)** | 列挙型 | ステータス（'active','inactive'） |
| **JSON** | JSON形式データ | 設定情報、メタデータ |

## 基本的なテーブル作成例

### 例1：シンプルな学生テーブル

```sql
-- 基本的な学生テーブルの作成
CREATE TABLE simple_students (
    student_id INT,
    student_name VARCHAR(100),
    birth_date DATE,
    email VARCHAR(255)
);

-- テーブル構造の確認
DESCRIBE simple_students;

-- または
SHOW CREATE TABLE simple_students;
```

### 例2：制約を含む教師テーブル

```sql
-- 制約付きの教師テーブル
CREATE TABLE teachers_new (
    teacher_id BIGINT NOT NULL,
    teacher_name VARCHAR(64) NOT NULL,
    email VARCHAR(255) UNIQUE,
    hire_date DATE,
    department VARCHAR(50) DEFAULT '未配属',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 例3：主キーと外部キーを含むテーブル

```sql
-- 講座テーブル（外部キー制約付き）
CREATE TABLE courses_new (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT NOT NULL,
    credits INT DEFAULT 2,
    max_students INT DEFAULT 30,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- 外部キー制約
    FOREIGN KEY (teacher_id) REFERENCES teachers_new(teacher_id)
);
```

## 制約の詳細解説

### 1. カラム制約

#### NOT NULL制約

```sql
-- 必須項目の定義
CREATE TABLE required_data_example (
    id INT NOT NULL,                    -- 必須
    name VARCHAR(100) NOT NULL,         -- 必須
    description VARCHAR(500),           -- オプション（NULLを許可）
    created_at TIMESTAMP NOT NULL       -- 必須
);
```

#### DEFAULT制約

```sql
-- デフォルト値の設定
CREATE TABLE default_values_example (
    id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'active',                    -- 文字列のデフォルト
    priority INT DEFAULT 1,                                 -- 数値のデフォルト
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,         -- 現在日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
               ON UPDATE CURRENT_TIMESTAMP,                 -- 更新時に自動更新
    is_enabled BOOLEAN DEFAULT TRUE                         -- 真偽値のデフォルト
);
```

#### UNIQUE制約

```sql
-- 一意性制約の設定
CREATE TABLE unique_constraint_example (
    id INT PRIMARY KEY,
    email VARCHAR(255) UNIQUE,                              -- 単一カラムの一意性
    username VARCHAR(50) UNIQUE,
    phone VARCHAR(20),
    
    -- 複数カラムの組み合わせ一意性
    UNIQUE KEY unique_phone_user (phone, username)
);
```

### 2. テーブル制約

#### PRIMARY KEY制約

```sql
-- 主キーの設定方法

-- 方法1：カラム定義時に指定
CREATE TABLE primary_key_example1 (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- 方法2：テーブル制約として指定
CREATE TABLE primary_key_example2 (
    id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    
    PRIMARY KEY (id)
);

-- 方法3：複合主キー
CREATE TABLE composite_key_example (
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    enrollment_date DATE NOT NULL,
    
    PRIMARY KEY (student_id, course_id)
);
```

#### FOREIGN KEY制約

```sql
-- 外部キー制約の設定
CREATE TABLE enrollment_example (
    enrollment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    enrollment_date DATE NOT NULL,
    grade DECIMAL(3,1),
    
    -- 外部キー制約の定義
    FOREIGN KEY (student_id) REFERENCES simple_students(student_id)
        ON DELETE CASCADE                    -- 参照先削除時に連動削除
        ON UPDATE CASCADE,                   -- 参照先更新時に連動更新
    
    FOREIGN KEY (course_id) REFERENCES courses_new(course_id)
        ON DELETE RESTRICT                   -- 参照先削除を禁止
        ON UPDATE RESTRICT                   -- 参照先更新を禁止
);
```

#### CHECK制約（MySQL 8.0以降）

```sql
-- CHECK制約の使用例
CREATE TABLE student_grades_example (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    subject VARCHAR(100) NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    semester INT NOT NULL,
    academic_year INT NOT NULL,
    
    -- CHECK制約の定義
    CHECK (score >= 0 AND score <= 100),                   -- 点数の範囲制限
    CHECK (semester IN (1, 2)),                            -- 学期の値制限
    CHECK (academic_year >= 2000 AND academic_year <= 2100) -- 年度の範囲制限
);
```

## AUTO_INCREMENTの使用

### 基本的な使用方法

```sql
-- 自動連番の設定
CREATE TABLE auto_increment_example (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,      -- 自動増加する主キー
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- データ挿入時（IDは自動設定される）
INSERT INTO auto_increment_example (name) VALUES ('テストデータ1');
INSERT INTO auto_increment_example (name) VALUES ('テストデータ2');

-- 結果確認
SELECT * FROM auto_increment_example;
```

### 開始値の設定

```sql
-- 連番の開始値を指定
CREATE TABLE custom_auto_increment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(200)
) AUTO_INCREMENT = 1000;                       -- 1000から開始

-- 既存テーブルの開始値変更
ALTER TABLE auto_increment_example AUTO_INCREMENT = 100;
```

## 実践的なテーブル作成例

### 例4：学校管理システムの完全な学生テーブル

```sql
-- 実用的な学生テーブル
CREATE TABLE students_complete (
    -- 基本情報
    student_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_number VARCHAR(20) UNIQUE NOT NULL,           -- 学籍番号
    first_name VARCHAR(50) NOT NULL,                      -- 名
    last_name VARCHAR(50) NOT NULL,                       -- 姓
    first_name_kana VARCHAR(100),                         -- 名（カナ）
    last_name_kana VARCHAR(100),                          -- 姓（カナ）
    
    -- 個人情報
    birth_date DATE,
    gender ENUM('male', 'female', 'other', 'prefer_not_to_say'),
    nationality VARCHAR(50) DEFAULT '日本',
    
    -- 連絡先情報
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    emergency_contact VARCHAR(100),
    emergency_phone VARCHAR(20),
    
    -- 住所情報
    postal_code VARCHAR(10),
    prefecture VARCHAR(20),
    city VARCHAR(50),
    address_line VARCHAR(200),
    
    -- 学籍情報
    admission_date DATE NOT NULL,
    graduation_date DATE,
    status ENUM('enrolled', 'graduated', 'withdrawn', 'suspended') DEFAULT 'enrolled',
    class_year INT,
    major VARCHAR(100),
    
    -- システム情報
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- 制約
    CHECK (birth_date <= CURRENT_DATE),                   -- 生年月日は現在日以前
    CHECK (admission_date >= '2000-01-01'),              -- 入学日は2000年以降
    CHECK (class_year >= 1 AND class_year <= 6),         -- 学年は1-6年
    
    -- インデックス
    INDEX idx_student_number (student_number),
    INDEX idx_name (last_name, first_name),
    INDEX idx_admission_date (admission_date),
    INDEX idx_status (status)
);
```

### 例5：授業評価テーブル

```sql
-- 授業評価システムテーブル
CREATE TABLE course_evaluations (
    evaluation_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    teacher_id BIGINT NOT NULL,
    
    -- 評価項目（1-5のスコア）
    content_quality TINYINT,                             -- 内容の質
    teaching_method TINYINT,                             -- 教授法
    difficulty_level TINYINT,                            -- 難易度
    workload TINYINT,                                    -- 課題量
    overall_satisfaction TINYINT,                        -- 総合満足度
    
    -- 自由記述
    good_points TEXT,                                    -- 良かった点
    improvement_points TEXT,                             -- 改善点
    
    -- 推奨度
    would_recommend BOOLEAN,
    
    -- システム情報
    evaluation_date DATE NOT NULL,
    is_anonymous BOOLEAN DEFAULT TRUE,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 制約
    CHECK (content_quality >= 1 AND content_quality <= 5),
    CHECK (teaching_method >= 1 AND teaching_method <= 5),
    CHECK (difficulty_level >= 1 AND difficulty_level <= 5),
    CHECK (workload >= 1 AND workload <= 5),
    CHECK (overall_satisfaction >= 1 AND overall_satisfaction <= 5),
    
    -- 外部キー制約
    FOREIGN KEY (student_id) REFERENCES students_complete(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses_new(course_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers_new(teacher_id) ON DELETE CASCADE,
    
    -- 一意性制約（1学生1講座1回のみ評価可能）
    UNIQUE KEY unique_evaluation (student_id, course_id),
    
    -- インデックス
    INDEX idx_course_evaluation (course_id, evaluation_date),
    INDEX idx_teacher_evaluation (teacher_id, evaluation_date)
);
```

## テーブル作成時の注意点

### 1. 命名規則

```sql
-- 良い命名例
CREATE TABLE student_course_enrollments (    -- わかりやすいテーブル名
    enrollment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,              -- 一貫した命名
    course_id VARCHAR(16) NOT NULL,
    enrollment_date DATE NOT NULL
);

-- 避けるべき命名例
CREATE TABLE t1 (                           -- 意味不明なテーブル名
    id INT,                                  -- あいまいなカラム名
    data VARCHAR(100),                       -- 汎用的すぎるカラム名
    dt DATETIME                              -- 略語
);
```

### 2. データ型の適切な選択

```sql
-- 適切なデータ型の選択例
CREATE TABLE data_type_best_practices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,                -- 将来の拡張を考慮
    status ENUM('active', 'inactive', 'pending'),        -- 固定値はENUM
    score DECIMAL(5,2),                                  -- 金額や正確な数値
    description VARCHAR(500),                            -- 適切な長さ設定
    large_text MEDIUMTEXT,                               -- 容量に応じた選択
    flag BOOLEAN,                                        -- 真偽値はBOOLEAN
    percentage TINYINT UNSIGNED,                         -- 0-255の範囲で十分
    
    CHECK (percentage <= 100)                            -- 範囲制限
);
```

### 3. 制約の適切な設定

```sql
-- 制約設定のベストプラクティス
CREATE TABLE constraint_best_practices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- 必須項目には NOT NULL
    name VARCHAR(100) NOT NULL,
    
    -- 一意性が必要な項目には UNIQUE
    email VARCHAR(255) UNIQUE NOT NULL,
    
    -- デフォルト値の設定
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 範囲制限
    age TINYINT UNSIGNED,
    CHECK (age >= 0 AND age <= 150),
    
    -- 外部キー制約
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
        ON DELETE SET NULL                               -- 参照先削除時はNULLに設定
        ON UPDATE CASCADE                                -- 参照先更新時は連動更新
);
```

## エラーと対処法

### 1. 既存テーブル名の重複

```sql
-- エラー例
CREATE TABLE students (                      -- 既存のテーブル名
    id INT PRIMARY KEY,
    name VARCHAR(100)
);
-- エラー: Table 'students' already exists

-- 対処法1: IF NOT EXISTS を使用
CREATE TABLE IF NOT EXISTS students_backup (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- 対処法2: 異なるテーブル名を使用
CREATE TABLE students_new_version (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);
```

### 2. データ型の不適切な使用

```sql
-- エラー例
CREATE TABLE data_type_error (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR,                            -- 長さ指定なし
    score DECIMAL,                           -- 精度指定なし
    date_value DATE(10)                      -- 不要な長さ指定
);

-- 正しい書き方
CREATE TABLE data_type_correct (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),                       -- 適切な長さ指定
    score DECIMAL(5,2),                      -- 精度指定
    date_value DATE                          -- 長さ指定不要
);
```

### 3. 外部キー制約エラー

```sql
-- エラー例：参照先テーブルが存在しない
CREATE TABLE enrollment_error (
    student_id INT,
    course_id VARCHAR(16),
    FOREIGN KEY (student_id) REFERENCES non_existent_table(id)  -- 存在しないテーブル
);

-- 対処法：参照先テーブルを先に作成
CREATE TABLE students_ref (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE enrollment_correct (
    student_id INT,
    course_id VARCHAR(16),
    FOREIGN KEY (student_id) REFERENCES students_ref(id)
);
```

## テーブル作成のベストプラクティス

### 1. 段階的なテーブル設計

```sql
-- Phase 1: 基本テーブル
CREATE TABLE products_basic (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Phase 2: カテゴリテーブル追加
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Phase 3: 関連付け
ALTER TABLE products_basic 
ADD COLUMN category_id INT,
ADD FOREIGN KEY (category_id) REFERENCES categories(id);
```

### 2. 将来の拡張を考慮した設計

```sql
-- 拡張性を考慮したテーブル設計
CREATE TABLE future_proof_design (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,        -- 大きなIDに対応
    uuid CHAR(36) UNIQUE,                        -- UUID対応
    version INT DEFAULT 1,                       -- バージョン管理
    
    -- JSONカラムで柔軟な属性管理
    attributes JSON,
    
    -- 論理削除対応
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    
    -- 監査ログ対応
    created_by BIGINT,
    updated_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 3. ドキュメント化

```sql
-- コメント付きテーブル作成
CREATE TABLE documented_table (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主キー（自動増加）',
    user_id BIGINT NOT NULL COMMENT 'ユーザーID（usersテーブルの外部キー）',
    title VARCHAR(200) NOT NULL COMMENT 'タイトル（最大200文字）',
    content TEXT COMMENT '内容（無制限）',
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft' COMMENT 'ステータス',
    view_count INT UNSIGNED DEFAULT 0 COMMENT '閲覧数',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT = 'ブログ記事テーブル';
```

## 練習問題

### 問題32-1：基本的なテーブル作成
教室管理システム用の「教室テーブル（classrooms_practice）」を作成してください。以下のカラムを含めてください：
- room_id: 教室ID（整数、主キー、自動増加）
- room_name: 教室名（文字列、最大50文字、必須）
- building: 建物名（文字列、最大30文字）
- floor: 階数（小さな整数）
- capacity: 収容人数（整数、デフォルト値30）
- has_projector: プロジェクター有無（真偽値、デフォルト値FALSE）

### 問題32-2：制約付きテーブル作成
図書管理システム用の「図書テーブル（books）」を作成してください。以下の要件を満たしてください：
- book_id: 図書ID（大きな整数、主キー、自動増加）
- isbn: ISBN番号（文字列、最大20文字、一意、必須）
- title: 書籍名（文字列、最大200文字、必須）
- author: 著者名（文字列、最大100文字、必須）
- publisher: 出版社（文字列、最大100文字）
- publication_year: 出版年（整数、1900年以降2100年以下の制約）
- price: 価格（小数点2桁まで）
- category: カテゴリ（'fiction', 'non-fiction', 'textbook', 'reference'のいずれか）
- is_available: 貸出可能フラグ（真偽値、デフォルト値TRUE）
- created_at: 登録日時（タイムスタンプ、現在日時がデフォルト）

### 問題32-3：外部キー制約付きテーブル作成
図書貸出管理システム用の「貸出テーブル（book_loans）」を作成してください。前問のbooksテーブルと、既存のstudentsテーブルを参照する外部キーを含めてください：
- loan_id: 貸出ID（大きな整数、主キー、自動増加）
- book_id: 図書ID（外部キー、booksテーブル参照、必須）
- student_id: 学生ID（外部キー、studentsテーブル参照、必須）
- loan_date: 貸出日（日付、必須）
- due_date: 返却予定日（日付、必須）
- return_date: 返却日（日付、NULL許可）
- status: ステータス（'borrowed', 'returned', 'overdue'のいずれか、デフォルト'borrowed'）
- 制約：due_dateはloan_dateより後の日付であること
- 制約：return_dateが設定されている場合、loan_date以降であること

### 問題32-4：複合的なテーブル設計
時間割管理システム用の「時間割テーブル（class_schedules）」を作成してください：
- schedule_id: スケジュールID（大きな整数、主キー、自動増加）
- course_id: 講座ID（文字列、既存のcoursesテーブル参照）
- classroom_id: 教室ID（前問で作成したclassrooms_practiceテーブル参照）
- day_of_week: 曜日（1=月曜日～7=日曜日、1-7の範囲制約）
- period: 時限（1-8の範囲制約）
- start_time: 開始時刻（時刻型）
- end_time: 終了時刻（時刻型）
- semester: 学期（'spring', 'summer', 'fall', 'winter'のいずれか）
- academic_year: 年度（整数、2000年以降の制約）
- is_active: 有効フラグ（真偽値、デフォルトTRUE）
- 制約：end_timeはstart_timeより後の時刻であること
- 制約：同じ教室、同じ曜日、同じ時限、同じ学期、同じ年度の組み合わせは一意であること

### 問題32-5：JSON型を使用したテーブル作成
学生の追加情報を管理する「学生プロフィールテーブル（student_profiles）」を作成してください：
- profile_id: プロフィールID（大きな整数、主キー、自動増加）
- student_id: 学生ID（外部キー、studentsテーブル参照、必須、一意）
- hobbies: 趣味（JSON型）
- skills: スキル（JSON型）
- emergency_contacts: 緊急連絡先（JSON型）
- preferences: 設定（JSON型、デフォルト値は空のJSONオブジェクト'{}'）
- last_updated: 最終更新日時（タイムスタンプ、更新時に自動更新）

### 問題32-6：包括的なテーブル設計
成績管理システムの拡張として「詳細成績テーブル（detailed_grades）」を作成してください。以下の要件をすべて満たしてください：
- 自動増加の主キー
- 既存のstudents、courses、teachersテーブルとの外部キー関係
- 複数の評価項目（筆記試験、実技試験、レポート、出席点など）
- 各評価の重み付け設定
- 成績の範囲制約（0-100点）
- 評価日時の記録
- 評価者（教師）の記録
- コメント機能
- 再評価フラグ
- 論理削除機能
- 作成・更新日時の自動管理
- 適切なインデックス設定

## 解答

### 解答32-1
```sql
CREATE TABLE classrooms_practice (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_name VARCHAR(50) NOT NULL,
    building VARCHAR(30),
    floor TINYINT,
    capacity INT DEFAULT 30,
    has_projector BOOLEAN DEFAULT FALSE
);
```

### 解答32-2
```sql
CREATE TABLE books (
    book_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publisher VARCHAR(100),
    publication_year INT,
    price DECIMAL(8,2),
    category ENUM('fiction', 'non-fiction', 'textbook', 'reference'),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CHECK (publication_year >= 1900 AND publication_year <= 2100)
);
```

### 解答32-3
```sql
CREATE TABLE book_loans (
    loan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    book_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('borrowed', 'returned', 'overdue') DEFAULT 'borrowed',
    
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE RESTRICT,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE RESTRICT,
    
    CHECK (due_date > loan_date),
    CHECK (return_date IS NULL OR return_date >= loan_date)
);
```

### 解答32-4
```sql
CREATE TABLE class_schedules (
    schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(16) NOT NULL,
    classroom_id INT NOT NULL,
    day_of_week TINYINT NOT NULL,
    period TINYINT NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    semester ENUM('spring', 'summer', 'fall', 'winter') NOT NULL,
    academic_year INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (classroom_id) REFERENCES classrooms_practice(room_id) ON DELETE RESTRICT,
    
    CHECK (day_of_week >= 1 AND day_of_week <= 7),
    CHECK (period >= 1 AND period <= 8),
    CHECK (end_time > start_time),
    CHECK (academic_year >= 2000),
    
    UNIQUE KEY unique_schedule (classroom_id, day_of_week, period, semester, academic_year)
);
```

### 解答32-5
```sql
CREATE TABLE student_profiles (
    profile_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL UNIQUE,
    hobbies JSON,
    skills JSON,
    emergency_contacts JSON,
    preferences JSON DEFAULT ('{}'),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);
```

### 解答32-6
```sql
CREATE TABLE detailed_grades (
    grade_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    teacher_id BIGINT NOT NULL,
    
    -- 評価項目
    evaluation_type ENUM('written_exam', 'practical_exam', 'report', 'attendance', 'participation', 'project') NOT NULL,
    evaluation_name VARCHAR(100) NOT NULL,
    
    -- 成績関連
    score DECIMAL(5,2),
    max_score DECIMAL(5,2) DEFAULT 100,
    weight_percentage DECIMAL(5,2) DEFAULT 100,
    
    -- 日時関連
    evaluation_date DATE NOT NULL,
    submission_deadline DATETIME,
    submitted_at DATETIME,
    
    -- 追加情報
    comments TEXT,
    is_revaluation BOOLEAN DEFAULT FALSE,
    original_grade_id BIGINT,
    
    -- 論理削除
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    deleted_by BIGINT,
    
    -- 監査情報
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by BIGINT,
    updated_by BIGINT,
    
    -- 制約
    CHECK (score >= 0 AND score <= max_score),
    CHECK (max_score > 0),
    CHECK (weight_percentage >= 0 AND weight_percentage <= 100),
    CHECK (submitted_at IS NULL OR submitted_at <= CURRENT_TIMESTAMP),
    
    -- 外部キー制約
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE RESTRICT,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE RESTRICT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id) ON DELETE RESTRICT,
    FOREIGN KEY (original_grade_id) REFERENCES detailed_grades(grade_id) ON DELETE SET NULL,
    
    -- インデックス
    INDEX idx_student_course (student_id, course_id),
    INDEX idx_evaluation_date (evaluation_date),
    INDEX idx_teacher_course (teacher_id, course_id),
    INDEX idx_evaluation_type (evaluation_type),
    INDEX idx_active_grades (is_deleted, evaluation_date)
) COMMENT = '詳細成績管理テーブル';
```

## まとめ

この章では、CREATE TABLE文について詳しく学びました：

1. **CREATE TABLE文の基本概念**：
   - DDL（データ定義言語）の一部としての役割
   - テーブル構造（スキーマ）の定義
   - カラム、データ型、制約の基本理解

2. **データ型の選択**：
   - 数値型（INT、BIGINT、DECIMAL等）の適切な使用
   - 文字列型（VARCHAR、TEXT等）の容量考慮
   - 日付・時刻型の使い分け
   - 特殊型（ENUM、JSON等）の活用

3. **制約の活用**：
   - NOT NULL制約による必須項目の定義
   - PRIMARY KEY制約による主キー設定
   - FOREIGN KEY制約による関連性の定義
   - CHECK制約による値の範囲制限
   - UNIQUE制約による一意性の保証

4. **実践的な設計手法**：
   - AUTO_INCREMENTによる自動連番
   - DEFAULT値による初期値設定
   - 複合制約の使用
   - 将来の拡張性を考慮した設計

5. **ベストプラクティス**：
   - 適切な命名規則の採用
   - 段階的なテーブル設計
   - ドキュメント化の重要性
   - パフォーマンスを考慮したインデックス設定

6. **エラー回避と対処法**：
   - よくあるエラーパターンの理解
   - IF NOT EXISTSによる安全な作成
   - 制約エラーの回避方法

CREATE TABLE文は、データベース設計の基礎となる重要なSQL文です。適切にテーブルを設計することで、データの整合性を保ち、効率的なデータベースシステムを構築できます。

次の章では、「ALTER TABLE：テーブル構造の変更」について学び、既存テーブルの構造を安全に変更する方法を理解していきます。