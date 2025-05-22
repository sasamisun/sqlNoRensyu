# 31. インデックス：検索効率化の基本

## はじめに

前章では、ビューを使って複雑なクエリを管理しやすくする方法を学びました。この章では、データベースの検索性能を大幅に向上させる「インデックス」について学習します。

インデックスは、データベースのパフォーマンスを左右する最も重要な要素の一つです。適切に設計されたインデックスは、検索速度を数十倍、場合によっては数百倍高速化することができます。

インデックスが重要な場面の例：
- 「学生IDでの検索が遅すぎる」
- 「成績順でのソートに時間がかかる」
- 「複数テーブルの結合処理が遅い」
- 「WHERE句での絞り込みが非効率」
- 「大量データでの集計処理が重い」
- 「アプリケーションの応答時間を改善したい」

この章では、インデックスの基本概念から実践的な設計方法、パフォーマンス分析まで詳しく学んでいきます。

## インデックスとは

インデックスは、データベースの検索性能を向上させるための「索引」です。本の巻末にある索引と同様に、特定の値を効率的に見つけるための仕組みです。

> **用語解説**：
> - **インデックス（Index）**：テーブルのデータを効率的に検索するための索引構造です。
> - **B-Treeインデックス**：最も一般的なインデックス構造で、バランス木を使用します。
> - **主キー（Primary Key）**：テーブルの各行を一意に識別するキーで、自動的にインデックスが作成されます。
> - **外部キー（Foreign Key）**：他のテーブルの主キーを参照するキーです。
> - **一意インデックス（Unique Index）**：重複値を許可しないインデックスです。
> - **複合インデックス（Composite Index）**：複数のカラムを組み合わせたインデックスです。
> - **選択性（Selectivity）**：インデックスがどれだけ効果的にデータを絞り込めるかの指標です。

## インデックスの仕組み

### 本の索引との比較

本で特定の用語を探す場合：
- **索引なし**：最初のページから順番に全ページをめくって探す
- **索引あり**：巻末の索引で用語を見つけ、該当ページに直接飛ぶ

データベースでも同様：
- **インデックスなし**：テーブルの最初の行から順番に全行をスキャン（フルテーブルスキャン）
- **インデックスあり**：インデックスで該当行を特定し、直接アクセス

### B-Treeインデックスの構造

```
        [50]
       /    \
   [25]      [75]
   /  \      /  \
[10][40] [60][90]
```

この木構造により、対数時間（O(log n)）でのデータアクセスが可能になります。

## インデックスの種類

### 1. 主キーインデックス（自動作成）

```sql
-- 主キーは自動的にインデックスが作成される
CREATE TABLE test_students (
    student_id BIGINT PRIMARY KEY,  -- 自動的にインデックス作成
    student_name VARCHAR(64)
);
```

### 2. 一意インデックス

```sql
-- 重複を許可しないインデックス
CREATE UNIQUE INDEX idx_student_email 
ON students (email);
```

### 3. 単一カラムインデックス

```sql
-- 単一カラムのインデックス
CREATE INDEX idx_student_name 
ON students (student_name);

CREATE INDEX idx_grades_score 
ON grades (score);
```

### 4. 複合インデックス

```sql
-- 複数カラムの組み合わせインデックス
CREATE INDEX idx_grades_student_course 
ON grades (student_id, course_id);

CREATE INDEX idx_attendance_schedule_student 
ON attendance (schedule_id, student_id, status);
```

## インデックスの作成

### CREATE INDEX文の基本構文

```sql
CREATE [UNIQUE] INDEX インデックス名
ON テーブル名 (カラム1 [ASC|DESC], カラム2 [ASC|DESC], ...);
```

### 例1：学校データベースでの基本インデックス作成

```sql
-- 学生名での検索を高速化
CREATE INDEX idx_students_name ON students (student_name);

-- 成績での検索を高速化
CREATE INDEX idx_grades_score ON grades (score);

-- 授業日での検索を高速化
CREATE INDEX idx_schedule_date ON course_schedule (schedule_date);

-- 教師IDでの検索を高速化（既存の外部キーに追加）
CREATE INDEX idx_courses_teacher ON courses (teacher_id);
```

### 例2：複合インデックスの作成

