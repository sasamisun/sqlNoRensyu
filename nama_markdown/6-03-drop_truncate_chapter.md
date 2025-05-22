# 34. テーブルの削除とクリア：DROP TABLE文とTRUNCATE文

## はじめに

前章では、ALTER TABLE文を使用してテーブル構造を変更する方法を学びました。この章では、テーブルそのものを削除したり、テーブル内のデータをすべて削除したりするための「DROP TABLE文」と「TRUNCATE文」について学習します。

これらの操作は、データベース管理において非常に強力で便利ですが、**一度実行すると元に戻すことができない**危険な操作でもあります。誤って実行するとデータの完全な損失につながるため、特に慎重な扱いが必要です。

DROP TABLE文とTRUNCATE文が必要となる場面の例：
- 「テスト用に作成したテーブルが不要になったので削除したい」
- 「システム移行が完了したので、古いテーブルを削除したい」
- 「一時的な集計テーブルを毎回初期化して使いたい」
- 「大量のログデータを一括削除して容量を確保したい」
- 「開発環境のテーブルをクリアして新しいテストデータを投入したい」
- 「不要になった中間テーブルを削除してデータベースを整理したい」
- 「AUTO_INCREMENTの値をリセットしたい」

この章では、これらの操作の基本構文から、安全な実行方法、注意点まで詳しく学んでいきます。

## DROP TABLE文とTRUNCATE文とは

### DROP TABLE文
DROP TABLE文は、テーブル全体（構造とデータの両方）をデータベースから完全に削除するSQL文です。実行後、そのテーブルは存在しなくなります。

### TRUNCATE文
TRUNCATE文は、テーブルの構造は残したまま、テーブル内のすべてのデータを高速に削除するSQL文です。テーブル自体は残るため、再度データを挿入することができます。

> **用語解説**：
> - **DROP TABLE文**：テーブルの構造とデータを完全に削除するDDL文です。
> - **TRUNCATE文**：テーブル構造を残してデータのみを高速削除するDDL文です。
> - **カスケード削除**：外部キー制約で関連付けられたテーブルも連鎖的に削除することです。
> - **フルテーブルスキャン**：テーブル全体を順次読み取る処理です。
> - **ページ削除**：データベースの内部構造単位でデータを削除する高速な方法です。
> - **AUTO_INCREMENT リセット**：自動増加カウンタを初期値に戻すことです。
> - **外部キー制約**：他のテーブルとの関連性を保証する制約で、削除操作に影響します。
> - **参照整合性**：関連するテーブル間でデータの整合性が保たれている状態です。
> - **ロールバック**：トランザクションを取り消してデータを元の状態に戻すことです。
> - **DDLロック**：DDL操作中にテーブルがロックされることです。

## 基本構文

### DROP TABLE文の構文

```sql
-- 基本構文
DROP TABLE テーブル名;

-- 複数テーブルの同時削除
DROP TABLE テーブル名1, テーブル名2, テーブル名3;

-- 存在しない場合でもエラーにしない
DROP TABLE IF EXISTS テーブル名;

-- 外部キー制約を無視して削除（注意が必要）
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE テーブル名;
SET FOREIGN_KEY_CHECKS = 1;
```

### TRUNCATE文の構文

```sql
-- 基本構文
TRUNCATE TABLE テーブル名;

-- またはTABLEキーワードを省略
TRUNCATE テーブル名;
```

## DROP TABLE文の詳細

### 1. 基本的なテーブル削除

```sql
-- テスト用テーブルの作成
CREATE TABLE test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- データの挿入
INSERT INTO test_table (name) VALUES ('テストデータ1'), ('テストデータ2');

-- テーブルの確認
SELECT * FROM test_table;

-- テーブルの削除
DROP TABLE test_table;

-- 削除確認（エラーになる）
-- SELECT * FROM test_table;  -- エラー: Table 'test_table' doesn't exist
```

### 2. 複数テーブルの同時削除

