# 28. データ削除：DELETE文

## はじめに

前章では、UPDATE文を使用してデータを更新する方法を学びました。この章では、不要になったデータをデータベースから削除するための「DELETE文」について学習します。

DELETE文は、テーブルからレコード（行）を削除するためのSQL文で、データベースの基本操作CRUD（Create、Read、Update、Delete）の「Delete」に該当します。

DELETE文が必要となる場面の例：
- 「退学した学生のデータを削除したい」
- 「キャンセルされた授業の記録を削除したい」
- 「古いテストデータを削除したい」
- 「重複したデータを削除したい」
- 「一定期間経過した出席記録をアーカイブしたい」
- 「システム移行前の不要データを削除したい」

DELETE文は非常に強力で便利な機能ですが、**一度削除されたデータは元に戻すことができません**。UPDATE文以上に慎重な操作が必要です。安全な使用方法と注意点を含めて詳しく学んでいきます。

## DELETE文とは

DELETE文は、テーブルから指定した条件に一致するレコードを完全に削除するためのSQL文です。削除されたデータは、特別な復旧手段がない限り永続的に失われます。

> **用語解説**：
> - **DELETE文**：テーブルからレコード（行）を削除するSQL文です。
> - **WHERE句**：削除対象のレコードを限定するための条件を指定します。DELETE文では特に重要です。
> - **TRUNCATE文**：テーブルの全レコードを高速で削除する文です。
> - **CASCADE DELETE**：外部キー制約で関連するレコードも連鎖的に削除する機能です。
> - **論理削除**：実際にレコードを削除せず、削除フラグを設定してデータを無効にする方法です。
> - **物理削除**：DELETE文による実際のレコードの削除です。

## DELETE文の基本構文

```sql
DELETE FROM テーブル名
WHERE 条件;
```

### ⚠️ 極めて重要な注意事項

**WHERE句を省略すると、テーブル内のすべてのレコードが削除されます。**これは取り返しのつかない結果を招く可能性があるため、DELETE文を実行する前は必ずWHERE句の存在と条件を確認してください。

## 基本的なDELETE文の例

### 例1：単一レコードの削除

特定の学生を削除（注意：実際の運用では外部キー制約により削除できない場合があります）：

```sql
-- 削除前の確認
SELECT student_id, student_name FROM students WHERE student_id = 340;

-- 削除実行
DELETE FROM students
WHERE student_id = 340;

-- 削除後の確認
SELECT student_id, student_name FROM students WHERE student_id = 340;
-- 結果：0行が返される（削除されたため）
```

### 例2：複数の条件での削除

特定の講座の特定タイプの成績を削除：

```sql
-- 削除前の確認
SELECT COUNT(*) as delete_count
FROM grades
WHERE course_id = '32' AND grade_type = 'テスト課題';

-- 削除実行
DELETE FROM grades
WHERE course_id = '32' AND grade_type = 'テスト課題';
```

### 例3：日付条件での削除

古い出席記録を削除：

```sql
-- 2025年4月以前の出席記録を削除
-- 削除前の確認
SELECT COUNT(*) as old_records
FROM attendance a
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE cs.schedule_date < '2025-05-01';

-- 削除実行
DELETE a FROM attendance a
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE cs.schedule_date < '2025-05-01';
```

## 条件付きDELETE

WHERE句を使用して、特定の条件に一致するレコードのみを削除できます。

### 例4：範囲条件での削除

テスト用に作成した学生データを削除：

```sql
-- 学生ID 330番台のテストデータを削除
-- 削除前の確認
SELECT student_id, student_name 
FROM students 
WHERE student_id BETWEEN 330 AND 339;

-- 外部キー制約を確認し、関連データがある場合は先に削除
DELETE FROM student_courses WHERE student_id BETWEEN 330 AND 339;
DELETE FROM attendance WHERE student_id BETWEEN 330 AND 339;
DELETE FROM grades WHERE student_id BETWEEN 330 AND 339;

-- 最後に学生データを削除
DELETE FROM students
WHERE student_id BETWEEN 330 AND 339;
```