```sql
-- 学生と講座の組み合わせでの検索を高速化
CREATE INDEX idx_grades_student_course ON grades (student_id, course_id);

-- 講座と評価タイプの組み合わせでの検索を高速化
CREATE INDEX idx_grades_course_type ON grades (course_id, grade_type);

-- 日付と時限の組み合わせでの検索を高速化
CREATE INDEX idx_schedule_date_period ON course_schedule (schedule_date, period_id);
```

## インデックスの効果を確認

### EXPLAIN文によるクエリ実行計画の確認

```sql
-- インデックスを使用する前のクエリ
EXPLAIN
SELECT * FROM grades WHERE student_id = 301;

-- インデックス作成
CREATE INDEX idx_grades_student_id ON grades (student_id);

-- インデックスを使用した後のクエリ
EXPLAIN
SELECT * FROM grades WHERE student_id = 301;
```

### 例3：パフォーマンス改善の実例

**改善前：**
```sql
-- インデックスなしでの検索（遅い）
SELECT s.student_name, g.score
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.score >= 85
ORDER BY g.score DESC;

-- EXPLAIN結果: Full Table Scan（全テーブルスキャン）
```

**改善後：**
```sql
-- 適切なインデックスを作成
CREATE INDEX idx_grades_score ON grades (score);
CREATE INDEX idx_grades_student_id ON grades (student_id);

-- 同じクエリが高速化される
SELECT s.student_name, g.score
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.score >= 85
ORDER BY g.score DESC;

-- EXPLAIN結果: Index Scan（インデックススキャン）
```

## 複合インデックスの設計

### カラムの順序の重要性

複合インデックスでは、カラムの順序が非常に重要です。「左端一致の原則」に従って設計する必要があります。

```sql
-- 複合インデックスの作成
CREATE INDEX idx_grades_multi ON grades (student_id, course_id, grade_type);

-- このインデックスが効果的に使用される例
SELECT * FROM grades WHERE student_id = 301;  -- ✓ 効果的
SELECT * FROM grades WHERE student_id = 301 AND course_id = '1';  -- ✓ 効果的
SELECT * FROM grades WHERE student_id = 301 AND course_id = '1' AND grade_type = '中間テスト';  -- ✓ 効果的

-- このインデックスが効果的でない例
SELECT * FROM grades WHERE course_id = '1';  -- ✗ 効果的でない
SELECT * FROM grades WHERE grade_type = '中間テスト';  -- ✗ 効果的でない
SELECT * FROM grades WHERE course_id = '1' AND grade_type = '中間テスト';  -- ✗ 効果的でない
```

### 例4：効果的な複合インデックスの設計

```sql
-- 出席検索用の複合インデックス
-- よく使用される検索パターンを分析
-- 1. schedule_id での検索
-- 2. schedule_id + student_id での検索
-- 3. schedule_id + student_id + status での検索

CREATE INDEX idx_attendance_composite 
ON attendance (schedule_id, student_id, status);

-- 効果的な使用例
EXPLAIN SELECT * FROM attendance 
WHERE schedule_id = 1 AND student_id = 301;

EXPLAIN SELECT COUNT(*) FROM attendance 
WHERE schedule_id = 1 AND status = 'present';
```

## 実践的なインデックス設計例

### 例5：学生検索の最適化

```sql
-- 学生検索でよく使用されるクエリパターンを分析

-- パターン1: 名前での部分一致検索
SELECT * FROM students WHERE student_name LIKE '田%';

-- パターン2: IDでの直接検索
SELECT * FROM students WHERE student_id = 301;

-- パターン3: 範囲での検索
SELECT * FROM students WHERE student_id BETWEEN 301 AND 310;

-- 対応するインデックス
CREATE INDEX idx_students_name ON students (student_name);  -- 主キーは既存
-- student_id は主キーなので既にインデックスあり
```

### 例6：成績分析クエリの最適化

```sql
-- よく使用される成績分析クエリ
-- 1. 特定学生の全成績
SELECT * FROM grades WHERE student_id = 301;

-- 2. 特定講座の全成績
SELECT * FROM grades WHERE course_id = '1';

-- 3. 特定評価タイプの全成績
SELECT * FROM grades WHERE grade_type = '中間テスト';

-- 4. 高得点の成績
SELECT * FROM grades WHERE score >= 90;

-- 5. 学生×講座での成績
SELECT * FROM grades WHERE student_id = 301 AND course_id = '1';

-- 最適なインデックス設計
CREATE INDEX idx_grades_student_id ON grades (student_id);
CREATE INDEX idx_grades_course_id ON grades (course_id);
CREATE INDEX idx_grades_score ON grades (score);
CREATE INDEX idx_grades_student_course ON grades (student_id, course_id);
```