```sql
-- 複数のテスト用テーブルを作成
CREATE TABLE temp_table1 (id INT, data VARCHAR(50));
CREATE TABLE temp_table2 (id INT, data VARCHAR(50));
CREATE TABLE temp_table3 (id INT, data VARCHAR(50));

-- テーブル一覧で確認
SHOW TABLES LIKE 'temp_%';

-- 複数テーブルを同時削除
DROP TABLE temp_table1, temp_table2, temp_table3;

-- 削除確認
SHOW TABLES LIKE 'temp_%';
```

### 3. IF EXISTS句の使用

```sql
-- 存在しないテーブルを削除しようとした場合（エラー）
-- DROP TABLE non_existent_table;  -- エラー: Unknown table 'non_existent_table'

-- IF EXISTS句を使用した安全な削除
DROP TABLE IF EXISTS non_existent_table;  -- エラーにならない

-- 複数のテーブルに対するIF EXISTS
DROP TABLE IF EXISTS old_table1, old_table2, old_table3;
```

## TRUNCATE文の詳細

### 1. 基本的なデータクリア

```sql
-- テスト用データの準備
CREATE TABLE truncate_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    value INT
);

INSERT INTO truncate_test (name, value) VALUES 
('データ1', 100),
('データ2', 200),
('データ3', 300);

-- データの確認
SELECT * FROM truncate_test;

-- テーブル構造の確認
DESCRIBE truncate_test;

-- TRUNCATEでデータをクリア
TRUNCATE TABLE truncate_test;

-- データがクリアされたことを確認
SELECT * FROM truncate_test;

-- テーブル構造は残っていることを確認
DESCRIBE truncate_test;
```

### 2. AUTO_INCREMENTのリセット

```sql
-- データを再挿入
INSERT INTO truncate_test (name, value) VALUES ('新データ1', 1000);

-- IDが1から開始されることを確認
SELECT * FROM truncate_test;

-- AUTO_INCREMENT値の確認
SHOW TABLE STATUS LIKE 'truncate_test';
```

## DELETE文、TRUNCATE文、DROP TABLE文の比較

### 比較表

| 項目 | DELETE | TRUNCATE | DROP TABLE |
|------|--------|----------|------------|
| **対象** | データのみ | データのみ | 構造とデータ |
| **実行速度** | 遅い（行単位） | 高速（ページ単位） | 高速 |
| **WHERE句** | 使用可能 | 使用不可 | 使用不可 |
| **ロールバック** | 可能 | 不可（DDL） | 不可（DDL） |
| **AUTO_INCREMENT** | リセットされない | リセットされる | N/A |
| **トリガー** | 実行される | 実行されない | 実行されない |
| **外部キー制約** | チェックされる | 制約があると実行不可 | CASCADE必要 |
| **ログ記録** | 詳細ログ | 最小限ログ | 最小限ログ |

### 実例による比較

```sql
-- 比較用テーブルの作成
CREATE TABLE comparison_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO comparison_test (name) VALUES 
('データ1'), ('データ2'), ('データ3'), ('データ4'), ('データ5');

-- 現在の状態確認
SELECT * FROM comparison_test;
SHOW TABLE STATUS LIKE 'comparison_test';

-- 1. DELETE文での削除（条件付き）
DELETE FROM comparison_test WHERE id <= 3;
SELECT * FROM comparison_test;  -- id=4,5が残る

-- 新しいデータ挿入
INSERT INTO comparison_test (name) VALUES ('新データ1');
SELECT * FROM comparison_test;  -- AUTO_INCREMENTは6から開始

-- すべてのデータを削除
DELETE FROM comparison_test;
SELECT * FROM comparison_test;  -- データなし

-- 新しいデータ挿入
INSERT INTO comparison_test (name) VALUES ('削除後データ');
SELECT * FROM comparison_test;  -- AUTO_INCREMENTは7から開始

-- TRUNCATEでのクリア
TRUNCATE TABLE comparison_test;
INSERT INTO comparison_test (name) VALUES ('TRUNCATE後データ');
SELECT * FROM comparison_test;  -- AUTO_INCREMENTは1から開始
```