### 例5：NULL値を条件とした削除

不完全なデータを削除：

```sql
-- 成績が記録されていない（NULL）レコードを削除
DELETE FROM grades
WHERE score IS NULL AND submission_date IS NULL;
```

### 例6：LIKE演算子での削除

特定のパターンに一致するデータを削除：

```sql
-- テスト用の講座（名前に「テスト」が含まれる）を削除
-- まず関連データを削除
DELETE FROM student_courses 
WHERE course_id IN (
    SELECT course_id FROM courses WHERE course_name LIKE '%テスト%'
);

DELETE FROM course_schedule 
WHERE course_id IN (
    SELECT course_id FROM courses WHERE course_name LIKE '%テスト%'
);

DELETE FROM grades 
WHERE course_id IN (
    SELECT course_id FROM courses WHERE course_name LIKE '%テスト%'
);

-- 最後に講座データを削除
DELETE FROM courses
WHERE course_name LIKE '%テスト%';
```

## JOINを使ったDELETE

他のテーブルの情報を参照しながら削除を行う場合に使用します。

### 例7：関連データに基づく削除

担当教師が不在の期間中の授業記録を削除：

```sql
-- 教師の不在期間と重なる授業スケジュールを削除
DELETE cs FROM course_schedule cs
JOIN teacher_unavailability tu ON cs.teacher_id = tu.teacher_id
WHERE cs.schedule_date BETWEEN tu.start_date AND tu.end_date
  AND cs.status = 'cancelled';
```

### 例8：集計結果に基づく削除

受講者が1人もいない講座を削除：

```sql
-- 受講者のいない講座を特定
SELECT c.course_id, c.course_name
FROM courses c
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
WHERE sc.course_id IS NULL;

-- 関連データを削除（授業スケジュール）
DELETE cs FROM course_schedule cs
LEFT JOIN student_courses sc ON cs.course_id = sc.course_id
WHERE sc.course_id IS NULL;

-- 講座データを削除
DELETE c FROM courses c
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
WHERE sc.course_id IS NULL;
```

## サブクエリを使ったDELETE

### 例9：平均点が低い成績データの削除

全体平均よりも大幅に低い成績（平均-20点以下）を削除：

```sql
-- 削除対象の確認
SELECT student_id, course_id, grade_type, score
FROM grades
WHERE score < (SELECT AVG(score) - 20 FROM grades)
ORDER BY score;

-- 削除実行
DELETE FROM grades
WHERE score < (SELECT AVG(score) - 20 FROM grades);
```

### 例10：重複データの削除

同じ学生が同じ講座を重複受講している場合の削除：

```sql
-- 重複レコードの特定
SELECT student_id, course_id, COUNT(*) as duplicate_count
FROM student_courses
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- 重複レコードの削除（最小のIDを残して他を削除）
DELETE sc1 FROM student_courses sc1
JOIN student_courses sc2 ON sc1.student_id = sc2.student_id 
                         AND sc1.course_id = sc2.course_id
WHERE sc1.course_id > sc2.course_id;  -- より大きなIDのレコードを削除
```

## LIMIT句を使った削除

MySQLでは、DELETE文でLIMIT句を使用して削除件数を制限できます。

### 例11：件数を制限した削除

```sql
-- 古い出席記録を少しずつ削除
DELETE FROM attendance 
WHERE schedule_id IN (
    SELECT schedule_id FROM course_schedule 
    WHERE schedule_date < '2025-04-01'
)
LIMIT 100;  -- 一度に100件まで削除
```

## 外部キー制約とDELETE

外部キー制約がある場合、参照されているレコードは削除できません。

### 例12：外部キー制約を考慮した削除