### 例7：授業スケジュール検索の最適化

```sql
-- スケジュール検索のクエリパターン
-- 1. 特定日の授業
SELECT * FROM course_schedule WHERE schedule_date = '2025-05-22';

-- 2. 特定期間の授業
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';

-- 3. 特定講座のスケジュール
SELECT * FROM course_schedule WHERE course_id = '1';

-- 4. 特定教師のスケジュール
SELECT * FROM course_schedule WHERE teacher_id = 101;

-- 5. 日付と時限での検索
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-22' AND period_id = 1;

-- 最適なインデックス設計
CREATE INDEX idx_schedule_date ON course_schedule (schedule_date);
CREATE INDEX idx_schedule_course ON course_schedule (course_id);
CREATE INDEX idx_schedule_teacher ON course_schedule (teacher_id);
CREATE INDEX idx_schedule_date_period ON course_schedule (schedule_date, period_id);
```

## インデックスのパフォーマンス分析

### EXPLAIN文の詳細分析

```sql
-- 詳細な実行計画の確認
EXPLAIN FORMAT=JSON
SELECT s.student_name, AVG(g.score) as avg_score
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.score >= 80
GROUP BY s.student_id, s.student_name
ORDER BY avg_score DESC;
```

### 例8：結合クエリの最適化

```sql
-- 結合処理の最適化前
EXPLAIN
SELECT s.student_name, c.course_name, g.score
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
WHERE g.score >= 85;

-- 結合用インデックスの作成
CREATE INDEX idx_student_courses_student ON student_courses (student_id);
CREATE INDEX idx_student_courses_course ON student_courses (course_id);
CREATE INDEX idx_grades_student_course_score ON grades (student_id, course_id, score);

-- 最適化後のクエリ
EXPLAIN
SELECT s.student_name, c.course_name, g.score
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
WHERE g.score >= 85;
```

## インデックスのコストと注意点

### 1. 挿入・更新・削除への影響

```sql
-- インデックスが多いテーブルでは、更新処理が遅くなる
-- 例：grades テーブルに多数のインデックスがある場合

-- 挿入時：すべてのインデックスを更新する必要がある
INSERT INTO grades (student_id, course_id, grade_type, score, max_score)
VALUES (301, '1', '追加テスト', 85, 100);

-- 更新時：影響するインデックスを更新する必要がある
UPDATE grades SET score = 90 WHERE student_id = 301 AND course_id = '1';

-- 削除時：すべてのインデックスから該当エントリを削除する必要がある
DELETE FROM grades WHERE student_id = 301 AND course_id = '1';
```

### 2. ストレージ使用量の増加

```sql
-- インデックスのサイズ確認
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    ROUND(STAT_VALUE * @@innodb_page_size / 1024 / 1024, 2) AS index_size_mb
FROM INFORMATION_SCHEMA.INNODB_SYS_TABLESTATS 
WHERE TABLE_NAME LIKE 'grades';
```

### 3. 不要なインデックスの識別

```sql
-- 使用されていないインデックスの確認
SELECT 
    OBJECT_SCHEMA,
    OBJECT_NAME,
    INDEX_NAME,
    COUNT_STAR,
    COUNT_READ,
    COUNT_WRITE
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE OBJECT_SCHEMA = 'school_db'
AND COUNT_STAR = 0
ORDER BY OBJECT_NAME, INDEX_NAME;
```

## 効果的でないインデックスの例

### 避けるべきインデックス

```sql
-- 1. 選択性の低いカラム（多くの行が同じ値）
-- 悪い例：ほとんどの値が同じ
CREATE INDEX idx_grades_max_score ON grades (max_score);  -- ほとんど100

-- 2. 頻繁に更新されるカラム
-- 注意が必要：頻繁に更新される場合
CREATE INDEX idx_grades_submission_date ON grades (submission_date);

-- 3. 非常に長い文字列カラム
-- 注意が必要：長いテキストフィールド
CREATE INDEX idx_classrooms_facilities ON classrooms (facilities);  -- TEXT型
```

### 部分インデックスの活用