## 外部キー制約がある場合の処理

### 1. 外部キー制約の確認

```sql
-- 現在の外部キー制約を確認
SELECT 
    constraint_name,
    table_name,
    referenced_table_name,
    delete_rule
FROM information_schema.referential_constraints 
WHERE constraint_schema = DATABASE();
```

### 2. 外部キー制約による削除エラー

```sql
-- 参照されているテーブルの削除を試行（エラーになる例）
-- DROP TABLE students;  -- エラー: Cannot delete or update a parent row

-- 子テーブル（参照する側）から先に削除
-- DROP TABLE grades;     -- 成功
-- DROP TABLE students;   -- その後で親テーブルを削除可能
```

### 3. CASCADE削除の活用

```sql
-- CASCADE削除設定のテーブル作成例
CREATE TABLE parent_table (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE child_table (
    id INT PRIMARY KEY,
    parent_id INT,
    data VARCHAR(100),
    FOREIGN KEY (parent_id) REFERENCES parent_table(id) ON DELETE CASCADE
);

-- データ挿入
INSERT INTO parent_table VALUES (1, '親データ1'), (2, '親データ2');
INSERT INTO child_table VALUES (1, 1, '子データ1'), (2, 1, '子データ2'), (3, 2, '子データ3');

-- 親テーブルの特定行を削除（CASCADE削除）
DELETE FROM parent_table WHERE id = 1;

-- 関連する子データも自動削除されることを確認
SELECT * FROM child_table;
```

### 4. 外部キー制約を一時的に無効化

```sql
-- 注意：本番環境では慎重に使用すること

-- 外部キー制約の無効化
SET FOREIGN_KEY_CHECKS = 0;

-- テーブル削除（通常はエラーになるものも削除可能）
DROP TABLE IF EXISTS parent_table;
DROP TABLE IF EXISTS child_table;

-- 外部キー制約の再有効化
SET FOREIGN_KEY_CHECKS = 1;
```

## 実践的な削除例

### 例1：ログテーブルの定期クリア

```sql
-- ログテーブルの作成
CREATE TABLE access_logs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    action VARCHAR(100),
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_created_at (created_at),
    INDEX idx_user_id (user_id)
);

-- サンプルデータの挿入
INSERT INTO access_logs (user_id, action, ip_address) VALUES
(101, 'login', '192.168.1.1'),
(102, 'view_page', '192.168.1.2'),
(103, 'logout', '192.168.1.3');

-- 定期的なログクリア（月次）
-- 古いログデータの確認
SELECT COUNT(*) as old_logs
FROM access_logs 
WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 MONTH);

-- 古いデータの削除（DELETE使用 - 条件付き削除）
DELETE FROM access_logs 
WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 MONTH);

-- または、全ログのクリア（TRUNCATE使用 - 高速）
-- TRUNCATE TABLE access_logs;
```

### 例2：テスト環境のデータリセット

```sql
-- テスト環境での安全なデータリセット手順

-- Step 1: 現在のデータ量を確認
SELECT 
    'students' as table_name, COUNT(*) as record_count FROM students
UNION ALL
SELECT 'grades', COUNT(*) FROM grades
UNION ALL
SELECT 'attendance', COUNT(*) FROM attendance
UNION ALL
SELECT 'student_courses', COUNT(*) FROM student_courses;

-- Step 2: 外部キー制約順に考慮してTRUNCATE
-- 子テーブルから先にクリア
TRUNCATE TABLE attendance;
TRUNCATE TABLE grades;
TRUNCATE TABLE student_courses;

-- Step 3: 親テーブルのクリア
TRUNCATE TABLE course_schedule;
-- students と courses は他のテーブルから参照されているので最後

-- Step 4: 結果確認
SELECT 
    'students' as table_name, COUNT(*) as record_count FROM students
UNION ALL
SELECT 'grades', COUNT(*) FROM grades
UNION ALL
SELECT 'attendance', COUNT(*) FROM attendance
UNION ALL
SELECT 'student_courses', COUNT(*) FROM student_courses;
```

