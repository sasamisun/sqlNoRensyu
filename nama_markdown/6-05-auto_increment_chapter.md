# 36. シーケンス/AUTO_INCREMENT：連番生成

## はじめに

前章では、制約を使ってデータの整合性を保つ方法を学習しました。この章では、データベースで一意な識別子を自動生成する「連番生成」について詳しく学習します。

MySQLでは、主に「AUTO_INCREMENT」機能を使用して連番を生成します。他のデータベース管理システム（PostgreSQL、Oracle、SQL Serverなど）で提供される「SEQUENCE」オブジェクトとは異なりますが、同様の機能を実現できます。

連番生成が必要となる場面の例：
- 「学生に一意の学生IDを自動で割り当てたい」
- 「注文番号、請求書番号などのビジネス文書に連番を付けたい」
- 「ログレコードに時系列の識別子を付けたい」
- 「複数のテーブルで共通の連番体系を使いたい」
- 「年度別、月別の連番を管理したい」
- 「欠番を避けて確実に連続した番号を生成したい」
- 「高負荷環境で競合状態を避けながら連番を生成したい」

この章では、AUTO_INCREMENTの基本的な使用方法から、複雑な連番管理システムの設計まで詳しく学んでいきます。

## 連番生成とは

連番生成は、データベースで一意な識別子を自動的に生成する仕組みです。主キーとして使用されることが多く、新しいレコードが挿入されるたびに自動的に次の番号が割り当てられます。

> **用語解説**：
> - **AUTO_INCREMENT**：MySQLでカラムに自動的に連番を割り当てる機能です。
> - **シーケンス（SEQUENCE）**：PostgreSQL、Oracle等で提供される連番生成オブジェクトです（MySQLにはありません）。
> - **連番（Sequential Number）**：1, 2, 3...のように連続した数値です。
> - **一意識別子（Unique Identifier）**：各レコードを一意に識別するための値です。
> - **開始値（Start Value）**：連番の開始値を指定します。
> - **増分値（Increment）**：連番の増加幅を指定します（通常は1）。
> - **最大値（Maximum Value）**：連番の上限値です。
> - **欠番（Gap）**：連番の途中で抜けている番号です。
> - **競合状態（Race Condition）**：複数の処理が同時に連番を取得しようとする状況です。
> - **ロック（Lock）**：競合を避けるためにリソースを一時的に占有することです。

## AUTO_INCREMENTの基本

### 1. AUTO_INCREMENTの基本概念

AUTO_INCREMENTは、MySQLでテーブルのカラムに対して自動的に連番を割り当てる機能です。

#### AUTO_INCREMENTの特性
- **自動増加**：INSERT時に自動的に次の値が設定される
- **一意性**：重複しない値が保証される
- **整数型限定**：整数型のカラムにのみ設定可能
- **主キー推奨**：通常は主キーまたはUNIQUEキーに設定
- **テーブル単位**：1つのテーブルに1つのAUTO_INCREMENTカラムのみ

### 2. 基本的なAUTO_INCREMENTの使用

```sql
-- 基本的なAUTO_INCREMENTテーブル
CREATE TABLE basic_auto_increment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- データ挿入（IDは自動設定）
INSERT INTO basic_auto_increment (name) VALUES 
('データ1'),
('データ2'),
('データ3');

-- 結果確認
SELECT * FROM basic_auto_increment;

-- 次のAUTO_INCREMENT値を確認
SHOW TABLE STATUS LIKE 'basic_auto_increment';
```

### 3. AUTO_INCREMENTの詳細情報確認

```sql
-- AUTO_INCREMENT情報の取得
SELECT 
    TABLE_NAME,
    AUTO_INCREMENT,
    TABLE_COMMENT
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'basic_auto_increment';

-- 最後に挿入されたAUTO_INCREMENT値を取得
SELECT LAST_INSERT_ID();

-- より詳細な情報
SHOW CREATE TABLE basic_auto_increment;
```

## AUTO_INCREMENTの詳細設定

### 1. 開始値の設定

```sql
-- テーブル作成時に開始値を指定
CREATE TABLE custom_start_value (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(100)
) AUTO_INCREMENT = 1000;

-- データ挿入
INSERT INTO custom_start_value (data) VALUES ('データA'), ('データB');

-- 結果確認（1000, 1001から開始）
SELECT * FROM custom_start_value;

-- 既存テーブルの開始値変更
ALTER TABLE custom_start_value AUTO_INCREMENT = 2000;

-- 次の挿入は2000から
INSERT INTO custom_start_value (data) VALUES ('データC');
SELECT * FROM custom_start_value;
```

### 2. データ型別のAUTO_INCREMENT

```sql
-- 異なるデータ型でのAUTO_INCREMENT
CREATE TABLE different_types_demo (
    tiny_id TINYINT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(50)
);

CREATE TABLE int_demo (
    int_id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(50)
);

CREATE TABLE bigint_demo (
    bigint_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(50)
);

-- TINYINTの上限テスト（127まで）
INSERT INTO different_types_demo (data) 
SELECT CONCAT('データ', n)
FROM (
    SELECT 1 as n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
) numbers;

SELECT * FROM different_types_demo;

-- 上限値の確認
SELECT 
    'TINYINT' as type, 
    POWER(2, 7) - 1 as signed_max,
    POWER(2, 8) - 1 as unsigned_max
UNION ALL
SELECT 'INT', POWER(2, 31) - 1, POWER(2, 32) - 1
UNION ALL
SELECT 'BIGINT', POWER(2, 63) - 1, POWER(2, 64) - 1;
```

### 3. UNSIGNED型との組み合わせ

```sql
-- UNSIGNED型でのAUTO_INCREMENT
CREATE TABLE unsigned_demo (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(100)
);

-- より大きな範囲の連番が可能
INSERT INTO unsigned_demo (description) VALUES ('UNSIGNEDテスト');

-- 最大値の確認
SELECT 
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    EXTRA
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'unsigned_demo' 
AND COLUMN_NAME = 'id';
```