```sql
-- 部分インデックス（特定の条件に一致するレコードのみ）
CREATE INDEX idx_high_scores ON grades (student_id, score) 
WHERE score >= 80;

-- NULL値を除外したインデックス
CREATE INDEX idx_non_null_scores ON grades (score) 
WHERE score IS NOT NULL;
```

## インデックスの保守

### インデックスの確認

```sql
-- テーブルのインデックス一覧表示
SHOW INDEX FROM grades;

-- より詳細な情報
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    COLLATION,
    CARDINALITY,
    INDEX_TYPE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'school_db' 
AND TABLE_NAME = 'grades'
ORDER BY INDEX_NAME, SEQ_IN_INDEX;
```

### インデックスの削除

```sql
-- 不要なインデックスの削除
DROP INDEX idx_grades_max_score ON grades;

-- 主キー以外のインデックスをすべて削除
ALTER TABLE grades 
DROP INDEX idx_grades_score,
DROP INDEX idx_grades_student_id,
DROP INDEX idx_grades_course_id;
```

### インデックスの再構築

```sql
-- テーブルの最適化（インデックス再構築を含む）
OPTIMIZE TABLE grades;

-- または
ALTER TABLE grades ENGINE=InnoDB;
```

## 実践的なインデックス戦略

### 例9：学校データベースの包括的なインデックス設計

```sql
-- 1. 基本的な検索パターンに対するインデックス

-- 学生関連
CREATE INDEX idx_students_name ON students (student_name);

-- 講座関連
CREATE INDEX idx_courses_teacher ON courses (teacher_id);
CREATE INDEX idx_courses_name ON courses (course_name);

-- 成績関連
CREATE INDEX idx_grades_student ON grades (student_id);
CREATE INDEX idx_grades_course ON grades (course_id);
CREATE INDEX idx_grades_score ON grades (score);
CREATE INDEX idx_grades_type ON grades (grade_type);
CREATE INDEX idx_grades_date ON grades (submission_date);

-- 複合インデックス
CREATE INDEX idx_grades_student_course ON grades (student_id, course_id);
CREATE INDEX idx_grades_course_type_score ON grades (course_id, grade_type, score);

-- 出席関連
CREATE INDEX idx_attendance_student ON attendance (student_id);
CREATE INDEX idx_attendance_schedule ON attendance (schedule_id);
CREATE INDEX idx_attendance_status ON attendance (status);
CREATE INDEX idx_attendance_schedule_student ON attendance (schedule_id, student_id);

-- スケジュール関連
CREATE INDEX idx_schedule_date ON course_schedule (schedule_date);
CREATE INDEX idx_schedule_course ON course_schedule (course_id);
CREATE INDEX idx_schedule_teacher ON course_schedule (teacher_id);
CREATE INDEX idx_schedule_classroom ON course_schedule (classroom_id);
CREATE INDEX idx_schedule_date_period ON course_schedule (schedule_date, period_id);

-- 受講関連
CREATE INDEX idx_student_courses_student ON student_courses (student_id);
CREATE INDEX idx_student_courses_course ON student_courses (course_id);
```

### 例10：クエリパフォーマンスの測定

```sql
-- パフォーマンステスト用のクエリ
SET profiling = 1;

-- テストクエリ1：学生の成績検索
SELECT s.student_name, AVG(g.score) as avg_score
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE s.student_id BETWEEN 301 AND 310
GROUP BY s.student_id, s.student_name
ORDER BY avg_score DESC;

-- テストクエリ2：講座別の出席率
SELECT c.course_name, 
       COUNT(a.student_id) as total,
       SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) as present,
       ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 2) as attendance_rate
FROM courses c
JOIN course_schedule cs ON c.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY c.course_id, c.course_name
ORDER BY attendance_rate DESC;

-- プロファイリング結果の確認
SHOW PROFILES;
SHOW PROFILE FOR QUERY 1;
SHOW PROFILE FOR QUERY 2;
```

## インデックス設計のベストプラクティス

### 1. 選択性の高いカラムを優先

```sql
-- 良い例：選択性の高いカラム
CREATE INDEX idx_students_id ON students (student_id);  -- 一意性が高い

-- 注意が必要：選択性の低いカラム
CREATE INDEX idx_attendance_status ON attendance (status);  -- 3種類の値のみ
```

### 2. よく使用されるWHERE句の条件