### 例3：一時テーブルの管理

```sql
-- 処理用一時テーブルの作成
CREATE TEMPORARY TABLE temp_calculation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT,
    total_score DECIMAL(8,2),
    average_score DECIMAL(5,2)
);

-- 計算処理
INSERT INTO temp_calculation (student_id, total_score, average_score)
SELECT 
    student_id,
    SUM(score) as total_score,
    AVG(score) as average_score
FROM grades
GROUP BY student_id;

-- 結果確認
SELECT * FROM temp_calculation LIMIT 5;

-- 処理完了後のクリーンアップ
DROP TEMPORARY TABLE temp_calculation;
```

## 安全な削除手順

### 1. 削除前のチェックリスト

```sql
-- チェック1: テーブルの依存関係確認
SELECT 
    table_name,
    referenced_table_name,
    constraint_name
FROM information_schema.referential_constraints 
WHERE constraint_schema = DATABASE()
AND (table_name = 'target_table' OR referenced_table_name = 'target_table');

-- チェック2: データ量の確認
SELECT 
    COUNT(*) as record_count,
    MAX(created_at) as latest_record,
    MIN(created_at) as oldest_record
FROM target_table;

-- チェック3: 使用中のトランザクション確認
SHOW PROCESSLIST;
```

### 2. バックアップ作成

```sql
-- 重要なテーブルの削除前バックアップ
CREATE TABLE students_backup_20231201 AS SELECT * FROM students;

-- バックアップの確認
SELECT COUNT(*) FROM students_backup_20231201;

-- テーブル削除の実行
DROP TABLE students;

-- 必要に応じて復元
-- CREATE TABLE students AS SELECT * FROM students_backup_20231201;
```

### 3. 段階的な削除

```sql
-- 大量データの段階的削除

-- Step 1: 削除対象の確認
SELECT COUNT(*) as target_count
FROM large_table 
WHERE created_at < '2023-01-01';

-- Step 2: 小さなバッチで削除
DELETE FROM large_table 
WHERE created_at < '2023-01-01' 
LIMIT 1000;

-- Step 3: 進捗確認
SELECT COUNT(*) as remaining_count
FROM large_table 
WHERE created_at < '2023-01-01';

-- Step 4: 必要に応じて繰り返し

-- Step 5: 最終的にTRUNCATEで高速クリア（全削除の場合）
-- TRUNCATE TABLE large_table;
```

## エラーと対処法

### 1. 外部キー制約エラー

```sql
-- エラー例
-- DROP TABLE courses;
-- エラー: Cannot delete or update a parent row: a foreign key constraint fails

-- 対処法1: 依存関係を確認
SELECT 
    table_name,
    constraint_name,
    referenced_table_name
FROM information_schema.referential_constraints 
WHERE referenced_table_name = 'courses';

-- 対処法2: 子テーブルから順に削除
DROP TABLE grades;
DROP TABLE student_courses;
DROP TABLE course_schedule;
DROP TABLE courses;

-- 対処法3: 外部キー制約の一時無効化（慎重に）
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE courses;
SET FOREIGN_KEY_CHECKS = 1;
```

### 2. TRUNCATE制約エラー

```sql
-- エラー例
-- TRUNCATE TABLE students;
-- エラー: Cannot truncate a table referenced in a foreign key constraint

-- 対処法1: 外部キー制約を一時的に削除
ALTER TABLE grades DROP FOREIGN KEY fk_grades_student;
TRUNCATE TABLE students;
ALTER TABLE grades ADD CONSTRAINT fk_grades_student 
FOREIGN KEY (student_id) REFERENCES students(student_id);

-- 対処法2: DELETEを使用
DELETE FROM students;
-- 注意: AUTO_INCREMENTはリセットされない

-- 対処法3: 外部キー制約の一時無効化
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE students;
SET FOREIGN_KEY_CHECKS = 1;
```

### 3. 権限エラー