## カスタム連番生成

### 1. 手動連番管理テーブル

MySQLにはSEQUENCEオブジェクトがないため、手動で連番を管理するテーブルを作成できます。

```sql
-- 連番管理テーブル
CREATE TABLE sequence_generators (
    sequence_name VARCHAR(50) PRIMARY KEY,
    current_value BIGINT UNSIGNED NOT NULL DEFAULT 0,
    increment_by INT NOT NULL DEFAULT 1,
    min_value BIGINT UNSIGNED NOT NULL DEFAULT 1,
    max_value BIGINT UNSIGNED NOT NULL DEFAULT 9223372036854775807,
    cycle_flag BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 連番定義の初期化
INSERT INTO sequence_generators (sequence_name, current_value, increment_by) VALUES
('student_id_seq', 1000, 1),
('order_number_seq', 100000, 1),
('invoice_seq', 202500001, 1);

-- 結果確認
SELECT * FROM sequence_generators;
```

### 2. 連番取得関数の作成

```sql
-- 連番取得のストアドファンクション
DELIMITER //

CREATE FUNCTION get_next_sequence(seq_name VARCHAR(50)) 
RETURNS BIGINT
READS SQL DATA
MODIFIES SQL DATA
DETERMINISTIC
BEGIN
    DECLARE next_val BIGINT;
    DECLARE max_val BIGINT;
    DECLARE increment_val INT;
    DECLARE cycle_enabled BOOLEAN;
    
    -- 現在値と設定を取得（排他制御）
    SELECT 
        current_value + increment_by,
        max_value,
        increment_by,
        cycle_flag
    INTO next_val, max_val, increment_val, cycle_enabled
    FROM sequence_generators 
    WHERE sequence_name = seq_name
    FOR UPDATE;
    
    -- 最大値チェック
    IF next_val > max_val THEN
        IF cycle_enabled THEN
            SET next_val = (SELECT min_value FROM sequence_generators WHERE sequence_name = seq_name);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sequence maximum value exceeded';
        END IF;
    END IF;
    
    -- 値を更新
    UPDATE sequence_generators 
    SET current_value = next_val,
        updated_at = CURRENT_TIMESTAMP
    WHERE sequence_name = seq_name;
    
    RETURN next_val;
END //

DELIMITER ;

-- 関数の使用例
SELECT get_next_sequence('student_id_seq') as next_student_id;
SELECT get_next_sequence('order_number_seq') as next_order_number;
SELECT get_next_sequence('invoice_seq') as next_invoice_number;

-- 連番管理テーブルの確認
SELECT * FROM sequence_generators;
```

### 3. カスタム連番を使用したテーブル作成

```sql
-- カスタム連番を使用する学生テーブル
CREATE TABLE students_with_custom_seq (
    student_id BIGINT PRIMARY KEY,
    student_number VARCHAR(20) UNIQUE,
    student_name VARCHAR(100) NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 学生登録のストアドプロシージャ
DELIMITER //

CREATE PROCEDURE register_student(
    IN p_student_name VARCHAR(100),
    IN p_enrollment_date DATE
)
BEGIN
    DECLARE new_student_id BIGINT;
    DECLARE new_student_number VARCHAR(20);
    
    -- カスタム連番を取得
    SET new_student_id = get_next_sequence('student_id_seq');
    SET new_student_number = CONCAT('S', YEAR(IFNULL(p_enrollment_date, CURRENT_DATE)), 
                                   LPAD(new_student_id, 6, '0'));
    
    -- 学生データを挿入
    INSERT INTO students_with_custom_seq (student_id, student_number, student_name, enrollment_date)
    VALUES (new_student_id, new_student_number, p_student_name, p_enrollment_date);
    
    -- 結果を返す
    SELECT new_student_id as student_id, new_student_number as student_number;
END //

DELIMITER ;

-- プロシージャの使用
CALL register_student('田中太郎', '2025-04-01');
CALL register_student('佐藤花子', '2025-04-01');
CALL register_student('鈴木次郎', '2025-04-02');

-- 結果確認
SELECT * FROM students_with_custom_seq;
```

## 年度別・月別連番

### 1. 年度別連番システム

```sql
-- 年度別連番管理
CREATE TABLE yearly_sequences (
    sequence_name VARCHAR(50),
    year_value INT,
    current_value BIGINT UNSIGNED DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (sequence_name, year_value)
);

-- 年度別連番取得関数
DELIMITER //

CREATE FUNCTION get_yearly_sequence(seq_name VARCHAR(50), target_year INT) 
RETURNS BIGINT
READS SQL DATA
MODIFIES SQL DATA
DETERMINISTIC
BEGIN
    DECLARE next_val BIGINT DEFAULT 1;
    
    -- 該当年度の連番レコードが存在するかチェック
    IF NOT EXISTS (SELECT 1 FROM yearly_sequences 
                   WHERE sequence_name = seq_name AND year_value = target_year) THEN
        INSERT INTO yearly_sequences (sequence_name, year_value, current_value)
        VALUES (seq_name, target_year, 1);
        RETURN 1;
    END IF;
    
    -- 連番を更新して取得
    UPDATE yearly_sequences 
    SET current_value = current_value + 1
    WHERE sequence_name = seq_name AND year_value = target_year;
    
    SELECT current_value INTO next_val
    FROM yearly_sequences 
    WHERE sequence_name = seq_name AND year_value = target_year;
    
    RETURN next_val;
END //

DELIMITER ;

-- 年度別注文番号の生成例
SELECT 
    CONCAT(YEAR(CURRENT_DATE), '-', 
           LPAD(get_yearly_sequence('order_seq', YEAR(CURRENT_DATE)), 6, '0')) 
    as order_number;

-- 複数回実行して確認
SELECT 
    CONCAT(YEAR(CURRENT_DATE), '-', 
           LPAD(get_yearly_sequence('order_seq', YEAR(CURRENT_DATE)), 6, '0')) 
    as order_number;

-- 年度別連番の状況確認
SELECT * FROM yearly_sequences;
```