```sql
-- 学生を削除する場合の正しい手順

-- 1. 削除対象の学生の関連データを確認
SELECT '成績' as table_name, COUNT(*) as count FROM grades WHERE student_id = 325
UNION ALL
SELECT '出席', COUNT(*) FROM attendance WHERE student_id = 325
UNION ALL
SELECT '受講', COUNT(*) FROM student_courses WHERE student_id = 325;

-- 2. 関連データを順序良く削除
DELETE FROM grades WHERE student_id = 325;
DELETE FROM attendance WHERE student_id = 325;
DELETE FROM student_courses WHERE student_id = 325;

-- 3. 最後に学生データを削除
DELETE FROM students WHERE student_id = 325;
```

### CASCADE DELETEの活用

外部キー制約にCASCADE オプションが設定されている場合、親レコードの削除時に子レコードも自動削除されます：

```sql
-- CASCADE DELETEが設定されている場合
-- （外部キー制約の設定例）
-- ALTER TABLE grades 
-- ADD CONSTRAINT fk_grades_student 
-- FOREIGN KEY (student_id) REFERENCES students(student_id) 
-- ON DELETE CASCADE;

-- 学生を削除すると、関連する成績データも自動削除される
DELETE FROM students WHERE student_id = 325;
```

## TRUNCATE文との違い

TRUNCATE文は、テーブルの全レコードを高速で削除する文です。

### TRUNCATE文の例

```sql
-- テーブルの全データを削除（高速）
TRUNCATE TABLE test_grades;
```

### DELETE文とTRUNCATE文の比較

| 項目 | DELETE | TRUNCATE |
|------|--------|----------|
| **実行速度** | 遅い（レコード単位） | 高速（テーブル単位） |
| **WHERE句** | 使用可能 | 使用不可 |
| **ロールバック** | 可能 | 不可（一部のDB） |
| **外部キー制約** | チェックされる | 制約があると実行不可 |
| **トリガー** | 実行される | 実行されない |
| **AUTO_INCREMENT** | リセットされない | リセットされる |

## 論理削除 vs 物理削除

### 論理削除の実装例

```sql
-- 学生テーブルに削除フラグを追加（実際の運用では必要）
-- ALTER TABLE students ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;

-- 論理削除の実行
UPDATE students 
SET is_deleted = TRUE 
WHERE student_id = 325;

-- 論理削除されていない学生のみを取得
SELECT student_id, student_name 
FROM students 
WHERE is_deleted = FALSE OR is_deleted IS NULL;
```

### 物理削除と論理削除の使い分け

| シナリオ | 推奨方法 | 理由 |
|----------|----------|------|
| **学生の退学** | 論理削除 | 履歴として保持が必要 |
| **テストデータ** | 物理削除 | 不要なデータの完全除去 |
| **個人情報** | 物理削除 | プライバシー保護 |
| **一時的な無効化** | 論理削除 | 復元の可能性 |

## 安全なDELETE操作

### 1. 削除前の必須チェック

```sql
-- Step 1: 削除対象レコードの確認
SELECT student_id, student_name 
FROM students 
WHERE student_id = 325;

-- Step 2: 関連データの確認
SELECT COUNT(*) as related_grades FROM grades WHERE student_id = 325;
SELECT COUNT(*) as related_attendance FROM attendance WHERE student_id = 325;

-- Step 3: バックアップの作成（重要な場合）
CREATE TABLE students_backup_20250522 AS 
SELECT * FROM students WHERE student_id = 325;

-- Step 4: 削除実行
DELETE FROM students WHERE student_id = 325;

-- Step 5: 削除結果の確認
SELECT student_id, student_name FROM students WHERE student_id = 325;
-- 結果: 0行（削除成功）
```

### 2. トランザクションの使用

```sql
START TRANSACTION;

-- 関連データの削除
DELETE FROM grades WHERE student_id = 325;
DELETE FROM attendance WHERE student_id = 325;
DELETE FROM student_courses WHERE student_id = 325;

-- 学生データの削除
DELETE FROM students WHERE student_id = 325;

-- 確認後にコミット
-- 問題がなければ
COMMIT;

-- 問題があれば
-- ROLLBACK;
```