```sql
-- エラー例
-- DROP TABLE some_table;
-- エラー: Access denied; you need the DROP privilege for this operation

-- 対処法: 管理者に権限確認を依頼
SHOW GRANTS FOR CURRENT_USER();

-- 必要な権限の確認
-- DROP権限、ALTER権限などが必要
```

## パフォーマンスと容量の考慮

### 1. 削除操作のパフォーマンス比較

```sql
-- 大量データでのパフォーマンステスト用テーブル作成
CREATE TABLE performance_test (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 大量データ挿入（時間測定）
INSERT INTO performance_test (data)
SELECT CONCAT('test_data_', n)
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 n
    FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
) numbers
LIMIT 10000;

-- データ量確認
SELECT COUNT(*) as total_records FROM performance_test;

-- DELETE文での削除（時間測定）
-- SET @start_time = NOW(6);
-- DELETE FROM performance_test;
-- SET @end_time = NOW(6);
-- SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) as delete_microseconds;

-- TRUNCATE文での削除（時間測定）
SET @start_time = NOW(6);
TRUNCATE TABLE performance_test;
SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) as truncate_microseconds;
```

### 2. 容量回復の確認

```sql
-- テーブルサイズの確認
SELECT 
    table_name,
    table_rows,
    data_length / 1024 / 1024 as data_mb,
    index_length / 1024 / 1024 as index_mb,
    (data_length + index_length) / 1024 / 1024 as total_mb
FROM information_schema.tables 
WHERE table_schema = DATABASE() 
AND table_name = 'performance_test';

-- TRUNCATE後の容量確認
TRUNCATE TABLE performance_test;

-- 再度サイズ確認
SELECT 
    table_name,
    table_rows,
    data_length / 1024 / 1024 as data_mb,
    index_length / 1024 / 1024 as index_mb,
    (data_length + index_length) / 1024 / 1024 as total_mb
FROM information_schema.tables 
WHERE table_schema = DATABASE() 
AND table_name = 'performance_test';
```

## ベストプラクティス

### 1. 削除操作の標準手順

```sql
-- 標準的な削除手順テンプレート

-- Phase 1: 事前確認
-- 1.1 依存関係の確認
SELECT table_name, referenced_table_name
FROM information_schema.referential_constraints 
WHERE constraint_schema = DATABASE();

-- 1.2 データ量の確認
SELECT COUNT(*) as record_count FROM target_table;

-- 1.3 最終アクセス時刻の確認
SELECT MAX(updated_at) as last_update FROM target_table;

-- Phase 2: バックアップ作成（重要なデータの場合）
CREATE TABLE target_table_backup AS SELECT * FROM target_table;

-- Phase 3: 削除実行
TRUNCATE TABLE target_table;
-- または
-- DROP TABLE target_table;

-- Phase 4: 確認
-- データベース一覧やレコード数で確認

-- Phase 5: クリーンアップ（問題なければバックアップ削除）
-- DROP TABLE target_table_backup;
```

### 2. 自動化スクリプトの例

```sql
-- ログテーブル自動クリーンアップのプロシージャ例
DELIMITER //

CREATE PROCEDURE CleanupOldLogs(IN retention_days INT)
BEGIN
    DECLARE record_count INT;
    
    -- 削除対象レコード数の確認
    SELECT COUNT(*) INTO record_count
    FROM access_logs 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL retention_days DAY);
    
    -- ログ出力
    INSERT INTO cleanup_log (table_name, deleted_count, cleanup_date)
    VALUES ('access_logs', record_count, NOW());
    
    -- 実際の削除
    DELETE FROM access_logs 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL retention_days DAY);
    
END //

DELIMITER ;

-- 使用例: 30日より古いログを削除
-- CALL CleanupOldLogs(30);
```

### 3. 環境別の削除戦略