### 2. 月別連番システム

```sql
-- 月別連番管理
CREATE TABLE monthly_sequences (
    sequence_name VARCHAR(50),
    year_month VARCHAR(7),  -- YYYY-MM形式
    current_value BIGINT UNSIGNED DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (sequence_name, year_month)
);

-- 月別連番取得関数
DELIMITER //

CREATE FUNCTION get_monthly_sequence(seq_name VARCHAR(50), target_year_month VARCHAR(7)) 
RETURNS BIGINT
READS SQL DATA
MODIFIES SQL DATA
DETERMINISTIC
BEGIN
    DECLARE next_val BIGINT DEFAULT 1;
    
    -- 該当月の連番レコードが存在するかチェック
    IF NOT EXISTS (SELECT 1 FROM monthly_sequences 
                   WHERE sequence_name = seq_name AND year_month = target_year_month) THEN
        INSERT INTO monthly_sequences (sequence_name, year_month, current_value)
        VALUES (seq_name, target_year_month, 1);
        RETURN 1;
    END IF;
    
    -- 連番を更新して取得
    UPDATE monthly_sequences 
    SET current_value = current_value + 1
    WHERE sequence_name = seq_name AND year_month = target_year_month;
    
    SELECT current_value INTO next_val
    FROM monthly_sequences 
    WHERE sequence_name = seq_name AND year_month = target_year_month;
    
    RETURN next_val;
END //

DELIMITER ;

-- 月別請求書番号の生成
SELECT 
    CONCAT(DATE_FORMAT(CURRENT_DATE, '%Y%m'), '-', 
           LPAD(get_monthly_sequence('invoice_seq', DATE_FORMAT(CURRENT_DATE, '%Y-%m')), 4, '0')) 
    as invoice_number;

-- 結果確認
SELECT * FROM monthly_sequences;
```

## AUTO_INCREMENTの調整と管理

### 1. AUTO_INCREMENT値のリセット

```sql
-- テスト用テーブル作成
CREATE TABLE reset_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(50)
);

-- データ挿入
INSERT INTO reset_test (data) VALUES ('データ1'), ('データ2'), ('データ3');
SELECT * FROM reset_test;

-- AUTO_INCREMENT値をリセット
TRUNCATE TABLE reset_test;  -- データクリア + AUTO_INCREMENTリセット

-- または
-- DELETE FROM reset_test;
-- ALTER TABLE reset_test AUTO_INCREMENT = 1;

-- 新しいデータ挿入（1から開始）
INSERT INTO reset_test (data) VALUES ('新データ1');
SELECT * FROM reset_test;
```

### 2. AUTO_INCREMENT値の調整

```sql
-- 現在の値を確認
SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reset_test';

-- 値を大きく設定
ALTER TABLE reset_test AUTO_INCREMENT = 1000;

-- 新しいデータ挿入
INSERT INTO reset_test (data) VALUES ('1000番台データ');
SELECT * FROM reset_test;

-- 現在の最大値より小さい値に設定しようとした場合
ALTER TABLE reset_test AUTO_INCREMENT = 500;  -- 効果なし（現在の最大値より小さいため）

-- 確認
SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reset_test';
```

### 3. 欠番の確認と対処

```sql
-- 欠番確認用テーブル
CREATE TABLE gap_analysis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- データ挿入
INSERT INTO gap_analysis (data) VALUES 
('データ1'), ('データ2'), ('データ3'), ('データ4'), ('データ5');

-- 特定のレコードを削除（欠番を作成）
DELETE FROM gap_analysis WHERE id IN (2, 4);

-- 欠番の確認
SELECT * FROM gap_analysis ORDER BY id;

-- 欠番検出クエリ
SELECT 
    id + 1 as gap_start,
    (SELECT MIN(id) - 1 FROM gap_analysis ga2 WHERE ga2.id > ga1.id) as gap_end
FROM gap_analysis ga1
WHERE NOT EXISTS (SELECT 1 FROM gap_analysis ga2 WHERE ga2.id = ga1.id + 1)
AND id < (SELECT MAX(id) FROM gap_analysis);

-- 連続性チェック
SELECT 
    COUNT(*) as total_records,
    MAX(id) as max_id,
    MAX(id) - COUNT(*) as gaps_count
FROM gap_analysis;
```

## 高負荷環境での連番管理

### 1. 競合状態の回避

```sql
-- 安全な連番取得のためのテーブル
CREATE TABLE safe_counter (
    counter_name VARCHAR(50) PRIMARY KEY,
    current_value BIGINT UNSIGNED NOT NULL DEFAULT 0,
    lock_timeout INT DEFAULT 10,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 初期値設定
INSERT INTO safe_counter (counter_name, current_value) VALUES 
('order_counter', 100000),
('ticket_counter', 1000000);

-- 安全な連番取得プロシージャ
DELIMITER //

CREATE PROCEDURE get_safe_sequence(
    IN counter_name VARCHAR(50),
    OUT next_value BIGINT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 行レベルロックで排他制御
    SELECT current_value + 1 INTO next_value
    FROM safe_counter 
    WHERE counter_name = counter_name
    FOR UPDATE;
    
    -- カウンタを更新
    UPDATE safe_counter 
    SET current_value = next_value
    WHERE counter_name = counter_name;
    
    COMMIT;
END //

DELIMITER ;

-- 使用例
CALL get_safe_sequence('order_counter', @order_id);
SELECT @order_id as new_order_id;

CALL get_safe_sequence('ticket_counter', @ticket_id);
SELECT @ticket_id as new_ticket_id;

-- カウンタ状況確認
SELECT * FROM safe_counter;
```

### 2. パフォーマンス最適化