### 3. 影響範囲の事前確認

```sql
-- 削除対象の件数を事前確認
SELECT COUNT(*) as will_be_deleted
FROM grades
WHERE submission_date < '2025-04-01' AND score IS NULL;

-- 確認後に削除実行
DELETE FROM grades
WHERE submission_date < '2025-04-01' AND score IS NULL;
```

## DELETE文のパフォーマンス考慮点

### 1. インデックスの活用

```sql
-- WHERE句で使用するカラムにインデックスを作成
-- CREATE INDEX idx_submission_date ON grades(submission_date);

-- インデックスを活用した効率的な削除
DELETE FROM grades
WHERE submission_date < '2025-04-01';
```

### 2. 大量削除の分割実行

```sql
-- 大量データの削除を分割して実行
DELETE FROM old_attendance 
WHERE schedule_id IN (
    SELECT schedule_id FROM course_schedule 
    WHERE schedule_date < '2025-01-01'
)
LIMIT 1000;  -- 1000件ずつ削除

-- 削除完了まで繰り返し実行
```

### 3. 外部キー制約の一時無効化（注意が必要）

```sql
-- 大量削除時の外部キー制約の一時無効化
SET FOREIGN_KEY_CHECKS = 0;

-- 削除実行
DELETE FROM students WHERE student_id BETWEEN 300 AND 350;

-- 制約を再有効化
SET FOREIGN_KEY_CHECKS = 1;
```

## よくあるエラーと対処法

### 1. WHERE句の忘れ

```sql
-- 危険：WHERE句なし（全レコードが削除される）
-- DELETE FROM students;

-- 安全：WHERE句あり
DELETE FROM students WHERE student_id = 999;  -- 存在しないIDなので実際は削除されない
```

### 2. 外部キー制約エラー

```sql
-- エラー例：参照されているレコードの削除
-- DELETE FROM students WHERE student_id = 301;
-- エラー: Cannot delete or update a parent row: a foreign key constraint fails

-- 対処法：関連データを先に削除
DELETE FROM grades WHERE student_id = 301;
DELETE FROM attendance WHERE student_id = 301;
DELETE FROM student_courses WHERE student_id = 301;
DELETE FROM students WHERE student_id = 301;
```

## ベストプラクティス

### 1. 段階的な削除

```sql
-- 小規模でテスト
DELETE FROM test_table WHERE id = 1;

-- 結果確認後、範囲を拡大
DELETE FROM test_table WHERE id BETWEEN 1 AND 10;
```

### 2. バックアップの作成

```sql
-- 重要なデータの削除前にバックアップ
CREATE TABLE grades_backup_20250522 AS 
SELECT * FROM grades WHERE course_id = '32';

-- 削除実行
DELETE FROM grades WHERE course_id = '32';

-- 必要に応じて復元
-- INSERT INTO grades SELECT * FROM grades_backup_20250522;
```

### 3. ログ記録

```sql
-- 削除ログテーブルの作成
CREATE TABLE deletion_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    deleted_count INT,
    deletion_condition TEXT,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 削除前にログ記録
INSERT INTO deletion_log (table_name, deleted_count, deletion_condition)
SELECT 'grades', COUNT(*), 'course_id = "32" AND score IS NULL'
FROM grades WHERE course_id = '32' AND score IS NULL;

-- 削除実行
DELETE FROM grades WHERE course_id = '32' AND score IS NULL;
```

## 練習問題

### 問題28-1
学生ID=339の学生を安全に削除するための一連のDELETE文を書いてください。関連データも含めて適切な順序で削除してください。

### 問題28-2
2025年4月以前の出席記録をすべて削除するDELETE文を書いてください。JOINを使用してください。

### 問題28-3
成績が60点未満で、かつ提出日がNULLの成績レコードを削除するDELETE文を書いてください。

### 問題28-4
サブクエリを使用して、受講者が5人未満の講座に関する授業スケジュールをすべて削除するDELETE文を書いてください。