```sql
-- 開発環境：積極的なクリーンアップ
-- 毎日リセット
-- TRUNCATE TABLE session_data;
-- TRUNCATE TABLE temp_calculations;

-- ステージング環境：定期的なクリーンアップ
-- 週次でテストデータリセット
-- TRUNCATE TABLE test_results;

-- 本番環境：慎重な削除
-- 長期保存後の削除、必ずバックアップ作成
-- CREATE TABLE old_logs_backup AS SELECT * FROM logs WHERE created_at < '2023-01-01';
-- DELETE FROM logs WHERE created_at < '2023-01-01';
```

## 練習問題

### 問題34-1：基本的なテーブル削除
以下の手順を実行してください：
1. `practice_table1`という名前のテーブルを作成（id: INT PRIMARY KEY、name: VARCHAR(50)）
2. テストデータを3件挿入
3. `DROP TABLE`文でテーブルを削除
4. 削除されたことを確認

### 問題34-2：TRUNCATE文の使用
以下の手順を実行してください：
1. `practice_table2`という名前のテーブルを作成（id: INT AUTO_INCREMENT PRIMARY KEY、data: VARCHAR(100)、created_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP）
2. テストデータを5件挿入し、最大のidを確認
3. `TRUNCATE`文でデータをクリア
4. 新しいデータを1件挿入し、idが1から開始されることを確認

### 問題34-3：DELETE、TRUNCATE、DROPの比較
以下の比較実験を行ってください：
1. 同じ構造のテーブルを3つ作成（`delete_test`、`truncate_test`、`drop_test`）
2. 各テーブルに同じテストデータを挿入
3. それぞれ`DELETE`、`TRUNCATE`、`DROP TABLE`で処理
4. 実行後の状態を比較し、違いをまとめる

### 問題34-4：外部キー制約がある場合の削除
以下の手順で外部キー制約を考慮した削除を実行してください：
1. 親テーブル`departments`（dept_id: INT PRIMARY KEY、dept_name: VARCHAR(100)）を作成
2. 子テーブル`employees`（emp_id: INT PRIMARY KEY、name: VARCHAR(100)、dept_id: INT、外部キー制約あり）を作成
3. 両テーブルにテストデータを挿入
4. 正しい順序でテーブルを削除
5. 外部キー制約があるときに親テーブルを先に削除しようとするとどうなるか確認

### 問題34-5：大量データの効率的削除
以下の大量データ削除シナリオを実装してください：
1. `large_data_table`を作成（id: BIGINT AUTO_INCREMENT PRIMARY KEY、content: TEXT、created_at: TIMESTAMP）
2. 1000件以上のテストデータを挿入
3. `DELETE`文と`TRUNCATE`文の実行時間を比較
4. 各方法のメリット・デメリットを考察

### 問題34-6：安全な削除手順の実装
以下の安全な削除手順を実装してください：
1. 重要なデータが入った`important_table`を作成
2. バックアップテーブルを作成する手順
3. 元テーブルを削除する手順
4. 必要に応じて復元する手順
5. 最終的にバックアップテーブルも削除する手順
すべてをSQL文で実装し、各ステップで適切な確認を行ってください。

## 解答

### 解答34-1
```sql
-- 1. テーブル作成
CREATE TABLE practice_table1 (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- 2. テストデータ挿入
INSERT INTO practice_table1 VALUES 
(1, 'データ1'),
(2, 'データ2'),
(3, 'データ3');

-- データ確認
SELECT * FROM practice_table1;

-- 3. テーブル削除
DROP TABLE practice_table1;

-- 4. 削除確認（エラーになることを確認）
-- SELECT * FROM practice_table1;  -- エラー: Table doesn't exist

-- または存在確認
SHOW TABLES LIKE 'practice_table1';  -- 結果: 0行
```

### 解答34-2
```sql
-- 1. テーブル作成
CREATE TABLE practice_table2 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. テストデータ挿入
INSERT INTO practice_table2 (data) VALUES 
('データ1'), ('データ2'), ('データ3'), ('データ4'), ('データ5');

-- 最大idの確認
SELECT MAX(id) as max_id FROM practice_table2;

-- 3. TRUNCATEでデータクリア
TRUNCATE TABLE practice_table2;

-- データがクリアされたことを確認
SELECT COUNT(*) as record_count FROM practice_table2;

-- 4. 新しいデータ挿入
INSERT INTO practice_table2 (data) VALUES ('新しいデータ');

-- idが1から開始されることを確認
SELECT * FROM practice_table2;
```