```sql
-- バッチ処理用の連番予約システム
CREATE TABLE sequence_reservations (
    sequence_name VARCHAR(50) PRIMARY KEY,
    reserved_start BIGINT UNSIGNED NOT NULL,
    reserved_end BIGINT UNSIGNED NOT NULL,
    current_position BIGINT UNSIGNED NOT NULL,
    batch_size INT NOT NULL DEFAULT 100,
    last_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- バッチ連番取得プロシージャ
DELIMITER //

CREATE PROCEDURE reserve_sequence_batch(
    IN seq_name VARCHAR(50),
    IN batch_size INT,
    OUT start_value BIGINT,
    OUT end_value BIGINT
)
BEGIN
    DECLARE current_max BIGINT DEFAULT 0;
    
    -- 現在の最大値を取得
    SELECT IFNULL(MAX(reserved_end), 0) INTO current_max
    FROM sequence_reservations 
    WHERE sequence_name = seq_name;
    
    -- 新しい範囲を計算
    SET start_value = current_max + 1;
    SET end_value = current_max + batch_size;
    
    -- 予約レコードを挿入または更新
    INSERT INTO sequence_reservations 
        (sequence_name, reserved_start, reserved_end, current_position, batch_size)
    VALUES 
        (seq_name, start_value, end_value, start_value, batch_size)
    ON DUPLICATE KEY UPDATE
        reserved_start = start_value,
        reserved_end = end_value,
        current_position = start_value,
        batch_size = batch_size;
END //

DELIMITER ;

-- バッチ予約の使用例
CALL reserve_sequence_batch('bulk_order_seq', 1000, @start_val, @end_val);
SELECT @start_val as start_value, @end_val as end_value;

-- 予約状況確認
SELECT * FROM sequence_reservations;
```

## 実践的な連番設計例

### 1. 学校システムの包括的連番設計

```sql
-- 学校システム用連番管理
CREATE TABLE school_sequences (
    seq_type ENUM('student', 'teacher', 'course', 'grade_report', 'attendance_sheet') PRIMARY KEY,
    prefix VARCHAR(10) NOT NULL,
    current_number BIGINT UNSIGNED NOT NULL DEFAULT 0,
    year_reset BOOLEAN DEFAULT TRUE,
    last_reset_year INT,
    format_template VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 連番設定の初期化
INSERT INTO school_sequences VALUES
('student', 'S', 0, TRUE, YEAR(CURRENT_DATE), '{PREFIX}{YEAR}{NUMBER:06d}', '学生ID生成', NOW(), NOW()),
('teacher', 'T', 0, FALSE, NULL, '{PREFIX}{NUMBER:04d}', '教師ID生成', NOW(), NOW()),
('course', 'C', 0, TRUE, YEAR(CURRENT_DATE), '{PREFIX}{YEAR}{NUMBER:03d}', '講座ID生成', NOW(), NOW()),
('grade_report', 'GR', 0, TRUE, YEAR(CURRENT_DATE), '{PREFIX}{YEAR}{MONTH:02d}{NUMBER:04d}', '成績表番号', NOW(), NOW()),
('attendance_sheet', 'AS', 0, TRUE, YEAR(CURRENT_DATE), '{PREFIX}{YEAR}{MONTH:02d}{NUMBER:04d}', '出席表番号', NOW(), NOW());

-- 学校システム用連番生成関数
DELIMITER //

CREATE FUNCTION generate_school_id(seq_type_param ENUM('student', 'teacher', 'course', 'grade_report', 'attendance_sheet'))
RETURNS VARCHAR(50)
READS SQL DATA
MODIFIES SQL DATA
DETERMINISTIC
BEGIN
    DECLARE next_number BIGINT;
    DECLARE prefix_val VARCHAR(10);
    DECLARE format_template VARCHAR(50);
    DECLARE year_reset_flag BOOLEAN;
    DECLARE last_reset_year_val INT;
    DECLARE current_year INT DEFAULT YEAR(CURRENT_DATE);
    DECLARE current_month INT DEFAULT MONTH(CURRENT_DATE);
    DECLARE result_id VARCHAR(50);
    
    -- 設定を取得
    SELECT prefix, current_number, year_reset, last_reset_year, format_template
    INTO prefix_val, next_number, year_reset_flag, last_reset_year_val, format_template
    FROM school_sequences 
    WHERE seq_type = seq_type_param
    FOR UPDATE;
    
    -- 年度リセットチェック
    IF year_reset_flag AND (last_reset_year_val IS NULL OR last_reset_year_val < current_year) THEN
        SET next_number = 1;
        UPDATE school_sequences 
        SET current_number = 1, last_reset_year = current_year
        WHERE seq_type = seq_type_param;
    ELSE
        SET next_number = next_number + 1;
        UPDATE school_sequences 
        SET current_number = next_number
        WHERE seq_type = seq_type_param;
    END IF;
    
    -- フォーマットに応じてIDを生成
    CASE format_template
        WHEN '{PREFIX}{YEAR}{NUMBER:06d}' THEN
            SET result_id = CONCAT(prefix_val, current_year, LPAD(next_number, 6, '0'));
        WHEN '{PREFIX}{NUMBER:04d}' THEN
            SET result_id = CONCAT(prefix_val, LPAD(next_number, 4, '0'));
        WHEN '{PREFIX}{YEAR}{NUMBER:03d}' THEN
            SET result_id = CONCAT(prefix_val, current_year, LPAD(next_number, 3, '0'));
        WHEN '{PREFIX}{YEAR}{MONTH:02d}{NUMBER:04d}' THEN
            SET result_id = CONCAT(prefix_val, current_year, LPAD(current_month, 2, '0'), LPAD(next_number, 4, '0'));
        ELSE
            SET result_id = CONCAT(prefix_val, next_number);
    END CASE;
    
    RETURN result_id;
END //

DELIMITER ;

-- 学校システムIDの生成テスト
SELECT 
    generate_school_id('student') as student_id,
    generate_school_id('teacher') as teacher_id,
    generate_school_id('course') as course_id,
    generate_school_id('grade_report') as grade_report_id,
    generate_school_id('attendance_sheet') as attendance_sheet_id;

-- 連番状況確認
SELECT * FROM school_sequences;
```

### 2. 複数システム間での連番共有