```sql
-- アプリケーションでよく使用されるクエリを分析
-- 例：学生ポータルでの成績検索
SELECT * FROM grades 
WHERE student_id = ? AND course_id = ?;

-- 対応するインデックス
CREATE INDEX idx_grades_student_course ON grades (student_id, course_id);
```

### 3. ORDER BY句の最適化

```sql
-- ソートが必要なクエリ
SELECT * FROM grades 
WHERE course_id = '1'
ORDER BY score DESC;

-- ソート用インデックス
CREATE INDEX idx_grades_course_score_desc ON grades (course_id, score DESC);
```

### 4. カバリングインデックス

```sql
-- 必要なすべてのカラムを含むインデックス
CREATE INDEX idx_grades_covering 
ON grades (student_id, course_id, grade_type, score, submission_date);

-- このインデックスにより、テーブルアクセスなしで結果を取得可能
SELECT student_id, course_id, grade_type, score, submission_date
FROM grades
WHERE student_id = 301;
```

## 練習問題

### 問題31-1
以下のクエリを高速化するために必要なインデックスを特定し、CREATE INDEX文を書いてください：
```sql
SELECT * FROM students WHERE student_name LIKE '田%';
```

### 問題31-2
以下のクエリのパフォーマンスを向上させるための複合インデックスを設計してください：
```sql
SELECT * FROM grades 
WHERE course_id = '1' AND grade_type = '中間テスト' AND score >= 80
ORDER BY score DESC;
```

### 問題31-3
以下の結合クエリを最適化するために必要なインデックスをすべて特定してください：
```sql
SELECT s.student_name, c.course_name, g.score
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
WHERE s.student_id BETWEEN 301 AND 310;
```

### 問題31-4
出席テーブル（attendance）で以下のクエリパターンが頻繁に実行されます。最適な複合インデックスを1つ設計してください：
- `WHERE schedule_id = ? AND student_id = ?`
- `WHERE schedule_id = ? AND status = 'present'`
- `WHERE schedule_id = ?`

### 問題31-5
EXPLAIN文を使用して、以下のクエリの実行計画を分析し、必要なインデックスを提案してください：
```sql
SELECT DATE_FORMAT(cs.schedule_date, '%Y-%m') as month,
       COUNT(*) as class_count,
       AVG(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) as attendance_rate
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
WHERE cs.schedule_date >= '2025-01-01'
GROUP BY DATE_FORMAT(cs.schedule_date, '%Y-%m');
```

### 問題31-6
以下の条件で、不要なインデックスを特定し、その理由を説明してください：
- gradesテーブルのmax_scoreカラム（ほとんどの値が100）
- studentsテーブルの非常に長いコメントカラム
- 頻繁に更新されるlast_updated_atカラム

## 解答

### 解答31-1
```sql
-- 前方一致検索用のインデックス
CREATE INDEX idx_students_name ON students (student_name);

-- LIKE '田%' のような前方一致検索では、このインデックスが効果的に使用される
-- ただし、'%田%' のような中間一致や '%田' のような後方一致では効果的でない
```

### 解答31-2
```sql
-- 複合インデックスの設計
-- WHERE句の条件とORDER BY句を考慮
CREATE INDEX idx_grades_course_type_score_desc 
ON grades (course_id, grade_type, score DESC);

-- このインデックスにより：
-- 1. course_id = '1' での絞り込み
-- 2. grade_type = '中間テスト' での絞り込み  
-- 3. score >= 80 での範囲検索
-- 4. score DESC でのソート
-- すべてが効率的に実行される
```

### 解答31-3
```sql
-- 必要なインデックス一覧

-- 1. students テーブル（主キーは既存）
-- student_id は主キーなので既にインデックスあり

-- 2. student_courses テーブル
CREATE INDEX idx_student_courses_student ON student_courses (student_id);
CREATE INDEX idx_student_courses_course ON student_courses (course_id);

-- 3. courses テーブル（主キーは既存）
-- course_id は主キーなので既にインデックスあり

-- 4. grades テーブル
CREATE INDEX idx_grades_student ON grades (student_id);
CREATE INDEX idx_grades_course ON grades (course_id);
-- または結合用の複合インデックス
CREATE INDEX idx_grades_student_course ON grades (student_id, course_id);

-- 5. WHERE句の条件用
-- student_id BETWEEN 301 AND 310 は主キーで効率的に処理される
```