### 解答34-3
```sql
-- 1. 3つのテーブル作成
CREATE TABLE delete_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE truncate_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE drop_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 各テーブルに同じデータを挿入
INSERT INTO delete_test (data) VALUES ('データA'), ('データB'), ('データC');
INSERT INTO truncate_test (data) VALUES ('データA'), ('データB'), ('データC');
INSERT INTO drop_test (data) VALUES ('データA'), ('データB'), ('データC');

-- 挿入後の状態確認
SELECT 'delete_test' as table_name, COUNT(*) as count FROM delete_test
UNION ALL
SELECT 'truncate_test', COUNT(*) FROM truncate_test
UNION ALL
SELECT 'drop_test', COUNT(*) FROM drop_test;

-- 3. それぞれの方法で処理
-- DELETE
DELETE FROM delete_test;

-- TRUNCATE
TRUNCATE TABLE truncate_test;

-- DROP
DROP TABLE drop_test;

-- 4. 結果比較
-- DELETEの結果
SELECT 'delete_test after DELETE' as status, COUNT(*) as count FROM delete_test;
DESCRIBE delete_test;  -- テーブル構造は残っている

-- TRUNCATEの結果
SELECT 'truncate_test after TRUNCATE' as status, COUNT(*) as count FROM truncate_test;
DESCRIBE truncate_test;  -- テーブル構造は残っている

-- DROPの結果
-- DESCRIBE drop_test;  -- エラー: テーブルが存在しない

-- 新しいデータ挿入でAUTO_INCREMENTの違いを確認
INSERT INTO delete_test (data) VALUES ('DELETE後データ');
INSERT INTO truncate_test (data) VALUES ('TRUNCATE後データ');

SELECT 'DELETE後のAUTO_INCREMENT' as type, id FROM delete_test;
SELECT 'TRUNCATE後のAUTO_INCREMENT' as type, id FROM truncate_test;
```

### 解答34-4
```sql
-- 1. 親テーブル作成
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

-- 2. 子テーブル作成（外部キー制約付き）
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 3. テストデータ挿入
INSERT INTO departments VALUES (1, '営業部'), (2, '開発部');
INSERT INTO employees VALUES (101, '田中', 1), (102, '佐藤', 2), (103, '鈴木', 1);

-- データ確認
SELECT * FROM departments;
SELECT * FROM employees;

-- 4. 親テーブルを先に削除しようとする（エラーになることを確認）
-- DROP TABLE departments;  
-- エラー: Cannot delete or update a parent row: a foreign key constraint fails

-- 正しい順序での削除（子テーブルから先に）
DROP TABLE employees;
DROP TABLE departments;

-- 削除確認
SHOW TABLES LIKE 'departments';
SHOW TABLES LIKE 'employees';
```

### 解答34-5
```sql
-- 1. テーブル作成
CREATE TABLE large_data_table (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 大量データ挿入（1000件以上）
INSERT INTO large_data_table (content)
SELECT CONCAT('コンテンツ', n) as content
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 n
    FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
) numbers
LIMIT 2000;

-- データ量確認
SELECT COUNT(*) as total_records FROM large_data_table;

-- 3. DELETEの実行時間測定
-- まずデータを複製
CREATE TABLE large_data_delete AS SELECT * FROM large_data_table;
CREATE TABLE large_data_truncate AS SELECT * FROM large_data_table;

-- DELETE文の時間測定
SET @start_time = NOW(6);
DELETE FROM large_data_delete;
SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) as delete_microseconds;

-- TRUNCATE文の時間測定
SET @start_time = NOW(6);
TRUNCATE TABLE large_data_truncate;
SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) as truncate_microseconds;

-- 4. 考察
/*
DELETEのメリット：
- 条件指定可能
- ロールバック可能
- トリガー実行

DELETEのデメリット：
- 処理が遅い
- ログ容量が大きい

TRUNCATEのメリット：
- 高速処理
- AUTO_INCREMENT リセット
- 少ないログ使用

TRUNCATEのデメリット：
- 条件指定不可
- ロールバック不可
- 外部キー制約で制限
*/

-- クリーンアップ
DROP TABLE large_data_table;
DROP TABLE large_data_delete;
DROP TABLE large_data_truncate;
```