```sql
-- システム間連番共有テーブル
CREATE TABLE global_sequences (
    system_name VARCHAR(50),
    sequence_name VARCHAR(50),
    current_value BIGINT UNSIGNED NOT NULL DEFAULT 0,
    increment_step INT NOT NULL DEFAULT 1,
    node_offset INT NOT NULL DEFAULT 0,  -- 分散システム用オフセット
    max_value BIGINT UNSIGNED,
    
    PRIMARY KEY (system_name, sequence_name),
    INDEX idx_sequence_name (sequence_name)
);

-- 分散システム用連番設定
INSERT INTO global_sequences VALUES
('school_system', 'global_student_id', 10000, 10, 1, 999999999),   -- ノード1: 10001, 10011, 10021...
('library_system', 'global_book_id', 20000, 10, 2, 999999999),    -- ノード2: 20002, 20012, 20022...
('exam_system', 'global_exam_id', 30000, 10, 3, 999999999);       -- ノード3: 30003, 30013, 30023...

-- 分散対応連番取得関数
DELIMITER //

CREATE FUNCTION get_distributed_sequence(
    system_name_param VARCHAR(50),
    sequence_name_param VARCHAR(50)
) RETURNS BIGINT
READS SQL DATA
MODIFIES SQL DATA
DETERMINISTIC
BEGIN
    DECLARE next_val BIGINT;
    DECLARE step_val INT;
    DECLARE offset_val INT;
    DECLARE max_val BIGINT;
    
    -- 設定値を取得
    SELECT current_value + increment_step, increment_step, node_offset, max_value
    INTO next_val, step_val, offset_val, max_val
    FROM global_sequences 
    WHERE system_name = system_name_param AND sequence_name = sequence_name_param
    FOR UPDATE;
    
    -- 最大値チェック
    IF next_val > max_val THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sequence maximum value exceeded';
    END IF;
    
    -- 値を更新
    UPDATE global_sequences 
    SET current_value = next_val
    WHERE system_name = system_name_param AND sequence_name = sequence_name_param;
    
    -- オフセットを適用した値を返す
    RETURN next_val + offset_val;
END //

DELIMITER ;

-- 分散連番の使用例
SELECT 
    get_distributed_sequence('school_system', 'global_student_id') as school_student_id,
    get_distributed_sequence('library_system', 'global_book_id') as library_book_id,
    get_distributed_sequence('exam_system', 'global_exam_id') as exam_id;

-- 結果確認
SELECT * FROM global_sequences;
```

## 連番のバックアップと復旧

### 1. 連番状態のバックアップ

```sql
-- 連番バックアップテーブル
CREATE TABLE sequence_backups (
    backup_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    backup_name VARCHAR(100) NOT NULL,
    table_name VARCHAR(64) NOT NULL,
    sequence_name VARCHAR(50),
    sequence_value BIGINT NOT NULL,
    backup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    backup_type ENUM('manual', 'scheduled', 'pre_maintenance') DEFAULT 'manual',
    notes TEXT
);

-- バックアップ作成プロシージャ
DELIMITER //

CREATE PROCEDURE backup_sequences(IN backup_name_param VARCHAR(100))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tbl_name VARCHAR(64);
    DECLARE auto_inc_val BIGINT;
    
    DECLARE sequence_cursor CURSOR FOR
        SELECT TABLE_NAME, AUTO_INCREMENT
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND AUTO_INCREMENT IS NOT NULL;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN sequence_cursor;
    
    sequence_loop: LOOP
        FETCH sequence_cursor INTO tbl_name, auto_inc_val;
        IF done THEN
            LEAVE sequence_loop;
        END IF;
        
        INSERT INTO sequence_backups (backup_name, table_name, sequence_name, sequence_value, backup_type)
        VALUES (backup_name_param, tbl_name, 'AUTO_INCREMENT', auto_inc_val, 'manual');
    END LOOP;
    
    CLOSE sequence_cursor;
    
    -- カスタム連番もバックアップ
    INSERT INTO sequence_backups (backup_name, table_name, sequence_name, sequence_value, backup_type)
    SELECT backup_name_param, 'sequence_generators', sequence_name, current_value, 'manual'
    FROM sequence_generators;
    
END //

DELIMITER ;

-- バックアップ実行
CALL backup_sequences('daily_backup_20250522');

-- バックアップ確認
SELECT * FROM sequence_backups WHERE backup_name = 'daily_backup_20250522';
```

### 2. 連番の復旧

```sql
-- 復旧プロシージャ
DELIMITER //

CREATE PROCEDURE restore_sequences(IN backup_name_param VARCHAR(100))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tbl_name VARCHAR(64);
    DECLARE seq_name VARCHAR(50);
    DECLARE seq_value BIGINT;
    
    DECLARE restore_cursor CURSOR FOR
        SELECT table_name, sequence_name, sequence_value
        FROM sequence_backups
        WHERE backup_name = backup_name_param;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN restore_cursor;
    
    restore_loop: LOOP
        FETCH restore_cursor INTO tbl_name, seq_name, seq_value;
        IF done THEN
            LEAVE restore_loop;
        END IF;
        
        -- AUTO_INCREMENTの復旧
        IF seq_name = 'AUTO_INCREMENT' THEN
            SET @sql = CONCAT('ALTER TABLE ', tbl_name, ' AUTO_INCREMENT = ', seq_value);
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END IF;
        
        -- カスタム連番の復旧
        IF tbl_name = 'sequence_generators' THEN
            UPDATE sequence_generators 
            SET current_value = seq_value
            WHERE sequence_name = seq_name;
        END IF;
        
    END LOOP;
    
    CLOSE restore_cursor;
END //

DELIMITER ;

-- 復旧実行例（緊急時のみ）
-- CALL restore_sequences('daily_backup_20250522');
```

## パフォーマンスと注意点

### 1. AUTO_INCREMENTのパフォーマンス特性