### 問題28-5
JOINとサブクエリを組み合わせて、教師の不在期間と重複している授業のうち、出席者が0人の授業記録（attendance テーブル）を削除するDELETE文を書いてください。

### 問題28-6
重複している成績データ（同じ学生・同じ講座・同じ評価タイプ）のうち、より新しい提出日のレコードを残して古いものを削除するDELETE文を書いてください。

## 解答

### 解答28-1
```sql
-- Step 1: 削除前の確認
SELECT student_id, student_name FROM students WHERE student_id = 339;

-- Step 2: 関連データの削除（外部キー制約順）
DELETE FROM grades WHERE student_id = 339;
DELETE FROM attendance WHERE student_id = 339;
DELETE FROM student_courses WHERE student_id = 339;

-- Step 3: 学生データの削除
DELETE FROM students WHERE student_id = 339;

-- Step 4: 削除確認
SELECT student_id, student_name FROM students WHERE student_id = 339;
```

### 解答28-2
```sql
DELETE a FROM attendance a
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE cs.schedule_date < '2025-05-01';
```

### 解答28-3
```sql
DELETE FROM grades
WHERE score < 60 AND submission_date IS NULL;
```

### 解答28-4
```sql
DELETE FROM course_schedule
WHERE course_id IN (
    SELECT course_id
    FROM (
        SELECT c.course_id
        FROM courses c
        LEFT JOIN student_courses sc ON c.course_id = sc.course_id
        GROUP BY c.course_id
        HAVING COUNT(sc.student_id) < 5
    ) AS low_enrollment_courses
);
```

### 解答28-5
```sql
DELETE a FROM attendance a
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
JOIN teacher_unavailability tu ON cs.teacher_id = tu.teacher_id
WHERE cs.schedule_date BETWEEN tu.start_date AND tu.end_date
AND cs.schedule_id NOT IN (
    SELECT DISTINCT schedule_id
    FROM attendance
    WHERE status = 'present'
);
```

### 解答28-6
```sql
DELETE g1 FROM grades g1
JOIN grades g2 ON g1.student_id = g2.student_id 
               AND g1.course_id = g2.course_id 
               AND g1.grade_type = g2.grade_type
WHERE g1.submission_date < g2.submission_date
   OR (g1.submission_date = g2.submission_date AND g1.grade_id < g2.grade_id);
```

## まとめ

この章では、DELETE文について詳しく学びました：

1. **DELETE文の基本概念**：
   - テーブルからレコードを削除するSQL文
   - 削除されたデータは基本的に復元不可能
   - WHERE句の重要性

2. **基本的なDELETE操作**：
   - 単一レコードの削除
   - 条件付き削除
   - 複数条件での削除

3. **高度なDELETE技術**：
   - JOINを使った削除
   - サブクエリを使った削除
   - LIMIT句による件数制限

4. **外部キー制約への対応**：
   - 関連データの適切な削除順序
   - CASCADE DELETEの活用
   - 制約エラーの回避

5. **TRUNCATE文との違い**：
   - パフォーマンスの違い
   - 機能の違い
   - 使い分けの基準

6. **論理削除 vs 物理削除**：
   - それぞれの特徴と使い分け
   - 履歴保持の重要性

7. **安全なDELETE操作**：
   - 削除前の必須チェック
   - トランザクションの使用
   - バックアップの作成

8. **パフォーマンスとエラー対処**：
   - インデックスの活用
   - 大量削除の分割実行
   - よくあるエラーの回避

9. **ベストプラクティス**：
   - 段階的な削除
   - ログ記録
   - 復元可能性の考慮

DELETE文は、データベース操作の中でも特に慎重に扱う必要がある機能です。適切な手順と安全対策を講じることで、安全かつ効率的にデータ削除を行うことができます。

次の章では、「トランザクション：BEGIN、COMMIT、ROLLBACK」について学び、複数の操作をまとめて安全に実行する方法を理解していきます。