### 解答31-4
```sql
-- 最適な複合インデックス
CREATE INDEX idx_attendance_schedule_student_status 
ON attendance (schedule_id, student_id, status);

-- このインデックスが3つのクエリパターンすべてに対応：
-- 1. WHERE schedule_id = ? AND student_id = ? （左端から2カラム使用）
-- 2. WHERE schedule_id = ? AND status = 'present' （schedule_idと3番目のstatusを使用）
-- 3. WHERE schedule_id = ? （左端カラムのみ使用）

-- 左端一致の原則により、すべてのパターンで効果的に使用される
```

### 解答31-5
```sql
-- まず現在の実行計画を確認
EXPLAIN FORMAT=JSON
SELECT DATE_FORMAT(cs.schedule_date, '%Y-%m') as month,
       COUNT(*) as class_count,
       AVG(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) as attendance_rate
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
WHERE cs.schedule_date >= '2025-01-01'
GROUP BY DATE_FORMAT(cs.schedule_date, '%Y-%m');

-- 必要なインデックス
-- 1. WHERE句の条件用
CREATE INDEX idx_schedule_date ON course_schedule (schedule_date);

-- 2. LEFT JOIN用
CREATE INDEX idx_attendance_schedule ON attendance (schedule_id);

-- 3. 集計処理最適化用（オプション）
CREATE INDEX idx_attendance_schedule_status ON attendance (schedule_id, status);

-- これらのインデックスにより：
-- - WHERE句での日付範囲検索が高速化
-- - LEFT JOINが効率的に実行
-- - GROUP BYとAVG計算が最適化
```

### 解答31-6
```sql
-- 不要または注意が必要なインデックス

-- 1. gradesテーブルのmax_scoreカラム
-- DROP INDEX idx_grades_max_score ON grades;
-- 理由：選択性が非常に低い（ほとんどの値が100）
-- ほとんどの行が同じ値を持つため、インデックスの効果が薄い

-- 2. studentsテーブルの長いコメントカラム
-- DROP INDEX idx_students_comment ON students;  
-- 理由：長いテキストフィールドのインデックスは容量を大量消費
-- 前方一致検索以外では効果的でない

-- 3. 頻繁に更新されるlast_updated_atカラム
-- DROP INDEX idx_last_updated ON some_table;
-- 理由：頻繁な更新によりインデックスメンテナンスコストが高い
-- 更新のたびにインデックスの再構築が必要

-- 代替案：
-- - 選択性の高いカラムと組み合わせた複合インデックス
-- - 部分インデックス（特定条件のみ）
-- - 更新頻度とクエリ頻度を比較して判断
```

## まとめ

この章では、インデックスについて詳しく学びました：

1. **インデックスの基本概念**：
   - データベースの索引としての役割
   - B-Treeインデックスの仕組み
   - パフォーマンス向上の原理

2. **インデックスの種類**：
   - 主キーインデックス（自動作成）
   - 一意インデックス
   - 単一カラムインデックス
   - 複合インデックス

3. **効果的なインデックス設計**：
   - WHERE句で使用されるカラム
   - ORDER BY句で使用されるカラム
   - JOIN条件で使用されるカラム
   - 左端一致の原則

4. **パフォーマンス分析**：
   - EXPLAIN文による実行計画の確認
   - インデックス使用状況の監視
   - クエリ最適化の手法

5. **インデックスのコスト**：
   - 挿入・更新・削除への影響
   - ストレージ使用量の増加
   - メンテナンスコスト

6. **実践的な設計例**：
   - 学校データベースでの具体例
   - クエリパターンの分析
   - 包括的なインデックス戦略

7. **ベストプラクティス**：
   - 選択性の高いカラムの優先
   - カバリングインデックスの活用
   - 不要なインデックスの削除

8. **保守と最適化**：
   - インデックスの確認方法
   - 再構築とメンテナンス
   - パフォーマンス監視

インデックスは、データベースパフォーマンスの最も重要な要素の一つです。適切に設計・管理することで、アプリケーションの応答性を大幅に改善できます。ただし、過度なインデックス作成はかえってパフォーマンスを悪化させる可能性があるため、バランスの取れた設計が重要です。

これで第5章「データ操作と管理」が完了しました。INSERT、UPDATE、DELETE文によるデータ操作から、トランザクション、ビュー、インデックスまで、データベース管理の重要な技術を体系的に学習できました。