```sql
-- パフォーマンステスト用テーブル
CREATE TABLE performance_test_auto (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE performance_test_manual (
    id BIGINT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AUTO_INCREMENTのパフォーマンステスト
-- 大量データ挿入の時間測定
SET @start_time = NOW(6);

INSERT INTO performance_test_auto (data)
SELECT CONCAT('test_data_', n)
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + 1 n
    FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c
) numbers
LIMIT 1000;

SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) as auto_increment_microseconds;

-- レコード数確認
SELECT COUNT(*) as record_count FROM performance_test_auto;
```

### 2. 並行処理での注意点

```sql
-- 並行処理テスト用設定
SET SESSION innodb_autoinc_lock_mode = 1;  -- 従来のロックモード

-- 同時挿入のシミュレーション用プロシージャ
DELIMITER //

CREATE PROCEDURE concurrent_insert_test()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 100 DO
        INSERT INTO performance_test_auto (data) 
        VALUES (CONCAT('concurrent_', CONNECTION_ID(), '_', i));
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

-- 同時実行テスト（複数のセッションで実行）
-- CALL concurrent_insert_test();

-- 結果の整合性確認
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT id) as unique_ids,
    MAX(id) - MIN(id) + 1 as id_range
FROM performance_test_auto;
```

### 3. 設定の最適化

```sql
-- AUTO_INCREMENTに関する設定確認
SHOW VARIABLES LIKE '%auto_increment%';

-- 主要な設定項目の説明
SELECT 
    'auto_increment_increment' as variable_name,
    'AUTO_INCREMENTの増分値' as description
UNION ALL
SELECT 'auto_increment_offset', 'AUTO_INCREMENTの開始オフセット'
UNION ALL
SELECT 'innodb_autoinc_lock_mode', 'AUTO_INCREMENTロックモード（0:従来, 1:連続, 2:インターリーブ）';

-- 現在の設定値
SELECT 
    @@auto_increment_increment as increment_value,
    @@auto_increment_offset as offset_value,
    @@innodb_autoinc_lock_mode as lock_mode;
```

## 練習問題

### 問題36-1：基本的なAUTO_INCREMENT
以下の要件を満たすテーブル`products`を作成してください：
- 商品ID：`product_id`（AUTO_INCREMENT、主キー、1000から開始）
- 商品名：`product_name`（必須）
- 価格：`price`（小数点2桁）
- 作成日時：`created_at`（現在日時がデフォルト）
テーブル作成後、3件のテストデータを挿入し、AUTO_INCREMENT値を確認してください。

### 問題36-2：カスタム連番システム
以下の機能を持つカスタム連番システムを実装してください：
1. 連番管理テーブル`custom_sequences`を作成
2. 連番取得関数`get_sequence(sequence_name)`を作成
3. 以下の連番を定義：
   - 'order_seq'：100000から開始、増分1
   - 'invoice_seq'：2025001から開始、増分1
4. 各連番を5回取得して動作確認

### 問題36-3：年度別連番
年度が変わると1から始まる年度別連番システムを実装してください：
1. 年度別連番管理テーブルを作成
2. 年度別連番取得関数を作成
3. 学籍番号形式「S{年度}{連番6桁}」で生成
4. 2024年度と2025年度で各3件ずつ生成してテスト

### 問題36-4：複合連番システム
以下の仕様で請求書番号生成システムを作成してください：
- 形式：「INV-{年}{月}{連番4桁}」（例：INV-20250501）
- 月が変わると連番は1からリセット
- 月別連番管理テーブルとプロシージャを実装
- 2025年5月と6月で各5件ずつ生成してテスト

### 問題36-5：欠番検出システム
以下の機能を実装してください：
1. テスト用テーブルを作成してAUTO_INCREMENTデータを10件挿入
2. ランダムに3件のレコードを削除して欠番を作成
3. 欠番を検出するクエリを作成
4. 欠番の範囲（開始番号、終了番号）を表示
5. 全体の欠番数を計算

### 問題36-6：高負荷対応連番システム
並行処理に対応した安全な連番システムを実装してください：
1. ロック機能付き連番テーブル`safe_sequences`を作成
2. 排他制御を行う連番取得プロシージャを実装
3. バッチ処理用の連番予約機能を実装
4. 競合状態をテストするプロシージャを作成
5. 同時実行時の整合性を確認

## 解答

### 解答36-1
```sql
-- productsテーブル作成
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) AUTO_INCREMENT = 1000;

-- テストデータ挿入
INSERT INTO products (product_name, price) VALUES 
('ノートパソコン', 89800.00),
('マウス', 2980.00),
('キーボード', 5980.00);

-- 結果確認
SELECT * FROM products;

-- AUTO_INCREMENT値確認
SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products';

SHOW TABLE STATUS LIKE 'products';
```

### 解答36-2
```sql
-- 1. 連番管理テーブル作成
CREATE TABLE custom_sequences (
    sequence_name VARCHAR(50) PRIMARY KEY,
    current_value BIGINT UNSIGNED NOT NULL DEFAULT 0,
    increment_by INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. 連番取得関数作成
DELIMITER //
CREATE FUNCTION get_sequence(seq_name VARCHAR(50)) 
RETURNS BIGINT
READS SQL DATA
MODIFIES SQL DATA
DETERMINISTIC
BEGIN
    DECLARE next_val BIGINT;
    
    UPDATE custom_sequences 
    SET current_value = current_value + increment_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE sequence_name = seq_name;
    
    SELECT current_value INTO next_val
    FROM custom_sequences 
    WHERE sequence_name = seq_name;
    
    RETURN next_val;
END //
DELIMITER ;

-- 3. 連番定義
INSERT INTO custom_sequences (sequence_name, current_value) VALUES
('order_seq', 99999),    -- 次回取得時に100000
('invoice_seq', 2025000); -- 次回取得時に2025001

-- 4. 動作確認
SELECT get_sequence('order_seq') as order_number;
SELECT get_sequence('order_seq') as order_number;
SELECT get_sequence('order_seq') as order_number;
SELECT get_sequence('order_seq') as order_number;
SELECT get_sequence('order_seq') as order_number;

SELECT get_sequence('invoice_seq') as invoice_number;
SELECT get_sequence('invoice_seq') as invoice_number;
SELECT get_sequence('invoice_seq') as invoice_number;
SELECT get_sequence('invoice_seq') as invoice_number;
SELECT get_sequence('invoice_seq') as invoice_number;

-- 連番状況確認
SELECT * FROM custom_sequences;
```