### 解答34-6
```sql
-- 1. 重要なテーブル作成
CREATE TABLE important_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    critical_data VARCHAR(255),
    amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 重要なデータ挿入
INSERT INTO important_table (critical_data, amount) VALUES 
('重要データ1', 1000.00),
('重要データ2', 2000.00),
('重要データ3', 1500.00);

-- データ確認
SELECT * FROM important_table;

-- 2. バックアップテーブル作成
CREATE TABLE important_table_backup_20231201 AS 
SELECT * FROM important_table;

-- バックアップの確認
SELECT COUNT(*) as backup_count FROM important_table_backup_20231201;
SELECT * FROM important_table_backup_20231201;

-- 3. 元テーブル削除前の最終確認
SELECT 
    COUNT(*) as original_count,
    SUM(amount) as total_amount,
    MAX(created_at) as latest_record
FROM important_table;

-- 元テーブルの削除
DROP TABLE important_table;

-- 削除確認
SHOW TABLES LIKE 'important_table';

-- 4. 復元手順（必要に応じて）
CREATE TABLE important_table AS 
SELECT * FROM important_table_backup_20231201;

-- 復元確認
SELECT COUNT(*) as restored_count FROM important_table;
SELECT * FROM important_table;

-- データ整合性確認
SELECT 
    o.id, o.critical_data, o.amount,
    CASE WHEN b.id IS NOT NULL THEN '一致' ELSE '不一致' END as integrity_check
FROM important_table o
LEFT JOIN important_table_backup_20231201 b ON o.id = b.id AND o.critical_data = b.critical_data;

-- 5. 最終クリーンアップ（すべて確認後）
-- バックアップテーブルの削除
DROP TABLE important_table_backup_20231201;

-- 最終確認
SHOW TABLES LIKE '%important%';
```

## まとめ

この章では、DROP TABLE文とTRUNCATE文について詳しく学びました：

1. **基本概念の理解**：
   - DROP TABLE：テーブル構造とデータの完全削除
   - TRUNCATE：テーブル構造を保持してデータのみ高速削除
   - DELETE文との違いと使い分け

2. **基本構文と操作**：
   - DROP TABLEの基本構文とIF EXISTSオプション
   - TRUNCATEの基本構文とAUTO_INCREMENTリセット
   - 複数テーブルの同時削除

3. **外部キー制約の考慮**：
   - 参照整合性による削除制限
   - CASCADE削除の活用
   - 制約の一時無効化（注意が必要）

4. **パフォーマンスの比較**：
   - DELETE、TRUNCATE、DROPの処理速度差
   - ログ記録量の違い
   - ロールバック可能性の違い

5. **実践的な削除戦略**：
   - ログテーブルの定期クリア
   - テスト環境のデータリセット
   - 一時テーブルの管理

6. **安全な削除手順**：
   - 事前のバックアップ作成
   - 依存関係の確認
   - 段階的な削除実行

7. **エラー対処法**：
   - 外部キー制約エラーの解決
   - 権限エラーへの対応
   - TRUNCATE制約エラーの回避

8. **ベストプラクティス**：
   - 環境別の削除戦略
   - 自動化スクリプトの活用
   - リスク管理の重要性

DROP TABLE文とTRUNCATE文は非常に強力ですが、**一度実行すると元に戻せない**危険な操作です。特に本番環境では、必ずバックアップを作成し、十分な確認を行ってから実行することが重要です。

次の章では、「制約：主キー、外部キー、CHECK制約」について学び、データの整合性を保つための制約機能を詳しく理解していきます。