### 解答36-3
```sql
-- 1. 年度別連番管理テーブル
CREATE TABLE yearly_student_sequences (
    academic_year INT PRIMARY KEY,
    current_number INT UNSIGNED DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. 年度別連番取得関数
DELIMITER //
CREATE FUNCTION get_student_number(year_val INT) 
RETURNS VARCHAR(20)
READS SQL DATA
MODIFIES SQL DATA
DETERMINISTIC
BEGIN
    DECLARE next_num INT;
    DECLARE student_number VARCHAR(20);
    
    -- 年度レコードが存在しない場合は作成
    INSERT IGNORE INTO yearly_student_sequences (academic_year, current_number)
    VALUES (year_val, 0);
    
    -- 連番を更新して取得
    UPDATE yearly_student_sequences 
    SET current_number = current_number + 1,
        updated_at = CURRENT_TIMESTAMP
    WHERE academic_year = year_val;
    
    SELECT current_number INTO next_num
    FROM yearly_student_sequences 
    WHERE academic_year = year_val;
    
    -- 学籍番号形式で返す
    SET student_number = CONCAT('S', year_val, LPAD(next_num, 6, '0'));
    
    RETURN student_number;
END //
DELIMITER ;

-- 3. テスト実行
-- 2024年度
SELECT get_student_number(2024) as student_number_2024;
SELECT get_student_number(2024) as student_number_2024;
SELECT get_student_number(2024) as student_number_2024;

-- 2025年度
SELECT get_student_number(2025) as student_number_2025;
SELECT get_student_number(2025) as student_number_2025;
SELECT get_student_number(2025) as student_number_2025;

-- 結果確認
SELECT * FROM yearly_student_sequences;
```

### 解答36-4
```sql
-- 1. 月別連番管理テーブル
CREATE TABLE monthly_invoice_sequences (
    year_month CHAR(6) PRIMARY KEY,  -- YYYYMM形式
    current_number INT UNSIGNED DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. 請求書番号生成プロシージャ
DELIMITER //
CREATE PROCEDURE generate_invoice_number(OUT invoice_number VARCHAR(20))
BEGIN
    DECLARE year_month_str CHAR(6);
    DECLARE next_num INT;
    
    SET year_month_str = DATE_FORMAT(CURRENT_DATE, '%Y%m');
    
    -- 月別レコードが存在しない場合は作成
    INSERT IGNORE INTO monthly_invoice_sequences (year_month, current_number)
    VALUES (year_month_str, 0);
    
    -- 連番を更新して取得
    UPDATE monthly_invoice_sequences 
    SET current_number = current_number + 1,
        updated_at = CURRENT_TIMESTAMP
    WHERE year_month = year_month_str;
    
    SELECT current_number INTO next_num
    FROM monthly_invoice_sequences 
    WHERE year_month = year_month_str;
    
    -- 請求書番号形式で生成
    SET invoice_number = CONCAT('INV-', year_month_str, LPAD(next_num, 4, '0'));
END //
DELIMITER ;

-- 3. テスト実行
-- 2025年5月のテスト
CALL generate_invoice_number(@inv1); SELECT @inv1 as invoice_may_1;
CALL generate_invoice_number(@inv2); SELECT @inv2 as invoice_may_2;
CALL generate_invoice_number(@inv3); SELECT @inv3 as invoice_may_3;
CALL generate_invoice_number(@inv4); SELECT @inv4 as invoice_may_4;
CALL generate_invoice_number(@inv5); SELECT @inv5 as invoice_may_5;

-- 手動で6月分をテスト（実際の月が変わった時のシミュレーション）
INSERT IGNORE INTO monthly_invoice_sequences (year_month, current_number) VALUES ('202506', 0);
UPDATE monthly_invoice_sequences SET current_number = 1 WHERE year_month = '202506';
SELECT CONCAT('INV-', '202506', LPAD(1, 4, '0')) as invoice_june_1;
UPDATE monthly_invoice_sequences SET current_number = 2 WHERE year_month = '202506';
SELECT CONCAT('INV-', '202506', LPAD(2, 4, '0')) as invoice_june_2;

-- 結果確認
SELECT * FROM monthly_invoice_sequences;
```

### 解答36-5
```sql
-- 1. テスト用テーブル作成とデータ挿入
CREATE TABLE gap_detection_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO gap_detection_test (data) VALUES 
('データ1'), ('データ2'), ('データ3'), ('データ4'), ('データ5'),
('データ6'), ('データ7'), ('データ8'), ('データ9'), ('データ10');

-- 2. ランダムに3件削除（例：2, 5, 8を削除）
DELETE FROM gap_detection_test WHERE id IN (2, 5, 8);

-- 削除後の状態確認
SELECT * FROM gap_detection_test ORDER BY id;

-- 3. 欠番検出クエリ
-- 連続する欠番の範囲を検出
SELECT 
    gap_start,
    CASE 
        WHEN gap_end IS NULL THEN gap_start
        ELSE gap_end
    END as gap_end,
    CASE 
        WHEN gap_end IS NULL THEN 1
        ELSE gap_end - gap_start + 1
    END as gap_count
FROM (
    SELECT 
        id + 1 as gap_start,
        (SELECT MIN(id) - 1 FROM gap_detection_test g2 WHERE g2.id > g1.id) as gap_end
    FROM gap_detection_test g1
    WHERE NOT EXISTS (SELECT 1 FROM gap_detection_test g2 WHERE g2.id = g1.id + 1)
    AND id < (SELECT MAX(id) FROM gap_detection_test)
) gaps;

-- 4. 個別の欠番リスト
SELECT missing_id
FROM (
    SELECT MIN(id) + (n.n - 1) as missing_id
    FROM gap_detection_test
    CROSS JOIN (
        SELECT 1 as n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
        UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
    ) n
    WHERE MIN(id) + (n.n - 1) <= (SELECT MAX(id) FROM gap_detection_test)
) all_possible
WHERE missing_id NOT IN (SELECT id FROM gap_detection_test)
ORDER BY missing_id;

-- 5. 全体の欠番数計算
SELECT 
    (SELECT MAX(id) FROM gap_detection_test) - (SELECT MIN(id) FROM gap_detection_test) + 1 as expected_count,
    COUNT(*) as actual_count,
    (SELECT MAX(id) FROM gap_detection_test) - (SELECT MIN(id) FROM gap_detection_test) + 1 - COUNT(*) as gap_count
FROM gap_detection_test;
```

### 解答36-6
```sql
-- 1. ロック機能付き連番テーブル
CREATE TABLE safe_sequences (
    sequence_name VARCHAR(50) PRIMARY KEY,
    current_value BIGINT UNSIGNED NOT NULL DEFAULT 0,
    batch_size INT DEFAULT 1,
    reserved_start BIGINT UNSIGNED DEFAULT 0,
    reserved_end BIGINT UNSIGNED DEFAULT 0,
    lock_holder VARCHAR(100),
    locked_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. 排他制御付き連番取得プロシージャ
DELIMITER //
CREATE PROCEDURE get_safe_sequence_value(
    IN seq_name VARCHAR(50),
    OUT next_value BIGINT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 排他ロックで連番を取得・更新
    SELECT current_value + 1 INTO next_value
    FROM safe_sequences 
    WHERE sequence_name = seq_name
    FOR UPDATE;
    
    UPDATE safe_sequences 
    SET current_value = next_value,
        updated_at = CURRENT_TIMESTAMP
    WHERE sequence_name = seq_name;
    
    COMMIT;
END //

-- 3. バッチ処理用連番予約プロシージャ
CREATE PROCEDURE reserve_sequence_batch_safe(
    IN seq_name VARCHAR(50),
    IN batch_size_param INT,
    OUT start_value BIGINT,
    OUT end_value BIGINT
)
BEGIN
    DECLARE current_val BIGINT;
    
    START TRANSACTION;
    
    SELECT current_value INTO current_val
    FROM safe_sequences 
    WHERE sequence_name = seq_name
    FOR UPDATE;
    
    SET start_value = current_val + 1;
    SET end_value = current_val + batch_size_param;
    
    UPDATE safe_sequences 
    SET current_value = end_value,
        reserved_start = start_value,
        reserved_end = end_value,
        batch_size = batch_size_param,
        updated_at = CURRENT_TIMESTAMP
    WHERE sequence_name = seq_name;
    
    COMMIT;
END //

-- 4. 競合状態テストプロシージャ
CREATE PROCEDURE concurrent_sequence_test(IN seq_name VARCHAR(50))
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE result BIGINT;
    
    WHILE i <= 10 DO
        CALL get_safe_sequence_value(seq_name, result);
        INSERT INTO sequence_test_log VALUES (CONNECTION_ID(), result, NOW());
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- テスト用ログテーブル
CREATE TABLE sequence_test_log (
    connection_id BIGINT,
    sequence_value BIGINT,
    generated_at TIMESTAMP
);

-- 初期設定
INSERT INTO safe_sequences (sequence_name, current_value) VALUES 
('test_seq', 0),
('batch_test_seq', 0);

-- 5. 整合性確認テスト
-- 単一アクセステスト
CALL get_safe_sequence_value('test_seq', @val1); SELECT @val1;
CALL get_safe_sequence_value('test_seq', @val2); SELECT @val2;
CALL get_safe_sequence_value('test_seq', @val3); SELECT @val3;

-- バッチ予約テスト
CALL reserve_sequence_batch_safe('batch_test_seq', 100, @start, @end);
SELECT @start as batch_start, @end as batch_end;

-- 競合テスト用（複数セッションで同時実行）
-- CALL concurrent_sequence_test('test_seq');

-- 結果確認
SELECT * FROM safe_sequences;
SELECT * FROM sequence_test_log ORDER BY generated_at;

-- 整合性チェック
SELECT 
    COUNT(*) as total_generated,
    COUNT(DISTINCT sequence_value) as unique_values,
    MIN(sequence_value) as min_val,
    MAX(sequence_value) as max_val
FROM sequence_test_log;
```

## まとめ

この章では、シーケンス/AUTO_INCREMENTによる連番生成について詳しく学びました：

1. **AUTO_INCREMENTの基本**：
   - MySQLでの自動連番生成機能
   - 基本的な使用方法と特性
   - データ型別の設定方法

2. **詳細設定と管理**：
   - 開始値のカスタマイズ
   - AUTO_INCREMENT値の調整
   - 欠番の検出と対処

3. **カスタム連番システム**：
   - 手動連番管理テーブルの設計
   - 連番取得関数の実装
   - 複雑な連番ルールの実現

4. **期間別連番管理**：
   - 年度別連番システム
   - 月別連番システム
   - 自動リセット機能

5. **高負荷環境への対応**：
   - 競合状態の回避
   - 排他制御の実装
   - バッチ処理最適化

6. **実践的な設計例**：
   - 学校システムでの包括的連番設計
   - 分散システム対応
   - 複数システム間での連番共有

7. **バックアップと復旧**：
   - 連番状態の保存
   - 緊急時の復旧手順
   - 整合性の確認

8. **パフォーマンス考慮点**：
   - 並行処理での注意点
   - 設定の最適化
   - ロックモードの理解

AUTO_INCREMENTは簡単に使用できる一方で、高負荷環境や複雑な要件では慎重な設計が必要です。適切に実装することで、信頼性の高い一意識別子システムを構築できます。

次の章では、「マテリアライズドビュー：結果を保存するビュー」について学び、パフォーマンス向上のための高度なビュー技術を理解していきます。