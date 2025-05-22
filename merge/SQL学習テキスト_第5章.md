# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [26. データ挿入：INSERT文](#26-データ挿入insert文)
2. [27. データ更新：UPDATE文](#27-データ更新update文)
3. [28. データ削除：DELETE文](#28-データ削除delete文)
4. [29. トランザクション：BEGIN、COMMIT、ROLLBACK](#29-トランザクションbegincommitrollback)
5. [30. ビュー：仮想テーブルの作成と利用](#30-ビュー仮想テーブルの作成と利用)
6. [31. インデックス：検索効率化の基本](#31-インデックス検索効率化の基本)
7. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)
8. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)
9. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)
10. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)

---


# 26. データ挿入：INSERT文

## はじめに

これまでの章では、SELECT文を中心としたデータの検索と分析について詳しく学んできました。第5章からは、データベースの操作と管理について学習します。最初に取り上げるのは「INSERT文」です。

INSERT文は、データベースのテーブルに新しいレコード（行）を追加するためのSQL文です。これまで学習で使用してきた学校データベースのサンプルデータも、すべてINSERT文によって作成されています。

INSERT文が必要となる場面の例：
- 「新しい学生が入学したので、学生情報を登録したい」
- 「新学期の講座スケジュールをまとめて登録したい」
- 「他のシステムからデータを移行したい」
- 「テスト用のサンプルデータを作成したい」
- 「ユーザーが入力したフォームデータを保存したい」

この章では、INSERT文の基本構文から、実践的な活用方法、注意点まで詳しく学んでいきます。

## INSERT文とは

INSERT文は、テーブルに新しいデータ行を追加するためのSQL文です。データベースの基本操作であるCRUD（Create、Read、Update、Delete）の「Create」に該当します。

> **用語解説**：
> - **INSERT文**：テーブルに新しいレコード（行）を挿入するSQL文です。
> - **VALUES句**：挿入する具体的な値を指定する部分です。
> - **カラムリスト**：データを挿入する対象のカラムを明示的に指定するリストです。
> - **一括挿入**：複数のレコードを一度のINSERT文で挿入することです。
> - **INSERT SELECT**：他のテーブルから取得したデータを新しいテーブルに挿入する方法です。
> - **デフォルト値**：カラムに値が指定されなかった場合に自動的に設定される値です。

## INSERT文の基本構文

### 1. 基本的なINSERT構文

```sql
INSERT INTO テーブル名 (カラム1, カラム2, カラム3, ...)
VALUES (値1, 値2, 値3, ...);
```

### 2. カラム名を省略した構文

```sql
INSERT INTO テーブル名
VALUES (値1, 値2, 値3, ...);
```

カラム名を省略する場合は、テーブル定義の順序通りにすべてのカラムに対して値を指定する必要があります。

## 基本的なINSERT文の例

### 例1：新しい学生の登録

```sql
-- カラムを明示的に指定したINSERT
INSERT INTO students (student_id, student_name)
VALUES (326, '山田太郎');
```

このクエリでは、studentsテーブルに学生ID=326、学生名='山田太郎'の新しい学生を追加しています。

### 例2：新しい教師の登録

```sql
-- すべてのカラムに値を指定
INSERT INTO teachers (teacher_id, teacher_name)
VALUES (109, '佐藤花子');
```

### 例3：新しい講座の登録

```sql
-- 一部のカラムのみに値を指定（他はNULLまたはデフォルト値）
INSERT INTO courses (course_id, course_name, teacher_id)
VALUES ('30', '新しいプログラミング講座', 109);
```

実行後の確認：

```sql
-- 挿入されたデータの確認
SELECT * FROM students WHERE student_id = 326;
SELECT * FROM teachers WHERE teacher_id = 109;
SELECT * FROM courses WHERE course_id = '30';
```

## 複数行の一括挿入

一度のINSERT文で複数のレコードを挿入することができます。これはパフォーマンスの面で効率的です。

### 例4：複数の学生を一括登録

```sql
INSERT INTO students (student_id, student_name)
VALUES 
    (327, '鈴木一郎'),
    (328, '田中美咲'),
    (329, '高橋健太'),
    (330, '伊藤愛子');
```

### 例5：複数の教室を一括登録

```sql
INSERT INTO classrooms (classroom_id, classroom_name, capacity, building, facilities)
VALUES 
    ('501A', '501A講義室', 80, '5号館', 'プロジェクター、ホワイトボード'),
    ('501B', '501Bセミナー室', 30, '5号館', 'ホワイトボード、可動式机'),
    ('502', '502コンピュータ実習室', 40, '5号館', 'PC40台、プロジェクター');
```

実行後の確認：

```sql
-- 挿入された複数のレコードを確認
SELECT * FROM students WHERE student_id BETWEEN 327 AND 330;
SELECT * FROM classrooms WHERE building = '5号館';
```

## INSERT SELECT文

他のテーブルやビューから取得したデータを新しいテーブルに挿入する場合に使用します。

### 基本構文

```sql
INSERT INTO 挿入先テーブル (カラム1, カラム2, ...)
SELECT カラム1, カラム2, ...
FROM 参照元テーブル
WHERE 条件;
```

### 例6：優秀な学生のリストを別テーブルに作成

まず、優秀な学生を格納するテーブルを作成：

```sql
-- 優秀学生テーブルの作成（実際のデータベース操作では必要）
CREATE TABLE excellent_students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(64),
    avg_score DECIMAL(5,2),
    registration_date DATE DEFAULT (CURRENT_DATE)
);
```

平均点が85点以上の学生を抽出して新しいテーブルに挿入：

```sql
INSERT INTO excellent_students (student_id, student_name, avg_score)
SELECT 
    s.student_id,
    s.student_name,
    ROUND(AVG(g.score), 2)
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(g.score) >= 85;
```

### 例7：月次出席レポートテーブルの作成

```sql
-- 月次出席レポートテーブルの作成
CREATE TABLE monthly_attendance_report (
    report_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT,
    student_name VARCHAR(64),
    month_year VARCHAR(7),
    total_classes INT,
    present_count INT,
    attendance_rate DECIMAL(5,2),
    report_date DATE DEFAULT (CURRENT_DATE)
);

-- 2025年5月の出席データを挿入
INSERT INTO monthly_attendance_report 
    (student_id, student_name, month_year, total_classes, present_count, attendance_rate)
SELECT 
    s.student_id,
    s.student_name,
    '2025-05' AS month_year,
    COUNT(a.schedule_id) AS total_classes,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS present_count,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 2) AS attendance_rate
FROM students s
JOIN attendance a ON s.student_id = a.student_id
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE cs.schedule_date BETWEEN '2025-05-01' AND '2025-05-31'
GROUP BY s.student_id, s.student_name
HAVING COUNT(a.schedule_id) > 0;
```

## NULL値とデフォルト値の扱い

### NULL値の明示的な挿入

```sql
-- NULLを明示的に指定
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason)
VALUES (101, '2025-06-01', '2025-06-03', NULL);
```

### デフォルト値の使用

```sql
-- DEFAULTキーワードを使用
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id, status)
VALUES ('1', '2025-06-10', 1, '101A', 101, DEFAULT);
```

### カラムの省略によるデフォルト値の使用

```sql
-- statusカラムを省略（デフォルト値'scheduled'が設定される）
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id)
VALUES ('1', '2025-06-11', 2, '101A', 101);
```

## 条件付きINSERT

### INSERT IGNORE

重複キーエラーを無視して挿入を続行します：

```sql
-- 既存の学生IDが存在してもエラーにしない
INSERT IGNORE INTO students (student_id, student_name)
VALUES (301, '既存学生'), (331, '新規学生');
```

### ON DUPLICATE KEY UPDATE

重複が発生した場合に更新を実行します：

```sql
-- 学生IDが重複した場合は名前を更新
INSERT INTO students (student_id, student_name)
VALUES (301, '更新された名前')
ON DUPLICATE KEY UPDATE student_name = VALUES(student_name);
```

## 実践的なINSERT例

### 例8：新学期の授業スケジュール一括登録

```sql
-- 新しい講座の登録
INSERT INTO courses (course_id, course_name, teacher_id)
VALUES ('31', 'データサイエンス応用', 106);

-- 学生の受講登録
INSERT INTO student_courses (course_id, student_id)
SELECT '31', student_id
FROM students
WHERE student_id BETWEEN 301 AND 310;

-- 授業スケジュールの登録（6月の毎週水曜日）
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id)
VALUES 
    ('31', '2025-06-04', 3, '402H', 106),
    ('31', '2025-06-11', 3, '402H', 106),
    ('31', '2025-06-18', 3, '402H', 106),
    ('31', '2025-06-25', 3, '402H', 106);
```

### 例9：出席データの一括登録

```sql
-- 特定の授業に対する出席データを一括登録
INSERT INTO attendance (schedule_id, student_id, status)
SELECT 
    cs.schedule_id,
    sc.student_id,
    CASE 
        WHEN sc.student_id % 10 = 0 THEN 'absent'
        WHEN sc.student_id % 7 = 0 THEN 'late'
        ELSE 'present'
    END AS status
FROM course_schedule cs
JOIN student_courses sc ON cs.course_id = sc.course_id
WHERE cs.schedule_date = '2025-06-04' AND cs.course_id = '31';
```

### 例10：成績データの段階的登録

```sql
-- 中間テストの成績を登録
INSERT INTO grades (student_id, course_id, grade_type, score, max_score, submission_date)
SELECT 
    sc.student_id,
    '31',
    '中間テスト',
    ROUND(70 + (RAND() * 30), 1),  -- 70-100点のランダムな点数
    100,
    '2025-06-15'
FROM student_courses sc
WHERE sc.course_id = '31';

-- レポート課題の成績を登録
INSERT INTO grades (student_id, course_id, grade_type, score, max_score, submission_date)
SELECT 
    sc.student_id,
    '31',
    'レポート1',
    ROUND(60 + (RAND() * 40), 1),  -- 60-100点のランダムな点数
    100,
    '2025-06-20'
FROM student_courses sc
WHERE sc.course_id = '31'
AND RAND() > 0.1;  -- 90%の学生が提出（10%は未提出）
```

## INSERT文のパフォーマンス考慮点

### 1. 一括挿入の活用

```sql
-- 効率的：一括挿入
INSERT INTO students (student_id, student_name)
VALUES 
    (332, '学生A'),
    (333, '学生B'),
    (334, '学生C');

-- 非効率的：個別挿入
INSERT INTO students (student_id, student_name) VALUES (332, '学生A');
INSERT INTO students (student_id, student_name) VALUES (333, '学生B');
INSERT INTO students (student_id, student_name) VALUES (334, '学生C');
```

### 2. トランザクションの使用

大量データの挿入時にはトランザクションを使用：

```sql
START TRANSACTION;

INSERT INTO students (student_id, student_name)
VALUES (335, '学生D'), (336, '学生E');

INSERT INTO student_courses (course_id, student_id)
VALUES ('1', 335), ('2', 335), ('1', 336), ('2', 336);

COMMIT;
```

### 3. インデックスへの配慮

大量データ挿入時は、一時的にインデックスを無効化することでパフォーマンスが向上する場合があります（ただし、注意が必要）。

## INSERT文のエラーと対処法

### よくあるエラーとその対処法

1. **主キー重複エラー**
```sql
-- エラー例
INSERT INTO students (student_id, student_name) VALUES (301, '重複学生');
-- エラー: Duplicate entry '301' for key 'PRIMARY'

-- 対処法1: INSERT IGNORE
INSERT IGNORE INTO students (student_id, student_name) VALUES (301, '重複学生');

-- 対処法2: ON DUPLICATE KEY UPDATE
INSERT INTO students (student_id, student_name) VALUES (301, '更新学生')
ON DUPLICATE KEY UPDATE student_name = '更新学生';
```

2. **外部キー制約エラー**
```sql
-- エラー例（存在しない教師IDを指定）
INSERT INTO courses (course_id, course_name, teacher_id) 
VALUES ('32', 'テスト講座', 999);
-- エラー: Cannot add or update a child row: a foreign key constraint fails

-- 対処法：事前に参照先の存在確認
INSERT INTO courses (course_id, course_name, teacher_id)
SELECT '32', 'テスト講座', 109
WHERE EXISTS (SELECT 1 FROM teachers WHERE teacher_id = 109);
```

3. **NULL制約エラー**
```sql
-- エラー例（NOT NULLカラムにNULLを挿入）
INSERT INTO courses (course_id, teacher_id) VALUES ('33', 101);
-- エラー: Field 'course_name' doesn't have a default value

-- 対処法：必須カラムに値を指定
INSERT INTO courses (course_id, course_name, teacher_id) 
VALUES ('33', '講座名を指定', 101);
```

## INSERT文のベストプラクティス

### 1. カラム名の明示

```sql
-- 推奨：カラム名を明示
INSERT INTO students (student_id, student_name)
VALUES (337, '新学生');

-- 非推奨：カラム名の省略（メンテナンス性が低い）
INSERT INTO students VALUES (337, '新学生');
```

### 2. データ型の適切な指定

```sql
-- 適切なデータ型での挿入
INSERT INTO grades (student_id, course_id, grade_type, score, max_score)
VALUES (301, '1', '期末テスト', 85.5, 100.0);
```

### 3. 日付データの適切な指定

```sql
-- 推奨：標準的な日付形式
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id)
VALUES ('1', '2025-06-30', 1, '101A', 101);

-- 現在日時の使用
INSERT INTO grades (student_id, course_id, grade_type, score, max_score, submission_date)
VALUES (301, '1', '追加課題', 90.0, 100.0, CURRENT_DATE);
```

## 練習問題

### 問題26-1
新しい教師「田中英子」（teacher_id = 110）を登録するINSERT文を書いてください。

### 問題26-2
以下の3人の学生を一括で登録するINSERT文を書いてください：
- 学生ID: 338, 名前: 中村太郎
- 学生ID: 339, 名前: 佐々木花音
- 学生ID: 340, 名前: 高田次郎

### 問題26-3
新しい講座「Python基礎」（course_id = '32'）を田中英子先生（teacher_id = 110）の担当で登録し、学生ID 301-305の学生をこの講座に受講登録するINSERT文を書いてください（2つのINSERT文で実現）。

### 問題26-4
INSERT SELECTを使用して、平均出席率が80%以上の学生を「high_attendance_students」テーブルに登録するINSERT文を書いてください。テーブル構造は以下の通りです：
```sql
CREATE TABLE high_attendance_students (
    student_id BIGINT,
    student_name VARCHAR(64),
    attendance_rate DECIMAL(5,2)
);
```

### 問題26-5
2025年6月の毎週月曜日（6/2, 6/9, 6/16, 6/23, 6/30）に「Python基礎」講座の授業スケジュールを登録するINSERT文を書いてください。時限は2限、教室は「501A」、担当教師は田中英子先生とします。

### 問題26-6
ON DUPLICATE KEY UPDATEを使用して、学生ID=301の学生名を「黒沢春馬（更新）」に更新するか、存在しない場合は新規登録するINSERT文を書いてください。

## 解答

### 解答26-1
```sql
INSERT INTO teachers (teacher_id, teacher_name)
VALUES (110, '田中英子');
```

### 解答26-2
```sql
INSERT INTO students (student_id, student_name)
VALUES 
    (338, '中村太郎'),
    (339, '佐々木花音'),
    (340, '高田次郎');
```

### 解答26-3
```sql
-- 新しい講座の登録
INSERT INTO courses (course_id, course_name, teacher_id)
VALUES ('32', 'Python基礎', 110);

-- 学生の受講登録
INSERT INTO student_courses (course_id, student_id)
VALUES 
    ('32', 301),
    ('32', 302),
    ('32', 303),
    ('32', 304),
    ('32', 305);
```

### 解答26-4
```sql
INSERT INTO high_attendance_students (student_id, student_name, attendance_rate)
SELECT 
    s.student_id,
    s.student_name,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 2) AS attendance_rate
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80;
```

### 解答26-5
```sql
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id)
VALUES 
    ('32', '2025-06-02', 2, '501A', 110),
    ('32', '2025-06-09', 2, '501A', 110),
    ('32', '2025-06-16', 2, '501A', 110),
    ('32', '2025-06-23', 2, '501A', 110),
    ('32', '2025-06-30', 2, '501A', 110);
```

### 解答26-6
```sql
INSERT INTO students (student_id, student_name)
VALUES (301, '黒沢春馬（更新）')
ON DUPLICATE KEY UPDATE student_name = VALUES(student_name);
```

## まとめ

この章では、INSERT文について詳しく学びました：

1. **INSERT文の基本概念**：
   - テーブルに新しいレコードを追加するSQL文
   - データベースのCRUD操作の「Create」に該当
   - 基本構文とカラム指定の方法

2. **基本的なINSERT文**：
   - 単一行の挿入
   - カラム名の明示指定と省略
   - 値の直接指定

3. **複数行の一括挿入**：
   - 複数のVALUES句による効率的な挿入
   - パフォーマンス向上のメリット

4. **INSERT SELECT文**：
   - 他のテーブルからのデータ挿入
   - 条件付きデータの移行
   - 集計結果の挿入

5. **NULL値とデフォルト値**：
   - NULL値の明示的指定
   - DEFAULTキーワードの使用
   - カラム省略によるデフォルト値の適用

6. **条件付きINSERT**：
   - INSERT IGNOREによる重複エラーの無視
   - ON DUPLICATE KEY UPDATEによる更新処理

7. **実践的な活用例**：
   - 新学期スケジュールの一括登録
   - 出席データと成績データの挿入
   - 段階的なデータ構築

8. **パフォーマンスとエラー対処**：
   - 効率的な挿入方法
   - よくあるエラーと対処法
   - ベストプラクティス

INSERT文は、データベースにデータを蓄積するための基本的で重要な操作です。適切に使用することで、効率的にデータを構築し、システムの基盤を作ることができます。

次の章では、「データ更新：UPDATE文」について学び、既存データの変更方法を理解していきます。



---

# 27. データ更新：UPDATE文

## はじめに

前章では、INSERT文を使用してデータベースに新しいデータを挿入する方法を学びました。この章では、既存のデータを変更・更新するための「UPDATE文」について学習します。

UPDATE文は、テーブル内の既存レコードの値を変更するためのSQL文で、データベースの基本操作CRUD（Create、Read、Update、Delete）の「Update」に該当します。

UPDATE文が必要となる場面の例：
- 「学生の名前に変更があったので更新したい」
- 「講座の担当教師を変更したい」
- 「成績の入力ミスを修正したい」
- 「授業のステータスを『予定』から『完了』に変更したい」
- 「一括で出席ポイントを加算したい」
- 「データクリーニングで不正な値を修正したい」

UPDATE文は非常に強力な機能ですが、誤った使用により大量のデータが意図せず変更される危険性もあります。安全な使用方法も含めて詳しく学んでいきます。

## UPDATE文とは

UPDATE文は、テーブル内の既存レコードの一部または全部のカラム値を変更するためのSQL文です。WHERE句と組み合わせることで、特定の条件に一致するレコードのみを更新できます。

> **用語解説**：
> - **UPDATE文**：既存のレコードの値を変更するSQL文です。
> - **SET句**：更新するカラム名と新しい値を指定する部分です。
> - **WHERE句**：更新対象のレコードを限定するための条件を指定します。
> - **一括更新**：複数のレコードを一度のUPDATE文で更新することです。
> - **条件付き更新**：CASE式などを使用して、条件に応じて異なる値で更新することです。
> - **結合更新**：JOINを使用して他のテーブルの情報を参照しながら更新することです。

## UPDATE文の基本構文

```sql
UPDATE テーブル名
SET カラム1 = 値1, カラム2 = 値2, ...
WHERE 条件;
```

### 重要な注意事項

**WHERE句を省略すると、テーブル内のすべてのレコードが更新されます。**これは意図しない大量更新を引き起こす可能性があるため、特に注意が必要です。

## 基本的なUPDATE文の例

### 例1：単一レコードの単一カラム更新

学生ID=301の学生名を変更：

```sql
-- 更新前の確認
SELECT student_id, student_name FROM students WHERE student_id = 301;

-- 更新実行
UPDATE students
SET student_name = '黒沢春馬（更新済み）'
WHERE student_id = 301;

-- 更新後の確認
SELECT student_id, student_name FROM students WHERE student_id = 301;
```

### 例2：複数カラムの同時更新

教室の情報を複数のカラムで同時に更新：

```sql
-- 更新前の確認
SELECT * FROM classrooms WHERE classroom_id = '101A';

-- 複数カラムの同時更新
UPDATE classrooms
SET 
    capacity = 45,
    facilities = 'PC30台、プロジェクター、ホワイトボード、エアコン'
WHERE classroom_id = '101A';

-- 更新後の確認
SELECT * FROM classrooms WHERE classroom_id = '101A';
```

### 例3：計算による更新

すべての成績に5点のボーナスポイントを加算：

```sql
-- 更新前の確認（一部のデータ）
SELECT student_id, course_id, grade_type, score 
FROM grades 
WHERE grade_type = 'レポート1' 
LIMIT 5;

-- 計算による更新
UPDATE grades
SET score = score + 5
WHERE grade_type = 'レポート1' AND score <= 95;  -- 100点を超えないように制限

-- 更新後の確認
SELECT student_id, course_id, grade_type, score 
FROM grades 
WHERE grade_type = 'レポート1' 
LIMIT 5;
```

## 条件付きUPDATE

WHERE句を使用して、特定の条件に一致するレコードのみを更新できます。

### 例4：複数条件での更新

特定の講座の特定の評価タイプの成績を更新：

```sql
-- ITのための基礎知識の中間テストで80点未満の成績を底上げ
UPDATE grades
SET score = score + 10
WHERE course_id = '1' 
  AND grade_type = '中間テスト' 
  AND score < 80;
```

### 例5：日付条件での更新

特定の日付以降の授業ステータスを更新：

```sql
-- 過去の授業を「完了」ステータスに変更
UPDATE course_schedule
SET status = 'completed'
WHERE schedule_date < CURRENT_DATE 
  AND status = 'scheduled';
```

### 例6：範囲条件での更新

学生IDの範囲を指定した更新：

```sql
-- 学生ID 301-310の学生に特別なマークを追加
UPDATE students
SET student_name = CONCAT(student_name, ' ★')
WHERE student_id BETWEEN 301 AND 310
  AND student_name NOT LIKE '%★%';  -- 既にマークがついていない場合のみ
```

## CASE式を使った条件分岐更新

CASE式を使用することで、条件に応じて異なる値で更新できます。

### 例7：成績に基づく等級の設定

成績テーブルに新しく等級カラムを追加して、点数に基づく等級を設定：

```sql
-- まず等級カラムを追加（実際の運用では必要）
-- ALTER TABLE grades ADD COLUMN grade_letter VARCHAR(2);

-- 点数に基づく等級の設定
UPDATE grades
SET grade_letter = CASE
    WHEN score >= 90 THEN 'A'
    WHEN score >= 80 THEN 'B'
    WHEN score >= 70 THEN 'C'
    WHEN score >= 60 THEN 'D'
    ELSE 'F'
END
WHERE grade_letter IS NULL OR grade_letter = '';
```

### 例8：出席状況に基づく総合評価

出席率に基づいて学生の総合評価を更新：

```sql
-- 学生テーブルに評価カラムを追加（実際の運用では必要）
-- ALTER TABLE students ADD COLUMN overall_rating VARCHAR(20);

-- 出席率に基づく総合評価の設定
UPDATE students s
SET overall_rating = CASE
    WHEN (
        SELECT AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END)
        FROM attendance a
        WHERE a.student_id = s.student_id
    ) >= 90 THEN '優秀'
    WHEN (
        SELECT AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END)
        FROM attendance a
        WHERE a.student_id = s.student_id
    ) >= 80 THEN '良好'
    WHEN (
        SELECT AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END)
        FROM attendance a
        WHERE a.student_id = s.student_id
    ) >= 70 THEN '普通'
    ELSE '要改善'
END;
```

## JOINを使ったUPDATE

他のテーブルの情報を参照しながら更新を行う場合に使用します。

### 例9：教師名に基づく講座情報の更新

教師テーブルの情報を参照して講座の説明を更新：

```sql
-- 講座テーブルに説明カラムを追加（実際の運用では必要）
-- ALTER TABLE courses ADD COLUMN description TEXT;

-- JOINを使用した更新
UPDATE courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
SET c.description = CONCAT('担当教師：', t.teacher_name, 'が指導する', c.course_name, 'の講座です。')
WHERE c.description IS NULL;
```

### 例10：平均点に基づく講座の難易度設定

各講座の平均点を基に難易度を設定：

```sql
-- 講座テーブルに難易度カラムを追加（実際の運用では必要）
-- ALTER TABLE courses ADD COLUMN difficulty_level VARCHAR(20);

-- 平均点に基づく難易度の設定
UPDATE courses c
JOIN (
    SELECT 
        course_id,
        AVG(score) as avg_score
    FROM grades
    GROUP BY course_id
) g ON c.course_id = g.course_id
SET c.difficulty_level = CASE
    WHEN g.avg_score >= 85 THEN '易しい'
    WHEN g.avg_score >= 75 THEN '標準'
    WHEN g.avg_score >= 65 THEN '難しい'
    ELSE '非常に難しい'
END;
```

## サブクエリを使ったUPDATE

### 例11：相対的な値での更新

各学生の平均点を基準とした相対評価を追加：

```sql
-- 成績テーブルに相対評価カラムを追加（実際の運用では必要）
-- ALTER TABLE grades ADD COLUMN relative_performance VARCHAR(20);

-- 学生の平均点と比較した相対評価
UPDATE grades g1
SET relative_performance = CASE
    WHEN g1.score > (
        SELECT AVG(g2.score)
        FROM grades g2
        WHERE g2.student_id = g1.student_id
    ) THEN '平均以上'
    WHEN g1.score = (
        SELECT AVG(g2.score)
        FROM grades g2
        WHERE g2.student_id = g1.student_id
    ) THEN '平均'
    ELSE '平均以下'
END;
```

### 例12：講座内順位に基づく更新

講座内での順位に基づいて特別マークを付与：

```sql
-- 成績テーブルに順位マークカラムを追加（実際の運用では必要）
-- ALTER TABLE grades ADD COLUMN rank_marker VARCHAR(10);

-- 講座内上位3位にマークを付与
UPDATE grades g1
SET rank_marker = '上位'
WHERE (
    SELECT COUNT(*)
    FROM grades g2
    WHERE g2.course_id = g1.course_id
      AND g2.grade_type = g1.grade_type
      AND g2.score > g1.score
) < 3
AND g1.grade_type = '中間テスト';
```

## NULL値の処理

### 例13：NULL値の置換

NULL値を適切なデフォルト値に置換：

```sql
-- NULLの成績を0に設定
UPDATE grades
SET score = 0
WHERE score IS NULL;

-- 空文字の評価タイプを「その他」に設定
UPDATE grades
SET grade_type = 'その他'
WHERE grade_type IS NULL OR grade_type = '';
```

### 例14：条件付きNULL設定

特定の条件下でNULLを設定：

```sql
-- 無効な成績データ（負の値や100超）をNULLに設定
UPDATE grades
SET score = NULL
WHERE score < 0 OR score > 100;
```

## 安全なUPDATE操作

### 1. 更新前の確認

```sql
-- 1. 更新対象レコードの確認
SELECT student_id, student_name 
FROM students 
WHERE student_id = 301;

-- 2. 更新実行
UPDATE students 
SET student_name = '新しい名前' 
WHERE student_id = 301;

-- 3. 更新後の確認
SELECT student_id, student_name 
FROM students 
WHERE student_id = 301;
```

### 2. 影響範囲の事前確認

```sql
-- 更新対象の件数を事前確認
SELECT COUNT(*) as update_count
FROM grades
WHERE course_id = '1' AND grade_type = '中間テスト' AND score < 70;

-- 確認後に更新実行
UPDATE grades
SET score = score + 5
WHERE course_id = '1' AND grade_type = '中間テスト' AND score < 70;
```

### 3. LIMIT句の使用（MySQLのみ）

```sql
-- 一度に更新する件数を制限
UPDATE students
SET student_name = CONCAT(student_name, ' (更新)')
WHERE student_id > 300
LIMIT 5;
```

## UPDATE文のパフォーマンス考慮点

### 1. インデックスの活用

```sql
-- WHERE句で使用するカラムにインデックスがあることを確認
-- CREATE INDEX idx_student_id ON grades(student_id);

-- インデックスを活用した効率的な更新
UPDATE grades
SET score = score + 2
WHERE student_id = 301;  -- student_idにインデックスがある場合高速
```

### 2. 大量更新時の分割実行

```sql
-- 大量データの分割更新例
UPDATE grades
SET score = LEAST(score + 3, 100)  -- 100点を超えないように制限
WHERE grade_type = 'レポート1'
  AND student_id BETWEEN 301 AND 310;  -- 範囲を限定

-- 次のバッチ
UPDATE grades
SET score = LEAST(score + 3, 100)
WHERE grade_type = 'レポート1'
  AND student_id BETWEEN 311 AND 320;
```

### 3. 効率的な結合更新

```sql
-- 効率的なJOIN UPDATE
UPDATE courses c
INNER JOIN (
    SELECT course_id, COUNT(*) as student_count
    FROM student_courses
    GROUP BY course_id
) sc ON c.course_id = sc.course_id
SET c.enrollment_count = sc.student_count;
```

## よくあるエラーと対処法

### 1. WHERE句の忘れ

```sql
-- 危険：WHERE句なし（全レコードが更新される）
-- UPDATE students SET student_name = 'テスト';

-- 安全：WHERE句あり
UPDATE students 
SET student_name = 'テスト' 
WHERE student_id = 999;  -- 存在しないIDなので実際は更新されない
```

### 2. 外部キー制約エラー

```sql
-- エラー例：存在しない教師IDに更新しようとする
-- UPDATE courses SET teacher_id = 999 WHERE course_id = '1';

-- 対処法：事前に存在確認
UPDATE courses 
SET teacher_id = 109 
WHERE course_id = '1'
  AND EXISTS (SELECT 1 FROM teachers WHERE teacher_id = 109);
```

### 3. データ型エラー

```sql
-- エラー例：文字列を数値カラムに設定
-- UPDATE grades SET score = '無効な値' WHERE grade_id = 1;

-- 対処法：適切なデータ型で更新
UPDATE grades 
SET score = 85.5 
WHERE student_id = 301 AND course_id = '1';
```

## UPDATE文のベストプラクティス

### 1. トランザクションの使用

```sql
START TRANSACTION;

-- 複数の関連する更新を実行
UPDATE students SET student_name = '更新名前' WHERE student_id = 301;
UPDATE grades SET score = score + 5 WHERE student_id = 301;

-- 問題がなければコミット
COMMIT;

-- 問題があればロールバック
-- ROLLBACK;
```

### 2. バックアップの作成

```sql
-- 重要な更新前にバックアップテーブルを作成
CREATE TABLE grades_backup AS SELECT * FROM grades;

-- 更新実行
UPDATE grades SET score = score * 1.05 WHERE grade_type = '最終評価';

-- 必要に応じて復元
-- DELETE FROM grades;
-- INSERT INTO grades SELECT * FROM grades_backup;
```

### 3. 段階的な更新

```sql
-- ステップ1：少数のレコードでテスト
UPDATE students 
SET student_name = UPPER(student_name) 
WHERE student_id = 301;

-- ステップ2：結果確認後、範囲を拡大
UPDATE students 
SET student_name = UPPER(student_name) 
WHERE student_id BETWEEN 301 AND 305;
```

## 練習問題

### 問題27-1
学生ID=302の学生名を「新垣愛留（修正版）」に更新するUPDATE文を書いてください。

### 問題27-2
「ITのための基礎知識」講座（course_id='1'）の中間テストで70点未満の成績をすべて70点に更新するUPDATE文を書いてください。

### 問題27-3
CASE式を使用して、出席テーブルの'late'（遅刻）を'present'（出席）に、'absent'（欠席）はそのまま、'present'も変更しないUPDATE文を書いてください。

### 問題27-4
JOINを使用して、各講座の受講者数を基に、20人以上の講座の名前に「【人気】」、10人未満の講座の名前に「【少人数】」の接頭辞を追加するUPDATE文を書いてください。

### 問題27-5
サブクエリを使用して、各学生の平均点が85点以上の場合に「優秀学生」、75点以上85点未満の場合に「良好学生」、それ未満の場合に「一般学生」というコメントを学生名の後に追加するUPDATE文を書いてください。

### 問題27-6
2025年5月20日より前の授業スケジュールのステータスを'completed'に、それ以降で現在日より前の授業を'ongoing'に、将来の授業は'scheduled'のままにするUPDATE文を書いてください。

## 解答

### 解答27-1
```sql
UPDATE students
SET student_name = '新垣愛留（修正版）'
WHERE student_id = 302;
```

### 解答27-2
```sql
UPDATE grades
SET score = 70
WHERE course_id = '1' 
  AND grade_type = '中間テスト' 
  AND score < 70;
```

### 解答27-3
```sql
UPDATE attendance
SET status = CASE
    WHEN status = 'late' THEN 'present'
    ELSE status
END
WHERE status = 'late';
```

### 解答27-4
```sql
UPDATE courses c
JOIN (
    SELECT 
        course_id,
        COUNT(student_id) as enrollment_count
    FROM student_courses
    GROUP BY course_id
) sc ON c.course_id = sc.course_id
SET c.course_name = CASE
    WHEN sc.enrollment_count >= 20 THEN CONCAT('【人気】', c.course_name)
    WHEN sc.enrollment_count < 10 THEN CONCAT('【少人数】', c.course_name)
    ELSE c.course_name
END
WHERE c.course_name NOT LIKE '【%】%';  -- 既に接頭辞がついていない場合のみ
```

### 解答27-5
```sql
UPDATE students s
SET student_name = CONCAT(
    s.student_name,
    CASE
        WHEN (
            SELECT AVG(score)
            FROM grades g
            WHERE g.student_id = s.student_id
        ) >= 85 THEN '（優秀学生）'
        WHEN (
            SELECT AVG(score)
            FROM grades g
            WHERE g.student_id = s.student_id
        ) >= 75 THEN '（良好学生）'
        ELSE '（一般学生）'
    END
)
WHERE EXISTS (
    SELECT 1 FROM grades g WHERE g.student_id = s.student_id
)
AND s.student_name NOT LIKE '%（%学生）';  -- 既にコメントがない場合のみ
```

### 解答27-6
```sql
UPDATE course_schedule
SET status = CASE
    WHEN schedule_date < '2025-05-20' THEN 'completed'
    WHEN schedule_date < CURRENT_DATE THEN 'ongoing'
    ELSE 'scheduled'
END
WHERE status != 'cancelled';  -- キャンセルされた授業は除外
```

## まとめ

この章では、UPDATE文について詳しく学びました：

1. **UPDATE文の基本概念**：
   - 既存レコードの値を変更するSQL文
   - SET句による値の指定
   - WHERE句による更新対象の限定

2. **基本的なUPDATE操作**：
   - 単一カラムの更新
   - 複数カラムの同時更新
   - 計算による値の更新

3. **条件付きUPDATE**：
   - WHERE句による条件指定
   - 複数条件の組み合わせ
   - 日付や範囲条件での更新

4. **CASE式を使った条件分岐更新**：
   - 条件に応じた異なる値での更新
   - 複雑な条件分岐の実現

5. **JOINを使ったUPDATE**：
   - 他のテーブルの情報を参照した更新
   - 関連データに基づく値の設定

6. **サブクエリを使ったUPDATE**：
   - 動的な条件での更新
   - 集計結果に基づく更新

7. **安全なUPDATE操作**：
   - 更新前後の確認方法
   - 影響範囲の事前チェック
   - LIMIT句による制限

8. **パフォーマンスとエラー対処**：
   - インデックスの活用
   - 大量更新時の分割実行
   - よくあるエラーの回避

9. **ベストプラクティス**：
   - トランザクションの使用
   - バックアップの作成
   - 段階的な更新アプローチ

UPDATE文は強力な機能ですが、WHERE句の忘れなどにより意図しない大量更新が発生する危険性があります。常に安全性を意識し、適切な手順で実行することが重要です。

次の章では、「データ削除：DELETE文」について学び、不要なデータを安全に削除する方法を理解していきます。



---

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



---

# 29. トランザクション：BEGIN、COMMIT、ROLLBACK

## はじめに

これまでの章で、INSERT、UPDATE、DELETE文を学び、データベースの基本的な操作方法を習得しました。しかし、実際のシステムでは、複数の操作を組み合わせて一つの処理を完成させることが多くあります。この章では、複数のSQL文をまとめて安全に実行するための「トランザクション」について学習します。

トランザクションが必要となる場面の例：
- 「学生の転校処理：旧学校からの削除と新学校への登録を同時に実行」
- 「成績の一括更新：中間テストと期末テストの成績を同時に入力」
- 「講座の開設：講座作成、教師の割り当て、教室の予約を一連の処理として実行」
- 「システム障害時の復旧：エラーが発生した場合、変更をすべて取り消し」
- 「データ移行：複数テーブルのデータを整合性を保ちながら移行」

トランザクションは、これらの複雑な処理を安全かつ確実に実行するための仕組みです。「すべて成功するか、すべて失敗するか」のいずれかを保証し、中途半端な状態を防ぎます。

## トランザクションとは

トランザクションとは、データベースに対する一連の操作をひとまとまりとして扱う仕組みです。トランザクション内のすべての操作が成功した場合のみ変更を確定し、一つでも失敗した場合はすべての変更を取り消します。

> **用語解説**：
> - **トランザクション**：データベースに対する一連の操作をひとまとまりとして扱う単位です。
> - **BEGIN/START TRANSACTION**：トランザクションの開始を宣言する文です。
> - **COMMIT**：トランザクション内の変更をデータベースに確定する文です。
> - **ROLLBACK**：トランザクション内の変更をすべて取り消す文です。
> - **オートコミット**：各SQL文が自動的にコミットされるモードです。
> - **ACID特性**：トランザクションが満たすべき4つの特性（原子性、一貫性、独立性、永続性）です。

## ACID特性

トランザクションは、以下の4つの特性（ACID特性）を満たす必要があります：

### 1. Atomicity（原子性）
トランザクション内の操作は「すべて実行されるか、まったく実行されないか」のどちらかです。部分的な実行はありません。

### 2. Consistency（一貫性）
トランザクションの実行により、データベースは一つの整合性のある状態から別の整合性のある状態に移行します。

### 3. Isolation（独立性）
複数のトランザクションが同時に実行されても、それぞれが独立して実行されているように見えます。

### 4. Durability（永続性）
コミットされたトランザクションの結果は、システム障害が発生しても永続的に保持されます。

## トランザクションの基本構文

### 基本的な構文

```sql
-- トランザクションの開始
BEGIN;
-- または
START TRANSACTION;

-- 一連のSQL文
INSERT INTO ...;
UPDATE ...;
DELETE FROM ...;

-- 成功時：変更を確定
COMMIT;

-- 失敗時：変更を取り消し
-- ROLLBACK;
```

## 基本的なトランザクションの例

### 例1：新しい学生の登録処理

新しい学生を登録し、同時に指定された講座に受講登録する処理：

```sql
-- トランザクション開始
START TRANSACTION;

-- 学生の登録
INSERT INTO students (student_id, student_name)
VALUES (341, '新入生太郎');

-- 受講登録
INSERT INTO student_courses (course_id, student_id)
VALUES 
    ('1', 341),   -- ITのための基礎知識
    ('2', 341),   -- UNIX入門
    ('7', 341);   -- AI・機械学習入門

-- 出席記録の初期化（既存の授業分）
INSERT INTO attendance (schedule_id, student_id, status)
SELECT cs.schedule_id, 341, 'absent'  -- 過去の授業は欠席扱い
FROM course_schedule cs
WHERE cs.course_id IN ('1', '2', '7')
  AND cs.schedule_date < CURRENT_DATE;

-- すべて成功した場合、変更を確定
COMMIT;

-- 確認
SELECT s.student_name, c.course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE s.student_id = 341;
```

### 例2：成績の一括更新処理

複数の評価タイプの成績を同時に更新する処理：

```sql
-- トランザクション開始
BEGIN;

-- 中間テストの成績更新
UPDATE grades 
SET score = score * 1.05  -- 5%のボーナス
WHERE course_id = '1' 
  AND grade_type = '中間テスト' 
  AND score >= 80;

-- レポート評価の成績更新
UPDATE grades 
SET score = LEAST(score + 10, 100)  -- 10点加算（上限100点）
WHERE course_id = '1' 
  AND grade_type = 'レポート1' 
  AND score >= 75;

-- 最終評価の再計算
UPDATE grades 
SET score = (
    SELECT ROUND(AVG(g2.score), 1)
    FROM grades g2
    WHERE g2.student_id = grades.student_id
      AND g2.course_id = grades.course_id
      AND g2.grade_type IN ('中間テスト', 'レポート1')
)
WHERE course_id = '1' 
  AND grade_type = '最終評価';

-- 変更を確定
COMMIT;
```

## エラー処理とROLLBACK

### 例3：エラーが発生した場合の処理

```sql
-- トランザクション開始
START TRANSACTION;

-- 教師の登録
INSERT INTO teachers (teacher_id, teacher_name)
VALUES (111, '新任教師');

-- 講座の作成
INSERT INTO courses (course_id, course_name, teacher_id)
VALUES ('33', '新講座', 111);

-- 授業スケジュールの作成
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id)
VALUES ('33', '2025-06-10', 1, '501A', 111);

-- ここで何らかのエラーが発生したとします
-- 例：存在しない教室IDを指定
-- INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id)
-- VALUES ('33', '2025-06-11', 1, '存在しない教室', 111);

-- エラーが発生した場合、すべての変更を取り消し
ROLLBACK;

-- 確認：データが挿入されていないことを確認
SELECT * FROM teachers WHERE teacher_id = 111;
SELECT * FROM courses WHERE course_id = '33';
-- 結果：0行（ROLLBACKにより挿入が取り消された）
```

## 条件付きトランザクション処理

### 例4：条件によるCOMMITとROLLBACK

```sql
DELIMITER //

CREATE PROCEDURE AddStudentWithValidation(
    IN p_student_id BIGINT,
    IN p_student_name VARCHAR(64),
    IN p_course_ids TEXT  -- カンマ区切りの講座ID
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 学生の重複チェック
    IF EXISTS (SELECT 1 FROM students WHERE student_id = p_student_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '学生IDが既に存在します';
    END IF;
    
    -- 学生の登録
    INSERT INTO students (student_id, student_name)
    VALUES (p_student_id, p_student_name);
    
    -- 講座の受講登録（講座IDが有効かチェック）
    INSERT INTO student_courses (course_id, student_id)
    SELECT course_id, p_student_id
    FROM courses
    WHERE FIND_IN_SET(course_id, p_course_ids) > 0;
    
    -- 登録された講座数をチェック
    IF (SELECT COUNT(*) FROM student_courses WHERE student_id = p_student_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '有効な講座が指定されていません';
    END IF;
    
    COMMIT;
END //

DELIMITER ;

-- プロシージャの使用例
CALL AddStudentWithValidation(342, '検証学生', '1,2,3');
```

## 複雑なトランザクションの例

### 例5：講座の統合処理

2つの講座を統合し、片方を削除する複雑な処理：

```sql
START TRANSACTION;

-- 統合前の確認
SELECT 
    '統合前' as timing,
    course_id,
    course_name,
    (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) as students
FROM courses c
WHERE course_id IN ('30', '31');

-- 講座31の学生を講座30に移動
UPDATE student_courses 
SET course_id = '30'
WHERE course_id = '31'
  AND student_id NOT IN (
      SELECT student_id FROM student_courses WHERE course_id = '30'
  );

-- 講座31の重複受講者を削除
DELETE FROM student_courses 
WHERE course_id = '31';

-- 講座31の成績を講座30に移動
UPDATE grades 
SET course_id = '30'
WHERE course_id = '31';

-- 講座31の授業スケジュールを講座30に移動
UPDATE course_schedule 
SET course_id = '30'
WHERE course_id = '31';

-- 講座31を削除
DELETE FROM courses WHERE course_id = '31';

-- 統合後の確認
SELECT 
    '統合後' as timing,
    course_id,
    course_name,
    (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) as students
FROM courses c
WHERE course_id = '30';

-- 問題がなければコミット
COMMIT;
```

## セーブポイント（SAVEPOINT）

大きなトランザクション内で部分的なロールバックを行うためにセーブポイントを使用できます。

### 例6：セーブポイントの使用

```sql
START TRANSACTION;

-- 基本データの挿入
INSERT INTO students (student_id, student_name) VALUES (343, 'セーブポイント学生');

-- セーブポイント1の設定
SAVEPOINT sp1;

-- 受講登録
INSERT INTO student_courses (course_id, student_id) VALUES ('1', 343);
INSERT INTO student_courses (course_id, student_id) VALUES ('2', 343);

-- セーブポイント2の設定
SAVEPOINT sp2;

-- 成績の初期化（この処理でエラーが発生したとします）
INSERT INTO grades (student_id, course_id, grade_type, score, max_score)
VALUES (343, '1', '中間テスト', 85, 100);

-- エラーが発生した場合、セーブポイント2まで戻る
-- ROLLBACK TO sp2;

-- または、セーブポイント1まで戻る
-- ROLLBACK TO sp1;

-- 最終的なコミット
COMMIT;
```

## トランザクション分離レベル

複数のトランザクションが同時実行される際の動作を制御します。

### 分離レベルの種類

1. **READ UNCOMMITTED**：最も低い分離レベル
2. **READ COMMITTED**：コミットされたデータのみ読取り
3. **REPEATABLE READ**：同一トランザクション内での一貫した読取り（MySQLのデフォルト）
4. **SERIALIZABLE**：最も高い分離レベル

### 例7：分離レベルの設定

```sql
-- セッション単位での分離レベル設定
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- トランザクション単位での分離レベル設定
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;
-- トランザクション処理
COMMIT;
```

## デッドロックの理解と対策

デッドロックは、複数のトランザクションが互いの完了を待って停止状態になることです。

### 例8：デッドロックが発生しやすい状況

```sql
-- セッション1
START TRANSACTION;
UPDATE students SET student_name = '更新1' WHERE student_id = 301;
-- この時点で学生301をロック

-- セッション2
START TRANSACTION;
UPDATE students SET student_name = '更新2' WHERE student_id = 302;
-- この時点で学生302をロック

-- セッション1が学生302を更新しようとする
UPDATE students SET student_name = '更新1-2' WHERE student_id = 302;
-- 待機状態（セッション2が学生302をロック中）

-- セッション2が学生301を更新しようとする
UPDATE students SET student_name = '更新2-1' WHERE student_id = 301;
-- デッドロック発生！
```

### デッドロック対策

```sql
-- 対策1：常に同じ順序でテーブルにアクセス
START TRANSACTION;
-- 常に学生IDの昇順でアクセス
UPDATE students SET student_name = '安全な更新' WHERE student_id = 301;
UPDATE students SET student_name = '安全な更新' WHERE student_id = 302;
COMMIT;

-- 対策2：トランザクションを短時間で完了させる
START TRANSACTION;
UPDATE students SET student_name = '短時間更新' WHERE student_id = 301;
COMMIT;  -- 速やかにコミット
```

## オートコミットモードの制御

### 例9：オートコミットの制御

```sql
-- 現在のオートコミット設定を確認
SELECT @@autocommit;

-- オートコミットを無効化
SET autocommit = 0;

-- 以降のSQL文は明示的にCOMMITするまで確定されない
INSERT INTO students (student_id, student_name) VALUES (344, 'オートコミットテスト');

-- 確認（まだコミットされていない）
SELECT * FROM students WHERE student_id = 344;

-- 明示的にコミット
COMMIT;

-- オートコミットを再有効化
SET autocommit = 1;
```

## トランザクションのベストプラクティス

### 1. トランザクションは短時間で

```sql
-- 良い例：短時間のトランザクション
START TRANSACTION;
UPDATE grades SET score = 85 WHERE student_id = 301 AND course_id = '1';
INSERT INTO grade_history (student_id, course_id, old_score, new_score, changed_at)
VALUES (301, '1', 80, 85, NOW());
COMMIT;

-- 悪い例：長時間のトランザクション
START TRANSACTION;
-- 大量のデータ処理や時間のかかる処理
-- 他のトランザクションをブロックしてしまう
```

### 2. 適切なエラーハンドリング

```sql
START TRANSACTION;

BEGIN
    -- メイン処理
    INSERT INTO students (student_id, student_name) VALUES (345, 'エラーハンドリング学生');
    
    -- 関連処理
    INSERT INTO student_courses (course_id, student_id) VALUES ('1', 345);
    
    COMMIT;
END;

-- エラーが発生した場合の処理
IF @@error_count > 0 THEN
    ROLLBACK;
END IF;
```

### 3. リソースの適切な管理

```sql
-- 接続プールの考慮
START TRANSACTION;

-- 必要最小限の処理のみ
UPDATE students SET student_name = '更新済み' WHERE student_id = 301;

-- 速やかにコミット
COMMIT;

-- 長時間の処理は別途実行
```

## 実践的なトランザクション例

### 例10：学期末処理の自動化

```sql
DELIMITER //

CREATE PROCEDURE EndOfSemesterProcessing()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_student_id BIGINT;
    DECLARE v_course_id VARCHAR(16);
    DECLARE v_final_score DECIMAL(5,2);
    
    DECLARE student_cursor CURSOR FOR
        SELECT DISTINCT student_id, course_id
        FROM grades
        WHERE grade_type IN ('中間テスト', 'レポート1', '課題1');
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 最終評価の計算と挿入
    OPEN student_cursor;
    
    student_loop: LOOP
        FETCH student_cursor INTO v_student_id, v_course_id;
        IF done THEN
            LEAVE student_loop;
        END IF;
        
        -- 最終スコアの計算
        SELECT AVG(score) INTO v_final_score
        FROM grades
        WHERE student_id = v_student_id 
          AND course_id = v_course_id
          AND grade_type IN ('中間テスト', 'レポート1', '課題1');
        
        -- 最終評価の挿入または更新
        INSERT INTO grades (student_id, course_id, grade_type, score, max_score, submission_date)
        VALUES (v_student_id, v_course_id, '最終評価', v_final_score, 100, CURRENT_DATE)
        ON DUPLICATE KEY UPDATE 
            score = v_final_score,
            submission_date = CURRENT_DATE;
    END LOOP;
    
    CLOSE student_cursor;
    
    -- 学期終了フラグの設定
    UPDATE course_schedule 
    SET status = 'completed'
    WHERE schedule_date <= CURRENT_DATE 
      AND status = 'scheduled';
    
    COMMIT;
END //

DELIMITER ;

-- プロシージャの実行
CALL EndOfSemesterProcessing();
```

## 練習問題

### 問題29-1
新しい教師（teacher_id=112, teacher_name='実習教師'）を登録し、同時にその教師が担当する新しい講座（course_id='34', course_name='実習講座'）を作成するトランザクションを書いてください。

### 問題29-2
学生ID=301の全成績に10%のボーナスを加算し（ただし100点を超えない）、同時に成績変更ログテーブル（grade_change_log）に変更記録を挿入するトランザクションを書いてください。

### 問題29-3
講座ID='32'を削除するために、関連するすべてのデータ（student_courses、grades、course_schedule、courses）を適切な順序で削除するトランザクションを書いてください。エラーが発生した場合はすべてロールバックしてください。

### 問題29-4
セーブポイントを使用して、学生の一括登録処理を書いてください。学生情報の登録後にセーブポイントを設定し、受講登録でエラーが発生した場合は受講登録のみをロールバックして学生情報は保持するトランザクションを作成してください。

### 問題29-5
2つの学生（student_id=301と302）の成績データを入れ替える（301の成績を302に、302の成績を301に移動）トランザクションを書いてください。一時的な学生ID（999）を使用して安全に実行してください。

### 問題29-6
出席率が70%未満の学生に対して警告フラグを設定し、同時に担当教師に通知メッセージを送信するためのデータを挿入する複合トランザクションを書いてください。

## 解答

### 解答29-1
```sql
START TRANSACTION;

-- 教師の登録
INSERT INTO teachers (teacher_id, teacher_name)
VALUES (112, '実習教師');

-- 講座の作成
INSERT INTO courses (course_id, course_name, teacher_id)
VALUES ('34', '実習講座', 112);

-- 成功時にコミット
COMMIT;

-- 確認
SELECT t.teacher_name, c.course_name
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
WHERE t.teacher_id = 112;
```

### 解答29-2
```sql
-- ログテーブルの作成（実際の運用では事前に作成）
CREATE TABLE IF NOT EXISTS grade_change_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT,
    course_id VARCHAR(16),
    grade_type VARCHAR(32),
    old_score DECIMAL(5,2),
    new_score DECIMAL(5,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

START TRANSACTION;

-- 変更前のデータをログに記録
INSERT INTO grade_change_log (student_id, course_id, grade_type, old_score, new_score)
SELECT 
    student_id,
    course_id,
    grade_type,
    score,
    LEAST(score * 1.1, 100)
FROM grades
WHERE student_id = 301;

-- 成績にボーナスを加算
UPDATE grades
SET score = LEAST(score * 1.1, 100)
WHERE student_id = 301;

COMMIT;
```

### 解答29-3
```sql
START TRANSACTION;

-- 関連データを適切な順序で削除
DELETE FROM attendance 
WHERE schedule_id IN (
    SELECT schedule_id FROM course_schedule WHERE course_id = '32'
);

DELETE FROM grades WHERE course_id = '32';

DELETE FROM student_courses WHERE course_id = '32';

DELETE FROM course_schedule WHERE course_id = '32';

DELETE FROM courses WHERE course_id = '32';

-- 削除結果の確認
SELECT COUNT(*) as remaining_courses FROM courses WHERE course_id = '32';

COMMIT;
```

### 解答29-4
```sql
START TRANSACTION;

-- 学生の登録
INSERT INTO students (student_id, student_name) VALUES (346, 'セーブポイント学生');

-- セーブポイント設定
SAVEPOINT after_student_insert;

-- 受講登録の試行
BEGIN
    INSERT INTO student_courses (course_id, student_id) VALUES ('1', 346);
    INSERT INTO student_courses (course_id, student_id) VALUES ('2', 346);
    INSERT INTO student_courses (course_id, student_id) VALUES ('存在しない講座', 346);
EXCEPTION
    WHEN OTHERS THEN
        -- 受講登録でエラーが発生した場合、セーブポイントまでロールバック
        ROLLBACK TO after_student_insert;
        -- 学生情報は保持される
END;

COMMIT;

-- 確認
SELECT * FROM students WHERE student_id = 346;
SELECT * FROM student_courses WHERE student_id = 346;
```

### 解答29-5
```sql
START TRANSACTION;

-- 一時的な学生ID（999）を使用して安全に成績を入れ替え

-- Step 1: 301の成績を一時的に999に移動
UPDATE grades SET student_id = 999 WHERE student_id = 301;

-- Step 2: 302の成績を301に移動
UPDATE grades SET student_id = 301 WHERE student_id = 302;

-- Step 3: 999の成績を302に移動
UPDATE grades SET student_id = 302 WHERE student_id = 999;

-- 入れ替え完了の確認
SELECT 
    student_id,
    course_id,
    grade_type,
    score
FROM grades
WHERE student_id IN (301, 302)
ORDER BY student_id, course_id, grade_type;

COMMIT;
```

### 解答29-6
```sql
-- 通知テーブルの作成（実際の運用では事前に作成）
CREATE TABLE IF NOT EXISTS teacher_notifications (
    notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    teacher_id BIGINT,
    student_id BIGINT,
    message TEXT,
    notification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE
);

-- 学生テーブルに警告フラグカラムを追加（実際の運用では事前に作成）
-- ALTER TABLE students ADD COLUMN warning_flag BOOLEAN DEFAULT FALSE;

START TRANSACTION;

-- 出席率が70%未満の学生に警告フラグを設定
UPDATE students s
SET warning_flag = TRUE
WHERE s.student_id IN (
    SELECT DISTINCT a.student_id
    FROM attendance a
    GROUP BY a.student_id
    HAVING AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) < 70
);

-- 担当教師への通知メッセージを作成
INSERT INTO teacher_notifications (teacher_id, student_id, message)
SELECT DISTINCT
    c.teacher_id,
    s.student_id,
    CONCAT('学生 ', s.student_name, '（ID: ', s.student_id, '）の出席率が70%を下回りました。面談が必要です。')
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE s.warning_flag = TRUE;

COMMIT;

-- 確認
SELECT 
    s.student_name,
    s.warning_flag,
    t.teacher_name,
    tn.message
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN teacher_notifications tn ON t.teacher_id = tn.teacher_id AND s.student_id = tn.student_id
WHERE s.warning_flag = TRUE;
```

## まとめ

この章では、トランザクションについて詳しく学びました：

1. **トランザクションの基本概念**：
   - 複数の操作をひとまとまりとして扱う仕組み
   - ACID特性（原子性、一貫性、独立性、永続性）
   - BEGIN/START TRANSACTION、COMMIT、ROLLBACKの使い方

2. **基本的なトランザクション操作**：
   - 学生登録と受講登録の組み合わせ
   - 成績の一括更新処理
   - エラー発生時のロールバック

3. **高度なトランザクション技術**：
   - 条件付きCOMMITとROLLBACK
   - セーブポイント（SAVEPOINT）の使用
   - 複雑な業務処理の実装

4. **同時実行制御**：
   - トランザクション分離レベル
   - デッドロックの理解と対策
   - オートコミットモードの制御

5. **実践的な応用**：
   - 学期末処理の自動化
   - データ整合性の保証
   - 複雑な業務ロジックの実装

6. **ベストプラクティス**：
   - 短時間でのトランザクション完了
   - 適切なエラーハンドリング
   - リソースの効率的な管理

トランザクションは、データベースの整合性を保つための重要な仕組みです。適切に使用することで、複雑な業務処理を安全かつ確実に実行できます。特に、複数のテーブルにまたがる処理や、エラーが発生した場合の復旧処理において、トランザクションは不可欠な機能です。

次の章では、「ビュー：仮想テーブルの作成と利用」について学び、複雑なクエリを再利用可能な形で管理する方法を理解していきます。



---

# 30. ビュー：仮想テーブルの作成と利用

## はじめに

前章では、トランザクションを使って複数の操作を安全に実行する方法を学びました。この章では、複雑なクエリを再利用可能な形で管理するための「ビュー（View）」について学習します。

ビューは、一つまたは複数のテーブルから取得したデータを「仮想的なテーブル」として定義する機能です。実際のデータを格納するわけではなく、定義されたクエリを実行して動的に結果を生成します。

ビューが役立つ場面の例：
- 「複雑な集計クエリを何度も使いたい」
- 「機密情報を含むテーブルの一部だけを見せたい」
- 「複数のテーブルを結合した結果を簡単に参照したい」
- 「異なるユーザーに異なるデータの見せ方をしたい」
- 「レポート作成用の標準的なデータ形式を提供したい」
- 「複雑なビジネスロジックを隠蔽したい」

この章では、ビューの基本概念から実践的な活用方法、パフォーマンスの考慮点まで詳しく学んでいきます。

## ビューとは

ビューは、一つまたは複数のテーブルに基づいて定義される「仮想的なテーブル」です。ビュー自体はデータを格納せず、アクセス時に定義されたクエリを実行して結果を返します。

> **用語解説**：
> - **ビュー（View）**：テーブルやその他のビューに基づいて定義される仮想的なテーブルです。
> - **仮想テーブル**：実際のデータは格納せず、クエリの実行結果として動的に生成されるテーブルです。
> - **ベーステーブル**：ビューの定義で参照される元のテーブルです。
> - **更新可能ビュー**：INSERT、UPDATE、DELETEが可能なビューです。
> - **読み取り専用ビュー**：SELECT操作のみが可能なビューです。
> - **マテリアライズドビュー**：結果を物理的に格納するビュー（MySQLでは標準サポートなし）。

## ビューの利点

### 1. セキュリティの向上
機密情報を含むテーブルの一部のカラムやレコードのみを公開できます。

### 2. クエリの簡略化
複雑な結合や集計クエリを簡単な名前で参照できます。

### 3. データの論理的な統合
複数のテーブルから関連データを統合した形で提供できます。

### 4. データの抽象化
テーブル構造の変更をビューで吸収し、アプリケーションへの影響を最小化できます。

### 5. 再利用性
よく使用されるクエリパターンを標準化できます。

## ビューの基本構文

### CREATE VIEW文

```sql
CREATE VIEW ビュー名 AS
SELECT文;
```

### ビューの参照

```sql
SELECT * FROM ビュー名;
```

### ビューの削除

```sql
DROP VIEW ビュー名;
```

## 基本的なビューの例

### 例1：学生情報の簡略ビュー

学生の基本情報のみを表示するシンプルなビュー：

```sql
-- 学生基本情報ビューの作成
CREATE VIEW student_basic_info AS
SELECT 
    student_id,
    student_name
FROM students;

-- ビューの使用
SELECT * FROM student_basic_info;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| ...        | ...          |

### 例2：講座と担当教師のビュー

講座と担当教師の情報を結合したビュー：

```sql
-- 講座詳細ビューの作成
CREATE VIEW course_details AS
SELECT 
    c.course_id,
    c.course_name,
    t.teacher_id,
    t.teacher_name,
    COUNT(sc.student_id) AS enrollment_count
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name, t.teacher_id, t.teacher_name;

-- ビューの使用
SELECT * FROM course_details 
WHERE enrollment_count > 10
ORDER BY enrollment_count DESC;
```

実行結果：

| course_id | course_name           | teacher_id | teacher_name | enrollment_count |
|-----------|----------------------|------------|--------------|------------------|
| 1         | ITのための基礎知識     | 101        | 寺内鞍       | 12               |
| 16        | データサイエンスとビジネス応用 | 106 | 星野涼子     | 11               |
| ...       | ...                  | ...        | ...          | ...              |

## 複雑なビューの例

### 例3：学生の成績サマリービュー

各学生の成績統計を表示するビュー：

```sql
CREATE VIEW student_grade_summary AS
SELECT 
    s.student_id,
    s.student_name,
    COUNT(DISTINCT g.course_id) AS courses_taken,
    COUNT(g.grade_id) AS total_grades,
    ROUND(AVG(g.score), 2) AS average_score,
    MAX(g.score) AS highest_score,
    MIN(g.score) AS lowest_score,
    CASE 
        WHEN AVG(g.score) >= 90 THEN 'A'
        WHEN AVG(g.score) >= 80 THEN 'B'
        WHEN AVG(g.score) >= 70 THEN 'C'
        WHEN AVG(g.score) >= 60 THEN 'D'
        ELSE 'F'
    END AS overall_grade
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name;

-- ビューの使用
SELECT * FROM student_grade_summary 
WHERE overall_grade IN ('A', 'B')
ORDER BY average_score DESC;
```

### 例4：出席率統計ビュー

各学生の出席状況を統計表示するビュー：

```sql
CREATE VIEW attendance_statistics AS
SELECT 
    s.student_id,
    s.student_name,
    COUNT(a.schedule_id) AS total_classes,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS present_count,
    SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS late_count,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS absent_count,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate,
    CASE 
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 95 THEN '優秀'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 85 THEN '良好'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 75 THEN '普通'
        ELSE '要改善'
    END AS attendance_status
FROM students s
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name;

-- ビューの使用
SELECT student_name, attendance_rate, attendance_status
FROM attendance_statistics 
WHERE attendance_status = '要改善'
ORDER BY attendance_rate;
```

### 例5：総合ダッシュボードビュー

成績と出席率を統合した総合評価ビュー：

```sql
CREATE VIEW student_dashboard AS
SELECT 
    sgs.student_id,
    sgs.student_name,
    sgs.average_score,
    sgs.overall_grade,
    ats.attendance_rate,
    ats.attendance_status,
    CASE 
        WHEN sgs.overall_grade IN ('A', 'B') AND ats.attendance_rate >= 85 THEN '優秀学生'
        WHEN sgs.overall_grade IN ('A', 'B', 'C') AND ats.attendance_rate >= 75 THEN '良好学生'
        WHEN sgs.overall_grade = 'F' OR ats.attendance_rate < 60 THEN '要指導学生'
        ELSE '一般学生'
    END AS student_category,
    sgs.courses_taken,
    ats.total_classes
FROM student_grade_summary sgs
LEFT JOIN attendance_statistics ats ON sgs.student_id = ats.student_id;

-- ビューの使用
SELECT 
    student_category,
    COUNT(*) as student_count,
    ROUND(AVG(average_score), 1) as avg_grade,
    ROUND(AVG(attendance_rate), 1) as avg_attendance
FROM student_dashboard
GROUP BY student_category
ORDER BY avg_grade DESC;
```

## 更新可能ビューと更新不可能ビュー

### 更新可能ビューの条件

ビューがINSERT、UPDATE、DELETEを受け付けるには、以下の条件を満たす必要があります：

1. 単一のテーブルを参照している
2. GROUP BY、HAVING、集計関数を使用していない
3. DISTINCT、UNION、サブクエリを使用していない
4. 計算カラムがない

### 例6：更新可能ビューの作成と使用

```sql
-- 更新可能ビューの作成
CREATE VIEW active_students AS
SELECT student_id, student_name
FROM students
WHERE student_id >= 300;

-- ビューを通じた挿入
INSERT INTO active_students (student_id, student_name)
VALUES (347, 'ビューテスト学生');

-- ビューを通じた更新
UPDATE active_students
SET student_name = 'ビューテスト学生（更新済み）'
WHERE student_id = 347;

-- ビューを通じた削除
DELETE FROM active_students WHERE student_id = 347;

-- 確認
SELECT * FROM active_students WHERE student_id = 347;
```

### 例7：更新不可能ビューの例

```sql
-- 更新不可能ビュー（集計関数を使用）
CREATE VIEW course_enrollment_count AS
SELECT 
    c.course_id,
    c.course_name,
    COUNT(sc.student_id) as enrollment_count
FROM courses c
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name;

-- このビューに対するUPDATEは失敗する
-- UPDATE course_enrollment_count SET enrollment_count = 10 WHERE course_id = '1';
-- エラー: The target table course_enrollment_count of the UPDATE is not updatable
```

## WITH CHECK OPTIONの使用

WHERE句を含むビューで、条件に合わないデータの挿入を防ぐために使用します。

### 例8：WITH CHECK OPTIONの使用

```sql
-- チェックオプション付きビューの作成
CREATE VIEW high_grade_students AS
SELECT student_id, student_name
FROM students
WHERE student_id IN (
    SELECT DISTINCT student_id 
    FROM grades 
    WHERE score >= 80
)
WITH CHECK OPTION;

-- このビューを通じた挿入は、条件をチェックする
-- INSERT INTO high_grade_students VALUES (999, '新学生');
-- この場合、成績が80点以上でないとエラーになる
```

## セキュリティビューの例

### 例9：機密情報を隠すビュー

教師用の学生情報ビュー（個人情報の一部を制限）：

```sql
-- 教師用学生情報ビュー（制限付き）
CREATE VIEW teacher_student_view AS
SELECT 
    s.student_id,
    LEFT(s.student_name, 1) + '**' AS masked_name,  -- 名前をマスク
    sgs.average_score,
    sgs.overall_grade,
    ats.attendance_rate
FROM students s
LEFT JOIN student_grade_summary sgs ON s.student_id = sgs.student_id
LEFT JOIN attendance_statistics ats ON s.student_id = ats.student_id;

-- 管理者用学生情報ビュー（制限なし）
CREATE VIEW admin_student_view AS
SELECT 
    s.student_id,
    s.student_name,
    sgs.average_score,
    sgs.overall_grade,
    ats.attendance_rate,
    ats.total_classes,
    sgs.courses_taken
FROM students s
LEFT JOIN student_grade_summary sgs ON s.student_id = sgs.student_id
LEFT JOIN attendance_statistics ats ON s.student_id = ats.student_id;
```

## 複雑なレポートビューの例

### 例10：月次レポートビュー

```sql
CREATE VIEW monthly_report AS
SELECT 
    DATE_FORMAT(cs.schedule_date, '%Y-%m') AS report_month,
    COUNT(DISTINCT cs.schedule_id) AS total_classes,
    COUNT(DISTINCT cs.course_id) AS active_courses,
    COUNT(DISTINCT cs.teacher_id) AS active_teachers,
    COUNT(DISTINCT a.student_id) AS attending_students,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS average_attendance_rate,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS total_attendance,
    COUNT(CASE WHEN a.status = 'absent' THEN 1 END) AS total_absences,
    COUNT(CASE WHEN a.status = 'late' THEN 1 END) AS total_late
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
WHERE cs.schedule_date >= '2025-01-01'
GROUP BY DATE_FORMAT(cs.schedule_date, '%Y-%m')
ORDER BY report_month;

-- 月次レポートの確認
SELECT * FROM monthly_report;
```

### 例11：教師パフォーマンスビュー

```sql
CREATE VIEW teacher_performance AS
SELECT 
    t.teacher_id,
    t.teacher_name,
    COUNT(DISTINCT c.course_id) AS courses_taught,
    COUNT(DISTINCT sc.student_id) AS total_students,
    ROUND(AVG(g.score), 2) AS average_student_score,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS class_attendance_rate,
    COUNT(DISTINCT cs.schedule_id) AS classes_held,
    CASE 
        WHEN AVG(g.score) >= 85 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90 THEN '優秀'
        WHEN AVG(g.score) >= 75 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80 THEN '良好'
        ELSE '標準'
    END AS performance_rating
FROM teachers t
LEFT JOIN courses c ON t.teacher_id = c.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
LEFT JOIN grades g ON c.course_id = g.course_id
LEFT JOIN course_schedule cs ON c.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY t.teacher_id, t.teacher_name;

-- 教師パフォーマンスの確認
SELECT * FROM teacher_performance 
ORDER BY performance_rating, average_student_score DESC;
```

## ビューの管理

### ビューの変更

```sql
-- ビューの定義を変更
CREATE OR REPLACE VIEW student_basic_info AS
SELECT 
    student_id,
    student_name,
    'アクティブ' AS status  -- 新しいカラムを追加
FROM students
WHERE student_id >= 300;
```

### ビューの削除

```sql
-- ビューの削除
DROP VIEW IF EXISTS student_basic_info;
```

### ビューの情報確認

```sql
-- 存在するビューの一覧
SHOW TABLES;

-- ビューの詳細情報
SHOW CREATE VIEW student_dashboard;

-- ビューの構造確認
DESCRIBE student_dashboard;
```

## ビューのパフォーマンス考慮点

### 1. 複雑なビューのパフォーマンス

```sql
-- パフォーマンスが重い可能性があるビュー
CREATE VIEW complex_student_analysis AS
SELECT 
    s.student_id,
    s.student_name,
    (SELECT AVG(score) FROM grades WHERE student_id = s.student_id) AS avg_score,
    (SELECT COUNT(*) FROM attendance WHERE student_id = s.student_id) AS total_classes,
    (SELECT COUNT(DISTINCT course_id) FROM student_courses WHERE student_id = s.student_id) AS course_count
FROM students s;

-- より効率的な書き方
CREATE VIEW efficient_student_analysis AS
SELECT 
    s.student_id,
    s.student_name,
    ROUND(AVG(g.score), 2) AS avg_score,
    COUNT(DISTINCT a.schedule_id) AS total_classes,
    COUNT(DISTINCT sc.course_id) AS course_count
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
GROUP BY s.student_id, s.student_name;
```

### 2. インデックスの重要性

ビューで使用されるベーステーブルのカラムに適切なインデックスを作成：

```sql
-- ビューのパフォーマンス向上のためのインデックス
-- CREATE INDEX idx_grades_student_id ON grades(student_id);
-- CREATE INDEX idx_attendance_student_id ON attendance(student_id);
-- CREATE INDEX idx_student_courses_student_id ON student_courses(student_id);
```

## ビューのベストプラクティス

### 1. 命名規則

```sql
-- わかりやすい命名規則を使用
CREATE VIEW v_student_summary AS        -- プレフィックス付き
SELECT ...;

CREATE VIEW student_grade_report AS     -- 用途が明確
SELECT ...;
```

### 2. ドキュメント化

```sql
-- コメント付きビューの作成
CREATE VIEW student_performance_metrics AS
-- 目的: 学生のパフォーマンス指標を統合表示
-- 作成者: 管理者
-- 作成日: 2025-05-22
-- 更新日: 2025-05-22
SELECT 
    s.student_id,
    s.student_name,
    -- 成績関連指標
    AVG(g.score) AS average_score,
    -- 出席関連指標
    AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) AS attendance_rate
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name;
```

### 3. 段階的なビュー構築

```sql
-- 基本ビュー
CREATE VIEW basic_student_info AS
SELECT student_id, student_name FROM students;

-- 拡張ビュー（基本ビューを利用）
CREATE VIEW extended_student_info AS
SELECT 
    bsi.*,
    COUNT(sc.course_id) AS course_count
FROM basic_student_info bsi
LEFT JOIN student_courses sc ON bsi.student_id = sc.student_id
GROUP BY bsi.student_id, bsi.student_name;
```

## 実践的なビュー活用例

### 例12：API用データビュー

アプリケーション向けのJSON形式データを提供するビュー：

```sql
CREATE VIEW api_student_data AS
SELECT 
    JSON_OBJECT(
        'student_id', s.student_id,
        'name', s.student_name,
        'grades', JSON_OBJECT(
            'average', ROUND(AVG(g.score), 2),
            'count', COUNT(g.grade_id)
        ),
        'attendance', JSON_OBJECT(
            'rate', ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1),
            'total_classes', COUNT(a.schedule_id)
        )
    ) AS student_data
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name;
```

## 練習問題

### 問題30-1
各講座の基本情報（講座ID、講座名、担当教師名、受講者数）を表示するビュー「course_overview」を作成してください。

### 問題30-2
学生の出席率が80%以上の学生のみを表示するビュー「good_attendance_students」を作成してください。このビューには学生ID、学生名、出席率を含めてください。

### 問題30-3
各教師について、担当講座数、総受講者数、担当講座の平均成績を表示するビュー「teacher_summary」を作成してください。

### 問題30-4
成績が85点以上の学生のみが更新可能な制限付きビュー「high_performers」を作成してください。WITH CHECK OPTIONを使用してください。

### 問題30-5
月別の授業統計（年月、実施授業数、出席者総数、平均出席率）を表示するビュー「monthly_class_stats」を作成してください。

### 問題30-6
学生、成績、出席率の情報を統合し、総合評価（S、A、B、C、D）を算出するビュー「student_comprehensive_evaluation」を作成してください。評価基準は以下の通りです：
- S: 平均点90点以上かつ出席率95%以上
- A: 平均点80点以上かつ出席率85%以上
- B: 平均点70点以上かつ出席率75%以上  
- C: 平均点60点以上かつ出席率65%以上
- D: 上記以外

## 解答

### 解答30-1
```sql
CREATE VIEW course_overview AS
SELECT 
    c.course_id,
    c.course_name,
    t.teacher_name,
    COUNT(sc.student_id) AS enrollment_count
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name, t.teacher_name;

-- 確認
SELECT * FROM course_overview ORDER BY enrollment_count DESC;
```

### 解答30-2
```sql
CREATE VIEW good_attendance_students AS
SELECT 
    s.student_id,
    s.student_name,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80;

-- 確認
SELECT * FROM good_attendance_students ORDER BY attendance_rate DESC;
```

### 解答30-3
```sql
CREATE VIEW teacher_summary AS
SELECT 
    t.teacher_id,
    t.teacher_name,
    COUNT(DISTINCT c.course_id) AS courses_taught,
    COUNT(DISTINCT sc.student_id) AS total_students,
    ROUND(AVG(g.score), 2) AS average_grade
FROM teachers t
LEFT JOIN courses c ON t.teacher_id = c.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
LEFT JOIN grades g ON c.course_id = g.course_id
GROUP BY t.teacher_id, t.teacher_name;

-- 確認
SELECT * FROM teacher_summary ORDER BY average_grade DESC;
```

### 解答30-4
```sql
CREATE VIEW high_performers AS
SELECT 
    s.student_id,
    s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT student_id
    FROM grades
    GROUP BY student_id
    HAVING AVG(score) >= 85
)
WITH CHECK OPTION;

-- 使用例（平均85点以上の学生のみ追加可能）
-- INSERT INTO high_performers VALUES (999, 'テスト学生');
```

### 解答30-5
```sql
CREATE VIEW monthly_class_stats AS
SELECT 
    DATE_FORMAT(cs.schedule_date, '%Y-%m') AS month_year,
    COUNT(DISTINCT cs.schedule_id) AS classes_held,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS total_attendance,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS average_attendance_rate
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY DATE_FORMAT(cs.schedule_date, '%Y-%m')
ORDER BY month_year;

-- 確認
SELECT * FROM monthly_class_stats;
```

### 解答30-6
```sql
CREATE VIEW student_comprehensive_evaluation AS
SELECT 
    s.student_id,
    s.student_name,
    ROUND(AVG(g.score), 2) AS average_score,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate,
    CASE 
        WHEN AVG(g.score) >= 90 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 95 THEN 'S'
        WHEN AVG(g.score) >= 80 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 85 THEN 'A'
        WHEN AVG(g.score) >= 70 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 75 THEN 'B'
        WHEN AVG(g.score) >= 60 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 65 THEN 'C'
        ELSE 'D'
    END AS comprehensive_grade
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name;

-- 確認
SELECT 
    comprehensive_grade,
    COUNT(*) as student_count,
    ROUND(AVG(average_score), 1) as avg_score,
    ROUND(AVG(attendance_rate), 1) as avg_attendance
FROM student_comprehensive_evaluation
GROUP BY comprehensive_grade
ORDER BY comprehensive_grade;
```

## まとめ

この章では、ビューについて詳しく学びました：

1. **ビューの基本概念**：
   - 仮想テーブルとしてのビューの理解
   - ベーステーブルとの関係
   - セキュリティと簡略化の利点

2. **基本的なビューの作成**：
   - CREATE VIEW文の構文
   - シンプルなビューの例
   - 複数テーブルの結合ビュー

3. **複雑なビューの活用**：
   - 集計関数を使ったビュー
   - 条件分岐を含むビュー
   - 複数ビューの組み合わせ

4. **更新可能ビュー**：
   - 更新可能な条件の理解
   - WITH CHECK OPTIONの使用
   - セキュリティ制限の実装

5. **実践的な応用**：
   - ダッシュボードビューの作成
   - レポート用ビューの構築
   - API用データビューの設計

6. **ビューの管理**：
   - ビューの変更と削除
   - 情報確認の方法
   - 適切な命名規則

7. **パフォーマンス考慮点**：
   - 効率的なビューの設計
   - インデックスの重要性
   - 複雑さとパフォーマンスのバランス

8. **ベストプラクティス**：
   - 段階的なビュー構築
   - ドキュメント化の重要性
   - 保守性の向上

ビューは、データベースの複雑さを隠蔽し、ユーザーに使いやすいインターフェースを提供する強力な機能です。適切に設計・活用することで、セキュリティの向上、開発効率の向上、保守性の向上を実現できます。

次の章では、「インデックス：検索効率化の基本」について学び、データベースのパフォーマンスを向上させる方法を理解していきます。



---

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



---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [1. SELECT基本：単一テーブルから特定カラムを取得する](#1-select基本単一テーブルから特定カラムを取得する)
2. [2. WHERE句：条件に合ったレコードを絞り込む](#2-where句条件に合ったレコードを絞り込む)
3. [3. 論理演算子：AND、OR、NOTを使った複合条件](#3-論理演算子andornotを使った複合条件)
4. [4. パターンマッチング：LIKE演算子と%、_ワイルドカード](#4-パターンマッチングlike演算子と_ワイルドカード)
5. [5. 範囲指定：BETWEEN、IN演算子](#5-範囲指定betweenin演算子)
6. [6. NULL値の処理：IS NULL、IS NOT NULL](#6-null値の処理is-nullis-not-null)
7. [7. ORDER BY：結果の並び替え](#7-order-by結果の並び替え)
8. [8. LIMIT句：結果件数の制限とページネーション](#8-limit句結果件数の制限とページネーション)

---


# 1. SELECT基本：単一テーブルから特定カラムを取得する

## はじめに

データベースからデータを取り出す作業は、料理人が大きな冷蔵庫から必要な材料だけを取り出すようなものです。SQLでは、この「取り出す」作業を「SELECT文」で行います。

SELECT文はSQLの中で最も基本的で、最もよく使われる命令です。この章では、単一のテーブル（データの表）から必要な情報だけを取り出す方法を学びます。

## 基本構文

SELECT文の最も基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名;
```

この文は「テーブル名というテーブルからカラム名という列のデータを取り出してください」という意味です。

> **用語解説**：
> - **SELECT**：「選択する」という意味のSQLコマンドで、データを取り出すときに使います。
> - **カラム**：テーブルの縦の列のことで、同じ種類のデータが並んでいます（例：名前のカラム、年齢のカラムなど）。
> - **FROM**：「〜から」という意味で、どのテーブルからデータを取るかを指定します。
> - **テーブル**：データベース内の表のことで、行と列で構成されています。

## 実践例：単一カラムの取得

学校データベースの中の「teachers」テーブル（教師テーブル）から、教師の名前だけを取得してみましょう。

```sql
SELECT teacher_name FROM teachers;
```

実行結果：

| teacher_name |
|--------------|
| 寺内鞍       |
| 田尻朋美     |
| 内村海凪     |
| 藤本理恵     |
| 黒木大介     |
| 星野涼子     |
| 深山誠一     |
| 吉岡由佳     |
| 山田太郎     |
| 佐藤花子     |
| ...          |

これは「teachers」テーブルの「teacher_name」という列（先生の名前）だけを取り出しています。

## 複数のカラムを取得する

料理に複数の材料が必要なように、データを取り出すときも複数の列が必要なことがよくあります。複数のカラムを取得するには、カラム名をカンマ（,）で区切って指定します。

```sql
SELECT カラム名1, カラム名2, カラム名3 FROM テーブル名;
```

例えば、教師の番号（ID）と名前を一緒に取得してみましょう：

```sql
SELECT teacher_id, teacher_name FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| 104        | 藤本理恵     |
| 105        | 黒木大介     |
| 106        | 星野涼子     |
| ...        | ...          |

## すべてのカラムを取得する

テーブルのすべての列を取得したい場合は、アスタリスク（*）を使います。これは「すべての列」を意味するワイルドカードです。

```sql
SELECT * FROM テーブル名;
```

例：
```sql
SELECT * FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| ...        | ...          |

> **注意**：`SELECT *`は便利ですが、実際の業務では必要なカラムだけを指定する方が良いとされています。これは、データ量が多いときに処理速度が遅くなるのを防ぐためです。

## カラムに別名をつける（AS句）

取得したカラムに分かりやすい名前（別名）をつけることができます。これは「AS」句を使います。

```sql
SELECT カラム名 AS 別名 FROM テーブル名;
```

> **用語解説**：
> - **AS**：「〜として」という意味で、カラムに別名をつけるときに使います。この別名は結果を表示するときだけ使われます。

例えば、教師IDを「番号」、教師名を「名前」として表示してみましょう：

```sql
SELECT teacher_id AS 番号, teacher_name AS 名前 FROM teachers;
```

実行結果：

| 番号  | 名前       |
|------|------------|
| 101  | 寺内鞍     |
| 102  | 田尻朋美   |
| 103  | 内村海凪   |
| ...  | ...        |

ASは省略することも可能です：

```sql
SELECT teacher_id 番号, teacher_name 名前 FROM teachers;
```

## 計算式を使う

SELECT文では、カラムの値を使った計算もできます。例えば、成績テーブルから点数と満点を取得して、達成率（パーセント）を計算してみましょう。

```sql
SELECT student_id, course_id, grade_type, 
       score, max_score,
       (score / max_score) * 100 AS 達成率
FROM grades;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 301        | 1         | 中間テスト   | 85.5  | 100.0     | 85.5     |
| 302        | 1         | 中間テスト   | 92.0  | 100.0     | 92.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

## 重複を除外する（DISTINCT）

同じ値が複数ある場合に、重複を除いて一意の値だけを表示するには「DISTINCT」キーワードを使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別された」という意味で、重複する値を除外して一意の値だけを取得します。

例えば、どの講座にどの教師が担当しているかを重複なしで確認してみましょう：

```sql
SELECT DISTINCT teacher_id FROM courses;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

これにより、courses（講座）テーブルで使われている教師IDが重複なく表示されます。

## 文字列の結合

文字列を結合するには、MySQLでは「CONCAT」関数を使います。例えば、教師のIDと名前を組み合わせて表示してみましょう：

```sql
SELECT CONCAT('教師ID:', teacher_id, ' 名前:', teacher_name) AS 教師情報
FROM teachers;
```

実行結果：

| 教師情報                  |
|--------------------------|
| 教師ID:101 名前:寺内鞍   |
| 教師ID:102 名前:田尻朋美 |
| ...                      |

> **用語解説**：
> - **CONCAT**：複数の文字列を一つにつなげる関数です。

## SELECT文と終了記号

SQLの文は通常、セミコロン（;）で終わります。これは「この命令はここで終わりです」という合図です。

複数のSQL文を一度に実行する場合は、それぞれの文の最後にセミコロンをつけます。

## 練習問題

### 問題1-1
students（学生）テーブルから、すべての学生の名前（student_name）を取得するSQLを書いてください。

### 問題1-2
classrooms（教室）テーブルから、教室ID（classroom_id）と教室名（classroom_name）を取得するSQLを書いてください。

### 問題1-3
courses（講座）テーブルから、すべての列（カラム）を取得するSQLを書いてください。

### 問題1-4
class_periods（授業時間）テーブルから、時限ID（period_id）、開始時間（start_time）、終了時間（end_time）を取得し、開始時間には「開始」、終了時間には「終了」という別名をつけるSQLを書いてください。

### 問題1-5
grades（成績）テーブルから、学生ID（student_id）、講座ID（course_id）、評価タイプ（grade_type）、得点（score）、満点（max_score）、そして得点を満点で割って100を掛けた値を「パーセント」という別名で取得するSQLを書いてください。

### 問題1-6
course_schedule（授業カレンダー）テーブルから、schedule_date（予定日）カラムだけを重複なしで取得するSQLを書いてください。

## 解答

### 解答1-1
```sql
SELECT student_name FROM students;
```

### 解答1-2
```sql
SELECT classroom_id, classroom_name FROM classrooms;
```

### 解答1-3
```sql
SELECT * FROM courses;
```

### 解答1-4
```sql
SELECT period_id, start_time AS 開始, end_time AS 終了 FROM class_periods;
```

### 解答1-5
```sql
SELECT student_id, course_id, grade_type, score, max_score,
       (score / max_score) * 100 AS パーセント
FROM grades;
```

### 解答1-6
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

## まとめ

この章では、SQLのSELECT文の基本を学びました：

1. 単一カラムの取得: `SELECT カラム名 FROM テーブル名;`
2. 複数カラムの取得: `SELECT カラム名1, カラム名2 FROM テーブル名;`
3. すべてのカラムの取得: `SELECT * FROM テーブル名;`
4. カラムに別名をつける: `SELECT カラム名 AS 別名 FROM テーブル名;`
5. 計算式を使う: `SELECT カラム名, (計算式) AS 別名 FROM テーブル名;`
6. 重複を除外する: `SELECT DISTINCT カラム名 FROM テーブル名;`
7. 文字列の結合: `SELECT CONCAT(文字列1, カラム名, 文字列2) FROM テーブル名;`

これらの基本操作を使いこなせるようになれば、データベースから必要な情報を効率よく取り出せるようになります。次の章では、WHERE句を使って条件に合ったデータだけを取り出す方法を学びます。



---

# 2. WHERE句：条件に合ったレコードを絞り込む

## はじめに

前章では、テーブルからデータを取得する基本的な方法を学びました。しかし実際の業務では、すべてのデータではなく、特定の条件に合ったデータだけを取得したいことがほとんどです。

例えば、「全生徒の情報」ではなく「特定の学科の生徒だけ」や「成績が80点以上の学生だけ」といった形で、データを絞り込みたい場合があります。

このような場合に使用するのが「WHERE句」です。WHERE句は、SELECTコマンドの後に追加して使い、条件に合致するレコード（行）だけを取得します。

## 基本構文

WHERE句の基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件式;
```

> **用語解説**：
> - **WHERE**：「〜の場所で」「〜の条件で」という意味のSQLコマンドで、条件に合うデータだけを抽出するために使います。
> - **条件式**：データが満たすべき条件を指定するための式です。例えば「age > 20」（年齢が20より大きい）などです。
> - **レコード**：テーブルの横の行のことで、1つのデータの集まりを表します。

## 基本的な比較演算子

WHERE句では、様々な比較演算子を使って条件を指定できます：

| 演算子 | 意味                   | 例                    |
|--------|------------------------|------------------------|
| =      | 等しい                 | age = 25               |
| <>     | 等しくない（≠と同じ）  | gender <> 'male'       |
| >      | より大きい             | score > 80             |
| <      | より小さい             | price < 1000           |
| >=     | 以上                   | height >= 170          |
| <=     | 以下                   | weight <= 70           |

## 実践例：基本的な条件での絞り込み

### 例1：等しい（=）
例えば、教師ID（teacher_id）が101の教師のみを取得するには：

```sql
SELECT * FROM teachers WHERE teacher_id = 101;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |

### 例2：より大きい（>）
成績（grades）テーブルから、90点を超える成績だけを取得するには：

```sql
SELECT * FROM grades WHERE score > 90;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例3：等しくない（<>）
講座IDが3ではない講座に関する成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id <> '3';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト  | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 301        | 2         | 実技試験    | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 文字列の比較

テキスト（文字列）を条件にする場合は、シングルクォーテーション（'）またはダブルクォーテーション（"）で囲みます。MySQLではどちらも使えますが、多くの場合シングルクォーテーションが推奨されます。

```sql
SELECT * FROM テーブル名 WHERE テキストカラム = 'テキスト値';
```

例えば、教師名（teacher_name）が「田尻朋美」の教師を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name = '田尻朋美';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |

## 日付の比較

日付の比較も同様にシングルクォーテーションで囲みます。日付の形式はデータベースの設定によって異なりますが、一般的にはISO形式（YYYY-MM-DD）が使われます。

```sql
SELECT * FROM テーブル名 WHERE 日付カラム = '日付';
```

例えば、2025年5月20日に提出された成績を検索するには：

```sql
SELECT * FROM grades WHERE submission_date = '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

また、日付同士の大小関係も比較できます：

```sql
SELECT * FROM grades WHERE submission_date < '2025-05-15';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | レポート1   | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1   | 48.0  | 50.0      | 2025-05-10      |
| 304        | 5         | ER図作成課題 | 27.5  | 30.0      | 2025-05-14      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 複数の条件を指定する（次章の内容）

WHERE句では、複数の条件を組み合わせることもできます。この詳細は次章「論理演算子：AND、OR、NOTを使った複合条件」で説明します。

例えば、講座IDが1で、かつ、得点が90以上の成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id = '1' AND score >= 90;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題2-1
students（学生）テーブルから、学生ID（student_id）が「310」の学生情報を取得するSQLを書いてください。

### 問題2-2
classrooms（教室）テーブルから、収容人数（capacity）が30人より多い教室の情報をすべて取得するSQLを書いてください。

### 問題2-3
courses（講座）テーブルから、教師ID（teacher_id）が「105」の講座情報を取得するSQLを書いてください。

### 問題2-4
course_schedule（授業カレンダー）テーブルから、「2025-05-15」の授業スケジュールをすべて取得するSQLを書いてください。

### 問題2-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」で、得点（score）が80点未満の成績を取得するSQLを書いてください。

### 問題2-6
teachers（教師）テーブルから、教師ID（teacher_id）が「101」ではない教師の名前を取得するSQLを書いてください。

## 解答

### 解答2-1
```sql
SELECT * FROM students WHERE student_id = 310;
```

### 解答2-2
```sql
SELECT * FROM classrooms WHERE capacity > 30;
```

### 解答2-3
```sql
SELECT * FROM courses WHERE teacher_id = 105;
```

### 解答2-4
```sql
SELECT * FROM course_schedule WHERE schedule_date = '2025-05-15';
```

### 解答2-5
```sql
SELECT * FROM grades WHERE grade_type = '中間テスト' AND score < 80;
```

### 解答2-6
```sql
SELECT teacher_name FROM teachers WHERE teacher_id <> 101;
```

## まとめ

この章では、WHERE句を使って条件に合ったレコードを取得する方法を学びました：

1. 基本的な比較演算子（=, <>, >, <, >=, <=）の使い方
2. 数値による条件絞り込み
3. 文字列（テキスト）による条件絞り込み
4. 日付による条件絞り込み

WHERE句は、大量のデータから必要な情報だけを取り出すための非常に重要な機能です。実際のデータベース操作では、この条件絞り込みを頻繁に使います。

次の章では、複数の条件を組み合わせるための「論理演算子（AND、OR、NOT）」について学びます。



---

# 3. 論理演算子：AND、OR、NOTを使った複合条件

## はじめに

前章では、WHERE句を使って単一の条件でデータを絞り込む方法を学びました。しかし実際の業務では、より複雑な条件でデータを絞り込む必要があることがよくあります。

例えば：
- 「成績が80点以上**かつ**出席率が90%以上の学生」
- 「数学**または**英語の成績が優秀な学生」
- 「課題を**まだ提出していない**学生」

このような複合条件を指定するために使うのが論理演算子です。主な論理演算子は次の3つです：

- **AND**：両方の条件を満たす（かつ）
- **OR**：いずれかの条件を満たす（または）
- **NOT**：条件を満たさない（〜ではない）

## AND演算子

AND演算子は、指定した**すべての条件を満たす**レコードだけを取得したいときに使います。

> **用語解説**：
> - **AND**：「かつ」「そして」という意味の論理演算子です。複数の条件をすべて満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 AND 条件2;
```

### 例：ANDを使った複合条件

例えば、中間テストで90点以上かつ満点が100点の成績レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

この例では、「score >= 90」と「max_score = 100」の両方の条件を満たすレコードだけが取得されます。

### 3つ以上の条件の組み合わせ

ANDを使って3つ以上の条件を組み合わせることもできます：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100 AND grade_type = '中間テスト';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## OR演算子

OR演算子は、指定した条件の**いずれか一つでも満たす**レコードを取得したいときに使います。

> **用語解説**：
> - **OR**：「または」「もしくは」という意味の論理演算子です。複数の条件のうち少なくとも1つを満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 OR 条件2;
```

### 例：ORを使った複合条件

例えば、教師IDが101または102の講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id = 101 OR teacher_id = 102;
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 2         | UNIX入門             | 102        |
| 3         | Cプログラミング演習    | 101        |
| 29        | コードリファクタリングとクリーンコード | 101 |
| 40        | ソフトウェアアーキテクチャパターン | 102 |
| ...       | ...                  | ...        |

この例では、「teacher_id = 101」または「teacher_id = 102」のいずれかの条件を満たすレコードが取得されます。

## NOT演算子

NOT演算子は、指定した条件を**満たさない**レコードを取得したいときに使います。

> **用語解説**：
> - **NOT**：「〜ではない」という意味の論理演算子です。条件を否定して、その条件を満たさないデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE NOT 条件;
```

### 例：NOTを使った否定条件

例えば、完了（completed）状態ではない授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
WHERE NOT status = 'completed';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 45          | 11        | 2025-05-20    | 5         | 401G         | 106        | scheduled |
| 46          | 12        | 2025-05-21    | 1         | 301E         | 107        | scheduled |
| 50          | 2         | 2025-05-23    | 3         | 101A         | 102        | cancelled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

この例では、statusが「completed」ではないレコード（scheduled状態やcancelled状態）が取得されます。

NOT演算子は、「〜ではない」という否定の条件を作るために使われます。例えば次の2つの書き方は同じ意味になります：

```sql
SELECT * FROM teachers WHERE NOT teacher_id = 101;
SELECT * FROM teachers WHERE teacher_id <> 101;
```

## 複合論理条件（AND、OR、NOTの組み合わせ）

AND、OR、NOTを組み合わせて、より複雑な条件を指定することもできます。

### 例：ANDとORの組み合わせ

例えば、「成績が90点以上で中間テストである」または「成績が45点以上でレポートである」レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE (score >= 90 AND grade_type = '中間テスト') 
   OR (score >= 45 AND grade_type = 'レポート1');
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 308        | 1         | レポート1  | 47.0  | 50.0      | 2025-05-09      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 優先順位と括弧の使用

論理演算子を組み合わせる場合、演算子の優先順位に注意が必要です。基本的に**ANDはORよりも優先順位が高い**です。つまり、ANDが先に処理されます。

例えば：
```sql
WHERE 条件1 OR 条件2 AND 条件3
```

これは次のように解釈されます：
```sql
WHERE 条件1 OR (条件2 AND 条件3)
```

意図した条件と異なる場合は、**括弧（）を使って明示的にグループ化**することが重要です：
```sql
WHERE (条件1 OR 条件2) AND 条件3
```

### 例：括弧を使った条件のグループ化

教師IDが101または102で、かつ、講座名に「プログラミング」という単語が含まれる講座を取得するには：

```sql
SELECT * FROM courses 
WHERE (teacher_id = 101 OR teacher_id = 102) 
  AND course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

この例では、括弧を使って「teacher_id = 101 OR teacher_id = 102」の部分をグループ化し、その条件と「course_name LIKE '%プログラミング%'」の条件をANDで結合しています。

## 練習問題

### 問題3-1
grades（成績）テーブルから、課題タイプ（grade_type）が「中間テスト」かつ点数（score）が85点以上のレコードを取得するSQLを書いてください。

### 問題3-2
classrooms（教室）テーブルから、収容人数（capacity）が40人以下または建物（building）が「1号館」の教室を取得するSQLを書いてください。

### 問題3-3
teachers（教師）テーブルから、教師ID（teacher_id）が101、102、103ではない教師の情報を取得するSQLを書いてください。

### 問題3-4
course_schedule（授業カレンダー）テーブルから、2025年5月20日の授業で、時限（period_id）が1か2で、かつ状態（status）が「scheduled」の授業を取得するSQLを書いてください。

### 問題3-5
students（学生）テーブルから、学生名（student_name）に「田」または「山」を含む学生を取得するSQLを書いてください。

### 問題3-6
grades（成績）テーブルから、提出日（submission_date）が2025年5月15日以降で、かつ（「中間テスト」で90点以上または「レポート1」で45点以上）の成績を取得するSQLを書いてください。

## 解答

### 解答3-1
```sql
SELECT * FROM grades 
WHERE grade_type = '中間テスト' AND score >= 85;
```

### 解答3-2
```sql
SELECT * FROM classrooms 
WHERE capacity <= 40 OR building = '1号館';
```

### 解答3-3
```sql
SELECT * FROM teachers 
WHERE NOT (teacher_id = 101 OR teacher_id = 102 OR teacher_id = 103);
```
または
```sql
SELECT * FROM teachers 
WHERE teacher_id <> 101 AND teacher_id <> 102 AND teacher_id <> 103;
```

### 解答3-4
```sql
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-20' 
  AND (period_id = 1 OR period_id = 2) 
  AND status = 'scheduled';
```

### 解答3-5
```sql
SELECT * FROM students 
WHERE student_name LIKE '%田%' OR student_name LIKE '%山%';
```

### 解答3-6
```sql
SELECT * FROM grades 
WHERE submission_date >= '2025-05-15' 
  AND ((grade_type = '中間テスト' AND score >= 90) 
       OR (grade_type = 'レポート1' AND score >= 45));
```

## まとめ

この章では、論理演算子（AND、OR、NOT）を使って複合条件を作る方法を学びました：

1. **AND**：すべての条件を満たすレコードを取得（条件1 AND 条件2）
2. **OR**：いずれかの条件を満たすレコードを取得（条件1 OR 条件2）
3. **NOT**：指定した条件を満たさないレコードを取得（NOT 条件）
4. **複合条件**：AND、OR、NOTを組み合わせたより複雑な条件
5. **括弧（）**：条件をグループ化して優先順位を明示的に指定

これらの論理演算子を使いこなすことで、より複雑で細かな条件でデータを絞り込むことができるようになります。実際のデータベース操作では、複数の条件を組み合わせることが頻繁にあるため、この章で学んだ内容は非常に重要です。

次の章では、テキストデータに対する検索を行う「パターンマッチング」について学びます。



---

# 4. パターンマッチング：LIKE演算子と%、_ワイルドカード

## はじめに

前章までは、データの完全一致や数値の比較といった条件での絞り込みを学びました。しかし実際の業務では、もっと柔軟な検索が必要なケースがあります。例えば：

- 「山」で始まる名前の学生を検索したい
- 「プログラミング」という単語を含む講座名を探したい
- 電話番号の一部だけ覚えているデータを探したい

このような「部分一致」や「パターン一致」の検索を行うためのSQLの機能が「パターンマッチング」です。この章では、パターンマッチングを行うための「LIKE演算子」と「ワイルドカード文字」について学びます。

## LIKE演算子の基本

LIKE演算子は、文字列のパターンマッチングを行うための演算子です。WHERE句と組み合わせて使用します。

> **用語解説**：
> - **LIKE**：「〜のような」という意味の演算子で、パターンに一致する文字列を検索します。
> - **パターンマッチング**：完全一致ではなく、一定のパターンに合致するデータを検索する方法です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 文字列カラム LIKE 'パターン';
```

パターンには、通常の文字に加えて、特別な意味を持つ「ワイルドカード文字」を使用できます。

## ワイルドカード文字

SQLでは主に2つのワイルドカード文字があります：

1. **%（パーセント）**：0文字以上の任意の文字列に一致します。
2. **_（アンダースコア）**：任意の1文字に一致します。

> **用語解説**：
> - **ワイルドカード**：任意の文字や文字列に一致する特殊な文字記号です。トランプのジョーカーのように、様々な値に代用できます。

## LIKE演算子の使い方：実践例

### 例1：%（パーセント）を使ったパターンマッチング

#### 「〜で始まる」パターン：前方一致

例えば、「山」で始まる学生名を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '山%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 山本裕子     |
| 325        | 山田翔太     |
| ...        | ...          |

ここでの「山%」は「山で始まり、その後に0文字以上の任意の文字が続く」という意味です。

#### 「〜で終わる」パターン：後方一致

例えば、「子」で終わる教師名を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name LIKE '%子';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| 106        | 星野涼子     |
| 108        | 吉岡由佳     |
| 110        | 佐藤花子     |
| ...        | ...          |

#### 「〜を含む」パターン：部分一致

例えば、「プログラミング」という単語を含む講座名を検索するには：

```sql
SELECT * FROM courses WHERE course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| 14        | IoTデバイスプログラミング実践 | 110 |
| ...       | ...                  | ...        |

### 例2：_（アンダースコア）を使ったパターンマッチング

アンダースコアは任意の1文字に一致します。例えば、教室IDが「10_A」パターン（最初の2文字が「10」、3文字目が任意の1文字、最後が「A」）の教室を検索するには：

```sql
SELECT * FROM classrooms WHERE classroom_id LIKE '10_A';
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| ...          | ...            | ...      | ...      | ...        |

### 例3：%と_の組み合わせ

ワイルドカード文字は組み合わせて使うこともできます。例えば、「2文字目が田」の学生を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '_田%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 384        | 櫻井翼       |
| ...        | ...          |

## NOT LIKEを使った否定形のパターンマッチング

特定のパターンに一致しないレコードを検索したい場合は、「NOT LIKE」を使います。

> **用語解説**：
> - **NOT LIKE**：「〜のパターンに一致しない」という意味で、指定したパターンに一致しないデータを検索します。

例えば、講座名に「入門」を含まない講座を検索するには：

```sql
SELECT * FROM courses WHERE course_name NOT LIKE '%入門%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

## エスケープ文字の使用

もし検索したいパターンに「%」や「_」自体が含まれている場合は、それらを特別な文字としてではなく、通常の文字として扱うために「エスケープ文字」を使います。

> **用語解説**：
> - **エスケープ文字**：特別な意味を持つ文字を通常の文字として扱うための印です。

MySQLでは、バックスラッシュ（\）をエスケープ文字として使用できます。例えば、「50%」という値そのものを検索するには：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50\%';
```

または、ESCAPE句を使って明示的にエスケープ文字を指定することもできます：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50!%' ESCAPE '!';
```

この例では「!」をエスケープ文字として指定しています。

## 大文字と小文字の区別

MySQLのデフォルト設定では、LIKE演算子は大文字と小文字を区別しません（大文字小文字を同じものとして扱います）。

例えば、次の2つのクエリは同じ結果を返します：

```sql
SELECT * FROM courses WHERE course_name LIKE '%web%';
SELECT * FROM courses WHERE course_name LIKE '%Web%';
```

もし大文字と小文字を区別した検索が必要な場合は、「BINARY」キーワードを使用します：

```sql
SELECT * FROM courses WHERE course_name LIKE BINARY '%Web%';
```

この場合、「Web」は「web」とは一致しません。

## 複合条件との組み合わせ

LIKE演算子は、これまで学んだAND、OR、NOTなどの論理演算子と組み合わせて使うこともできます。

例えば、「田」で始まる名前で、かつ教師IDが102から105の間の教師を検索するには：

```sql
SELECT * FROM teachers 
WHERE teacher_name LIKE '田%' 
  AND teacher_id BETWEEN 102 AND 105;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| ...        | ...          |

## 練習問題

### 問題4-1
students（学生）テーブルから、学生名（student_name）が「佐藤」で始まる学生の情報をすべて取得するSQLを書いてください。

### 問題4-2
courses（講座）テーブルから、講座名（course_name）に「データ」という単語を含む講座の情報を取得するSQLを書いてください。

### 問題4-3
classrooms（教室）テーブルから、教室名（classroom_name）が「コンピュータ実習室」で終わる教室の情報を取得するSQLを書いてください。

### 問題4-4
teachers（教師）テーブルから、教師名（teacher_name）の2文字目が「木」である教師の情報を取得するSQLを書いてください。

### 問題4-5
courses（講座）テーブルから、講座名（course_name）に「入門」または「基礎」を含む講座を取得するSQLを書いてください。

### 問題4-6
students（学生）テーブルから、学生名（student_name）が「山」で始まり、かつ「子」で終わらない学生を取得するSQLを書いてください。

## 解答

### 解答4-1
```sql
SELECT * FROM students WHERE student_name LIKE '佐藤%';
```

### 解答4-2
```sql
SELECT * FROM courses WHERE course_name LIKE '%データ%';
```

### 解答4-3
```sql
SELECT * FROM classrooms WHERE classroom_name LIKE '%コンピュータ実習室';
```

### 解答4-4
```sql
SELECT * FROM teachers WHERE teacher_name LIKE '_木%';
```

### 解答4-5
```sql
SELECT * FROM courses 
WHERE course_name LIKE '%入門%' OR course_name LIKE '%基礎%';
```

### 解答4-6
```sql
SELECT * FROM students 
WHERE student_name LIKE '山%' AND student_name NOT LIKE '%子';
```

## まとめ

この章では、パターンマッチングを行うためのLIKE演算子と、その中で使用するワイルドカード文字（%と_）について学びました：

1. **LIKE演算子**：文字列パターンに一致するデータを検索するための演算子
2. **%（パーセント）**：0文字以上の任意の文字列に一致するワイルドカード
3. **_（アンダースコア）**：任意の1文字に一致するワイルドカード
4. **前方一致**：「パターン%」で「パターンで始まる」文字列に一致
5. **後方一致**：「%パターン」で「パターンで終わる」文字列に一致
6. **部分一致**：「%パターン%」で「パターンを含む」文字列に一致
7. **NOT LIKE**：指定したパターンに一致しないデータを検索
8. **エスケープ文字**：特殊文字（%や_）を通常の文字として扱うための方法
9. **複合条件との組み合わせ**：AND、ORなどと組み合わせたより複雑な条件

パターンマッチングは、特にテキストデータを扱う際に非常に便利な機能です。部分的な情報しか持っていない場合や、特定のパターンを持つデータを探す場合に活用できます。

次の章では、範囲指定のための「BETWEEN演算子」と「IN演算子」について学びます。



---

# 5. 範囲指定：BETWEEN、IN演算子

## はじめに

これまでの章では、等号（=）や不等号（>、<）を使って条件を指定する方法や、LIKE演算子を使ったパターンマッチングを学びました。この章では、値の範囲を指定する「BETWEEN演算子」と、複数の値を一度に指定できる「IN演算子」について学びます。

これらの演算子を使うと、次のような検索がより簡単になります：
- 「80点から90点の間の成績」
- 「2025年4月から6月の間のスケジュール」
- 「特定の教師IDリストに該当する講座」

## BETWEEN演算子：範囲を指定する

BETWEEN演算子は、ある値が指定した範囲内にあるかどうかを調べるために使います。

> **用語解説**：
> - **BETWEEN**：「〜の間に」という意味の演算子で、ある値が指定した最小値と最大値の間（両端の値を含む）にあるかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 BETWEEN 最小値 AND 最大値;
```

この構文は次の条件と同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 >= 最小値 AND カラム名 <= 最大値;
```

### 例1：数値範囲の指定

例えば、成績（grades）テーブルから、80点から90点の間の成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 308        | 6         | 小テスト1  | 89.0  | 100.0     | 2025-05-15      |
| ...        | ...       | ...        | ...   | ...       | ...             |

### 例2：日付範囲の指定

日付にもBETWEEN演算子が使えます。例えば、2025年5月10日から2025年5月20日までに提出された成績を取得するには：

```sql
SELECT * FROM grades 
WHERE submission_date BETWEEN '2025-05-10' AND '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | レポート1  | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## NOT BETWEEN：範囲外を指定する

NOT BETWEENを使うと、指定した範囲の外にある値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT BETWEEN 最小値 AND 最大値;
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 < 最小値 OR カラム名 > 最大値;
```

### 例：範囲外の値を取得

例えば、80点未満または90点より高い成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score NOT BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## IN演算子：複数の値を指定する

IN演算子は、ある値が指定した複数の値のリストのいずれかに一致するかどうかを調べるために使います。

> **用語解説**：
> - **IN**：「〜の中に含まれる」という意味の演算子で、ある値が指定したリストの中に含まれているかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (値1, 値2, 値3, ...);
```

この構文は次のOR条件の組み合わせと同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 = 値1 OR カラム名 = 値2 OR カラム名 = 値3 OR ...;
```

### 例1：数値リストの指定

例えば、教師ID（teacher_id）が101、103、105のいずれかである講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (101, 103, 105);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| 5         | データベース設計と実装  | 105        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

### 例2：文字列リストの指定

文字列のリストにも適用できます。例えば、特定の教室ID（classroom_id）のみの教室情報を取得するには：

```sql
SELECT * FROM classrooms 
WHERE classroom_id IN ('101A', '202D', '301E');
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| 202D         | 2号館コンピュータ実習室D | 25     | 2号館     | パソコン25台、プロジェクター、3Dプリンター |
| 301E         | 3号館講義室E      | 80       | 3号館     | プロジェクター、マイク設備、録画設備 |

## NOT IN：リストに含まれない値を指定する

NOT IN演算子を使うと、指定したリストに含まれない値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT IN (値1, 値2, 値3, ...);
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 <> 値1 AND カラム名 <> 値2 AND カラム名 <> 値3 AND ...;
```

### 例：リストに含まれない値を取得

例えば、教師IDが101、102、103以外の教師が担当する講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id NOT IN (101, 102, 103);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 4         | Webアプリケーション開発 | 104        |
| 5         | データベース設計と実装  | 105        |
| 6         | ネットワークセキュリティ | 107        |
| ...       | ...                  | ...        |

## IN演算子でのサブクエリの利用（基本）

IN演算子の括弧内には、直接値を書く代わりに、サブクエリ（別のSELECT文）を指定することもできます。これにより、動的に値のリストを生成できます。

> **用語解説**：
> - **サブクエリ**：SQL文の中に含まれる別のSQL文のことで、外側のSQL文（メインクエリ）に値や条件を提供します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (SELECT カラム名 FROM 別テーブル WHERE 条件);
```

### 例：サブクエリを使ったIN条件

例えば、教師名（teacher_name）に「田」を含む教師が担当している講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (
    SELECT teacher_id FROM teachers 
    WHERE teacher_name LIKE '%田%'
);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 2         | UNIX入門             | 102        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

この例では、まず「teachers」テーブルから名前に「田」を含む教師のIDを取得し、それらのIDを持つ講座を「courses」テーブルから取得しています。

## BETWEEN演算子とIN演算子の組み合わせ

BETWEEN演算子とIN演算子は、論理演算子（AND、OR）と組み合わせて、さらに複雑な条件を作ることができます。

### 例：BETWEENとINの組み合わせ

例えば、「教師IDが101、103、105のいずれかで、かつ、2025年5月15日から2025年6月15日の間に実施される授業」を取得するには：

```sql
SELECT * FROM course_schedule 
WHERE teacher_id IN (101, 103, 105) 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-06-15';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 38          | 1         | 2025-05-20    | 1         | 102B         | 101        | scheduled |
| 42          | 10        | 2025-05-23    | 3         | 201C         | 103        | scheduled |
| 45          | 5         | 2025-05-28    | 2         | 402H         | 105        | scheduled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

## 練習問題

### 問題5-1
grades（成績）テーブルから、得点（score）が85点から95点の間にある成績を取得するSQLを書いてください。

### 問題5-2
course_schedule（授業カレンダー）テーブルから、2025年5月1日から2025年5月31日までの授業スケジュールを取得するSQLを書いてください。

### 問題5-3
courses（講座）テーブルから、教師ID（teacher_id）が104、106、108のいずれかである講座の情報を取得するSQLを書いてください。

### 問題5-4
classrooms（教室）テーブルから、教室ID（classroom_id）が「101A」、「201C」、「301E」、「401G」以外の教室情報を取得するSQLを書いてください。

### 問題5-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」または「実技試験」で、かつ得点（score）が80点から90点の間にない成績を取得するSQLを書いてください。

### 問題5-6
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）が「101A」、「202D」のいずれかで、かつ2025年5月15日から2025年5月30日の間に実施される授業スケジュールを取得するSQLを書いてください。

## 解答

### 解答5-1
```sql
SELECT * FROM grades 
WHERE score BETWEEN 85 AND 95;
```

### 解答5-2
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

### 解答5-3
```sql
SELECT * FROM courses 
WHERE teacher_id IN (104, 106, 108);
```

### 解答5-4
```sql
SELECT * FROM classrooms 
WHERE classroom_id NOT IN ('101A', '201C', '301E', '401G');
```

### 解答5-5
```sql
SELECT * FROM grades 
WHERE grade_type IN ('中間テスト', '実技試験') 
  AND score NOT BETWEEN 80 AND 90;
```

### 解答5-6
```sql
SELECT * FROM course_schedule 
WHERE classroom_id IN ('101A', '202D') 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-05-30';
```

## まとめ

この章では、範囲指定のための「BETWEEN演算子」と複数値指定のための「IN演算子」について学びました：

1. **BETWEEN演算子**：値が指定した範囲内（両端を含む）にあるかどうかをチェック
2. **NOT BETWEEN**：値が指定した範囲外にあるかどうかをチェック
3. **IN演算子**：値が指定したリストのいずれかに一致するかどうかをチェック
4. **NOT IN**：値が指定したリストのいずれにも一致しないかどうかをチェック
5. **サブクエリとIN**：動的に生成された値のリストを使用する方法
6. **複合条件**：BETWEEN、IN、論理演算子を組み合わせたより複雑な条件

これらの演算子を使うことで、複数の条件を指定する場合に、SQLをより簡潔に書くことができます。特に、多くの値を指定する場合や範囲条件を指定する場合に便利です。

次の章では、「NULL値の処理：IS NULL、IS NOT NULL」について学びます。



---

# 6. NULL値の処理：IS NULL、IS NOT NULL

## はじめに

データベースの世界では、データがない状態を表すために「NULL」という特別な値が使われます。NULLは「空」や「0」や「空白文字」とは異なる、「値が存在しない」または「不明」であることを表す特殊な概念です。

例えば、学校データベースでは次のようなシナリオがあります：
- まだ成績が付けられていない（NULL）
- コメントが入力されていない（NULL）
- 授業がキャンセルされたため教室が割り当てられていない（NULL）

この章では、NULL値を正しく処理するための「IS NULL」と「IS NOT NULL」演算子について学びます。

## NULLとは何か？

NULL値には、いくつかの特徴があります：

1. **値がない**：NULLは値がないことを表します。0でも空文字列（''）でもなく、値そのものが存在しないことを示します。
2. **不明**：データが不明であることを表す場合もあります。
3. **未設定**：まだ値が設定されていないことを表す場合もあります。
4. **比較できない**：NULLは通常の比較演算子（=, <, >など）で比較できません。

> **用語解説**：
> - **NULL**：データベースにおいて「値がない」または「不明」を表す特殊な値です。0や空文字とは異なります。

## NULL値と通常の比較演算子

通常の比較演算子（=, <>, >, <, >=, <=）では、NULL値を正しく検出できません。例えば：

```sql
-- この条件はNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 = NULL;

-- この条件もNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 <> NULL;
```

これは、NULL値との等価比較は「不明」と評価されるためです。つまり、NULL = NULLでさえFALSEではなく「不明」になります。

## IS NULL演算子

NULL値を持つレコードを検索するには、「IS NULL」演算子を使います。

> **用語解説**：
> - **IS NULL**：カラムの値がNULLかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NULL;
```

### 例：IS NULLの使用

例えば、コメントが入力されていない（NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

実行結果：

| schedule_id | student_id | status  | comment |
|-------------|------------|---------|---------|
| 1           | 301        | present | NULL    |
| 1           | 306        | present | NULL    |
| 1           | 307        | present | NULL    |
| ...         | ...        | ...     | NULL    |

## IS NOT NULL演算子

逆に、NULL値を持たないレコード（つまり、何らかの値を持つレコード）を検索するには、「IS NOT NULL」演算子を使います。

> **用語解説**：
> - **IS NOT NULL**：カラムの値がNULLでないかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NOT NULL;
```

### 例：IS NOT NULLの使用

例えば、コメントが入力されている（NOT NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 302        | late   | 15分遅刻      |
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |

## NULL値の論理的な扱い

NULL値は論理演算（AND、OR、NOT）でも特殊な扱いを受けます。

- **NULL AND TRUE** → NULL（不明）
- **NULL AND FALSE** → FALSE
- **NULL OR TRUE** → TRUE
- **NULL OR FALSE** → NULL（不明）
- **NOT NULL** → NULL（不明）

この特殊な振る舞いが、バグや誤った結果の原因になることがあります。

## NULL値と結合条件

テーブル結合（JOINなど、後の章で学習）の際も、NULL値は特殊な扱いを受けます。NULL値同士は「等しい」とは判定されないため、通常の結合条件ではNULL値を持つレコードは結合されません。

## IS NULLとIS NOT NULLを使った複合条件

IS NULLとIS NOT NULLも、他の条件と組み合わせて使用できます。

### 例：複合条件でのIS NULLの使用

例えば、「出席状態が "absent"（欠席）で、コメントがNULLでない（理由が入力されている）レコード」を検索するには：

```sql
SELECT * FROM attendance 
WHERE status = 'absent' AND comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |

## NVL/IFNULL/COALESCE関数：NULL値の置換

NULL値を別の値に置き換えるための関数が用意されています。データベースによって関数名が異なることがありますが、機能は似ています：

- MySQL/MariaDB: **IFNULL(expr, replace_value)**
- Oracle: **NVL(expr, replace_value)**
- SQL Server: **ISNULL(expr, replace_value)**
- 標準SQL: **COALESCE(expr1, expr2, ..., exprN)** - 最初のNULLでない式を返します

### 例：IFNULL関数の使用（MySQL）

例えば、コメントがNULLの場合は「特記事項なし」と表示するには：

```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '特記事項なし') AS comment
FROM attendance;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | 特記事項なし  |
| 1           | 302        | late    | 15分遅刻      |
| 1           | 303        | absent  | 事前連絡あり  |
| ...         | ...        | ...     | ...           |

## NULLを使う際の注意点

1. **除外の罠**：`WHERE カラム名 <> 値` だけでは、NULL値を持つレコードは含まれません。すべてのレコードを対象にするには：
   ```sql
   WHERE カラム名 <> 値 OR カラム名 IS NULL
   ```

2. **集計関数**：COUNT(*)はすべての行を数えますが、COUNT(カラム名)はそのカラムがNULLでない行だけを数えます。

3. **インデックス**：多くのデータベースでは、NULL値にもインデックスを適用できますが、データベースによって動作が異なる場合があります。

4. **一意性制約**：一般的に、UNIQUE制約ではNULL値は重複としてカウントされません（複数のNULL値が許可されます）。

## 練習問題

### 問題6-1
attendance（出席）テーブルから、コメント（comment）がNULLの出席レコードをすべて取得するSQLを書いてください。

### 問題6-2
course_schedule（授業カレンダー）テーブルから、状態（status）が「cancelled」で、かつ教室ID（classroom_id）がNULLでないレコードを取得するSQLを書いてください。

### 問題6-3
grades（成績）テーブルから、提出日（submission_date）がNULLの成績レコードを取得するSQLを書いてください。

### 問題6-4
attendance（出席）テーブルから、出席状態（status）が「present」か「late」で、かつコメント（comment）がNULLのレコードを取得するSQLを書いてください。

### 問題6-5
以下のSQLで教師（teachers）テーブルから「佐藤」という名前を持つ教師を検索する場合、NULL値を持つレコードも含めるにはどう修正すべきですか？
```sql
SELECT * FROM teachers WHERE teacher_name <> '佐藤花子';
```

### 問題6-6
attendance（出席）テーブルのすべてのレコードを取得し、コメント（comment）がNULLの場合は「記録なし」と表示するSQLを書いてください。

## 解答

### 解答6-1
```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

### 解答6-2
```sql
SELECT * FROM course_schedule 
WHERE status = 'cancelled' AND classroom_id IS NOT NULL;
```

### 解答6-3
```sql
SELECT * FROM grades WHERE submission_date IS NULL;
```

### 解答6-4
```sql
SELECT * FROM attendance 
WHERE (status = 'present' OR status = 'late') AND comment IS NULL;
```
または
```sql
SELECT * FROM attendance 
WHERE status IN ('present', 'late') AND comment IS NULL;
```

### 解答6-5
```sql
SELECT * FROM teachers 
WHERE teacher_name <> '佐藤花子' OR teacher_name IS NULL;
```

### 解答6-6
```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '記録なし') AS comment
FROM attendance;
```

## まとめ

この章では、データベースにおけるNULL値の概念と、NULL値を扱うための演算子や関数について学びました：

1. **NULL値の概念**：値がない、不明、未設定を表す特殊な値
2. **IS NULL演算子**：NULL値を持つレコードを検索する方法
3. **IS NOT NULL演算子**：NULL値を持たないレコードを検索する方法
4. **NULL値の論理的扱い**：論理演算（AND、OR、NOT）におけるNULLの振る舞い
5. **複合条件**：IS NULL/IS NOT NULLと他の条件の組み合わせ
6. **NULL値の置換**：IFNULL/NVL/COALESCE関数の使用方法
7. **注意点**：NULL値を扱う際の一般的な落とし穴

NULL値の正確な理解と適切な処理は、SQLプログラミングの重要な部分です。不適切なNULL処理は、予期しない結果やバグの原因になります。

次の章では、クエリ結果の並び替えを行うための「ORDER BY：結果の並び替え」について学びます。



---

# 7. ORDER BY：結果の並び替え

## はじめに

これまでの章では、データベースから条件に合ったレコードを取得する方法を学んできました。しかし実際の業務では、取得したデータを見やすく整理する必要があります。例えば：

- 成績を高い順に表示したい
- 学生を名前の五十音順に並べたい
- 日付の新しい順にスケジュールを確認したい

このようなデータの「並び替え」を行うためのSQLコマンドが「ORDER BY」です。この章では、クエリ結果を特定の順序で並べる方法を学びます。

## ORDER BYの基本

ORDER BY句は、SELECT文の結果を指定したカラムの値に基づいて並び替えるために使います。

> **用語解説**：
> - **ORDER BY**：「〜の順に並べる」という意味のSQLコマンドで、クエリ結果の並び順を指定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] ORDER BY 並び替えカラム;
```

ORDER BY句は通常、SELECT文の最後に記述します。

### 例1：単一カラムでの並び替え

例えば、学生（students）テーブルから、学生名（student_name）の五十音順（辞書順）でデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_name;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 309        | 相沢吉夫      |
| 303        | 柴崎春花      |
| 306        | 河田咲奈      |
| 305        | 河口菜恵子    |
| ...        | ...          |

### デフォルトの並び順

ORDER BYを使わない場合、結果の順序は保証されません。多くの場合、データがデータベースに保存された順序で返されますが、これは信頼できるものではありません。

## 昇順と降順の指定

ORDER BY句では、並び順を「昇順」か「降順」のどちらかで指定できます。

> **用語解説**：
> - **昇順（ASC）**：小さい値から大きい値へ（A→Z、1→9）の順に並べます。
> - **降順（DESC）**：大きい値から小さい値へ（Z→A、9→1）の順に並べます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 ORDER BY 並び替えカラム [ASC|DESC];
```

ASC（昇順）がデフォルトのため、省略可能です。

### 例2：降順での並び替え

例えば、成績（grades）テーブルから、得点（score）の高い順（降順）に成績を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 複数カラムでの並び替え

複数のカラムを使って並び替えることもできます。最初に指定したカラムで並び替え、値が同じレコードがある場合は次のカラムで並び替えます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 
ORDER BY 並び替えカラム1 [ASC|DESC], 並び替えカラム2 [ASC|DESC], ...;
```

### 例3：複数カラムでの並び替え

例えば、成績（grades）テーブルから、課題タイプ（grade_type）の五十音順に並べ、同じ課題タイプ内では得点（score）の高い順に成績を取得するには：

```sql
SELECT * FROM grades 
ORDER BY grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| 321        | 2         | 実技試験     | 85.5  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト   | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| 302        | 1         | レポート1    | 48.0  | 50.0      | 2025-05-10      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例4：昇順と降順の混合

各カラムごとに並び順を指定することもできます。例えば、講座ID（course_id）の昇順、評価タイプ（grade_type）の昇順、得点（score）の降順で並べるには：

```sql
SELECT * FROM grades 
ORDER BY course_id ASC, grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## NULLの扱い

ORDER BYでNULL値を並び替える場合、データベース製品によって動作が異なります。多くのデータベースでは、NULL値は最小値または最大値として扱われます。

- MySQL/MariaDBでは、NULL値は昇順（ASC）の場合は最小値として（最初に表示）、降順（DESC）の場合は最大値として（最後に表示）扱われます。

一部のデータベース（PostgreSQLなど）では、NULL値の位置を明示的に指定するための「NULLS FIRST」「NULLS LAST」構文がサポートされています。

### 例5：NULL値の扱い

例えば、出席（attendance）テーブルからコメント（comment）でソートすると、NULLが最初に来ます：

```sql
SELECT * FROM attendance ORDER BY comment;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | NULL          |
| 1           | 306        | present | NULL          |
| ...         | ...        | ...     | NULL          |
| 1           | 308        | late    | 5分遅刻       |
| 1           | 323        | late    | 電車遅延      |
| ...         | ...        | ...     | ...           |

## カラム番号を使った並び替え

カラム名の代わりに、SELECT文の結果セットにおけるカラムの位置（番号）を使って並び替えることもできます。最初のカラムは1、2番目のカラムは2、という具合です。

### 構文

```sql
SELECT カラム名1, カラム名2, ... FROM テーブル名 ORDER BY カラム位置;
```

### 例6：カラム番号を使った並び替え

例えば、学生（students）テーブルから学生ID（student_id）と名前（student_name）を取得し、名前（2番目のカラム）で並べ替えるには：

```sql
SELECT student_id, student_name FROM students ORDER BY 2;
```

この場合、「ORDER BY 2」は「ORDER BY student_name」と同じ意味になります。

> **注意**：カラム番号を使う方法は、カラムの順序を変更すると問題が起きるため、実際の業務では使用を避けた方が良いとされています。

## 式や関数を使った並び替え

ORDER BY句で式や関数を使うことにより、計算結果に基づいて並び替えることもできます。

### 例7：式を使った並び替え

例えば、成績（grades）テーブルから、得点の達成率（score/max_score）の高い順に並べるには：

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY (score/max_score) DESC;
```

または

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY 達成率 DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 98.0     |
| 320        | 1         | レポート1    | 48.5  | 50.0      | 97.0     |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 95.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

### 例8：関数を使った並び替え

文字列関数を使って並び替えることもできます。例えば、月名で並べることを考えましょう：

```sql
SELECT schedule_date, MONTH(schedule_date) AS month
FROM course_schedule
ORDER BY MONTH(schedule_date);
```

実行結果：

| schedule_date | month |
|---------------|-------|
| 2025-04-07    | 4     |
| 2025-04-08    | 4     |
| ...           | ...   |
| 2025-05-01    | 5     |
| 2025-05-02    | 5     |
| ...           | ...   |
| 2025-06-01    | 6     |
| ...           | ...   |

## CASE式を使った条件付き並び替え

さらに高度な並び替えとして、CASE式を使って条件に応じた並び順を定義することもできます。

### 例9：CASE式を使った並び替え

例えば、出席（attendance）テーブルから、出席状況（status）を「欠席→遅刻→出席」の順に優先して表示するには：

```sql
SELECT * FROM attendance
ORDER BY CASE 
           WHEN status = 'absent' THEN 1
           WHEN status = 'late' THEN 2
           WHEN status = 'present' THEN 3
           ELSE 4
         END;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |
| 1           | 302        | late   | 15分遅刻      |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |
| 1           | 301        | present| NULL          |
| 1           | 306        | present| NULL          |
| ...         | ...        | ...    | ...           |

## 練習問題

### 問題7-1
students（学生）テーブルから、すべての学生情報を学生名（student_name）の降順（逆五十音順）で取得するSQLを書いてください。

### 問題7-2
grades（成績）テーブルから、得点（score）が85点以上の成績を得点の高い順に取得するSQLを書いてください。

### 問題7-3
course_schedule（授業カレンダー）テーブルから、2025年5月の授業スケジュールを日付（schedule_date）の昇順で取得するSQLを書いてください。

### 問題7-4
teachers（教師）テーブルから、教師IDと名前を取得し、名前（teacher_name）の五十音順で並べるSQLを書いてください。

### 問題7-5
grades（成績）テーブルから、講座ID（course_id）ごとに、成績を評価タイプ（grade_type）の五十音順に、同じ評価タイプ内では得点（score）の高い順に並べて取得するSQLを書いてください。

### 問題7-6
attendance（出席）テーブルから、すべての出席情報を出席状況（status）が「absent」「late」「present」の順番で、同じ状態内ではコメント（comment）の有無（NULLが後）で並べて取得するSQLを書いてください。

## 解答

### 解答7-1
```sql
SELECT * FROM students ORDER BY student_name DESC;
```

### 解答7-2
```sql
SELECT * FROM grades WHERE score >= 85 ORDER BY score DESC;
```

### 解答7-3
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31' 
ORDER BY schedule_date;
```

### 解答7-4
```sql
SELECT teacher_id, teacher_name FROM teachers ORDER BY teacher_name;
```

### 解答7-5
```sql
SELECT * FROM grades 
ORDER BY course_id, grade_type, score DESC;
```

### 解答7-6
```sql
SELECT * FROM attendance
ORDER BY 
  CASE 
    WHEN status = 'absent' THEN 1
    WHEN status = 'late' THEN 2
    WHEN status = 'present' THEN 3
    ELSE 4
  END,
  CASE 
    WHEN comment IS NULL THEN 2
    ELSE 1
  END;
```

## まとめ

この章では、クエリ結果を特定の順序で並べるための「ORDER BY」句について学びました：

1. **基本的な並び替え**：指定したカラムの値に基づいて結果を並べる方法
2. **昇順と降順**：ASC（昇順）とDESC（降順）の指定方法
3. **複数カラムでの並び替え**：優先順位の高いカラムから順に指定する方法
4. **NULL値の扱い**：NULL値が並び替えでどのように扱われるか
5. **カラム番号**：カラム名の代わりに位置で指定する方法（あまり推奨されない）
6. **式や関数**：計算結果に基づいて並べる方法
7. **CASE式**：条件付きの複雑な並び替え

ORDER BY句は、データを見やすく整理するために非常に重要です。特に大量のデータを扱う場合、適切な並び順はデータの理解を大きく助けます。

次の章では、取得する結果の件数を制限する「LIMIT句：結果件数の制限とページネーション」について学びます。



---

# 8. LIMIT句：結果件数の制限とページネーション

## はじめに

これまでの章では、条件に合うデータを取得し、それを特定の順序で並べる方法を学びました。しかし実際のアプリケーションでは、大量のデータがあるときに、その一部だけを表示したいことがよくあります。例えば：

- 成績上位10件だけを表示したい
- Webページで一度に20件ずつ表示したい（ページネーション）
- 最新の5件のお知らせだけを取得したい

このような「結果の件数を制限する」ためのSQLコマンドが「LIMIT句」です。この章では、クエリ結果の件数を制限する方法と、ページネーションの実装方法を学びます。

## LIMIT句の基本

LIMIT句は、SELECT文の結果から指定した件数だけを取得するために使います。

> **用語解説**：
> - **LIMIT**：「制限する」という意味のSQLコマンドで、取得する行数を制限します。

### 基本構文（MySQL/MariaDB）

MySQLやMariaDBでのLIMIT句の基本構文は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数;
```

LIMIT句は通常、SELECT文の最後に記述します（ORDER BYの後）。

### 例1：単純なLIMIT

例えば、学生（students）テーブルから最初の5人だけを取得するには：

```sql
SELECT * FROM students LIMIT 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |

### ORDER BYとLIMITの組み合わせ

通常、LIMIT句はORDER BY句と組み合わせて使用します。これにより、「上位N件」「最新N件」などの操作が可能になります。

### 例2：ORDER BYとLIMITの組み合わせ

例えば、成績（grades）テーブルから得点（score）の高い順に上位3件を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 3;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |

### 例3：最新のレコードを取得

日付でソートして最新のデータを取得することもよくあります。例えば、最新の3つの授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
ORDER BY schedule_date DESC LIMIT 3;
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 95          | 28        | 2026-12-21    | 3         | 202D         | 119        | scheduled |
| 94          | 1         | 2026-12-21    | 1         | 102B         | 101        | scheduled |
| 93          | 14        | 2026-12-15    | 4         | 202D         | 110        | scheduled |

## OFFSETとページネーション

Webアプリケーションなどでは、大量のデータを「ページ」に分けて表示することがよくあります（ページネーション）。この機能を実現するためには、「OFFSET」（オフセット）という機能が必要です。

> **用語解説**：
> - **OFFSET**：「ずらす」という意味で、結果セットの先頭から指定した数だけ行をスキップします。
> - **ページネーション**：大量のデータを複数のページに分割して表示する技術です。

### 基本構文（MySQL/MariaDB）

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数 OFFSET スキップ数;
```

または、短縮形として：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT スキップ数, 件数;
```

### 例4：OFFSETを使ったスキップ

例えば、学生（students）テーブルから6番目から10番目までの学生を取得するには：

```sql
SELECT * FROM students LIMIT 5 OFFSET 5;
```

または：

```sql
SELECT * FROM students LIMIT 5, 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 306        | 河田咲奈     |
| 307        | 織田柚夏     |
| 308        | 永田悦子     |
| 309        | 相沢吉夫     |
| 310        | 吉川伽羅     |

### 例5：ページネーションの実装

ページネーションを実装する場合、通常は以下の式を使ってOFFSETを計算します：

```
OFFSET = (ページ番号 - 1) × ページあたりの件数
```

例えば、1ページあたり10件表示で、3ページ目のデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 10 OFFSET 20;
```

または：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 20, 10;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 322        | 木村結衣     |
| 323        | 林正義       |
| 324        | 清水香織     |
| 325        | 山田翔太     |
| 326        | 葉山陽太     |
| 327        | 青山凛       |
| 328        | 沢村大和     |
| 329        | 白石優月     |
| 330        | 月岡星奈     |

## LIMIT句を使用する際の注意点

### 1. ORDER BYの重要性

LIMIT句を使用する場合、通常はORDER BY句も一緒に使うべきです。ORDER BYがなければ、どのレコードが取得されるかは保証されません。

```sql
-- 良い例：結果が予測可能
SELECT * FROM students ORDER BY student_id LIMIT 5;

-- 悪い例：結果が不確定
SELECT * FROM students LIMIT 5;
```

### 2. パフォーマンスへの影響

大規模なテーブルで大きなOFFSET値を使用すると、パフォーマンスが低下する可能性があります。これは、データベースがOFFSET分のレコードを読み込んでから破棄する必要があるためです。

### 3. データベース製品による構文の違い

LIMIT句の構文はデータベース製品によって異なります：

- **MySQL/MariaDB/SQLite**：`LIMIT 件数 OFFSET スキップ数` または `LIMIT スキップ数, 件数`
- **PostgreSQL**：`LIMIT 件数 OFFSET スキップ数`
- **Oracle**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY`
- **SQL Server**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY` または旧バージョンでは `TOP`句

この章では主にMySQL/MariaDBの構文を使用します。

## 実践的なページネーションの実装

実際のアプリケーションでページネーションを実装する場合、以下のようなコードになります（疑似コード）：

```
ページ番号 = URLから取得またはデフォルト値（例：1）
1ページあたりの件数 = 設定値（例：10）
総レコード数 = SELECTで取得（COUNT(*)を使用）
総ページ数 = CEILING(総レコード数 ÷ 1ページあたりの件数)
OFFSET = (ページ番号 - 1) × 1ページあたりの件数

SQLクエリ = "SELECT * FROM テーブル ORDER BY カラム LIMIT " + 1ページあたりの件数 + " OFFSET " + OFFSET
```

### 例6：総レコード数と総ページ数の取得

総レコード数を取得するには：

```sql
SELECT COUNT(*) AS total_records FROM students;
```

実行結果：

| total_records |
|---------------|
| 100           |

この場合、1ページあたり10件表示なら、総ページ数は10ページ（CEILING(100 ÷ 10)）になります。

## 練習問題

### 問題8-1
grades（成績）テーブルから、得点（score）の高い順に上位5件の成績レコードを取得するSQLを書いてください。

### 問題8-2
course_schedule（授業カレンダー）テーブルから、日付（schedule_date）の新しい順に3件のスケジュールを取得するSQLを書いてください。

### 問題8-3
students（学生）テーブルを学生ID（student_id）の昇順で並べ、11番目から15番目までの学生（5件）を取得するSQLを書いてください。

### 問題8-4
teachers（教師）テーブルから、教師名（teacher_name）の五十音順で6番目から10番目までの教師情報を取得するSQLを書いてください。

### 問題8-5
1ページあたり20件表示で、grades（成績）テーブルの3ページ目のデータを得点（score）の高い順に取得するSQLを書いてください。

### 問題8-6
course_schedule（授業カレンダー）テーブルから、状態（status）が「scheduled」のスケジュールを日付（schedule_date）の昇順で並べ、先頭から10件スキップして次の5件を取得するSQLを書いてください。

## 解答

### 解答8-1
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 5;
```

### 解答8-2
```sql
SELECT * FROM course_schedule ORDER BY schedule_date DESC LIMIT 3;
```

### 解答8-3
```sql
SELECT * FROM students ORDER BY student_id LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM students ORDER BY student_id LIMIT 10, 5;
```

### 解答8-4
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5 OFFSET 5;
```
または
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5, 5;
```

### 解答8-5
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 20 OFFSET 40;
```
または
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 40, 20;
```

### 解答8-6
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 10, 5;
```

## まとめ

この章では、クエリ結果の件数を制限するためのLIMIT句と、ページネーションの実装方法について学びました：

1. **LIMIT句の基本**：指定した件数だけのレコードを取得する方法
2. **ORDER BYとの組み合わせ**：順序付けされた結果から一部だけを取得する方法
3. **OFFSET**：結果の先頭から指定した数だけレコードをスキップする方法
4. **ページネーション**：大量のデータを複数のページに分けて表示する実装方法
5. **注意点**：LIMIT句を使用する際の留意事項
6. **データベース製品による違い**：異なるデータベースでの構文の違い

LIMIT句は特にWebアプリケーションの開発で重要な機能です。大量のデータを効率よく表示するためのページネーション機能を実装するために欠かせません。また、トップN（上位N件）やボトムN（下位N件）のデータを取得する際にも使われます。

次の章では、データの集計分析を行うための「集計関数：COUNT、SUM、AVG、MAX、MIN」について学びます。




---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [9. 集計関数：COUNT、SUM、AVG、MAX、MIN](#9-集計関数countsumavgmaxmin)
2. [10. GROUP BY：データのグループ化](#10-group-byデータのグループ化)
3. [11. HAVING：グループ化後の絞り込み](#11-havingグループ化後の絞り込み)
4. [12. DISTINCT：重複の除外](#12-distinct重複の除外)
5. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)

---


# 9. 集計関数：COUNT、SUM、AVG、MAX、MIN

## はじめに

これまでの章では、データベースからレコードを取得して表示する方法を学んできました。しかし、データベースを使う目的の一つは、大量のデータから有用な情報（集計、統計など）を抽出することです。例えば：

- 「学生の総数は何人か？」
- 「成績の平均点は？」
- 「最高点と最低点は？」
- 「全講座の合計受講者数は？」

このような「データの集計」を行うためのSQLの機能が「集計関数」です。この章では、最もよく使われる5つの集計関数（COUNT、SUM、AVG、MAX、MIN）について学びます。

## 集計関数の基本

集計関数は、複数の行のデータをまとめて一つの値を返す関数です。

> **用語解説**：
> - **集計関数**：複数の行（レコード）から計算された単一の値を返す関数です。データの集計や統計に使用されます。

### 主な集計関数

| 関数   | 説明                     | 例                                 |
|--------|--------------------------|-------------------------------------|
| COUNT  | レコード数を数える        | 学生の総数                           |
| SUM    | 値の合計を計算する        | 全成績の点数合計                     |
| AVG    | 値の平均を計算する        | 平均点                             |
| MAX    | 最大値を取得する         | 最高点                             |
| MIN    | 最小値を取得する         | 最低点                             |

## COUNT関数：レコード数をカウントする

COUNT関数は、条件に一致するレコードの数を数えるのに使用します。

### 基本構文

```sql
SELECT COUNT(カラム名) FROM テーブル名 [WHERE 条件];
```

または、すべての行を数える場合：

```sql
SELECT COUNT(*) FROM テーブル名 [WHERE 条件];
```

### 例1：テーブル内の全レコード数

例えば、学生（students）テーブルの全学生数を数えるには：

```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

実行結果：

| 学生総数 |
|---------|
| 100     |

### 例2：条件付きのカウント

WHERE句と組み合わせることで、条件に一致するレコードだけをカウントできます。例えば、「出席（present）」状態の出席レコードの数を数えるには：

```sql
SELECT COUNT(*) AS 出席数 FROM attendance WHERE status = 'present';
```

実行結果：

| 出席数 |
|-------|
| 42    |

### 例3：NULL以外の値をカウント

COUNT(カラム名)を使うと、そのカラムがNULLでない行だけがカウントされます。これは、COUNT(*)との大きな違いです。例えば、コメント（comment）が入力されている出席レコードの数を数えるには：

```sql
SELECT COUNT(comment) AS コメントあり FROM attendance;
```

実行結果：

| コメントあり |
|------------|
| 23         |

### 例4：DISTINCTを使った重複のないカウント

DISTINCTを使うと、重複を除外してカウントできます。例えば、何種類の評価タイプ（grade_type）があるかを数えるには：

```sql
SELECT COUNT(DISTINCT grade_type) AS 評価タイプ数 FROM grades;
```

実行結果：

| 評価タイプ数 |
|------------|
| 3          |

## SUM関数：合計を計算する

SUM関数は、数値カラムの合計を計算するのに使用します。

### 基本構文

```sql
SELECT SUM(数値カラム) FROM テーブル名 [WHERE 条件];
```

### 例1：単純な合計

例えば、全成績レコードの得点（score）の合計を計算するには：

```sql
SELECT SUM(score) AS 総得点 FROM grades;
```

実行結果：

| 総得点   |
|---------|
| 3542.5  |

### 例2：条件付きの合計

WHERE句と組み合わせることで、条件に一致するレコードだけの合計を計算できます。例えば、「中間テスト」の得点合計を計算するには：

```sql
SELECT SUM(score) AS 中間テスト合計点 
FROM grades 
WHERE grade_type = '中間テスト';
```

実行結果：

| 中間テスト合計点 |
|----------------|
| 1728.0         |

### 例3：計算式を使った合計

計算式と組み合わせることもできます。例えば、全成績の達成率（score/max_score）の合計を計算するには：

```sql
SELECT SUM(score/max_score) AS 達成率合計 FROM grades;
```

実行結果：

| 達成率合計 |
|-----------|
| 39.86     |

## AVG関数：平均を計算する

AVG関数は、数値カラムの平均値を計算するのに使用します。

### 基本構文

```sql
SELECT AVG(数値カラム) FROM テーブル名 [WHERE 条件];
```

### 例1：単純な平均

例えば、全成績レコードの得点（score）の平均を計算するには：

```sql
SELECT AVG(score) AS 平均点 FROM grades;
```

実行結果：

| 平均点  |
|--------|
| 82.38  |

### 例2：条件付きの平均

WHERE句と組み合わせることで、条件に一致するレコードだけの平均を計算できます。例えば、「実技試験」の平均点を計算するには：

```sql
SELECT AVG(score) AS 実技試験平均点 
FROM grades 
WHERE grade_type = '実技試験';
```

実行結果：

| 実技試験平均点 |
|--------------|
| 85.6         |

### 例3：達成率（%）の計算

計算式と組み合わせることで、例えば平均達成率（%）を計算できます：

```sql
SELECT AVG(score/max_score * 100) AS 平均達成率 FROM grades;
```

実行結果：

| 平均達成率 |
|-----------|
| 87.24     |

## MAX関数：最大値を取得する

MAX関数は、数値、文字列、日付などのカラムから最大値を取得するのに使用します。

### 基本構文

```sql
SELECT MAX(カラム名) FROM テーブル名 [WHERE 条件];
```

### 例1：数値の最大値

例えば、全成績レコードの中での最高点を取得するには：

```sql
SELECT MAX(score) AS 最高点 FROM grades;
```

実行結果：

| 最高点 |
|-------|
| 95.0  |

### 例2：文字列の最大値（辞書順で最後）

MAX関数は文字列にも使用でき、この場合は辞書順で「最後」の値を返します。例えば、学生名の辞書順で最後の値（最も「わ行」に近い名前）を取得するには：

```sql
SELECT MAX(student_name) AS 学生名最終 FROM students;
```

実行結果：

| 学生名最終 |
|----------|
| 吉川伽羅  |

### 例3：日付の最大値（最新の日付）

日付にMAX関数を使うと、最新（最も未来）の日付が取得できます。例えば、最も新しい提出日を取得するには：

```sql
SELECT MAX(submission_date) AS 最新提出日 FROM grades;
```

実行結果：

| 最新提出日   |
|------------|
| 2025-05-20 |

## MIN関数：最小値を取得する

MIN関数は、数値、文字列、日付などのカラムから最小値を取得するのに使用します。

### 基本構文

```sql
SELECT MIN(カラム名) FROM テーブル名 [WHERE 条件];
```

### 例1：数値の最小値

例えば、全成績レコードの中での最低点を取得するには：

```sql
SELECT MIN(score) AS 最低点 FROM grades;
```

実行結果：

| 最低点 |
|-------|
| 68.0  |

### 例2：文字列の最小値（辞書順で最初）

MIN関数は文字列にも使用でき、この場合は辞書順で「最初」の値を返します。例えば、学生名の辞書順で最初の値（最も「あ行」に近い名前）を取得するには：

```sql
SELECT MIN(student_name) AS 学生名最初 FROM students;
```

実行結果：

| 学生名最初 |
|----------|
| 相沢吉夫  |

### 例3：日付の最小値（最古の日付）

日付にMIN関数を使うと、最も古い日付が取得できます。例えば、最も古い提出日を取得するには：

```sql
SELECT MIN(submission_date) AS 最古提出日 FROM grades;
```

実行結果：

| 最古提出日   |
|------------|
| 2025-05-06 |

## 複数の集計関数の組み合わせ

複数の集計関数を一つのクエリで使用することもできます。

### 例：成績の統計情報

例えば、成績（grades）テーブルの統計情報を一度に取得するには：

```sql
SELECT 
    COUNT(*) AS レコード数,
    AVG(score) AS 平均点,
    SUM(score) AS 合計点,
    MAX(score) AS 最高点,
    MIN(score) AS 最低点
FROM grades;
```

実行結果：

| レコード数 | 平均点 | 合計点  | 最高点 | 最低点 |
|---------|--------|--------|-------|-------|
| 43      | 82.38  | 3542.5 | 95.0  | 68.0  |

## 集計関数とGROUP BY（次章の内容）

集計関数をより強力に使うためには、「GROUP BY」句と組み合わせます。これにより、データをグループ化して各グループごとに集計できます。GROUP BYについては次章で詳しく学びます。

例えば、講座（course_id）ごとの平均点を計算するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id;
```

実行結果：

| course_id | 平均点 |
|-----------|--------|
| 1         | 86.2   |
| 2         | 83.8   |
| 3         | 80.5   |
| ...       | ...    |

この例の詳細な説明は次章で行います。

## 練習問題

### 問題9-1
students（学生）テーブルから、学生の総数を取得するSQLを書いてください。

### 問題9-2
grades（成績）テーブルから、全成績の平均点（score）を取得するSQLを書いてください。

### 問題9-3
attendance（出席）テーブルから、出席状況（status）が「absent」のレコード数を取得するSQLを書いてください。

### 問題9-4
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」の成績の最高点と最低点を取得するSQLを書いてください。

### 問題9-5
course_schedule（授業カレンダー）テーブルから、最新（schedule_dateが最大）の授業スケジュールの日付を取得するSQLを書いてください。

### 問題9-6
grades（成績）テーブルから、成績の総数、平均点、合計点、最高点、最低点を一度に取得するSQLを書いてください。

## 解答

### 解答9-1
```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

### 解答9-2
```sql
SELECT AVG(score) AS 全成績平均点 FROM grades;
```

### 解答9-3
```sql
SELECT COUNT(*) AS 欠席数 FROM attendance WHERE status = 'absent';
```

### 解答9-4
```sql
SELECT 
    MAX(score) AS 中間テスト最高点,
    MIN(score) AS 中間テスト最低点
FROM grades 
WHERE grade_type = '中間テスト';
```

### 解答9-5
```sql
SELECT MAX(schedule_date) AS 最新授業日 FROM course_schedule;
```

### 解答9-6
```sql
SELECT 
    COUNT(*) AS 成績総数,
    AVG(score) AS 平均点,
    SUM(score) AS 合計点,
    MAX(score) AS 最高点,
    MIN(score) AS 最低点
FROM grades;
```

## まとめ

この章では、データの集計と分析に使用される主要な集計関数について学びました：

1. **COUNT**：レコード数をカウントする関数
2. **SUM**：数値の合計を計算する関数
3. **AVG**：数値の平均を計算する関数
4. **MAX**：最大値（数値、文字列、日付など）を取得する関数
5. **MIN**：最小値（数値、文字列、日付など）を取得する関数

これらの集計関数を使うことで、大量のデータから意味のある統計情報を簡単に抽出できます。ビジネスにおける意思決定や、データ分析において非常に重要な機能です。

次の章では、データをグループ化して集計を行うための「GROUP BY：データのグループ化」について学びます。



---

# 10. GROUP BY：データのグループ化

## はじめに

前章では、集計関数（COUNT、SUM、AVG、MAX、MIN）を使って全体的な集計や統計を計算する方法を学びました。しかし実際のデータ分析では、全体の集計だけでなく、特定のカテゴリや条件ごとに集計したい場合が多くあります。例えば：

- 「講座ごとの平均点は？」
- 「教師ごとの担当講座数は？」
- 「日付ごとの授業数は？」
- 「出席状況（出席/遅刻/欠席）の割合は？」

このような「グループごとの集計」を行うためのSQLコマンドが「GROUP BY」です。この章では、データをグループ化して集計する方法について学びます。

## GROUP BYの基本

GROUP BY句は、指定したカラムの値が同じレコードをグループ化し、それぞれのグループに対して集計関数を適用するために使います。

> **用語解説**：
> - **GROUP BY**：「〜でグループ化する」という意味のSQLコマンドで、同じ値を持つレコードをまとめてグループにします。
> - **グループ化**：データを特定の条件で分類し、それぞれの分類ごとに集計を行うこと。

### 基本構文

```sql
SELECT カラム名, 集計関数
FROM テーブル名
[WHERE 条件]
GROUP BY グループ化するカラム名;
```

重要なのは、SELECT句に含めるカラムは、GROUP BY句で指定したカラムか、集計関数（COUNT、SUM、AVG、MAX、MINなど）のいずれかでなければならないということです。

### 例1：単純なグループ化

例えば、成績（grades）テーブルから、評価タイプ（grade_type）ごとの成績レコード数を集計するには：

```sql
SELECT grade_type, COUNT(*) AS レコード数
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | レコード数 |
|-------------|-----------|
| 中間テスト   | 12        |
| レポート1    | 22        |
| 実技試験     | 9         |

### 例2：グループごとの平均

グループごとの平均を計算することも一般的です。例えば、各評価タイプごとの平均点を計算するには：

```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均点    |
|-------------|----------|
| 中間テスト   | 86.25    |
| レポート1    | 44.77    |
| 実技試験     | 85.61    |

## 複数のカラムによるグループ化

複数のカラムを指定してグループ化することもできます。この場合、指定したすべてのカラムの値の組み合わせがグループの単位になります。

### 例3：複数カラムでのグループ化

例えば、講座（course_id）と評価タイプ（grade_type）の組み合わせごとに成績の平均を計算するには：

```sql
SELECT course_id, grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY course_id, grade_type;
```

実行結果：

| course_id | grade_type  | 平均点    |
|-----------|-------------|----------|
| 1         | 中間テスト   | 87.33    |
| 1         | レポート1    | 45.39    |
| 2         | 実技試験     | 86.83    |
| ...       | ...         | ...      |

### グループ化の順序

GROUP BY句でカラムを指定する順序は、結果には影響しません。しかし、可読性のためにSELECT句と同じ順序で指定することが一般的です。

## WHERE句とGROUP BYの組み合わせ

WHERE句は、グループ化する前に行単位でレコードを絞り込むのに使います。

> **用語解説**：
> - **絞り込み順序**：WHERE句はGROUP BY句の前に評価され、条件に合うレコードだけがグループ化の対象になります。

### 例4：WHEREとGROUP BYの組み合わせ

例えば、得点（score）が80以上の成績だけを対象に、評価タイプごとの平均を計算するには：

```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
WHERE score >= 80
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均点    |
|-------------|----------|
| 中間テスト   | 88.92    |
| 実技試験     | 87.25    |

この例では、score >= 80の条件に一致するレコードだけがグループ化され、集計されています。レポート1はすべての点数が80未満なので、結果には表示されていません。

## GROUP BYとORDER BYの組み合わせ

GROUP BY句とORDER BY句を組み合わせることで、グループ化した結果を任意の順序で並べることができます。

### 例5：GROUP BYとORDER BYの組み合わせ

例えば、講座（course_id）ごとの平均点を計算し、平均点の高い順に並べるには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
ORDER BY 平均点 DESC;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| 2         | 83.79    |
| 5         | 82.33    |
| ...       | ...      |

## 集計関数の複数使用

一つのクエリで複数の集計関数を使用することもできます。

### 例6：複数の集計関数の使用

例えば、評価タイプごとの成績数、平均点、最高点、最低点を一度に取得するには：

```sql
SELECT grade_type, 
       COUNT(*) AS 成績数,
       AVG(score) AS 平均点,
       MAX(score) AS 最高点,
       MIN(score) AS 最低点
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 成績数 | 平均点    | 最高点 | 最低点 |
|-------------|-------|----------|-------|-------|
| 中間テスト   | 12    | 86.25    | 95.0  | 78.5  |
| レポート1    | 22    | 44.77    | 49.0  | 37.0  |
| 実技試験     | 9     | 85.61    | 88.0  | 79.5  |

## 計算式を含むグループ化

GROUP BY句で集計した結果に対して、さらに計算を加えることができます。

### 例7：計算式を含むグループ化

例えば、評価タイプごとに平均達成率（score/max_score）を計算するには：

```sql
SELECT grade_type, 
       AVG(score/max_score * 100) AS 平均達成率
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均達成率 |
|-------------|-----------|
| 中間テスト   | 86.25     |
| レポート1    | 89.54     |
| 実技試験     | 85.61     |

## GROUP BYとNULLの扱い

GROUP BY句でグループ化する際、NULL値も一つのグループとして扱われます。

### 例8：NULLを含むグループ化

例えば、出席（attendance）テーブルから、コメント（comment）の有無でグループ化し、それぞれの件数を数えるには：

```sql
SELECT 
    CASE 
        WHEN comment IS NULL THEN 'コメントなし'
        ELSE 'コメントあり'
    END AS コメント状態,
    COUNT(*) AS 件数
FROM attendance
GROUP BY 
    CASE 
        WHEN comment IS NULL THEN 'コメントなし'
        ELSE 'コメントあり'
    END;
```

実行結果：

| コメント状態   | 件数  |
|--------------|-------|
| コメントなし   | 20    |
| コメントあり   | 23    |

## HAVINGを使ったグループの絞り込み（次章の内容）

グループ化した後にさらに条件でグループを絞り込むには、「HAVING」句を使います。これについては次章で詳しく学びます。

例えば、5人以上の学生が受講している講座だけを取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 学生数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題10-1
courses（講座）テーブルから、教師ID（teacher_id）ごとに担当している講座の数を取得するSQLを書いてください。

### 問題10-2
attendance（出席）テーブルから、出席状況（status）ごとのレコード数を取得するSQLを書いてください。

### 問題10-3
grades（成績）テーブルから、学生ID（student_id）ごとの平均点を計算し、平均点の高い順に並べるSQLを書いてください。

### 問題10-4
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）ごとに予定されている授業の数を取得するSQLを書いてください。

### 問題10-5
grades（成績）テーブルから、講座ID（course_id）と評価タイプ（grade_type）の組み合わせごとの平均点を計算し、講座ID順、さらに評価タイプ順で並べるSQLを書いてください。

### 問題10-6
student_courses（受講）テーブルから、講座ID（course_id）ごとの受講者数を取得し、受講者数の多い順に並べるSQLを書いてください。

## 解答

### 解答10-1
```sql
SELECT teacher_id, COUNT(course_id) AS 担当講座数
FROM courses
GROUP BY teacher_id;
```

### 解答10-2
```sql
SELECT status, COUNT(*) AS レコード数
FROM attendance
GROUP BY status;
```

### 解答10-3
```sql
SELECT student_id, AVG(score) AS 平均点
FROM grades
GROUP BY student_id
ORDER BY 平均点 DESC;
```

### 解答10-4
```sql
SELECT classroom_id, COUNT(*) AS 授業数
FROM course_schedule
GROUP BY classroom_id;
```

### 解答10-5
```sql
SELECT course_id, grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY course_id, grade_type
ORDER BY course_id, grade_type;
```

### 解答10-6
```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
ORDER BY 受講者数 DESC;
```

## まとめ

この章では、データをグループ化して集計するためのGROUP BY句について学びました：

1. **GROUP BYの基本**：同じ値を持つレコードをグループ化する方法
2. **集計関数との組み合わせ**：グループごとの集計を行う方法
3. **複数カラムによるグループ化**：複数の条件でのグループ化
4. **WHERE句との組み合わせ**：グループ化前のレコード絞り込み
5. **ORDER BYとの組み合わせ**：グループ化結果の並び替え
6. **複数の集計関数の使用**：一度に複数の統計値を取得する方法
7. **計算式を含むグループ化**：より複雑な集計の実現
8. **NULLの扱い**：グループ化におけるNULL値の取り扱い

GROUP BY句を使うことで、データのさまざまな側面から分析が可能になり、意思決定のための有用な情報を抽出できるようになります。

次の章では、グループ化した結果をさらに条件で絞り込むための「HAVING：グループ化後の絞り込み」について学びます。



---

# 11. HAVING：グループ化後の絞り込み

## はじめに

前章では、GROUP BY句を使ってデータをグループ化し、各グループごとに集計を行う方法を学びました。しかし、すべてのグループの集計結果を表示するのではなく、特定の条件を満たすグループだけを表示したい場合があります。例えば：

- 「平均点が80点以上の講座だけを表示したい」
- 「5人以上の学生が登録している講座だけを取得したい」
- 「出席率が90%を超える学生だけをリストアップしたい」

このような「グループ化した結果をさらに絞り込む」ためのSQLコマンドが「HAVING」句です。この章では、グループ化した結果に条件を適用する方法について学びます。

## HAVINGの基本

HAVING句は、GROUP BY句でグループ化した後の結果に対して条件を適用し、条件を満たすグループだけを取得するために使います。

> **用語解説**：
> - **HAVING**：「〜を持っている」という意味のSQLコマンドで、グループ化した結果に対して条件を適用します。

### 基本構文

```sql
SELECT カラム名, 集計関数
FROM テーブル名
[WHERE 行レベルの条件]
GROUP BY グループ化するカラム名
HAVING グループレベルの条件;
```

### 例1：基本的なHAVINGの使用

例えば、受講者数が5人以上の講座だけを取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5;
```

実行結果：

| course_id | 受講者数 |
|-----------|---------|
| 1         | 12      |
| 2         | 8       |
| 4         | 7       |
| 5         | 7       |
| ...       | ...     |

この例では、まず講座ID（course_id）ごとに学生ID（student_id）の数を数え、その後でHAVING句を使って受講者数が5人以上のグループだけを抽出しています。

## WHEREとHAVINGの違い

WHERE句とHAVING句は似ていますが、適用されるタイミングと対象が異なります：

- **WHERE**：グループ化される前の個々の行（レコード）に対して条件を適用します。
- **HAVING**：グループ化された後のグループに対して条件を適用します。

> **用語解説**：
> - **行レベルのフィルタリング**：WHEREによる個々のレコードの絞り込み
> - **グループレベルのフィルタリング**：HAVINGによるグループの絞り込み

### 例2：WHEREとHAVINGの違い

以下の例で違いを確認しましょう：

```sql
-- WHERE（行レベル）：まず80点以上の成績だけを選び、それからグループ化
SELECT course_id, AVG(score) AS 平均点
FROM grades
WHERE score >= 80
GROUP BY course_id;

-- HAVING（グループレベル）：まずグループ化して平均点を計算し、それから平均点が80以上のグループを選ぶ
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
HAVING AVG(score) >= 80;
```

1つ目のクエリは、「80点以上の成績だけ」を対象に講座ごとの平均点を計算します。
2つ目のクエリは、「講座の平均点が80点以上」の講座だけを取得します。

**WHERE句の結果**：

| course_id | 平均点    |
|-----------|----------|
| 1         | 88.92    |
| 2         | 87.25    |
| ...       | ...      |

**HAVING句の結果**：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| 2         | 83.79    |
| 5         | 82.33    |
| ...       | ...      |

## HAVINGで使用できる条件

HAVING句では、集計関数（COUNT、SUM、AVG、MAX、MINなど）を使った条件や、GROUP BY句で指定したカラムに対する条件を指定できます。

### 例3：集計関数を使った条件

例えば、平均点が85点以上の講座を取得するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
HAVING AVG(score) >= 85;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| ...       | ...      |

### 例4：複数条件の指定

HAVING句も、WHERE句と同様に複数の条件を組み合わせることができます：

```sql
SELECT grade_type, COUNT(*) AS 件数, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type
HAVING COUNT(*) > 10 AND AVG(score) > 80;
```

実行結果：

| grade_type | 件数 | 平均点    |
|------------|-----|----------|
| 中間テスト  | 12  | 86.25    |
| ...        | ... | ...      |

## WHEREとHAVINGの組み合わせ

実際のクエリでは、WHERE句とHAVING句を組み合わせることが多いです。WHERE句でグループ化前の行を絞り込み、HAVING句でグループ化後の結果をさらに絞り込みます。

### 例5：WHEREとHAVINGの組み合わせ

例えば、「中間テストのみを対象として、平均点が85点以上の講座」を取得するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
WHERE grade_type = '中間テスト'
GROUP BY course_id
HAVING AVG(score) >= 85;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 87.33    |
| ...       | ...      |

## HAVINGとORDER BYの組み合わせ

HAVING句で絞り込んだ結果を並べ替えるには、ORDER BY句を追加します。

### 例6：HAVINGとORDER BYの組み合わせ

例えば、受講者数が5人以上の講座を、受講者数の多い順に並べて取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5
ORDER BY 受講者数 DESC;
```

実行結果：

| course_id | 受講者数 |
|-----------|---------|
| 1         | 12      |
| 20        | 11      |
| 9         | 10      |
| ...       | ...     |

## 実践的なHAVINGの使用例

### 例7：「平均達成率が90%を超える評価タイプ」の抽出

各評価タイプごとの平均達成率（score/max_score）を計算し、90%を超えるものだけを取得します：

```sql
SELECT grade_type, 
       AVG(score/max_score * 100) AS 平均達成率
FROM grades
GROUP BY grade_type
HAVING AVG(score/max_score * 100) > 90;
```

実行結果：

| grade_type | 平均達成率 |
|------------|----------|
| レポート1   | 93.54    |
| ...        | ...      |

### 例8：「特定の講座で成績データが存在する学生」の抽出

例えば、講座ID「1」の成績が2件以上ある学生を取得します：

```sql
SELECT student_id, COUNT(*) AS 成績件数
FROM grades
WHERE course_id = '1'
GROUP BY student_id
HAVING COUNT(*) >= 2;
```

実行結果：

| student_id | 成績件数 |
|------------|---------|
| 301        | 2       |
| 302        | 2       |
| ...        | ...     |

## HAVINGでの注意点

1. **集計関数の使用**: HAVINGで使用する条件には、通常、集計関数（COUNT、SUM、AVG、MAX、MINなど）が含まれます。単純なカラム比較だけならWHERE句を使用すべきです。

2. **パフォーマンスの考慮**: WHERE句はグループ化前に適用されるため、処理対象のレコード数を減らすことができます。可能な限り、グループ化前の条件はWHERE句で指定し、グループ化後の条件だけをHAVING句で指定するようにすると、効率的なクエリになります。

3. **グループレベルの条件**: HAVING句は、GROUP BY句で指定したカラムや集計関数の結果に対する条件でなければならないことを覚えておきましょう。

## 練習問題

### 問題11-1
student_courses（受講）テーブルから、受講者数が8人以上の講座ID（course_id）を取得するSQLを書いてください。

### 問題11-2
grades（成績）テーブルから、平均点（score）が85点以上の評価タイプ（grade_type）を取得するSQLを書いてください。

### 問題11-3
courses（講座）テーブルから、各教師（teacher_id）が担当する講座数を計算し、担当講座が3つ以上の教師だけを取得するSQLを書いてください。

### 問題11-4
grades（成績）テーブルから、講座ID（course_id）ごとの最高点（score）を計算し、最高点が90点以上の講座を、最高点の高い順に並べて取得するSQLを書いてください。

### 問題11-5
attendance（出席）テーブルから、欠席（status = 'absent'）の回数が2回以上ある学生ID（student_id）を取得するSQLを書いてください。

### 問題11-6
grades（成績）テーブルを使って、中間テスト（grade_type = '中間テスト'）のデータのみを対象に、平均点が85点以上で、かつ最低点が75点以上の講座ID（course_id）を取得するSQLを書いてください。

## 解答

### 解答11-1
```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 8;
```

### 解答11-2
```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type
HAVING AVG(score) >= 85;
```

### 解答11-3
```sql
SELECT teacher_id, COUNT(course_id) AS 担当講座数
FROM courses
GROUP BY teacher_id
HAVING COUNT(course_id) >= 3;
```

### 解答11-4
```sql
SELECT course_id, MAX(score) AS 最高点
FROM grades
GROUP BY course_id
HAVING MAX(score) >= 90
ORDER BY 最高点 DESC;
```

### 解答11-5
```sql
SELECT student_id, COUNT(*) AS 欠席回数
FROM attendance
WHERE status = 'absent'
GROUP BY student_id
HAVING COUNT(*) >= 2;
```

### 解答11-6
```sql
SELECT course_id, AVG(score) AS 平均点, MIN(score) AS 最低点
FROM grades
WHERE grade_type = '中間テスト'
GROUP BY course_id
HAVING AVG(score) >= 85 AND MIN(score) >= 75;
```

## まとめ

この章では、グループ化した結果に条件を適用するためのHAVING句について学びました：

1. **HAVINGの基本**：グループ化した結果に条件を適用する方法
2. **WHEREとHAVINGの違い**：
   - WHERE：グループ化前の行レベルのフィルタリング
   - HAVING：グループ化後のグループレベルのフィルタリング
3. **HAVING句での条件**：集計関数を使った条件設定
4. **複合条件**：ANDやORを使った複数条件の組み合わせ
5. **WHERE、HAVING、ORDER BYの組み合わせ**：複雑なデータ抽出の手法
6. **実践的な使用例**：実際の業務で使われるようなクエリパターン

HAVING句はデータ分析において非常に重要です。グループ化されたデータに対して「どのグループが重要か」「どのグループに注目すべきか」という条件を設定することで、より意味のある情報を抽出することができます。

次の章では、重複データを除外するための「DISTINCT：重複の除外」について学びます。



---

# 12. DISTINCT：重複の除外

## はじめに

データベースから情報を取得する際、同じ値が複数回出現することがよくあります。例えば、「どの講座がどの教室で行われているか」を調べると、同じ教室が複数回リストされるでしょう。しかし、時には重複を除いた一意の値のリストだけが必要な場合があります。例えば：

- 「学校にはどんな教室があるか」（重複なく知りたい）
- 「どの教師が授業を担当しているか」（重複なく知りたい）
- 「どのような評価タイプがあるか」（重複なく知りたい）

このような「重複を除外」するためのSQLキーワードが「DISTINCT」です。この章では、クエリ結果から重複するデータを除外する方法について学びます。

## DISTINCTの基本

DISTINCT句は、SELECT文の結果から重複する行を除外するために使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別される」という意味のSQLキーワードで、クエリ結果から重複する行を除外します。
> - **重複除外**：同じ値を持つレコードを1つだけにして、残りを除外すること。

### 基本構文

```sql
SELECT DISTINCT カラム名 FROM テーブル名 [WHERE 条件];
```

DISTINCTは、SELECT文の直後に配置され、すべての指定されたカラムの組み合わせに対して働きます。

### 例1：単一カラムでの重複除外

例えば、成績テーブル（grades）から、どのような評価タイプ（grade_type）があるかを重複なしで取得するには：

```sql
SELECT DISTINCT grade_type FROM grades;
```

実行結果：

| grade_type  |
|-------------|
| 中間テスト   |
| レポート1    |
| 実技試験     |

通常のSELECT文では、テーブル内の各行の評価タイプが表示されますが、DISTINCTを使うと、一意の評価タイプだけが表示されます。

### 例2：出席状況の種類の取得

出席（attendance）テーブルから、どのような出席状況（status）があるかを重複なしで取得するには：

```sql
SELECT DISTINCT status FROM attendance;
```

実行結果：

| status  |
|---------|
| present |
| late    |
| absent  |

## 複数カラムでのDISTINCT

DISTINCTは複数のカラムにも適用できます。この場合、指定したすべてのカラムの値の組み合わせが一意であるレコードだけが返されます。

### 基本構文

```sql
SELECT DISTINCT カラム名1, カラム名2, ... FROM テーブル名 [WHERE 条件];
```

### 例3：複数カラムでの重複除外

例えば、授業スケジュール（course_schedule）テーブルから、どの講座（course_id）がどの時限（period_id）に開講されているかを重複なしで取得するには：

```sql
SELECT DISTINCT course_id, period_id FROM course_schedule;
```

実行結果：

| course_id | period_id |
|-----------|-----------|
| 1         | 1         |
| 2         | 3         |
| 3         | 4         |
| 4         | 2         |
| ...       | ...       |

この結果は、course_idとperiod_idの組み合わせが一意のレコードのみを表示します。同じ講座が異なる時限に開講される場合や、異なる講座が同じ時限に開講される場合は、別々のレコードとして表示されます。

## COUNT関数との組み合わせ

DISTINCTはCOUNT関数と組み合わせることで、一意の値の数を数えることができます。

### 例4：一意の値の数を数える

例えば、学生（students）テーブルに何人の学生が登録されているかを数えるには：

```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

実行結果：

| 学生総数 |
|---------|
| 100     |

一方、受講（student_courses）テーブルに登録されている一意の学生数を数えるには：

```sql
SELECT COUNT(DISTINCT student_id) AS 受講学生数 FROM student_courses;
```

実行結果：

| 受講学生数 |
|-----------|
| 85        |

この2つの結果の差は、まだ1つも講座を受講していない学生が15人いることを意味します。

## DISTINCTとNULLの扱い

DISTINCTを使う場合、NULL値も1つの値として扱われます。複数のNULL値は1つのNULL値として集約されます。

### 例5：NULLを含むデータでのDISTINCT

例えば、出席（attendance）テーブルから、コメント（comment）の一意の値を取得するとします：

```sql
SELECT DISTINCT comment FROM attendance;
```

実行結果：

| comment       |
|---------------|
| NULL          |
| 15分遅刻      |
| 5分遅刻       |
| 事前連絡あり  |
| 体調不良      |
| ...           |

この結果には、NULL値も1つの行として含まれています。

## DISTINCTとORDER BYの組み合わせ

DISTINCTはORDER BY句と組み合わせて使うことができます。これにより、重複を除外した後で結果を並べ替えることができます。

### 例6：DISTINCTとORDER BYの組み合わせ

例えば、講座（courses）テーブルから、どの教師（teacher_id）が講座を担当しているかを重複なしで取得し、教師IDの順に並べるには：

```sql
SELECT DISTINCT teacher_id FROM courses ORDER BY teacher_id;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

## DISTINCTとWHEREの組み合わせ

DISTINCTはWHERE句と組み合わせて使うこともできます。これにより、特定の条件に合うレコードだけを対象に重複を除外できます。

### 例7：DISTINCTとWHEREの組み合わせ

例えば、2025年5月に授業がある教室（classroom_id）の一覧を重複なしで取得するには：

```sql
SELECT DISTINCT classroom_id
FROM course_schedule
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

実行結果：

| classroom_id |
|--------------|
| 101A         |
| 102B         |
| 201C         |
| 202D         |
| ...          |

## DISTINCTとGROUP BYの違い

DISTINCTとGROUP BYはどちらも「重複を除外する」という点では似ていますが、目的と使い方に違いがあります。

- **DISTINCT**：単純に重複する行を除外します。
- **GROUP BY**：グループごとに集計を行うために使います。集計関数（COUNT、SUM、AVG、MAX、MINなど）と一緒に使うことが一般的です。

### 例8：DISTINCTとGROUP BYの比較

例えば、講座（courses）テーブルから、どの教師（teacher_id）が講座を担当しているかを調べる場合：

DISTINCTを使う方法：
```sql
SELECT DISTINCT teacher_id FROM courses;
```

GROUP BYを使う方法：
```sql
SELECT teacher_id FROM courses GROUP BY teacher_id;
```

両方とも同じ結果を返しますが、目的が異なります。GROUP BYは集計を行うためのもので、例えば各教師が担当する講座数を数えたい場合は：

```sql
SELECT teacher_id, COUNT(*) AS 担当講座数
FROM courses
GROUP BY teacher_id;
```

このように、GROUP BYと集計関数を組み合わせて使います。

## パフォーマンスへの影響と注意点

1. **処理コスト**：DISTINCTはすべての行を調査して重複を除外するため、大量のデータがある場合は処理コストが高くなる可能性があります。

2. **代替手段の検討**：場合によっては、DISTINCTの代わりにGROUP BYを使ったり、EXISTS/NOT EXISTSを使ったりと、より効率的な方法があることがあります。

3. **部分一致には使えない**：DISTINCTは完全に一致するレコードのみを対象とします。部分的な一致や似ているレコードの除外には使えません。

## 練習問題

### 問題12-1
course_schedule（授業カレンダー）テーブルから、授業が行われる日付（schedule_date）のリストを重複なしで取得するSQLを書いてください。

### 問題12-2
grades（成績）テーブルから、何種類の評価タイプ（grade_type）があるかを数えるSQLを書いてください。

### 問題12-3
student_courses（受講）テーブルから、講座を受講している学生ID（student_id）を重複なしで取得し、IDの昇順に並べるSQLを書いてください。

### 問題12-4
course_schedule（授業カレンダー）テーブルから、どの教室（classroom_id）でどの時限（period_id）に授業が行われているかの組み合わせを重複なしで取得するSQLを書いてください。

### 問題12-5
attendance（出席）テーブルから、コメント（comment）が入力されている（NULLでない）一意のコメント内容を取得するSQLを書いてください。

### 問題12-6
grades（成績）テーブルから、どの学生（student_id）がどの講座（course_id）を受講したかの組み合わせを重複なしで取得し、学生ID、講座IDの順に並べるSQLを書いてください。

## 解答

### 解答12-1
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

### 解答12-2
```sql
SELECT COUNT(DISTINCT grade_type) AS 評価タイプ数 FROM grades;
```

### 解答12-3
```sql
SELECT DISTINCT student_id FROM student_courses ORDER BY student_id;
```

### 解答12-4
```sql
SELECT DISTINCT classroom_id, period_id FROM course_schedule;
```

### 解答12-5
```sql
SELECT DISTINCT comment FROM attendance WHERE comment IS NOT NULL;
```

### 解答12-6
```sql
SELECT DISTINCT student_id, course_id 
FROM grades 
ORDER BY student_id, course_id;
```

## まとめ

この章では、クエリ結果から重複を除外するためのDISTINCTキーワードについて学びました：

1. **DISTINCTの基本**：クエリ結果から重複する行を除外する方法
2. **単一カラムでの使用**：1つのカラムの重複を除外する方法
3. **複数カラムでの使用**：複数カラムの組み合わせの重複を除外する方法
4. **COUNT関数との組み合わせ**：一意の値の数を数える方法
5. **NULLの扱い**：DISTINCT使用時のNULL値の取り扱い
6. **ORDER BYとの組み合わせ**：重複除外後の並べ替え
7. **WHEREとの組み合わせ**：条件付きでの重複除外
8. **GROUP BYとの違い**：似た機能を持つGROUP BYとの使い分け
9. **パフォーマンスへの影響**：DISTINCTを使用する際の注意点

DISTINCTは、データベースから一意の値のリストを取得するための便利な機能です。特に、テーブル内の特定のカラムにどのような値が存在するかを調べたい場合や、重複のないマスターリストを作成したい場合に役立ちます。

次の章では、複数のテーブルを結合して情報を取得するための「JOIN基本：テーブル結合の概念」について学びます。



---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [1. SELECT基本：単一テーブルから特定カラムを取得する](#1-select基本単一テーブルから特定カラムを取得する)
2. [2. WHERE句：条件に合ったレコードを絞り込む](#2-where句条件に合ったレコードを絞り込む)
3. [3. 論理演算子：AND、OR、NOTを使った複合条件](#3-論理演算子andornotを使った複合条件)
4. [4. パターンマッチング：LIKE演算子と%、_ワイルドカード](#4-パターンマッチングlike演算子と_ワイルドカード)
5. [5. 範囲指定：BETWEEN、IN演算子](#5-範囲指定betweenin演算子)
6. [6. NULL値の処理：IS NULL、IS NOT NULL](#6-null値の処理is-nullis-not-null)
7. [7. ORDER BY：結果の並び替え](#7-order-by結果の並び替え)
8. [8. LIMIT句：結果件数の制限とページネーション](#8-limit句結果件数の制限とページネーション)

---


# 1. SELECT基本：単一テーブルから特定カラムを取得する

## はじめに

データベースからデータを取り出す作業は、料理人が大きな冷蔵庫から必要な材料だけを取り出すようなものです。SQLでは、この「取り出す」作業を「SELECT文」で行います。

SELECT文はSQLの中で最も基本的で、最もよく使われる命令です。この章では、単一のテーブル（データの表）から必要な情報だけを取り出す方法を学びます。

## 基本構文

SELECT文の最も基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名;
```

この文は「テーブル名というテーブルからカラム名という列のデータを取り出してください」という意味です。

> **用語解説**：
> - **SELECT**：「選択する」という意味のSQLコマンドで、データを取り出すときに使います。
> - **カラム**：テーブルの縦の列のことで、同じ種類のデータが並んでいます（例：名前のカラム、年齢のカラムなど）。
> - **FROM**：「〜から」という意味で、どのテーブルからデータを取るかを指定します。
> - **テーブル**：データベース内の表のことで、行と列で構成されています。

## 実践例：単一カラムの取得

学校データベースの中の「teachers」テーブル（教師テーブル）から、教師の名前だけを取得してみましょう。

```sql
SELECT teacher_name FROM teachers;
```

実行結果：

| teacher_name |
|--------------|
| 寺内鞍       |
| 田尻朋美     |
| 内村海凪     |
| 藤本理恵     |
| 黒木大介     |
| 星野涼子     |
| 深山誠一     |
| 吉岡由佳     |
| 山田太郎     |
| 佐藤花子     |
| ...          |

これは「teachers」テーブルの「teacher_name」という列（先生の名前）だけを取り出しています。

## 複数のカラムを取得する

料理に複数の材料が必要なように、データを取り出すときも複数の列が必要なことがよくあります。複数のカラムを取得するには、カラム名をカンマ（,）で区切って指定します。

```sql
SELECT カラム名1, カラム名2, カラム名3 FROM テーブル名;
```

例えば、教師の番号（ID）と名前を一緒に取得してみましょう：

```sql
SELECT teacher_id, teacher_name FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| 104        | 藤本理恵     |
| 105        | 黒木大介     |
| 106        | 星野涼子     |
| ...        | ...          |

## すべてのカラムを取得する

テーブルのすべての列を取得したい場合は、アスタリスク（*）を使います。これは「すべての列」を意味するワイルドカードです。

```sql
SELECT * FROM テーブル名;
```

例：
```sql
SELECT * FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| ...        | ...          |

> **注意**：`SELECT *`は便利ですが、実際の業務では必要なカラムだけを指定する方が良いとされています。これは、データ量が多いときに処理速度が遅くなるのを防ぐためです。

## カラムに別名をつける（AS句）

取得したカラムに分かりやすい名前（別名）をつけることができます。これは「AS」句を使います。

```sql
SELECT カラム名 AS 別名 FROM テーブル名;
```

> **用語解説**：
> - **AS**：「〜として」という意味で、カラムに別名をつけるときに使います。この別名は結果を表示するときだけ使われます。

例えば、教師IDを「番号」、教師名を「名前」として表示してみましょう：

```sql
SELECT teacher_id AS 番号, teacher_name AS 名前 FROM teachers;
```

実行結果：

| 番号  | 名前       |
|------|------------|
| 101  | 寺内鞍     |
| 102  | 田尻朋美   |
| 103  | 内村海凪   |
| ...  | ...        |

ASは省略することも可能です：

```sql
SELECT teacher_id 番号, teacher_name 名前 FROM teachers;
```

## 計算式を使う

SELECT文では、カラムの値を使った計算もできます。例えば、成績テーブルから点数と満点を取得して、達成率（パーセント）を計算してみましょう。

```sql
SELECT student_id, course_id, grade_type, 
       score, max_score,
       (score / max_score) * 100 AS 達成率
FROM grades;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 301        | 1         | 中間テスト   | 85.5  | 100.0     | 85.5     |
| 302        | 1         | 中間テスト   | 92.0  | 100.0     | 92.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

## 重複を除外する（DISTINCT）

同じ値が複数ある場合に、重複を除いて一意の値だけを表示するには「DISTINCT」キーワードを使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別された」という意味で、重複する値を除外して一意の値だけを取得します。

例えば、どの講座にどの教師が担当しているかを重複なしで確認してみましょう：

```sql
SELECT DISTINCT teacher_id FROM courses;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

これにより、courses（講座）テーブルで使われている教師IDが重複なく表示されます。

## 文字列の結合

文字列を結合するには、MySQLでは「CONCAT」関数を使います。例えば、教師のIDと名前を組み合わせて表示してみましょう：

```sql
SELECT CONCAT('教師ID:', teacher_id, ' 名前:', teacher_name) AS 教師情報
FROM teachers;
```

実行結果：

| 教師情報                  |
|--------------------------|
| 教師ID:101 名前:寺内鞍   |
| 教師ID:102 名前:田尻朋美 |
| ...                      |

> **用語解説**：
> - **CONCAT**：複数の文字列を一つにつなげる関数です。

## SELECT文と終了記号

SQLの文は通常、セミコロン（;）で終わります。これは「この命令はここで終わりです」という合図です。

複数のSQL文を一度に実行する場合は、それぞれの文の最後にセミコロンをつけます。

## 練習問題

### 問題1-1
students（学生）テーブルから、すべての学生の名前（student_name）を取得するSQLを書いてください。

### 問題1-2
classrooms（教室）テーブルから、教室ID（classroom_id）と教室名（classroom_name）を取得するSQLを書いてください。

### 問題1-3
courses（講座）テーブルから、すべての列（カラム）を取得するSQLを書いてください。

### 問題1-4
class_periods（授業時間）テーブルから、時限ID（period_id）、開始時間（start_time）、終了時間（end_time）を取得し、開始時間には「開始」、終了時間には「終了」という別名をつけるSQLを書いてください。

### 問題1-5
grades（成績）テーブルから、学生ID（student_id）、講座ID（course_id）、評価タイプ（grade_type）、得点（score）、満点（max_score）、そして得点を満点で割って100を掛けた値を「パーセント」という別名で取得するSQLを書いてください。

### 問題1-6
course_schedule（授業カレンダー）テーブルから、schedule_date（予定日）カラムだけを重複なしで取得するSQLを書いてください。

## 解答

### 解答1-1
```sql
SELECT student_name FROM students;
```

### 解答1-2
```sql
SELECT classroom_id, classroom_name FROM classrooms;
```

### 解答1-3
```sql
SELECT * FROM courses;
```

### 解答1-4
```sql
SELECT period_id, start_time AS 開始, end_time AS 終了 FROM class_periods;
```

### 解答1-5
```sql
SELECT student_id, course_id, grade_type, score, max_score,
       (score / max_score) * 100 AS パーセント
FROM grades;
```

### 解答1-6
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

## まとめ

この章では、SQLのSELECT文の基本を学びました：

1. 単一カラムの取得: `SELECT カラム名 FROM テーブル名;`
2. 複数カラムの取得: `SELECT カラム名1, カラム名2 FROM テーブル名;`
3. すべてのカラムの取得: `SELECT * FROM テーブル名;`
4. カラムに別名をつける: `SELECT カラム名 AS 別名 FROM テーブル名;`
5. 計算式を使う: `SELECT カラム名, (計算式) AS 別名 FROM テーブル名;`
6. 重複を除外する: `SELECT DISTINCT カラム名 FROM テーブル名;`
7. 文字列の結合: `SELECT CONCAT(文字列1, カラム名, 文字列2) FROM テーブル名;`

これらの基本操作を使いこなせるようになれば、データベースから必要な情報を効率よく取り出せるようになります。次の章では、WHERE句を使って条件に合ったデータだけを取り出す方法を学びます。



---

# 2. WHERE句：条件に合ったレコードを絞り込む

## はじめに

前章では、テーブルからデータを取得する基本的な方法を学びました。しかし実際の業務では、すべてのデータではなく、特定の条件に合ったデータだけを取得したいことがほとんどです。

例えば、「全生徒の情報」ではなく「特定の学科の生徒だけ」や「成績が80点以上の学生だけ」といった形で、データを絞り込みたい場合があります。

このような場合に使用するのが「WHERE句」です。WHERE句は、SELECTコマンドの後に追加して使い、条件に合致するレコード（行）だけを取得します。

## 基本構文

WHERE句の基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件式;
```

> **用語解説**：
> - **WHERE**：「〜の場所で」「〜の条件で」という意味のSQLコマンドで、条件に合うデータだけを抽出するために使います。
> - **条件式**：データが満たすべき条件を指定するための式です。例えば「age > 20」（年齢が20より大きい）などです。
> - **レコード**：テーブルの横の行のことで、1つのデータの集まりを表します。

## 基本的な比較演算子

WHERE句では、様々な比較演算子を使って条件を指定できます：

| 演算子 | 意味                   | 例                    |
|--------|------------------------|------------------------|
| =      | 等しい                 | age = 25               |
| <>     | 等しくない（≠と同じ）  | gender <> 'male'       |
| >      | より大きい             | score > 80             |
| <      | より小さい             | price < 1000           |
| >=     | 以上                   | height >= 170          |
| <=     | 以下                   | weight <= 70           |

## 実践例：基本的な条件での絞り込み

### 例1：等しい（=）
例えば、教師ID（teacher_id）が101の教師のみを取得するには：

```sql
SELECT * FROM teachers WHERE teacher_id = 101;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |

### 例2：より大きい（>）
成績（grades）テーブルから、90点を超える成績だけを取得するには：

```sql
SELECT * FROM grades WHERE score > 90;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例3：等しくない（<>）
講座IDが3ではない講座に関する成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id <> '3';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト  | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 301        | 2         | 実技試験    | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 文字列の比較

テキスト（文字列）を条件にする場合は、シングルクォーテーション（'）またはダブルクォーテーション（"）で囲みます。MySQLではどちらも使えますが、多くの場合シングルクォーテーションが推奨されます。

```sql
SELECT * FROM テーブル名 WHERE テキストカラム = 'テキスト値';
```

例えば、教師名（teacher_name）が「田尻朋美」の教師を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name = '田尻朋美';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |

## 日付の比較

日付の比較も同様にシングルクォーテーションで囲みます。日付の形式はデータベースの設定によって異なりますが、一般的にはISO形式（YYYY-MM-DD）が使われます。

```sql
SELECT * FROM テーブル名 WHERE 日付カラム = '日付';
```

例えば、2025年5月20日に提出された成績を検索するには：

```sql
SELECT * FROM grades WHERE submission_date = '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

また、日付同士の大小関係も比較できます：

```sql
SELECT * FROM grades WHERE submission_date < '2025-05-15';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | レポート1   | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1   | 48.0  | 50.0      | 2025-05-10      |
| 304        | 5         | ER図作成課題 | 27.5  | 30.0      | 2025-05-14      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 複数の条件を指定する（次章の内容）

WHERE句では、複数の条件を組み合わせることもできます。この詳細は次章「論理演算子：AND、OR、NOTを使った複合条件」で説明します。

例えば、講座IDが1で、かつ、得点が90以上の成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id = '1' AND score >= 90;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題2-1
students（学生）テーブルから、学生ID（student_id）が「310」の学生情報を取得するSQLを書いてください。

### 問題2-2
classrooms（教室）テーブルから、収容人数（capacity）が30人より多い教室の情報をすべて取得するSQLを書いてください。

### 問題2-3
courses（講座）テーブルから、教師ID（teacher_id）が「105」の講座情報を取得するSQLを書いてください。

### 問題2-4
course_schedule（授業カレンダー）テーブルから、「2025-05-15」の授業スケジュールをすべて取得するSQLを書いてください。

### 問題2-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」で、得点（score）が80点未満の成績を取得するSQLを書いてください。

### 問題2-6
teachers（教師）テーブルから、教師ID（teacher_id）が「101」ではない教師の名前を取得するSQLを書いてください。

## 解答

### 解答2-1
```sql
SELECT * FROM students WHERE student_id = 310;
```

### 解答2-2
```sql
SELECT * FROM classrooms WHERE capacity > 30;
```

### 解答2-3
```sql
SELECT * FROM courses WHERE teacher_id = 105;
```

### 解答2-4
```sql
SELECT * FROM course_schedule WHERE schedule_date = '2025-05-15';
```

### 解答2-5
```sql
SELECT * FROM grades WHERE grade_type = '中間テスト' AND score < 80;
```

### 解答2-6
```sql
SELECT teacher_name FROM teachers WHERE teacher_id <> 101;
```

## まとめ

この章では、WHERE句を使って条件に合ったレコードを取得する方法を学びました：

1. 基本的な比較演算子（=, <>, >, <, >=, <=）の使い方
2. 数値による条件絞り込み
3. 文字列（テキスト）による条件絞り込み
4. 日付による条件絞り込み

WHERE句は、大量のデータから必要な情報だけを取り出すための非常に重要な機能です。実際のデータベース操作では、この条件絞り込みを頻繁に使います。

次の章では、複数の条件を組み合わせるための「論理演算子（AND、OR、NOT）」について学びます。



---

# 3. 論理演算子：AND、OR、NOTを使った複合条件

## はじめに

前章では、WHERE句を使って単一の条件でデータを絞り込む方法を学びました。しかし実際の業務では、より複雑な条件でデータを絞り込む必要があることがよくあります。

例えば：
- 「成績が80点以上**かつ**出席率が90%以上の学生」
- 「数学**または**英語の成績が優秀な学生」
- 「課題を**まだ提出していない**学生」

このような複合条件を指定するために使うのが論理演算子です。主な論理演算子は次の3つです：

- **AND**：両方の条件を満たす（かつ）
- **OR**：いずれかの条件を満たす（または）
- **NOT**：条件を満たさない（〜ではない）

## AND演算子

AND演算子は、指定した**すべての条件を満たす**レコードだけを取得したいときに使います。

> **用語解説**：
> - **AND**：「かつ」「そして」という意味の論理演算子です。複数の条件をすべて満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 AND 条件2;
```

### 例：ANDを使った複合条件

例えば、中間テストで90点以上かつ満点が100点の成績レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

この例では、「score >= 90」と「max_score = 100」の両方の条件を満たすレコードだけが取得されます。

### 3つ以上の条件の組み合わせ

ANDを使って3つ以上の条件を組み合わせることもできます：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100 AND grade_type = '中間テスト';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## OR演算子

OR演算子は、指定した条件の**いずれか一つでも満たす**レコードを取得したいときに使います。

> **用語解説**：
> - **OR**：「または」「もしくは」という意味の論理演算子です。複数の条件のうち少なくとも1つを満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 OR 条件2;
```

### 例：ORを使った複合条件

例えば、教師IDが101または102の講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id = 101 OR teacher_id = 102;
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 2         | UNIX入門             | 102        |
| 3         | Cプログラミング演習    | 101        |
| 29        | コードリファクタリングとクリーンコード | 101 |
| 40        | ソフトウェアアーキテクチャパターン | 102 |
| ...       | ...                  | ...        |

この例では、「teacher_id = 101」または「teacher_id = 102」のいずれかの条件を満たすレコードが取得されます。

## NOT演算子

NOT演算子は、指定した条件を**満たさない**レコードを取得したいときに使います。

> **用語解説**：
> - **NOT**：「〜ではない」という意味の論理演算子です。条件を否定して、その条件を満たさないデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE NOT 条件;
```

### 例：NOTを使った否定条件

例えば、完了（completed）状態ではない授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
WHERE NOT status = 'completed';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 45          | 11        | 2025-05-20    | 5         | 401G         | 106        | scheduled |
| 46          | 12        | 2025-05-21    | 1         | 301E         | 107        | scheduled |
| 50          | 2         | 2025-05-23    | 3         | 101A         | 102        | cancelled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

この例では、statusが「completed」ではないレコード（scheduled状態やcancelled状態）が取得されます。

NOT演算子は、「〜ではない」という否定の条件を作るために使われます。例えば次の2つの書き方は同じ意味になります：

```sql
SELECT * FROM teachers WHERE NOT teacher_id = 101;
SELECT * FROM teachers WHERE teacher_id <> 101;
```

## 複合論理条件（AND、OR、NOTの組み合わせ）

AND、OR、NOTを組み合わせて、より複雑な条件を指定することもできます。

### 例：ANDとORの組み合わせ

例えば、「成績が90点以上で中間テストである」または「成績が45点以上でレポートである」レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE (score >= 90 AND grade_type = '中間テスト') 
   OR (score >= 45 AND grade_type = 'レポート1');
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 308        | 1         | レポート1  | 47.0  | 50.0      | 2025-05-09      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 優先順位と括弧の使用

論理演算子を組み合わせる場合、演算子の優先順位に注意が必要です。基本的に**ANDはORよりも優先順位が高い**です。つまり、ANDが先に処理されます。

例えば：
```sql
WHERE 条件1 OR 条件2 AND 条件3
```

これは次のように解釈されます：
```sql
WHERE 条件1 OR (条件2 AND 条件3)
```

意図した条件と異なる場合は、**括弧（）を使って明示的にグループ化**することが重要です：
```sql
WHERE (条件1 OR 条件2) AND 条件3
```

### 例：括弧を使った条件のグループ化

教師IDが101または102で、かつ、講座名に「プログラミング」という単語が含まれる講座を取得するには：

```sql
SELECT * FROM courses 
WHERE (teacher_id = 101 OR teacher_id = 102) 
  AND course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

この例では、括弧を使って「teacher_id = 101 OR teacher_id = 102」の部分をグループ化し、その条件と「course_name LIKE '%プログラミング%'」の条件をANDで結合しています。

## 練習問題

### 問題3-1
grades（成績）テーブルから、課題タイプ（grade_type）が「中間テスト」かつ点数（score）が85点以上のレコードを取得するSQLを書いてください。

### 問題3-2
classrooms（教室）テーブルから、収容人数（capacity）が40人以下または建物（building）が「1号館」の教室を取得するSQLを書いてください。

### 問題3-3
teachers（教師）テーブルから、教師ID（teacher_id）が101、102、103ではない教師の情報を取得するSQLを書いてください。

### 問題3-4
course_schedule（授業カレンダー）テーブルから、2025年5月20日の授業で、時限（period_id）が1か2で、かつ状態（status）が「scheduled」の授業を取得するSQLを書いてください。

### 問題3-5
students（学生）テーブルから、学生名（student_name）に「田」または「山」を含む学生を取得するSQLを書いてください。

### 問題3-6
grades（成績）テーブルから、提出日（submission_date）が2025年5月15日以降で、かつ（「中間テスト」で90点以上または「レポート1」で45点以上）の成績を取得するSQLを書いてください。

## 解答

### 解答3-1
```sql
SELECT * FROM grades 
WHERE grade_type = '中間テスト' AND score >= 85;
```

### 解答3-2
```sql
SELECT * FROM classrooms 
WHERE capacity <= 40 OR building = '1号館';
```

### 解答3-3
```sql
SELECT * FROM teachers 
WHERE NOT (teacher_id = 101 OR teacher_id = 102 OR teacher_id = 103);
```
または
```sql
SELECT * FROM teachers 
WHERE teacher_id <> 101 AND teacher_id <> 102 AND teacher_id <> 103;
```

### 解答3-4
```sql
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-20' 
  AND (period_id = 1 OR period_id = 2) 
  AND status = 'scheduled';
```

### 解答3-5
```sql
SELECT * FROM students 
WHERE student_name LIKE '%田%' OR student_name LIKE '%山%';
```

### 解答3-6
```sql
SELECT * FROM grades 
WHERE submission_date >= '2025-05-15' 
  AND ((grade_type = '中間テスト' AND score >= 90) 
       OR (grade_type = 'レポート1' AND score >= 45));
```

## まとめ

この章では、論理演算子（AND、OR、NOT）を使って複合条件を作る方法を学びました：

1. **AND**：すべての条件を満たすレコードを取得（条件1 AND 条件2）
2. **OR**：いずれかの条件を満たすレコードを取得（条件1 OR 条件2）
3. **NOT**：指定した条件を満たさないレコードを取得（NOT 条件）
4. **複合条件**：AND、OR、NOTを組み合わせたより複雑な条件
5. **括弧（）**：条件をグループ化して優先順位を明示的に指定

これらの論理演算子を使いこなすことで、より複雑で細かな条件でデータを絞り込むことができるようになります。実際のデータベース操作では、複数の条件を組み合わせることが頻繁にあるため、この章で学んだ内容は非常に重要です。

次の章では、テキストデータに対する検索を行う「パターンマッチング」について学びます。



---

# 4. パターンマッチング：LIKE演算子と%、_ワイルドカード

## はじめに

前章までは、データの完全一致や数値の比較といった条件での絞り込みを学びました。しかし実際の業務では、もっと柔軟な検索が必要なケースがあります。例えば：

- 「山」で始まる名前の学生を検索したい
- 「プログラミング」という単語を含む講座名を探したい
- 電話番号の一部だけ覚えているデータを探したい

このような「部分一致」や「パターン一致」の検索を行うためのSQLの機能が「パターンマッチング」です。この章では、パターンマッチングを行うための「LIKE演算子」と「ワイルドカード文字」について学びます。

## LIKE演算子の基本

LIKE演算子は、文字列のパターンマッチングを行うための演算子です。WHERE句と組み合わせて使用します。

> **用語解説**：
> - **LIKE**：「〜のような」という意味の演算子で、パターンに一致する文字列を検索します。
> - **パターンマッチング**：完全一致ではなく、一定のパターンに合致するデータを検索する方法です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 文字列カラム LIKE 'パターン';
```

パターンには、通常の文字に加えて、特別な意味を持つ「ワイルドカード文字」を使用できます。

## ワイルドカード文字

SQLでは主に2つのワイルドカード文字があります：

1. **%（パーセント）**：0文字以上の任意の文字列に一致します。
2. **_（アンダースコア）**：任意の1文字に一致します。

> **用語解説**：
> - **ワイルドカード**：任意の文字や文字列に一致する特殊な文字記号です。トランプのジョーカーのように、様々な値に代用できます。

## LIKE演算子の使い方：実践例

### 例1：%（パーセント）を使ったパターンマッチング

#### 「〜で始まる」パターン：前方一致

例えば、「山」で始まる学生名を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '山%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 山本裕子     |
| 325        | 山田翔太     |
| ...        | ...          |

ここでの「山%」は「山で始まり、その後に0文字以上の任意の文字が続く」という意味です。

#### 「〜で終わる」パターン：後方一致

例えば、「子」で終わる教師名を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name LIKE '%子';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| 106        | 星野涼子     |
| 108        | 吉岡由佳     |
| 110        | 佐藤花子     |
| ...        | ...          |

#### 「〜を含む」パターン：部分一致

例えば、「プログラミング」という単語を含む講座名を検索するには：

```sql
SELECT * FROM courses WHERE course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| 14        | IoTデバイスプログラミング実践 | 110 |
| ...       | ...                  | ...        |

### 例2：_（アンダースコア）を使ったパターンマッチング

アンダースコアは任意の1文字に一致します。例えば、教室IDが「10_A」パターン（最初の2文字が「10」、3文字目が任意の1文字、最後が「A」）の教室を検索するには：

```sql
SELECT * FROM classrooms WHERE classroom_id LIKE '10_A';
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| ...          | ...            | ...      | ...      | ...        |

### 例3：%と_の組み合わせ

ワイルドカード文字は組み合わせて使うこともできます。例えば、「2文字目が田」の学生を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '_田%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 384        | 櫻井翼       |
| ...        | ...          |

## NOT LIKEを使った否定形のパターンマッチング

特定のパターンに一致しないレコードを検索したい場合は、「NOT LIKE」を使います。

> **用語解説**：
> - **NOT LIKE**：「〜のパターンに一致しない」という意味で、指定したパターンに一致しないデータを検索します。

例えば、講座名に「入門」を含まない講座を検索するには：

```sql
SELECT * FROM courses WHERE course_name NOT LIKE '%入門%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

## エスケープ文字の使用

もし検索したいパターンに「%」や「_」自体が含まれている場合は、それらを特別な文字としてではなく、通常の文字として扱うために「エスケープ文字」を使います。

> **用語解説**：
> - **エスケープ文字**：特別な意味を持つ文字を通常の文字として扱うための印です。

MySQLでは、バックスラッシュ（\）をエスケープ文字として使用できます。例えば、「50%」という値そのものを検索するには：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50\%';
```

または、ESCAPE句を使って明示的にエスケープ文字を指定することもできます：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50!%' ESCAPE '!';
```

この例では「!」をエスケープ文字として指定しています。

## 大文字と小文字の区別

MySQLのデフォルト設定では、LIKE演算子は大文字と小文字を区別しません（大文字小文字を同じものとして扱います）。

例えば、次の2つのクエリは同じ結果を返します：

```sql
SELECT * FROM courses WHERE course_name LIKE '%web%';
SELECT * FROM courses WHERE course_name LIKE '%Web%';
```

もし大文字と小文字を区別した検索が必要な場合は、「BINARY」キーワードを使用します：

```sql
SELECT * FROM courses WHERE course_name LIKE BINARY '%Web%';
```

この場合、「Web」は「web」とは一致しません。

## 複合条件との組み合わせ

LIKE演算子は、これまで学んだAND、OR、NOTなどの論理演算子と組み合わせて使うこともできます。

例えば、「田」で始まる名前で、かつ教師IDが102から105の間の教師を検索するには：

```sql
SELECT * FROM teachers 
WHERE teacher_name LIKE '田%' 
  AND teacher_id BETWEEN 102 AND 105;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| ...        | ...          |

## 練習問題

### 問題4-1
students（学生）テーブルから、学生名（student_name）が「佐藤」で始まる学生の情報をすべて取得するSQLを書いてください。

### 問題4-2
courses（講座）テーブルから、講座名（course_name）に「データ」という単語を含む講座の情報を取得するSQLを書いてください。

### 問題4-3
classrooms（教室）テーブルから、教室名（classroom_name）が「コンピュータ実習室」で終わる教室の情報を取得するSQLを書いてください。

### 問題4-4
teachers（教師）テーブルから、教師名（teacher_name）の2文字目が「木」である教師の情報を取得するSQLを書いてください。

### 問題4-5
courses（講座）テーブルから、講座名（course_name）に「入門」または「基礎」を含む講座を取得するSQLを書いてください。

### 問題4-6
students（学生）テーブルから、学生名（student_name）が「山」で始まり、かつ「子」で終わらない学生を取得するSQLを書いてください。

## 解答

### 解答4-1
```sql
SELECT * FROM students WHERE student_name LIKE '佐藤%';
```

### 解答4-2
```sql
SELECT * FROM courses WHERE course_name LIKE '%データ%';
```

### 解答4-3
```sql
SELECT * FROM classrooms WHERE classroom_name LIKE '%コンピュータ実習室';
```

### 解答4-4
```sql
SELECT * FROM teachers WHERE teacher_name LIKE '_木%';
```

### 解答4-5
```sql
SELECT * FROM courses 
WHERE course_name LIKE '%入門%' OR course_name LIKE '%基礎%';
```

### 解答4-6
```sql
SELECT * FROM students 
WHERE student_name LIKE '山%' AND student_name NOT LIKE '%子';
```

## まとめ

この章では、パターンマッチングを行うためのLIKE演算子と、その中で使用するワイルドカード文字（%と_）について学びました：

1. **LIKE演算子**：文字列パターンに一致するデータを検索するための演算子
2. **%（パーセント）**：0文字以上の任意の文字列に一致するワイルドカード
3. **_（アンダースコア）**：任意の1文字に一致するワイルドカード
4. **前方一致**：「パターン%」で「パターンで始まる」文字列に一致
5. **後方一致**：「%パターン」で「パターンで終わる」文字列に一致
6. **部分一致**：「%パターン%」で「パターンを含む」文字列に一致
7. **NOT LIKE**：指定したパターンに一致しないデータを検索
8. **エスケープ文字**：特殊文字（%や_）を通常の文字として扱うための方法
9. **複合条件との組み合わせ**：AND、ORなどと組み合わせたより複雑な条件

パターンマッチングは、特にテキストデータを扱う際に非常に便利な機能です。部分的な情報しか持っていない場合や、特定のパターンを持つデータを探す場合に活用できます。

次の章では、範囲指定のための「BETWEEN演算子」と「IN演算子」について学びます。



---

# 5. 範囲指定：BETWEEN、IN演算子

## はじめに

これまでの章では、等号（=）や不等号（>、<）を使って条件を指定する方法や、LIKE演算子を使ったパターンマッチングを学びました。この章では、値の範囲を指定する「BETWEEN演算子」と、複数の値を一度に指定できる「IN演算子」について学びます。

これらの演算子を使うと、次のような検索がより簡単になります：
- 「80点から90点の間の成績」
- 「2025年4月から6月の間のスケジュール」
- 「特定の教師IDリストに該当する講座」

## BETWEEN演算子：範囲を指定する

BETWEEN演算子は、ある値が指定した範囲内にあるかどうかを調べるために使います。

> **用語解説**：
> - **BETWEEN**：「〜の間に」という意味の演算子で、ある値が指定した最小値と最大値の間（両端の値を含む）にあるかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 BETWEEN 最小値 AND 最大値;
```

この構文は次の条件と同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 >= 最小値 AND カラム名 <= 最大値;
```

### 例1：数値範囲の指定

例えば、成績（grades）テーブルから、80点から90点の間の成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 308        | 6         | 小テスト1  | 89.0  | 100.0     | 2025-05-15      |
| ...        | ...       | ...        | ...   | ...       | ...             |

### 例2：日付範囲の指定

日付にもBETWEEN演算子が使えます。例えば、2025年5月10日から2025年5月20日までに提出された成績を取得するには：

```sql
SELECT * FROM grades 
WHERE submission_date BETWEEN '2025-05-10' AND '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | レポート1  | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## NOT BETWEEN：範囲外を指定する

NOT BETWEENを使うと、指定した範囲の外にある値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT BETWEEN 最小値 AND 最大値;
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 < 最小値 OR カラム名 > 最大値;
```

### 例：範囲外の値を取得

例えば、80点未満または90点より高い成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score NOT BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## IN演算子：複数の値を指定する

IN演算子は、ある値が指定した複数の値のリストのいずれかに一致するかどうかを調べるために使います。

> **用語解説**：
> - **IN**：「〜の中に含まれる」という意味の演算子で、ある値が指定したリストの中に含まれているかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (値1, 値2, 値3, ...);
```

この構文は次のOR条件の組み合わせと同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 = 値1 OR カラム名 = 値2 OR カラム名 = 値3 OR ...;
```

### 例1：数値リストの指定

例えば、教師ID（teacher_id）が101、103、105のいずれかである講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (101, 103, 105);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| 5         | データベース設計と実装  | 105        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

### 例2：文字列リストの指定

文字列のリストにも適用できます。例えば、特定の教室ID（classroom_id）のみの教室情報を取得するには：

```sql
SELECT * FROM classrooms 
WHERE classroom_id IN ('101A', '202D', '301E');
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| 202D         | 2号館コンピュータ実習室D | 25     | 2号館     | パソコン25台、プロジェクター、3Dプリンター |
| 301E         | 3号館講義室E      | 80       | 3号館     | プロジェクター、マイク設備、録画設備 |

## NOT IN：リストに含まれない値を指定する

NOT IN演算子を使うと、指定したリストに含まれない値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT IN (値1, 値2, 値3, ...);
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 <> 値1 AND カラム名 <> 値2 AND カラム名 <> 値3 AND ...;
```

### 例：リストに含まれない値を取得

例えば、教師IDが101、102、103以外の教師が担当する講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id NOT IN (101, 102, 103);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 4         | Webアプリケーション開発 | 104        |
| 5         | データベース設計と実装  | 105        |
| 6         | ネットワークセキュリティ | 107        |
| ...       | ...                  | ...        |

## IN演算子でのサブクエリの利用（基本）

IN演算子の括弧内には、直接値を書く代わりに、サブクエリ（別のSELECT文）を指定することもできます。これにより、動的に値のリストを生成できます。

> **用語解説**：
> - **サブクエリ**：SQL文の中に含まれる別のSQL文のことで、外側のSQL文（メインクエリ）に値や条件を提供します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (SELECT カラム名 FROM 別テーブル WHERE 条件);
```

### 例：サブクエリを使ったIN条件

例えば、教師名（teacher_name）に「田」を含む教師が担当している講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (
    SELECT teacher_id FROM teachers 
    WHERE teacher_name LIKE '%田%'
);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 2         | UNIX入門             | 102        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

この例では、まず「teachers」テーブルから名前に「田」を含む教師のIDを取得し、それらのIDを持つ講座を「courses」テーブルから取得しています。

## BETWEEN演算子とIN演算子の組み合わせ

BETWEEN演算子とIN演算子は、論理演算子（AND、OR）と組み合わせて、さらに複雑な条件を作ることができます。

### 例：BETWEENとINの組み合わせ

例えば、「教師IDが101、103、105のいずれかで、かつ、2025年5月15日から2025年6月15日の間に実施される授業」を取得するには：

```sql
SELECT * FROM course_schedule 
WHERE teacher_id IN (101, 103, 105) 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-06-15';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 38          | 1         | 2025-05-20    | 1         | 102B         | 101        | scheduled |
| 42          | 10        | 2025-05-23    | 3         | 201C         | 103        | scheduled |
| 45          | 5         | 2025-05-28    | 2         | 402H         | 105        | scheduled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

## 練習問題

### 問題5-1
grades（成績）テーブルから、得点（score）が85点から95点の間にある成績を取得するSQLを書いてください。

### 問題5-2
course_schedule（授業カレンダー）テーブルから、2025年5月1日から2025年5月31日までの授業スケジュールを取得するSQLを書いてください。

### 問題5-3
courses（講座）テーブルから、教師ID（teacher_id）が104、106、108のいずれかである講座の情報を取得するSQLを書いてください。

### 問題5-4
classrooms（教室）テーブルから、教室ID（classroom_id）が「101A」、「201C」、「301E」、「401G」以外の教室情報を取得するSQLを書いてください。

### 問題5-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」または「実技試験」で、かつ得点（score）が80点から90点の間にない成績を取得するSQLを書いてください。

### 問題5-6
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）が「101A」、「202D」のいずれかで、かつ2025年5月15日から2025年5月30日の間に実施される授業スケジュールを取得するSQLを書いてください。

## 解答

### 解答5-1
```sql
SELECT * FROM grades 
WHERE score BETWEEN 85 AND 95;
```

### 解答5-2
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

### 解答5-3
```sql
SELECT * FROM courses 
WHERE teacher_id IN (104, 106, 108);
```

### 解答5-4
```sql
SELECT * FROM classrooms 
WHERE classroom_id NOT IN ('101A', '201C', '301E', '401G');
```

### 解答5-5
```sql
SELECT * FROM grades 
WHERE grade_type IN ('中間テスト', '実技試験') 
  AND score NOT BETWEEN 80 AND 90;
```

### 解答5-6
```sql
SELECT * FROM course_schedule 
WHERE classroom_id IN ('101A', '202D') 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-05-30';
```

## まとめ

この章では、範囲指定のための「BETWEEN演算子」と複数値指定のための「IN演算子」について学びました：

1. **BETWEEN演算子**：値が指定した範囲内（両端を含む）にあるかどうかをチェック
2. **NOT BETWEEN**：値が指定した範囲外にあるかどうかをチェック
3. **IN演算子**：値が指定したリストのいずれかに一致するかどうかをチェック
4. **NOT IN**：値が指定したリストのいずれにも一致しないかどうかをチェック
5. **サブクエリとIN**：動的に生成された値のリストを使用する方法
6. **複合条件**：BETWEEN、IN、論理演算子を組み合わせたより複雑な条件

これらの演算子を使うことで、複数の条件を指定する場合に、SQLをより簡潔に書くことができます。特に、多くの値を指定する場合や範囲条件を指定する場合に便利です。

次の章では、「NULL値の処理：IS NULL、IS NOT NULL」について学びます。



---

# 6. NULL値の処理：IS NULL、IS NOT NULL

## はじめに

データベースの世界では、データがない状態を表すために「NULL」という特別な値が使われます。NULLは「空」や「0」や「空白文字」とは異なる、「値が存在しない」または「不明」であることを表す特殊な概念です。

例えば、学校データベースでは次のようなシナリオがあります：
- まだ成績が付けられていない（NULL）
- コメントが入力されていない（NULL）
- 授業がキャンセルされたため教室が割り当てられていない（NULL）

この章では、NULL値を正しく処理するための「IS NULL」と「IS NOT NULL」演算子について学びます。

## NULLとは何か？

NULL値には、いくつかの特徴があります：

1. **値がない**：NULLは値がないことを表します。0でも空文字列（''）でもなく、値そのものが存在しないことを示します。
2. **不明**：データが不明であることを表す場合もあります。
3. **未設定**：まだ値が設定されていないことを表す場合もあります。
4. **比較できない**：NULLは通常の比較演算子（=, <, >など）で比較できません。

> **用語解説**：
> - **NULL**：データベースにおいて「値がない」または「不明」を表す特殊な値です。0や空文字とは異なります。

## NULL値と通常の比較演算子

通常の比較演算子（=, <>, >, <, >=, <=）では、NULL値を正しく検出できません。例えば：

```sql
-- この条件はNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 = NULL;

-- この条件もNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 <> NULL;
```

これは、NULL値との等価比較は「不明」と評価されるためです。つまり、NULL = NULLでさえFALSEではなく「不明」になります。

## IS NULL演算子

NULL値を持つレコードを検索するには、「IS NULL」演算子を使います。

> **用語解説**：
> - **IS NULL**：カラムの値がNULLかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NULL;
```

### 例：IS NULLの使用

例えば、コメントが入力されていない（NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

実行結果：

| schedule_id | student_id | status  | comment |
|-------------|------------|---------|---------|
| 1           | 301        | present | NULL    |
| 1           | 306        | present | NULL    |
| 1           | 307        | present | NULL    |
| ...         | ...        | ...     | NULL    |

## IS NOT NULL演算子

逆に、NULL値を持たないレコード（つまり、何らかの値を持つレコード）を検索するには、「IS NOT NULL」演算子を使います。

> **用語解説**：
> - **IS NOT NULL**：カラムの値がNULLでないかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NOT NULL;
```

### 例：IS NOT NULLの使用

例えば、コメントが入力されている（NOT NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 302        | late   | 15分遅刻      |
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |

## NULL値の論理的な扱い

NULL値は論理演算（AND、OR、NOT）でも特殊な扱いを受けます。

- **NULL AND TRUE** → NULL（不明）
- **NULL AND FALSE** → FALSE
- **NULL OR TRUE** → TRUE
- **NULL OR FALSE** → NULL（不明）
- **NOT NULL** → NULL（不明）

この特殊な振る舞いが、バグや誤った結果の原因になることがあります。

## NULL値と結合条件

テーブル結合（JOINなど、後の章で学習）の際も、NULL値は特殊な扱いを受けます。NULL値同士は「等しい」とは判定されないため、通常の結合条件ではNULL値を持つレコードは結合されません。

## IS NULLとIS NOT NULLを使った複合条件

IS NULLとIS NOT NULLも、他の条件と組み合わせて使用できます。

### 例：複合条件でのIS NULLの使用

例えば、「出席状態が "absent"（欠席）で、コメントがNULLでない（理由が入力されている）レコード」を検索するには：

```sql
SELECT * FROM attendance 
WHERE status = 'absent' AND comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |

## NVL/IFNULL/COALESCE関数：NULL値の置換

NULL値を別の値に置き換えるための関数が用意されています。データベースによって関数名が異なることがありますが、機能は似ています：

- MySQL/MariaDB: **IFNULL(expr, replace_value)**
- Oracle: **NVL(expr, replace_value)**
- SQL Server: **ISNULL(expr, replace_value)**
- 標準SQL: **COALESCE(expr1, expr2, ..., exprN)** - 最初のNULLでない式を返します

### 例：IFNULL関数の使用（MySQL）

例えば、コメントがNULLの場合は「特記事項なし」と表示するには：

```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '特記事項なし') AS comment
FROM attendance;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | 特記事項なし  |
| 1           | 302        | late    | 15分遅刻      |
| 1           | 303        | absent  | 事前連絡あり  |
| ...         | ...        | ...     | ...           |

## NULLを使う際の注意点

1. **除外の罠**：`WHERE カラム名 <> 値` だけでは、NULL値を持つレコードは含まれません。すべてのレコードを対象にするには：
   ```sql
   WHERE カラム名 <> 値 OR カラム名 IS NULL
   ```

2. **集計関数**：COUNT(*)はすべての行を数えますが、COUNT(カラム名)はそのカラムがNULLでない行だけを数えます。

3. **インデックス**：多くのデータベースでは、NULL値にもインデックスを適用できますが、データベースによって動作が異なる場合があります。

4. **一意性制約**：一般的に、UNIQUE制約ではNULL値は重複としてカウントされません（複数のNULL値が許可されます）。

## 練習問題

### 問題6-1
attendance（出席）テーブルから、コメント（comment）がNULLの出席レコードをすべて取得するSQLを書いてください。

### 問題6-2
course_schedule（授業カレンダー）テーブルから、状態（status）が「cancelled」で、かつ教室ID（classroom_id）がNULLでないレコードを取得するSQLを書いてください。

### 問題6-3
grades（成績）テーブルから、提出日（submission_date）がNULLの成績レコードを取得するSQLを書いてください。

### 問題6-4
attendance（出席）テーブルから、出席状態（status）が「present」か「late」で、かつコメント（comment）がNULLのレコードを取得するSQLを書いてください。

### 問題6-5
以下のSQLで教師（teachers）テーブルから「佐藤」という名前を持つ教師を検索する場合、NULL値を持つレコードも含めるにはどう修正すべきですか？
```sql
SELECT * FROM teachers WHERE teacher_name <> '佐藤花子';
```

### 問題6-6
attendance（出席）テーブルのすべてのレコードを取得し、コメント（comment）がNULLの場合は「記録なし」と表示するSQLを書いてください。

## 解答

### 解答6-1
```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

### 解答6-2
```sql
SELECT * FROM course_schedule 
WHERE status = 'cancelled' AND classroom_id IS NOT NULL;
```

### 解答6-3
```sql
SELECT * FROM grades WHERE submission_date IS NULL;
```

### 解答6-4
```sql
SELECT * FROM attendance 
WHERE (status = 'present' OR status = 'late') AND comment IS NULL;
```
または
```sql
SELECT * FROM attendance 
WHERE status IN ('present', 'late') AND comment IS NULL;
```

### 解答6-5
```sql
SELECT * FROM teachers 
WHERE teacher_name <> '佐藤花子' OR teacher_name IS NULL;
```

### 解答6-6
```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '記録なし') AS comment
FROM attendance;
```

## まとめ

この章では、データベースにおけるNULL値の概念と、NULL値を扱うための演算子や関数について学びました：

1. **NULL値の概念**：値がない、不明、未設定を表す特殊な値
2. **IS NULL演算子**：NULL値を持つレコードを検索する方法
3. **IS NOT NULL演算子**：NULL値を持たないレコードを検索する方法
4. **NULL値の論理的扱い**：論理演算（AND、OR、NOT）におけるNULLの振る舞い
5. **複合条件**：IS NULL/IS NOT NULLと他の条件の組み合わせ
6. **NULL値の置換**：IFNULL/NVL/COALESCE関数の使用方法
7. **注意点**：NULL値を扱う際の一般的な落とし穴

NULL値の正確な理解と適切な処理は、SQLプログラミングの重要な部分です。不適切なNULL処理は、予期しない結果やバグの原因になります。

次の章では、クエリ結果の並び替えを行うための「ORDER BY：結果の並び替え」について学びます。



---

# 7. ORDER BY：結果の並び替え

## はじめに

これまでの章では、データベースから条件に合ったレコードを取得する方法を学んできました。しかし実際の業務では、取得したデータを見やすく整理する必要があります。例えば：

- 成績を高い順に表示したい
- 学生を名前の五十音順に並べたい
- 日付の新しい順にスケジュールを確認したい

このようなデータの「並び替え」を行うためのSQLコマンドが「ORDER BY」です。この章では、クエリ結果を特定の順序で並べる方法を学びます。

## ORDER BYの基本

ORDER BY句は、SELECT文の結果を指定したカラムの値に基づいて並び替えるために使います。

> **用語解説**：
> - **ORDER BY**：「〜の順に並べる」という意味のSQLコマンドで、クエリ結果の並び順を指定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] ORDER BY 並び替えカラム;
```

ORDER BY句は通常、SELECT文の最後に記述します。

### 例1：単一カラムでの並び替え

例えば、学生（students）テーブルから、学生名（student_name）の五十音順（辞書順）でデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_name;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 309        | 相沢吉夫      |
| 303        | 柴崎春花      |
| 306        | 河田咲奈      |
| 305        | 河口菜恵子    |
| ...        | ...          |

### デフォルトの並び順

ORDER BYを使わない場合、結果の順序は保証されません。多くの場合、データがデータベースに保存された順序で返されますが、これは信頼できるものではありません。

## 昇順と降順の指定

ORDER BY句では、並び順を「昇順」か「降順」のどちらかで指定できます。

> **用語解説**：
> - **昇順（ASC）**：小さい値から大きい値へ（A→Z、1→9）の順に並べます。
> - **降順（DESC）**：大きい値から小さい値へ（Z→A、9→1）の順に並べます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 ORDER BY 並び替えカラム [ASC|DESC];
```

ASC（昇順）がデフォルトのため、省略可能です。

### 例2：降順での並び替え

例えば、成績（grades）テーブルから、得点（score）の高い順（降順）に成績を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 複数カラムでの並び替え

複数のカラムを使って並び替えることもできます。最初に指定したカラムで並び替え、値が同じレコードがある場合は次のカラムで並び替えます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 
ORDER BY 並び替えカラム1 [ASC|DESC], 並び替えカラム2 [ASC|DESC], ...;
```

### 例3：複数カラムでの並び替え

例えば、成績（grades）テーブルから、課題タイプ（grade_type）の五十音順に並べ、同じ課題タイプ内では得点（score）の高い順に成績を取得するには：

```sql
SELECT * FROM grades 
ORDER BY grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| 321        | 2         | 実技試験     | 85.5  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト   | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| 302        | 1         | レポート1    | 48.0  | 50.0      | 2025-05-10      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例4：昇順と降順の混合

各カラムごとに並び順を指定することもできます。例えば、講座ID（course_id）の昇順、評価タイプ（grade_type）の昇順、得点（score）の降順で並べるには：

```sql
SELECT * FROM grades 
ORDER BY course_id ASC, grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## NULLの扱い

ORDER BYでNULL値を並び替える場合、データベース製品によって動作が異なります。多くのデータベースでは、NULL値は最小値または最大値として扱われます。

- MySQL/MariaDBでは、NULL値は昇順（ASC）の場合は最小値として（最初に表示）、降順（DESC）の場合は最大値として（最後に表示）扱われます。

一部のデータベース（PostgreSQLなど）では、NULL値の位置を明示的に指定するための「NULLS FIRST」「NULLS LAST」構文がサポートされています。

### 例5：NULL値の扱い

例えば、出席（attendance）テーブルからコメント（comment）でソートすると、NULLが最初に来ます：

```sql
SELECT * FROM attendance ORDER BY comment;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | NULL          |
| 1           | 306        | present | NULL          |
| ...         | ...        | ...     | NULL          |
| 1           | 308        | late    | 5分遅刻       |
| 1           | 323        | late    | 電車遅延      |
| ...         | ...        | ...     | ...           |

## カラム番号を使った並び替え

カラム名の代わりに、SELECT文の結果セットにおけるカラムの位置（番号）を使って並び替えることもできます。最初のカラムは1、2番目のカラムは2、という具合です。

### 構文

```sql
SELECT カラム名1, カラム名2, ... FROM テーブル名 ORDER BY カラム位置;
```

### 例6：カラム番号を使った並び替え

例えば、学生（students）テーブルから学生ID（student_id）と名前（student_name）を取得し、名前（2番目のカラム）で並べ替えるには：

```sql
SELECT student_id, student_name FROM students ORDER BY 2;
```

この場合、「ORDER BY 2」は「ORDER BY student_name」と同じ意味になります。

> **注意**：カラム番号を使う方法は、カラムの順序を変更すると問題が起きるため、実際の業務では使用を避けた方が良いとされています。

## 式や関数を使った並び替え

ORDER BY句で式や関数を使うことにより、計算結果に基づいて並び替えることもできます。

### 例7：式を使った並び替え

例えば、成績（grades）テーブルから、得点の達成率（score/max_score）の高い順に並べるには：

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY (score/max_score) DESC;
```

または

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY 達成率 DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 98.0     |
| 320        | 1         | レポート1    | 48.5  | 50.0      | 97.0     |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 95.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

### 例8：関数を使った並び替え

文字列関数を使って並び替えることもできます。例えば、月名で並べることを考えましょう：

```sql
SELECT schedule_date, MONTH(schedule_date) AS month
FROM course_schedule
ORDER BY MONTH(schedule_date);
```

実行結果：

| schedule_date | month |
|---------------|-------|
| 2025-04-07    | 4     |
| 2025-04-08    | 4     |
| ...           | ...   |
| 2025-05-01    | 5     |
| 2025-05-02    | 5     |
| ...           | ...   |
| 2025-06-01    | 6     |
| ...           | ...   |

## CASE式を使った条件付き並び替え

さらに高度な並び替えとして、CASE式を使って条件に応じた並び順を定義することもできます。

### 例9：CASE式を使った並び替え

例えば、出席（attendance）テーブルから、出席状況（status）を「欠席→遅刻→出席」の順に優先して表示するには：

```sql
SELECT * FROM attendance
ORDER BY CASE 
           WHEN status = 'absent' THEN 1
           WHEN status = 'late' THEN 2
           WHEN status = 'present' THEN 3
           ELSE 4
         END;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |
| 1           | 302        | late   | 15分遅刻      |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |
| 1           | 301        | present| NULL          |
| 1           | 306        | present| NULL          |
| ...         | ...        | ...    | ...           |

## 練習問題

### 問題7-1
students（学生）テーブルから、すべての学生情報を学生名（student_name）の降順（逆五十音順）で取得するSQLを書いてください。

### 問題7-2
grades（成績）テーブルから、得点（score）が85点以上の成績を得点の高い順に取得するSQLを書いてください。

### 問題7-3
course_schedule（授業カレンダー）テーブルから、2025年5月の授業スケジュールを日付（schedule_date）の昇順で取得するSQLを書いてください。

### 問題7-4
teachers（教師）テーブルから、教師IDと名前を取得し、名前（teacher_name）の五十音順で並べるSQLを書いてください。

### 問題7-5
grades（成績）テーブルから、講座ID（course_id）ごとに、成績を評価タイプ（grade_type）の五十音順に、同じ評価タイプ内では得点（score）の高い順に並べて取得するSQLを書いてください。

### 問題7-6
attendance（出席）テーブルから、すべての出席情報を出席状況（status）が「absent」「late」「present」の順番で、同じ状態内ではコメント（comment）の有無（NULLが後）で並べて取得するSQLを書いてください。

## 解答

### 解答7-1
```sql
SELECT * FROM students ORDER BY student_name DESC;
```

### 解答7-2
```sql
SELECT * FROM grades WHERE score >= 85 ORDER BY score DESC;
```

### 解答7-3
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31' 
ORDER BY schedule_date;
```

### 解答7-4
```sql
SELECT teacher_id, teacher_name FROM teachers ORDER BY teacher_name;
```

### 解答7-5
```sql
SELECT * FROM grades 
ORDER BY course_id, grade_type, score DESC;
```

### 解答7-6
```sql
SELECT * FROM attendance
ORDER BY 
  CASE 
    WHEN status = 'absent' THEN 1
    WHEN status = 'late' THEN 2
    WHEN status = 'present' THEN 3
    ELSE 4
  END,
  CASE 
    WHEN comment IS NULL THEN 2
    ELSE 1
  END;
```

## まとめ

この章では、クエリ結果を特定の順序で並べるための「ORDER BY」句について学びました：

1. **基本的な並び替え**：指定したカラムの値に基づいて結果を並べる方法
2. **昇順と降順**：ASC（昇順）とDESC（降順）の指定方法
3. **複数カラムでの並び替え**：優先順位の高いカラムから順に指定する方法
4. **NULL値の扱い**：NULL値が並び替えでどのように扱われるか
5. **カラム番号**：カラム名の代わりに位置で指定する方法（あまり推奨されない）
6. **式や関数**：計算結果に基づいて並べる方法
7. **CASE式**：条件付きの複雑な並び替え

ORDER BY句は、データを見やすく整理するために非常に重要です。特に大量のデータを扱う場合、適切な並び順はデータの理解を大きく助けます。

次の章では、取得する結果の件数を制限する「LIMIT句：結果件数の制限とページネーション」について学びます。



---

# 8. LIMIT句：結果件数の制限とページネーション

## はじめに

これまでの章では、条件に合うデータを取得し、それを特定の順序で並べる方法を学びました。しかし実際のアプリケーションでは、大量のデータがあるときに、その一部だけを表示したいことがよくあります。例えば：

- 成績上位10件だけを表示したい
- Webページで一度に20件ずつ表示したい（ページネーション）
- 最新の5件のお知らせだけを取得したい

このような「結果の件数を制限する」ためのSQLコマンドが「LIMIT句」です。この章では、クエリ結果の件数を制限する方法と、ページネーションの実装方法を学びます。

## LIMIT句の基本

LIMIT句は、SELECT文の結果から指定した件数だけを取得するために使います。

> **用語解説**：
> - **LIMIT**：「制限する」という意味のSQLコマンドで、取得する行数を制限します。

### 基本構文（MySQL/MariaDB）

MySQLやMariaDBでのLIMIT句の基本構文は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数;
```

LIMIT句は通常、SELECT文の最後に記述します（ORDER BYの後）。

### 例1：単純なLIMIT

例えば、学生（students）テーブルから最初の5人だけを取得するには：

```sql
SELECT * FROM students LIMIT 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |

### ORDER BYとLIMITの組み合わせ

通常、LIMIT句はORDER BY句と組み合わせて使用します。これにより、「上位N件」「最新N件」などの操作が可能になります。

### 例2：ORDER BYとLIMITの組み合わせ

例えば、成績（grades）テーブルから得点（score）の高い順に上位3件を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 3;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |

### 例3：最新のレコードを取得

日付でソートして最新のデータを取得することもよくあります。例えば、最新の3つの授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
ORDER BY schedule_date DESC LIMIT 3;
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 95          | 28        | 2026-12-21    | 3         | 202D         | 119        | scheduled |
| 94          | 1         | 2026-12-21    | 1         | 102B         | 101        | scheduled |
| 93          | 14        | 2026-12-15    | 4         | 202D         | 110        | scheduled |

## OFFSETとページネーション

Webアプリケーションなどでは、大量のデータを「ページ」に分けて表示することがよくあります（ページネーション）。この機能を実現するためには、「OFFSET」（オフセット）という機能が必要です。

> **用語解説**：
> - **OFFSET**：「ずらす」という意味で、結果セットの先頭から指定した数だけ行をスキップします。
> - **ページネーション**：大量のデータを複数のページに分割して表示する技術です。

### 基本構文（MySQL/MariaDB）

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数 OFFSET スキップ数;
```

または、短縮形として：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT スキップ数, 件数;
```

### 例4：OFFSETを使ったスキップ

例えば、学生（students）テーブルから6番目から10番目までの学生を取得するには：

```sql
SELECT * FROM students LIMIT 5 OFFSET 5;
```

または：

```sql
SELECT * FROM students LIMIT 5, 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 306        | 河田咲奈     |
| 307        | 織田柚夏     |
| 308        | 永田悦子     |
| 309        | 相沢吉夫     |
| 310        | 吉川伽羅     |

### 例5：ページネーションの実装

ページネーションを実装する場合、通常は以下の式を使ってOFFSETを計算します：

```
OFFSET = (ページ番号 - 1) × ページあたりの件数
```

例えば、1ページあたり10件表示で、3ページ目のデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 10 OFFSET 20;
```

または：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 20, 10;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 322        | 木村結衣     |
| 323        | 林正義       |
| 324        | 清水香織     |
| 325        | 山田翔太     |
| 326        | 葉山陽太     |
| 327        | 青山凛       |
| 328        | 沢村大和     |
| 329        | 白石優月     |
| 330        | 月岡星奈     |

## LIMIT句を使用する際の注意点

### 1. ORDER BYの重要性

LIMIT句を使用する場合、通常はORDER BY句も一緒に使うべきです。ORDER BYがなければ、どのレコードが取得されるかは保証されません。

```sql
-- 良い例：結果が予測可能
SELECT * FROM students ORDER BY student_id LIMIT 5;

-- 悪い例：結果が不確定
SELECT * FROM students LIMIT 5;
```

### 2. パフォーマンスへの影響

大規模なテーブルで大きなOFFSET値を使用すると、パフォーマンスが低下する可能性があります。これは、データベースがOFFSET分のレコードを読み込んでから破棄する必要があるためです。

### 3. データベース製品による構文の違い

LIMIT句の構文はデータベース製品によって異なります：

- **MySQL/MariaDB/SQLite**：`LIMIT 件数 OFFSET スキップ数` または `LIMIT スキップ数, 件数`
- **PostgreSQL**：`LIMIT 件数 OFFSET スキップ数`
- **Oracle**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY`
- **SQL Server**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY` または旧バージョンでは `TOP`句

この章では主にMySQL/MariaDBの構文を使用します。

## 実践的なページネーションの実装

実際のアプリケーションでページネーションを実装する場合、以下のようなコードになります（疑似コード）：

```
ページ番号 = URLから取得またはデフォルト値（例：1）
1ページあたりの件数 = 設定値（例：10）
総レコード数 = SELECTで取得（COUNT(*)を使用）
総ページ数 = CEILING(総レコード数 ÷ 1ページあたりの件数)
OFFSET = (ページ番号 - 1) × 1ページあたりの件数

SQLクエリ = "SELECT * FROM テーブル ORDER BY カラム LIMIT " + 1ページあたりの件数 + " OFFSET " + OFFSET
```

### 例6：総レコード数と総ページ数の取得

総レコード数を取得するには：

```sql
SELECT COUNT(*) AS total_records FROM students;
```

実行結果：

| total_records |
|---------------|
| 100           |

この場合、1ページあたり10件表示なら、総ページ数は10ページ（CEILING(100 ÷ 10)）になります。

## 練習問題

### 問題8-1
grades（成績）テーブルから、得点（score）の高い順に上位5件の成績レコードを取得するSQLを書いてください。

### 問題8-2
course_schedule（授業カレンダー）テーブルから、日付（schedule_date）の新しい順に3件のスケジュールを取得するSQLを書いてください。

### 問題8-3
students（学生）テーブルを学生ID（student_id）の昇順で並べ、11番目から15番目までの学生（5件）を取得するSQLを書いてください。

### 問題8-4
teachers（教師）テーブルから、教師名（teacher_name）の五十音順で6番目から10番目までの教師情報を取得するSQLを書いてください。

### 問題8-5
1ページあたり20件表示で、grades（成績）テーブルの3ページ目のデータを得点（score）の高い順に取得するSQLを書いてください。

### 問題8-6
course_schedule（授業カレンダー）テーブルから、状態（status）が「scheduled」のスケジュールを日付（schedule_date）の昇順で並べ、先頭から10件スキップして次の5件を取得するSQLを書いてください。

## 解答

### 解答8-1
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 5;
```

### 解答8-2
```sql
SELECT * FROM course_schedule ORDER BY schedule_date DESC LIMIT 3;
```

### 解答8-3
```sql
SELECT * FROM students ORDER BY student_id LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM students ORDER BY student_id LIMIT 10, 5;
```

### 解答8-4
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5 OFFSET 5;
```
または
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5, 5;
```

### 解答8-5
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 20 OFFSET 40;
```
または
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 40, 20;
```

### 解答8-6
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 10, 5;
```

## まとめ

この章では、クエリ結果の件数を制限するためのLIMIT句と、ページネーションの実装方法について学びました：

1. **LIMIT句の基本**：指定した件数だけのレコードを取得する方法
2. **ORDER BYとの組み合わせ**：順序付けされた結果から一部だけを取得する方法
3. **OFFSET**：結果の先頭から指定した数だけレコードをスキップする方法
4. **ページネーション**：大量のデータを複数のページに分けて表示する実装方法
5. **注意点**：LIMIT句を使用する際の留意事項
6. **データベース製品による違い**：異なるデータベースでの構文の違い

LIMIT句は特にWebアプリケーションの開発で重要な機能です。大量のデータを効率よく表示するためのページネーション機能を実装するために欠かせません。また、トップN（上位N件）やボトムN（下位N件）のデータを取得する際にも使われます。

次の章では、データの集計分析を行うための「集計関数：COUNT、SUM、AVG、MAX、MIN」について学びます。





---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [13. JOIN基本：テーブル結合の概念](#13-join基本テーブル結合の概念)
2. [14. テーブル別名：AS句とその省略](#14-テーブル別名as句とその省略)
3. [15. 結合の種類：INNER JOIN、LEFT JOIN、RIGHT JOIN](#15-結合の種類inner-joinleft-joinright-join)
4. [16. 自己結合：同一テーブル内での関連付け](#16-自己結合同一テーブル内での関連付け)
5. [17. 複数テーブル結合：3つ以上のテーブルの連結](#17-複数テーブル結合3つ以上のテーブルの連結)
6. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)
7. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)

---


# 13. JOIN基本：テーブル結合の概念

## はじめに

これまでの章では、単一のテーブルからデータを取得する方法を学んできました。しかし実際のデータベースでは、情報は複数のテーブルに分散して保存されています。

例えば、学校データベースでは：
- 学生の基本情報は「students」テーブルに
- 講座の情報は「courses」テーブルに
- 成績データは「grades」テーブルに

このように別々のテーブルに保存されたデータを組み合わせて取得するための機能が「JOIN（結合）」です。この章では、複数のテーブルを結合して必要な情報を取得する基本的な方法を学びます。

## JOINとは

JOIN（結合）とは、2つ以上のテーブルを関連付けて、それらのテーブルから情報を組み合わせて取得するためのSQL機能です。

> **用語解説**：
> - **JOIN**：「結合する」という意味のSQLコマンドで、複数のテーブルを関連付けてデータを取得するために使います。
> - **結合キー**：テーブル間の関連付けに使用されるカラムのことで、通常は主キーと外部キーの関係にあります。

## テーブル結合の必要性

なぜテーブル結合が必要なのでしょうか？いくつかの理由があります：

1. **データの正規化**：データベース設計では、情報の重複を避けるためにデータを複数のテーブルに分割します（これを「正規化」と呼びます）。
2. **データの一貫性**：例えば、教師の名前を1か所（teachersテーブル）だけで管理することで、名前変更時の更新が容易になります。
3. **効率的なデータ管理**：関連するデータをグループ化して管理できます。

例えば、「どの学生がどの講座でどのような成績を取ったか」という情報を取得するには、students、courses、gradesの3つのテーブルを結合する必要があります。

## 基本的なJOINの種類

SQLでは主に4種類のJOINが使われます：

1. **JOIN**：両方のテーブルで一致するレコードだけを取得(INNER JOIN)
2. **LEFT JOIN**：左テーブルのすべてのレコードと、右テーブルの一致するレコード
3. **RIGHT JOIN**：右テーブルのすべてのレコードと、左テーブルの一致するレコード
4. **FULL JOIN**：両方のテーブルのすべてのレコード（MySQLでは直接サポートされていません）

この章では主にJOINについて学び、次章で他の種類のJOINを学びます。

## JOIN（内部結合）

JOINは、最も基本的な結合方法で、両方のテーブルで一致するレコードのみを取得します。

> **用語解説**：
> - **JOIN**：「内部結合」とも呼ばれ、結合条件に一致するレコードのみを返します。条件に一致しないレコードは結果に含まれません。

### 基本構文

```sql
SELECT カラム名
FROM テーブル1
JOIN テーブル2 ON テーブル1.結合カラム = テーブル2.結合カラム;
```

「ON」の後には結合条件を指定します。これは通常、一方のテーブルの主キーと他方のテーブルの外部キーを一致させる条件です。

> **用語解説**：
> - **ON**：「〜の条件で」という意味で、JOINの条件を指定するためのキーワードです。

## JOINの実践例

### 例1：講座とその担当教師の情報を取得

講座（courses）テーブルと教師（teachers）テーブルを結合して、各講座の名前と担当教師の名前を取得してみましょう：

```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id;
```

この例では：
- `c`と`t`はそれぞれcourses、teachersテーブルの「テーブル別名」（短縮名）です。
- `ON c.teacher_id = t.teacher_id`が結合条件です。
- 講座テーブルの`teacher_id`（外部キー）と教師テーブルの`teacher_id`（主キー）が一致するレコードが結合されます。

実行結果：

| course_id | course_name           | teacher_name |
|-----------|----------------------|--------------|
| 1         | ITのための基礎知識     | 寺内鞍       |
| 2         | UNIX入門             | 田尻朋美     |
| 3         | Cプログラミング演習    | 寺内鞍       |
| 4         | Webアプリケーション開発 | 藤本理恵     |
| ...       | ...                  | ...          |

### 例2：学生と受講講座の情報を取得

学生（students）テーブルと受講（student_courses）テーブルを結合して、特定の講座を受講している学生の一覧を取得してみましょう：

```sql
SELECT s.student_id, s.student_name, sc.course_id
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '1';
```

この例では、学生テーブルと受講テーブルを学生IDで結合し、講座ID = 1の学生だけを取得しています。

実行結果：

| student_id | student_name | course_id |
|------------|--------------|-----------|
| 301        | 黒沢春馬     | 1         |
| 302        | 新垣愛留     | 1         |
| 303        | 柴崎春花     | 1         |
| 306        | 河田咲奈     | 1         |
| ...        | ...          | ...       |

### 例3：3つのテーブルの結合

より複雑な例として、3つのテーブルを結合してみましょう。学生、講座、成績の情報を組み合わせて表示します：

```sql
SELECT s.student_name, c.course_name, g.score
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY g.score DESC;
```

この例では：
1. まず学生テーブルと成績テーブルを結合
2. その結果と講座テーブルを結合
3. 中間テストの成績だけを抽出
4. 点数の高い順にソート

実行結果：

| student_name | course_name           | score |
|--------------|----------------------|-------|
| 鈴木健太     | ITのための基礎知識     | 95.0  |
| 松本さくら   | ITのための基礎知識     | 93.5  |
| 新垣愛留     | ITのための基礎知識     | 92.0  |
| ...          | ...                  | ...    |

## JOIN時のカラム指定

テーブルを結合する際に、特に同じカラム名が両方のテーブルに存在する場合は、カラム名の前にテーブル名（または別名）を付けることで、どのテーブルのカラムを参照しているかを明確にする必要があります。

例えば：
```sql
SELECT students.student_id, students.student_name
FROM students;
```

これは次のように短縮できます：
```sql
SELECT s.student_id, s.student_name
FROM students s;
```

ここで`s`は`students`テーブルの別名です。

## テーブルの別名（エイリアス）

長いテーブル名は別名を使って短くすることができます。これにより、SQLが読みやすくなります。

> **用語解説**：
> - **テーブル別名（エイリアス）**：テーブルに一時的につける短い名前で、クエリ内でテーブルを参照するときに使用します。

構文：
```sql
SELECT t.カラム名
FROM テーブル名 AS t;
```

「AS」キーワードは省略可能です：
```sql
SELECT t.カラム名
FROM テーブル名 t;
```

### 例4：別名を使った結合

```sql
SELECT s.student_name, c.course_name, t.teacher_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE s.student_id = 301;
```

この例では4つのテーブルを結合して、学生ID=301の学生が受講しているすべての講座とその担当教師の情報を取得しています。

実行結果：

| student_name | course_name           | teacher_name |
|--------------|----------------------|--------------|
| 黒沢春馬     | ITのための基礎知識     | 寺内鞍       |
| 黒沢春馬     | UNIX入門             | 田尻朋美     |
| 黒沢春馬     | クラウドコンピューティング | 吉岡由佳  |
| ...          | ...                  | ...          |

## 結合条件の書き方

結合条件には複数の方法があります：

### 1. 等価結合（Equi-Join）

最も一般的な結合方法で、カラムの値が等しいことを条件に使います：
```sql
... ON テーブル1.カラム = テーブル2.カラム
```

### 2. 非等価結合（Non-Equi Join）

「等しい」以外の条件（<, >, <=, >=など）を使う結合方法です：
```sql
... ON テーブル1.カラム > テーブル2.カラム
```

### 3. 複合条件結合

複数の条件を組み合わせる結合方法です：
```sql
... ON テーブル1.カラム1 = テーブル2.カラム1
    AND テーブル1.カラム2 = テーブル2.カラム2
```

## JOINの特徴と注意点

JOINを使用する際には、以下の点に注意が必要です：

1. **一致しないレコードは含まれない**：結合条件に一致しないレコードは結果に含まれません。
2. **NULL値の扱い**：JOIN条件で使用するカラムにNULL値があると、その行は結果に含まれません。
3. **パフォーマンス**：大きなテーブル同士を結合すると、処理に時間がかかることがあります。

## 練習問題

### 問題13-1
courses（講座）テーブルとteachers（教師）テーブルを結合して、講座ID（course_id）、講座名（course_name）、担当教師名（teacher_name）を取得するSQLを書いてください。

### 問題13-2
students（学生）テーブルとstudent_courses（受講）テーブルを結合して、講座ID（course_id）が2の講座を受講している学生の学生ID（student_id）と学生名（student_name）を取得するSQLを書いてください。

### 問題13-3
course_schedule（授業カレンダー）テーブルとclassrooms（教室）テーブルを結合して、2025年5月20日に行われる授業のスケジュールIDと教室名（classroom_name）を取得するSQLを書いてください。

### 問題13-4
courses（講座）テーブル、teachers（教師）テーブル、course_schedule（授業カレンダー）テーブルの3つを結合して、2025年5月22日に行われる授業の講座名（course_name）と担当教師名（teacher_name）を取得するSQLを書いてください。

### 問題13-5
students（学生）テーブル、grades（成績）テーブル、courses（講座）テーブルを結合して、学生ID（student_id）が301の学生の成績情報（講座名、成績タイプ、点数）を取得するSQLを書いてください。

### 問題13-6
courses（講座）テーブル、course_schedule（授業カレンダー）テーブル、classrooms（教室）テーブル、class_periods（授業時間）テーブルの4つを結合して、2025年5月21日の授業スケジュール（講座名、教室名、開始時間、終了時間）を時間順に取得するSQLを書いてください。

## 解答

### 解答13-1
```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id;
```

### 解答13-2
```sql
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '2';
```

### 解答13-3
```sql
SELECT cs.schedule_id, cl.classroom_name
FROM course_schedule cs
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
WHERE cs.schedule_date = '2025-05-20';
```

### 解答13-4
```sql
SELECT c.course_name, t.teacher_name
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
WHERE cs.schedule_date = '2025-05-22';
```

### 解答13-5
```sql
SELECT c.course_name, g.grade_type, g.score
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE s.student_id = 301;
```

### 解答13-6
```sql
SELECT c.course_name, cl.classroom_name, cp.start_time, cp.end_time
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
WHERE cs.schedule_date = '2025-05-21'
ORDER BY cp.start_time;
```

## まとめ

この章では、複数のテーブルを結合して情報を取得するための基本的なJOIN操作について学びました：

1. **JOIN（結合）の概念**：複数のテーブルの情報を組み合わせる方法
2. **JOIN（内部結合）**：両方のテーブルで一致するレコードのみを取得
3. **結合条件**：ON句を使って結合条件を指定する方法
4. **テーブル別名**：テーブルに短い名前を付けて使う方法
5. **複数テーブルの結合**：3つ以上のテーブルを結合する方法
6. **結合条件の書き方**：等価結合、非等価結合、複合条件結合

JOINは実際のデータベース操作で非常に重要な機能です。データベースの性能を維持するために、関連情報は複数のテーブルに分散して保存されることが一般的で、必要な情報を取得するためにはこれらのテーブルを結合する必要があります。

次の章では、「テーブル別名：AS句とその省略」について詳しく学び、より効率的なJOINクエリの書き方を学びます。



---

# 14. テーブル別名：AS句とその省略

## はじめに

前章では複数のテーブルを結合する基本的な方法について学びました。テーブル結合を含むSQLクエリは、複数のテーブル名を扱うため長く複雑になりがちです。また、同じテーブル名やカラム名を繰り返し記述することも多くなります。

SQLでは、このような繰り返しを避け、クエリを簡潔に書くために「テーブル別名（エイリアス）」という機能が用意されています。この章では、テーブルやカラムに一時的な名前（別名）を付ける方法と、それを効果的に使用する方法について学びます。

## テーブル別名とは

テーブル別名（エイリアス）とは、SQLクエリの中で使用する仮の短い名前のことです。特に複数のテーブルを結合する場合や同じテーブルを複数回参照する場合に便利です。

> **用語解説**：
> - **テーブル別名（エイリアス）**：テーブルに一時的につける短い別名です。クエリ内でテーブルを参照するときに使用します。
> - **AS句**：「〜として」という意味のSQLキーワードで、テーブルやカラムに別名を付けるために使います。

## AS句を使ったテーブル別名の指定

テーブル別名を指定するには、FROMやJOIN句の中でテーブル名の後にASキーワードとともに別名を書きます。

### 基本構文

```sql
SELECT 列リスト
FROM テーブル名 AS 別名
[JOIN 別のテーブル AS 別名 ON 結合条件];
```

### 例1：AS句を使ったテーブル別名の指定

例えば、コースとその担当教師を取得するクエリでASを使用して別名を付けます：

```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses AS c
JOIN teachers AS t ON c.teacher_id = t.teacher_id;
```

この例では：
- `courses`テーブルに`c`という別名
- `teachers`テーブルに`t`という別名
を付けています。

## AS句の省略

SQLではAS句を省略することができます。これにより、クエリをさらに簡潔に書くことができます。

### 基本構文（AS省略）

```sql
SELECT 列リスト
FROM テーブル名 別名
[JOIN 別のテーブル 別名 ON 結合条件];
```

### 例2：AS句を省略したテーブル別名の指定

先ほどの例からASを省略してみましょう：

```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id;
```

この書き方は前の例と全く同じ結果を返します。ASを省略してもテーブル名の直後に別名を書くことで同じ効果が得られます。

実行結果：

| course_id | course_name           | teacher_name |
|-----------|----------------------|--------------|
| 1         | ITのための基礎知識     | 寺内鞍       |
| 2         | UNIX入門             | 田尻朋美     |
| 3         | Cプログラミング演習    | 寺内鞍       |
| ...       | ...                  | ...          |

## テーブル別名を使う利点

テーブル別名を使用することには、いくつかの利点があります：

1. **クエリの短縮**：長いテーブル名を短い別名で参照できるため、SQLの記述量が減ります。

2. **可読性の向上**：特に複数のテーブルを結合する複雑なクエリでは、どのテーブルのカラムを参照しているかが明確になります。

3. **同一テーブルの複数回使用**：後述する「自己結合」のように、同じテーブルを複数回使う場合に区別するために必須です。

4. **タイピングの労力削減**：繰り返し長いテーブル名を入力する必要がなくなります。

### 例3：複数テーブル結合での別名の活用

4つのテーブルを結合する複雑なクエリでテーブル別名を活用してみましょう：

```sql
SELECT s.student_name, c.course_name, cs.schedule_date, cl.classroom_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN course_schedule cs ON c.course_id = cs.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
WHERE s.student_id = 301 AND cs.schedule_date >= '2025-05-01';
```

このクエリでは以下の別名を使用しています：
- `students`テーブル → `s`
- `student_courses`テーブル → `sc`
- `courses`テーブル → `c`
- `course_schedule`テーブル → `cs`
- `classrooms`テーブル → `cl`

もし別名を使わないと、以下のような長く読みにくいクエリになります：

```sql
SELECT students.student_name, courses.course_name, course_schedule.schedule_date, classrooms.classroom_name
FROM students
JOIN student_courses ON students.student_id = student_courses.student_id
JOIN courses ON student_courses.course_id = courses.course_id
JOIN course_schedule ON courses.course_id = course_schedule.course_id
JOIN classrooms ON course_schedule.classroom_id = classrooms.classroom_id
WHERE students.student_id = 301 AND course_schedule.schedule_date >= '2025-05-01';
```

## カラム別名の指定

テーブルだけでなく、カラム（列）にも別名を付けることができます。カラム別名を使うと、結果セットの列見出しをわかりやすい名前に変更できます。

### 基本構文

```sql
SELECT 
    カラム名 AS 別名,
    計算式 AS 別名
FROM テーブル名;
```

### 例4：カラム別名の指定

```sql
SELECT 
    student_id AS 学生番号,
    student_name AS 氏名,
    CONCAT(student_id, ': ', student_name) AS 学生情報
FROM students
WHERE student_id < 305;
```

実行結果：

| 学生番号 | 氏名        | 学生情報          |
|---------|------------|------------------|
| 301     | 黒沢春馬    | 301: 黒沢春馬    |
| 302     | 新垣愛留    | 302: 新垣愛留    |
| 303     | 柴崎春花    | 303: 柴崎春花    |
| 304     | 森下風凛    | 304: 森下風凛    |

### カラム別名でもASは省略可能

カラム別名の場合もAS句は省略可能です：

```sql
SELECT 
    student_id 学生番号,
    student_name 氏名,
    CONCAT(student_id, ': ', student_name) 学生情報
FROM students
WHERE student_id < 305;
```

## スペースを含む別名

テーブル名やカラム名に含まれるスペースは通常問題になりますが、別名にスペースを含めたい場合は二重引用符（"）または（データベースによっては）バッククォート（`）で囲むことで指定できます。

### 例5：スペースを含む別名

```sql
SELECT 
    student_id AS "学生 ID",
    student_name AS "学生 氏名"
FROM students
WHERE student_id < 305;
```

実行結果：

| 学生 ID | 学生 氏名   |
|---------|------------|
| 301     | 黒沢春馬    |
| 302     | 新垣愛留    |
| 303     | 柴崎春花    |
| 304     | 森下風凛    |

## OrderByとテーブル別名

一般的に、ORDER BY句ではSELECT句で指定したカラム別名を使用できます：

### 例6：ORDER BY句での別名の使用

```sql
SELECT 
    student_id AS 学生番号,
    student_name AS 氏名
FROM students
WHERE student_id < 310
ORDER BY 氏名;
```

実行結果（氏名の五十音順）：

| 学生番号 | 氏名        |
|---------|------------|
| 309     | 相沢吉夫    |
| 305     | 河口菜恵子  |
| 306     | 河田咲奈    |
| 301     | 黒沢春馬    |
| 304     | 森下風凛    |
| 302     | 新垣愛留    |
| 303     | 柴崎春花    |
| 307     | 織田柚夏    |
| 308     | 永田悦子    |

## 別名の命名規則とベストプラクティス

テーブル別名やカラム別名を付ける際の一般的なルールとベストプラクティスを紹介します：

1. **テーブル別名は短く**：通常、1〜3文字程度の短い名前が好まれます（例：students → s）。

2. **意味のある別名**：テーブルの内容を表す頭文字や略語を使うと良いでしょう（例：teachers → t、course_schedule → cs）。

3. **一貫性**：プロジェクト内で同じテーブルには同じ別名を使うと可読性が向上します。

4. **カラム別名は説明的に**：カラム別名は、その内容がわかりやすい名前にします。特に計算列や関数の結果には説明的な名前を付けましょう。

5. **日本語の別名**：日本語環境では、カラム別名に日本語を使うとレポートが読みやすくなることがあります。

### 例7：ベストプラクティスに基づく別名

```sql
SELECT 
    c.course_name AS 講座名,
    t.teacher_name AS 担当教員,
    COUNT(sc.student_id) AS 受講者数
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name, t.teacher_name
ORDER BY 受講者数 DESC, 講座名;
```

実行結果：

| 講座名                 | 担当教員   | 受講者数 |
|----------------------|------------|---------|
| ITのための基礎知識       | 寺内鞍     | 12      |
| データサイエンスとビジネス応用 | 星野涼子   | 11      |
| クラウドネイティブアーキテクチャ | 吉岡由佳 | 10      |
| ...                  | ...        | ...     |

## テーブル別名を使用したJOINの応用

ここまで学んだテーブル別名の知識を使って、より実践的なJOINクエリを見てみましょう。

### 例8：出席状況と成績情報の結合

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    a.status AS 出席状況,
    g.score AS 得点,
    g.score / g.max_score * 100 AS 達成率
FROM students s
JOIN attendance a ON s.student_id = a.student_id
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN grades g ON s.student_id = g.student_id AND cs.course_id = g.course_id
WHERE cs.schedule_date = '2025-05-20'
ORDER BY c.course_name, s.student_name;
```

このクエリでは：
- 5つのテーブルを結合
- すべてのテーブルに別名を使用
- 結果のカラムにもわかりやすい別名を付与
- 成績は存在しない可能性があるためLEFT JOINを使用

## 練習問題

### 問題14-1
courses（講座）テーブルとteachers（教師）テーブルを結合して、講座名（course_name）と担当教師名（teacher_name）を「講座」と「担当者」という別名をつけて取得するSQLを書いてください。テーブル別名も使用してください。

### 問題14-2
students（学生）テーブルとgrades（成績）テーブルを結合して、学生名、成績タイプ、点数を「学生」「評価種別」「点数」という別名をつけて取得するSQLを書いてください。点数が90点以上のレコードだけを抽出し、点数の高い順にソートしてください。

### 問題14-3
course_schedule（授業カレンダー）テーブル、courses（講座）テーブル、classrooms（教室）テーブルを結合して、2025年5月21日の授業予定を「時間割」という形で取得するSQLを書いてください。結果には「講座名」「教室」「状態」という別名を付け、テーブル別名も使用してください。

### 問題14-4
学生の出席状況を確認するため、students（学生）テーブル、attendance（出席）テーブル、course_schedule（授業カレンダー）テーブルを結合して、学生ID=301の出席記録を取得するSQLを書いてください。結果には「日付」「状態」「コメント」という別名をつけ、日付順にソートしてください。

### 問題14-5
成績の集計情報を取得するため、students（学生）テーブル、grades（成績）テーブル、courses（講座）テーブルを結合し、学生ごとの平均点を計算するSQLを書いてください。結果には「学生名」「受講講座数」「平均点」という別名をつけ、平均点が高い順にソートしてください。

### 問題14-6
course_schedule（授業カレンダー）テーブル、teachers（教師）テーブル、teacher_unavailability（講師スケジュール管理）テーブルを結合して、講師が不在の日に予定されていた授業（status = 'cancelled'）を取得するSQLを書いてください。結果には「日付」「講師名」「不在理由」という別名をつけ、日付順にソートしてください。

## 解答

### 解答14-1
```sql
SELECT 
    c.course_name AS 講座,
    t.teacher_name AS 担当者
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id;
```

### 解答14-2
```sql
SELECT 
    s.student_name AS 学生,
    g.grade_type AS 評価種別,
    g.score AS 点数
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.score >= 90
ORDER BY 点数 DESC;
```

### 解答14-3
```sql
SELECT 
    c.course_name AS 講座名,
    cl.classroom_name AS 教室,
    cs.status AS 状態
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
WHERE cs.schedule_date = '2025-05-21'
ORDER BY cs.period_id;
```

### 解答14-4
```sql
SELECT 
    cs.schedule_date AS 日付,
    a.status AS 状態,
    a.comment AS コメント
FROM students s
JOIN attendance a ON s.student_id = a.student_id
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE s.student_id = 301
ORDER BY 日付;
```

### 解答14-5
```sql
SELECT 
    s.student_name AS 学生名,
    COUNT(DISTINCT g.course_id) AS 受講講座数,
    AVG(g.score) AS 平均点
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
GROUP BY s.student_id, s.student_name
ORDER BY 平均点 DESC;
```

### 解答14-6
```sql
SELECT 
    cs.schedule_date AS 日付,
    t.teacher_name AS 講師名,
    tu.reason AS 不在理由
FROM course_schedule cs
JOIN teachers t ON cs.teacher_id = t.teacher_id
JOIN teacher_unavailability tu ON t.teacher_id = tu.teacher_id
WHERE cs.status = 'cancelled'
  AND cs.schedule_date BETWEEN tu.start_date AND tu.end_date
ORDER BY 日付;
```

## まとめ

この章では、SQLクエリを簡潔で読みやすくするためのテーブル別名とカラム別名について学びました：

1. **テーブル別名の基本**：AS句を使ってテーブルに短い別名を付ける方法
2. **AS句の省略**：テーブル別名を指定する際にASキーワードを省略する書き方
3. **テーブル別名の利点**：クエリの短縮、可読性の向上、同一テーブルの複数回使用
4. **カラム別名**：SELECT句の結果セットの列に別名を付ける方法
5. **スペースを含む別名**：引用符を使って空白を含む別名を指定する方法
6. **ORDER BYでの別名使用**：ソート条件にカラム別名を使用する方法
7. **命名規則とベストプラクティス**：効果的な別名の付け方

テーブル別名とカラム別名はSQLの読みやすさと保守性を大きく向上させる重要な機能です。特に複数のテーブルを結合する複雑なクエリでは、適切な別名を使うことでコードの量が減り、理解しやすくなります。

次の章では、「結合の種類：JOIN、LEFT JOIN、RIGHT JOIN」について学び、さまざまな結合方法とその使い分けについて理解を深めていきます。



---

# 15. 結合の種類：INNER JOIN、LEFT JOIN、RIGHT JOIN

## はじめに

これまでの章で、テーブルを結合する基本的な方法であるINNER JOINと、クエリを簡潔にするためのテーブル別名について学びました。しかし実際のデータベース操作では、テーブル間の関係はさまざまであり、結合方法もそれに合わせて選ぶ必要があります。

例えば：
- 「すべての学生と、存在すれば成績情報も取得したい」
- 「課題を提出していない学生も含めて一覧を取得したい」
- 「担当講座のない教師も含めて教師一覧を表示したい」

このような要件に対応するためには、さまざまな種類の結合方法を理解する必要があります。この章では、主要な結合の種類（INNER JOIN、LEFT JOIN、RIGHT JOIN）とその使い分けについて学びます。

## 結合の種類とは

SQLでは、テーブルの結合方法として主に以下の種類があります：

1. **INNER JOIN（内部結合）**：両方のテーブルで一致するレコードのみを返します。
2. **LEFT JOIN（左外部結合）**：左テーブルのすべてのレコードと、右テーブルの一致するレコードを返します。
3. **RIGHT JOIN（右外部結合）**：右テーブルのすべてのレコードと、左テーブルの一致するレコードを返します。
4. **FULL JOIN（完全外部結合）**：両方のテーブルのすべてのレコードを返します（MySQLでは直接サポートされていません）。

> **用語解説**：
> - **内部結合**：両方のテーブルで条件に一致するレコードだけを返す結合方法。
> - **外部結合**：一方のテーブルのレコードがもう一方のテーブルに一致するレコードがなくても結果に含める結合方法。
> - **左テーブル**：FROM句で最初に指定されるテーブル。
> - **右テーブル**：JOIN句で指定されるテーブル。

## INNER JOIN（内部結合）の復習

INNER JOINは最も基本的な結合タイプで、13章で学んだ通り、両方のテーブルで結合条件に一致するレコードのみを返します。

### 基本構文

```sql
SELECT カラム名
FROM テーブル1
INNER JOIN テーブル2 ON 結合条件;
```

### 例1：INNER JOINの基本

学生と彼らが提出した成績情報を結合してみましょう：

```sql
SELECT s.student_id, s.student_name, g.course_id, g.score
FROM students s
INNER JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = '中間テスト'
ORDER BY s.student_id
LIMIT 5;
```

実行結果：

| student_id | student_name | course_id | score |
|------------|--------------|-----------|-------|
| 301        | 黒沢春馬     | 1         | 85.5  |
| 302        | 新垣愛留     | 1         | 92.0  |
| 303        | 柴崎春花     | 1         | 78.5  |
| 306        | 河田咲奈     | 1         | 88.0  |
| 307        | 織田柚夏     | 1         | 76.5  |

この結果には、成績テーブルに中間テストの記録がある学生だけが含まれています。成績記録のない学生は結果に含まれません。

## LEFT JOIN（左外部結合）

LEFT JOINは、左側のテーブル（FROM句のテーブル）のすべてのレコードを返し、右側のテーブル（JOIN句のテーブル）からは一致するレコードだけを返します。右側のテーブルに一致するレコードがない場合、そのカラムはNULLで埋められます。

> **用語解説**：
> - **LEFT JOIN**：左テーブルのすべてのレコードと、右テーブルの一致するレコードを返す結合方法です。
> - **NULL埋め**：一致するレコードがない場合、結果セット内の該当カラムはNULL値で埋められます。

### 基本構文

```sql
SELECT カラム名
FROM テーブル1
LEFT JOIN テーブル2 ON 結合条件;
```

### 例2：LEFT JOINの基本

すべての学生と、存在すれば彼らの成績情報を取得してみましょう：

```sql
SELECT s.student_id, s.student_name, g.course_id, g.score
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id AND g.grade_type = '中間テスト'
ORDER BY s.student_id
LIMIT 10;
```

実行結果：

| student_id | student_name | course_id | score |
|------------|--------------|-----------|-------|
| 301        | 黒沢春馬     | 1         | 85.5  |
| 302        | 新垣愛留     | 1         | 92.0  |
| 303        | 柴崎春花     | 1         | 78.5  |
| 304        | 森下風凛     | NULL      | NULL  |
| 305        | 河口菜恵子   | NULL      | NULL  |
| 306        | 河田咲奈     | 1         | 88.0  |
| 307        | 織田柚夏     | 1         | 76.5  |
| 308        | 永田悦子     | 1         | 91.0  |
| 309        | 相沢吉夫     | NULL      | NULL  |
| 310        | 吉川伽羅     | 1         | 82.5  |

この結果には、すべての学生が含まれています。成績記録がない学生（student_id = 304, 305, 309）の場合、course_idとscoreはNULLになっています。

### 例3：未提出者を見つける

LEFT JOINを使って、特定の課題を提出していない学生を見つけることができます：

```sql
SELECT s.student_id, s.student_name
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id AND g.grade_type = 'レポート1'
WHERE g.student_id IS NULL AND s.student_id < 320
ORDER BY s.student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |
| 309        | 相沢吉夫     |
| 313        | 佐藤大輔     |
| 314        | 中村彩香     |
| 316        | 渡辺美咲     |
| 319        | 加藤悠真     |

このクエリは、grades テーブルにレポート1の記録がない学生を探しています。WHEREで「g.student_id IS NULL」を指定することで、結合後にNULLになったレコード（＝提出していない学生）だけを抽出しています。

## RIGHT JOIN（右外部結合）

RIGHT JOINは、LEFT JOINの逆で、右側のテーブル（JOIN句のテーブル）のすべてのレコードを返し、左側のテーブル（FROM句のテーブル）からは一致するレコードだけを返します。

> **用語解説**：
> - **RIGHT JOIN**：右テーブルのすべてのレコードと、左テーブルの一致するレコードを返す結合方法です。

### 基本構文

```sql
SELECT カラム名
FROM テーブル1
RIGHT JOIN テーブル2 ON 結合条件;
```

### 例4：RIGHT JOINの基本

講座テーブルを基準に、その講座を受講している学生を取得してみましょう：

```sql
SELECT c.course_id, c.course_name, sc.student_id
FROM student_courses sc
RIGHT JOIN courses c ON sc.course_id = c.course_id AND sc.student_id = 301
ORDER BY c.course_id
LIMIT 10;
```

実行結果：

| course_id | course_name           | student_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 301        |
| 2         | UNIX入門             | 301        |
| 3         | Cプログラミング演習    | NULL       |
| 4         | Webアプリケーション開発 | NULL       |
| 5         | データベース設計と実装  | NULL       |
| 6         | ネットワークセキュリティ | NULL       |
| 7         | AI・機械学習入門      | NULL       |
| 8         | モバイルアプリ開発     | NULL       |
| 9         | クラウドコンピューティング | 301    |
| 10        | プロジェクト管理手法    | NULL       |

このクエリの結果には、すべての講座が含まれています。学生ID=301（黒沢春馬）が受講している講座（course_id = 1, 2, 9）では、student_idが表示され、それ以外の講座ではNULLになっています。

## LEFT JOINとRIGHT JOINの変換

LEFT JOINとRIGHT JOINは、テーブルの順序を入れ替えることで相互に変換できます。一般的には、LEFT JOINの方が直感的に理解しやすいため、多くの場合はLEFT JOINが好まれます。

次の2つのクエリは同等です：

```sql
-- LEFT JOINを使用
SELECT *
FROM テーブル1
LEFT JOIN テーブル2 ON 結合条件;

-- RIGHT JOINを使用（テーブルの順序を入れ替え）
SELECT *
FROM テーブル2
RIGHT JOIN テーブル1 ON 結合条件;
```

## 複数テーブルでの外部結合

外部結合は複数のテーブルを結合する場合にも使用できます。

### 例5：3つのテーブルを使った外部結合

学生、受講テーブル、講座テーブルを結合して、すべての学生と彼らが受講している講座（あれば）を取得してみましょう：

```sql
SELECT s.student_id, s.student_name, c.course_id, c.course_name
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN courses c ON sc.course_id = c.course_id
WHERE s.student_id BETWEEN 301 AND 305
ORDER BY s.student_id, c.course_id;
```

実行結果：

| student_id | student_name | course_id | course_name             |
|------------|--------------|-----------|------------------------|
| 301        | 黒沢春馬     | 1         | ITのための基礎知識       |
| 301        | 黒沢春馬     | 2         | UNIX入門               |
| 301        | 黒沢春馬     | 9         | クラウドコンピューティング |
| 301        | 黒沢春馬     | 16        | クラウドネイティブアーキテクチャ |
| ...        | ...          | ...       | ...                    |
| 302        | 新垣愛留     | 1         | ITのための基礎知識       |
| 302        | 新垣愛留     | 7         | AI・機械学習入門        |
| 302        | 新垣愛留     | 10        | プロジェクト管理手法      |
| ...        | ...          | ...       | ...                    |
| 303        | 柴崎春花     | 1         | ITのための基礎知識       |
| 303        | 柴崎春花     | 4         | Webアプリケーション開発   |
| 303        | 柴崎春花     | 10        | プロジェクト管理手法      |
| ...        | ...          | ...       | ...                    |
| 304        | 森下風凛     | 5         | データベース設計と実装    |
| 304        | 森下風凛     | 8         | モバイルアプリ開発       |
| 304        | 森下風凛     | 12        | サイバーセキュリティ対策  |
| ...        | ...          | ...       | ...                    |
| 305        | 河口菜恵子   | 4         | Webアプリケーション開発   |
| 305        | 河口菜恵子   | 7         | AI・機械学習入門        |
| 305        | 河口菜恵子   | 11        | データ分析と可視化       |
| ...        | ...          | ...       | ...                    |

このクエリでは2つのLEFT JOINを使用しています。最初のLEFT JOINは学生と受講テーブル、2つ目のLEFT JOINは受講テーブルと講座テーブルを結合しています。

## INNER JOINとLEFT JOINの使い分け

INNER JOINとLEFT JOIN（外部結合）は、用途に応じて使い分ける必要があります。以下のような基準で選択すると良いでしょう：

### INNER JOINを使う場合
- 両方のテーブルに対応するレコードが存在する場合のみデータを取得したい
- 関連付けられていないデータは不要な場合
- データの存在を確認したい場合

### LEFT JOIN（外部結合）を使う場合
- 主テーブルのすべてのレコードを表示したい
- 関連データがあるかどうかにかかわらず、主テーブルの情報は必要な場合
- 欠損データ（未提出、未登録など）を見つけたい場合
- レポート作成時に集計漏れを防ぎたい場合

## NULL値の処理に注意

外部結合を使用する場合、NULL値の処理に注意が必要です。特にWHERE句でフィルタリングする場合、通常の比較演算子（=, <, >など）はNULL値に対して常にFALSEを返します。

NULL値を検出するには「IS NULL」演算子を使用し、NULL値を除外するには「IS NOT NULL」演算子を使用します。

### 例6：NULL値の処理

```sql
-- 受講している講座がない学生を検索（NULLを検出）
SELECT s.student_id, s.student_name
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id IS NULL;

-- 少なくとも1つの講座を受講している学生を検索（NULLを除外）
SELECT DISTINCT s.student_id, s.student_name
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id IS NOT NULL;
```

## ON句とWHERE句の違い

LEFT JOINやRIGHT JOINを使用する場合、条件をON句に書くかWHERE句に書くかで結果が大きく変わることがあります。

- **ON句の条件**：結合操作の一部として適用され、外部結合の場合もNULL行を保持します。
- **WHERE句の条件**：結合後のすべての行に適用され、条件を満たさない行は結果から除外されます。

### 例7：ON句とWHERE句の違い

```sql
-- ON句に条件を書いた場合（外部結合の特性が保たれる）
SELECT s.student_id, s.student_name, g.score
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id AND g.grade_type = '中間テスト'
ORDER BY s.student_id
LIMIT 5;

-- WHERE句に条件を書いた場合（内部結合と同等になる）
SELECT s.student_id, s.student_name, g.score
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = '中間テスト'
ORDER BY s.student_id
LIMIT 5;
```

最初のクエリでは、すべての学生が結果に含まれ、中間テストのスコアがある場合はその値が表示され、ない場合はNULLになります。

2つ目のクエリでは、WHERE句でg.grade_type = '中間テスト'という条件を指定しているため、中間テストのスコアがない学生は結果から除外されます（実質的にINNER JOINと同等になります）。

## 練習問題

### 問題15-1
courses（講座）テーブルとteachers（教師）テーブルを使い、すべての講座とその担当教師（いれば）の情報を取得するSQLを書いてください。LEFT JOINを使用してください。

### 問題15-2
students（学生）テーブルとgrades（成績）テーブルを使い、講座ID（course_id）= 1の中間テストを受けていない学生を特定するSQLを書いてください。

### 問題15-3
teachers（教師）テーブルとcourses（講座）テーブルを使い、担当講座がない教師を特定するSQLを書いてください。

### 問題15-4
course_schedule（授業カレンダー）テーブルとattendance（出席）テーブルを使い、2025年5月20日の各授業に対する出席学生数と欠席学生数を集計するSQLを書いてください。

### 問題15-5
students（学生）テーブル、student_courses（受講）テーブル、courses（講座）テーブルを使い、各学生が受講している講座の数を取得するSQLを書いてください。受講していない学生も0として表示してください。

### 問題15-6
course_schedule（授業カレンダー）テーブル、teachers（教師）テーブル、teacher_unavailability（講師スケジュール管理）テーブルを使い、今後の授業予定（schedule_date >= '2025-05-20'）について、担当教師が不在期間と重なっているかどうかをチェックするSQLを書いてください。不在期間と重なっている場合は「要注意」、そうでない場合は「OK」と表示してください。

## 解答

### 解答15-1
```sql
SELECT c.course_id, c.course_name, t.teacher_id, t.teacher_name
FROM courses c
LEFT JOIN teachers t ON c.teacher_id = t.teacher_id
ORDER BY c.course_id;
```

### 解答15-2
```sql
SELECT s.student_id, s.student_name
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id 
                   AND g.course_id = '1' 
                   AND g.grade_type = '中間テスト'
WHERE g.student_id IS NULL
ORDER BY s.student_id;
```

### 解答15-3
```sql
SELECT t.teacher_id, t.teacher_name
FROM teachers t
LEFT JOIN courses c ON t.teacher_id = c.teacher_id
WHERE c.teacher_id IS NULL;
```

### 解答15-4
```sql
SELECT 
    cs.schedule_id,
    c.course_name,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS 出席数,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS 欠席数,
    SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS 遅刻数,
    COUNT(a.student_id) AS 総数
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
LEFT JOIN courses c ON cs.course_id = c.course_id
WHERE cs.schedule_date = '2025-05-20'
GROUP BY cs.schedule_id, c.course_name
ORDER BY cs.schedule_id;
```

### 解答15-5
```sql
SELECT 
    s.student_id,
    s.student_name,
    COUNT(sc.course_id) AS 受講講座数
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
GROUP BY s.student_id, s.student_name
ORDER BY s.student_id;
```

### 解答15-6
```sql
SELECT 
    cs.schedule_id,
    cs.schedule_date,
    t.teacher_name,
    c.course_name,
    CASE 
        WHEN tu.teacher_id IS NOT NULL THEN '要注意 - ' || tu.reason
        ELSE 'OK'
    END AS 状態
FROM course_schedule cs
INNER JOIN teachers t ON cs.teacher_id = t.teacher_id
INNER JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN teacher_unavailability tu ON cs.teacher_id = tu.teacher_id
                                    AND cs.schedule_date BETWEEN tu.start_date AND tu.end_date
WHERE cs.schedule_date >= '2025-05-20'
ORDER BY cs.schedule_date, cs.period_id;
```

## まとめ

この章では、データベースのさまざまな結合方法について学びました：

1. **INNER JOIN（内部結合）**：両方のテーブルで条件に一致するレコードのみを返す
2. **LEFT JOIN（左外部結合）**：左テーブルのすべてのレコードと、右テーブルの一致するレコードを返す
3. **RIGHT JOIN（右外部結合）**：右テーブルのすべてのレコードと、左テーブルの一致するレコードを返す
4. **結合方法の使い分け**：目的に応じてINNER JOINと外部結合を使い分ける基準
5. **NULL値の処理**：外部結合結果のNULL値を適切に処理する方法
6. **ON句とWHERE句の違い**：条件の記述場所による結果の違い

適切な結合方法を選択することで、より柔軟で正確なデータの抽出が可能になります。特に、データの欠損（未提出、未登録など）を検出したい場合や、すべてのレコードを漏れなく処理したい場合には、外部結合が非常に役立ちます。

次の章では、「自己結合：同一テーブル内での関連付け」について学び、同じテーブル内でのデータ間の関係を扱う方法を学びます。



---

# 16. 自己結合：同一テーブル内での関連付け

## はじめに

これまでの章では、異なるテーブル同士を結合する方法について学びました。しかし実際のデータベース設計では、同じテーブル内にデータ同士の関連がある場合があります。例えば：

- 社員テーブルで「上司」も同じ社員テーブル内の別の社員である
- 部品表で「部品」と「その部品の構成部品」が同じテーブルに格納されている
- 家系図データで「親」と「子」が同じ人物テーブルに格納されている

このような「同一テーブル内のレコード同士の関連」を取り扱うための結合方法が「自己結合（セルフジョイン）」です。この章では、テーブル自身と結合して情報を取得する方法について学びます。

## 自己結合（セルフジョイン）とは

自己結合とは、テーブルを自分自身と結合する技術です。テーブル内のあるレコードと、同じテーブル内の別のレコードとの関係を表現するために使用されます。

> **用語解説**：
> - **自己結合（セルフジョイン）**：同じテーブルを異なる別名で参照し、テーブル自身と結合する手法です。
> - **再帰的関係**：同じエンティティ（テーブル）内での親子関係や階層構造などの関係のこと。

## 自己結合の基本

自己結合を行うには、同じテーブルを異なる別名で参照する必要があります。これは通常、テーブル別名（エイリアス）を使用して実現します。

### 基本構文

```sql
SELECT a.カラム1, a.カラム2, b.カラム1, b.カラム2
FROM テーブル名 a
JOIN テーブル名 b ON a.関連カラム = b.主キー;
```

ここで、`a`と`b`は同じテーブルに対する異なる別名です。

## 自己結合の実践例

学校データベースでは、明示的な再帰的関係を持つテーブルはありませんが、自己結合の概念を理解するために簡単な例を見てみましょう。

### 例1：同じ教師が担当する講座を検索

```sql
SELECT 
    c1.course_id AS 講座ID, 
    c1.course_name AS 講座名,
    c2.course_id AS 関連講座ID,
    c2.course_name AS 関連講座名,
    t.teacher_name AS 担当教師
FROM courses c1
JOIN courses c2 ON c1.teacher_id = c2.teacher_id AND c1.course_id < c2.course_id
JOIN teachers t ON c1.teacher_id = t.teacher_id
ORDER BY t.teacher_name, c1.course_id, c2.course_id;
```

このクエリは、同じ教師が担当している講座の組み合わせを検索しています。
- `c1`と`c2`は同じcoursesテーブルの別名
- `c1.teacher_id = c2.teacher_id`で同じ教師を担当している講座を結合
- `c1.course_id < c2.course_id`でペアの重複を避けています（例：講座1と講座2、講座2と講座1が両方表示されることを防ぐ）

実行結果：

| 講座ID | 講座名                 | 関連講座ID | 関連講座名             | 担当教師   |
|-------|------------------------|-----------|------------------------|-----------|
| 4     | Webアプリケーション開発 | 8         | モバイルアプリ開発     | 藤本理恵   |
| 4     | Webアプリケーション開発 | 22        | フルスタック開発マスタークラス | 藤本理恵 |
| 8     | モバイルアプリ開発     | 22        | フルスタック開発マスタークラス | 藤本理恵 |
| 1     | ITのための基礎知識     | 3         | Cプログラミング演習     | 寺内鞍     |
| 1     | ITのための基礎知識     | 29        | コードリファクタリングとクリーンコード | 寺内鞍 |
| 3     | Cプログラミング演習     | 29        | コードリファクタリングとクリーンコード | 寺内鞍 |
| ...   | ...                    | ...       | ...                    | ...       |

### 例2：同じ日に複数の授業がある教師を検索

```sql
SELECT 
    cs1.schedule_date AS 日付,
    t.teacher_name AS 教師名,
    cs1.period_id AS 時限1,
    c1.course_name AS 講座1,
    cs2.period_id AS 時限2,
    c2.course_name AS 講座2
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.teacher_id = cs2.teacher_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.period_id < cs2.period_id
JOIN teachers t ON cs1.teacher_id = t.teacher_id
JOIN courses c1 ON cs1.course_id = c1.course_id
JOIN courses c2 ON cs2.course_id = c2.course_id
WHERE cs1.schedule_date = '2025-05-21'
ORDER BY cs1.schedule_date, t.teacher_name, cs1.period_id, cs2.period_id;
```

このクエリは、同じ日に複数の授業を担当する教師と、その授業の組み合わせを検索しています。
- `cs1`と`cs2`は同じcourse_scheduleテーブルの別名
- `cs1.teacher_id = cs2.teacher_id AND cs1.schedule_date = cs2.schedule_date`で同じ教師が同じ日に担当している授業を結合
- `cs1.period_id < cs2.period_id`でペアの重複を避けています

実行結果（例）：

| 日付       | 教師名     | 時限1 | 講座1                 | 時限2 | 講座2                 |
|-----------|------------|------|----------------------|------|----------------------|
| 2025-05-21 | 星野涼子   | 1    | 高度データ可視化技術   | 3    | データサイエンスとビジネス応用 |
| 2025-05-21 | 寺内鞍     | 2    | コードリファクタリングとクリーンコード | 4 | Cプログラミング演習 |
| ...       | ...        | ...  | ...                  | ...  | ...                  |

## 自己結合の応用：階層構造の表現

自己結合は、階層構造のデータを表現する際に特に役立ちます。例えば、組織図、カテゴリ階層、部品表などです。

ここでは、学校データベースにはない例として、架空の「社員」テーブルを使って階層構造を表現する例を示します：

### 例3：架空の社員テーブルを使った階層構造の表現

```sql
-- 架空の社員テーブル
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100),
  manager_id INT,
  FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- サンプルデータ
INSERT INTO employees VALUES (1, '山田太郎', NULL);  -- 社長（上司なし）
INSERT INTO employees VALUES (2, '佐藤次郎', 1);     -- 山田の部下
INSERT INTO employees VALUES (3, '鈴木三郎', 1);     -- 山田の部下
INSERT INTO employees VALUES (4, '高橋四郎', 2);     -- 佐藤の部下
INSERT INTO employees VALUES (5, '田中五郎', 2);     -- 佐藤の部下
INSERT INTO employees VALUES (6, '伊藤六郎', 3);     -- 鈴木の部下

-- 社員と直属の上司を取得
SELECT 
    e.employee_id,
    e.employee_name AS 社員名,
    m.employee_name AS 上司名
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;
```

結果：

| employee_id | 社員名     | 上司名     |
|-------------|------------|------------|
| 1           | 山田太郎   | NULL       |
| 2           | 佐藤次郎   | 山田太郎   |
| 3           | 鈴木三郎   | 山田太郎   |
| 4           | 高橋四郎   | 佐藤次郎   |
| 5           | 田中五郎   | 佐藤次郎   |
| 6           | 伊藤六郎   | 鈴木三郎   |

この例では、社員テーブルの`manager_id`が同じテーブルの`employee_id`を参照しています（自己参照）。自己結合を使用して、各社員の上司の名前を取得しています。

### 例4：架空の社員テーブルを使った部下の一覧表示

```sql
-- ある上司の直属の部下を取得
SELECT 
    m.employee_id AS 上司ID,
    m.employee_name AS 上司名,
    e.employee_id AS 部下ID,
    e.employee_name AS 部下名
FROM employees m
JOIN employees e ON m.employee_id = e.manager_id
WHERE m.employee_id = 2
ORDER BY e.employee_id;
```

結果：

| 上司ID | 上司名   | 部下ID | 部下名   |
|--------|----------|--------|----------|
| 2      | 佐藤次郎 | 4      | 高橋四郎 |
| 2      | 佐藤次郎 | 5      | 田中五郎 |

この例では、社員テーブルを`m`（上司）と`e`（部下）として自己結合し、上司ID=2の部下を取得しています。

## 学校データベースでの自己結合活用例

実際の学校データベースでは、自己結合を利用できる具体的なシナリオを見てみましょう。

### 例5：同じ教室を使用する授業の組み合わせ

```sql
SELECT 
    cs1.schedule_date AS 日付,
    cs1.classroom_id AS 教室,
    cs1.period_id AS 時限1,
    c1.course_name AS 講座1,
    t1.teacher_name AS 教師1,
    cs2.period_id AS 時限2,
    c2.course_name AS 講座2,
    t2.teacher_name AS 教師2
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.classroom_id = cs2.classroom_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.period_id < cs2.period_id
JOIN courses c1 ON cs1.course_id = c1.course_id
JOIN courses c2 ON cs2.course_id = c2.course_id
JOIN teachers t1 ON cs1.teacher_id = t1.teacher_id
JOIN teachers t2 ON cs2.teacher_id = t2.teacher_id
WHERE cs1.schedule_date = '2025-05-21'
ORDER BY cs1.classroom_id, cs1.period_id;
```

このクエリは、同じ日に同じ教室で行われる授業の組み合わせを検索しています。教室の利用状況や消毒・清掃のスケジュール計画などに役立ちます。

### 例6：同じ学生が受講している講座の組み合わせ

```sql
SELECT 
    sc1.student_id,
    s.student_name,
    c1.course_name AS 講座1,
    c2.course_name AS 講座2
FROM student_courses sc1
JOIN student_courses sc2 ON sc1.student_id = sc2.student_id AND sc1.course_id < sc2.course_id
JOIN students s ON sc1.student_id = s.student_id
JOIN courses c1 ON sc1.course_id = c1.course_id
JOIN courses c2 ON sc2.course_id = c2.course_id
WHERE sc1.student_id = 301
ORDER BY c1.course_name, c2.course_name;
```

このクエリは、学生ID=301の学生が受講しているすべての講座の組み合わせを検索しています。学生の履修パターンの分析や時間割の調整などに役立ちます。

## INNER JOINとLEFT JOINの自己結合

自己結合では、INNER JOIN、LEFT JOIN、RIGHT JOINなど、すべての結合タイプを使用できます。結合タイプの選択は、取得したいデータの性質に依存します。

### 例7：部下のいない社員を見つける（LEFT JOIN）

```sql
-- 架空の社員テーブルを使用
SELECT 
    m.employee_id,
    m.employee_name,
    COUNT(e.employee_id) AS 部下の数
FROM employees m
LEFT JOIN employees e ON m.employee_id = e.manager_id
GROUP BY m.employee_id, m.employee_name
HAVING COUNT(e.employee_id) = 0
ORDER BY m.employee_id;
```

このクエリは、部下のいない社員（つまり、誰も自分を上司として参照していない社員）を検索しています。結果として、employee_id = 4, 5, 6の社員（高橋四郎、田中五郎、伊藤六郎）が表示されるでしょう。

## 自己結合の注意点

自己結合を使用する際には、以下の点に注意が必要です：

1. **テーブル別名の明確化**：同じテーブルを複数回参照するため、わかりやすいテーブル別名を使用し、混乱を避けましょう。

2. **結合条件の正確性**：自己結合では結合条件が不適切だと、結果が指数関数的に増えることがあります。必要に応じて絞り込み条件を追加しましょう。

3. **重複の排除**：例1や例2で使用した`id1 < id2`のような条件を使って、組み合わせの重複を避けることが重要です。

4. **パフォーマンス**：自己結合は、特に大きなテーブルでは処理が重くなる可能性があります。必要に応じてインデックスを使用して最適化しましょう。

## 練習問題

### 問題16-1
教師（teachers）テーブルを自己結合して、教師IDが連続する教師のペア（例：ID 101と102, 102と103）を取得するSQLを書いてください。

### 問題16-2
course_schedule（授業カレンダー）テーブルを自己結合して、2025年5月15日に同じ教室で行われる授業のペアを時限の昇順で取得するSQLを書いてください。course_id、period_id、classroom_idの3つを表示してください。

### 問題16-3
生徒（students）テーブルを自己結合して、学生名（student_name）のファーストネーム（名前の最初の文字）が同じ学生のペアを取得するSQLを書いてください。ヒント：SUBSTRING関数を使用します。

### 問題16-4
course_schedule（授業カレンダー）テーブルを自己結合して、同じ日に同じ講師が担当する授業のペアを見つけるSQLを書いてください。期間が離れていない授業（period_idの差が1または2）のみを対象とします。

### 問題16-5
grades（成績）テーブルを自己結合して、同じ学生の異なる課題タイプ（grade_type）間で点数差が10点以上あるケースを検出するSQLを書いてください。

### 問題16-6
以下のような架空の「職階」テーブルを作成し、直接の上下関係（部下と上司）だけでなく、組織階層全体を表示するSQLを書いてください。

```sql
-- 架空の職階テーブル
CREATE TABLE job_hierarchy (
  level_id INT PRIMARY KEY,
  level_name VARCHAR(50),
  reports_to INT,
  FOREIGN KEY (reports_to) REFERENCES job_hierarchy(level_id)
);

-- データ挿入
INSERT INTO job_hierarchy VALUES (1, '学長', NULL);
INSERT INTO job_hierarchy VALUES (2, '副学長', 1);
INSERT INTO job_hierarchy VALUES (3, '学部長', 2);
INSERT INTO job_hierarchy VALUES (4, '学科長', 3);
INSERT INTO job_hierarchy VALUES (5, '教授', 4);
INSERT INTO job_hierarchy VALUES (6, '准教授', 5);
INSERT INTO job_hierarchy VALUES (7, '講師', 6);
INSERT INTO job_hierarchy VALUES (8, '助教', 7);
```

## 解答

### 解答16-1
```sql
SELECT 
    t1.teacher_id AS 教師ID1,
    t1.teacher_name AS 教師名1,
    t2.teacher_id AS 教師ID2,
    t2.teacher_name AS 教師名2
FROM teachers t1
JOIN teachers t2 ON t1.teacher_id + 1 = t2.teacher_id
ORDER BY t1.teacher_id;
```

### 解答16-2
```sql
SELECT 
    cs1.course_id AS 講座ID1,
    cs1.period_id AS 時限1,
    cs2.course_id AS 講座ID2,
    cs2.period_id AS 時限2,
    cs1.classroom_id AS 教室
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.classroom_id = cs2.classroom_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.period_id < cs2.period_id
WHERE cs1.schedule_date = '2025-05-15'
ORDER BY cs1.classroom_id, cs1.period_id, cs2.period_id;
```

### 解答16-3
```sql
SELECT 
    s1.student_id AS 学生ID1,
    s1.student_name AS 学生名1,
    s2.student_id AS 学生ID2,
    s2.student_name AS 学生名2,
    SUBSTRING(s1.student_name, 1, 1) AS 共通文字
FROM students s1
JOIN students s2 ON SUBSTRING(s1.student_name, 1, 1) = SUBSTRING(s2.student_name, 1, 1)
              AND s1.student_id < s2.student_id
ORDER BY 共通文字, s1.student_id, s2.student_id;
```

### 解答16-4
```sql
SELECT 
    cs1.schedule_date AS 日付,
    t.teacher_name AS 教師名,
    cs1.period_id AS 時限1,
    cs1.course_id AS 講座ID1,
    cs2.period_id AS 時限2,
    cs2.course_id AS 講座ID2,
    ABS(cs1.period_id - cs2.period_id) AS 時限差
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.teacher_id = cs2.teacher_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.schedule_id < cs2.schedule_id
JOIN teachers t ON cs1.teacher_id = t.teacher_id
WHERE ABS(cs1.period_id - cs2.period_id) IN (1, 2)
ORDER BY cs1.schedule_date, t.teacher_name, cs1.period_id;
```

### 解答16-5
```sql
SELECT 
    g1.student_id,
    s.student_name,
    g1.grade_type AS 評価タイプ1,
    g1.score AS 点数1,
    g2.grade_type AS 評価タイプ2,
    g2.score AS 点数2,
    ABS(g1.score - g2.score) AS 点数差
FROM grades g1
JOIN grades g2 ON g1.student_id = g2.student_id 
               AND g1.course_id = g2.course_id 
               AND g1.grade_type < g2.grade_type
JOIN students s ON g1.student_id = s.student_id
WHERE ABS(g1.score - g2.score) >= 10
ORDER BY 点数差 DESC, g1.student_id;
```

### 解答16-6
```sql
-- 組織階層全体を表示
WITH RECURSIVE hierarchy AS (
  -- 基点（学長）
  SELECT 
    level_id, 
    level_name, 
    reports_to, 
    0 AS depth, 
    CAST(level_name AS CHAR(200)) AS path
  FROM job_hierarchy
  WHERE reports_to IS NULL
  
  UNION ALL
  
  -- 再帰部分
  SELECT 
    j.level_id, 
    j.level_name, 
    j.reports_to, 
    h.depth + 1, 
    CONCAT(h.path, ' > ', j.level_name)
  FROM job_hierarchy j
  JOIN hierarchy h ON j.reports_to = h.level_id
)
SELECT 
  level_id,
  level_name,
  reports_to,
  depth,
  CONCAT(REPEAT('    ', depth), level_name) AS 階層表示,
  path AS 組織経路
FROM hierarchy
ORDER BY depth, level_id;
```

注意：最後の問題は再帰共通テーブル式（Recursive CTE）を使用しています。これはMySQL 8.0以降でサポートされています。再帰CTEはまだ学習していない高度な内容ですが、階層構造を扱う効果的な方法として参考になります。

## まとめ

この章では、同一テーブル内でのレコード間の関連を扱うための「自己結合」について学びました：

1. **自己結合の概念**：テーブルを自分自身と結合して、同一テーブル内のレコード間の関係を表現する方法
2. **基本的な構文**：テーブル別名を使用して同じテーブルを複数回参照する方法
3. **実践的な例**：同じ教師が担当する講座、同じ日の複数の授業など、実用的な自己結合のケース
4. **階層構造の表現**：上司と部下、組織階層など、再帰的な関係の表現方法
5. **さまざまな結合タイプ**：INNER JOINやLEFT JOINなど、自己結合でも利用可能な結合の種類
6. **注意点**：テーブル別名の明確化、結合条件の正確性、重複の排除、パフォーマンスの考慮

自己結合は、階層構造の表現や、同一エンティティ内での関連を取り扱う強力な手法です。特に組織図、部品表、カテゴリ階層、家系図など、再帰的な関係を含むデータモデルで頻繁に活用されます。

次の章では、「複数テーブル結合：3つ以上のテーブルの連結」について学び、より複雑なデータ関係を扱う方法を学びます。



---

# 17. 複数テーブル結合：3つ以上のテーブルの連結

## はじめに

これまでの章では、2つのテーブルを結合する方法や、同じテーブルを自己結合する方法について学びました。しかし、実際のデータベース操作では、3つ以上のテーブルを一度に結合して情報を取得する必要があることが多くあります。

例えば、以下のようなケースを考えてみましょう：
- 「学生の名前、受講している講座名、その担当教師名、教室情報を一度に取得したい」
- 「授業スケジュール、講座情報、教室情報、時間情報をまとめて表示したい」
- 「成績データに学生名、講座名、提出情報を関連付けて分析したい」

これらを実現するには、3つ以上のテーブルを連結する必要があります。この章では、複数のテーブルを効果的に結合する方法について学びます。

## 複数テーブル結合の基本

3つ以上のテーブルを結合する基本的な考え方は、2つのテーブルの結合を拡張したものです。2つのテーブルを結合した結果に、さらに別のテーブルを結合していきます。

> **用語解説**：
> - **複数結合**：3つ以上のテーブルを一度に連結して情報を取得する操作のことです。
> - **結合チェーン**：複数のJOIN句を連続して記述し、テーブルをつなげていく方法です。

### 基本構文

```sql
SELECT カラムリスト
FROM テーブル1
JOIN テーブル2 ON 結合条件1
JOIN テーブル3 ON 結合条件2
JOIN テーブル4 ON 結合条件3
...;
```

JOINの種類（INNER JOIN、LEFT JOIN、RIGHT JOINなど）は、各結合ごとに適切に選択できます。

## 3つのテーブルを結合する例

まずは、3つのテーブルを結合する基本的な例を見てみましょう。

### 例1：学生、講座、教師の情報を連結する

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE s.student_id = 301
ORDER BY c.course_id;
```

このクエリでは：
1. 学生テーブル(`students`)を基点に
2. 受講テーブル(`student_courses`)を結合し
3. 講座テーブル(`courses`)を結合し
4. 教師テーブル(`teachers`)を結合しています

実行結果：

| student_id | 学生名   | 講座名                 | 担当教師   |
|------------|----------|------------------------|------------|
| 301        | 黒沢春馬 | ITのための基礎知識     | 寺内鞍     |
| 301        | 黒沢春馬 | UNIX入門               | 田尻朋美   |
| 301        | 黒沢春馬 | クラウドコンピューティング | 吉岡由佳 |
| 301        | 黒沢春馬 | クラウドネイティブアーキテクチャ | 吉岡由佳 |
| ...        | ...      | ...                    | ...        |

## 4つ以上のテーブルを結合する例

より複雑な情報を取得するために、4つ以上のテーブルを結合してみましょう。

### 例2：授業スケジュール詳細の取得

```sql
SELECT 
    cs.schedule_date AS 日付,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師,
    cl.classroom_name AS 教室,
    cl.building AS 建物,
    cs.status AS 状態
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
WHERE cs.schedule_date = '2025-05-21'
ORDER BY cp.start_time, cl.classroom_id;
```

このクエリでは、5つのテーブルを結合して授業スケジュールの詳細情報を取得しています：
1. 授業カレンダーテーブル(`course_schedule`)を基点に
2. 講座テーブル(`courses`)を結合し
3. 教師テーブル(`teachers`)を結合し
4. 教室テーブル(`classrooms`)を結合し
5. 授業時間テーブル(`class_periods`)を結合しています

実行結果（例）：

| 日付       | 開始時間 | 終了時間 | 講座名                 | 担当教師   | 教室           | 建物  | 状態      |
|------------|----------|----------|------------------------|------------|----------------|-------|-----------|
| 2025-05-21 | 09:00:00 | 10:30:00 | 高度データ可視化技術   | 星野涼子   | 402Hコンピュータ実習室 | 4号館 | scheduled |
| 2025-05-21 | 09:00:00 | 10:30:00 | サイバーセキュリティ対策 | 深山誠一 | 301E講義室    | 3号館 | scheduled |
| 2025-05-21 | 10:40:00 | 12:10:00 | コードリファクタリングとクリーンコード | 寺内鞍 | 101Aコンピュータ実習室 | 1号館 | scheduled |
| ...        | ...      | ...      | ...                    | ...        | ...            | ...   | ...       |

## 複数テーブル結合のバリエーション

複数テーブルの結合では、さまざまな結合タイプを組み合わせることができます。

### 例3：INNER JOINとLEFT JOINの組み合わせ

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.grade_type AS 評価種別,
    g.score AS 点数,
    a.status AS 出席状況
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
LEFT JOIN grades g ON s.student_id = g.student_id AND sc.course_id = g.course_id AND g.grade_type = '中間テスト'
LEFT JOIN attendance a ON s.student_id = a.student_id
WHERE s.student_id = 301
ORDER BY c.course_id;
```

このクエリでは、以下のように異なる結合タイプを組み合わせています：
- students、student_courses、coursesテーブルには**INNER JOIN**を使用（関連データが必ず存在するため）
- gradesテーブルには**LEFT JOIN**を使用（中間テストの成績がない可能性があるため）
- attendanceテーブルにも**LEFT JOIN**を使用（出席情報がない可能性があるため）

## 結合順序とパフォーマンス

複数テーブルを結合する場合、結合の順序はSQLの実行計画に影響しますが、通常はデータベースのオプティマイザが最適な実行順序を決定します。ただし、以下の点に注意すると効率的なクエリを書くことができます：

1. **フィルタリングを早めに行う**：WHERE句での絞り込みを早い段階で行うことで、結合対象のレコード数を減らせます。

2. **小さいテーブルから大きいテーブルへ**：一般的に、小さいテーブルを基点に、より大きいテーブルを結合していく方が効率的です。

3. **結合条件の最適化**：インデックスが設定されているカラムを結合条件に使用すると、パフォーマンスが向上します。

### 例4：効率的な結合順序とフィルタリングの例

```sql
SELECT 
    cs.schedule_date,
    c.course_name,
    COUNT(a.student_id) AS 出席学生数
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND a.status = 'present'
WHERE cs.schedule_date BETWEEN '2025-05-01' AND '2025-05-31'
GROUP BY cs.schedule_id, cs.schedule_date, c.course_name
ORDER BY cs.schedule_date, c.course_name;
```

このクエリでは、以下の効率化を行っています：
- 日付範囲による絞り込みを早い段階で行っている（`course_schedule`テーブルへのWHERE句）
- 比較的小さい`course_schedule`テーブルを基点にしている
- 出席状態のフィルタリングを結合条件に含めている（`a.status = 'present'`）

## テーブル別名の重要性

複数テーブルの結合では、テーブル別名（エイリアス）の使用が特に重要になります。テーブル別名を使うことで：

1. コードが簡潔になる
2. 同じカラム名が複数のテーブルに存在する場合の曖昧さが解消される
3. SQLの可読性が向上する

### 例5：明確なテーブル別名の使用

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    t.teacher_name AS 教師名,
    cs.schedule_date AS 日付,
    cp.start_time AS 開始時間,
    cl.classroom_name AS 教室
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
JOIN course_schedule cs ON c.course_id = cs.course_id
JOIN class_periods cp ON cs.period_id = cp.period_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
WHERE s.student_id = 301
  AND cs.schedule_date >= '2025-05-01'
ORDER BY cs.schedule_date, cp.start_time;
```

このクエリでは、7つのテーブルに明確な別名を付けています：
- students → s
- student_courses → sc
- courses → c
- teachers → t
- course_schedule → cs
- class_periods → cp
- classrooms → cl

## 複雑な多テーブル結合の実用例

実際の業務でよく使われる、より複雑な多テーブル結合の例を見てみましょう。

### 例6：学生の成績と出席状況の総合分析

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_id,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師,
    -- 中間テストの点数
    MAX(CASE WHEN g.grade_type = '中間テスト' THEN g.score ELSE NULL END) AS 中間テスト,
    -- レポートの点数
    MAX(CASE WHEN g.grade_type = 'レポート1' THEN g.score ELSE NULL END) AS レポート,
    -- 出席情報の集計
    COUNT(DISTINCT cs.schedule_id) AS 授業回数,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS 出席回数,
    SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS 遅刻回数,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS 欠席回数,
    -- 出席率の計算
    ROUND(
        SUM(CASE 
            WHEN a.status = 'present' THEN 1 
            WHEN a.status = 'late' THEN 0.5 
            ELSE 0 
        END) / COUNT(DISTINCT cs.schedule_id) * 100, 
    1) AS 出席率
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
LEFT JOIN course_schedule cs ON c.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND s.student_id = a.student_id
WHERE s.student_id BETWEEN 301 AND 305
GROUP BY s.student_id, s.student_name, c.course_id, c.course_name, t.teacher_name
ORDER BY s.student_id, c.course_id;
```

このクエリは、複数のテーブルを結合して各学生の成績と出席状況を総合的に分析しています。特徴として：
- 複数テーブルの結合
- CASE式を使った条件付き集計
- GROUP BY句による集計
- 計算式を使った派生列（出席率）

## 練習問題

### 問題17-1
学生（students）、受講（student_courses）、講座（courses）の3つのテーブルを結合して、学生ID=302の学生が受講しているすべての講座名とその講座IDを取得するSQLを書いてください。

### 問題17-2
講座（courses）、授業カレンダー（course_schedule）、教室（classrooms）、授業時間（class_periods）の4つのテーブルを結合して、2025年5月22日のすべての授業スケジュールを、開始時間順に取得するSQLを書いてください。結果には講座名、教室名、開始時間、終了時間、担当教師名を含めてください。

### 問題17-3
学生（students）テーブル、成績（grades）テーブル、講座（courses）テーブルを結合して、「ITのための基礎知識」（course_id=1）の講座を受講している学生の中間テスト成績を、点数の高い順に取得するSQLを書いてください。結果には学生名、得点、および講座名を含めてください。

### 問題17-4
教師（teachers）テーブル、講座（courses）テーブル、授業カレンダー（course_schedule）テーブル、教室（classrooms）テーブルを結合して、教師ID=106（星野涼子）が2025年5月に担当するすべての授業の詳細を取得するSQLを書いてください。結果には授業日、講座名、教室名を含めてください。

### 問題17-5
学生（students）テーブル、受講（student_courses）テーブル、講座（courses）テーブル、成績（grades）テーブルを結合して、各学生の受講講座数と成績の平均点を計算するSQLを書いてください。成績がない場合も学生と講座は表示してください。結果を平均点の高い順に並べてください。

### 問題17-6
授業カレンダー（course_schedule）テーブル、講座（courses）テーブル、教師（teachers）テーブル、教師スケジュール管理（teacher_unavailability）テーブルを結合して、2025年5月20日以降に予定されている授業のうち、担当教師が不在期間と重なっている授業を特定するSQLを書いてください。結果には授業日、講座名、教師名、不在理由を含めてください。

## 解答

### 解答17-1
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_id,
    c.course_name AS 講座名
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE s.student_id = 302
ORDER BY c.course_id;
```

### 解答17-2
```sql
SELECT 
    c.course_name AS 講座名,
    cl.classroom_name AS 教室名,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間,
    t.teacher_name AS 担当教師名
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
WHERE cs.schedule_date = '2025-05-22'
ORDER BY cp.start_time, cl.classroom_id;
```

### 解答17-3
```sql
SELECT 
    s.student_name AS 学生名,
    g.score AS 得点,
    c.course_name AS 講座名
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE c.course_id = '1'
  AND g.grade_type = '中間テスト'
ORDER BY g.score DESC;
```

### 解答17-4
```sql
SELECT 
    cs.schedule_date AS 授業日,
    c.course_name AS 講座名,
    cl.classroom_name AS 教室名,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間
FROM teachers t
JOIN course_schedule cs ON t.teacher_id = cs.teacher_id
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
WHERE t.teacher_id = 106
  AND cs.schedule_date BETWEEN '2025-05-01' AND '2025-05-31'
ORDER BY cs.schedule_date, cp.start_time;
```

### 解答17-5
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    COUNT(DISTINCT sc.course_id) AS 受講講座数,
    AVG(g.score) AS 平均点
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN courses c ON sc.course_id = c.course_id
LEFT JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
GROUP BY s.student_id, s.student_name
ORDER BY 平均点 DESC NULLS LAST;
```

注：`NULLS LAST`はデータベースによってはサポートされていない場合があります。その場合は以下のように書き換えます：

```sql
ORDER BY CASE WHEN AVG(g.score) IS NULL THEN 0 ELSE 1 END DESC, AVG(g.score) DESC
```

### 解答17-6
```sql
SELECT 
    cs.schedule_date AS 授業日,
    c.course_name AS 講座名,
    t.teacher_name AS 教師名,
    tu.reason AS 不在理由
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
JOIN teacher_unavailability tu ON cs.teacher_id = tu.teacher_id
WHERE cs.schedule_date >= '2025-05-20'
  AND cs.schedule_date BETWEEN tu.start_date AND tu.end_date
ORDER BY cs.schedule_date, cs.period_id;
```

## まとめ

この章では、3つ以上のテーブルを結合して複雑な情報を取得する方法について学びました：

1. **複数テーブル結合の基本構文**：JOINをチェーンさせて3つ以上のテーブルを連結する方法
2. **さまざまな結合タイプの組み合わせ**：INNER JOIN、LEFT JOIN、RIGHT JOINを状況に応じて組み合わせる方法
3. **結合順序とパフォーマンスの考慮点**：効率的なクエリを作成するためのヒント
4. **テーブル別名の重要性**：複数テーブル結合での可読性と明確さの向上
5. **複雑な結合の実用例**：実際の業務で使われるような多テーブル結合の例

複数テーブルの結合は、関連するデータを効率的に取得し、有意義な情報を抽出するための重要なスキルです。特に正規化されたデータベースでは、必要な情報を得るためには複数のテーブルを結合することが必須となります。

次の章では、「サブクエリ：WHERE句内のサブクエリ」について学び、クエリの中に別のクエリを埋め込む高度なテクニックを習得していきます。



---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [1. SELECT基本：単一テーブルから特定カラムを取得する](#1-select基本単一テーブルから特定カラムを取得する)
2. [2. WHERE句：条件に合ったレコードを絞り込む](#2-where句条件に合ったレコードを絞り込む)
3. [3. 論理演算子：AND、OR、NOTを使った複合条件](#3-論理演算子andornotを使った複合条件)
4. [4. パターンマッチング：LIKE演算子と%、_ワイルドカード](#4-パターンマッチングlike演算子と_ワイルドカード)
5. [5. 範囲指定：BETWEEN、IN演算子](#5-範囲指定betweenin演算子)
6. [6. NULL値の処理：IS NULL、IS NOT NULL](#6-null値の処理is-nullis-not-null)
7. [7. ORDER BY：結果の並び替え](#7-order-by結果の並び替え)
8. [8. LIMIT句：結果件数の制限とページネーション](#8-limit句結果件数の制限とページネーション)

---


# 1. SELECT基本：単一テーブルから特定カラムを取得する

## はじめに

データベースからデータを取り出す作業は、料理人が大きな冷蔵庫から必要な材料だけを取り出すようなものです。SQLでは、この「取り出す」作業を「SELECT文」で行います。

SELECT文はSQLの中で最も基本的で、最もよく使われる命令です。この章では、単一のテーブル（データの表）から必要な情報だけを取り出す方法を学びます。

## 基本構文

SELECT文の最も基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名;
```

この文は「テーブル名というテーブルからカラム名という列のデータを取り出してください」という意味です。

> **用語解説**：
> - **SELECT**：「選択する」という意味のSQLコマンドで、データを取り出すときに使います。
> - **カラム**：テーブルの縦の列のことで、同じ種類のデータが並んでいます（例：名前のカラム、年齢のカラムなど）。
> - **FROM**：「〜から」という意味で、どのテーブルからデータを取るかを指定します。
> - **テーブル**：データベース内の表のことで、行と列で構成されています。

## 実践例：単一カラムの取得

学校データベースの中の「teachers」テーブル（教師テーブル）から、教師の名前だけを取得してみましょう。

```sql
SELECT teacher_name FROM teachers;
```

実行結果：

| teacher_name |
|--------------|
| 寺内鞍       |
| 田尻朋美     |
| 内村海凪     |
| 藤本理恵     |
| 黒木大介     |
| 星野涼子     |
| 深山誠一     |
| 吉岡由佳     |
| 山田太郎     |
| 佐藤花子     |
| ...          |

これは「teachers」テーブルの「teacher_name」という列（先生の名前）だけを取り出しています。

## 複数のカラムを取得する

料理に複数の材料が必要なように、データを取り出すときも複数の列が必要なことがよくあります。複数のカラムを取得するには、カラム名をカンマ（,）で区切って指定します。

```sql
SELECT カラム名1, カラム名2, カラム名3 FROM テーブル名;
```

例えば、教師の番号（ID）と名前を一緒に取得してみましょう：

```sql
SELECT teacher_id, teacher_name FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| 104        | 藤本理恵     |
| 105        | 黒木大介     |
| 106        | 星野涼子     |
| ...        | ...          |

## すべてのカラムを取得する

テーブルのすべての列を取得したい場合は、アスタリスク（*）を使います。これは「すべての列」を意味するワイルドカードです。

```sql
SELECT * FROM テーブル名;
```

例：
```sql
SELECT * FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| ...        | ...          |

> **注意**：`SELECT *`は便利ですが、実際の業務では必要なカラムだけを指定する方が良いとされています。これは、データ量が多いときに処理速度が遅くなるのを防ぐためです。

## カラムに別名をつける（AS句）

取得したカラムに分かりやすい名前（別名）をつけることができます。これは「AS」句を使います。

```sql
SELECT カラム名 AS 別名 FROM テーブル名;
```

> **用語解説**：
> - **AS**：「〜として」という意味で、カラムに別名をつけるときに使います。この別名は結果を表示するときだけ使われます。

例えば、教師IDを「番号」、教師名を「名前」として表示してみましょう：

```sql
SELECT teacher_id AS 番号, teacher_name AS 名前 FROM teachers;
```

実行結果：

| 番号  | 名前       |
|------|------------|
| 101  | 寺内鞍     |
| 102  | 田尻朋美   |
| 103  | 内村海凪   |
| ...  | ...        |

ASは省略することも可能です：

```sql
SELECT teacher_id 番号, teacher_name 名前 FROM teachers;
```

## 計算式を使う

SELECT文では、カラムの値を使った計算もできます。例えば、成績テーブルから点数と満点を取得して、達成率（パーセント）を計算してみましょう。

```sql
SELECT student_id, course_id, grade_type, 
       score, max_score,
       (score / max_score) * 100 AS 達成率
FROM grades;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 301        | 1         | 中間テスト   | 85.5  | 100.0     | 85.5     |
| 302        | 1         | 中間テスト   | 92.0  | 100.0     | 92.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

## 重複を除外する（DISTINCT）

同じ値が複数ある場合に、重複を除いて一意の値だけを表示するには「DISTINCT」キーワードを使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別された」という意味で、重複する値を除外して一意の値だけを取得します。

例えば、どの講座にどの教師が担当しているかを重複なしで確認してみましょう：

```sql
SELECT DISTINCT teacher_id FROM courses;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

これにより、courses（講座）テーブルで使われている教師IDが重複なく表示されます。

## 文字列の結合

文字列を結合するには、MySQLでは「CONCAT」関数を使います。例えば、教師のIDと名前を組み合わせて表示してみましょう：

```sql
SELECT CONCAT('教師ID:', teacher_id, ' 名前:', teacher_name) AS 教師情報
FROM teachers;
```

実行結果：

| 教師情報                  |
|--------------------------|
| 教師ID:101 名前:寺内鞍   |
| 教師ID:102 名前:田尻朋美 |
| ...                      |

> **用語解説**：
> - **CONCAT**：複数の文字列を一つにつなげる関数です。

## SELECT文と終了記号

SQLの文は通常、セミコロン（;）で終わります。これは「この命令はここで終わりです」という合図です。

複数のSQL文を一度に実行する場合は、それぞれの文の最後にセミコロンをつけます。

## 練習問題

### 問題1-1
students（学生）テーブルから、すべての学生の名前（student_name）を取得するSQLを書いてください。

### 問題1-2
classrooms（教室）テーブルから、教室ID（classroom_id）と教室名（classroom_name）を取得するSQLを書いてください。

### 問題1-3
courses（講座）テーブルから、すべての列（カラム）を取得するSQLを書いてください。

### 問題1-4
class_periods（授業時間）テーブルから、時限ID（period_id）、開始時間（start_time）、終了時間（end_time）を取得し、開始時間には「開始」、終了時間には「終了」という別名をつけるSQLを書いてください。

### 問題1-5
grades（成績）テーブルから、学生ID（student_id）、講座ID（course_id）、評価タイプ（grade_type）、得点（score）、満点（max_score）、そして得点を満点で割って100を掛けた値を「パーセント」という別名で取得するSQLを書いてください。

### 問題1-6
course_schedule（授業カレンダー）テーブルから、schedule_date（予定日）カラムだけを重複なしで取得するSQLを書いてください。

## 解答

### 解答1-1
```sql
SELECT student_name FROM students;
```

### 解答1-2
```sql
SELECT classroom_id, classroom_name FROM classrooms;
```

### 解答1-3
```sql
SELECT * FROM courses;
```

### 解答1-4
```sql
SELECT period_id, start_time AS 開始, end_time AS 終了 FROM class_periods;
```

### 解答1-5
```sql
SELECT student_id, course_id, grade_type, score, max_score,
       (score / max_score) * 100 AS パーセント
FROM grades;
```

### 解答1-6
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

## まとめ

この章では、SQLのSELECT文の基本を学びました：

1. 単一カラムの取得: `SELECT カラム名 FROM テーブル名;`
2. 複数カラムの取得: `SELECT カラム名1, カラム名2 FROM テーブル名;`
3. すべてのカラムの取得: `SELECT * FROM テーブル名;`
4. カラムに別名をつける: `SELECT カラム名 AS 別名 FROM テーブル名;`
5. 計算式を使う: `SELECT カラム名, (計算式) AS 別名 FROM テーブル名;`
6. 重複を除外する: `SELECT DISTINCT カラム名 FROM テーブル名;`
7. 文字列の結合: `SELECT CONCAT(文字列1, カラム名, 文字列2) FROM テーブル名;`

これらの基本操作を使いこなせるようになれば、データベースから必要な情報を効率よく取り出せるようになります。次の章では、WHERE句を使って条件に合ったデータだけを取り出す方法を学びます。



---

# 2. WHERE句：条件に合ったレコードを絞り込む

## はじめに

前章では、テーブルからデータを取得する基本的な方法を学びました。しかし実際の業務では、すべてのデータではなく、特定の条件に合ったデータだけを取得したいことがほとんどです。

例えば、「全生徒の情報」ではなく「特定の学科の生徒だけ」や「成績が80点以上の学生だけ」といった形で、データを絞り込みたい場合があります。

このような場合に使用するのが「WHERE句」です。WHERE句は、SELECTコマンドの後に追加して使い、条件に合致するレコード（行）だけを取得します。

## 基本構文

WHERE句の基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件式;
```

> **用語解説**：
> - **WHERE**：「〜の場所で」「〜の条件で」という意味のSQLコマンドで、条件に合うデータだけを抽出するために使います。
> - **条件式**：データが満たすべき条件を指定するための式です。例えば「age > 20」（年齢が20より大きい）などです。
> - **レコード**：テーブルの横の行のことで、1つのデータの集まりを表します。

## 基本的な比較演算子

WHERE句では、様々な比較演算子を使って条件を指定できます：

| 演算子 | 意味                   | 例                    |
|--------|------------------------|------------------------|
| =      | 等しい                 | age = 25               |
| <>     | 等しくない（≠と同じ）  | gender <> 'male'       |
| >      | より大きい             | score > 80             |
| <      | より小さい             | price < 1000           |
| >=     | 以上                   | height >= 170          |
| <=     | 以下                   | weight <= 70           |

## 実践例：基本的な条件での絞り込み

### 例1：等しい（=）
例えば、教師ID（teacher_id）が101の教師のみを取得するには：

```sql
SELECT * FROM teachers WHERE teacher_id = 101;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |

### 例2：より大きい（>）
成績（grades）テーブルから、90点を超える成績だけを取得するには：

```sql
SELECT * FROM grades WHERE score > 90;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例3：等しくない（<>）
講座IDが3ではない講座に関する成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id <> '3';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト  | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 301        | 2         | 実技試験    | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 文字列の比較

テキスト（文字列）を条件にする場合は、シングルクォーテーション（'）またはダブルクォーテーション（"）で囲みます。MySQLではどちらも使えますが、多くの場合シングルクォーテーションが推奨されます。

```sql
SELECT * FROM テーブル名 WHERE テキストカラム = 'テキスト値';
```

例えば、教師名（teacher_name）が「田尻朋美」の教師を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name = '田尻朋美';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |

## 日付の比較

日付の比較も同様にシングルクォーテーションで囲みます。日付の形式はデータベースの設定によって異なりますが、一般的にはISO形式（YYYY-MM-DD）が使われます。

```sql
SELECT * FROM テーブル名 WHERE 日付カラム = '日付';
```

例えば、2025年5月20日に提出された成績を検索するには：

```sql
SELECT * FROM grades WHERE submission_date = '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

また、日付同士の大小関係も比較できます：

```sql
SELECT * FROM grades WHERE submission_date < '2025-05-15';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | レポート1   | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1   | 48.0  | 50.0      | 2025-05-10      |
| 304        | 5         | ER図作成課題 | 27.5  | 30.0      | 2025-05-14      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 複数の条件を指定する（次章の内容）

WHERE句では、複数の条件を組み合わせることもできます。この詳細は次章「論理演算子：AND、OR、NOTを使った複合条件」で説明します。

例えば、講座IDが1で、かつ、得点が90以上の成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id = '1' AND score >= 90;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題2-1
students（学生）テーブルから、学生ID（student_id）が「310」の学生情報を取得するSQLを書いてください。

### 問題2-2
classrooms（教室）テーブルから、収容人数（capacity）が30人より多い教室の情報をすべて取得するSQLを書いてください。

### 問題2-3
courses（講座）テーブルから、教師ID（teacher_id）が「105」の講座情報を取得するSQLを書いてください。

### 問題2-4
course_schedule（授業カレンダー）テーブルから、「2025-05-15」の授業スケジュールをすべて取得するSQLを書いてください。

### 問題2-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」で、得点（score）が80点未満の成績を取得するSQLを書いてください。

### 問題2-6
teachers（教師）テーブルから、教師ID（teacher_id）が「101」ではない教師の名前を取得するSQLを書いてください。

## 解答

### 解答2-1
```sql
SELECT * FROM students WHERE student_id = 310;
```

### 解答2-2
```sql
SELECT * FROM classrooms WHERE capacity > 30;
```

### 解答2-3
```sql
SELECT * FROM courses WHERE teacher_id = 105;
```

### 解答2-4
```sql
SELECT * FROM course_schedule WHERE schedule_date = '2025-05-15';
```

### 解答2-5
```sql
SELECT * FROM grades WHERE grade_type = '中間テスト' AND score < 80;
```

### 解答2-6
```sql
SELECT teacher_name FROM teachers WHERE teacher_id <> 101;
```

## まとめ

この章では、WHERE句を使って条件に合ったレコードを取得する方法を学びました：

1. 基本的な比較演算子（=, <>, >, <, >=, <=）の使い方
2. 数値による条件絞り込み
3. 文字列（テキスト）による条件絞り込み
4. 日付による条件絞り込み

WHERE句は、大量のデータから必要な情報だけを取り出すための非常に重要な機能です。実際のデータベース操作では、この条件絞り込みを頻繁に使います。

次の章では、複数の条件を組み合わせるための「論理演算子（AND、OR、NOT）」について学びます。



---

# 3. 論理演算子：AND、OR、NOTを使った複合条件

## はじめに

前章では、WHERE句を使って単一の条件でデータを絞り込む方法を学びました。しかし実際の業務では、より複雑な条件でデータを絞り込む必要があることがよくあります。

例えば：
- 「成績が80点以上**かつ**出席率が90%以上の学生」
- 「数学**または**英語の成績が優秀な学生」
- 「課題を**まだ提出していない**学生」

このような複合条件を指定するために使うのが論理演算子です。主な論理演算子は次の3つです：

- **AND**：両方の条件を満たす（かつ）
- **OR**：いずれかの条件を満たす（または）
- **NOT**：条件を満たさない（〜ではない）

## AND演算子

AND演算子は、指定した**すべての条件を満たす**レコードだけを取得したいときに使います。

> **用語解説**：
> - **AND**：「かつ」「そして」という意味の論理演算子です。複数の条件をすべて満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 AND 条件2;
```

### 例：ANDを使った複合条件

例えば、中間テストで90点以上かつ満点が100点の成績レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

この例では、「score >= 90」と「max_score = 100」の両方の条件を満たすレコードだけが取得されます。

### 3つ以上の条件の組み合わせ

ANDを使って3つ以上の条件を組み合わせることもできます：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100 AND grade_type = '中間テスト';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## OR演算子

OR演算子は、指定した条件の**いずれか一つでも満たす**レコードを取得したいときに使います。

> **用語解説**：
> - **OR**：「または」「もしくは」という意味の論理演算子です。複数の条件のうち少なくとも1つを満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 OR 条件2;
```

### 例：ORを使った複合条件

例えば、教師IDが101または102の講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id = 101 OR teacher_id = 102;
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 2         | UNIX入門             | 102        |
| 3         | Cプログラミング演習    | 101        |
| 29        | コードリファクタリングとクリーンコード | 101 |
| 40        | ソフトウェアアーキテクチャパターン | 102 |
| ...       | ...                  | ...        |

この例では、「teacher_id = 101」または「teacher_id = 102」のいずれかの条件を満たすレコードが取得されます。

## NOT演算子

NOT演算子は、指定した条件を**満たさない**レコードを取得したいときに使います。

> **用語解説**：
> - **NOT**：「〜ではない」という意味の論理演算子です。条件を否定して、その条件を満たさないデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE NOT 条件;
```

### 例：NOTを使った否定条件

例えば、完了（completed）状態ではない授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
WHERE NOT status = 'completed';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 45          | 11        | 2025-05-20    | 5         | 401G         | 106        | scheduled |
| 46          | 12        | 2025-05-21    | 1         | 301E         | 107        | scheduled |
| 50          | 2         | 2025-05-23    | 3         | 101A         | 102        | cancelled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

この例では、statusが「completed」ではないレコード（scheduled状態やcancelled状態）が取得されます。

NOT演算子は、「〜ではない」という否定の条件を作るために使われます。例えば次の2つの書き方は同じ意味になります：

```sql
SELECT * FROM teachers WHERE NOT teacher_id = 101;
SELECT * FROM teachers WHERE teacher_id <> 101;
```

## 複合論理条件（AND、OR、NOTの組み合わせ）

AND、OR、NOTを組み合わせて、より複雑な条件を指定することもできます。

### 例：ANDとORの組み合わせ

例えば、「成績が90点以上で中間テストである」または「成績が45点以上でレポートである」レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE (score >= 90 AND grade_type = '中間テスト') 
   OR (score >= 45 AND grade_type = 'レポート1');
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 308        | 1         | レポート1  | 47.0  | 50.0      | 2025-05-09      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 優先順位と括弧の使用

論理演算子を組み合わせる場合、演算子の優先順位に注意が必要です。基本的に**ANDはORよりも優先順位が高い**です。つまり、ANDが先に処理されます。

例えば：
```sql
WHERE 条件1 OR 条件2 AND 条件3
```

これは次のように解釈されます：
```sql
WHERE 条件1 OR (条件2 AND 条件3)
```

意図した条件と異なる場合は、**括弧（）を使って明示的にグループ化**することが重要です：
```sql
WHERE (条件1 OR 条件2) AND 条件3
```

### 例：括弧を使った条件のグループ化

教師IDが101または102で、かつ、講座名に「プログラミング」という単語が含まれる講座を取得するには：

```sql
SELECT * FROM courses 
WHERE (teacher_id = 101 OR teacher_id = 102) 
  AND course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

この例では、括弧を使って「teacher_id = 101 OR teacher_id = 102」の部分をグループ化し、その条件と「course_name LIKE '%プログラミング%'」の条件をANDで結合しています。

## 練習問題

### 問題3-1
grades（成績）テーブルから、課題タイプ（grade_type）が「中間テスト」かつ点数（score）が85点以上のレコードを取得するSQLを書いてください。

### 問題3-2
classrooms（教室）テーブルから、収容人数（capacity）が40人以下または建物（building）が「1号館」の教室を取得するSQLを書いてください。

### 問題3-3
teachers（教師）テーブルから、教師ID（teacher_id）が101、102、103ではない教師の情報を取得するSQLを書いてください。

### 問題3-4
course_schedule（授業カレンダー）テーブルから、2025年5月20日の授業で、時限（period_id）が1か2で、かつ状態（status）が「scheduled」の授業を取得するSQLを書いてください。

### 問題3-5
students（学生）テーブルから、学生名（student_name）に「田」または「山」を含む学生を取得するSQLを書いてください。

### 問題3-6
grades（成績）テーブルから、提出日（submission_date）が2025年5月15日以降で、かつ（「中間テスト」で90点以上または「レポート1」で45点以上）の成績を取得するSQLを書いてください。

## 解答

### 解答3-1
```sql
SELECT * FROM grades 
WHERE grade_type = '中間テスト' AND score >= 85;
```

### 解答3-2
```sql
SELECT * FROM classrooms 
WHERE capacity <= 40 OR building = '1号館';
```

### 解答3-3
```sql
SELECT * FROM teachers 
WHERE NOT (teacher_id = 101 OR teacher_id = 102 OR teacher_id = 103);
```
または
```sql
SELECT * FROM teachers 
WHERE teacher_id <> 101 AND teacher_id <> 102 AND teacher_id <> 103;
```

### 解答3-4
```sql
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-20' 
  AND (period_id = 1 OR period_id = 2) 
  AND status = 'scheduled';
```

### 解答3-5
```sql
SELECT * FROM students 
WHERE student_name LIKE '%田%' OR student_name LIKE '%山%';
```

### 解答3-6
```sql
SELECT * FROM grades 
WHERE submission_date >= '2025-05-15' 
  AND ((grade_type = '中間テスト' AND score >= 90) 
       OR (grade_type = 'レポート1' AND score >= 45));
```

## まとめ

この章では、論理演算子（AND、OR、NOT）を使って複合条件を作る方法を学びました：

1. **AND**：すべての条件を満たすレコードを取得（条件1 AND 条件2）
2. **OR**：いずれかの条件を満たすレコードを取得（条件1 OR 条件2）
3. **NOT**：指定した条件を満たさないレコードを取得（NOT 条件）
4. **複合条件**：AND、OR、NOTを組み合わせたより複雑な条件
5. **括弧（）**：条件をグループ化して優先順位を明示的に指定

これらの論理演算子を使いこなすことで、より複雑で細かな条件でデータを絞り込むことができるようになります。実際のデータベース操作では、複数の条件を組み合わせることが頻繁にあるため、この章で学んだ内容は非常に重要です。

次の章では、テキストデータに対する検索を行う「パターンマッチング」について学びます。



---

# 4. パターンマッチング：LIKE演算子と%、_ワイルドカード

## はじめに

前章までは、データの完全一致や数値の比較といった条件での絞り込みを学びました。しかし実際の業務では、もっと柔軟な検索が必要なケースがあります。例えば：

- 「山」で始まる名前の学生を検索したい
- 「プログラミング」という単語を含む講座名を探したい
- 電話番号の一部だけ覚えているデータを探したい

このような「部分一致」や「パターン一致」の検索を行うためのSQLの機能が「パターンマッチング」です。この章では、パターンマッチングを行うための「LIKE演算子」と「ワイルドカード文字」について学びます。

## LIKE演算子の基本

LIKE演算子は、文字列のパターンマッチングを行うための演算子です。WHERE句と組み合わせて使用します。

> **用語解説**：
> - **LIKE**：「〜のような」という意味の演算子で、パターンに一致する文字列を検索します。
> - **パターンマッチング**：完全一致ではなく、一定のパターンに合致するデータを検索する方法です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 文字列カラム LIKE 'パターン';
```

パターンには、通常の文字に加えて、特別な意味を持つ「ワイルドカード文字」を使用できます。

## ワイルドカード文字

SQLでは主に2つのワイルドカード文字があります：

1. **%（パーセント）**：0文字以上の任意の文字列に一致します。
2. **_（アンダースコア）**：任意の1文字に一致します。

> **用語解説**：
> - **ワイルドカード**：任意の文字や文字列に一致する特殊な文字記号です。トランプのジョーカーのように、様々な値に代用できます。

## LIKE演算子の使い方：実践例

### 例1：%（パーセント）を使ったパターンマッチング

#### 「〜で始まる」パターン：前方一致

例えば、「山」で始まる学生名を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '山%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 山本裕子     |
| 325        | 山田翔太     |
| ...        | ...          |

ここでの「山%」は「山で始まり、その後に0文字以上の任意の文字が続く」という意味です。

#### 「〜で終わる」パターン：後方一致

例えば、「子」で終わる教師名を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name LIKE '%子';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| 106        | 星野涼子     |
| 108        | 吉岡由佳     |
| 110        | 佐藤花子     |
| ...        | ...          |

#### 「〜を含む」パターン：部分一致

例えば、「プログラミング」という単語を含む講座名を検索するには：

```sql
SELECT * FROM courses WHERE course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| 14        | IoTデバイスプログラミング実践 | 110 |
| ...       | ...                  | ...        |

### 例2：_（アンダースコア）を使ったパターンマッチング

アンダースコアは任意の1文字に一致します。例えば、教室IDが「10_A」パターン（最初の2文字が「10」、3文字目が任意の1文字、最後が「A」）の教室を検索するには：

```sql
SELECT * FROM classrooms WHERE classroom_id LIKE '10_A';
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| ...          | ...            | ...      | ...      | ...        |

### 例3：%と_の組み合わせ

ワイルドカード文字は組み合わせて使うこともできます。例えば、「2文字目が田」の学生を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '_田%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 384        | 櫻井翼       |
| ...        | ...          |

## NOT LIKEを使った否定形のパターンマッチング

特定のパターンに一致しないレコードを検索したい場合は、「NOT LIKE」を使います。

> **用語解説**：
> - **NOT LIKE**：「〜のパターンに一致しない」という意味で、指定したパターンに一致しないデータを検索します。

例えば、講座名に「入門」を含まない講座を検索するには：

```sql
SELECT * FROM courses WHERE course_name NOT LIKE '%入門%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

## エスケープ文字の使用

もし検索したいパターンに「%」や「_」自体が含まれている場合は、それらを特別な文字としてではなく、通常の文字として扱うために「エスケープ文字」を使います。

> **用語解説**：
> - **エスケープ文字**：特別な意味を持つ文字を通常の文字として扱うための印です。

MySQLでは、バックスラッシュ（\）をエスケープ文字として使用できます。例えば、「50%」という値そのものを検索するには：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50\%';
```

または、ESCAPE句を使って明示的にエスケープ文字を指定することもできます：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50!%' ESCAPE '!';
```

この例では「!」をエスケープ文字として指定しています。

## 大文字と小文字の区別

MySQLのデフォルト設定では、LIKE演算子は大文字と小文字を区別しません（大文字小文字を同じものとして扱います）。

例えば、次の2つのクエリは同じ結果を返します：

```sql
SELECT * FROM courses WHERE course_name LIKE '%web%';
SELECT * FROM courses WHERE course_name LIKE '%Web%';
```

もし大文字と小文字を区別した検索が必要な場合は、「BINARY」キーワードを使用します：

```sql
SELECT * FROM courses WHERE course_name LIKE BINARY '%Web%';
```

この場合、「Web」は「web」とは一致しません。

## 複合条件との組み合わせ

LIKE演算子は、これまで学んだAND、OR、NOTなどの論理演算子と組み合わせて使うこともできます。

例えば、「田」で始まる名前で、かつ教師IDが102から105の間の教師を検索するには：

```sql
SELECT * FROM teachers 
WHERE teacher_name LIKE '田%' 
  AND teacher_id BETWEEN 102 AND 105;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| ...        | ...          |

## 練習問題

### 問題4-1
students（学生）テーブルから、学生名（student_name）が「佐藤」で始まる学生の情報をすべて取得するSQLを書いてください。

### 問題4-2
courses（講座）テーブルから、講座名（course_name）に「データ」という単語を含む講座の情報を取得するSQLを書いてください。

### 問題4-3
classrooms（教室）テーブルから、教室名（classroom_name）が「コンピュータ実習室」で終わる教室の情報を取得するSQLを書いてください。

### 問題4-4
teachers（教師）テーブルから、教師名（teacher_name）の2文字目が「木」である教師の情報を取得するSQLを書いてください。

### 問題4-5
courses（講座）テーブルから、講座名（course_name）に「入門」または「基礎」を含む講座を取得するSQLを書いてください。

### 問題4-6
students（学生）テーブルから、学生名（student_name）が「山」で始まり、かつ「子」で終わらない学生を取得するSQLを書いてください。

## 解答

### 解答4-1
```sql
SELECT * FROM students WHERE student_name LIKE '佐藤%';
```

### 解答4-2
```sql
SELECT * FROM courses WHERE course_name LIKE '%データ%';
```

### 解答4-3
```sql
SELECT * FROM classrooms WHERE classroom_name LIKE '%コンピュータ実習室';
```

### 解答4-4
```sql
SELECT * FROM teachers WHERE teacher_name LIKE '_木%';
```

### 解答4-5
```sql
SELECT * FROM courses 
WHERE course_name LIKE '%入門%' OR course_name LIKE '%基礎%';
```

### 解答4-6
```sql
SELECT * FROM students 
WHERE student_name LIKE '山%' AND student_name NOT LIKE '%子';
```

## まとめ

この章では、パターンマッチングを行うためのLIKE演算子と、その中で使用するワイルドカード文字（%と_）について学びました：

1. **LIKE演算子**：文字列パターンに一致するデータを検索するための演算子
2. **%（パーセント）**：0文字以上の任意の文字列に一致するワイルドカード
3. **_（アンダースコア）**：任意の1文字に一致するワイルドカード
4. **前方一致**：「パターン%」で「パターンで始まる」文字列に一致
5. **後方一致**：「%パターン」で「パターンで終わる」文字列に一致
6. **部分一致**：「%パターン%」で「パターンを含む」文字列に一致
7. **NOT LIKE**：指定したパターンに一致しないデータを検索
8. **エスケープ文字**：特殊文字（%や_）を通常の文字として扱うための方法
9. **複合条件との組み合わせ**：AND、ORなどと組み合わせたより複雑な条件

パターンマッチングは、特にテキストデータを扱う際に非常に便利な機能です。部分的な情報しか持っていない場合や、特定のパターンを持つデータを探す場合に活用できます。

次の章では、範囲指定のための「BETWEEN演算子」と「IN演算子」について学びます。



---

# 5. 範囲指定：BETWEEN、IN演算子

## はじめに

これまでの章では、等号（=）や不等号（>、<）を使って条件を指定する方法や、LIKE演算子を使ったパターンマッチングを学びました。この章では、値の範囲を指定する「BETWEEN演算子」と、複数の値を一度に指定できる「IN演算子」について学びます。

これらの演算子を使うと、次のような検索がより簡単になります：
- 「80点から90点の間の成績」
- 「2025年4月から6月の間のスケジュール」
- 「特定の教師IDリストに該当する講座」

## BETWEEN演算子：範囲を指定する

BETWEEN演算子は、ある値が指定した範囲内にあるかどうかを調べるために使います。

> **用語解説**：
> - **BETWEEN**：「〜の間に」という意味の演算子で、ある値が指定した最小値と最大値の間（両端の値を含む）にあるかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 BETWEEN 最小値 AND 最大値;
```

この構文は次の条件と同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 >= 最小値 AND カラム名 <= 最大値;
```

### 例1：数値範囲の指定

例えば、成績（grades）テーブルから、80点から90点の間の成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 308        | 6         | 小テスト1  | 89.0  | 100.0     | 2025-05-15      |
| ...        | ...       | ...        | ...   | ...       | ...             |

### 例2：日付範囲の指定

日付にもBETWEEN演算子が使えます。例えば、2025年5月10日から2025年5月20日までに提出された成績を取得するには：

```sql
SELECT * FROM grades 
WHERE submission_date BETWEEN '2025-05-10' AND '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | レポート1  | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## NOT BETWEEN：範囲外を指定する

NOT BETWEENを使うと、指定した範囲の外にある値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT BETWEEN 最小値 AND 最大値;
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 < 最小値 OR カラム名 > 最大値;
```

### 例：範囲外の値を取得

例えば、80点未満または90点より高い成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score NOT BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## IN演算子：複数の値を指定する

IN演算子は、ある値が指定した複数の値のリストのいずれかに一致するかどうかを調べるために使います。

> **用語解説**：
> - **IN**：「〜の中に含まれる」という意味の演算子で、ある値が指定したリストの中に含まれているかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (値1, 値2, 値3, ...);
```

この構文は次のOR条件の組み合わせと同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 = 値1 OR カラム名 = 値2 OR カラム名 = 値3 OR ...;
```

### 例1：数値リストの指定

例えば、教師ID（teacher_id）が101、103、105のいずれかである講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (101, 103, 105);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| 5         | データベース設計と実装  | 105        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

### 例2：文字列リストの指定

文字列のリストにも適用できます。例えば、特定の教室ID（classroom_id）のみの教室情報を取得するには：

```sql
SELECT * FROM classrooms 
WHERE classroom_id IN ('101A', '202D', '301E');
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| 202D         | 2号館コンピュータ実習室D | 25     | 2号館     | パソコン25台、プロジェクター、3Dプリンター |
| 301E         | 3号館講義室E      | 80       | 3号館     | プロジェクター、マイク設備、録画設備 |

## NOT IN：リストに含まれない値を指定する

NOT IN演算子を使うと、指定したリストに含まれない値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT IN (値1, 値2, 値3, ...);
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 <> 値1 AND カラム名 <> 値2 AND カラム名 <> 値3 AND ...;
```

### 例：リストに含まれない値を取得

例えば、教師IDが101、102、103以外の教師が担当する講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id NOT IN (101, 102, 103);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 4         | Webアプリケーション開発 | 104        |
| 5         | データベース設計と実装  | 105        |
| 6         | ネットワークセキュリティ | 107        |
| ...       | ...                  | ...        |

## IN演算子でのサブクエリの利用（基本）

IN演算子の括弧内には、直接値を書く代わりに、サブクエリ（別のSELECT文）を指定することもできます。これにより、動的に値のリストを生成できます。

> **用語解説**：
> - **サブクエリ**：SQL文の中に含まれる別のSQL文のことで、外側のSQL文（メインクエリ）に値や条件を提供します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (SELECT カラム名 FROM 別テーブル WHERE 条件);
```

### 例：サブクエリを使ったIN条件

例えば、教師名（teacher_name）に「田」を含む教師が担当している講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (
    SELECT teacher_id FROM teachers 
    WHERE teacher_name LIKE '%田%'
);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 2         | UNIX入門             | 102        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

この例では、まず「teachers」テーブルから名前に「田」を含む教師のIDを取得し、それらのIDを持つ講座を「courses」テーブルから取得しています。

## BETWEEN演算子とIN演算子の組み合わせ

BETWEEN演算子とIN演算子は、論理演算子（AND、OR）と組み合わせて、さらに複雑な条件を作ることができます。

### 例：BETWEENとINの組み合わせ

例えば、「教師IDが101、103、105のいずれかで、かつ、2025年5月15日から2025年6月15日の間に実施される授業」を取得するには：

```sql
SELECT * FROM course_schedule 
WHERE teacher_id IN (101, 103, 105) 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-06-15';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 38          | 1         | 2025-05-20    | 1         | 102B         | 101        | scheduled |
| 42          | 10        | 2025-05-23    | 3         | 201C         | 103        | scheduled |
| 45          | 5         | 2025-05-28    | 2         | 402H         | 105        | scheduled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

## 練習問題

### 問題5-1
grades（成績）テーブルから、得点（score）が85点から95点の間にある成績を取得するSQLを書いてください。

### 問題5-2
course_schedule（授業カレンダー）テーブルから、2025年5月1日から2025年5月31日までの授業スケジュールを取得するSQLを書いてください。

### 問題5-3
courses（講座）テーブルから、教師ID（teacher_id）が104、106、108のいずれかである講座の情報を取得するSQLを書いてください。

### 問題5-4
classrooms（教室）テーブルから、教室ID（classroom_id）が「101A」、「201C」、「301E」、「401G」以外の教室情報を取得するSQLを書いてください。

### 問題5-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」または「実技試験」で、かつ得点（score）が80点から90点の間にない成績を取得するSQLを書いてください。

### 問題5-6
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）が「101A」、「202D」のいずれかで、かつ2025年5月15日から2025年5月30日の間に実施される授業スケジュールを取得するSQLを書いてください。

## 解答

### 解答5-1
```sql
SELECT * FROM grades 
WHERE score BETWEEN 85 AND 95;
```

### 解答5-2
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

### 解答5-3
```sql
SELECT * FROM courses 
WHERE teacher_id IN (104, 106, 108);
```

### 解答5-4
```sql
SELECT * FROM classrooms 
WHERE classroom_id NOT IN ('101A', '201C', '301E', '401G');
```

### 解答5-5
```sql
SELECT * FROM grades 
WHERE grade_type IN ('中間テスト', '実技試験') 
  AND score NOT BETWEEN 80 AND 90;
```

### 解答5-6
```sql
SELECT * FROM course_schedule 
WHERE classroom_id IN ('101A', '202D') 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-05-30';
```

## まとめ

この章では、範囲指定のための「BETWEEN演算子」と複数値指定のための「IN演算子」について学びました：

1. **BETWEEN演算子**：値が指定した範囲内（両端を含む）にあるかどうかをチェック
2. **NOT BETWEEN**：値が指定した範囲外にあるかどうかをチェック
3. **IN演算子**：値が指定したリストのいずれかに一致するかどうかをチェック
4. **NOT IN**：値が指定したリストのいずれにも一致しないかどうかをチェック
5. **サブクエリとIN**：動的に生成された値のリストを使用する方法
6. **複合条件**：BETWEEN、IN、論理演算子を組み合わせたより複雑な条件

これらの演算子を使うことで、複数の条件を指定する場合に、SQLをより簡潔に書くことができます。特に、多くの値を指定する場合や範囲条件を指定する場合に便利です。

次の章では、「NULL値の処理：IS NULL、IS NOT NULL」について学びます。



---

# 6. NULL値の処理：IS NULL、IS NOT NULL

## はじめに

データベースの世界では、データがない状態を表すために「NULL」という特別な値が使われます。NULLは「空」や「0」や「空白文字」とは異なる、「値が存在しない」または「不明」であることを表す特殊な概念です。

例えば、学校データベースでは次のようなシナリオがあります：
- まだ成績が付けられていない（NULL）
- コメントが入力されていない（NULL）
- 授業がキャンセルされたため教室が割り当てられていない（NULL）

この章では、NULL値を正しく処理するための「IS NULL」と「IS NOT NULL」演算子について学びます。

## NULLとは何か？

NULL値には、いくつかの特徴があります：

1. **値がない**：NULLは値がないことを表します。0でも空文字列（''）でもなく、値そのものが存在しないことを示します。
2. **不明**：データが不明であることを表す場合もあります。
3. **未設定**：まだ値が設定されていないことを表す場合もあります。
4. **比較できない**：NULLは通常の比較演算子（=, <, >など）で比較できません。

> **用語解説**：
> - **NULL**：データベースにおいて「値がない」または「不明」を表す特殊な値です。0や空文字とは異なります。

## NULL値と通常の比較演算子

通常の比較演算子（=, <>, >, <, >=, <=）では、NULL値を正しく検出できません。例えば：

```sql
-- この条件はNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 = NULL;

-- この条件もNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 <> NULL;
```

これは、NULL値との等価比較は「不明」と評価されるためです。つまり、NULL = NULLでさえFALSEではなく「不明」になります。

## IS NULL演算子

NULL値を持つレコードを検索するには、「IS NULL」演算子を使います。

> **用語解説**：
> - **IS NULL**：カラムの値がNULLかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NULL;
```

### 例：IS NULLの使用

例えば、コメントが入力されていない（NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

実行結果：

| schedule_id | student_id | status  | comment |
|-------------|------------|---------|---------|
| 1           | 301        | present | NULL    |
| 1           | 306        | present | NULL    |
| 1           | 307        | present | NULL    |
| ...         | ...        | ...     | NULL    |

## IS NOT NULL演算子

逆に、NULL値を持たないレコード（つまり、何らかの値を持つレコード）を検索するには、「IS NOT NULL」演算子を使います。

> **用語解説**：
> - **IS NOT NULL**：カラムの値がNULLでないかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NOT NULL;
```

### 例：IS NOT NULLの使用

例えば、コメントが入力されている（NOT NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 302        | late   | 15分遅刻      |
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |

## NULL値の論理的な扱い

NULL値は論理演算（AND、OR、NOT）でも特殊な扱いを受けます。

- **NULL AND TRUE** → NULL（不明）
- **NULL AND FALSE** → FALSE
- **NULL OR TRUE** → TRUE
- **NULL OR FALSE** → NULL（不明）
- **NOT NULL** → NULL（不明）

この特殊な振る舞いが、バグや誤った結果の原因になることがあります。

## NULL値と結合条件

テーブル結合（JOINなど、後の章で学習）の際も、NULL値は特殊な扱いを受けます。NULL値同士は「等しい」とは判定されないため、通常の結合条件ではNULL値を持つレコードは結合されません。

## IS NULLとIS NOT NULLを使った複合条件

IS NULLとIS NOT NULLも、他の条件と組み合わせて使用できます。

### 例：複合条件でのIS NULLの使用

例えば、「出席状態が "absent"（欠席）で、コメントがNULLでない（理由が入力されている）レコード」を検索するには：

```sql
SELECT * FROM attendance 
WHERE status = 'absent' AND comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |

## NVL/IFNULL/COALESCE関数：NULL値の置換

NULL値を別の値に置き換えるための関数が用意されています。データベースによって関数名が異なることがありますが、機能は似ています：

- MySQL/MariaDB: **IFNULL(expr, replace_value)**
- Oracle: **NVL(expr, replace_value)**
- SQL Server: **ISNULL(expr, replace_value)**
- 標準SQL: **COALESCE(expr1, expr2, ..., exprN)** - 最初のNULLでない式を返します

### 例：IFNULL関数の使用（MySQL）

例えば、コメントがNULLの場合は「特記事項なし」と表示するには：

```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '特記事項なし') AS comment
FROM attendance;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | 特記事項なし  |
| 1           | 302        | late    | 15分遅刻      |
| 1           | 303        | absent  | 事前連絡あり  |
| ...         | ...        | ...     | ...           |

## NULLを使う際の注意点

1. **除外の罠**：`WHERE カラム名 <> 値` だけでは、NULL値を持つレコードは含まれません。すべてのレコードを対象にするには：
   ```sql
   WHERE カラム名 <> 値 OR カラム名 IS NULL
   ```

2. **集計関数**：COUNT(*)はすべての行を数えますが、COUNT(カラム名)はそのカラムがNULLでない行だけを数えます。

3. **インデックス**：多くのデータベースでは、NULL値にもインデックスを適用できますが、データベースによって動作が異なる場合があります。

4. **一意性制約**：一般的に、UNIQUE制約ではNULL値は重複としてカウントされません（複数のNULL値が許可されます）。

## 練習問題

### 問題6-1
attendance（出席）テーブルから、コメント（comment）がNULLの出席レコードをすべて取得するSQLを書いてください。

### 問題6-2
course_schedule（授業カレンダー）テーブルから、状態（status）が「cancelled」で、かつ教室ID（classroom_id）がNULLでないレコードを取得するSQLを書いてください。

### 問題6-3
grades（成績）テーブルから、提出日（submission_date）がNULLの成績レコードを取得するSQLを書いてください。

### 問題6-4
attendance（出席）テーブルから、出席状態（status）が「present」か「late」で、かつコメント（comment）がNULLのレコードを取得するSQLを書いてください。

### 問題6-5
以下のSQLで教師（teachers）テーブルから「佐藤」という名前を持つ教師を検索する場合、NULL値を持つレコードも含めるにはどう修正すべきですか？
```sql
SELECT * FROM teachers WHERE teacher_name <> '佐藤花子';
```

### 問題6-6
attendance（出席）テーブルのすべてのレコードを取得し、コメント（comment）がNULLの場合は「記録なし」と表示するSQLを書いてください。

## 解答

### 解答6-1
```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

### 解答6-2
```sql
SELECT * FROM course_schedule 
WHERE status = 'cancelled' AND classroom_id IS NOT NULL;
```

### 解答6-3
```sql
SELECT * FROM grades WHERE submission_date IS NULL;
```

### 解答6-4
```sql
SELECT * FROM attendance 
WHERE (status = 'present' OR status = 'late') AND comment IS NULL;
```
または
```sql
SELECT * FROM attendance 
WHERE status IN ('present', 'late') AND comment IS NULL;
```

### 解答6-5
```sql
SELECT * FROM teachers 
WHERE teacher_name <> '佐藤花子' OR teacher_name IS NULL;
```

### 解答6-6
```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '記録なし') AS comment
FROM attendance;
```

## まとめ

この章では、データベースにおけるNULL値の概念と、NULL値を扱うための演算子や関数について学びました：

1. **NULL値の概念**：値がない、不明、未設定を表す特殊な値
2. **IS NULL演算子**：NULL値を持つレコードを検索する方法
3. **IS NOT NULL演算子**：NULL値を持たないレコードを検索する方法
4. **NULL値の論理的扱い**：論理演算（AND、OR、NOT）におけるNULLの振る舞い
5. **複合条件**：IS NULL/IS NOT NULLと他の条件の組み合わせ
6. **NULL値の置換**：IFNULL/NVL/COALESCE関数の使用方法
7. **注意点**：NULL値を扱う際の一般的な落とし穴

NULL値の正確な理解と適切な処理は、SQLプログラミングの重要な部分です。不適切なNULL処理は、予期しない結果やバグの原因になります。

次の章では、クエリ結果の並び替えを行うための「ORDER BY：結果の並び替え」について学びます。



---

# 7. ORDER BY：結果の並び替え

## はじめに

これまでの章では、データベースから条件に合ったレコードを取得する方法を学んできました。しかし実際の業務では、取得したデータを見やすく整理する必要があります。例えば：

- 成績を高い順に表示したい
- 学生を名前の五十音順に並べたい
- 日付の新しい順にスケジュールを確認したい

このようなデータの「並び替え」を行うためのSQLコマンドが「ORDER BY」です。この章では、クエリ結果を特定の順序で並べる方法を学びます。

## ORDER BYの基本

ORDER BY句は、SELECT文の結果を指定したカラムの値に基づいて並び替えるために使います。

> **用語解説**：
> - **ORDER BY**：「〜の順に並べる」という意味のSQLコマンドで、クエリ結果の並び順を指定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] ORDER BY 並び替えカラム;
```

ORDER BY句は通常、SELECT文の最後に記述します。

### 例1：単一カラムでの並び替え

例えば、学生（students）テーブルから、学生名（student_name）の五十音順（辞書順）でデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_name;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 309        | 相沢吉夫      |
| 303        | 柴崎春花      |
| 306        | 河田咲奈      |
| 305        | 河口菜恵子    |
| ...        | ...          |

### デフォルトの並び順

ORDER BYを使わない場合、結果の順序は保証されません。多くの場合、データがデータベースに保存された順序で返されますが、これは信頼できるものではありません。

## 昇順と降順の指定

ORDER BY句では、並び順を「昇順」か「降順」のどちらかで指定できます。

> **用語解説**：
> - **昇順（ASC）**：小さい値から大きい値へ（A→Z、1→9）の順に並べます。
> - **降順（DESC）**：大きい値から小さい値へ（Z→A、9→1）の順に並べます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 ORDER BY 並び替えカラム [ASC|DESC];
```

ASC（昇順）がデフォルトのため、省略可能です。

### 例2：降順での並び替え

例えば、成績（grades）テーブルから、得点（score）の高い順（降順）に成績を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 複数カラムでの並び替え

複数のカラムを使って並び替えることもできます。最初に指定したカラムで並び替え、値が同じレコードがある場合は次のカラムで並び替えます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 
ORDER BY 並び替えカラム1 [ASC|DESC], 並び替えカラム2 [ASC|DESC], ...;
```

### 例3：複数カラムでの並び替え

例えば、成績（grades）テーブルから、課題タイプ（grade_type）の五十音順に並べ、同じ課題タイプ内では得点（score）の高い順に成績を取得するには：

```sql
SELECT * FROM grades 
ORDER BY grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| 321        | 2         | 実技試験     | 85.5  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト   | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| 302        | 1         | レポート1    | 48.0  | 50.0      | 2025-05-10      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例4：昇順と降順の混合

各カラムごとに並び順を指定することもできます。例えば、講座ID（course_id）の昇順、評価タイプ（grade_type）の昇順、得点（score）の降順で並べるには：

```sql
SELECT * FROM grades 
ORDER BY course_id ASC, grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## NULLの扱い

ORDER BYでNULL値を並び替える場合、データベース製品によって動作が異なります。多くのデータベースでは、NULL値は最小値または最大値として扱われます。

- MySQL/MariaDBでは、NULL値は昇順（ASC）の場合は最小値として（最初に表示）、降順（DESC）の場合は最大値として（最後に表示）扱われます。

一部のデータベース（PostgreSQLなど）では、NULL値の位置を明示的に指定するための「NULLS FIRST」「NULLS LAST」構文がサポートされています。

### 例5：NULL値の扱い

例えば、出席（attendance）テーブルからコメント（comment）でソートすると、NULLが最初に来ます：

```sql
SELECT * FROM attendance ORDER BY comment;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | NULL          |
| 1           | 306        | present | NULL          |
| ...         | ...        | ...     | NULL          |
| 1           | 308        | late    | 5分遅刻       |
| 1           | 323        | late    | 電車遅延      |
| ...         | ...        | ...     | ...           |

## カラム番号を使った並び替え

カラム名の代わりに、SELECT文の結果セットにおけるカラムの位置（番号）を使って並び替えることもできます。最初のカラムは1、2番目のカラムは2、という具合です。

### 構文

```sql
SELECT カラム名1, カラム名2, ... FROM テーブル名 ORDER BY カラム位置;
```

### 例6：カラム番号を使った並び替え

例えば、学生（students）テーブルから学生ID（student_id）と名前（student_name）を取得し、名前（2番目のカラム）で並べ替えるには：

```sql
SELECT student_id, student_name FROM students ORDER BY 2;
```

この場合、「ORDER BY 2」は「ORDER BY student_name」と同じ意味になります。

> **注意**：カラム番号を使う方法は、カラムの順序を変更すると問題が起きるため、実際の業務では使用を避けた方が良いとされています。

## 式や関数を使った並び替え

ORDER BY句で式や関数を使うことにより、計算結果に基づいて並び替えることもできます。

### 例7：式を使った並び替え

例えば、成績（grades）テーブルから、得点の達成率（score/max_score）の高い順に並べるには：

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY (score/max_score) DESC;
```

または

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY 達成率 DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 98.0     |
| 320        | 1         | レポート1    | 48.5  | 50.0      | 97.0     |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 95.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

### 例8：関数を使った並び替え

文字列関数を使って並び替えることもできます。例えば、月名で並べることを考えましょう：

```sql
SELECT schedule_date, MONTH(schedule_date) AS month
FROM course_schedule
ORDER BY MONTH(schedule_date);
```

実行結果：

| schedule_date | month |
|---------------|-------|
| 2025-04-07    | 4     |
| 2025-04-08    | 4     |
| ...           | ...   |
| 2025-05-01    | 5     |
| 2025-05-02    | 5     |
| ...           | ...   |
| 2025-06-01    | 6     |
| ...           | ...   |

## CASE式を使った条件付き並び替え

さらに高度な並び替えとして、CASE式を使って条件に応じた並び順を定義することもできます。

### 例9：CASE式を使った並び替え

例えば、出席（attendance）テーブルから、出席状況（status）を「欠席→遅刻→出席」の順に優先して表示するには：

```sql
SELECT * FROM attendance
ORDER BY CASE 
           WHEN status = 'absent' THEN 1
           WHEN status = 'late' THEN 2
           WHEN status = 'present' THEN 3
           ELSE 4
         END;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |
| 1           | 302        | late   | 15分遅刻      |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |
| 1           | 301        | present| NULL          |
| 1           | 306        | present| NULL          |
| ...         | ...        | ...    | ...           |

## 練習問題

### 問題7-1
students（学生）テーブルから、すべての学生情報を学生名（student_name）の降順（逆五十音順）で取得するSQLを書いてください。

### 問題7-2
grades（成績）テーブルから、得点（score）が85点以上の成績を得点の高い順に取得するSQLを書いてください。

### 問題7-3
course_schedule（授業カレンダー）テーブルから、2025年5月の授業スケジュールを日付（schedule_date）の昇順で取得するSQLを書いてください。

### 問題7-4
teachers（教師）テーブルから、教師IDと名前を取得し、名前（teacher_name）の五十音順で並べるSQLを書いてください。

### 問題7-5
grades（成績）テーブルから、講座ID（course_id）ごとに、成績を評価タイプ（grade_type）の五十音順に、同じ評価タイプ内では得点（score）の高い順に並べて取得するSQLを書いてください。

### 問題7-6
attendance（出席）テーブルから、すべての出席情報を出席状況（status）が「absent」「late」「present」の順番で、同じ状態内ではコメント（comment）の有無（NULLが後）で並べて取得するSQLを書いてください。

## 解答

### 解答7-1
```sql
SELECT * FROM students ORDER BY student_name DESC;
```

### 解答7-2
```sql
SELECT * FROM grades WHERE score >= 85 ORDER BY score DESC;
```

### 解答7-3
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31' 
ORDER BY schedule_date;
```

### 解答7-4
```sql
SELECT teacher_id, teacher_name FROM teachers ORDER BY teacher_name;
```

### 解答7-5
```sql
SELECT * FROM grades 
ORDER BY course_id, grade_type, score DESC;
```

### 解答7-6
```sql
SELECT * FROM attendance
ORDER BY 
  CASE 
    WHEN status = 'absent' THEN 1
    WHEN status = 'late' THEN 2
    WHEN status = 'present' THEN 3
    ELSE 4
  END,
  CASE 
    WHEN comment IS NULL THEN 2
    ELSE 1
  END;
```

## まとめ

この章では、クエリ結果を特定の順序で並べるための「ORDER BY」句について学びました：

1. **基本的な並び替え**：指定したカラムの値に基づいて結果を並べる方法
2. **昇順と降順**：ASC（昇順）とDESC（降順）の指定方法
3. **複数カラムでの並び替え**：優先順位の高いカラムから順に指定する方法
4. **NULL値の扱い**：NULL値が並び替えでどのように扱われるか
5. **カラム番号**：カラム名の代わりに位置で指定する方法（あまり推奨されない）
6. **式や関数**：計算結果に基づいて並べる方法
7. **CASE式**：条件付きの複雑な並び替え

ORDER BY句は、データを見やすく整理するために非常に重要です。特に大量のデータを扱う場合、適切な並び順はデータの理解を大きく助けます。

次の章では、取得する結果の件数を制限する「LIMIT句：結果件数の制限とページネーション」について学びます。



---

# 8. LIMIT句：結果件数の制限とページネーション

## はじめに

これまでの章では、条件に合うデータを取得し、それを特定の順序で並べる方法を学びました。しかし実際のアプリケーションでは、大量のデータがあるときに、その一部だけを表示したいことがよくあります。例えば：

- 成績上位10件だけを表示したい
- Webページで一度に20件ずつ表示したい（ページネーション）
- 最新の5件のお知らせだけを取得したい

このような「結果の件数を制限する」ためのSQLコマンドが「LIMIT句」です。この章では、クエリ結果の件数を制限する方法と、ページネーションの実装方法を学びます。

## LIMIT句の基本

LIMIT句は、SELECT文の結果から指定した件数だけを取得するために使います。

> **用語解説**：
> - **LIMIT**：「制限する」という意味のSQLコマンドで、取得する行数を制限します。

### 基本構文（MySQL/MariaDB）

MySQLやMariaDBでのLIMIT句の基本構文は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数;
```

LIMIT句は通常、SELECT文の最後に記述します（ORDER BYの後）。

### 例1：単純なLIMIT

例えば、学生（students）テーブルから最初の5人だけを取得するには：

```sql
SELECT * FROM students LIMIT 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |

### ORDER BYとLIMITの組み合わせ

通常、LIMIT句はORDER BY句と組み合わせて使用します。これにより、「上位N件」「最新N件」などの操作が可能になります。

### 例2：ORDER BYとLIMITの組み合わせ

例えば、成績（grades）テーブルから得点（score）の高い順に上位3件を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 3;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |

### 例3：最新のレコードを取得

日付でソートして最新のデータを取得することもよくあります。例えば、最新の3つの授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
ORDER BY schedule_date DESC LIMIT 3;
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 95          | 28        | 2026-12-21    | 3         | 202D         | 119        | scheduled |
| 94          | 1         | 2026-12-21    | 1         | 102B         | 101        | scheduled |
| 93          | 14        | 2026-12-15    | 4         | 202D         | 110        | scheduled |

## OFFSETとページネーション

Webアプリケーションなどでは、大量のデータを「ページ」に分けて表示することがよくあります（ページネーション）。この機能を実現するためには、「OFFSET」（オフセット）という機能が必要です。

> **用語解説**：
> - **OFFSET**：「ずらす」という意味で、結果セットの先頭から指定した数だけ行をスキップします。
> - **ページネーション**：大量のデータを複数のページに分割して表示する技術です。

### 基本構文（MySQL/MariaDB）

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数 OFFSET スキップ数;
```

または、短縮形として：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT スキップ数, 件数;
```

### 例4：OFFSETを使ったスキップ

例えば、学生（students）テーブルから6番目から10番目までの学生を取得するには：

```sql
SELECT * FROM students LIMIT 5 OFFSET 5;
```

または：

```sql
SELECT * FROM students LIMIT 5, 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 306        | 河田咲奈     |
| 307        | 織田柚夏     |
| 308        | 永田悦子     |
| 309        | 相沢吉夫     |
| 310        | 吉川伽羅     |

### 例5：ページネーションの実装

ページネーションを実装する場合、通常は以下の式を使ってOFFSETを計算します：

```
OFFSET = (ページ番号 - 1) × ページあたりの件数
```

例えば、1ページあたり10件表示で、3ページ目のデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 10 OFFSET 20;
```

または：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 20, 10;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 322        | 木村結衣     |
| 323        | 林正義       |
| 324        | 清水香織     |
| 325        | 山田翔太     |
| 326        | 葉山陽太     |
| 327        | 青山凛       |
| 328        | 沢村大和     |
| 329        | 白石優月     |
| 330        | 月岡星奈     |

## LIMIT句を使用する際の注意点

### 1. ORDER BYの重要性

LIMIT句を使用する場合、通常はORDER BY句も一緒に使うべきです。ORDER BYがなければ、どのレコードが取得されるかは保証されません。

```sql
-- 良い例：結果が予測可能
SELECT * FROM students ORDER BY student_id LIMIT 5;

-- 悪い例：結果が不確定
SELECT * FROM students LIMIT 5;
```

### 2. パフォーマンスへの影響

大規模なテーブルで大きなOFFSET値を使用すると、パフォーマンスが低下する可能性があります。これは、データベースがOFFSET分のレコードを読み込んでから破棄する必要があるためです。

### 3. データベース製品による構文の違い

LIMIT句の構文はデータベース製品によって異なります：

- **MySQL/MariaDB/SQLite**：`LIMIT 件数 OFFSET スキップ数` または `LIMIT スキップ数, 件数`
- **PostgreSQL**：`LIMIT 件数 OFFSET スキップ数`
- **Oracle**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY`
- **SQL Server**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY` または旧バージョンでは `TOP`句

この章では主にMySQL/MariaDBの構文を使用します。

## 実践的なページネーションの実装

実際のアプリケーションでページネーションを実装する場合、以下のようなコードになります（疑似コード）：

```
ページ番号 = URLから取得またはデフォルト値（例：1）
1ページあたりの件数 = 設定値（例：10）
総レコード数 = SELECTで取得（COUNT(*)を使用）
総ページ数 = CEILING(総レコード数 ÷ 1ページあたりの件数)
OFFSET = (ページ番号 - 1) × 1ページあたりの件数

SQLクエリ = "SELECT * FROM テーブル ORDER BY カラム LIMIT " + 1ページあたりの件数 + " OFFSET " + OFFSET
```

### 例6：総レコード数と総ページ数の取得

総レコード数を取得するには：

```sql
SELECT COUNT(*) AS total_records FROM students;
```

実行結果：

| total_records |
|---------------|
| 100           |

この場合、1ページあたり10件表示なら、総ページ数は10ページ（CEILING(100 ÷ 10)）になります。

## 練習問題

### 問題8-1
grades（成績）テーブルから、得点（score）の高い順に上位5件の成績レコードを取得するSQLを書いてください。

### 問題8-2
course_schedule（授業カレンダー）テーブルから、日付（schedule_date）の新しい順に3件のスケジュールを取得するSQLを書いてください。

### 問題8-3
students（学生）テーブルを学生ID（student_id）の昇順で並べ、11番目から15番目までの学生（5件）を取得するSQLを書いてください。

### 問題8-4
teachers（教師）テーブルから、教師名（teacher_name）の五十音順で6番目から10番目までの教師情報を取得するSQLを書いてください。

### 問題8-5
1ページあたり20件表示で、grades（成績）テーブルの3ページ目のデータを得点（score）の高い順に取得するSQLを書いてください。

### 問題8-6
course_schedule（授業カレンダー）テーブルから、状態（status）が「scheduled」のスケジュールを日付（schedule_date）の昇順で並べ、先頭から10件スキップして次の5件を取得するSQLを書いてください。

## 解答

### 解答8-1
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 5;
```

### 解答8-2
```sql
SELECT * FROM course_schedule ORDER BY schedule_date DESC LIMIT 3;
```

### 解答8-3
```sql
SELECT * FROM students ORDER BY student_id LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM students ORDER BY student_id LIMIT 10, 5;
```

### 解答8-4
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5 OFFSET 5;
```
または
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5, 5;
```

### 解答8-5
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 20 OFFSET 40;
```
または
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 40, 20;
```

### 解答8-6
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 10, 5;
```

## まとめ

この章では、クエリ結果の件数を制限するためのLIMIT句と、ページネーションの実装方法について学びました：

1. **LIMIT句の基本**：指定した件数だけのレコードを取得する方法
2. **ORDER BYとの組み合わせ**：順序付けされた結果から一部だけを取得する方法
3. **OFFSET**：結果の先頭から指定した数だけレコードをスキップする方法
4. **ページネーション**：大量のデータを複数のページに分けて表示する実装方法
5. **注意点**：LIMIT句を使用する際の留意事項
6. **データベース製品による違い**：異なるデータベースでの構文の違い

LIMIT句は特にWebアプリケーションの開発で重要な機能です。大量のデータを効率よく表示するためのページネーション機能を実装するために欠かせません。また、トップN（上位N件）やボトムN（下位N件）のデータを取得する際にも使われます。

次の章では、データの集計分析を行うための「集計関数：COUNT、SUM、AVG、MAX、MIN」について学びます。




---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [9. 集計関数：COUNT、SUM、AVG、MAX、MIN](#9-集計関数countsumavgmaxmin)
2. [10. GROUP BY：データのグループ化](#10-group-byデータのグループ化)
3. [11. HAVING：グループ化後の絞り込み](#11-havingグループ化後の絞り込み)
4. [12. DISTINCT：重複の除外](#12-distinct重複の除外)
5. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)

---


# 9. 集計関数：COUNT、SUM、AVG、MAX、MIN

## はじめに

これまでの章では、データベースからレコードを取得して表示する方法を学んできました。しかし、データベースを使う目的の一つは、大量のデータから有用な情報（集計、統計など）を抽出することです。例えば：

- 「学生の総数は何人か？」
- 「成績の平均点は？」
- 「最高点と最低点は？」
- 「全講座の合計受講者数は？」

このような「データの集計」を行うためのSQLの機能が「集計関数」です。この章では、最もよく使われる5つの集計関数（COUNT、SUM、AVG、MAX、MIN）について学びます。

## 集計関数の基本

集計関数は、複数の行のデータをまとめて一つの値を返す関数です。

> **用語解説**：
> - **集計関数**：複数の行（レコード）から計算された単一の値を返す関数です。データの集計や統計に使用されます。

### 主な集計関数

| 関数   | 説明                     | 例                                 |
|--------|--------------------------|-------------------------------------|
| COUNT  | レコード数を数える        | 学生の総数                           |
| SUM    | 値の合計を計算する        | 全成績の点数合計                     |
| AVG    | 値の平均を計算する        | 平均点                             |
| MAX    | 最大値を取得する         | 最高点                             |
| MIN    | 最小値を取得する         | 最低点                             |

## COUNT関数：レコード数をカウントする

COUNT関数は、条件に一致するレコードの数を数えるのに使用します。

### 基本構文

```sql
SELECT COUNT(カラム名) FROM テーブル名 [WHERE 条件];
```

または、すべての行を数える場合：

```sql
SELECT COUNT(*) FROM テーブル名 [WHERE 条件];
```

### 例1：テーブル内の全レコード数

例えば、学生（students）テーブルの全学生数を数えるには：

```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

実行結果：

| 学生総数 |
|---------|
| 100     |

### 例2：条件付きのカウント

WHERE句と組み合わせることで、条件に一致するレコードだけをカウントできます。例えば、「出席（present）」状態の出席レコードの数を数えるには：

```sql
SELECT COUNT(*) AS 出席数 FROM attendance WHERE status = 'present';
```

実行結果：

| 出席数 |
|-------|
| 42    |

### 例3：NULL以外の値をカウント

COUNT(カラム名)を使うと、そのカラムがNULLでない行だけがカウントされます。これは、COUNT(*)との大きな違いです。例えば、コメント（comment）が入力されている出席レコードの数を数えるには：

```sql
SELECT COUNT(comment) AS コメントあり FROM attendance;
```

実行結果：

| コメントあり |
|------------|
| 23         |

### 例4：DISTINCTを使った重複のないカウント

DISTINCTを使うと、重複を除外してカウントできます。例えば、何種類の評価タイプ（grade_type）があるかを数えるには：

```sql
SELECT COUNT(DISTINCT grade_type) AS 評価タイプ数 FROM grades;
```

実行結果：

| 評価タイプ数 |
|------------|
| 3          |

## SUM関数：合計を計算する

SUM関数は、数値カラムの合計を計算するのに使用します。

### 基本構文

```sql
SELECT SUM(数値カラム) FROM テーブル名 [WHERE 条件];
```

### 例1：単純な合計

例えば、全成績レコードの得点（score）の合計を計算するには：

```sql
SELECT SUM(score) AS 総得点 FROM grades;
```

実行結果：

| 総得点   |
|---------|
| 3542.5  |

### 例2：条件付きの合計

WHERE句と組み合わせることで、条件に一致するレコードだけの合計を計算できます。例えば、「中間テスト」の得点合計を計算するには：

```sql
SELECT SUM(score) AS 中間テスト合計点 
FROM grades 
WHERE grade_type = '中間テスト';
```

実行結果：

| 中間テスト合計点 |
|----------------|
| 1728.0         |

### 例3：計算式を使った合計

計算式と組み合わせることもできます。例えば、全成績の達成率（score/max_score）の合計を計算するには：

```sql
SELECT SUM(score/max_score) AS 達成率合計 FROM grades;
```

実行結果：

| 達成率合計 |
|-----------|
| 39.86     |

## AVG関数：平均を計算する

AVG関数は、数値カラムの平均値を計算するのに使用します。

### 基本構文

```sql
SELECT AVG(数値カラム) FROM テーブル名 [WHERE 条件];
```

### 例1：単純な平均

例えば、全成績レコードの得点（score）の平均を計算するには：

```sql
SELECT AVG(score) AS 平均点 FROM grades;
```

実行結果：

| 平均点  |
|--------|
| 82.38  |

### 例2：条件付きの平均

WHERE句と組み合わせることで、条件に一致するレコードだけの平均を計算できます。例えば、「実技試験」の平均点を計算するには：

```sql
SELECT AVG(score) AS 実技試験平均点 
FROM grades 
WHERE grade_type = '実技試験';
```

実行結果：

| 実技試験平均点 |
|--------------|
| 85.6         |

### 例3：達成率（%）の計算

計算式と組み合わせることで、例えば平均達成率（%）を計算できます：

```sql
SELECT AVG(score/max_score * 100) AS 平均達成率 FROM grades;
```

実行結果：

| 平均達成率 |
|-----------|
| 87.24     |

## MAX関数：最大値を取得する

MAX関数は、数値、文字列、日付などのカラムから最大値を取得するのに使用します。

### 基本構文

```sql
SELECT MAX(カラム名) FROM テーブル名 [WHERE 条件];
```

### 例1：数値の最大値

例えば、全成績レコードの中での最高点を取得するには：

```sql
SELECT MAX(score) AS 最高点 FROM grades;
```

実行結果：

| 最高点 |
|-------|
| 95.0  |

### 例2：文字列の最大値（辞書順で最後）

MAX関数は文字列にも使用でき、この場合は辞書順で「最後」の値を返します。例えば、学生名の辞書順で最後の値（最も「わ行」に近い名前）を取得するには：

```sql
SELECT MAX(student_name) AS 学生名最終 FROM students;
```

実行結果：

| 学生名最終 |
|----------|
| 吉川伽羅  |

### 例3：日付の最大値（最新の日付）

日付にMAX関数を使うと、最新（最も未来）の日付が取得できます。例えば、最も新しい提出日を取得するには：

```sql
SELECT MAX(submission_date) AS 最新提出日 FROM grades;
```

実行結果：

| 最新提出日   |
|------------|
| 2025-05-20 |

## MIN関数：最小値を取得する

MIN関数は、数値、文字列、日付などのカラムから最小値を取得するのに使用します。

### 基本構文

```sql
SELECT MIN(カラム名) FROM テーブル名 [WHERE 条件];
```

### 例1：数値の最小値

例えば、全成績レコードの中での最低点を取得するには：

```sql
SELECT MIN(score) AS 最低点 FROM grades;
```

実行結果：

| 最低点 |
|-------|
| 68.0  |

### 例2：文字列の最小値（辞書順で最初）

MIN関数は文字列にも使用でき、この場合は辞書順で「最初」の値を返します。例えば、学生名の辞書順で最初の値（最も「あ行」に近い名前）を取得するには：

```sql
SELECT MIN(student_name) AS 学生名最初 FROM students;
```

実行結果：

| 学生名最初 |
|----------|
| 相沢吉夫  |

### 例3：日付の最小値（最古の日付）

日付にMIN関数を使うと、最も古い日付が取得できます。例えば、最も古い提出日を取得するには：

```sql
SELECT MIN(submission_date) AS 最古提出日 FROM grades;
```

実行結果：

| 最古提出日   |
|------------|
| 2025-05-06 |

## 複数の集計関数の組み合わせ

複数の集計関数を一つのクエリで使用することもできます。

### 例：成績の統計情報

例えば、成績（grades）テーブルの統計情報を一度に取得するには：

```sql
SELECT 
    COUNT(*) AS レコード数,
    AVG(score) AS 平均点,
    SUM(score) AS 合計点,
    MAX(score) AS 最高点,
    MIN(score) AS 最低点
FROM grades;
```

実行結果：

| レコード数 | 平均点 | 合計点  | 最高点 | 最低点 |
|---------|--------|--------|-------|-------|
| 43      | 82.38  | 3542.5 | 95.0  | 68.0  |

## 集計関数とGROUP BY（次章の内容）

集計関数をより強力に使うためには、「GROUP BY」句と組み合わせます。これにより、データをグループ化して各グループごとに集計できます。GROUP BYについては次章で詳しく学びます。

例えば、講座（course_id）ごとの平均点を計算するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id;
```

実行結果：

| course_id | 平均点 |
|-----------|--------|
| 1         | 86.2   |
| 2         | 83.8   |
| 3         | 80.5   |
| ...       | ...    |

この例の詳細な説明は次章で行います。

## 練習問題

### 問題9-1
students（学生）テーブルから、学生の総数を取得するSQLを書いてください。

### 問題9-2
grades（成績）テーブルから、全成績の平均点（score）を取得するSQLを書いてください。

### 問題9-3
attendance（出席）テーブルから、出席状況（status）が「absent」のレコード数を取得するSQLを書いてください。

### 問題9-4
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」の成績の最高点と最低点を取得するSQLを書いてください。

### 問題9-5
course_schedule（授業カレンダー）テーブルから、最新（schedule_dateが最大）の授業スケジュールの日付を取得するSQLを書いてください。

### 問題9-6
grades（成績）テーブルから、成績の総数、平均点、合計点、最高点、最低点を一度に取得するSQLを書いてください。

## 解答

### 解答9-1
```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

### 解答9-2
```sql
SELECT AVG(score) AS 全成績平均点 FROM grades;
```

### 解答9-3
```sql
SELECT COUNT(*) AS 欠席数 FROM attendance WHERE status = 'absent';
```

### 解答9-4
```sql
SELECT 
    MAX(score) AS 中間テスト最高点,
    MIN(score) AS 中間テスト最低点
FROM grades 
WHERE grade_type = '中間テスト';
```

### 解答9-5
```sql
SELECT MAX(schedule_date) AS 最新授業日 FROM course_schedule;
```

### 解答9-6
```sql
SELECT 
    COUNT(*) AS 成績総数,
    AVG(score) AS 平均点,
    SUM(score) AS 合計点,
    MAX(score) AS 最高点,
    MIN(score) AS 最低点
FROM grades;
```

## まとめ

この章では、データの集計と分析に使用される主要な集計関数について学びました：

1. **COUNT**：レコード数をカウントする関数
2. **SUM**：数値の合計を計算する関数
3. **AVG**：数値の平均を計算する関数
4. **MAX**：最大値（数値、文字列、日付など）を取得する関数
5. **MIN**：最小値（数値、文字列、日付など）を取得する関数

これらの集計関数を使うことで、大量のデータから意味のある統計情報を簡単に抽出できます。ビジネスにおける意思決定や、データ分析において非常に重要な機能です。

次の章では、データをグループ化して集計を行うための「GROUP BY：データのグループ化」について学びます。



---

# 10. GROUP BY：データのグループ化

## はじめに

前章では、集計関数（COUNT、SUM、AVG、MAX、MIN）を使って全体的な集計や統計を計算する方法を学びました。しかし実際のデータ分析では、全体の集計だけでなく、特定のカテゴリや条件ごとに集計したい場合が多くあります。例えば：

- 「講座ごとの平均点は？」
- 「教師ごとの担当講座数は？」
- 「日付ごとの授業数は？」
- 「出席状況（出席/遅刻/欠席）の割合は？」

このような「グループごとの集計」を行うためのSQLコマンドが「GROUP BY」です。この章では、データをグループ化して集計する方法について学びます。

## GROUP BYの基本

GROUP BY句は、指定したカラムの値が同じレコードをグループ化し、それぞれのグループに対して集計関数を適用するために使います。

> **用語解説**：
> - **GROUP BY**：「〜でグループ化する」という意味のSQLコマンドで、同じ値を持つレコードをまとめてグループにします。
> - **グループ化**：データを特定の条件で分類し、それぞれの分類ごとに集計を行うこと。

### 基本構文

```sql
SELECT カラム名, 集計関数
FROM テーブル名
[WHERE 条件]
GROUP BY グループ化するカラム名;
```

重要なのは、SELECT句に含めるカラムは、GROUP BY句で指定したカラムか、集計関数（COUNT、SUM、AVG、MAX、MINなど）のいずれかでなければならないということです。

### 例1：単純なグループ化

例えば、成績（grades）テーブルから、評価タイプ（grade_type）ごとの成績レコード数を集計するには：

```sql
SELECT grade_type, COUNT(*) AS レコード数
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | レコード数 |
|-------------|-----------|
| 中間テスト   | 12        |
| レポート1    | 22        |
| 実技試験     | 9         |

### 例2：グループごとの平均

グループごとの平均を計算することも一般的です。例えば、各評価タイプごとの平均点を計算するには：

```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均点    |
|-------------|----------|
| 中間テスト   | 86.25    |
| レポート1    | 44.77    |
| 実技試験     | 85.61    |

## 複数のカラムによるグループ化

複数のカラムを指定してグループ化することもできます。この場合、指定したすべてのカラムの値の組み合わせがグループの単位になります。

### 例3：複数カラムでのグループ化

例えば、講座（course_id）と評価タイプ（grade_type）の組み合わせごとに成績の平均を計算するには：

```sql
SELECT course_id, grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY course_id, grade_type;
```

実行結果：

| course_id | grade_type  | 平均点    |
|-----------|-------------|----------|
| 1         | 中間テスト   | 87.33    |
| 1         | レポート1    | 45.39    |
| 2         | 実技試験     | 86.83    |
| ...       | ...         | ...      |

### グループ化の順序

GROUP BY句でカラムを指定する順序は、結果には影響しません。しかし、可読性のためにSELECT句と同じ順序で指定することが一般的です。

## WHERE句とGROUP BYの組み合わせ

WHERE句は、グループ化する前に行単位でレコードを絞り込むのに使います。

> **用語解説**：
> - **絞り込み順序**：WHERE句はGROUP BY句の前に評価され、条件に合うレコードだけがグループ化の対象になります。

### 例4：WHEREとGROUP BYの組み合わせ

例えば、得点（score）が80以上の成績だけを対象に、評価タイプごとの平均を計算するには：

```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
WHERE score >= 80
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均点    |
|-------------|----------|
| 中間テスト   | 88.92    |
| 実技試験     | 87.25    |

この例では、score >= 80の条件に一致するレコードだけがグループ化され、集計されています。レポート1はすべての点数が80未満なので、結果には表示されていません。

## GROUP BYとORDER BYの組み合わせ

GROUP BY句とORDER BY句を組み合わせることで、グループ化した結果を任意の順序で並べることができます。

### 例5：GROUP BYとORDER BYの組み合わせ

例えば、講座（course_id）ごとの平均点を計算し、平均点の高い順に並べるには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
ORDER BY 平均点 DESC;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| 2         | 83.79    |
| 5         | 82.33    |
| ...       | ...      |

## 集計関数の複数使用

一つのクエリで複数の集計関数を使用することもできます。

### 例6：複数の集計関数の使用

例えば、評価タイプごとの成績数、平均点、最高点、最低点を一度に取得するには：

```sql
SELECT grade_type, 
       COUNT(*) AS 成績数,
       AVG(score) AS 平均点,
       MAX(score) AS 最高点,
       MIN(score) AS 最低点
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 成績数 | 平均点    | 最高点 | 最低点 |
|-------------|-------|----------|-------|-------|
| 中間テスト   | 12    | 86.25    | 95.0  | 78.5  |
| レポート1    | 22    | 44.77    | 49.0  | 37.0  |
| 実技試験     | 9     | 85.61    | 88.0  | 79.5  |

## 計算式を含むグループ化

GROUP BY句で集計した結果に対して、さらに計算を加えることができます。

### 例7：計算式を含むグループ化

例えば、評価タイプごとに平均達成率（score/max_score）を計算するには：

```sql
SELECT grade_type, 
       AVG(score/max_score * 100) AS 平均達成率
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均達成率 |
|-------------|-----------|
| 中間テスト   | 86.25     |
| レポート1    | 89.54     |
| 実技試験     | 85.61     |

## GROUP BYとNULLの扱い

GROUP BY句でグループ化する際、NULL値も一つのグループとして扱われます。

### 例8：NULLを含むグループ化

例えば、出席（attendance）テーブルから、コメント（comment）の有無でグループ化し、それぞれの件数を数えるには：

```sql
SELECT 
    CASE 
        WHEN comment IS NULL THEN 'コメントなし'
        ELSE 'コメントあり'
    END AS コメント状態,
    COUNT(*) AS 件数
FROM attendance
GROUP BY 
    CASE 
        WHEN comment IS NULL THEN 'コメントなし'
        ELSE 'コメントあり'
    END;
```

実行結果：

| コメント状態   | 件数  |
|--------------|-------|
| コメントなし   | 20    |
| コメントあり   | 23    |

## HAVINGを使ったグループの絞り込み（次章の内容）

グループ化した後にさらに条件でグループを絞り込むには、「HAVING」句を使います。これについては次章で詳しく学びます。

例えば、5人以上の学生が受講している講座だけを取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 学生数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題10-1
courses（講座）テーブルから、教師ID（teacher_id）ごとに担当している講座の数を取得するSQLを書いてください。

### 問題10-2
attendance（出席）テーブルから、出席状況（status）ごとのレコード数を取得するSQLを書いてください。

### 問題10-3
grades（成績）テーブルから、学生ID（student_id）ごとの平均点を計算し、平均点の高い順に並べるSQLを書いてください。

### 問題10-4
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）ごとに予定されている授業の数を取得するSQLを書いてください。

### 問題10-5
grades（成績）テーブルから、講座ID（course_id）と評価タイプ（grade_type）の組み合わせごとの平均点を計算し、講座ID順、さらに評価タイプ順で並べるSQLを書いてください。

### 問題10-6
student_courses（受講）テーブルから、講座ID（course_id）ごとの受講者数を取得し、受講者数の多い順に並べるSQLを書いてください。

## 解答

### 解答10-1
```sql
SELECT teacher_id, COUNT(course_id) AS 担当講座数
FROM courses
GROUP BY teacher_id;
```

### 解答10-2
```sql
SELECT status, COUNT(*) AS レコード数
FROM attendance
GROUP BY status;
```

### 解答10-3
```sql
SELECT student_id, AVG(score) AS 平均点
FROM grades
GROUP BY student_id
ORDER BY 平均点 DESC;
```

### 解答10-4
```sql
SELECT classroom_id, COUNT(*) AS 授業数
FROM course_schedule
GROUP BY classroom_id;
```

### 解答10-5
```sql
SELECT course_id, grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY course_id, grade_type
ORDER BY course_id, grade_type;
```

### 解答10-6
```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
ORDER BY 受講者数 DESC;
```

## まとめ

この章では、データをグループ化して集計するためのGROUP BY句について学びました：

1. **GROUP BYの基本**：同じ値を持つレコードをグループ化する方法
2. **集計関数との組み合わせ**：グループごとの集計を行う方法
3. **複数カラムによるグループ化**：複数の条件でのグループ化
4. **WHERE句との組み合わせ**：グループ化前のレコード絞り込み
5. **ORDER BYとの組み合わせ**：グループ化結果の並び替え
6. **複数の集計関数の使用**：一度に複数の統計値を取得する方法
7. **計算式を含むグループ化**：より複雑な集計の実現
8. **NULLの扱い**：グループ化におけるNULL値の取り扱い

GROUP BY句を使うことで、データのさまざまな側面から分析が可能になり、意思決定のための有用な情報を抽出できるようになります。

次の章では、グループ化した結果をさらに条件で絞り込むための「HAVING：グループ化後の絞り込み」について学びます。



---

# 11. HAVING：グループ化後の絞り込み

## はじめに

前章では、GROUP BY句を使ってデータをグループ化し、各グループごとに集計を行う方法を学びました。しかし、すべてのグループの集計結果を表示するのではなく、特定の条件を満たすグループだけを表示したい場合があります。例えば：

- 「平均点が80点以上の講座だけを表示したい」
- 「5人以上の学生が登録している講座だけを取得したい」
- 「出席率が90%を超える学生だけをリストアップしたい」

このような「グループ化した結果をさらに絞り込む」ためのSQLコマンドが「HAVING」句です。この章では、グループ化した結果に条件を適用する方法について学びます。

## HAVINGの基本

HAVING句は、GROUP BY句でグループ化した後の結果に対して条件を適用し、条件を満たすグループだけを取得するために使います。

> **用語解説**：
> - **HAVING**：「〜を持っている」という意味のSQLコマンドで、グループ化した結果に対して条件を適用します。

### 基本構文

```sql
SELECT カラム名, 集計関数
FROM テーブル名
[WHERE 行レベルの条件]
GROUP BY グループ化するカラム名
HAVING グループレベルの条件;
```

### 例1：基本的なHAVINGの使用

例えば、受講者数が5人以上の講座だけを取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5;
```

実行結果：

| course_id | 受講者数 |
|-----------|---------|
| 1         | 12      |
| 2         | 8       |
| 4         | 7       |
| 5         | 7       |
| ...       | ...     |

この例では、まず講座ID（course_id）ごとに学生ID（student_id）の数を数え、その後でHAVING句を使って受講者数が5人以上のグループだけを抽出しています。

## WHEREとHAVINGの違い

WHERE句とHAVING句は似ていますが、適用されるタイミングと対象が異なります：

- **WHERE**：グループ化される前の個々の行（レコード）に対して条件を適用します。
- **HAVING**：グループ化された後のグループに対して条件を適用します。

> **用語解説**：
> - **行レベルのフィルタリング**：WHEREによる個々のレコードの絞り込み
> - **グループレベルのフィルタリング**：HAVINGによるグループの絞り込み

### 例2：WHEREとHAVINGの違い

以下の例で違いを確認しましょう：

```sql
-- WHERE（行レベル）：まず80点以上の成績だけを選び、それからグループ化
SELECT course_id, AVG(score) AS 平均点
FROM grades
WHERE score >= 80
GROUP BY course_id;

-- HAVING（グループレベル）：まずグループ化して平均点を計算し、それから平均点が80以上のグループを選ぶ
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
HAVING AVG(score) >= 80;
```

1つ目のクエリは、「80点以上の成績だけ」を対象に講座ごとの平均点を計算します。
2つ目のクエリは、「講座の平均点が80点以上」の講座だけを取得します。

**WHERE句の結果**：

| course_id | 平均点    |
|-----------|----------|
| 1         | 88.92    |
| 2         | 87.25    |
| ...       | ...      |

**HAVING句の結果**：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| 2         | 83.79    |
| 5         | 82.33    |
| ...       | ...      |

## HAVINGで使用できる条件

HAVING句では、集計関数（COUNT、SUM、AVG、MAX、MINなど）を使った条件や、GROUP BY句で指定したカラムに対する条件を指定できます。

### 例3：集計関数を使った条件

例えば、平均点が85点以上の講座を取得するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
HAVING AVG(score) >= 85;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| ...       | ...      |

### 例4：複数条件の指定

HAVING句も、WHERE句と同様に複数の条件を組み合わせることができます：

```sql
SELECT grade_type, COUNT(*) AS 件数, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type
HAVING COUNT(*) > 10 AND AVG(score) > 80;
```

実行結果：

| grade_type | 件数 | 平均点    |
|------------|-----|----------|
| 中間テスト  | 12  | 86.25    |
| ...        | ... | ...      |

## WHEREとHAVINGの組み合わせ

実際のクエリでは、WHERE句とHAVING句を組み合わせることが多いです。WHERE句でグループ化前の行を絞り込み、HAVING句でグループ化後の結果をさらに絞り込みます。

### 例5：WHEREとHAVINGの組み合わせ

例えば、「中間テストのみを対象として、平均点が85点以上の講座」を取得するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
WHERE grade_type = '中間テスト'
GROUP BY course_id
HAVING AVG(score) >= 85;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 87.33    |
| ...       | ...      |

## HAVINGとORDER BYの組み合わせ

HAVING句で絞り込んだ結果を並べ替えるには、ORDER BY句を追加します。

### 例6：HAVINGとORDER BYの組み合わせ

例えば、受講者数が5人以上の講座を、受講者数の多い順に並べて取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5
ORDER BY 受講者数 DESC;
```

実行結果：

| course_id | 受講者数 |
|-----------|---------|
| 1         | 12      |
| 20        | 11      |
| 9         | 10      |
| ...       | ...     |

## 実践的なHAVINGの使用例

### 例7：「平均達成率が90%を超える評価タイプ」の抽出

各評価タイプごとの平均達成率（score/max_score）を計算し、90%を超えるものだけを取得します：

```sql
SELECT grade_type, 
       AVG(score/max_score * 100) AS 平均達成率
FROM grades
GROUP BY grade_type
HAVING AVG(score/max_score * 100) > 90;
```

実行結果：

| grade_type | 平均達成率 |
|------------|----------|
| レポート1   | 93.54    |
| ...        | ...      |

### 例8：「特定の講座で成績データが存在する学生」の抽出

例えば、講座ID「1」の成績が2件以上ある学生を取得します：

```sql
SELECT student_id, COUNT(*) AS 成績件数
FROM grades
WHERE course_id = '1'
GROUP BY student_id
HAVING COUNT(*) >= 2;
```

実行結果：

| student_id | 成績件数 |
|------------|---------|
| 301        | 2       |
| 302        | 2       |
| ...        | ...     |

## HAVINGでの注意点

1. **集計関数の使用**: HAVINGで使用する条件には、通常、集計関数（COUNT、SUM、AVG、MAX、MINなど）が含まれます。単純なカラム比較だけならWHERE句を使用すべきです。

2. **パフォーマンスの考慮**: WHERE句はグループ化前に適用されるため、処理対象のレコード数を減らすことができます。可能な限り、グループ化前の条件はWHERE句で指定し、グループ化後の条件だけをHAVING句で指定するようにすると、効率的なクエリになります。

3. **グループレベルの条件**: HAVING句は、GROUP BY句で指定したカラムや集計関数の結果に対する条件でなければならないことを覚えておきましょう。

## 練習問題

### 問題11-1
student_courses（受講）テーブルから、受講者数が8人以上の講座ID（course_id）を取得するSQLを書いてください。

### 問題11-2
grades（成績）テーブルから、平均点（score）が85点以上の評価タイプ（grade_type）を取得するSQLを書いてください。

### 問題11-3
courses（講座）テーブルから、各教師（teacher_id）が担当する講座数を計算し、担当講座が3つ以上の教師だけを取得するSQLを書いてください。

### 問題11-4
grades（成績）テーブルから、講座ID（course_id）ごとの最高点（score）を計算し、最高点が90点以上の講座を、最高点の高い順に並べて取得するSQLを書いてください。

### 問題11-5
attendance（出席）テーブルから、欠席（status = 'absent'）の回数が2回以上ある学生ID（student_id）を取得するSQLを書いてください。

### 問題11-6
grades（成績）テーブルを使って、中間テスト（grade_type = '中間テスト'）のデータのみを対象に、平均点が85点以上で、かつ最低点が75点以上の講座ID（course_id）を取得するSQLを書いてください。

## 解答

### 解答11-1
```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 8;
```

### 解答11-2
```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type
HAVING AVG(score) >= 85;
```

### 解答11-3
```sql
SELECT teacher_id, COUNT(course_id) AS 担当講座数
FROM courses
GROUP BY teacher_id
HAVING COUNT(course_id) >= 3;
```

### 解答11-4
```sql
SELECT course_id, MAX(score) AS 最高点
FROM grades
GROUP BY course_id
HAVING MAX(score) >= 90
ORDER BY 最高点 DESC;
```

### 解答11-5
```sql
SELECT student_id, COUNT(*) AS 欠席回数
FROM attendance
WHERE status = 'absent'
GROUP BY student_id
HAVING COUNT(*) >= 2;
```

### 解答11-6
```sql
SELECT course_id, AVG(score) AS 平均点, MIN(score) AS 最低点
FROM grades
WHERE grade_type = '中間テスト'
GROUP BY course_id
HAVING AVG(score) >= 85 AND MIN(score) >= 75;
```

## まとめ

この章では、グループ化した結果に条件を適用するためのHAVING句について学びました：

1. **HAVINGの基本**：グループ化した結果に条件を適用する方法
2. **WHEREとHAVINGの違い**：
   - WHERE：グループ化前の行レベルのフィルタリング
   - HAVING：グループ化後のグループレベルのフィルタリング
3. **HAVING句での条件**：集計関数を使った条件設定
4. **複合条件**：ANDやORを使った複数条件の組み合わせ
5. **WHERE、HAVING、ORDER BYの組み合わせ**：複雑なデータ抽出の手法
6. **実践的な使用例**：実際の業務で使われるようなクエリパターン

HAVING句はデータ分析において非常に重要です。グループ化されたデータに対して「どのグループが重要か」「どのグループに注目すべきか」という条件を設定することで、より意味のある情報を抽出することができます。

次の章では、重複データを除外するための「DISTINCT：重複の除外」について学びます。



---

# 12. DISTINCT：重複の除外

## はじめに

データベースから情報を取得する際、同じ値が複数回出現することがよくあります。例えば、「どの講座がどの教室で行われているか」を調べると、同じ教室が複数回リストされるでしょう。しかし、時には重複を除いた一意の値のリストだけが必要な場合があります。例えば：

- 「学校にはどんな教室があるか」（重複なく知りたい）
- 「どの教師が授業を担当しているか」（重複なく知りたい）
- 「どのような評価タイプがあるか」（重複なく知りたい）

このような「重複を除外」するためのSQLキーワードが「DISTINCT」です。この章では、クエリ結果から重複するデータを除外する方法について学びます。

## DISTINCTの基本

DISTINCT句は、SELECT文の結果から重複する行を除外するために使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別される」という意味のSQLキーワードで、クエリ結果から重複する行を除外します。
> - **重複除外**：同じ値を持つレコードを1つだけにして、残りを除外すること。

### 基本構文

```sql
SELECT DISTINCT カラム名 FROM テーブル名 [WHERE 条件];
```

DISTINCTは、SELECT文の直後に配置され、すべての指定されたカラムの組み合わせに対して働きます。

### 例1：単一カラムでの重複除外

例えば、成績テーブル（grades）から、どのような評価タイプ（grade_type）があるかを重複なしで取得するには：

```sql
SELECT DISTINCT grade_type FROM grades;
```

実行結果：

| grade_type  |
|-------------|
| 中間テスト   |
| レポート1    |
| 実技試験     |

通常のSELECT文では、テーブル内の各行の評価タイプが表示されますが、DISTINCTを使うと、一意の評価タイプだけが表示されます。

### 例2：出席状況の種類の取得

出席（attendance）テーブルから、どのような出席状況（status）があるかを重複なしで取得するには：

```sql
SELECT DISTINCT status FROM attendance;
```

実行結果：

| status  |
|---------|
| present |
| late    |
| absent  |

## 複数カラムでのDISTINCT

DISTINCTは複数のカラムにも適用できます。この場合、指定したすべてのカラムの値の組み合わせが一意であるレコードだけが返されます。

### 基本構文

```sql
SELECT DISTINCT カラム名1, カラム名2, ... FROM テーブル名 [WHERE 条件];
```

### 例3：複数カラムでの重複除外

例えば、授業スケジュール（course_schedule）テーブルから、どの講座（course_id）がどの時限（period_id）に開講されているかを重複なしで取得するには：

```sql
SELECT DISTINCT course_id, period_id FROM course_schedule;
```

実行結果：

| course_id | period_id |
|-----------|-----------|
| 1         | 1         |
| 2         | 3         |
| 3         | 4         |
| 4         | 2         |
| ...       | ...       |

この結果は、course_idとperiod_idの組み合わせが一意のレコードのみを表示します。同じ講座が異なる時限に開講される場合や、異なる講座が同じ時限に開講される場合は、別々のレコードとして表示されます。

## COUNT関数との組み合わせ

DISTINCTはCOUNT関数と組み合わせることで、一意の値の数を数えることができます。

### 例4：一意の値の数を数える

例えば、学生（students）テーブルに何人の学生が登録されているかを数えるには：

```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

実行結果：

| 学生総数 |
|---------|
| 100     |

一方、受講（student_courses）テーブルに登録されている一意の学生数を数えるには：

```sql
SELECT COUNT(DISTINCT student_id) AS 受講学生数 FROM student_courses;
```

実行結果：

| 受講学生数 |
|-----------|
| 85        |

この2つの結果の差は、まだ1つも講座を受講していない学生が15人いることを意味します。

## DISTINCTとNULLの扱い

DISTINCTを使う場合、NULL値も1つの値として扱われます。複数のNULL値は1つのNULL値として集約されます。

### 例5：NULLを含むデータでのDISTINCT

例えば、出席（attendance）テーブルから、コメント（comment）の一意の値を取得するとします：

```sql
SELECT DISTINCT comment FROM attendance;
```

実行結果：

| comment       |
|---------------|
| NULL          |
| 15分遅刻      |
| 5分遅刻       |
| 事前連絡あり  |
| 体調不良      |
| ...           |

この結果には、NULL値も1つの行として含まれています。

## DISTINCTとORDER BYの組み合わせ

DISTINCTはORDER BY句と組み合わせて使うことができます。これにより、重複を除外した後で結果を並べ替えることができます。

### 例6：DISTINCTとORDER BYの組み合わせ

例えば、講座（courses）テーブルから、どの教師（teacher_id）が講座を担当しているかを重複なしで取得し、教師IDの順に並べるには：

```sql
SELECT DISTINCT teacher_id FROM courses ORDER BY teacher_id;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

## DISTINCTとWHEREの組み合わせ

DISTINCTはWHERE句と組み合わせて使うこともできます。これにより、特定の条件に合うレコードだけを対象に重複を除外できます。

### 例7：DISTINCTとWHEREの組み合わせ

例えば、2025年5月に授業がある教室（classroom_id）の一覧を重複なしで取得するには：

```sql
SELECT DISTINCT classroom_id
FROM course_schedule
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

実行結果：

| classroom_id |
|--------------|
| 101A         |
| 102B         |
| 201C         |
| 202D         |
| ...          |

## DISTINCTとGROUP BYの違い

DISTINCTとGROUP BYはどちらも「重複を除外する」という点では似ていますが、目的と使い方に違いがあります。

- **DISTINCT**：単純に重複する行を除外します。
- **GROUP BY**：グループごとに集計を行うために使います。集計関数（COUNT、SUM、AVG、MAX、MINなど）と一緒に使うことが一般的です。

### 例8：DISTINCTとGROUP BYの比較

例えば、講座（courses）テーブルから、どの教師（teacher_id）が講座を担当しているかを調べる場合：

DISTINCTを使う方法：
```sql
SELECT DISTINCT teacher_id FROM courses;
```

GROUP BYを使う方法：
```sql
SELECT teacher_id FROM courses GROUP BY teacher_id;
```

両方とも同じ結果を返しますが、目的が異なります。GROUP BYは集計を行うためのもので、例えば各教師が担当する講座数を数えたい場合は：

```sql
SELECT teacher_id, COUNT(*) AS 担当講座数
FROM courses
GROUP BY teacher_id;
```

このように、GROUP BYと集計関数を組み合わせて使います。

## パフォーマンスへの影響と注意点

1. **処理コスト**：DISTINCTはすべての行を調査して重複を除外するため、大量のデータがある場合は処理コストが高くなる可能性があります。

2. **代替手段の検討**：場合によっては、DISTINCTの代わりにGROUP BYを使ったり、EXISTS/NOT EXISTSを使ったりと、より効率的な方法があることがあります。

3. **部分一致には使えない**：DISTINCTは完全に一致するレコードのみを対象とします。部分的な一致や似ているレコードの除外には使えません。

## 練習問題

### 問題12-1
course_schedule（授業カレンダー）テーブルから、授業が行われる日付（schedule_date）のリストを重複なしで取得するSQLを書いてください。

### 問題12-2
grades（成績）テーブルから、何種類の評価タイプ（grade_type）があるかを数えるSQLを書いてください。

### 問題12-3
student_courses（受講）テーブルから、講座を受講している学生ID（student_id）を重複なしで取得し、IDの昇順に並べるSQLを書いてください。

### 問題12-4
course_schedule（授業カレンダー）テーブルから、どの教室（classroom_id）でどの時限（period_id）に授業が行われているかの組み合わせを重複なしで取得するSQLを書いてください。

### 問題12-5
attendance（出席）テーブルから、コメント（comment）が入力されている（NULLでない）一意のコメント内容を取得するSQLを書いてください。

### 問題12-6
grades（成績）テーブルから、どの学生（student_id）がどの講座（course_id）を受講したかの組み合わせを重複なしで取得し、学生ID、講座IDの順に並べるSQLを書いてください。

## 解答

### 解答12-1
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

### 解答12-2
```sql
SELECT COUNT(DISTINCT grade_type) AS 評価タイプ数 FROM grades;
```

### 解答12-3
```sql
SELECT DISTINCT student_id FROM student_courses ORDER BY student_id;
```

### 解答12-4
```sql
SELECT DISTINCT classroom_id, period_id FROM course_schedule;
```

### 解答12-5
```sql
SELECT DISTINCT comment FROM attendance WHERE comment IS NOT NULL;
```

### 解答12-6
```sql
SELECT DISTINCT student_id, course_id 
FROM grades 
ORDER BY student_id, course_id;
```

## まとめ

この章では、クエリ結果から重複を除外するためのDISTINCTキーワードについて学びました：

1. **DISTINCTの基本**：クエリ結果から重複する行を除外する方法
2. **単一カラムでの使用**：1つのカラムの重複を除外する方法
3. **複数カラムでの使用**：複数カラムの組み合わせの重複を除外する方法
4. **COUNT関数との組み合わせ**：一意の値の数を数える方法
5. **NULLの扱い**：DISTINCT使用時のNULL値の取り扱い
6. **ORDER BYとの組み合わせ**：重複除外後の並べ替え
7. **WHEREとの組み合わせ**：条件付きでの重複除外
8. **GROUP BYとの違い**：似た機能を持つGROUP BYとの使い分け
9. **パフォーマンスへの影響**：DISTINCTを使用する際の注意点

DISTINCTは、データベースから一意の値のリストを取得するための便利な機能です。特に、テーブル内の特定のカラムにどのような値が存在するかを調べたい場合や、重複のないマスターリストを作成したい場合に役立ちます。

次の章では、複数のテーブルを結合して情報を取得するための「JOIN基本：テーブル結合の概念」について学びます。



---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [1. SELECT基本：単一テーブルから特定カラムを取得する](#1-select基本単一テーブルから特定カラムを取得する)
2. [2. WHERE句：条件に合ったレコードを絞り込む](#2-where句条件に合ったレコードを絞り込む)
3. [3. 論理演算子：AND、OR、NOTを使った複合条件](#3-論理演算子andornotを使った複合条件)
4. [4. パターンマッチング：LIKE演算子と%、_ワイルドカード](#4-パターンマッチングlike演算子と_ワイルドカード)
5. [5. 範囲指定：BETWEEN、IN演算子](#5-範囲指定betweenin演算子)
6. [6. NULL値の処理：IS NULL、IS NOT NULL](#6-null値の処理is-nullis-not-null)
7. [7. ORDER BY：結果の並び替え](#7-order-by結果の並び替え)
8. [8. LIMIT句：結果件数の制限とページネーション](#8-limit句結果件数の制限とページネーション)

---


# 1. SELECT基本：単一テーブルから特定カラムを取得する

## はじめに

データベースからデータを取り出す作業は、料理人が大きな冷蔵庫から必要な材料だけを取り出すようなものです。SQLでは、この「取り出す」作業を「SELECT文」で行います。

SELECT文はSQLの中で最も基本的で、最もよく使われる命令です。この章では、単一のテーブル（データの表）から必要な情報だけを取り出す方法を学びます。

## 基本構文

SELECT文の最も基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名;
```

この文は「テーブル名というテーブルからカラム名という列のデータを取り出してください」という意味です。

> **用語解説**：
> - **SELECT**：「選択する」という意味のSQLコマンドで、データを取り出すときに使います。
> - **カラム**：テーブルの縦の列のことで、同じ種類のデータが並んでいます（例：名前のカラム、年齢のカラムなど）。
> - **FROM**：「〜から」という意味で、どのテーブルからデータを取るかを指定します。
> - **テーブル**：データベース内の表のことで、行と列で構成されています。

## 実践例：単一カラムの取得

学校データベースの中の「teachers」テーブル（教師テーブル）から、教師の名前だけを取得してみましょう。

```sql
SELECT teacher_name FROM teachers;
```

実行結果：

| teacher_name |
|--------------|
| 寺内鞍       |
| 田尻朋美     |
| 内村海凪     |
| 藤本理恵     |
| 黒木大介     |
| 星野涼子     |
| 深山誠一     |
| 吉岡由佳     |
| 山田太郎     |
| 佐藤花子     |
| ...          |

これは「teachers」テーブルの「teacher_name」という列（先生の名前）だけを取り出しています。

## 複数のカラムを取得する

料理に複数の材料が必要なように、データを取り出すときも複数の列が必要なことがよくあります。複数のカラムを取得するには、カラム名をカンマ（,）で区切って指定します。

```sql
SELECT カラム名1, カラム名2, カラム名3 FROM テーブル名;
```

例えば、教師の番号（ID）と名前を一緒に取得してみましょう：

```sql
SELECT teacher_id, teacher_name FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| 104        | 藤本理恵     |
| 105        | 黒木大介     |
| 106        | 星野涼子     |
| ...        | ...          |

## すべてのカラムを取得する

テーブルのすべての列を取得したい場合は、アスタリスク（*）を使います。これは「すべての列」を意味するワイルドカードです。

```sql
SELECT * FROM テーブル名;
```

例：
```sql
SELECT * FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| ...        | ...          |

> **注意**：`SELECT *`は便利ですが、実際の業務では必要なカラムだけを指定する方が良いとされています。これは、データ量が多いときに処理速度が遅くなるのを防ぐためです。

## カラムに別名をつける（AS句）

取得したカラムに分かりやすい名前（別名）をつけることができます。これは「AS」句を使います。

```sql
SELECT カラム名 AS 別名 FROM テーブル名;
```

> **用語解説**：
> - **AS**：「〜として」という意味で、カラムに別名をつけるときに使います。この別名は結果を表示するときだけ使われます。

例えば、教師IDを「番号」、教師名を「名前」として表示してみましょう：

```sql
SELECT teacher_id AS 番号, teacher_name AS 名前 FROM teachers;
```

実行結果：

| 番号  | 名前       |
|------|------------|
| 101  | 寺内鞍     |
| 102  | 田尻朋美   |
| 103  | 内村海凪   |
| ...  | ...        |

ASは省略することも可能です：

```sql
SELECT teacher_id 番号, teacher_name 名前 FROM teachers;
```

## 計算式を使う

SELECT文では、カラムの値を使った計算もできます。例えば、成績テーブルから点数と満点を取得して、達成率（パーセント）を計算してみましょう。

```sql
SELECT student_id, course_id, grade_type, 
       score, max_score,
       (score / max_score) * 100 AS 達成率
FROM grades;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 301        | 1         | 中間テスト   | 85.5  | 100.0     | 85.5     |
| 302        | 1         | 中間テスト   | 92.0  | 100.0     | 92.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

## 重複を除外する（DISTINCT）

同じ値が複数ある場合に、重複を除いて一意の値だけを表示するには「DISTINCT」キーワードを使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別された」という意味で、重複する値を除外して一意の値だけを取得します。

例えば、どの講座にどの教師が担当しているかを重複なしで確認してみましょう：

```sql
SELECT DISTINCT teacher_id FROM courses;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

これにより、courses（講座）テーブルで使われている教師IDが重複なく表示されます。

## 文字列の結合

文字列を結合するには、MySQLでは「CONCAT」関数を使います。例えば、教師のIDと名前を組み合わせて表示してみましょう：

```sql
SELECT CONCAT('教師ID:', teacher_id, ' 名前:', teacher_name) AS 教師情報
FROM teachers;
```

実行結果：

| 教師情報                  |
|--------------------------|
| 教師ID:101 名前:寺内鞍   |
| 教師ID:102 名前:田尻朋美 |
| ...                      |

> **用語解説**：
> - **CONCAT**：複数の文字列を一つにつなげる関数です。

## SELECT文と終了記号

SQLの文は通常、セミコロン（;）で終わります。これは「この命令はここで終わりです」という合図です。

複数のSQL文を一度に実行する場合は、それぞれの文の最後にセミコロンをつけます。

## 練習問題

### 問題1-1
students（学生）テーブルから、すべての学生の名前（student_name）を取得するSQLを書いてください。

### 問題1-2
classrooms（教室）テーブルから、教室ID（classroom_id）と教室名（classroom_name）を取得するSQLを書いてください。

### 問題1-3
courses（講座）テーブルから、すべての列（カラム）を取得するSQLを書いてください。

### 問題1-4
class_periods（授業時間）テーブルから、時限ID（period_id）、開始時間（start_time）、終了時間（end_time）を取得し、開始時間には「開始」、終了時間には「終了」という別名をつけるSQLを書いてください。

### 問題1-5
grades（成績）テーブルから、学生ID（student_id）、講座ID（course_id）、評価タイプ（grade_type）、得点（score）、満点（max_score）、そして得点を満点で割って100を掛けた値を「パーセント」という別名で取得するSQLを書いてください。

### 問題1-6
course_schedule（授業カレンダー）テーブルから、schedule_date（予定日）カラムだけを重複なしで取得するSQLを書いてください。

## 解答

### 解答1-1
```sql
SELECT student_name FROM students;
```

### 解答1-2
```sql
SELECT classroom_id, classroom_name FROM classrooms;
```

### 解答1-3
```sql
SELECT * FROM courses;
```

### 解答1-4
```sql
SELECT period_id, start_time AS 開始, end_time AS 終了 FROM class_periods;
```

### 解答1-5
```sql
SELECT student_id, course_id, grade_type, score, max_score,
       (score / max_score) * 100 AS パーセント
FROM grades;
```

### 解答1-6
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

## まとめ

この章では、SQLのSELECT文の基本を学びました：

1. 単一カラムの取得: `SELECT カラム名 FROM テーブル名;`
2. 複数カラムの取得: `SELECT カラム名1, カラム名2 FROM テーブル名;`
3. すべてのカラムの取得: `SELECT * FROM テーブル名;`
4. カラムに別名をつける: `SELECT カラム名 AS 別名 FROM テーブル名;`
5. 計算式を使う: `SELECT カラム名, (計算式) AS 別名 FROM テーブル名;`
6. 重複を除外する: `SELECT DISTINCT カラム名 FROM テーブル名;`
7. 文字列の結合: `SELECT CONCAT(文字列1, カラム名, 文字列2) FROM テーブル名;`

これらの基本操作を使いこなせるようになれば、データベースから必要な情報を効率よく取り出せるようになります。次の章では、WHERE句を使って条件に合ったデータだけを取り出す方法を学びます。



---

# 2. WHERE句：条件に合ったレコードを絞り込む

## はじめに

前章では、テーブルからデータを取得する基本的な方法を学びました。しかし実際の業務では、すべてのデータではなく、特定の条件に合ったデータだけを取得したいことがほとんどです。

例えば、「全生徒の情報」ではなく「特定の学科の生徒だけ」や「成績が80点以上の学生だけ」といった形で、データを絞り込みたい場合があります。

このような場合に使用するのが「WHERE句」です。WHERE句は、SELECTコマンドの後に追加して使い、条件に合致するレコード（行）だけを取得します。

## 基本構文

WHERE句の基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件式;
```

> **用語解説**：
> - **WHERE**：「〜の場所で」「〜の条件で」という意味のSQLコマンドで、条件に合うデータだけを抽出するために使います。
> - **条件式**：データが満たすべき条件を指定するための式です。例えば「age > 20」（年齢が20より大きい）などです。
> - **レコード**：テーブルの横の行のことで、1つのデータの集まりを表します。

## 基本的な比較演算子

WHERE句では、様々な比較演算子を使って条件を指定できます：

| 演算子 | 意味                   | 例                    |
|--------|------------------------|------------------------|
| =      | 等しい                 | age = 25               |
| <>     | 等しくない（≠と同じ）  | gender <> 'male'       |
| >      | より大きい             | score > 80             |
| <      | より小さい             | price < 1000           |
| >=     | 以上                   | height >= 170          |
| <=     | 以下                   | weight <= 70           |

## 実践例：基本的な条件での絞り込み

### 例1：等しい（=）
例えば、教師ID（teacher_id）が101の教師のみを取得するには：

```sql
SELECT * FROM teachers WHERE teacher_id = 101;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |

### 例2：より大きい（>）
成績（grades）テーブルから、90点を超える成績だけを取得するには：

```sql
SELECT * FROM grades WHERE score > 90;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例3：等しくない（<>）
講座IDが3ではない講座に関する成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id <> '3';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト  | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 301        | 2         | 実技試験    | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 文字列の比較

テキスト（文字列）を条件にする場合は、シングルクォーテーション（'）またはダブルクォーテーション（"）で囲みます。MySQLではどちらも使えますが、多くの場合シングルクォーテーションが推奨されます。

```sql
SELECT * FROM テーブル名 WHERE テキストカラム = 'テキスト値';
```

例えば、教師名（teacher_name）が「田尻朋美」の教師を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name = '田尻朋美';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |

## 日付の比較

日付の比較も同様にシングルクォーテーションで囲みます。日付の形式はデータベースの設定によって異なりますが、一般的にはISO形式（YYYY-MM-DD）が使われます。

```sql
SELECT * FROM テーブル名 WHERE 日付カラム = '日付';
```

例えば、2025年5月20日に提出された成績を検索するには：

```sql
SELECT * FROM grades WHERE submission_date = '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

また、日付同士の大小関係も比較できます：

```sql
SELECT * FROM grades WHERE submission_date < '2025-05-15';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | レポート1   | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1   | 48.0  | 50.0      | 2025-05-10      |
| 304        | 5         | ER図作成課題 | 27.5  | 30.0      | 2025-05-14      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 複数の条件を指定する（次章の内容）

WHERE句では、複数の条件を組み合わせることもできます。この詳細は次章「論理演算子：AND、OR、NOTを使った複合条件」で説明します。

例えば、講座IDが1で、かつ、得点が90以上の成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id = '1' AND score >= 90;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題2-1
students（学生）テーブルから、学生ID（student_id）が「310」の学生情報を取得するSQLを書いてください。

### 問題2-2
classrooms（教室）テーブルから、収容人数（capacity）が30人より多い教室の情報をすべて取得するSQLを書いてください。

### 問題2-3
courses（講座）テーブルから、教師ID（teacher_id）が「105」の講座情報を取得するSQLを書いてください。

### 問題2-4
course_schedule（授業カレンダー）テーブルから、「2025-05-15」の授業スケジュールをすべて取得するSQLを書いてください。

### 問題2-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」で、得点（score）が80点未満の成績を取得するSQLを書いてください。

### 問題2-6
teachers（教師）テーブルから、教師ID（teacher_id）が「101」ではない教師の名前を取得するSQLを書いてください。

## 解答

### 解答2-1
```sql
SELECT * FROM students WHERE student_id = 310;
```

### 解答2-2
```sql
SELECT * FROM classrooms WHERE capacity > 30;
```

### 解答2-3
```sql
SELECT * FROM courses WHERE teacher_id = 105;
```

### 解答2-4
```sql
SELECT * FROM course_schedule WHERE schedule_date = '2025-05-15';
```

### 解答2-5
```sql
SELECT * FROM grades WHERE grade_type = '中間テスト' AND score < 80;
```

### 解答2-6
```sql
SELECT teacher_name FROM teachers WHERE teacher_id <> 101;
```

## まとめ

この章では、WHERE句を使って条件に合ったレコードを取得する方法を学びました：

1. 基本的な比較演算子（=, <>, >, <, >=, <=）の使い方
2. 数値による条件絞り込み
3. 文字列（テキスト）による条件絞り込み
4. 日付による条件絞り込み

WHERE句は、大量のデータから必要な情報だけを取り出すための非常に重要な機能です。実際のデータベース操作では、この条件絞り込みを頻繁に使います。

次の章では、複数の条件を組み合わせるための「論理演算子（AND、OR、NOT）」について学びます。



---

# 3. 論理演算子：AND、OR、NOTを使った複合条件

## はじめに

前章では、WHERE句を使って単一の条件でデータを絞り込む方法を学びました。しかし実際の業務では、より複雑な条件でデータを絞り込む必要があることがよくあります。

例えば：
- 「成績が80点以上**かつ**出席率が90%以上の学生」
- 「数学**または**英語の成績が優秀な学生」
- 「課題を**まだ提出していない**学生」

このような複合条件を指定するために使うのが論理演算子です。主な論理演算子は次の3つです：

- **AND**：両方の条件を満たす（かつ）
- **OR**：いずれかの条件を満たす（または）
- **NOT**：条件を満たさない（〜ではない）

## AND演算子

AND演算子は、指定した**すべての条件を満たす**レコードだけを取得したいときに使います。

> **用語解説**：
> - **AND**：「かつ」「そして」という意味の論理演算子です。複数の条件をすべて満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 AND 条件2;
```

### 例：ANDを使った複合条件

例えば、中間テストで90点以上かつ満点が100点の成績レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

この例では、「score >= 90」と「max_score = 100」の両方の条件を満たすレコードだけが取得されます。

### 3つ以上の条件の組み合わせ

ANDを使って3つ以上の条件を組み合わせることもできます：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100 AND grade_type = '中間テスト';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## OR演算子

OR演算子は、指定した条件の**いずれか一つでも満たす**レコードを取得したいときに使います。

> **用語解説**：
> - **OR**：「または」「もしくは」という意味の論理演算子です。複数の条件のうち少なくとも1つを満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 OR 条件2;
```

### 例：ORを使った複合条件

例えば、教師IDが101または102の講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id = 101 OR teacher_id = 102;
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 2         | UNIX入門             | 102        |
| 3         | Cプログラミング演習    | 101        |
| 29        | コードリファクタリングとクリーンコード | 101 |
| 40        | ソフトウェアアーキテクチャパターン | 102 |
| ...       | ...                  | ...        |

この例では、「teacher_id = 101」または「teacher_id = 102」のいずれかの条件を満たすレコードが取得されます。

## NOT演算子

NOT演算子は、指定した条件を**満たさない**レコードを取得したいときに使います。

> **用語解説**：
> - **NOT**：「〜ではない」という意味の論理演算子です。条件を否定して、その条件を満たさないデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE NOT 条件;
```

### 例：NOTを使った否定条件

例えば、完了（completed）状態ではない授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
WHERE NOT status = 'completed';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 45          | 11        | 2025-05-20    | 5         | 401G         | 106        | scheduled |
| 46          | 12        | 2025-05-21    | 1         | 301E         | 107        | scheduled |
| 50          | 2         | 2025-05-23    | 3         | 101A         | 102        | cancelled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

この例では、statusが「completed」ではないレコード（scheduled状態やcancelled状態）が取得されます。

NOT演算子は、「〜ではない」という否定の条件を作るために使われます。例えば次の2つの書き方は同じ意味になります：

```sql
SELECT * FROM teachers WHERE NOT teacher_id = 101;
SELECT * FROM teachers WHERE teacher_id <> 101;
```

## 複合論理条件（AND、OR、NOTの組み合わせ）

AND、OR、NOTを組み合わせて、より複雑な条件を指定することもできます。

### 例：ANDとORの組み合わせ

例えば、「成績が90点以上で中間テストである」または「成績が45点以上でレポートである」レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE (score >= 90 AND grade_type = '中間テスト') 
   OR (score >= 45 AND grade_type = 'レポート1');
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 308        | 1         | レポート1  | 47.0  | 50.0      | 2025-05-09      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 優先順位と括弧の使用

論理演算子を組み合わせる場合、演算子の優先順位に注意が必要です。基本的に**ANDはORよりも優先順位が高い**です。つまり、ANDが先に処理されます。

例えば：
```sql
WHERE 条件1 OR 条件2 AND 条件3
```

これは次のように解釈されます：
```sql
WHERE 条件1 OR (条件2 AND 条件3)
```

意図した条件と異なる場合は、**括弧（）を使って明示的にグループ化**することが重要です：
```sql
WHERE (条件1 OR 条件2) AND 条件3
```

### 例：括弧を使った条件のグループ化

教師IDが101または102で、かつ、講座名に「プログラミング」という単語が含まれる講座を取得するには：

```sql
SELECT * FROM courses 
WHERE (teacher_id = 101 OR teacher_id = 102) 
  AND course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

この例では、括弧を使って「teacher_id = 101 OR teacher_id = 102」の部分をグループ化し、その条件と「course_name LIKE '%プログラミング%'」の条件をANDで結合しています。

## 練習問題

### 問題3-1
grades（成績）テーブルから、課題タイプ（grade_type）が「中間テスト」かつ点数（score）が85点以上のレコードを取得するSQLを書いてください。

### 問題3-2
classrooms（教室）テーブルから、収容人数（capacity）が40人以下または建物（building）が「1号館」の教室を取得するSQLを書いてください。

### 問題3-3
teachers（教師）テーブルから、教師ID（teacher_id）が101、102、103ではない教師の情報を取得するSQLを書いてください。

### 問題3-4
course_schedule（授業カレンダー）テーブルから、2025年5月20日の授業で、時限（period_id）が1か2で、かつ状態（status）が「scheduled」の授業を取得するSQLを書いてください。

### 問題3-5
students（学生）テーブルから、学生名（student_name）に「田」または「山」を含む学生を取得するSQLを書いてください。

### 問題3-6
grades（成績）テーブルから、提出日（submission_date）が2025年5月15日以降で、かつ（「中間テスト」で90点以上または「レポート1」で45点以上）の成績を取得するSQLを書いてください。

## 解答

### 解答3-1
```sql
SELECT * FROM grades 
WHERE grade_type = '中間テスト' AND score >= 85;
```

### 解答3-2
```sql
SELECT * FROM classrooms 
WHERE capacity <= 40 OR building = '1号館';
```

### 解答3-3
```sql
SELECT * FROM teachers 
WHERE NOT (teacher_id = 101 OR teacher_id = 102 OR teacher_id = 103);
```
または
```sql
SELECT * FROM teachers 
WHERE teacher_id <> 101 AND teacher_id <> 102 AND teacher_id <> 103;
```

### 解答3-4
```sql
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-20' 
  AND (period_id = 1 OR period_id = 2) 
  AND status = 'scheduled';
```

### 解答3-5
```sql
SELECT * FROM students 
WHERE student_name LIKE '%田%' OR student_name LIKE '%山%';
```

### 解答3-6
```sql
SELECT * FROM grades 
WHERE submission_date >= '2025-05-15' 
  AND ((grade_type = '中間テスト' AND score >= 90) 
       OR (grade_type = 'レポート1' AND score >= 45));
```

## まとめ

この章では、論理演算子（AND、OR、NOT）を使って複合条件を作る方法を学びました：

1. **AND**：すべての条件を満たすレコードを取得（条件1 AND 条件2）
2. **OR**：いずれかの条件を満たすレコードを取得（条件1 OR 条件2）
3. **NOT**：指定した条件を満たさないレコードを取得（NOT 条件）
4. **複合条件**：AND、OR、NOTを組み合わせたより複雑な条件
5. **括弧（）**：条件をグループ化して優先順位を明示的に指定

これらの論理演算子を使いこなすことで、より複雑で細かな条件でデータを絞り込むことができるようになります。実際のデータベース操作では、複数の条件を組み合わせることが頻繁にあるため、この章で学んだ内容は非常に重要です。

次の章では、テキストデータに対する検索を行う「パターンマッチング」について学びます。



---

# 4. パターンマッチング：LIKE演算子と%、_ワイルドカード

## はじめに

前章までは、データの完全一致や数値の比較といった条件での絞り込みを学びました。しかし実際の業務では、もっと柔軟な検索が必要なケースがあります。例えば：

- 「山」で始まる名前の学生を検索したい
- 「プログラミング」という単語を含む講座名を探したい
- 電話番号の一部だけ覚えているデータを探したい

このような「部分一致」や「パターン一致」の検索を行うためのSQLの機能が「パターンマッチング」です。この章では、パターンマッチングを行うための「LIKE演算子」と「ワイルドカード文字」について学びます。

## LIKE演算子の基本

LIKE演算子は、文字列のパターンマッチングを行うための演算子です。WHERE句と組み合わせて使用します。

> **用語解説**：
> - **LIKE**：「〜のような」という意味の演算子で、パターンに一致する文字列を検索します。
> - **パターンマッチング**：完全一致ではなく、一定のパターンに合致するデータを検索する方法です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 文字列カラム LIKE 'パターン';
```

パターンには、通常の文字に加えて、特別な意味を持つ「ワイルドカード文字」を使用できます。

## ワイルドカード文字

SQLでは主に2つのワイルドカード文字があります：

1. **%（パーセント）**：0文字以上の任意の文字列に一致します。
2. **_（アンダースコア）**：任意の1文字に一致します。

> **用語解説**：
> - **ワイルドカード**：任意の文字や文字列に一致する特殊な文字記号です。トランプのジョーカーのように、様々な値に代用できます。

## LIKE演算子の使い方：実践例

### 例1：%（パーセント）を使ったパターンマッチング

#### 「〜で始まる」パターン：前方一致

例えば、「山」で始まる学生名を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '山%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 山本裕子     |
| 325        | 山田翔太     |
| ...        | ...          |

ここでの「山%」は「山で始まり、その後に0文字以上の任意の文字が続く」という意味です。

#### 「〜で終わる」パターン：後方一致

例えば、「子」で終わる教師名を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name LIKE '%子';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| 106        | 星野涼子     |
| 108        | 吉岡由佳     |
| 110        | 佐藤花子     |
| ...        | ...          |

#### 「〜を含む」パターン：部分一致

例えば、「プログラミング」という単語を含む講座名を検索するには：

```sql
SELECT * FROM courses WHERE course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| 14        | IoTデバイスプログラミング実践 | 110 |
| ...       | ...                  | ...        |

### 例2：_（アンダースコア）を使ったパターンマッチング

アンダースコアは任意の1文字に一致します。例えば、教室IDが「10_A」パターン（最初の2文字が「10」、3文字目が任意の1文字、最後が「A」）の教室を検索するには：

```sql
SELECT * FROM classrooms WHERE classroom_id LIKE '10_A';
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| ...          | ...            | ...      | ...      | ...        |

### 例3：%と_の組み合わせ

ワイルドカード文字は組み合わせて使うこともできます。例えば、「2文字目が田」の学生を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '_田%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 384        | 櫻井翼       |
| ...        | ...          |

## NOT LIKEを使った否定形のパターンマッチング

特定のパターンに一致しないレコードを検索したい場合は、「NOT LIKE」を使います。

> **用語解説**：
> - **NOT LIKE**：「〜のパターンに一致しない」という意味で、指定したパターンに一致しないデータを検索します。

例えば、講座名に「入門」を含まない講座を検索するには：

```sql
SELECT * FROM courses WHERE course_name NOT LIKE '%入門%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

## エスケープ文字の使用

もし検索したいパターンに「%」や「_」自体が含まれている場合は、それらを特別な文字としてではなく、通常の文字として扱うために「エスケープ文字」を使います。

> **用語解説**：
> - **エスケープ文字**：特別な意味を持つ文字を通常の文字として扱うための印です。

MySQLでは、バックスラッシュ（\）をエスケープ文字として使用できます。例えば、「50%」という値そのものを検索するには：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50\%';
```

または、ESCAPE句を使って明示的にエスケープ文字を指定することもできます：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50!%' ESCAPE '!';
```

この例では「!」をエスケープ文字として指定しています。

## 大文字と小文字の区別

MySQLのデフォルト設定では、LIKE演算子は大文字と小文字を区別しません（大文字小文字を同じものとして扱います）。

例えば、次の2つのクエリは同じ結果を返します：

```sql
SELECT * FROM courses WHERE course_name LIKE '%web%';
SELECT * FROM courses WHERE course_name LIKE '%Web%';
```

もし大文字と小文字を区別した検索が必要な場合は、「BINARY」キーワードを使用します：

```sql
SELECT * FROM courses WHERE course_name LIKE BINARY '%Web%';
```

この場合、「Web」は「web」とは一致しません。

## 複合条件との組み合わせ

LIKE演算子は、これまで学んだAND、OR、NOTなどの論理演算子と組み合わせて使うこともできます。

例えば、「田」で始まる名前で、かつ教師IDが102から105の間の教師を検索するには：

```sql
SELECT * FROM teachers 
WHERE teacher_name LIKE '田%' 
  AND teacher_id BETWEEN 102 AND 105;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| ...        | ...          |

## 練習問題

### 問題4-1
students（学生）テーブルから、学生名（student_name）が「佐藤」で始まる学生の情報をすべて取得するSQLを書いてください。

### 問題4-2
courses（講座）テーブルから、講座名（course_name）に「データ」という単語を含む講座の情報を取得するSQLを書いてください。

### 問題4-3
classrooms（教室）テーブルから、教室名（classroom_name）が「コンピュータ実習室」で終わる教室の情報を取得するSQLを書いてください。

### 問題4-4
teachers（教師）テーブルから、教師名（teacher_name）の2文字目が「木」である教師の情報を取得するSQLを書いてください。

### 問題4-5
courses（講座）テーブルから、講座名（course_name）に「入門」または「基礎」を含む講座を取得するSQLを書いてください。

### 問題4-6
students（学生）テーブルから、学生名（student_name）が「山」で始まり、かつ「子」で終わらない学生を取得するSQLを書いてください。

## 解答

### 解答4-1
```sql
SELECT * FROM students WHERE student_name LIKE '佐藤%';
```

### 解答4-2
```sql
SELECT * FROM courses WHERE course_name LIKE '%データ%';
```

### 解答4-3
```sql
SELECT * FROM classrooms WHERE classroom_name LIKE '%コンピュータ実習室';
```

### 解答4-4
```sql
SELECT * FROM teachers WHERE teacher_name LIKE '_木%';
```

### 解答4-5
```sql
SELECT * FROM courses 
WHERE course_name LIKE '%入門%' OR course_name LIKE '%基礎%';
```

### 解答4-6
```sql
SELECT * FROM students 
WHERE student_name LIKE '山%' AND student_name NOT LIKE '%子';
```

## まとめ

この章では、パターンマッチングを行うためのLIKE演算子と、その中で使用するワイルドカード文字（%と_）について学びました：

1. **LIKE演算子**：文字列パターンに一致するデータを検索するための演算子
2. **%（パーセント）**：0文字以上の任意の文字列に一致するワイルドカード
3. **_（アンダースコア）**：任意の1文字に一致するワイルドカード
4. **前方一致**：「パターン%」で「パターンで始まる」文字列に一致
5. **後方一致**：「%パターン」で「パターンで終わる」文字列に一致
6. **部分一致**：「%パターン%」で「パターンを含む」文字列に一致
7. **NOT LIKE**：指定したパターンに一致しないデータを検索
8. **エスケープ文字**：特殊文字（%や_）を通常の文字として扱うための方法
9. **複合条件との組み合わせ**：AND、ORなどと組み合わせたより複雑な条件

パターンマッチングは、特にテキストデータを扱う際に非常に便利な機能です。部分的な情報しか持っていない場合や、特定のパターンを持つデータを探す場合に活用できます。

次の章では、範囲指定のための「BETWEEN演算子」と「IN演算子」について学びます。



---

# 5. 範囲指定：BETWEEN、IN演算子

## はじめに

これまでの章では、等号（=）や不等号（>、<）を使って条件を指定する方法や、LIKE演算子を使ったパターンマッチングを学びました。この章では、値の範囲を指定する「BETWEEN演算子」と、複数の値を一度に指定できる「IN演算子」について学びます。

これらの演算子を使うと、次のような検索がより簡単になります：
- 「80点から90点の間の成績」
- 「2025年4月から6月の間のスケジュール」
- 「特定の教師IDリストに該当する講座」

## BETWEEN演算子：範囲を指定する

BETWEEN演算子は、ある値が指定した範囲内にあるかどうかを調べるために使います。

> **用語解説**：
> - **BETWEEN**：「〜の間に」という意味の演算子で、ある値が指定した最小値と最大値の間（両端の値を含む）にあるかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 BETWEEN 最小値 AND 最大値;
```

この構文は次の条件と同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 >= 最小値 AND カラム名 <= 最大値;
```

### 例1：数値範囲の指定

例えば、成績（grades）テーブルから、80点から90点の間の成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 308        | 6         | 小テスト1  | 89.0  | 100.0     | 2025-05-15      |
| ...        | ...       | ...        | ...   | ...       | ...             |

### 例2：日付範囲の指定

日付にもBETWEEN演算子が使えます。例えば、2025年5月10日から2025年5月20日までに提出された成績を取得するには：

```sql
SELECT * FROM grades 
WHERE submission_date BETWEEN '2025-05-10' AND '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | レポート1  | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## NOT BETWEEN：範囲外を指定する

NOT BETWEENを使うと、指定した範囲の外にある値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT BETWEEN 最小値 AND 最大値;
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 < 最小値 OR カラム名 > 最大値;
```

### 例：範囲外の値を取得

例えば、80点未満または90点より高い成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score NOT BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## IN演算子：複数の値を指定する

IN演算子は、ある値が指定した複数の値のリストのいずれかに一致するかどうかを調べるために使います。

> **用語解説**：
> - **IN**：「〜の中に含まれる」という意味の演算子で、ある値が指定したリストの中に含まれているかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (値1, 値2, 値3, ...);
```

この構文は次のOR条件の組み合わせと同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 = 値1 OR カラム名 = 値2 OR カラム名 = 値3 OR ...;
```

### 例1：数値リストの指定

例えば、教師ID（teacher_id）が101、103、105のいずれかである講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (101, 103, 105);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| 5         | データベース設計と実装  | 105        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

### 例2：文字列リストの指定

文字列のリストにも適用できます。例えば、特定の教室ID（classroom_id）のみの教室情報を取得するには：

```sql
SELECT * FROM classrooms 
WHERE classroom_id IN ('101A', '202D', '301E');
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| 202D         | 2号館コンピュータ実習室D | 25     | 2号館     | パソコン25台、プロジェクター、3Dプリンター |
| 301E         | 3号館講義室E      | 80       | 3号館     | プロジェクター、マイク設備、録画設備 |

## NOT IN：リストに含まれない値を指定する

NOT IN演算子を使うと、指定したリストに含まれない値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT IN (値1, 値2, 値3, ...);
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 <> 値1 AND カラム名 <> 値2 AND カラム名 <> 値3 AND ...;
```

### 例：リストに含まれない値を取得

例えば、教師IDが101、102、103以外の教師が担当する講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id NOT IN (101, 102, 103);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 4         | Webアプリケーション開発 | 104        |
| 5         | データベース設計と実装  | 105        |
| 6         | ネットワークセキュリティ | 107        |
| ...       | ...                  | ...        |

## IN演算子でのサブクエリの利用（基本）

IN演算子の括弧内には、直接値を書く代わりに、サブクエリ（別のSELECT文）を指定することもできます。これにより、動的に値のリストを生成できます。

> **用語解説**：
> - **サブクエリ**：SQL文の中に含まれる別のSQL文のことで、外側のSQL文（メインクエリ）に値や条件を提供します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (SELECT カラム名 FROM 別テーブル WHERE 条件);
```

### 例：サブクエリを使ったIN条件

例えば、教師名（teacher_name）に「田」を含む教師が担当している講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (
    SELECT teacher_id FROM teachers 
    WHERE teacher_name LIKE '%田%'
);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 2         | UNIX入門             | 102        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

この例では、まず「teachers」テーブルから名前に「田」を含む教師のIDを取得し、それらのIDを持つ講座を「courses」テーブルから取得しています。

## BETWEEN演算子とIN演算子の組み合わせ

BETWEEN演算子とIN演算子は、論理演算子（AND、OR）と組み合わせて、さらに複雑な条件を作ることができます。

### 例：BETWEENとINの組み合わせ

例えば、「教師IDが101、103、105のいずれかで、かつ、2025年5月15日から2025年6月15日の間に実施される授業」を取得するには：

```sql
SELECT * FROM course_schedule 
WHERE teacher_id IN (101, 103, 105) 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-06-15';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 38          | 1         | 2025-05-20    | 1         | 102B         | 101        | scheduled |
| 42          | 10        | 2025-05-23    | 3         | 201C         | 103        | scheduled |
| 45          | 5         | 2025-05-28    | 2         | 402H         | 105        | scheduled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

## 練習問題

### 問題5-1
grades（成績）テーブルから、得点（score）が85点から95点の間にある成績を取得するSQLを書いてください。

### 問題5-2
course_schedule（授業カレンダー）テーブルから、2025年5月1日から2025年5月31日までの授業スケジュールを取得するSQLを書いてください。

### 問題5-3
courses（講座）テーブルから、教師ID（teacher_id）が104、106、108のいずれかである講座の情報を取得するSQLを書いてください。

### 問題5-4
classrooms（教室）テーブルから、教室ID（classroom_id）が「101A」、「201C」、「301E」、「401G」以外の教室情報を取得するSQLを書いてください。

### 問題5-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」または「実技試験」で、かつ得点（score）が80点から90点の間にない成績を取得するSQLを書いてください。

### 問題5-6
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）が「101A」、「202D」のいずれかで、かつ2025年5月15日から2025年5月30日の間に実施される授業スケジュールを取得するSQLを書いてください。

## 解答

### 解答5-1
```sql
SELECT * FROM grades 
WHERE score BETWEEN 85 AND 95;
```

### 解答5-2
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

### 解答5-3
```sql
SELECT * FROM courses 
WHERE teacher_id IN (104, 106, 108);
```

### 解答5-4
```sql
SELECT * FROM classrooms 
WHERE classroom_id NOT IN ('101A', '201C', '301E', '401G');
```

### 解答5-5
```sql
SELECT * FROM grades 
WHERE grade_type IN ('中間テスト', '実技試験') 
  AND score NOT BETWEEN 80 AND 90;
```

### 解答5-6
```sql
SELECT * FROM course_schedule 
WHERE classroom_id IN ('101A', '202D') 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-05-30';
```

## まとめ

この章では、範囲指定のための「BETWEEN演算子」と複数値指定のための「IN演算子」について学びました：

1. **BETWEEN演算子**：値が指定した範囲内（両端を含む）にあるかどうかをチェック
2. **NOT BETWEEN**：値が指定した範囲外にあるかどうかをチェック
3. **IN演算子**：値が指定したリストのいずれかに一致するかどうかをチェック
4. **NOT IN**：値が指定したリストのいずれにも一致しないかどうかをチェック
5. **サブクエリとIN**：動的に生成された値のリストを使用する方法
6. **複合条件**：BETWEEN、IN、論理演算子を組み合わせたより複雑な条件

これらの演算子を使うことで、複数の条件を指定する場合に、SQLをより簡潔に書くことができます。特に、多くの値を指定する場合や範囲条件を指定する場合に便利です。

次の章では、「NULL値の処理：IS NULL、IS NOT NULL」について学びます。



---

# 6. NULL値の処理：IS NULL、IS NOT NULL

## はじめに

データベースの世界では、データがない状態を表すために「NULL」という特別な値が使われます。NULLは「空」や「0」や「空白文字」とは異なる、「値が存在しない」または「不明」であることを表す特殊な概念です。

例えば、学校データベースでは次のようなシナリオがあります：
- まだ成績が付けられていない（NULL）
- コメントが入力されていない（NULL）
- 授業がキャンセルされたため教室が割り当てられていない（NULL）

この章では、NULL値を正しく処理するための「IS NULL」と「IS NOT NULL」演算子について学びます。

## NULLとは何か？

NULL値には、いくつかの特徴があります：

1. **値がない**：NULLは値がないことを表します。0でも空文字列（''）でもなく、値そのものが存在しないことを示します。
2. **不明**：データが不明であることを表す場合もあります。
3. **未設定**：まだ値が設定されていないことを表す場合もあります。
4. **比較できない**：NULLは通常の比較演算子（=, <, >など）で比較できません。

> **用語解説**：
> - **NULL**：データベースにおいて「値がない」または「不明」を表す特殊な値です。0や空文字とは異なります。

## NULL値と通常の比較演算子

通常の比較演算子（=, <>, >, <, >=, <=）では、NULL値を正しく検出できません。例えば：

```sql
-- この条件はNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 = NULL;

-- この条件もNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 <> NULL;
```

これは、NULL値との等価比較は「不明」と評価されるためです。つまり、NULL = NULLでさえFALSEではなく「不明」になります。

## IS NULL演算子

NULL値を持つレコードを検索するには、「IS NULL」演算子を使います。

> **用語解説**：
> - **IS NULL**：カラムの値がNULLかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NULL;
```

### 例：IS NULLの使用

例えば、コメントが入力されていない（NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

実行結果：

| schedule_id | student_id | status  | comment |
|-------------|------------|---------|---------|
| 1           | 301        | present | NULL    |
| 1           | 306        | present | NULL    |
| 1           | 307        | present | NULL    |
| ...         | ...        | ...     | NULL    |

## IS NOT NULL演算子

逆に、NULL値を持たないレコード（つまり、何らかの値を持つレコード）を検索するには、「IS NOT NULL」演算子を使います。

> **用語解説**：
> - **IS NOT NULL**：カラムの値がNULLでないかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NOT NULL;
```

### 例：IS NOT NULLの使用

例えば、コメントが入力されている（NOT NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 302        | late   | 15分遅刻      |
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |

## NULL値の論理的な扱い

NULL値は論理演算（AND、OR、NOT）でも特殊な扱いを受けます。

- **NULL AND TRUE** → NULL（不明）
- **NULL AND FALSE** → FALSE
- **NULL OR TRUE** → TRUE
- **NULL OR FALSE** → NULL（不明）
- **NOT NULL** → NULL（不明）

この特殊な振る舞いが、バグや誤った結果の原因になることがあります。

## NULL値と結合条件

テーブル結合（JOINなど、後の章で学習）の際も、NULL値は特殊な扱いを受けます。NULL値同士は「等しい」とは判定されないため、通常の結合条件ではNULL値を持つレコードは結合されません。

## IS NULLとIS NOT NULLを使った複合条件

IS NULLとIS NOT NULLも、他の条件と組み合わせて使用できます。

### 例：複合条件でのIS NULLの使用

例えば、「出席状態が "absent"（欠席）で、コメントがNULLでない（理由が入力されている）レコード」を検索するには：

```sql
SELECT * FROM attendance 
WHERE status = 'absent' AND comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |

## NVL/IFNULL/COALESCE関数：NULL値の置換

NULL値を別の値に置き換えるための関数が用意されています。データベースによって関数名が異なることがありますが、機能は似ています：

- MySQL/MariaDB: **IFNULL(expr, replace_value)**
- Oracle: **NVL(expr, replace_value)**
- SQL Server: **ISNULL(expr, replace_value)**
- 標準SQL: **COALESCE(expr1, expr2, ..., exprN)** - 最初のNULLでない式を返します

### 例：IFNULL関数の使用（MySQL）

例えば、コメントがNULLの場合は「特記事項なし」と表示するには：

```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '特記事項なし') AS comment
FROM attendance;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | 特記事項なし  |
| 1           | 302        | late    | 15分遅刻      |
| 1           | 303        | absent  | 事前連絡あり  |
| ...         | ...        | ...     | ...           |

## NULLを使う際の注意点

1. **除外の罠**：`WHERE カラム名 <> 値` だけでは、NULL値を持つレコードは含まれません。すべてのレコードを対象にするには：
   ```sql
   WHERE カラム名 <> 値 OR カラム名 IS NULL
   ```

2. **集計関数**：COUNT(*)はすべての行を数えますが、COUNT(カラム名)はそのカラムがNULLでない行だけを数えます。

3. **インデックス**：多くのデータベースでは、NULL値にもインデックスを適用できますが、データベースによって動作が異なる場合があります。

4. **一意性制約**：一般的に、UNIQUE制約ではNULL値は重複としてカウントされません（複数のNULL値が許可されます）。

## 練習問題

### 問題6-1
attendance（出席）テーブルから、コメント（comment）がNULLの出席レコードをすべて取得するSQLを書いてください。

### 問題6-2
course_schedule（授業カレンダー）テーブルから、状態（status）が「cancelled」で、かつ教室ID（classroom_id）がNULLでないレコードを取得するSQLを書いてください。

### 問題6-3
grades（成績）テーブルから、提出日（submission_date）がNULLの成績レコードを取得するSQLを書いてください。

### 問題6-4
attendance（出席）テーブルから、出席状態（status）が「present」か「late」で、かつコメント（comment）がNULLのレコードを取得するSQLを書いてください。

### 問題6-5
以下のSQLで教師（teachers）テーブルから「佐藤」という名前を持つ教師を検索する場合、NULL値を持つレコードも含めるにはどう修正すべきですか？
```sql
SELECT * FROM teachers WHERE teacher_name <> '佐藤花子';
```

### 問題6-6
attendance（出席）テーブルのすべてのレコードを取得し、コメント（comment）がNULLの場合は「記録なし」と表示するSQLを書いてください。

## 解答

### 解答6-1
```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

### 解答6-2
```sql
SELECT * FROM course_schedule 
WHERE status = 'cancelled' AND classroom_id IS NOT NULL;
```

### 解答6-3
```sql
SELECT * FROM grades WHERE submission_date IS NULL;
```

### 解答6-4
```sql
SELECT * FROM attendance 
WHERE (status = 'present' OR status = 'late') AND comment IS NULL;
```
または
```sql
SELECT * FROM attendance 
WHERE status IN ('present', 'late') AND comment IS NULL;
```

### 解答6-5
```sql
SELECT * FROM teachers 
WHERE teacher_name <> '佐藤花子' OR teacher_name IS NULL;
```

### 解答6-6
```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '記録なし') AS comment
FROM attendance;
```

## まとめ

この章では、データベースにおけるNULL値の概念と、NULL値を扱うための演算子や関数について学びました：

1. **NULL値の概念**：値がない、不明、未設定を表す特殊な値
2. **IS NULL演算子**：NULL値を持つレコードを検索する方法
3. **IS NOT NULL演算子**：NULL値を持たないレコードを検索する方法
4. **NULL値の論理的扱い**：論理演算（AND、OR、NOT）におけるNULLの振る舞い
5. **複合条件**：IS NULL/IS NOT NULLと他の条件の組み合わせ
6. **NULL値の置換**：IFNULL/NVL/COALESCE関数の使用方法
7. **注意点**：NULL値を扱う際の一般的な落とし穴

NULL値の正確な理解と適切な処理は、SQLプログラミングの重要な部分です。不適切なNULL処理は、予期しない結果やバグの原因になります。

次の章では、クエリ結果の並び替えを行うための「ORDER BY：結果の並び替え」について学びます。



---

# 7. ORDER BY：結果の並び替え

## はじめに

これまでの章では、データベースから条件に合ったレコードを取得する方法を学んできました。しかし実際の業務では、取得したデータを見やすく整理する必要があります。例えば：

- 成績を高い順に表示したい
- 学生を名前の五十音順に並べたい
- 日付の新しい順にスケジュールを確認したい

このようなデータの「並び替え」を行うためのSQLコマンドが「ORDER BY」です。この章では、クエリ結果を特定の順序で並べる方法を学びます。

## ORDER BYの基本

ORDER BY句は、SELECT文の結果を指定したカラムの値に基づいて並び替えるために使います。

> **用語解説**：
> - **ORDER BY**：「〜の順に並べる」という意味のSQLコマンドで、クエリ結果の並び順を指定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] ORDER BY 並び替えカラム;
```

ORDER BY句は通常、SELECT文の最後に記述します。

### 例1：単一カラムでの並び替え

例えば、学生（students）テーブルから、学生名（student_name）の五十音順（辞書順）でデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_name;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 309        | 相沢吉夫      |
| 303        | 柴崎春花      |
| 306        | 河田咲奈      |
| 305        | 河口菜恵子    |
| ...        | ...          |

### デフォルトの並び順

ORDER BYを使わない場合、結果の順序は保証されません。多くの場合、データがデータベースに保存された順序で返されますが、これは信頼できるものではありません。

## 昇順と降順の指定

ORDER BY句では、並び順を「昇順」か「降順」のどちらかで指定できます。

> **用語解説**：
> - **昇順（ASC）**：小さい値から大きい値へ（A→Z、1→9）の順に並べます。
> - **降順（DESC）**：大きい値から小さい値へ（Z→A、9→1）の順に並べます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 ORDER BY 並び替えカラム [ASC|DESC];
```

ASC（昇順）がデフォルトのため、省略可能です。

### 例2：降順での並び替え

例えば、成績（grades）テーブルから、得点（score）の高い順（降順）に成績を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 複数カラムでの並び替え

複数のカラムを使って並び替えることもできます。最初に指定したカラムで並び替え、値が同じレコードがある場合は次のカラムで並び替えます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 
ORDER BY 並び替えカラム1 [ASC|DESC], 並び替えカラム2 [ASC|DESC], ...;
```

### 例3：複数カラムでの並び替え

例えば、成績（grades）テーブルから、課題タイプ（grade_type）の五十音順に並べ、同じ課題タイプ内では得点（score）の高い順に成績を取得するには：

```sql
SELECT * FROM grades 
ORDER BY grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| 321        | 2         | 実技試験     | 85.5  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト   | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| 302        | 1         | レポート1    | 48.0  | 50.0      | 2025-05-10      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例4：昇順と降順の混合

各カラムごとに並び順を指定することもできます。例えば、講座ID（course_id）の昇順、評価タイプ（grade_type）の昇順、得点（score）の降順で並べるには：

```sql
SELECT * FROM grades 
ORDER BY course_id ASC, grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## NULLの扱い

ORDER BYでNULL値を並び替える場合、データベース製品によって動作が異なります。多くのデータベースでは、NULL値は最小値または最大値として扱われます。

- MySQL/MariaDBでは、NULL値は昇順（ASC）の場合は最小値として（最初に表示）、降順（DESC）の場合は最大値として（最後に表示）扱われます。

一部のデータベース（PostgreSQLなど）では、NULL値の位置を明示的に指定するための「NULLS FIRST」「NULLS LAST」構文がサポートされています。

### 例5：NULL値の扱い

例えば、出席（attendance）テーブルからコメント（comment）でソートすると、NULLが最初に来ます：

```sql
SELECT * FROM attendance ORDER BY comment;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | NULL          |
| 1           | 306        | present | NULL          |
| ...         | ...        | ...     | NULL          |
| 1           | 308        | late    | 5分遅刻       |
| 1           | 323        | late    | 電車遅延      |
| ...         | ...        | ...     | ...           |

## カラム番号を使った並び替え

カラム名の代わりに、SELECT文の結果セットにおけるカラムの位置（番号）を使って並び替えることもできます。最初のカラムは1、2番目のカラムは2、という具合です。

### 構文

```sql
SELECT カラム名1, カラム名2, ... FROM テーブル名 ORDER BY カラム位置;
```

### 例6：カラム番号を使った並び替え

例えば、学生（students）テーブルから学生ID（student_id）と名前（student_name）を取得し、名前（2番目のカラム）で並べ替えるには：

```sql
SELECT student_id, student_name FROM students ORDER BY 2;
```

この場合、「ORDER BY 2」は「ORDER BY student_name」と同じ意味になります。

> **注意**：カラム番号を使う方法は、カラムの順序を変更すると問題が起きるため、実際の業務では使用を避けた方が良いとされています。

## 式や関数を使った並び替え

ORDER BY句で式や関数を使うことにより、計算結果に基づいて並び替えることもできます。

### 例7：式を使った並び替え

例えば、成績（grades）テーブルから、得点の達成率（score/max_score）の高い順に並べるには：

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY (score/max_score) DESC;
```

または

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY 達成率 DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 98.0     |
| 320        | 1         | レポート1    | 48.5  | 50.0      | 97.0     |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 95.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

### 例8：関数を使った並び替え

文字列関数を使って並び替えることもできます。例えば、月名で並べることを考えましょう：

```sql
SELECT schedule_date, MONTH(schedule_date) AS month
FROM course_schedule
ORDER BY MONTH(schedule_date);
```

実行結果：

| schedule_date | month |
|---------------|-------|
| 2025-04-07    | 4     |
| 2025-04-08    | 4     |
| ...           | ...   |
| 2025-05-01    | 5     |
| 2025-05-02    | 5     |
| ...           | ...   |
| 2025-06-01    | 6     |
| ...           | ...   |

## CASE式を使った条件付き並び替え

さらに高度な並び替えとして、CASE式を使って条件に応じた並び順を定義することもできます。

### 例9：CASE式を使った並び替え

例えば、出席（attendance）テーブルから、出席状況（status）を「欠席→遅刻→出席」の順に優先して表示するには：

```sql
SELECT * FROM attendance
ORDER BY CASE 
           WHEN status = 'absent' THEN 1
           WHEN status = 'late' THEN 2
           WHEN status = 'present' THEN 3
           ELSE 4
         END;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |
| 1           | 302        | late   | 15分遅刻      |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |
| 1           | 301        | present| NULL          |
| 1           | 306        | present| NULL          |
| ...         | ...        | ...    | ...           |

## 練習問題

### 問題7-1
students（学生）テーブルから、すべての学生情報を学生名（student_name）の降順（逆五十音順）で取得するSQLを書いてください。

### 問題7-2
grades（成績）テーブルから、得点（score）が85点以上の成績を得点の高い順に取得するSQLを書いてください。

### 問題7-3
course_schedule（授業カレンダー）テーブルから、2025年5月の授業スケジュールを日付（schedule_date）の昇順で取得するSQLを書いてください。

### 問題7-4
teachers（教師）テーブルから、教師IDと名前を取得し、名前（teacher_name）の五十音順で並べるSQLを書いてください。

### 問題7-5
grades（成績）テーブルから、講座ID（course_id）ごとに、成績を評価タイプ（grade_type）の五十音順に、同じ評価タイプ内では得点（score）の高い順に並べて取得するSQLを書いてください。

### 問題7-6
attendance（出席）テーブルから、すべての出席情報を出席状況（status）が「absent」「late」「present」の順番で、同じ状態内ではコメント（comment）の有無（NULLが後）で並べて取得するSQLを書いてください。

## 解答

### 解答7-1
```sql
SELECT * FROM students ORDER BY student_name DESC;
```

### 解答7-2
```sql
SELECT * FROM grades WHERE score >= 85 ORDER BY score DESC;
```

### 解答7-3
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31' 
ORDER BY schedule_date;
```

### 解答7-4
```sql
SELECT teacher_id, teacher_name FROM teachers ORDER BY teacher_name;
```

### 解答7-5
```sql
SELECT * FROM grades 
ORDER BY course_id, grade_type, score DESC;
```

### 解答7-6
```sql
SELECT * FROM attendance
ORDER BY 
  CASE 
    WHEN status = 'absent' THEN 1
    WHEN status = 'late' THEN 2
    WHEN status = 'present' THEN 3
    ELSE 4
  END,
  CASE 
    WHEN comment IS NULL THEN 2
    ELSE 1
  END;
```

## まとめ

この章では、クエリ結果を特定の順序で並べるための「ORDER BY」句について学びました：

1. **基本的な並び替え**：指定したカラムの値に基づいて結果を並べる方法
2. **昇順と降順**：ASC（昇順）とDESC（降順）の指定方法
3. **複数カラムでの並び替え**：優先順位の高いカラムから順に指定する方法
4. **NULL値の扱い**：NULL値が並び替えでどのように扱われるか
5. **カラム番号**：カラム名の代わりに位置で指定する方法（あまり推奨されない）
6. **式や関数**：計算結果に基づいて並べる方法
7. **CASE式**：条件付きの複雑な並び替え

ORDER BY句は、データを見やすく整理するために非常に重要です。特に大量のデータを扱う場合、適切な並び順はデータの理解を大きく助けます。

次の章では、取得する結果の件数を制限する「LIMIT句：結果件数の制限とページネーション」について学びます。



---

# 8. LIMIT句：結果件数の制限とページネーション

## はじめに

これまでの章では、条件に合うデータを取得し、それを特定の順序で並べる方法を学びました。しかし実際のアプリケーションでは、大量のデータがあるときに、その一部だけを表示したいことがよくあります。例えば：

- 成績上位10件だけを表示したい
- Webページで一度に20件ずつ表示したい（ページネーション）
- 最新の5件のお知らせだけを取得したい

このような「結果の件数を制限する」ためのSQLコマンドが「LIMIT句」です。この章では、クエリ結果の件数を制限する方法と、ページネーションの実装方法を学びます。

## LIMIT句の基本

LIMIT句は、SELECT文の結果から指定した件数だけを取得するために使います。

> **用語解説**：
> - **LIMIT**：「制限する」という意味のSQLコマンドで、取得する行数を制限します。

### 基本構文（MySQL/MariaDB）

MySQLやMariaDBでのLIMIT句の基本構文は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数;
```

LIMIT句は通常、SELECT文の最後に記述します（ORDER BYの後）。

### 例1：単純なLIMIT

例えば、学生（students）テーブルから最初の5人だけを取得するには：

```sql
SELECT * FROM students LIMIT 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |

### ORDER BYとLIMITの組み合わせ

通常、LIMIT句はORDER BY句と組み合わせて使用します。これにより、「上位N件」「最新N件」などの操作が可能になります。

### 例2：ORDER BYとLIMITの組み合わせ

例えば、成績（grades）テーブルから得点（score）の高い順に上位3件を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 3;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |

### 例3：最新のレコードを取得

日付でソートして最新のデータを取得することもよくあります。例えば、最新の3つの授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
ORDER BY schedule_date DESC LIMIT 3;
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 95          | 28        | 2026-12-21    | 3         | 202D         | 119        | scheduled |
| 94          | 1         | 2026-12-21    | 1         | 102B         | 101        | scheduled |
| 93          | 14        | 2026-12-15    | 4         | 202D         | 110        | scheduled |

## OFFSETとページネーション

Webアプリケーションなどでは、大量のデータを「ページ」に分けて表示することがよくあります（ページネーション）。この機能を実現するためには、「OFFSET」（オフセット）という機能が必要です。

> **用語解説**：
> - **OFFSET**：「ずらす」という意味で、結果セットの先頭から指定した数だけ行をスキップします。
> - **ページネーション**：大量のデータを複数のページに分割して表示する技術です。

### 基本構文（MySQL/MariaDB）

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数 OFFSET スキップ数;
```

または、短縮形として：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT スキップ数, 件数;
```

### 例4：OFFSETを使ったスキップ

例えば、学生（students）テーブルから6番目から10番目までの学生を取得するには：

```sql
SELECT * FROM students LIMIT 5 OFFSET 5;
```

または：

```sql
SELECT * FROM students LIMIT 5, 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 306        | 河田咲奈     |
| 307        | 織田柚夏     |
| 308        | 永田悦子     |
| 309        | 相沢吉夫     |
| 310        | 吉川伽羅     |

### 例5：ページネーションの実装

ページネーションを実装する場合、通常は以下の式を使ってOFFSETを計算します：

```
OFFSET = (ページ番号 - 1) × ページあたりの件数
```

例えば、1ページあたり10件表示で、3ページ目のデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 10 OFFSET 20;
```

または：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 20, 10;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 322        | 木村結衣     |
| 323        | 林正義       |
| 324        | 清水香織     |
| 325        | 山田翔太     |
| 326        | 葉山陽太     |
| 327        | 青山凛       |
| 328        | 沢村大和     |
| 329        | 白石優月     |
| 330        | 月岡星奈     |

## LIMIT句を使用する際の注意点

### 1. ORDER BYの重要性

LIMIT句を使用する場合、通常はORDER BY句も一緒に使うべきです。ORDER BYがなければ、どのレコードが取得されるかは保証されません。

```sql
-- 良い例：結果が予測可能
SELECT * FROM students ORDER BY student_id LIMIT 5;

-- 悪い例：結果が不確定
SELECT * FROM students LIMIT 5;
```

### 2. パフォーマンスへの影響

大規模なテーブルで大きなOFFSET値を使用すると、パフォーマンスが低下する可能性があります。これは、データベースがOFFSET分のレコードを読み込んでから破棄する必要があるためです。

### 3. データベース製品による構文の違い

LIMIT句の構文はデータベース製品によって異なります：

- **MySQL/MariaDB/SQLite**：`LIMIT 件数 OFFSET スキップ数` または `LIMIT スキップ数, 件数`
- **PostgreSQL**：`LIMIT 件数 OFFSET スキップ数`
- **Oracle**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY`
- **SQL Server**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY` または旧バージョンでは `TOP`句

この章では主にMySQL/MariaDBの構文を使用します。

## 実践的なページネーションの実装

実際のアプリケーションでページネーションを実装する場合、以下のようなコードになります（疑似コード）：

```
ページ番号 = URLから取得またはデフォルト値（例：1）
1ページあたりの件数 = 設定値（例：10）
総レコード数 = SELECTで取得（COUNT(*)を使用）
総ページ数 = CEILING(総レコード数 ÷ 1ページあたりの件数)
OFFSET = (ページ番号 - 1) × 1ページあたりの件数

SQLクエリ = "SELECT * FROM テーブル ORDER BY カラム LIMIT " + 1ページあたりの件数 + " OFFSET " + OFFSET
```

### 例6：総レコード数と総ページ数の取得

総レコード数を取得するには：

```sql
SELECT COUNT(*) AS total_records FROM students;
```

実行結果：

| total_records |
|---------------|
| 100           |

この場合、1ページあたり10件表示なら、総ページ数は10ページ（CEILING(100 ÷ 10)）になります。

## 練習問題

### 問題8-1
grades（成績）テーブルから、得点（score）の高い順に上位5件の成績レコードを取得するSQLを書いてください。

### 問題8-2
course_schedule（授業カレンダー）テーブルから、日付（schedule_date）の新しい順に3件のスケジュールを取得するSQLを書いてください。

### 問題8-3
students（学生）テーブルを学生ID（student_id）の昇順で並べ、11番目から15番目までの学生（5件）を取得するSQLを書いてください。

### 問題8-4
teachers（教師）テーブルから、教師名（teacher_name）の五十音順で6番目から10番目までの教師情報を取得するSQLを書いてください。

### 問題8-5
1ページあたり20件表示で、grades（成績）テーブルの3ページ目のデータを得点（score）の高い順に取得するSQLを書いてください。

### 問題8-6
course_schedule（授業カレンダー）テーブルから、状態（status）が「scheduled」のスケジュールを日付（schedule_date）の昇順で並べ、先頭から10件スキップして次の5件を取得するSQLを書いてください。

## 解答

### 解答8-1
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 5;
```

### 解答8-2
```sql
SELECT * FROM course_schedule ORDER BY schedule_date DESC LIMIT 3;
```

### 解答8-3
```sql
SELECT * FROM students ORDER BY student_id LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM students ORDER BY student_id LIMIT 10, 5;
```

### 解答8-4
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5 OFFSET 5;
```
または
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5, 5;
```

### 解答8-5
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 20 OFFSET 40;
```
または
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 40, 20;
```

### 解答8-6
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 10, 5;
```

## まとめ

この章では、クエリ結果の件数を制限するためのLIMIT句と、ページネーションの実装方法について学びました：

1. **LIMIT句の基本**：指定した件数だけのレコードを取得する方法
2. **ORDER BYとの組み合わせ**：順序付けされた結果から一部だけを取得する方法
3. **OFFSET**：結果の先頭から指定した数だけレコードをスキップする方法
4. **ページネーション**：大量のデータを複数のページに分けて表示する実装方法
5. **注意点**：LIMIT句を使用する際の留意事項
6. **データベース製品による違い**：異なるデータベースでの構文の違い

LIMIT句は特にWebアプリケーションの開発で重要な機能です。大量のデータを効率よく表示するためのページネーション機能を実装するために欠かせません。また、トップN（上位N件）やボトムN（下位N件）のデータを取得する際にも使われます。

次の章では、データの集計分析を行うための「集計関数：COUNT、SUM、AVG、MAX、MIN」について学びます。






---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [18. サブクエリ：WHERE句内のサブクエリ](#18-サブクエリwhere句内のサブクエリ)
2. [19. サブクエリ応用：SELECT句、FROM句でのサブクエリ](#19-サブクエリ応用select句from句でのサブクエリ)
3. [20. 相関サブクエリ：外部クエリと連動するサブクエリ](#20-相関サブクエリ外部クエリと連動するサブクエリ)
4. [21. 集合演算：UNION、INTERSECT、EXCEPT](#21-集合演算unionintersectexcept)
5. [22. EXISTS演算子：存在確認のクエリ](#22-exists演算子存在確認のクエリ)
6. [23. CASE式：条件分岐による値の変換](#23-case式条件分岐による値の変換)
7. [24. ウィンドウ関数：OVER句とパーティション](#24-ウィンドウ関数over句とパーティション)
8. [25. 共通テーブル式（CTE）：WITH句の活用](#25-共通テーブル式ctewith句の活用)
9. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)
10. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)
11. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)

---


# 18. サブクエリ：WHERE句内のサブクエリ

## はじめに

これまでの章では、テーブルの結合（JOIN）を使って複数のテーブルからデータを取得する方法を学びました。しかし、データの取得や絞り込みには、もう一つの強力な方法があります。それが「サブクエリ（副問合せ）」です。

サブクエリとは、SQLクエリの中に埋め込まれた別のSQLクエリのことです。たとえば次のような場合に便利です：
- 「平均点より高い点数の成績だけを取得したい」
- 「特定の講座を受講している学生だけを検索したい」
- 「出席率が80%以上の学生の情報を知りたい」

この章では、サブクエリの基本概念を理解し、特にWHERE句内でのサブクエリの使い方について学びます。

## サブクエリとは

サブクエリ（または副問合せ）とは、別のSQL文の中に含まれるSQL文のことです。「クエリの中のクエリ」と考えることができます。

> **用語解説**：
> - **サブクエリ（副問合せ）**：SQLクエリの中に埋め込まれた別のSQLクエリで、外側のクエリ（外部クエリ）に値や条件を提供します。
> - **外部クエリ**：サブクエリを含む、より大きなクエリのことです。

### サブクエリの特徴

サブクエリには、以下のような特徴があります：

1. **括弧で囲む**：サブクエリは常に括弧`()`で囲む必要があります。
2. **内側から実行**：通常、サブクエリは外部クエリより先に実行されます。
3. **返す値**：サブクエリが返す値によって、いくつかのタイプに分けられます：
   - **スカラーサブクエリ**：単一の値（1行1列）を返す
   - **行サブクエリ**：単一の行（複数列可）を返す
   - **表サブクエリ**：複数の行と列を返す（結果セットのようなもの）
4. **使用場所**：SQL文の様々な場所で使用できます：
   - WHERE句内（この章のトピック）
   - FROM句内（テーブルのように扱う）
   - SELECT句内（計算値として）
   - HAVING句内（集計後のフィルタリング）
   - JOIN句の条件として

## サブクエリとJOINの違い

サブクエリとJOINは両方とも複数のテーブルからデータを関連付ける方法ですが、アプローチが異なります：

| サブクエリ | JOIN |
|------------|------|
| クエリの中に別のクエリを埋め込む | 複数のテーブルを直接連結する |
| 結果を段階的に絞り込む | 結果を一度に結合して表示する |
| 複雑なフィルタリングや計算に適している | 複数テーブルからの情報を一覧表示するのに適している |
| 読みやすいクエリになることがある | 簡潔なクエリになることがある |
| パフォーマンスが良い場合と悪い場合がある | 通常は効率的だが、大きなテーブル結合では重くなることがある |

どちらを使うかは、解決したい問題や求める結果の形式によって異なります。多くの場合、同じ結果を得るためにサブクエリとJOINの両方の方法が考えられます。

## WHERE句内のサブクエリ

WHERE句内でのサブクエリは、条件の一部として別のクエリの結果を使用する方法です。これは特に、動的に条件を決定したい場合に便利です。

### 基本構文：比較演算子とサブクエリ

```sql
SELECT カラム名
FROM テーブル名
WHERE カラム名 比較演算子 (SELECT カラム名 FROM テーブル名 WHERE 条件);
```

比較演算子には、`=, <>, >, <, >=, <=`などが使えます。

### 例1：スカラーサブクエリ（単一値）

平均点よりも高い成績を取得するクエリを考えてみましょう：

```sql
SELECT student_id, course_id, grade_type, score
FROM grades
WHERE score > (SELECT AVG(score) FROM grades)
ORDER BY score DESC;
```

このクエリでは：
1. サブクエリ `(SELECT AVG(score) FROM grades)` がまず実行され、すべての成績の平均点を計算します。
2. 外部クエリでは、その平均点より高いスコアを持つレコードだけを取得します。

実行結果：

| student_id | course_id | grade_type | score |
|------------|-----------|------------|-------|
| 311        | 1         | 中間テスト  | 95.0  |
| 320        | 1         | 中間テスト  | 93.5  |
| 302        | 1         | 中間テスト  | 92.0  |
| 308        | 1         | 中間テスト  | 91.0  |
| ...        | ...       | ...        | ...   |

上記のクエリでサブクエリが返す値は単一の値（例えば78.5など）です。このように単一の値を返すサブクエリをスカラーサブクエリと呼びます。

### 例2：特定教師の担当科目

教師ID=101（寺内鞍）が担当する講座を取得するクエリ：

```sql
SELECT course_id, course_name
FROM courses
WHERE teacher_id = (SELECT teacher_id FROM teachers WHERE teacher_name = '寺内鞍');
```

このクエリでは：
1. サブクエリ `(SELECT teacher_id FROM teachers WHERE teacher_name = '寺内鞍')` が寺内鞍先生のIDを取得します（結果は101）。
2. 外部クエリでは、そのIDに一致する講座を取得します。

実行結果：

| course_id | course_name                         |
|-----------|-------------------------------------|
| 1         | ITのための基礎知識                  |
| 3         | Cプログラミング演習                 |
| 29        | コードリファクタリングとクリーンコード |

### 例3：複数値を返すサブクエリ（IN演算子）

特定の講座を受講している学生を取得するクエリを考えてみましょう：

```sql
SELECT student_id, student_name
FROM students
WHERE student_id IN (
    SELECT student_id 
    FROM student_courses 
    WHERE course_id = '1'
)
ORDER BY student_id;
```

このクエリでは：
1. サブクエリは講座ID=1を受講している学生IDのリストを返します。
2. 外部クエリでは、そのリストに含まれる学生IDを持つ学生レコードだけを取得します。

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 306        | 河田咲奈     |
| ...        | ...          |

ここでは、サブクエリが複数の値（学生IDのリスト）を返し、外部クエリではIN演算子を使って「そのリストのいずれかに一致する」という条件を表現しています。

## IN、NOT IN、EXISTS、NOT EXISTSとの組み合わせ

サブクエリの結果が複数の行を返す場合、以下の演算子と組み合わせて使用します：

### 1. IN / NOT IN

「〜のいずれかに一致する」または「〜のいずれにも一致しない」という条件を表現します。

> **用語解説**：
> - **IN**：値がリストの中のいずれかの値と一致するか確認します。
> - **NOT IN**：値がリストの中のどの値とも一致しないか確認します。

#### 例4：IN演算子を使ったサブクエリ

2025年5月20日に授業が予定されている講座を検索：

```sql
SELECT course_id, course_name
FROM courses
WHERE course_id IN (
    SELECT DISTINCT course_id 
    FROM course_schedule 
    WHERE schedule_date = '2025-05-20'
)
ORDER BY course_id;
```

#### 例5：NOT IN演算子を使ったサブクエリ

2025年5月に授業が予定されていない講座を検索：

```sql
SELECT course_id, course_name
FROM courses
WHERE course_id NOT IN (
    SELECT DISTINCT course_id 
    FROM course_schedule 
    WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31'
)
ORDER BY course_id;
```

### 2. EXISTS / NOT EXISTS

レコードの存在チェックを行います。結果の値そのものは重要ではなく、「存在するかどうか」だけが条件になります。

> **用語解説**：
> - **EXISTS**：サブクエリが少なくとも1行の結果を返すかどうかをチェックします。
> - **NOT EXISTS**：サブクエリが結果を1行も返さないかどうかをチェックします。

#### 例6：EXISTS演算子を使ったサブクエリ

出席記録がある学生を検索：

```sql
SELECT student_id, student_name
FROM students s
WHERE EXISTS (
    SELECT 1 
    FROM attendance a 
    WHERE a.student_id = s.student_id
)
ORDER BY student_id;
```

このクエリでは、各学生に対して出席記録があるかどうかをチェックしています。サブクエリの`SELECT 1`は、結果の値は重要ではなく、単にレコードが存在するかどうかだけを調べるためのものです。

#### 例7：NOT EXISTS演算子を使ったサブクエリ

まだ一度も講座を受講していない学生を検索：

```sql
SELECT student_id, student_name
FROM students s
WHERE NOT EXISTS (
    SELECT 1 
    FROM student_courses sc 
    WHERE sc.student_id = s.student_id
)
ORDER BY student_id;
```

## ALL、ANY、SOMEとの組み合わせ

サブクエリが複数の値を返す場合、以下の修飾子と比較演算子を組み合わせて使うこともできます：

### 1. ALL

「すべての値と比較して条件を満たす」という意味です。

> **用語解説**：
> - **ALL**：サブクエリの結果のすべての値と比較して条件を満たすかどうかをチェックします。

#### 例8：ALL修飾子を使ったサブクエリ

すべての成績の平均よりも高い点数を取った学生を検索：

```sql
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.score > ALL (
    SELECT AVG(score) 
    FROM grades 
    GROUP BY course_id
)
ORDER BY s.student_id;
```

### 2. ANY / SOME

「いずれかの値と比較して条件を満たす」という意味です（ANY と SOME は同じ意味）。

> **用語解説**：
> - **ANY/SOME**：サブクエリの結果のいずれかの値と比較して条件を満たすかどうかをチェックします。

#### 例9：ANY修飾子を使ったサブクエリ

少なくとも1つの授業で85点以上を取得している学生を検索：

```sql
SELECT DISTINCT s.student_id, s.student_name
FROM students s
WHERE s.student_id = ANY (
    SELECT student_id 
    FROM grades 
    WHERE score >= 85
)
ORDER BY s.student_id;
```

## 相関サブクエリの基本

通常のサブクエリは、外部クエリとは独立して実行されます。一方、相関サブクエリは外部クエリの現在処理中の行を参照します。これにより、各行ごとに異なる条件での評価が可能になります。

> **用語解説**：
> - **相関サブクエリ**：外部クエリの現在の行を参照するサブクエリで、外部クエリと「相関関係」にあるサブクエリです。

### 例10：相関サブクエリの基本例

各学生の平均点より高い成績だけを取得するクエリ：

```sql
SELECT g.student_id, g.course_id, g.grade_type, g.score
FROM grades g
WHERE g.score > (
    SELECT AVG(score) 
    FROM grades 
    WHERE student_id = g.student_id
)
ORDER BY g.student_id, g.score DESC;
```

このクエリでは：
1. 外部クエリでgrades表から1行ずつ処理します。
2. サブクエリでは、現在処理中の学生IDの平均点を計算します（`WHERE student_id = g.student_id`の部分が相関しています）。
3. その学生の平均点より高い成績だけを結果に含めます。

外部クエリの各行に対して、サブクエリが実行されるため、処理は次のようになります：
- 学生301の場合：学生301の平均点を計算し、それより高い学生301の成績を返す
- 学生302の場合：学生302の平均点を計算し、それより高い学生302の成績を返す
- ...以下同様

## サブクエリのパフォーマンスと注意点

サブクエリを使用する際の主な注意点は以下の通りです：

1. **パフォーマンス**：複雑なサブクエリや相関サブクエリは、実行に時間がかかることがあります。特に大きなテーブルで相関サブクエリを使う場合は注意が必要です。

2. **NULL値の扱い**：NOT IN演算子とサブクエリを組み合わせる場合、サブクエリの結果にNULL値が含まれると予期しない結果になることがあります。NULL値の処理には注意しましょう。

3. **代替手段の検討**：多くの場合、サブクエリはJOINや他の方法でも同じ結果を得られます。パフォーマンスを考慮して、最適な方法を選択しましょう。

4. **可読性**：サブクエリはSQLを理解しやすくする場合もありますが、過度に複雑なネストされたサブクエリは可読性を低下させます。

## 練習問題

### 問題18-1
成績（grades）テーブルを使って、平均点より高い点数を取った成績レコードを取得するSQLを書いてください。結果には学生ID、講座ID、評価タイプ、点数を含め、点数の高い順にソートしてください。

### 問題18-2
学生（students）テーブルと受講（student_courses）テーブルを使って、「クラウドコンピューティング」（course_id = 9）の講座を受講している学生の名前を取得するSQLを書いてください。サブクエリを使用してください。

### 問題18-3
教師（teachers）テーブル、講座（courses）テーブルを使って、担当講座が3つ以上ある教師の名前を取得するSQLを書いてください。サブクエリとIN演算子を使用してください。

### 問題18-4
講座（courses）テーブル、学生コース（student_courses）テーブルを使って、受講者が一人もいない講座を取得するSQLを書いてください。NOT EXISTS演算子を使用してください。

### 問題18-5
学生（students）テーブル、成績（grades）テーブルを使って、全科目の平均点が85点以上の学生を取得するSQLを書いてください。相関サブクエリを使用してください。

### 問題18-6
教師（teachers）テーブル、講座（courses）テーブル、授業カレンダー（course_schedule）テーブルを使って、2025年5月に授業を行っていない教師を取得するSQLを書いてください。サブクエリとNOT IN演算子を使用してください。

## 解答

### 解答18-1
```sql
SELECT student_id, course_id, grade_type, score
FROM grades
WHERE score > (SELECT AVG(score) FROM grades)
ORDER BY score DESC;
```

### 解答18-2
```sql
SELECT student_id, student_name
FROM students
WHERE student_id IN (
    SELECT student_id
    FROM student_courses
    WHERE course_id = '9'
)
ORDER BY student_id;
```

### 解答18-3
```sql
SELECT teacher_id, teacher_name
FROM teachers
WHERE teacher_id IN (
    SELECT teacher_id
    FROM courses
    GROUP BY teacher_id
    HAVING COUNT(course_id) >= 3
)
ORDER BY teacher_id;
```

### 解答18-4
```sql
SELECT course_id, course_name
FROM courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM student_courses sc
    WHERE sc.course_id = c.course_id
)
ORDER BY course_id;
```

### 解答18-5
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE 85 <= (
    SELECT AVG(score)
    FROM grades g
    WHERE g.student_id = s.student_id
)
ORDER BY s.student_id;
```

### 解答18-6
```sql
SELECT t.teacher_id, t.teacher_name
FROM teachers t
WHERE t.teacher_id NOT IN (
    SELECT DISTINCT cs.teacher_id
    FROM course_schedule cs
    WHERE cs.schedule_date BETWEEN '2025-05-01' AND '2025-05-31'
)
ORDER BY t.teacher_id;
```

## まとめ

この章では、サブクエリの基本概念とWHERE句内でのサブクエリの使い方について学びました：

1. **サブクエリの基本概念**：
   - クエリ内に埋め込まれた別のクエリ
   - 括弧で囲む
   - 通常は内側から実行される

2. **サブクエリの種類**：
   - スカラーサブクエリ（単一値）
   - 複数値を返すサブクエリ
   - 相関サブクエリ（外部クエリを参照）

3. **WHERE句での使用方法**：
   - 比較演算子（=, <>, >, <, >=, <=）との組み合わせ
   - IN / NOT INでの複数値との比較
   - EXISTS / NOT EXISTSでの存在チェック
   - ALL / ANY / SOMEでの条件修飾

4. **サブクエリとJOINの使い分け**：
   - 用途に応じた適切な方法の選択
   - パフォーマンスと可読性の考慮

サブクエリは、動的な条件や複雑な絞り込みを実現するための強力なツールです。次の章では、FROM句内でのサブクエリ（導出テーブル）について学び、さらに高度なクエリ技術を習得していきます。



---

# 19. サブクエリ応用：SELECT句、FROM句でのサブクエリ

## はじめに

前章では、サブクエリの基本概念とWHERE句内でのサブクエリの使い方について学びました。サブクエリは、WHERE句だけでなく、SQL文の様々な部分で使用することができます。特に重要なのは、SELECT句とFROM句でのサブクエリです。

以下のような場合に役立ちます：
- 「各学生の点数と全体の平均点を同時に表示したい」（SELECT句）
- 「複雑な集計結果を元に、さらに計算や絞り込みを行いたい」（FROM句）
- 「テーブル自体を動的に生成して使用したい」（FROM句）

この章では、SELECT句とFROM句におけるサブクエリの活用方法とその応用について学びます。

## SELECT句内のサブクエリ

SELECT句内のサブクエリは、クエリの結果セットに計算列を追加する方法の一つです。通常、スカラーサブクエリ（単一の値を返すサブクエリ）が使用されます。

> **用語解説**：
> - **スカラーサブクエリ**：単一の値（1行1列）のみを返すサブクエリのことです。
> - **計算列**：既存のデータから計算されて生成される列のことです。

### 基本構文

```sql
SELECT 
    カラム1,
    カラム2,
    (SELECT 集計関数 FROM テーブル名 WHERE 条件) AS 別名
FROM テーブル名
WHERE 条件;
```

### 例1：全体の平均点を各成績と一緒に表示

```sql
SELECT 
    student_id,
    course_id,
    grade_type,
    score,
    (SELECT AVG(score) FROM grades) AS 全体平均
FROM grades
WHERE grade_type = '中間テスト'
ORDER BY score DESC;
```

このクエリでは、各成績レコードに「全体平均」という列を追加しています。サブクエリ `(SELECT AVG(score) FROM grades)` は全成績の平均値を計算します。

実行結果：

| student_id | course_id | grade_type | score | 全体平均 |
|------------|-----------|------------|-------|----------|
| 311        | 1         | 中間テスト | 95.0  | 78.5     |
| 320        | 1         | 中間テスト | 93.5  | 78.5     |
| 302        | 1         | 中間テスト | 92.0  | 78.5     |
| ...        | ...       | ...        | ...   | ...      |

### 例2：学生ごとの平均点を表示（相関サブクエリ）

```sql
SELECT 
    s.student_id,
    s.student_name,
    (SELECT AVG(score) FROM grades g WHERE g.student_id = s.student_id) AS 平均点
FROM students s
WHERE s.student_id BETWEEN 301 AND 310
ORDER BY 平均点 DESC;
```

このクエリでは、相関サブクエリを使用して各学生の平均点を計算しています。サブクエリは外部クエリの現在の行（学生）に依存しています。

実行結果：

| student_id | student_name | 平均点  |
|------------|--------------|---------|
| 311        | 鈴木健太     | 89.8    |
| 302        | 新垣愛留     | 86.5    |
| 308        | 永田悦子     | 85.9    |
| 301        | 黒沢春馬     | 82.3    |
| ...        | ...          | ...     |

### 例3：受講している講座数を表示

```sql
SELECT 
    s.student_id,
    s.student_name,
    (SELECT COUNT(*) FROM student_courses sc WHERE sc.student_id = s.student_id) AS 受講講座数
FROM students s
WHERE s.student_id BETWEEN 301 AND 310
ORDER BY 受講講座数 DESC, s.student_id;
```

このクエリでは、各学生が受講している講座の数を相関サブクエリを使って計算しています。

実行結果：

| student_id | student_name | 受講講座数 |
|------------|--------------|------------|
| 301        | 黒沢春馬     | 8          |
| 309        | 相沢吉夫     | 7          |
| 306        | 河田咲奈     | 6          |
| 310        | 吉川伽羅     | 6          |
| ...        | ...          | ...        |

## FROM句内のサブクエリ（導出テーブル）

FROM句内のサブクエリは、クエリの実行中に一時的に生成されるテーブル（導出テーブルやインラインビューとも呼ばれる）として機能します。これにより、複雑な集計や絞り込みを段階的に行うことができます。

> **用語解説**：
> - **導出テーブル（Derived Table）**：FROM句内のサブクエリによって生成される一時的なテーブルのことです。
> - **インラインビュー（Inline View）**：FROM句内のサブクエリの別名で、特にOracle製品でよく使われる用語です。

### 基本構文

```sql
SELECT カラム1, カラム2, ...
FROM (SELECT カラム1, カラム2, ... FROM テーブル名 WHERE 条件) AS 別名
WHERE 条件;
```

### 例4：各講座の平均点と全体平均との差を計算

```sql
SELECT 
    avg_scores.course_id,
    c.course_name,
    avg_scores.平均点,
    avg_scores.平均点 - (SELECT AVG(score) FROM grades) AS 全体平均との差
FROM (
    SELECT course_id, AVG(score) AS 平均点
    FROM grades
    GROUP BY course_id
) AS avg_scores
JOIN courses c ON avg_scores.course_id = c.course_id
ORDER BY avg_scores.平均点 DESC;
```

このクエリでは：
1. サブクエリ（導出テーブル）で各講座の平均点を計算
2. 外部クエリでは、その平均点と全体平均との差を計算
3. 結果を平均点の高い順に並べる

実行結果：

| course_id | course_name           | 平均点 | 全体平均との差 |
|-----------|----------------------|--------|----------------|
| 1         | ITのための基礎知識     | 86.21  | 7.71           |
| 2         | UNIX入門             | 83.79  | 5.29           |
| 5         | データベース設計と実装  | 82.33  | 3.83           |
| ...       | ...                  | ...    | ...            |

### 例5：成績上位の学生を抽出

```sql
SELECT 
    top_students.student_id,
    s.student_name,
    top_students.平均点
FROM (
    SELECT student_id, AVG(score) AS 平均点
    FROM grades
    GROUP BY student_id
    HAVING AVG(score) > 85
) AS top_students
JOIN students s ON top_students.student_id = s.student_id
ORDER BY top_students.平均点 DESC;
```

このクエリでは：
1. サブクエリで平均点が85点を超える学生を抽出
2. 外部クエリでその学生の名前を取得
3. 平均点の高い順に並べる

実行結果：

| student_id | student_name | 平均点 |
|------------|--------------|--------|
| 311        | 鈴木健太     | 89.8   |
| 302        | 新垣愛留     | 86.5   |
| 308        | 永田悦子     | 85.9   |
| ...        | ...          | ...    |

### 例6：複数の集計結果を組み合わせる

```sql
SELECT 
    attendance_stats.student_id,
    s.student_name,
    attendance_stats.出席回数,
    attendance_stats.欠席回数,
    attendance_stats.遅刻回数,
    attendance_stats.総授業数,
    ROUND(attendance_stats.出席回数 * 100.0 / attendance_stats.総授業数, 1) AS 出席率
FROM (
    SELECT 
        student_id,
        SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) AS 出席回数,
        SUM(CASE WHEN status = 'absent' THEN 1 ELSE 0 END) AS 欠席回数,
        SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END) AS 遅刻回数,
        COUNT(*) AS 総授業数
    FROM attendance
    GROUP BY student_id
) AS attendance_stats
JOIN students s ON attendance_stats.student_id = s.student_id
ORDER BY 出席率 DESC;
```

このクエリでは：
1. サブクエリ内で複雑な集計（出席状況の分類と集計）を行い
2. 外部クエリではその結果を使って出席率を計算しています

このように、複雑な集計を段階的に行うことで、クエリの可読性を高めることができます。

## SELECT句とFROM句の両方でサブクエリを使用

より複雑な分析では、SELECT句とFROM句の両方でサブクエリを使用することもあります。

### 例7：各講座の平均点と全体との比較

```sql
SELECT 
    course_stats.course_id,
    c.course_name,
    course_stats.受講者数,
    course_stats.平均点,
    (SELECT AVG(score) FROM grades) AS 全体平均,
    course_stats.平均点 - (SELECT AVG(score) FROM grades) AS 平均点差,
    CASE 
        WHEN course_stats.平均点 > (SELECT AVG(score) FROM grades) THEN '↑'
        WHEN course_stats.平均点 < (SELECT AVG(score) FROM grades) THEN '↓'
        ELSE '→'
    END AS 比較
FROM (
    SELECT 
        course_id,
        COUNT(DISTINCT student_id) AS 受講者数,
        AVG(score) AS 平均点
    FROM grades
    GROUP BY course_id
) AS course_stats
JOIN courses c ON course_stats.course_id = c.course_id
ORDER BY course_stats.平均点 DESC;
```

このクエリでは：
1. FROM句のサブクエリで各講座の受講者数と平均点を計算
2. SELECT句のサブクエリで全体平均を計算
3. CASE式で平均点と全体平均を比較して矢印記号を表示

実行結果：

| course_id | course_name           | 受講者数 | 平均点 | 全体平均 | 平均点差 | 比較 |
|-----------|----------------------|----------|--------|----------|----------|------|
| 1         | ITのための基礎知識     | 12       | 86.21  | 78.5     | 7.71     | ↑    |
| 2         | UNIX入門             | 8        | 83.79  | 78.5     | 5.29     | ↑    |
| 5         | データベース設計と実装  | 7        | 82.33  | 78.5     | 3.83     | ↑    |
| ...       | ...                  | ...      | ...    | ...      | ...      | ...  |

## サブクエリのネスト（入れ子）

サブクエリはネスト（入れ子）することもできます。つまり、サブクエリの中に別のサブクエリを含めることができます。

### 例8：平均点が全体の上位25%に入る学生を検索

```sql
SELECT student_id, student_name
FROM students
WHERE student_id IN (
    SELECT student_id
    FROM (
        SELECT 
            student_id,
            AVG(score) AS avg_score,
            PERCENT_RANK() OVER (ORDER BY AVG(score)) AS percentile
        FROM grades
        GROUP BY student_id
    ) AS student_percentiles
    WHERE percentile >= 0.75
)
ORDER BY student_id;
```

このクエリでは：
1. 最も内側のサブクエリで各学生の平均点とパーセンタイルを計算
2. 中間のサブクエリでパーセンタイルが75%以上の学生IDを抽出
3. 外部クエリでその学生の情報を取得

## サブクエリとJOINの使い分け

前章でも触れましたが、多くの場合、サブクエリとJOINは互いに代替可能です。一般的な傾向として：

### サブクエリが適している場合：
- 段階的に結果を絞り込みたい場合
- 一時的な集計結果を使って更なる計算や絞り込みをしたい場合
- クエリの各部分を明確に分離したい場合
- 相関サブクエリを使って行ごとの計算や比較をしたい場合

### JOINが適している場合：
- 複数のテーブルから同時にデータを取得したい場合
- 結果セットで複数のテーブルのカラムを表示したい場合
- 大きなデータセットで処理速度を重視する場合

## 共通テーブル式（CTE）との比較

MySQL 8.0以降では、FROM句のサブクエリの代わりに「共通テーブル式（CTE）」を使用することもできます。CTE（WITH句）は可読性が高く、同じ導出テーブルを複数回参照する場合に特に便利です。CTEについては後の章で詳しく学びます。

### 例9：CTEを使った同等のクエリ（参考）

```sql
WITH course_stats AS (
    SELECT 
        course_id,
        COUNT(DISTINCT student_id) AS 受講者数,
        AVG(score) AS 平均点
    FROM grades
    GROUP BY course_id
)
SELECT 
    course_stats.course_id,
    c.course_name,
    course_stats.受講者数,
    course_stats.平均点,
    (SELECT AVG(score) FROM grades) AS 全体平均,
    course_stats.平均点 - (SELECT AVG(score) FROM grades) AS 平均点差
FROM course_stats
JOIN courses c ON course_stats.course_id = c.course_id
ORDER BY course_stats.平均点 DESC;
```

## パフォーマンスの考慮点

サブクエリを使用する際のパフォーマンスに関する主な考慮点は以下の通りです：

1. **相関サブクエリの影響**：相関サブクエリは外部クエリの各行に対して実行されるため、大きなテーブルでは処理が遅くなる可能性があります。

2. **実行計画の確認**：複雑なサブクエリを使用する場合は、データベースがどのようにクエリを実行するかを確認しましょう（EXPLAIN文などを使用）。

3. **代替手段の検討**：特にパフォーマンスが重要な場合は、JOIN、インデックス、一時テーブル、ビューなどの代替手段も検討しましょう。

4. **再利用可能性**：同じサブクエリを複数回使用する場合は、CTEや一時テーブルを使用することで処理を一度だけにすることができます。

## 練習問題

### 問題19-1
SELECT句内のサブクエリを使用して、各学生の名前、学生ID、およびその学生が受講している講座の数を表示するSQLを書いてください。学生ID=301から305までの学生だけを対象とし、結果を受講講座数の多い順にソートしてください。

### 問題19-2
FROM句内のサブクエリを使用して、成績の平均点が80点以上の講座の情報（講座ID、講座名、平均点）を取得するSQLを書いてください。結果を平均点の高い順にソートしてください。

### 問題19-3
SELECT句とFROM句の両方でサブクエリを使用して、各学生の出席率（出席回数÷全授業回数×100）とクラス全体の平均出席率を比較するSQLを書いてください。結果には学生ID、学生名、出席率、平均出席率、および出席率と平均出席率の差を含めてください。

### 問題19-4
FROM句内のサブクエリを使用して、各教師が担当している講座の数と、その教師が担当するすべての講座の平均受講者数を計算するSQLを書いてください。結果を担当講座数の多い順にソートしてください。

### 問題19-5
FROM句内のサブクエリとJOINを組み合わせて、各学生の中間テストとレポート1の点数を横並びで比較するSQLを書いてください。結果には学生ID、学生名、中間テスト点数、レポート1点数、およびその差（中間テスト - レポート1）を含めてください。

### 問題19-6
複数のサブクエリをネストして、以下の情報を含むレポートを作成するSQLを書いてください：各講座について、講座名、担当教師名、平均点、最高点を取った学生の名前、そして授業の予定回数を表示します。結果を講座IDの順にソートしてください。

## 解答

### 解答19-1
```sql
SELECT 
    student_id,
    student_name,
    (SELECT COUNT(*) FROM student_courses sc WHERE sc.student_id = s.student_id) AS 受講講座数
FROM students s
WHERE student_id BETWEEN 301 AND 305
ORDER BY 受講講座数 DESC, student_id;
```

### 解答19-2
```sql
SELECT 
    course_avg.course_id,
    c.course_name,
    course_avg.平均点
FROM (
    SELECT 
        course_id,
        AVG(score) AS 平均点
    FROM grades
    GROUP BY course_id
    HAVING AVG(score) >= 80
) AS course_avg
JOIN courses c ON course_avg.course_id = c.course_id
ORDER BY course_avg.平均点 DESC;
```

### 解答19-3
```sql
SELECT 
    attendance_stats.student_id,
    s.student_name,
    attendance_stats.出席率,
    (SELECT 
         AVG(CASE WHEN status = 'present' THEN 100.0 ELSE 0 END) 
     FROM attendance) AS 平均出席率,
    attendance_stats.出席率 - (SELECT 
                               AVG(CASE WHEN status = 'present' THEN 100.0 ELSE 0 END) 
                           FROM attendance) AS 出席率差
FROM (
    SELECT 
        student_id,
        AVG(CASE WHEN status = 'present' THEN 100.0 ELSE 0 END) AS 出席率
    FROM attendance
    GROUP BY student_id
) AS attendance_stats
JOIN students s ON attendance_stats.student_id = s.student_id
ORDER BY 出席率差 DESC;
```

### 解答19-4
```sql
SELECT 
    teacher_stats.teacher_id,
    t.teacher_name,
    teacher_stats.担当講座数,
    teacher_stats.平均受講者数
FROM (
    SELECT 
        c.teacher_id,
        COUNT(c.course_id) AS 担当講座数,
        AVG(student_count.受講者数) AS 平均受講者数
    FROM courses c
    LEFT JOIN (
        SELECT 
            course_id,
            COUNT(student_id) AS 受講者数
        FROM student_courses
        GROUP BY course_id
    ) AS student_count ON c.course_id = student_count.course_id
    GROUP BY c.teacher_id
) AS teacher_stats
JOIN teachers t ON teacher_stats.teacher_id = t.teacher_id
ORDER BY teacher_stats.担当講座数 DESC;
```

### 解答19-5
```sql
SELECT 
    s.student_id,
    s.student_name,
    grades_comp.中間テスト,
    grades_comp.レポート1,
    grades_comp.中間テスト - grades_comp.レポート1 AS 点数差
FROM students s
JOIN (
    SELECT 
        student_id,
        MAX(CASE WHEN grade_type = '中間テスト' THEN score ELSE NULL END) AS 中間テスト,
        MAX(CASE WHEN grade_type = 'レポート1' THEN score ELSE NULL END) AS レポート1
    FROM grades
    WHERE grade_type IN ('中間テスト', 'レポート1')
    GROUP BY student_id
) AS grades_comp ON s.student_id = grades_comp.student_id
WHERE grades_comp.中間テスト IS NOT NULL AND grades_comp.レポート1 IS NOT NULL
ORDER BY 点数差 DESC;
```

### 解答19-6
```sql
SELECT 
    c.course_id,
    c.course_name,
    t.teacher_name AS 担当教師,
    course_stats.平均点,
    (SELECT s.student_name 
     FROM grades g
     JOIN students s ON g.student_id = s.student_id
     WHERE g.course_id = c.course_id
     ORDER BY g.score DESC
     LIMIT 1) AS 最高得点学生,
    (SELECT COUNT(*) 
     FROM course_schedule cs
     WHERE cs.course_id = c.course_id) AS 授業予定回数
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN (
    SELECT 
        course_id,
        AVG(score) AS 平均点
    FROM grades
    GROUP BY course_id
) AS course_stats ON c.course_id = course_stats.course_id
ORDER BY c.course_id;
```

## まとめ

この章では、SELECT句とFROM句におけるサブクエリの応用的な使い方について学びました：

1. **SELECT句内のサブクエリ**：
   - 計算列を追加するためのスカラーサブクエリ
   - 相関サブクエリを使った行ごとの計算
   - 各行に対する集計値や比較値の表示

2. **FROM句内のサブクエリ（導出テーブル）**：
   - 一時的なテーブルとして機能するサブクエリ
   - 複雑な集計や絞り込みを段階的に行う方法
   - 導出テーブルを使った二次加工

3. **SELECT句とFROM句の両方でのサブクエリ**：
   - 複雑な分析のための組み合わせ
   - 複数の集計レベルでの比較

4. **サブクエリのネスト**：
   - サブクエリ内に別のサブクエリを含める方法
   - 段階的な絞り込みの実現

5. **サブクエリとJOINの使い分け**：
   - それぞれの適した用途
   - パフォーマンスへの影響

サブクエリはSQL機能の中でも特に強力なツールの一つであり、複雑な分析や条件付き集計などを実現するための重要なテクニックです。用途に応じてJOINなどの他の手法と使い分けながら、効率的かつ読みやすいクエリを作成することが重要です。

次の章では、「相関サブクエリ：外部クエリと連動するサブクエリ」について詳しく学び、行ごとの比較や条件付き操作をさらに深く理解していきます。



---

# 20. 相関サブクエリ：外部クエリと連動するサブクエリ

## はじめに

前章までで、サブクエリの基本概念とWHERE句・SELECT句・FROM句でのサブクエリの使い方について学びました。サブクエリの中でも特に重要で強力なのが「相関サブクエリ」です。

相関サブクエリとは、外部クエリの値を参照するサブクエリのことです。例えば以下のようなケースで活用できます：
- 「各学生の成績が、その学生の平均点よりも高いものだけを抽出したい」
- 「各講座において、その講座の平均点より高い点数を取った学生を見つけたい」
- 「各教師が担当する講座の中で、最も受講者が多い講座を特定したい」

通常のサブクエリは独立して処理されますが、相関サブクエリは外部クエリの各行に対して実行されるため、より柔軟な条件指定が可能になります。この章では、相関サブクエリの基本概念と具体的な活用方法について詳しく学びます。

## 相関サブクエリとは

相関サブクエリとは、外部クエリの現在処理中の行の値を参照するサブクエリのことです。サブクエリが外部クエリの列を参照するため、「相関関係(correlation)」があると言われています。

> **用語解説**：
> - **相関サブクエリ**：外部クエリの値を参照する（外部クエリに依存する）サブクエリのことです。
> - **外部クエリ**：サブクエリを含む、より大きなクエリのことです。
> - **外部参照**：サブクエリ内から外部クエリのカラムを参照することを指します。

### 通常のサブクエリと相関サブクエリの違い

1. **通常のサブクエリ**：
   - 外部クエリとは独立して実行される
   - 外部クエリが実行される前に一度だけ評価される
   - 外部クエリの列を参照しない

2. **相関サブクエリ**：
   - 外部クエリの各行に対して実行される
   - 外部クエリの現在の行に依存する
   - 外部クエリの列を参照する

## 相関サブクエリの基本構文

相関サブクエリの基本構文は以下の通りです：

```sql
SELECT カラム1, カラム2, ...
FROM テーブル1 外部別名
WHERE カラム 演算子 (
    SELECT 集計関数(カラム)
    FROM テーブル2
    WHERE テーブル2.カラム = 外部別名.カラム
);
```

ここで重要なのは、サブクエリ内のWHERE句が外部クエリのテーブル別名を参照している点です。この参照により、外部クエリの各行に対してサブクエリが実行されます。

## 相関サブクエリの実践例

### 例1：学生の平均点より高い成績だけを抽出

```sql
SELECT g1.student_id, g1.course_id, g1.grade_type, g1.score
FROM grades g1
WHERE g1.score > (
    SELECT AVG(g2.score)
    FROM grades g2
    WHERE g2.student_id = g1.student_id
)
ORDER BY g1.student_id, g1.score DESC;
```

このクエリでは：
1. 外部クエリでgrades表の各行を処理します。
2. サブクエリでは、現在処理中の行の学生ID（`g1.student_id`）を使って、その学生の平均点を計算します。
3. その学生の平均点より高い成績だけを結果に含めます。

実行結果（一部）：

| student_id | course_id | grade_type | score |
|------------|-----------|------------|-------|
| 301        | 2         | 中間テスト  | 88.0  |
| 301        | 9         | 中間テスト  | 87.5  |
| 301        | 2         | レポート1   | 85.0  |
| 302        | 1         | 中間テスト  | 92.0  |
| 302        | 7         | 中間テスト  | 91.0  |
| ...        | ...       | ...        | ...   |

### 例2：講座ごとの平均点より高い点数を取った学生を見つける

```sql
SELECT c.course_name, s.student_name, g1.score
FROM grades g1
JOIN courses c ON g1.course_id = c.course_id
JOIN students s ON g1.student_id = s.student_id
WHERE g1.grade_type = '中間テスト'
AND g1.score > (
    SELECT AVG(g2.score)
    FROM grades g2
    WHERE g2.course_id = g1.course_id
    AND g2.grade_type = '中間テスト'
)
ORDER BY c.course_name, g1.score DESC;
```

このクエリでは：
1. 外部クエリでは中間テストの成績を処理します。
2. サブクエリでは、現在処理中の行の講座ID（`g1.course_id`）を使って、その講座の中間テストの平均点を計算します。
3. 講座の平均点より高い点数を取った学生だけを結果に含めます。

実行結果：

| course_name           | student_name | score |
|----------------------|--------------|-------|
| AI・機械学習入門      | 新垣愛留     | 91.0  |
| AI・機械学習入門      | 中村彩香     | 89.5  |
| ITのための基礎知識     | 鈴木健太     | 95.0  |
| ITのための基礎知識     | 松本さくら   | 93.5  |
| ITのための基礎知識     | 新垣愛留     | 92.0  |
| ...                  | ...          | ...   |

### 例3：各教師が担当する講座の中で最も受講者が多い講座

```sql
SELECT t.teacher_id, t.teacher_name, c.course_name, 
       (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) AS 受講者数
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
WHERE (
    SELECT COUNT(*)
    FROM student_courses sc
    WHERE sc.course_id = c.course_id
) = (
    SELECT MAX(enrollment_count)
    FROM (
        SELECT c2.course_id, COUNT(*) AS enrollment_count
        FROM courses c2
        JOIN student_courses sc ON c2.course_id = sc.course_id
        WHERE c2.teacher_id = t.teacher_id
        GROUP BY c2.course_id
    ) AS course_enrollments
)
ORDER BY t.teacher_id;
```

このクエリでは：
1. 外部クエリでteachersとcoursesテーブルを結合します。
2. 最初のサブクエリは、現在の講座の受講者数を計算します。
3. 二番目のサブクエリは、相関サブクエリとネスト（入れ子）を組み合わせて、教師（`t.teacher_id`）が担当する講座の中での最大受講者数を求めます。
4. それが一致する講座だけを結果に含めます。

実行結果：

| teacher_id | teacher_name | course_name           | 受講者数 |
|------------|--------------|----------------------|---------|
| 101        | 寺内鞍       | ITのための基礎知識     | 12      |
| 102        | 田尻朋美     | サーバーサイドプログラミング | 9  |
| 103        | 藤本理恵     | Webアプリケーション開発 | 11     |
| ...        | ...          | ...                  | ...     |

このように、相関サブクエリを使うことで「各〜について」という条件を実現できます。

## EXISTS演算子と相関サブクエリ

相関サブクエリはEXISTS演算子と組み合わせると特に強力です。EXISTSは、サブクエリが少なくとも1行結果を返すかどうかだけをチェックします。

> **用語解説**：
> - **EXISTS**：サブクエリが少なくとも1行の結果を返すかどうかをチェックする演算子です。
> - **NOT EXISTS**：サブクエリが結果を1行も返さないかどうかをチェックする演算子です。

### 例4：EXISTS演算子を使った相関サブクエリ

中間テストとレポート1の両方を提出している学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1 
    FROM grades g 
    WHERE g.student_id = s.student_id 
    AND g.grade_type = '中間テスト'
)
AND EXISTS (
    SELECT 1 
    FROM grades g 
    WHERE g.student_id = s.student_id 
    AND g.grade_type = 'レポート1'
)
ORDER BY s.student_id;
```

このクエリでは、各学生について「中間テストがある」「レポート1がある」という二つの条件を相関サブクエリとEXISTSを使ってチェックしています。

### 例5：NOT EXISTS演算子を使った相関サブクエリ

いずれかの授業で欠席している学生を検索：

```sql
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN course_schedule cs ON sc.course_id = cs.course_id
WHERE NOT EXISTS (
    SELECT 1
    FROM attendance a
    WHERE a.student_id = s.student_id
    AND a.schedule_id = cs.schedule_id
    AND a.status = 'present'
)
AND cs.schedule_date <= CURRENT_DATE
ORDER BY s.student_id;
```

このクエリでは、各学生が受講しているはずの授業について、出席記録がないか「欠席」状態になっているレコードを検索しています。

## 相関サブクエリの処理の流れ

相関サブクエリがどのように処理されるかを理解するために、簡単な例で詳しく見てみましょう：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
    AND g.score > 90
);
```

このクエリの処理の流れは次のようになります：

1. 外部クエリがstudentsテーブルの最初の行を取得
2. 現在の学生ID（例えば301）に対して、サブクエリが実行される
   - `WHERE g.student_id = 301 AND g.score > 90`のレコードを検索
   - 該当レコードがあればEXISTSはtrueを返す
3. EXISTSがtrueなら、その学生が結果に含まれる
4. 外部クエリが次の行に進み、サブクエリが再び実行される
5. すべての行に対してこれを繰り返す

このように、相関サブクエリは外部クエリの各行に対して実行されるため、外部クエリの行数が多いと処理時間が長くなる可能性があります。

## 相関サブクエリとJOINの比較

相関サブクエリとJOINは多くの場合、同じ結果を得るための別のアプローチとして使えます。どちらを選ぶかは、クエリの目的、データ量、可読性などによって異なります。

### 例6：相関サブクエリとJOINの比較

#### 相関サブクエリを使った例：
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
    AND g.score > 90
);
```

#### 同等のJOINを使った例：
```sql
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.score > 90;
```

### 使い分けの基準：

1. **相関サブクエリが適している場合**：
   - 「存在する/しない」という条件チェックが主目的
   - 結果セットにサブクエリのテーブルからのデータが不要
   - 複雑な条件や集計結果との比較
   - 各行ごとに異なる条件での評価が必要

2. **JOINが適している場合**：
   - 両方のテーブルから情報を表示したい
   - 大量データの処理でパフォーマンスが重要
   - 複数のテーブルからのデータを組み合わせる
   - クエリの可読性を重視する

## UPDATE文での相関サブクエリ

相関サブクエリはSELECT文だけでなく、UPDATE文でも利用できます。これにより、あるテーブルの値に基づいて別のテーブルを更新することが可能になります。

### 例7：UPDATE文での相関サブクエリ

例えば、学生の出席状況に基づいて成績に出席点を加算する場合：

```sql
UPDATE grades g
SET g.score = g.score + 5
WHERE g.grade_type = '最終評価'
AND EXISTS (
    SELECT 1
    FROM attendance a
    JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
    WHERE a.student_id = g.student_id
    AND cs.course_id = g.course_id
    AND a.status = 'present'
    GROUP BY a.student_id, cs.course_id
    HAVING COUNT(*) / COUNT(DISTINCT cs.schedule_id) >= 0.9  -- 90%以上の出席率
);
```

このクエリでは、出席率が90%以上の学生の最終評価に5点加算しています。

## 相関サブクエリの注意点とパフォーマンス

相関サブクエリは強力ですが、以下の点に注意が必要です：

1. **パフォーマンス**：
   - 外部クエリの各行に対してサブクエリが実行されるため、データ量が多いとパフォーマンスが低下する可能性がある
   - 特に深くネストした相関サブクエリでは注意が必要

2. **インデックス**：
   - 相関サブクエリのパフォーマンスを向上させるには、参照されるカラムにインデックスを設定することが重要
   - 特に、サブクエリ内のWHERE句で使用されるカラムには適切なインデックスを作成する

3. **代替手段の検討**：
   - JOINや一時テーブルなど、同じ結果を得るための別の方法も検討する
   - 特に大量データを扱う場合は、実行計画を比較して最適な方法を選択する

4. **可読性と保守性**：
   - 相関サブクエリは複雑になりがちなので、適切なコメントや命名規則を使って可読性を高める
   - 非常に複雑なロジックは、複数のステップに分解することも検討する

## 練習問題

### 問題20-1
grades（成績）テーブルを使って、各学生の平均点より10点以上高い成績を取得するSQLを書いてください。結果には学生ID、講座ID、評価タイプ、点数、および学生の平均点との差を「点差」という列名で表示してください。

### 問題20-2
courses（講座）テーブルとstudent_courses（受講）テーブルを使って、教師ごとに担当する講座の中で最も受講者が多い講座を取得するSQLを書いてください。結果には教師ID、教師名、講座名、受講者数を含めてください。相関サブクエリを使用してください。

### 問題20-3
students（学生）テーブルとattendance（出席）テーブルを使って、すべての授業に出席している学生（status = 'present'）を取得するSQLを書いてください。EXISTS演算子と相関サブクエリを使用してください。

### 問題20-4
course_schedule（授業カレンダー）テーブルとteachers（教師）テーブルを使って、担当している講座のうち一つでも欠席（status = 'absent'）の学生がいる授業を担当している教師を取得するSQLを書いてください。相関サブクエリとEXISTS演算子を使用してください。

### 問題20-5
grades（成績）テーブルとcourses（講座）テーブルを使って、講座ごとに平均点が全体の平均点よりも高い講座を取得するSQLを書いてください。結果には講座ID、講座名、講座平均点、全体平均点、差（講座平均点 - 全体平均点）を含めてください。相関サブクエリを使用してください。

### 問題20-6
students（学生）テーブル、student_courses（受講）テーブル、grades（成績）テーブルを使って、受講しているすべての講座で合格点（70点以上）を取っている学生を取得するSQLを書いてください。NOT EXISTS演算子と相関サブクエリを使用してください。

## 解答

### 解答20-1
```sql
SELECT 
    g1.student_id,
    g1.course_id,
    g1.grade_type,
    g1.score,
    g1.score - (
        SELECT AVG(g2.score)
        FROM grades g2
        WHERE g2.student_id = g1.student_id
    ) AS 点差
FROM grades g1
WHERE g1.score >= (
    SELECT AVG(g2.score) + 10
    FROM grades g2
    WHERE g2.student_id = g1.student_id
)
ORDER BY 点差 DESC;
```

### 解答20-2
```sql
SELECT 
    t.teacher_id,
    t.teacher_name,
    c.course_name,
    (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) AS 受講者数
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
WHERE (
    SELECT COUNT(*)
    FROM student_courses sc
    WHERE sc.course_id = c.course_id
) = (
    SELECT MAX(student_count)
    FROM (
        SELECT c2.course_id, COUNT(sc.student_id) AS student_count
        FROM courses c2
        LEFT JOIN student_courses sc ON c2.course_id = sc.course_id
        WHERE c2.teacher_id = t.teacher_id
        GROUP BY c2.course_id
    ) AS max_students
)
ORDER BY t.teacher_id, 受講者数 DESC;
```

### 解答20-3
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM course_schedule cs
    JOIN student_courses sc ON cs.course_id = sc.course_id
    WHERE sc.student_id = s.student_id
    AND NOT EXISTS (
        SELECT 1
        FROM attendance a
        WHERE a.schedule_id = cs.schedule_id
        AND a.student_id = s.student_id
        AND a.status = 'present'
    )
)
AND EXISTS (
    SELECT 1 FROM student_courses sc WHERE sc.student_id = s.student_id
)
ORDER BY s.student_id;
```

### 解答20-4
```sql
SELECT DISTINCT t.teacher_id, t.teacher_name
FROM teachers t
WHERE EXISTS (
    SELECT 1
    FROM course_schedule cs
    WHERE cs.teacher_id = t.teacher_id
    AND EXISTS (
        SELECT 1
        FROM attendance a
        WHERE a.schedule_id = cs.schedule_id
        AND a.status = 'absent'
    )
)
ORDER BY t.teacher_id;
```

### 解答20-5
```sql
SELECT 
    c.course_id,
    c.course_name,
    (SELECT AVG(g.score) FROM grades g WHERE g.course_id = c.course_id) AS 講座平均点,
    (SELECT AVG(score) FROM grades) AS 全体平均点,
    (SELECT AVG(g.score) FROM grades g WHERE g.course_id = c.course_id) - 
    (SELECT AVG(score) FROM grades) AS 差
FROM courses c
WHERE (
    SELECT AVG(g.score)
    FROM grades g
    WHERE g.course_id = c.course_id
) > (
    SELECT AVG(score)
    FROM grades
)
ORDER BY 差 DESC;
```

### 解答20-6
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1 FROM student_courses sc WHERE sc.student_id = s.student_id
)
AND NOT EXISTS (
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
    AND EXISTS (
        SELECT 1
        FROM grades g
        WHERE g.student_id = s.student_id
        AND g.course_id = sc.course_id
        AND g.score < 70
    )
)
ORDER BY s.student_id;
```

## まとめ

この章では、相関サブクエリについて詳しく学びました：

1. **相関サブクエリの概念**：
   - 外部クエリの値を参照するサブクエリ
   - 外部クエリの各行に対して実行される
   - 「各〜について」という条件を実現できる強力な機能

2. **相関サブクエリの構文と使用例**：
   - 基本構文と動作原理
   - 学生の平均点より高い成績の抽出
   - 講座ごとの平均点との比較
   - 教師ごとの最大受講者数の講座の特定

3. **EXISTS演算子との組み合わせ**：
   - レコードの存在チェックに効果的なEXISTS/NOT EXISTS
   - 複雑な条件を持つデータの抽出方法

4. **処理の流れとパフォーマンス**：
   - 相関サブクエリの実行順序と動作の理解
   - パフォーマンスへの影響と最適化方法

5. **相関サブクエリとJOINの比較**：
   - 同じ結果を得るための異なるアプローチ
   - 使い分けの基準と考慮点

6. **UPDATE文での活用**：
   - データ更新における相関サブクエリの応用

相関サブクエリは、複雑な条件や「各〜について」という条件を実現するための強力なツールです。適切に使用することで、単純なJOINでは実現しにくい複雑なデータ抽出や条件付きの操作が可能になります。ただし、パフォーマンスへの影響を考慮し、適切な場面で使用することが重要です。

次の章では、「EXISTS句とサブクエリ：存在チェックの高度な使い方」について学び、EXISTSとサブクエリをさらに深く理解していきます。



---

# 21. 集合演算：UNION、INTERSECT、EXCEPT

## はじめに

これまでの章では、サブクエリや相関サブクエリを使用して複雑なデータ検索を行う方法を学びました。SQLにはもう一つの強力な技術があります。それが「集合演算」です。

集合演算とは、複数のSELECT文の結果を結合したり、比較したりする操作のことです。例えば以下のようなケースで活用できます：
- 「複数の検索条件の結果を一つにまとめたい」
- 「二つの検索結果の共通部分だけを抽出したい」
- 「ある条件の結果から別の条件の結果を除外したい」

この章では、主要な集合演算（UNION、INTERSECT、EXCEPT）の基本概念と実践的な使用方法について学びます。

## 集合演算とは

集合演算とは、複数のクエリ結果を数学的な「集合」として扱い、それらを組み合わせる操作のことです。主な集合演算には以下の3種類があります：

> **用語解説**：
> - **集合演算**：複数のSELECT文の結果を集合として扱い、合成する演算のことです。
> - **UNION（和集合）**：二つのクエリ結果を結合し、重複を排除した結果を返します。
> - **INTERSECT（積集合）**：二つのクエリ結果の共通部分のみを返します。
> - **EXCEPT（差集合）**：一つ目のクエリ結果から二つ目のクエリ結果に含まれるレコードを除外した結果を返します。

## 集合演算の基本規則

集合演算を使用する際には、以下の基本規則に従う必要があります：

1. **カラム数の一致**：集合演算で結合する各SELECT文は、同じ数のカラムを持つ必要があります。
2. **データ型の互換性**：対応するカラムは互換性のあるデータ型である必要があります。
3. **カラム名**：最終的な結果のカラム名は、最初のSELECT文で指定されたものが使用されます。
4. **ORDER BY**：集合演算の結果全体に対して一番最後に一度だけ指定できます。
5. **NULL値**：集合演算においてNULL値も通常の値として扱われます。

## UNION（和集合）

UNIONは、二つ以上のクエリ結果を結合し、重複を排除した結果を返します。

> **用語解説**：
> - **UNION**：複数のSELECT文の結果を結合し、重複を排除する演算子です。
> - **UNION ALL**：複数のSELECT文の結果を結合し、重複を排除せずにすべての行を返す演算子です。

### 基本構文

```sql
SELECT カラム1, カラム2, ...
FROM テーブル1
WHERE 条件1

UNION

SELECT カラム1, カラム2, ...
FROM テーブル2
WHERE 条件2;
```

### 例1：UNIONの基本

ITかAI関連の講座を受講している学生の一覧を取得するクエリ：

```sql
-- ITのための基礎知識を受講している学生
SELECT s.student_id, s.student_name, '1' AS course_id, 'ITのための基礎知識' AS course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '1'

UNION

-- AI・機械学習入門を受講している学生
SELECT s.student_id, s.student_name, '7' AS course_id, 'AI・機械学習入門' AS course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '7'

ORDER BY student_id;
```

実行結果（一部）：

| student_id | student_name | course_id | course_name        |
|------------|--------------|-----------|-------------------|
| 301        | 黒沢春馬     | 1         | ITのための基礎知識  |
| 302        | 新垣愛留     | 1         | ITのための基礎知識  |
| 302        | 新垣愛留     | 7         | AI・機械学習入門    |
| 303        | 柴崎春花     | 1         | ITのための基礎知識  |
| 305        | 河口菜恵子   | 7         | AI・機械学習入門    |
| ...        | ...          | ...       | ...               |

このクエリでは、講座ID=1（ITのための基礎知識）または講座ID=7（AI・機械学習入門）を受講している学生をUNIONで結合しています。ある学生が両方の講座を受講している場合（例：302の新垣愛留）、その学生は両方の講座で結果に含まれます。

### 例2：UNION ALLを使用した重複を許容する例

```sql
-- 出席率が高い学生（90%以上）
SELECT s.student_id, s.student_name, '高出席率' AS category
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(CASE WHEN a.status = 'present' THEN 100 ELSE 0 END) >= 90

UNION ALL

-- 成績が優秀な学生（85点以上）
SELECT s.student_id, s.student_name, '高成績' AS category
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(g.score) >= 85

ORDER BY category, student_id;
```

このクエリでは、出席率の高い学生と成績が優秀な学生を `UNION ALL` で結合しています。`UNION ALL` は重複を排除しないため、ある学生が両方の条件を満たす場合、結果に2回含まれます（出席率が高く、かつ成績も優秀な学生）。

実行結果（一部）：

| student_id | student_name | category |
|------------|--------------|----------|
| 301        | 黒沢春馬     | 高出席率  |
| 302        | 新垣愛留     | 高出席率  |
| 307        | 織田柚夏     | 高出席率  |
| 302        | 新垣愛留     | 高成績    |
| 308        | 永田悦子     | 高成績    |
| 311        | 鈴木健太     | 高成績    |
| ...        | ...          | ...      |

### UNIONとUNION ALLの違い

- **UNION**：重複する行を排除します（重複チェックのためにソートが行われるため、パフォーマンスへの影響があります）。
- **UNION ALL**：重複する行もすべて保持します（ソートが不要なため、通常UNIONより高速です）。

重複を排除する必要がなければ、パフォーマンスの観点から`UNION ALL`を使用する方が好ましいことが多いです。

## INTERSECT（積集合）

INTERSECTは、二つのクエリ結果の共通部分（両方のクエリ結果に含まれる行）のみを返します。

> **用語解説**：
> - **INTERSECT**：二つのSELECT文の結果の共通部分のみを返す演算子です。

### 基本構文

```sql
SELECT カラム1, カラム2, ...
FROM テーブル1
WHERE 条件1

INTERSECT

SELECT カラム1, カラム2, ...
FROM テーブル2
WHERE 条件2;
```

### 例3：INTERSECTの基本

ITの基礎知識とAI・機械学習入門の両方を受講している学生を検索：

```sql
-- ITのための基礎知識を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '1'

INTERSECT

-- AI・機械学習入門を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '7'

ORDER BY student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 302        | 新垣愛留     |
| 310        | 吉川伽羅     |
| 315        | 遠藤勇気     |
| ...        | ...          |

このクエリでは、講座ID=1と講座ID=7の両方を受講している学生のみが結果に含まれます。

### 例4：複数条件の共通部分

中間テストとレポート1の両方で85点以上を取得した学生を検索：

```sql
-- 中間テストで85点以上の学生
SELECT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = '中間テスト' AND g.score >= 85

INTERSECT

-- レポート1で85点以上の学生
SELECT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = 'レポート1' AND g.score >= 85

ORDER BY student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 302        | 新垣愛留     |
| 308        | 永田悦子     |
| 311        | 鈴木健太     |
| ...        | ...          |

## EXCEPT（差集合）

EXCEPTは、最初のクエリ結果から2番目のクエリ結果に含まれる行を除外した結果を返します。

> **用語解説**：
> - **EXCEPT**：一つ目のSELECT文の結果から二つ目のSELECT文の結果に含まれる行を除外する演算子です。一部のデータベース（例：Oracle）では、MINUS演算子が同じ目的で使用されます。

### 基本構文

```sql
SELECT カラム1, カラム2, ...
FROM テーブル1
WHERE 条件1

EXCEPT

SELECT カラム1, カラム2, ...
FROM テーブル2
WHERE 条件2;
```

### 例5：EXCEPTの基本

ITのための基礎知識は受講しているが、AI・機械学習入門は受講していない学生を検索：

```sql
-- ITのための基礎知識を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '1'

EXCEPT

-- AI・機械学習入門を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '7'

ORDER BY student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 303        | 柴崎春花     |
| 306        | 河田咲奈     |
| ...        | ...          |

このクエリでは、講座ID=1を受講しているが、講座ID=7は受講していない学生だけが結果に含まれます。

### 例6：除外条件を使った検索

出席記録はあるが、成績記録がない学生を検索：

```sql
-- 出席記録がある学生
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN attendance a ON s.student_id = a.student_id

EXCEPT

-- 成績記録がある学生
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id

ORDER BY student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 佐々木優斗   |
| 317        | 長谷川結衣   |
| 321        | 西山太一     |
| ...        | ...          |

## 集合演算子の組み合わせ

複数の集合演算子を組み合わせて使用することもできます。その場合、括弧（）を使用して演算の優先順位を明確にしましょう。

### 例7：集合演算子の組み合わせ

IT関連の講座か、クラウド関連の講座を受講していて、かつプログラミング関連の講座は受講していない学生を検索：

```sql
-- IT関連の講座を受講している学生
(SELECT DISTINCT s.student_id, s.student_name
 FROM students s
 JOIN student_courses sc ON s.student_id = sc.student_id
 WHERE sc.course_id IN ('1', '7')  -- ITの基礎知識またはAI・機械学習入門

 UNION

 -- クラウド関連の講座を受講している学生
 SELECT DISTINCT s.student_id, s.student_name
 FROM students s
 JOIN student_courses sc ON s.student_id = sc.student_id
 WHERE sc.course_id IN ('9', '16'))  -- クラウドコンピューティングまたはクラウドネイティブアーキテクチャ

EXCEPT

-- プログラミング関連の講座を受講している学生
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id IN ('3', '4', '8');  -- Cプログラミングまたはウェブアプリまたはモバイルアプリ

```

このクエリでは：
1. まず、IT関連またはクラウド関連の講座を受講している学生を`UNION`で結合
2. 次に、プログラミング関連の講座を受講している学生を`EXCEPT`で除外

## 集合演算を使用する状況

集合演算は以下のような状況で特に役立ちます：

1. **複数の条件を満たすレコードの検索**：
   - 複数の条件すべてを満たすレコード（`INTERSECT`）
   - いずれかの条件を満たすレコード（`UNION`）
   - 特定の条件は満たすが別の条件は満たさないレコード（`EXCEPT`）

2. **異なるテーブルからの類似データの結合**：
   - 構造は同じだが別々のテーブルにあるデータを結合する（例：アーカイブと現行データ）

3. **複雑なレポート作成**：
   - 複数のカテゴリを含むレポート作成
   - 異なる条件のデータを一つのレポートにまとめる

4. **差分分析**：
   - 二つのデータセット間の違いを特定する（例：前月と今月の比較）

## 集合演算とサブクエリやJOINの比較

集合演算に代わる方法として、サブクエリやJOINを使用することも可能な場合があります。以下に、それぞれの方法の比較を示します：

### 例8：集合演算とサブクエリの比較

**集合演算を使う場合（INTERSECT）**：
```sql
-- 中間テストで85点以上の学生
SELECT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = '中間テスト' AND g.score >= 85

INTERSECT

-- レポート1で85点以上の学生
SELECT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = 'レポート1' AND g.score >= 85;
```

**サブクエリを使う場合（IN）**：
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT g1.student_id
    FROM grades g1
    WHERE g1.grade_type = '中間テスト' AND g1.score >= 85
)
AND s.student_id IN (
    SELECT g2.student_id
    FROM grades g2
    WHERE g2.grade_type = 'レポート1' AND g2.score >= 85
);
```

**JOINを使う場合**：
```sql
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN grades g1 ON s.student_id = g1.student_id
JOIN grades g2 ON s.student_id = g2.student_id
WHERE g1.grade_type = '中間テスト' AND g1.score >= 85
AND g2.grade_type = 'レポート1' AND g2.score >= 85;
```

### 使い分けの基準：

1. **集合演算が適している場合**：
   - クエリが概念的に「和集合」「積集合」「差集合」として考えやすい場合
   - 複数の異なるクエリ結果を組み合わせる場合
   - クエリが複雑で、分割して考えた方が理解しやすい場合

2. **サブクエリが適している場合**：
   - 一方のクエリ結果がフィルタとして使用される場合
   - EXISTS/NOT EXISTSでの存在チェックが必要な場合
   - 相関サブクエリで行ごとの条件チェックが必要な場合

3. **JOINが適している場合**：
   - 複数のテーブルからの情報を組み合わせて表示する場合
   - 結合条件が明確で、パフォーマンスが重要な場合
   - 追加の集計や条件が必要な場合

## 集合演算のパフォーマンスと注意点

集合演算を使用する際の主な注意点は以下の通りです：

1. **ソーティングコスト**：
   - `UNION`、`INTERSECT`、`EXCEPT`は重複排除のためのソートが必要なため、大きなデータセットでは処理が遅くなる可能性があります。
   - 重複排除が不要な場合は`UNION ALL`を使用すると効率的です。

2. **メモリ消費**：
   - 大きなデータセットを結合する場合、メモリ消費が大きくなることがあります。
   - 特に、`INTERSECT`と`EXCEPT`は両方のクエリ結果を一時的に保存する必要があります。

3. **クエリの最適化**：
   - 大きなデータセットの集合演算では、各SELECT文を最適化して、必要最小限のデータだけを処理するようにしましょう。
   - 可能な限り、集合演算の前に条件でフィルタリングして結果セットを小さくしましょう。

4. **代替手段の検討**：
   - 同じ結果を得るためのJOINや条件式など、より効率的な方法がないか検討しましょう。
   - 特にパフォーマンスが重要な場合は、実行計画を比較して最適な方法を選択しましょう。

## 練習問題

### 問題21-1
UNION演算子を使用して、「ITのための基礎知識」（course_id = 1）と「データベース設計と実装」（course_id = 5）のいずれかを受講している学生の一覧を取得するSQLを書いてください。結果には学生ID、学生名、講座名を含めてください。

### 問題21-2
INTERSECT演算子を使用して、「Webアプリケーション開発」（course_id = 4）と「モバイルアプリ開発」（course_id = 8）の両方を受講している学生の一覧を取得するSQLを書いてください。

### 問題21-3
EXCEPT演算子を使用して、「プロジェクト管理手法」（course_id = 10）は受講しているが、「UNIX入門」（course_id = 2）は受講していない学生の一覧を取得するSQLを書いてください。

### 問題21-4
UNION ALL演算子を使用して、出席率（status = 'present'の割合）が85%以上の学生と、平均点が85点以上の学生をそれぞれ「高出席」「高成績」のカテゴリー別に一覧表示し、同じ学生が両方の条件を満たす場合は両方のカテゴリーに表示されるようにするSQLを書いてください。

### 問題21-5
UNION、INTERSECTおよびEXCEPT演算子を組み合わせて、次の条件を満たす学生の一覧を取得するSQLを書いてください：
- 「データベース設計と実装」または「データ分析と可視化」を受講している
- 「プロジェクト管理手法」は受講していない
- 中間テストの成績が80点以上である

### 問題21-6
講座の組み合わせのうち、同じ学生が受講している頻度の高い組み合わせトップ5を見つけるために、INTERSECT演算子とUNION演算子を組み合わせたSQLを書いてください。結果には講座ID、講座名、受講者数を含めてください。

## 解答

### 解答21-1
```sql
-- ITのための基礎知識を受講している学生
SELECT s.student_id, s.student_name, c.course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE c.course_id = '1'

UNION

-- データベース設計と実装を受講している学生
SELECT s.student_id, s.student_name, c.course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE c.course_id = '5'

ORDER BY student_id;
```

### 解答21-2
```sql
-- Webアプリケーション開発を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '4'

INTERSECT

-- モバイルアプリ開発を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '8'

ORDER BY student_id;
```

### 解答21-3
```sql
-- プロジェクト管理手法を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '10'

EXCEPT

-- UNIX入門を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '2'

ORDER BY student_id;
```

### 解答21-4
```sql
-- 出席率が85%以上の学生
SELECT s.student_id, s.student_name, '高出席' AS category
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 85

UNION ALL

-- 平均点が85点以上の学生
SELECT s.student_id, s.student_name, '高成績' AS category
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(g.score) >= 85

ORDER BY student_id, category;
```

### 解答21-5
```sql
-- データベース設計と実装またはデータ分析と可視化を受講している学生
(SELECT DISTINCT s.student_id, s.student_name
 FROM students s
 JOIN student_courses sc ON s.student_id = sc.student_id
 WHERE sc.course_id IN ('5', '11'))

EXCEPT

-- プロジェクト管理手法を受講している学生
(SELECT s.student_id, s.student_name
 FROM students s
 JOIN student_courses sc ON s.student_id = sc.student_id
 WHERE sc.course_id = '10')

INTERSECT

-- 中間テストの成績が80点以上の学生
(SELECT s.student_id, s.student_name
 FROM students s
 JOIN grades g ON s.student_id = g.student_id
 WHERE g.grade_type = '中間テスト' AND g.score >= 80)

ORDER BY student_id;
```

### 解答21-6
```sql
WITH course_pairs AS (
    -- 講座ペアごとの受講学生数を計算
    SELECT 
        c1.course_id AS course_id1,
        c1.course_name AS course_name1,
        c2.course_id AS course_id2,
        c2.course_name AS course_name2,
        COUNT(*) AS common_students
    FROM courses c1
    JOIN student_courses sc1 ON c1.course_id = sc1.course_id
    JOIN student_courses sc2 ON sc1.student_id = sc2.student_id
    JOIN courses c2 ON sc2.course_id = c2.course_id
    WHERE c1.course_id < c2.course_id  -- 重複を避ける
    GROUP BY c1.course_id, c1.course_name, c2.course_id, c2.course_name
)
-- 上位5件を取得
SELECT 
    course_id1, 
    course_name1, 
    course_id2, 
    course_name2, 
    common_students AS 共通受講者数
FROM course_pairs
ORDER BY common_students DESC
LIMIT 5;
```

注：この解答の例は、共通テーブル式（WITH句）を使用しています。これは次の章で詳しく学習する内容ですが、ここでは効率的な解答のために先行して使用しています。

## まとめ

この章では、SQL集合演算について詳しく学びました：

1. **集合演算の基本概念**：
   - 複数のクエリ結果を集合として扱う演算
   - 集合演算を使用する際の基本規則（カラム数の一致、データ型の互換性など）

2. **UNION（和集合）**：
   - 複数のクエリ結果を結合し、重複を排除する方法
   - UNION ALLで重複を保持する方法
   - パフォーマンスの違いと使い分け

3. **INTERSECT（積集合）**：
   - 複数のクエリ結果の共通部分を抽出する方法
   - 複数条件をすべて満たすレコードの検索

4. **EXCEPT（差集合）**：
   - 一方のクエリ結果から他方のクエリ結果を除外する方法
   - 特定の条件を満たすが別の条件は満たさないレコードの検索

5. **集合演算子の組み合わせ**：
   - 複数の集合演算子を組み合わせた複雑な条件の表現
   - 括弧を使った演算優先順位の制御

6. **集合演算とサブクエリやJOINの比較**：
   - 同じ結果を得るための異なるアプローチ
   - 使い分けの基準

集合演算は、複雑なレポート作成や条件付きデータ分析において強力なツールとなります。適切に使用することで、複雑な条件を持つデータの抽出や異なるデータセットの比較が効率的に行えるようになります。

次の章では、「EXISTS演算子：存在確認のクエリ」について学び、レコードの存在確認に特化したSQLテクニックを深く理解していきます。



---

# 22. EXISTS演算子：存在確認のクエリ

## はじめに

これまでの章で、サブクエリ、相関サブクエリ、集合演算について学び、その中でEXISTS演算子にも触れてきました。EXISTS演算子は、レコードの存在確認に特化した非常に強力で頻繁に使用されるSQL機能です。

EXISTS演算子は以下のような場面で特に威力を発揮します：
- 「特定の条件を満たすレコードが存在する場合のみ」という条件付き検索
- 「関連テーブルに対応するデータがある/ない」という存在チェック
- 「複数の条件をすべて満たす」または「いずれかの条件を満たす」という複雑な条件設定
- 大きなデータセットでの効率的な存在確認

この章では、EXISTS演算子の詳細な使い方、パフォーマンス特性、そして実践的な活用方法について深く学びます。

## EXISTS演算子とは

EXISTS演算子は、サブクエリが少なくとも1行の結果を返すかどうかをチェックする演算子です。結果の値そのものは重要ではなく、「存在するかどうか」だけが評価されます。

> **用語解説**：
> - **EXISTS**：サブクエリが少なくとも1行の結果を返すかどうかをチェックする演算子です。
> - **NOT EXISTS**：サブクエリが結果を1行も返さないかどうかをチェックする演算子です。
> - **存在確認**：データが存在するかどうかを確認することで、値そのものではなく存在の有無だけを調べる操作です。

### EXISTSの特徴

1. **真偽値の返却**：EXISTSは常にTRUE（真）またはFALSE（偽）を返します。
2. **効率的な処理**：サブクエリが1行でも条件に一致すれば、それ以上の検索を停止します（ショートサーキット評価）。
3. **NULLに影響されない**：サブクエリの結果にNULL値が含まれていても正常に動作します。
4. **相関サブクエリとの相性**：外部クエリとの相関関係を持つサブクエリと組み合わせて使用されることが多いです。

## EXISTS演算子の基本構文

```sql
SELECT カラム1, カラム2, ...
FROM テーブル1
WHERE EXISTS (
    SELECT 1  -- または任意のカラム
    FROM テーブル2
    WHERE 条件
);
```

EXISTSのサブクエリでは、`SELECT 1`や`SELECT *`のように書くのが一般的です。実際の値は使用されないため、どのような値を SELECT しても結果は同じです。

## EXISTS演算子の基本例

### 例1：EXISTSの基本的な使用

成績記録がある学生のみを取得：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
)
ORDER BY s.student_id;
```

このクエリでは：
1. 外部クエリでstudentsテーブルから各学生を処理します。
2. 各学生に対して、サブクエリでその学生の成績記録があるかチェックします。
3. 成績記録が存在する学生のみが結果に含まれます。

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 306        | 河田咲奈     |
| ...        | ...          |

### 例2：NOT EXISTSの使用

成績記録がない学生を取得：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
)
ORDER BY s.student_id;
```

NOT EXISTSは、サブクエリが結果を1行も返さない場合にTRUEを返します。

実行結果：

| student_id | student_name |
|------------|--------------|
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |
| 309        | 相沢吉夫     |
| 312        | 佐々木優斗   |
| ...        | ...          |

## EXISTS vs IN：違いとパフォーマンス

EXISTSとINは、似たような結果を得ることができる場合がありますが、重要な違いがあります。

### 例3：EXISTSとINの比較

#### EXISTSを使用した場合：
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
    AND sc.course_id = '1'
);
```

#### INを使用した場合：
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT sc.student_id
    FROM student_courses sc
    WHERE sc.course_id = '1'
);
```

### EXISTSとINの主な違い

| 項目 | EXISTS | IN |
|------|--------|-----|
| **NULL値の扱い** | NULL値に影響されない | サブクエリにNULLが含まれると予期しない結果になることがある |
| **パフォーマンス** | 1行見つかると検索停止（効率的） | 場合によってはすべての結果を評価する必要がある |
| **相関サブクエリ** | 外部クエリとの相関関係を自然に表現できる | 相関関係の表現が複雑になる場合がある |
| **重複の扱い** | 重複を気にする必要がない | サブクエリの重複が結果に影響することがある |

### NULL値の問題例

INでの問題例：
```sql
-- NOT INでNULL値が含まれる場合の問題
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id NOT IN (
    SELECT sc.student_id
    FROM student_courses sc
    WHERE sc.course_id = '999'  -- 存在しない講座ID
);
-- 上記クエリは期待通りに動作しない可能性があります（NULLが含まれる場合）
```

NOT EXISTSを使用した場合：
```sql
-- NOT EXISTSは安全に動作します
SELECT s.student_id, s.student_name
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
    AND sc.course_id = '999'
);
```

## 複雑な存在確認パターン

### 例4：複数条件の存在確認

中間テストとレポート1の両方を提出している学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g1
    WHERE g1.student_id = s.student_id
    AND g1.grade_type = '中間テスト'
)
AND EXISTS (
    SELECT 1
    FROM grades g2
    WHERE g2.student_id = s.student_id
    AND g2.grade_type = 'レポート1'
)
ORDER BY s.student_id;
```

このクエリでは、各学生について「中間テストがある」AND「レポート1がある」という2つの条件をそれぞれ別のEXISTS句でチェックしています。

### 例5：条件付き存在確認

85点以上の成績を少なくとも1つ持つ学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
    AND g.score >= 85
)
ORDER BY s.student_id;
```

### 例6：複雑な相関条件

各講座において平均点以上を取った学生を検索：

```sql
SELECT DISTINCT s.student_id, s.student_name, c.course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
    AND g.course_id = sc.course_id
    AND g.score >= (
        SELECT AVG(score)
        FROM grades g2
        WHERE g2.course_id = g.course_id
    )
)
ORDER BY s.student_id, c.course_name;
```

このクエリでは、EXISTSサブクエリの中にさらにサブクエリが含まれており、各講座の平均点と比較しています。

## NOT EXISTSの高度な活用

NOT EXISTSは、「〜が存在しない」という条件を表現するために使用され、データの欠損や未達成条件の特定に非常に有効です。

### 例7：完全な条件の否定

すべての講座で80点以上を取っている学生（80点未満の成績が存在しない学生）を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 少なくとも1つの成績記録がある
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
)
AND NOT EXISTS (
    -- 80点未満の成績が存在しない
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
    AND g.score < 80
)
ORDER BY s.student_id;
```

### 例8：関連データの完全性チェック

受講しているすべての講座に出席している学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 受講している講座がある
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
)
AND NOT EXISTS (
    -- 欠席した授業が存在しない
    SELECT 1
    FROM student_courses sc
    JOIN course_schedule cs ON sc.course_id = cs.course_id
    WHERE sc.student_id = s.student_id
    AND NOT EXISTS (
        SELECT 1
        FROM attendance a
        WHERE a.student_id = sc.student_id
        AND a.schedule_id = cs.schedule_id
        AND a.status = 'present'
    )
)
ORDER BY s.student_id;
```

## EXISTS演算子を使った実践的なクエリパターン

### 例9：階層的な存在確認

特定の教師が担当する講座を受講し、かつその講座で良い成績を収めている学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM student_courses sc
    JOIN courses c ON sc.course_id = c.course_id
    JOIN teachers t ON c.teacher_id = t.teacher_id
    WHERE sc.student_id = s.student_id
    AND t.teacher_name = '寺内鞍'
    AND EXISTS (
        SELECT 1
        FROM grades g
        WHERE g.student_id = s.student_id
        AND g.course_id = sc.course_id
        AND g.score >= 85
    )
)
ORDER BY s.student_id;
```

### 例10：時系列での存在確認

最近の授業（直近30日間）で欠席したことがない学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 直近30日間に授業がある
    SELECT 1
    FROM student_courses sc
    JOIN course_schedule cs ON sc.course_id = cs.course_id
    WHERE sc.student_id = s.student_id
    AND cs.schedule_date >= CURRENT_DATE - INTERVAL 30 DAY
)
AND NOT EXISTS (
    -- 直近30日間で欠席していない
    SELECT 1
    FROM student_courses sc
    JOIN course_schedule cs ON sc.course_id = cs.course_id
    LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id 
                           AND a.student_id = s.student_id
    WHERE sc.student_id = s.student_id
    AND cs.schedule_date >= CURRENT_DATE - INTERVAL 30 DAY
    AND (a.status IS NULL OR a.status != 'present')
)
ORDER BY s.student_id;
```

## EXISTS演算子のパフォーマンス最適化

EXISTSを効率的に使用するためのポイントを説明します。

### 1. インデックスの活用

EXISTS句で使用される結合条件にはインデックスを設定することが重要です：

```sql
-- 効率的なEXISTSクエリの例
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id  -- student_idにインデックスが必要
    AND g.score >= 90
);
```

### 2. 適切な条件の配置

より選択性の高い条件を先に配置することで、処理を効率化できます：

```sql
-- 効率的な条件の配置
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.score >= 95  -- 選択性の高い条件を先に
    AND g.student_id = s.student_id  -- 結合条件を後に
);
```

### 3. 不要な結合の回避

EXISTSではサブクエリの結果値が使用されないため、必要最小限の結合にとどめます：

```sql
-- 効率的なEXISTSクエリ
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
    AND sc.course_id = '1'
    -- 不要な結合（coursesテーブルなど）は行わない
);
```

## EXISTS演算子と他の手法の使い分け

### 1. EXISTS vs JOIN

#### EXISTSが適している場合：
- 存在確認だけが目的
- 関連テーブルからのデータが不要
- 1対多の関係で重複を避けたい

```sql
-- EXISTS：存在確認のみ
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
);
```

#### JOINが適している場合：
- 関連テーブルからのデータも取得したい
- パフォーマンスが重要
- 集計などの追加処理が必要

```sql
-- JOIN：関連データも取得
SELECT DISTINCT s.student_id, s.student_name, g.score
FROM students s
JOIN grades g ON s.student_id = g.student_id;
```

### 2. EXISTS vs IN

#### EXISTSが適している場合：
- サブクエリにNULL値が含まれる可能性がある
- 相関サブクエリを使用する
- 複雑な条件がある

#### INが適している場合：
- 単純な値のリストとの照合
- サブクエリが非相関で簡潔
- NULLが含まれない確実な場合

## 練習問題

### 問題22-1
EXISTS演算子を使用して、レポート1の成績が90点以上の学生が在籍している講座を取得するSQLを書いてください。結果には講座ID、講座名、担当教師名を含めてください。

### 問題22-2
NOT EXISTS演算子を使用して、2025年5月20日以降の授業にまだ一度も欠席（status = 'absent'）していない学生を取得するSQLを書いてください。ただし、授業に出席した記録がある学生のみを対象とします。

### 問題22-3
EXISTS演算子を使用して、担当しているすべての講座で平均受講者数が10人以上の教師を取得するSQLを書いてください。NOT EXISTSも組み合わせて使用してください。

### 問題22-4
EXISTS演算子を使用して、プログラミング関連の講座（course_id = 3, 4, 8のいずれか）を受講し、かつそのすべての講座で80点以上を取得している学生を取得するSQLを書いてください。

### 問題22-5
EXISTS演算子を使用して、同じ教師が担当する複数の講座を受講している学生を取得するSQLを書いてください。結果には学生ID、学生名、教師名を含めてください。

### 問題22-6
NOT EXISTS演算子を使用して、受講している講座があるにも関わらず、成績記録が一切ない学生を特定するSQLを書いてください。このような学生は成績入力漏れの可能性があります。

## 解答

### 解答22-1
```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE EXISTS (
    SELECT 1
    FROM grades g
    JOIN students s ON g.student_id = s.student_id
    JOIN student_courses sc ON s.student_id = sc.student_id
    WHERE sc.course_id = c.course_id
    AND g.course_id = c.course_id
    AND g.grade_type = 'レポート1'
    AND g.score >= 90
)
ORDER BY c.course_id;
```

### 解答22-2
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 出席記録がある学生
    SELECT 1
    FROM attendance a
    WHERE a.student_id = s.student_id
)
AND NOT EXISTS (
    -- 2025年5月20日以降に欠席していない
    SELECT 1
    FROM attendance a
    JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
    WHERE a.student_id = s.student_id
    AND cs.schedule_date >= '2025-05-20'
    AND a.status = 'absent'
)
ORDER BY s.student_id;
```

### 解答22-3
```sql
SELECT t.teacher_id, t.teacher_name
FROM teachers t
WHERE EXISTS (
    -- 担当講座がある
    SELECT 1
    FROM courses c
    WHERE c.teacher_id = t.teacher_id
)
AND NOT EXISTS (
    -- 受講者数が10人未満の講座が存在しない
    SELECT 1
    FROM courses c
    WHERE c.teacher_id = t.teacher_id
    AND (
        SELECT COUNT(*)
        FROM student_courses sc
        WHERE sc.course_id = c.course_id
    ) < 10
)
ORDER BY t.teacher_id;
```

### 解答22-4
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- プログラミング関連講座を受講している
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
    AND sc.course_id IN ('3', '4', '8')
)
AND NOT EXISTS (
    -- 受講しているプログラミング関連講座で80点未満の成績が存在しない
    SELECT 1
    FROM student_courses sc
    JOIN grades g ON sc.student_id = g.student_id AND sc.course_id = g.course_id
    WHERE sc.student_id = s.student_id
    AND sc.course_id IN ('3', '4', '8')
    AND g.score < 80
)
ORDER BY s.student_id;
```

### 解答22-5
```sql
SELECT DISTINCT s.student_id, s.student_name, t.teacher_name
FROM students s
JOIN student_courses sc1 ON s.student_id = sc1.student_id
JOIN courses c1 ON sc1.course_id = c1.course_id
JOIN teachers t ON c1.teacher_id = t.teacher_id
WHERE EXISTS (
    -- 同じ教師が担当する別の講座も受講している
    SELECT 1
    FROM student_courses sc2
    JOIN courses c2 ON sc2.course_id = c2.course_id
    WHERE sc2.student_id = s.student_id
    AND c2.teacher_id = t.teacher_id
    AND sc2.course_id != sc1.course_id
)
ORDER BY s.student_id, t.teacher_name;
```

### 解答22-6
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 受講している講座がある
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
)
AND NOT EXISTS (
    -- 成績記録が存在しない
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
)
ORDER BY s.student_id;
```

## まとめ

この章では、EXISTS演算子について詳しく学びました：

1. **EXISTS演算子の基本概念**：
   - レコードの存在確認に特化した演算子
   - TRUE/FALSEの真偽値を返し、値そのものは評価しない
   - ショートサーキット評価による効率的な処理

2. **EXISTS vs IN の違い**：
   - NULL値の扱いにおける安全性の違い
   - パフォーマンス特性の違い
   - 相関サブクエリとの親和性

3. **NOT EXISTSの活用**：
   - 否定条件の表現
   - データの欠損や未達成条件の特定
   - 完全性チェックの実装

4. **複雑な存在確認パターン**：
   - 複数条件の組み合わせ
   - 階層的な存在確認
   - 条件付き存在確認

5. **パフォーマンス最適化**：
   - インデックスの重要性
   - 効率的な条件配置
   - 不要な結合の回避

6. **他の手法との使い分け**：
   - EXISTS vs JOIN の適切な選択
   - EXISTS vs IN の使い分け基準

EXISTS演算子は、データの存在確認において非常に強力で安全な方法を提供します。特に、NULL値の扱いやパフォーマンスの観点から、多くの場面でINよりも適切な選択となります。適切に使用することで、複雑な条件でのデータ検索や関連性の確認が効率的に行えるようになります。

次の章では、「CASE式：条件分岐による値の変換」について学び、SQLでの条件付きロジックの実装方法を深く理解していきます。



---

# 23. CASE式：条件分岐による値の変換

## はじめに

これまでの章で、サブクエリや EXISTS演算子など、SQLの高度な検索技術について学んできました。しかし、実際のデータ分析では、取得したデータを条件に応じて変換・分類する必要があることが多くあります。

例えば以下のような場合です：
- 「点数を文字等級（A、B、C、D、F）に変換したい」
- 「出席状況を『良好』『要注意』『問題あり』に分類したい」
- 「時間帯によって授業を『午前』『午後』『夜間』に分類したい」
- 「条件に応じて異なる計算を行いたい」

このような条件分岐による値の変換を実現するのが「CASE式」です。CASE式は、SQLにおけるプログラミング言語の「if-then-else」文に相当する機能で、条件に応じて異なる値を返すことができます。

この章では、CASE式の基本概念から高度な活用方法まで、実践的な例を通して詳しく学びます。

## CASE式とは

CASE式は、複数の条件を評価し、条件に応じて異なる値を返すSQL構文です。プログラミング言語の条件分岐（if-then-else）と同様の機能を提供します。

> **用語解説**：
> - **CASE式**：条件に応じて異なる値を返すSQL構文で、条件分岐を実現します。
> - **単純CASE式**：特定のカラムの値と複数の値を比較するCASE式です。
> - **検索CASE式**：複雑な条件式を評価できるCASE式です。
> - **WHEN句**：「〜の場合」という条件を指定する部分です。
> - **THEN句**：条件が真の場合に返される値を指定する部分です。
> - **ELSE句**：すべての条件が偽の場合に返される値を指定する部分です（省略可能）。

## CASE式の基本構文

CASE式には2つの形式があります：

### 1. 単純CASE式（Simple CASE）

```sql
CASE カラム名
    WHEN 値1 THEN 結果1
    WHEN 値2 THEN 結果2
    WHEN 値3 THEN 結果3
    ELSE デフォルト値
END
```

### 2. 検索CASE式（Searched CASE）

```sql
CASE
    WHEN 条件1 THEN 結果1
    WHEN 条件2 THEN 結果2
    WHEN 条件3 THEN 結果3
    ELSE デフォルト値
END
```

検索CASE式の方がより柔軟で一般的に使用されます。

## CASE式の基本例

### 例1：成績の等級変換（検索CASE式）

点数を文字等級に変換してみましょう：

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    CASE
        WHEN g.score >= 90 THEN 'A'
        WHEN g.score >= 80 THEN 'B'
        WHEN g.score >= 70 THEN 'C'
        WHEN g.score >= 60 THEN 'D'
        ELSE 'F'
    END AS 等級
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY g.score DESC;
```

実行結果：

| 学生名     | 講座名                 | 点数 | 等級 |
|------------|------------------------|------|------|
| 鈴木健太   | ITのための基礎知識     | 95.0 | A    |
| 松本さくら | ITのための基礎知識     | 93.5 | A    |
| 新垣愛留   | ITのための基礎知識     | 92.0 | A    |
| 永田悦子   | ITのための基礎知識     | 91.0 | A    |
| 河田咲奈   | ITのための基礎知識     | 88.0 | B    |
| 黒沢春馬   | ITのための基礎知識     | 85.5 | B    |
| ...        | ...                    | ...  | ...  |

### 例2：出席状況の分類（単純CASE式）

出席状況を日本語に変換：

```sql
SELECT 
    s.student_name AS 学生名,
    cs.schedule_date AS 日付,
    CASE a.status
        WHEN 'present' THEN '出席'
        WHEN 'absent' THEN '欠席'
        WHEN 'late' THEN '遅刻'
        ELSE '不明'
    END AS 出席状況
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE cs.schedule_date = '2025-05-20'
ORDER BY s.student_name;
```

実行結果：

| 学生名     | 日付       | 出席状況 |
|------------|------------|----------|
| 黒沢春馬   | 2025-05-20 | 出席     |
| 新垣愛留   | 2025-05-20 | 遅刻     |
| 柴崎春花   | 2025-05-20 | 出席     |
| 森下風凛   | 2025-05-20 | 欠席     |
| ...        | ...        | ...      |

## SELECT句でのCASE式の活用

### 例3：複雑な条件による分類

学生の学習状況を総合的に評価：

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    AVG(g.score) AS 平均点,
    COUNT(DISTINCT sc.course_id) AS 受講講座数,
    AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0.0 END) * 100 AS 出席率,
    CASE
        WHEN AVG(g.score) >= 85 AND 
             AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0.0 END) >= 0.9 THEN '優秀'
        WHEN AVG(g.score) >= 75 AND 
             AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0.0 END) >= 0.8 THEN '良好'
        WHEN AVG(g.score) >= 65 OR 
             AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0.0 END) >= 0.7 THEN '普通'
        ELSE '要指導'
    END AS 総合評価
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
WHERE s.student_id BETWEEN 301 AND 310
GROUP BY s.student_id, s.student_name
ORDER BY AVG(g.score) DESC;
```

実行結果：

| student_id | 学生名     | 平均点 | 受講講座数 | 出席率 | 総合評価 |
|------------|------------|--------|------------|--------|----------|
| 311        | 鈴木健太   | 89.8   | 6          | 92.5   | 優秀     |
| 302        | 新垣愛留   | 86.5   | 7          | 88.9   | 良好     |
| 308        | 永田悦子   | 85.9   | 5          | 95.0   | 優秀     |
| 301        | 黒沢春馬   | 82.3   | 8          | 85.7   | 良好     |
| ...        | ...        | ...    | ...        | ...    | ...      |

### 例4：時間帯による授業の分類

```sql
SELECT 
    c.course_name AS 講座名,
    cp.start_time AS 開始時間,
    CASE
        WHEN cp.start_time < '12:00:00' THEN '午前'
        WHEN cp.start_time < '17:00:00' THEN '午後'
        ELSE '夜間'
    END AS 時間帯,
    COUNT(*) AS 授業回数
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN class_periods cp ON cs.period_id = cp.period_id
GROUP BY c.course_name, cp.start_time
ORDER BY c.course_name, cp.start_time;
```

## WHERE句でのCASE式

CASE式はWHERE句でも使用できます。これにより、複雑な条件を分かりやすく表現できます。

### 例5：条件付きフィルタリング

成績のタイプに応じて異なる合格基準を適用：

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.grade_type AS 評価タイプ,
    g.score AS 点数,
    CASE g.grade_type
        WHEN '中間テスト' THEN 70
        WHEN 'レポート1' THEN 60
        WHEN '最終評価' THEN 75
        ELSE 65
    END AS 合格基準
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.score >= CASE g.grade_type
                    WHEN '中間テスト' THEN 70
                    WHEN 'レポート1' THEN 60
                    WHEN '最終評価' THEN 75
                    ELSE 65
                 END
ORDER BY s.student_name, c.course_name;
```

## ORDER BY句でのCASE式

ORDER BY句でCASE式を使用することで、カスタムソート順を実現できます。

### 例6：カスタムソート順

出席状況を優先度順でソート：

```sql
SELECT 
    s.student_name AS 学生名,
    cs.schedule_date AS 日付,
    CASE a.status
        WHEN 'present' THEN '出席'
        WHEN 'late' THEN '遅刻'
        WHEN 'absent' THEN '欠席'
        ELSE '不明'
    END AS 出席状況
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE cs.schedule_date = '2025-05-20'
ORDER BY 
    CASE a.status
        WHEN 'absent' THEN 1   -- 欠席を最初に
        WHEN 'late' THEN 2     -- 遅刻を次に
        WHEN 'present' THEN 3  -- 出席を最後に
        ELSE 4
    END,
    s.student_name;
```

### 例7：成績タイプのカスタムソート

```sql
SELECT 
    s.student_name AS 学生名,
    g.grade_type AS 評価タイプ,
    g.score AS 点数
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE s.student_id = 301
ORDER BY 
    CASE g.grade_type
        WHEN '中間テスト' THEN 1
        WHEN 'レポート1' THEN 2
        WHEN '課題1' THEN 3
        WHEN '最終評価' THEN 4
        ELSE 5
    END;
```

## 集計関数とCASE式の組み合わせ

CASE式を集計関数と組み合わせることで、条件付き集計が可能になります。

### 例8：条件付きカウント

各講座の出席状況別人数を集計：

```sql
SELECT 
    c.course_name AS 講座名,
    cs.schedule_date AS 日付,
    COUNT(*) AS 受講者数,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS 出席者数,
    SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS 遅刻者数,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS 欠席者数,
    ROUND(SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS 出席率
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
WHERE cs.schedule_date = '2025-05-20'
GROUP BY c.course_name, cs.schedule_date
ORDER BY 出席率 DESC;
```

実行結果：

| 講座名                 | 日付       | 受講者数 | 出席者数 | 遅刻者数 | 欠席者数 | 出席率 |
|------------------------|------------|----------|----------|----------|----------|--------|
| データベース設計と実装 | 2025-05-20 | 8        | 7        | 1        | 0        | 87.5   |
| ITのための基礎知識     | 2025-05-20 | 12       | 9        | 2        | 1        | 75.0   |
| AI・機械学習入門       | 2025-05-20 | 10       | 7        | 1        | 2        | 70.0   |
| ...                    | ...        | ...      | ...      | ...      | ...      | ...    |

### 例9：成績レベル別の統計

```sql
SELECT 
    c.course_name AS 講座名,
    COUNT(*) AS 総受験者数,
    SUM(CASE WHEN g.score >= 90 THEN 1 ELSE 0 END) AS A評価数,
    SUM(CASE WHEN g.score >= 80 AND g.score < 90 THEN 1 ELSE 0 END) AS B評価数,
    SUM(CASE WHEN g.score >= 70 AND g.score < 80 THEN 1 ELSE 0 END) AS C評価数,
    SUM(CASE WHEN g.score >= 60 AND g.score < 70 THEN 1 ELSE 0 END) AS D評価数,
    SUM(CASE WHEN g.score < 60 THEN 1 ELSE 0 END) AS F評価数,
    ROUND(AVG(g.score), 1) AS 平均点
FROM grades g
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
GROUP BY c.course_name
ORDER BY 平均点 DESC;
```

実行結果：

| 講座名                 | 総受験者数 | A評価数 | B評価数 | C評価数 | D評価数 | F評価数 | 平均点 |
|------------------------|------------|---------|---------|---------|---------|---------|--------|
| ITのための基礎知識     | 12         | 4       | 5       | 2       | 1       | 0       | 86.2   |
| データベース設計と実装 | 7          | 2       | 3       | 2       | 0       | 0       | 82.3   |
| AI・機械学習入門       | 8          | 2       | 2       | 3       | 1       | 0       | 78.9   |
| ...                    | ...        | ...     | ...     | ...     | ...     | ...     | ...    |

## CASE式のネスト（入れ子）

CASE式の中に別のCASE式を含めることで、より複雑な条件分岐を表現できます。

### 例10：複雑な成績評価システム

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    CASE g.grade_type
        WHEN '中間テスト' THEN
            CASE
                WHEN g.score >= 95 THEN 'A+'
                WHEN g.score >= 90 THEN 'A'
                WHEN g.score >= 85 THEN 'A-'
                WHEN g.score >= 80 THEN 'B+'
                WHEN g.score >= 75 THEN 'B'
                WHEN g.score >= 70 THEN 'B-'
                WHEN g.score >= 65 THEN 'C+'
                WHEN g.score >= 60 THEN 'C'
                ELSE 'F'
            END
        WHEN 'レポート1' THEN
            CASE
                WHEN g.score >= 90 THEN 'A'
                WHEN g.score >= 80 THEN 'B'
                WHEN g.score >= 70 THEN 'C'
                WHEN g.score >= 60 THEN 'D'
                ELSE 'F'
            END
        ELSE
            CASE
                WHEN g.score >= 85 THEN 'A'
                WHEN g.score >= 75 THEN 'B'
                WHEN g.score >= 65 THEN 'C'
                WHEN g.score >= 55 THEN 'D'
                ELSE 'F'
            END
    END AS 等級
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
ORDER BY s.student_name, c.course_name, g.grade_type;
```

## NULL値の処理

CASE式では、NULL値を適切に処理することが重要です。

### 例11：NULL値を含む条件分岐

```sql
SELECT 
    s.student_name AS 学生名,
    sc.course_id AS 講座ID,
    CASE
        WHEN g.score IS NULL THEN '未提出'
        WHEN g.score >= 80 THEN '合格'
        WHEN g.score >= 60 THEN '条件付き合格'
        ELSE '不合格'
    END AS 結果,
    COALESCE(g.score, 0) AS 点数
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN grades g ON s.student_id = g.student_id 
                   AND sc.course_id = g.course_id 
                   AND g.grade_type = '中間テスト'
WHERE s.student_id BETWEEN 301 AND 305
ORDER BY s.student_name, sc.course_id;
```

## CASE式の実践的な応用例

### 例12：学習進捗ダッシュボード

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    COUNT(DISTINCT sc.course_id) AS 受講講座数,
    CASE
        WHEN COUNT(DISTINCT sc.course_id) >= 8 THEN '多い'
        WHEN COUNT(DISTINCT sc.course_id) >= 5 THEN '適正'
        WHEN COUNT(DISTINCT sc.course_id) >= 3 THEN '少ない'
        ELSE '非常に少ない'
    END AS 履修状況,
    ROUND(AVG(CASE WHEN g.score IS NOT NULL THEN g.score END), 1) AS 平均点,
    CASE
        WHEN AVG(CASE WHEN g.score IS NOT NULL THEN g.score END) IS NULL THEN '未評価'
        WHEN AVG(CASE WHEN g.score IS NOT NULL THEN g.score END) >= 85 THEN '優秀'
        WHEN AVG(CASE WHEN g.score IS NOT NULL THEN g.score END) >= 75 THEN '良好'
        WHEN AVG(CASE WHEN g.score IS NOT NULL THEN g.score END) >= 65 THEN '普通'
        ELSE '要改善'
    END AS 成績評価,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    CASE
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90 THEN '良好'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80 THEN '普通'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 70 THEN '要注意'
        ELSE '問題あり'
    END AS 出席評価
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
WHERE s.student_id BETWEEN 301 AND 310
GROUP BY s.student_id, s.student_name
ORDER BY s.student_id;
```

## CASE式のパフォーマンス考慮点

CASE式を効率的に使用するためのポイント：

1. **条件の順序**：最も頻繁に該当する条件を最初に配置することで、評価回数を減らせます。

2. **複雑な条件の分解**：非常に複雑なCASE式は、複数のステップに分解したり、一時テーブルを使用したりすることを検討しましょう。

3. **インデックスの活用**：CASE式で使用するカラムにインデックスがある場合、WHERE句でそのカラムを直接使用することも検討しましょう。

### パフォーマンス改善の例：

```sql
-- 効率的なCASE式の例（頻度の高い条件を先に）
SELECT 
    student_name,
    CASE
        WHEN score >= 70 THEN '合格'      -- 最も頻度が高い
        WHEN score >= 60 THEN '条件付き'   -- 次に頻度が高い
        WHEN score IS NULL THEN '未受験'   -- まれなケース
        ELSE '不合格'                     -- 最も少ない
    END AS 結果
FROM students s
JOIN grades g ON s.student_id = g.student_id;
```

## 練習問題

### 問題23-1
CASE式を使用して、講座の受講者数を「多い」（15人以上）、「普通」（10〜14人）、「少ない」（5〜9人）、「非常に少ない」（4人以下）に分類するSQLを書いてください。結果には講座ID、講座名、受講者数、分類を含めてください。

### 問題23-2
CASE式を使用して、各学生の出席率を計算し、「優秀」（90%以上）、「良好」（80%以上）、「普通」（70%以上）、「要改善」（70%未満）に分類するSQLを書いてください。出席率も合わせて表示してください。

### 問題23-3
CASE式を使用して、教師の担当負荷を「重い」（4講座以上）、「適正」（2〜3講座）、「軽い」（1講座）、「なし」（担当なし）に分類するSQLを書いてください。結果には教師ID、教師名、担当講座数、負荷分類を含めてください。

### 問題23-4
CASE式と集計関数を組み合わせて、各講座について成績分布を分析するSQLを書いてください。「90点以上」「80-89点」「70-79点」「60-69点」「60点未満」「未提出」の各カテゴリの人数を表示してください。

### 問題23-5
CASE式を使用して、学生の学習パフォーマンスを総合評価するSQLを書いてください。平均点と出席率の両方を考慮し、以下の基準で評価してください：
- 平均点85点以上かつ出席率90%以上：「S」
- 平均点75点以上かつ出席率80%以上：「A」  
- 平均点65点以上かつ出席率70%以上：「B」
- それ以外：「C」

### 問題23-6
CASE式を使用して、時間割を見やすく整理するSQLを書いてください。授業時間を「1限目」「2限目」...として表示し、教室を建物別（1号館、2号館など）に分類して、曜日別に整理してください。2025年5月21日の授業スケジュールを対象とします。

## 解答

### 解答23-1
```sql
SELECT 
    c.course_id,
    c.course_name AS 講座名,
    COUNT(sc.student_id) AS 受講者数,
    CASE
        WHEN COUNT(sc.student_id) >= 15 THEN '多い'
        WHEN COUNT(sc.student_id) >= 10 THEN '普通'
        WHEN COUNT(sc.student_id) >= 5 THEN '少ない'
        ELSE '非常に少ない'
    END AS 分類
FROM courses c
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name
ORDER BY 受講者数 DESC;
```

### 解答23-2
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    CASE
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90 THEN '優秀'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80 THEN '良好'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 70 THEN '普通'
        ELSE '要改善'
    END AS 出席評価
FROM students s
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING COUNT(a.student_id) > 0  -- 出席記録がある学生のみ
ORDER BY 出席率 DESC;
```

### 解答23-3
```sql
SELECT 
    t.teacher_id,
    t.teacher_name AS 教師名,
    COUNT(c.course_id) AS 担当講座数,
    CASE
        WHEN COUNT(c.course_id) >= 4 THEN '重い'
        WHEN COUNT(c.course_id) >= 2 THEN '適正'
        WHEN COUNT(c.course_id) = 1 THEN '軽い'
        ELSE 'なし'
    END AS 負荷分類
FROM teachers t
LEFT JOIN courses c ON t.teacher_id = c.teacher_id
GROUP BY t.teacher_id, t.teacher_name
ORDER BY 担当講座数 DESC;
```

### 解答23-4
```sql
SELECT 
    c.course_id,
    c.course_name AS 講座名,
    SUM(CASE WHEN g.score >= 90 THEN 1 ELSE 0 END) AS '90点以上',
    SUM(CASE WHEN g.score >= 80 AND g.score < 90 THEN 1 ELSE 0 END) AS '80-89点',
    SUM(CASE WHEN g.score >= 70 AND g.score < 80 THEN 1 ELSE 0 END) AS '70-79点',
    SUM(CASE WHEN g.score >= 60 AND g.score < 70 THEN 1 ELSE 0 END) AS '60-69点',
    SUM(CASE WHEN g.score < 60 THEN 1 ELSE 0 END) AS '60点未満',
    (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) - 
    COUNT(g.score) AS 未提出
FROM courses c
LEFT JOIN grades g ON c.course_id = g.course_id AND g.grade_type = '中間テスト'
GROUP BY c.course_id, c.course_name
ORDER BY c.course_id;
```

### 解答23-5
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    ROUND(AVG(g.score), 1) AS 平均点,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    CASE
        WHEN AVG(g.score) >= 85 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90 THEN 'S'
        WHEN AVG(g.score) >= 75 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80 THEN 'A'
        WHEN AVG(g.score) >= 65 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 70 THEN 'B'
        ELSE 'C'
    END AS 総合評価
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING COUNT(DISTINCT g.grade_id) > 0 AND COUNT(DISTINCT a.schedule_id) > 0
ORDER BY 総合評価, 平均点 DESC;
```

### 解答23-6
```sql
SELECT 
    CASE cp.period_id
        WHEN 1 THEN '1限目'
        WHEN 2 THEN '2限目'
        WHEN 3 THEN '3限目'
        WHEN 4 THEN '4限目'
        WHEN 5 THEN '5限目'
        ELSE CONCAT(cp.period_id, '限目')
    END AS 時限,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間,
    c.course_name AS 講座名,
    cl.classroom_name AS 教室名,
    CASE
        WHEN cl.building LIKE '1号館%' THEN '1号館'
        WHEN cl.building LIKE '2号館%' THEN '2号館'
        WHEN cl.building LIKE '3号館%' THEN '3号館'
        WHEN cl.building LIKE '4号館%' THEN '4号館'
        ELSE cl.building
    END AS 建物,
    t.teacher_name AS 担当教師
FROM course_schedule cs
JOIN class_periods cp ON cs.period_id = cp.period_id
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
WHERE cs.schedule_date = '2025-05-21'
ORDER BY cp.period_id, cl.building, cl.classroom_name;
```

## まとめ

この章では、CASE式について詳しく学びました：

1. **CASE式の基本概念**：
   - 条件分岐による値の変換を実現するSQL構文
   - 単純CASE式と検索CASE式の2つの形式
   - プログラミング言語のif-then-else文に相当する機能

2. **CASE式の基本構文**：
   - WHEN-THEN-ELSE-ENDの基本構造
   - 複数条件の評価順序
   - ELSE句の省略とNULL値の扱い

3. **様々な場面でのCASE式の活用**：
   - SELECT句での値の変換と分類
   - WHERE句での複雑な条件指定
   - ORDER BY句でのカスタムソート順

4. **集計関数との組み合わせ**：
   - 条件付きカウントとSUM関数
   - カテゴリ別の統計集計
   - 複雑な分析レポートの作成

5. **高度なCASE式の使用法**：
   - ネストしたCASE式
   - NULL値の適切な処理
   - 複雑な条件分岐の実装

6. **実践的な応用例**：
   - 成績の等級変換システム
   - 学習進捗ダッシュボード
   - 出席状況の分類と分析

7. **パフォーマンスの考慮点**：
   - 条件の順序の最適化
   - 複雑なCASE式の分解方法
   - インデックスの効果的な活用

CASE式は、データの分類、変換、条件付き処理において非常に強力なツールです。適切に使用することで、複雑なビジネスロジックをSQLで直接実装でき、レポート作成やデータ分析の効率を大幅に向上させることができます。

次の章では、「ウィンドウ関数：OVER句とパーティション」について学び、より高度な分析機能を理解していきます。



---

# 24. ウィンドウ関数：OVER句とパーティション

## はじめに

これまでの章で、CASE式による条件分岐について学びました。SQLには、さらに高度な分析機能として「ウィンドウ関数」があります。ウィンドウ関数は、データ分析やレポート作成において非常に強力で、従来のGROUP BYでは実現が困難な複雑な集計や順位付けを可能にします。

ウィンドウ関数が活躍する場面の例：
- 「各学生の成績順位を求めたい」
- 「講座ごとの成績ランキングを作成したい」
- 「前回のテスト結果と今回の結果を比較したい」
- 「各月の累積出席者数を計算したい」
- 「移動平均を求めたい」

通常の集計関数（SUM、AVG、COUNT等）では、GROUP BYを使用すると元の行数が減ってしまいますが、ウィンドウ関数では元の行構造を保ったまま集計結果を取得できます。

この章では、ウィンドウ関数の基本概念から実践的な活用方法まで、詳しく学んでいきます。

## ウィンドウ関数とは

ウィンドウ関数は、指定された「ウィンドウ」（行の範囲）に対して計算を行う関数です。通常の集計関数と異なり、結果セットの行数を変更せず、各行に対して集計値や順位などの情報を追加できます。

> **用語解説**：
> - **ウィンドウ関数**：指定された行の範囲（ウィンドウ）に対して計算を行い、元の行構造を保ったまま結果を返す関数です。
> - **OVER句**：ウィンドウ関数でウィンドウの範囲や順序を指定する句です。
> - **パーティション**：データをグループに分割する仕組みで、各グループ内でウィンドウ関数が計算されます。
> - **ウィンドウフレーム**：各行において、計算対象となる行の範囲を指定します。
> - **順位関数**：ROW_NUMBER()、RANK()、DENSE_RANK()など、行に順位を付ける関数です。
> - **分析関数**：LAG()、LEAD()、FIRST_VALUE()、LAST_VALUE()など、行間の比較や分析を行う関数です。

## ウィンドウ関数の基本構文

```sql
関数名() OVER (
    [PARTITION BY カラム1, カラム2, ...]
    [ORDER BY カラム1 [ASC|DESC], カラム2 [ASC|DESC], ...]
    [フレーム指定]
)
```

### OVER句の構成要素

1. **PARTITION BY**：データをグループに分割（省略可能）
2. **ORDER BY**：ウィンドウ内での行の順序を指定（省略可能）
3. **フレーム指定**：計算対象の行範囲を指定（省略可能）

## 順位関数（Ranking Functions）

### ROW_NUMBER()

ROW_NUMBER()は、ウィンドウ内で各行に連続した番号を割り当てます。

### 例1：全体での成績順位

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    ROW_NUMBER() OVER (ORDER BY g.score DESC) AS 全体順位
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY g.score DESC;
```

実行結果：

| 学生名     | 講座名                 | 点数 | 全体順位 |
|------------|------------------------|------|----------|
| 鈴木健太   | ITのための基礎知識     | 95.0 | 1        |
| 松本さくら | ITのための基礎知識     | 93.5 | 2        |
| 新垣愛留   | ITのための基礎知識     | 92.0 | 3        |
| 永田悦子   | ITのための基礎知識     | 91.0 | 4        |
| 中村彩香   | AI・機械学習入門       | 89.5 | 5        |
| ...        | ...                    | ...  | ...      |

### 例2：講座別での成績順位（PARTITION BY）

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    ROW_NUMBER() OVER (PARTITION BY c.course_id ORDER BY g.score DESC) AS 講座内順位
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY c.course_name, g.score DESC;
```

実行結果：

| 学生名     | 講座名                 | 点数 | 講座内順位 |
|------------|------------------------|------|------------|
| 新垣愛留   | AI・機械学習入門       | 91.0 | 1          |
| 中村彩香   | AI・機械学習入門       | 89.5 | 2          |
| 吉川伽羅   | AI・機械学習入門       | 82.5 | 3          |
| ...        | ...                    | ...  | ...        |
| 鈴木健太   | ITのための基礎知識     | 95.0 | 1          |
| 松本さくら | ITのための基礎知識     | 93.5 | 2          |
| 新垣愛留   | ITのための基礎知識     | 92.0 | 3          |
| ...        | ...                    | ...  | ...        |

PARTITION BYを使用することで、各講座内での順位を個別に計算できます。

### RANK()とDENSE_RANK()

- **RANK()**：同順位がある場合、次の順位をスキップします
- **DENSE_RANK()**：同順位がある場合でも、次の順位を連続させます

### 例3：順位関数の比較

```sql
SELECT 
    s.student_name AS 学生名,
    g.score AS 点数,
    ROW_NUMBER() OVER (ORDER BY g.score DESC) AS ROW_NUMBER,
    RANK() OVER (ORDER BY g.score DESC) AS RANK,
    DENSE_RANK() OVER (ORDER BY g.score DESC) AS DENSE_RANK
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE g.grade_type = '中間テスト' AND g.course_id = '1'
ORDER BY g.score DESC;
```

実行結果：

| 学生名     | 点数 | ROW_NUMBER | RANK | DENSE_RANK |
|------------|------|------------|------|------------|
| 鈴木健太   | 95.0 | 1          | 1    | 1          |
| 松本さくら | 93.5 | 2          | 2    | 2          |
| 新垣愛留   | 92.0 | 3          | 3    | 3          |
| 永田悦子   | 91.0 | 4          | 4    | 4          |
| 河田咲奈   | 88.0 | 5          | 5    | 5          |
| 河田咲奈   | 88.0 | 6          | 5    | 5          |
| 黒沢春馬   | 85.5 | 7          | 7    | 6          |
| ...        | ...  | ...        | ...  | ...        |

この例では、河田咲奈が同点の88.0点を取った場合の違いを示しています：
- ROW_NUMBER()：連続した番号（5, 6）
- RANK()：同順位で次をスキップ（5, 5, 7）
- DENSE_RANK()：同順位で次を連続（5, 5, 6）

## 分析関数（Analytic Functions）

### LAG()とLEAD()

LAG()は前の行の値を、LEAD()は次の行の値を取得します。

### 例4：前回テストとの点数比較

```sql
SELECT 
    s.student_name AS 学生名,
    g.grade_type AS テスト種別,
    g.score AS 今回点数,
    LAG(g.score) OVER (PARTITION BY s.student_id ORDER BY 
        CASE g.grade_type 
            WHEN '中間テスト' THEN 1 
            WHEN 'レポート1' THEN 2 
            WHEN '最終評価' THEN 3 
        END) AS 前回点数,
    g.score - LAG(g.score) OVER (PARTITION BY s.student_id ORDER BY 
        CASE g.grade_type 
            WHEN '中間テスト' THEN 1 
            WHEN 'レポート1' THEN 2 
            WHEN '最終評価' THEN 3 
        END) AS 点数変化
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE s.student_id = 301 AND g.course_id = '1'
ORDER BY CASE g.grade_type 
    WHEN '中間テスト' THEN 1 
    WHEN 'レポート1' THEN 2 
    WHEN '最終評価' THEN 3 
END;
```

実行結果：

| 学生名   | テスト種別 | 今回点数 | 前回点数 | 点数変化 |
|----------|------------|----------|----------|----------|
| 黒沢春馬 | 中間テスト | 85.5     | NULL     | NULL     |
| 黒沢春馬 | レポート1  | 85.0     | 85.5     | -0.5     |
| 黒沢春馬 | 最終評価   | 87.0     | 85.0     | 2.0      |

### 例5：月別の出席者数推移

```sql
SELECT 
    DATE_FORMAT(cs.schedule_date, '%Y-%m') AS 年月,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS 今月出席者数,
    LAG(COUNT(CASE WHEN a.status = 'present' THEN 1 END)) 
        OVER (ORDER BY DATE_FORMAT(cs.schedule_date, '%Y-%m')) AS 前月出席者数,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) - 
    LAG(COUNT(CASE WHEN a.status = 'present' THEN 1 END)) 
        OVER (ORDER BY DATE_FORMAT(cs.schedule_date, '%Y-%m')) AS 増減
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY DATE_FORMAT(cs.schedule_date, '%Y-%m')
ORDER BY 年月;
```

## 集計ウィンドウ関数

通常の集計関数（SUM、AVG、COUNT等）もウィンドウ関数として使用できます。

### 例6：累積成績と移動平均

```sql
SELECT 
    s.student_name AS 学生名,
    g.grade_type AS 評価種別,
    g.score AS 点数,
    AVG(g.score) OVER (PARTITION BY s.student_id 
                       ORDER BY CASE g.grade_type 
                           WHEN '中間テスト' THEN 1 
                           WHEN 'レポート1' THEN 2 
                           WHEN '最終評価' THEN 3 
                       END) AS 累積平均,
    SUM(g.score) OVER (PARTITION BY s.student_id 
                       ORDER BY CASE g.grade_type 
                           WHEN '中間テスト' THEN 1 
                           WHEN 'レポート1' THEN 2 
                           WHEN '最終評価' THEN 3 
                       END) AS 累積合計
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE s.student_id = 302 AND g.course_id = '1'
ORDER BY CASE g.grade_type 
    WHEN '中間テスト' THEN 1 
    WHEN 'レポート1' THEN 2 
    WHEN '最終評価' THEN 3 
END;
```

実行結果：

| 学生名   | 評価種別   | 点数 | 累積平均 | 累積合計 |
|----------|------------|------|----------|----------|
| 新垣愛留 | 中間テスト | 92.0 | 92.0     | 92.0     |
| 新垣愛留 | レポート1  | 88.0 | 90.0     | 180.0    |
| 新垣愛留 | 最終評価   | 90.0 | 90.0     | 270.0    |

### 例7：各学生の講座別平均との比較

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 個人点数,
    ROUND(AVG(g.score) OVER (PARTITION BY g.course_id), 1) AS 講座平均,
    ROUND(g.score - AVG(g.score) OVER (PARTITION BY g.course_id), 1) AS 平均との差,
    ROUND(AVG(g.score) OVER (), 1) AS 全体平均
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト' AND s.student_id BETWEEN 301 AND 305
ORDER BY c.course_name, g.score DESC;
```

## フレーム指定（Window Frames）

フレーム指定により、計算対象となる行の範囲をより詳細に制御できます。

### 基本構文

```sql
ROWS BETWEEN 開始位置 AND 終了位置
```

### フレーム境界の指定方法

- `UNBOUNDED PRECEDING`：ウィンドウの最初
- `CURRENT ROW`：現在の行
- `UNBOUNDED FOLLOWING`：ウィンドウの最後
- `n PRECEDING`：現在行からn行前
- `n FOLLOWING`：現在行からn行後

### 例8：移動平均の計算

```sql
SELECT 
    cs.schedule_date AS 日付,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS 出席者数,
    ROUND(AVG(COUNT(CASE WHEN a.status = 'present' THEN 1 END)) 
        OVER (ORDER BY cs.schedule_date 
              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 1) AS 3日移動平均
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY cs.schedule_date
ORDER BY cs.schedule_date;
```

この例では、過去3日間（2 PRECEDING AND CURRENT ROW）の移動平均を計算しています。

### 例9：累積出席率の計算

```sql
SELECT 
    s.student_name AS 学生名,
    cs.schedule_date AS 日付,
    CASE WHEN a.status = 'present' THEN 1 ELSE 0 END AS 出席フラグ,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0 END) 
        OVER (PARTITION BY s.student_id 
              ORDER BY cs.schedule_date 
              ROWS UNBOUNDED PRECEDING) * 100, 1) AS 累積出席率
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN course_schedule cs ON sc.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND s.student_id = a.student_id
WHERE s.student_id = 301
ORDER BY cs.schedule_date;
```

## FIRST_VALUE()とLAST_VALUE()

ウィンドウ内の最初や最後の値を取得できます。

### 例10：各講座での最高点・最低点との比較

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    FIRST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                               ORDER BY g.score DESC 
                               ROWS UNBOUNDED PRECEDING) AS 最高点,
    LAST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                              ORDER BY g.score DESC 
                              ROWS BETWEEN UNBOUNDED PRECEDING 
                              AND UNBOUNDED FOLLOWING) AS 最低点,
    g.score - LAST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                                        ORDER BY g.score DESC 
                                        ROWS BETWEEN UNBOUNDED PRECEDING 
                                        AND UNBOUNDED FOLLOWING) AS 最低点との差
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト' AND g.course_id = '1'
ORDER BY g.score DESC;
```

## ウィンドウ関数の実践的な応用例

### 例11：学生の成績改善状況分析

```sql
WITH student_progress AS (
    SELECT 
        s.student_id,
        s.student_name,
        g.course_id,
        c.course_name,
        g.grade_type,
        g.score,
        ROW_NUMBER() OVER (PARTITION BY s.student_id, g.course_id 
                          ORDER BY CASE g.grade_type 
                              WHEN '中間テスト' THEN 1 
                              WHEN 'レポート1' THEN 2 
                              WHEN '最終評価' THEN 3 
                          END) AS test_order,
        LAG(g.score) OVER (PARTITION BY s.student_id, g.course_id 
                          ORDER BY CASE g.grade_type 
                              WHEN '中間テスト' THEN 1 
                              WHEN 'レポート1' THEN 2 
                              WHEN '最終評価' THEN 3 
                          END) AS prev_score
    FROM grades g
    JOIN students s ON g.student_id = s.student_id
    JOIN courses c ON g.course_id = c.course_id
)
SELECT 
    student_name AS 学生名,
    course_name AS 講座名,
    grade_type AS 評価種別,
    score AS 今回点数,
    prev_score AS 前回点数,
    score - prev_score AS 点数変化,
    CASE 
        WHEN score - prev_score > 10 THEN '大幅改善'
        WHEN score - prev_score > 5 THEN '改善'
        WHEN score - prev_score > -5 THEN '維持'
        WHEN score - prev_score > -10 THEN '低下'
        ELSE '大幅低下'
    END AS 改善状況
FROM student_progress
WHERE prev_score IS NOT NULL
ORDER BY student_name, course_name, test_order;
```

### 例12：講座の人気度ランキング

```sql
SELECT 
    c.course_id,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師,
    COUNT(sc.student_id) AS 受講者数,
    RANK() OVER (ORDER BY COUNT(sc.student_id) DESC) AS 人気ランキング,
    ROUND(AVG(g.score), 1) AS 平均点,
    RANK() OVER (ORDER BY AVG(g.score) DESC) AS 成績ランキング,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    RANK() OVER (ORDER BY AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) DESC) AS 出席率ランキング
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
LEFT JOIN grades g ON sc.student_id = g.student_id AND sc.course_id = g.course_id
LEFT JOIN attendance a ON sc.student_id = a.student_id
GROUP BY c.course_id, c.course_name, t.teacher_name
ORDER BY 人気ランキング;
```

## パフォーマンス考慮点

ウィンドウ関数を効率的に使用するためのポイント：

1. **インデックスの活用**：PARTITION BYやORDER BYで使用するカラムにインデックスを設定
2. **適切なフレーム指定**：必要以上に大きなフレームを指定しない
3. **メモリ使用量**：大きなデータセットでは、ウィンドウ関数がメモリを多く消費する可能性
4. **クエリの最適化**：WHERE句で事前にデータを絞り込む

### パフォーマンス改善の例

```sql
-- 効率的なウィンドウ関数の使用例
SELECT 
    s.student_name,
    g.score,
    RANK() OVER (PARTITION BY g.course_id ORDER BY g.score DESC) AS course_rank
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE g.grade_type = '中間テスト'  -- 事前にフィルタリング
AND g.course_id IN ('1', '2', '3')  -- 必要な講座のみに限定
ORDER BY g.course_id, course_rank;
```

## 練習問題

### 問題24-1
ROW_NUMBER()を使用して、各教師が担当する講座を受講者数の多い順に順位付けするSQLを書いてください。結果には教師名、講座名、受講者数、教師内順位を含めてください。

### 問題24-2
LAG()関数を使用して、各学生の連続する成績評価（中間テスト→レポート1→最終評価）の点数変化を分析するSQLを書いてください。前回評価からの変化量も計算してください。

### 問題24-3
DENSE_RANK()を使用して、各講座内での成績上位3位までの学生を抽出するSQLを書いてください。同点の場合は同順位として扱ってください。

### 問題24-4
移動平均を使用して、過去3回の授業の平均出席率を計算するSQLを書いてください。授業日順に並べ、3日移動平均の出席率を表示してください。

### 問題24-5
SUM()のウィンドウ関数を使用して、各学生の累積出席回数と累積出席率を計算するSQLを書いてください。日付順に並べて表示してください。

### 問題24-6
FIRST_VALUE()とLAST_VALUE()を使用して、各講座において最高得点と最低得点を取った学生の情報を、全ての学生の行に追加するSQLを書いてください。中間テストの結果を対象とします。

## 解答

### 解答24-1
```sql
SELECT 
    t.teacher_name AS 教師名,
    c.course_name AS 講座名,
    COUNT(sc.student_id) AS 受講者数,
    ROW_NUMBER() OVER (PARTITION BY t.teacher_id 
                       ORDER BY COUNT(sc.student_id) DESC) AS 教師内順位
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY t.teacher_id, t.teacher_name, c.course_id, c.course_name
ORDER BY t.teacher_name, 教師内順位;
```

### 解答24-2
```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.grade_type AS 評価種別,
    g.score AS 今回点数,
    LAG(g.score) OVER (PARTITION BY s.student_id, g.course_id 
                       ORDER BY CASE g.grade_type 
                           WHEN '中間テスト' THEN 1 
                           WHEN 'レポート1' THEN 2 
                           WHEN '最終評価' THEN 3 
                       END) AS 前回点数,
    g.score - LAG(g.score) OVER (PARTITION BY s.student_id, g.course_id 
                                 ORDER BY CASE g.grade_type 
                                     WHEN '中間テスト' THEN 1 
                                     WHEN 'レポート1' THEN 2 
                                     WHEN '最終評価' THEN 3 
                                 END) AS 点数変化
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
ORDER BY s.student_name, c.course_name, 
         CASE g.grade_type 
             WHEN '中間テスト' THEN 1 
             WHEN 'レポート1' THEN 2 
             WHEN '最終評価' THEN 3 
         END;
```

### 解答24-3
```sql
WITH ranked_grades AS (
    SELECT 
        s.student_name AS 学生名,
        c.course_name AS 講座名,
        g.score AS 点数,
        DENSE_RANK() OVER (PARTITION BY g.course_id ORDER BY g.score DESC) AS 順位
    FROM grades g
    JOIN students s ON g.student_id = s.student_id
    JOIN courses c ON g.course_id = c.course_id
    WHERE g.grade_type = '中間テスト'
)
SELECT 学生名, 講座名, 点数, 順位
FROM ranked_grades
WHERE 順位 <= 3
ORDER BY 講座名, 順位;
```

### 解答24-4
```sql
SELECT 
    cs.schedule_date AS 授業日,
    c.course_name AS 講座名,
    COUNT(a.student_id) AS 対象学生数,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS 出席者数,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    ROUND(AVG(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END)) 
        OVER (PARTITION BY c.course_id 
              ORDER BY cs.schedule_date 
              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 1) AS 3日移動平均出席率
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY cs.schedule_id, cs.schedule_date, c.course_id, c.course_name
ORDER BY c.course_name, cs.schedule_date;
```

### 解答24-5
```sql
SELECT 
    s.student_name AS 学生名,
    cs.schedule_date AS 授業日,
    CASE WHEN a.status = 'present' THEN 1 ELSE 0 END AS 今日の出席,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) 
        OVER (PARTITION BY s.student_id 
              ORDER BY cs.schedule_date 
              ROWS UNBOUNDED PRECEDING) AS 累積出席回数,
    COUNT(*) OVER (PARTITION BY s.student_id 
                   ORDER BY cs.schedule_date 
                   ROWS UNBOUNDED PRECEDING) AS 累積授業回数,
    ROUND(SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) 
        OVER (PARTITION BY s.student_id 
              ORDER BY cs.schedule_date 
              ROWS UNBOUNDED PRECEDING) * 100.0 /
        COUNT(*) OVER (PARTITION BY s.student_id 
                       ORDER BY cs.schedule_date 
                       ROWS UNBOUNDED PRECEDING), 1) AS 累積出席率
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN course_schedule cs ON sc.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND s.student_id = a.student_id
WHERE s.student_id BETWEEN 301 AND 305
ORDER BY s.student_name, cs.schedule_date;
```

### 解答24-6
```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    FIRST_VALUE(s2.student_name) OVER (PARTITION BY g.course_id 
                                       ORDER BY g.score DESC 
                                       ROWS UNBOUNDED PRECEDING) AS 最高得点者,
    FIRST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                               ORDER BY g.score DESC 
                               ROWS UNBOUNDED PRECEDING) AS 最高点,
    LAST_VALUE(s2.student_name) OVER (PARTITION BY g.course_id 
                                      ORDER BY g.score DESC 
                                      ROWS BETWEEN UNBOUNDED PRECEDING 
                                      AND UNBOUNDED FOLLOWING) AS 最低得点者,
    LAST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                              ORDER BY g.score DESC 
                              ROWS BETWEEN UNBOUNDED PRECEDING 
                              AND UNBOUNDED FOLLOWING) AS 最低点
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN students s2 ON g.student_id = s2.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY c.course_name, g.score DESC;
```

## まとめ

この章では、ウィンドウ関数について詳しく学びました：

1. **ウィンドウ関数の基本概念**：
   - 指定されたウィンドウ（行の範囲）に対して計算を行う関数
   - 元の行構造を保ったまま集計結果を取得
   - OVER句によるウィンドウの定義

2. **OVER句の構成要素**：
   - PARTITION BY：データのグループ化
   - ORDER BY：ウィンドウ内での行の順序
   - フレーム指定：計算対象の行範囲

3. **順位関数**：
   - ROW_NUMBER()：連続した番号の割り当て
   - RANK()：同順位考慮の順位付け（次の順位をスキップ）
   - DENSE_RANK()：同順位考慮の順位付け（次の順位を連続）

4. **分析関数**：
   - LAG()とLEAD()：前後の行の値の取得
   - FIRST_VALUE()とLAST_VALUE()：ウィンドウ内の最初・最後の値

5. **集計ウィンドウ関数**：
   - SUM()、AVG()、COUNT()等の集計関数をウィンドウ関数として使用
   - 累積計算や移動平均の実現

6. **フレーム指定**：
   - ROWS BETWEENによる計算対象範囲の詳細制御
   - 移動平均や累積計算での活用

7. **実践的な応用例**：
   - 成績ランキングの作成
   - 学習進捗の分析
   - 講座人気度の評価
   - 出席率の推移分析

8. **パフォーマンス考慮点**：
   - インデックスの重要性
   - 適切なフレーム指定
   - メモリ使用量への配慮

ウィンドウ関数は、従来のGROUP BYでは実現困難な複雑な分析を可能にする強力なツールです。データ分析、レポート作成、ランキング作成など、様々な場面で活用できる重要なSQL機能です。

次の章では、「共通テーブル式（CTE）：WITH句の活用」について学び、複雑なクエリを構造化して分かりやすく記述する方法を理解していきます。



---

# 25. 共通テーブル式（CTE）：WITH句の活用

## はじめに

これまでの章で、ウィンドウ関数による高度な分析機能について学びました。SQLの最後の重要な機能として「共通テーブル式（CTE：Common Table Expression）」について学びます。CTEは、WITH句を使用して一時的な結果セットを定義し、クエリ内で再利用できる機能です。

CTEが特に威力を発揮する場面：
- 「複雑なサブクエリを分かりやすく構造化したい」
- 「同じサブクエリを複数回使用したい」
- 「階層データを再帰的に処理したい」
- 「複雑な計算を段階的に行いたい」
- 「クエリの可読性と保守性を向上させたい」

従来のサブクエリやFROM句内のサブクエリと比較して、CTEはより読みやすく、再利用可能で、場合によってはパフォーマンスも向上させることができます。

この章では、CTEの基本概念から再帰CTE、実践的な活用方法まで、詳しく学んでいきます。

## 共通テーブル式（CTE）とは

共通テーブル式（CTE）は、WITH句を使用してクエリ内で一時的な名前付きの結果セットを定義する機能です。定義したCTEは、同じクエリ内で通常のテーブルと同様に参照できます。

> **用語解説**：
> - **CTE（Common Table Expression）**：共通テーブル式。WITH句で定義される一時的な名前付き結果セットです。
> - **WITH句**：CTEを定義するためのSQL句で、「〜と共に」という意味があります。
> - **非再帰CTE**：自分自身を参照しない通常のCTEです。
> - **再帰CTE**：自分自身を参照して反復処理を行うCTEです。
> - **アンカーメンバー**：再帰CTEにおいて、再帰の開始点となる初期データです。
> - **再帰メンバー**：再帰CTEにおいて、自分自身を参照する部分です。

## CTEの基本構文

### 単一CTE

```sql
WITH CTE名 AS (
    SELECT文
)
SELECT カラム1, カラム2, ...
FROM CTE名
WHERE 条件;
```

### 複数CTE

```sql
WITH 
CTE名1 AS (
    SELECT文1
),
CTE名2 AS (
    SELECT文2
)
SELECT カラム1, カラム2, ...
FROM CTE名1
JOIN CTE名2 ON 結合条件;
```

## 基本的なCTEの例

### 例1：単純なCTEの使用

成績優秀者を定義して、その詳細情報を取得：

```sql
WITH excellent_students AS (
    SELECT DISTINCT g.student_id
    FROM grades g
    WHERE g.score >= 90
)
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    COUNT(DISTINCT sc.course_id) AS 受講講座数,
    ROUND(AVG(g.score), 1) AS 平均点
FROM excellent_students es
JOIN students s ON es.student_id = s.student_id
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
ORDER BY 平均点 DESC;
```

このクエリでは、まず90点以上の成績を取った学生をCTEで定義し、その後でその学生たちの詳細情報を取得しています。

実行結果：

| student_id | 学生名     | 受講講座数 | 平均点 |
|------------|------------|------------|--------|
| 311        | 鈴木健太   | 6          | 89.8   |
| 302        | 新垣愛留   | 7          | 86.5   |
| 308        | 永田悦子   | 5          | 85.9   |
| 320        | 松本さくら | 4          | 84.2   |
| ...        | ...        | ...        | ...    |

### 例2：サブクエリとCTEの比較

同じ結果を得るためのサブクエリとCTEの比較：

#### サブクエリを使用した場合：
```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE s.student_id IN (
    SELECT g2.student_id
    FROM grades g2
    GROUP BY g2.student_id
    HAVING AVG(g2.score) >= 85
)
AND g.grade_type = '中間テスト'
ORDER BY s.student_name, g.score DESC;
```

#### CTEを使用した場合：
```sql
WITH high_performers AS (
    SELECT g.student_id
    FROM grades g
    GROUP BY g.student_id
    HAVING AVG(g.score) >= 85
)
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数
FROM high_performers hp
JOIN students s ON hp.student_id = s.student_id
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY s.student_name, g.score DESC;
```

CTEを使用した方が、クエリの意図が明確で読みやすくなります。

## 複数CTEの活用

複数のCTEを定義することで、複雑な処理を段階的に分解できます。

### 例3：複数CTEによる総合分析

```sql
WITH 
-- 各学生の平均成績を計算
student_averages AS (
    SELECT 
        s.student_id,
        s.student_name,
        ROUND(AVG(g.score), 1) AS avg_score,
        COUNT(DISTINCT g.grade_id) AS total_grades
    FROM students s
    LEFT JOIN grades g ON s.student_id = g.student_id
    GROUP BY s.student_id, s.student_name
),
-- 各学生の出席率を計算
student_attendance AS (
    SELECT 
        s.student_id,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate,
        COUNT(a.schedule_id) AS total_classes
    FROM students s
    LEFT JOIN attendance a ON s.student_id = a.student_id
    GROUP BY s.student_id
),
-- 各学生の受講講座数を計算
student_courses_count AS (
    SELECT 
        s.student_id,
        COUNT(DISTINCT sc.course_id) AS course_count
    FROM students s
    LEFT JOIN student_courses sc ON s.student_id = sc.student_id
    GROUP BY s.student_id
)
-- すべての情報を統合
SELECT 
    sa.student_id,
    sa.student_name AS 学生名,
    sa.avg_score AS 平均成績,
    sat.attendance_rate AS 出席率,
    scc.course_count AS 受講講座数,
    CASE 
        WHEN sa.avg_score >= 85 AND sat.attendance_rate >= 90 THEN 'S評価'
        WHEN sa.avg_score >= 75 AND sat.attendance_rate >= 80 THEN 'A評価'
        WHEN sa.avg_score >= 65 AND sat.attendance_rate >= 70 THEN 'B評価'
        ELSE 'C評価'
    END AS 総合評価
FROM student_averages sa
LEFT JOIN student_attendance sat ON sa.student_id = sat.student_id
LEFT JOIN student_courses_count scc ON sa.student_id = scc.student_id
WHERE sa.total_grades > 0  -- 成績記録がある学生のみ
ORDER BY sa.avg_score DESC, sat.attendance_rate DESC;
```

この例では、3つのCTEを使用して：
1. 学生の平均成績を計算
2. 学生の出席率を計算
3. 学生の受講講座数を計算
4. 最終的にすべてを統合して総合評価を行っています

実行結果：

| student_id | 学生名     | 平均成績 | 出席率 | 受講講座数 | 総合評価 |
|------------|------------|----------|--------|------------|----------|
| 311        | 鈴木健太   | 89.8     | 92.5   | 6          | S評価    |
| 302        | 新垣愛留   | 86.5     | 88.9   | 7          | A評価    |
| 308        | 永田悦子   | 85.9     | 95.0   | 5          | S評価    |
| 301        | 黒沢春馬   | 82.3     | 85.7   | 8          | A評価    |
| ...        | ...        | ...      | ...    | ...        | ...      |

## CTEの再利用

同じCTEを複数回参照することで、計算の重複を避けることができます。

### 例4：CTEの再利用による効率化

```sql
WITH course_stats AS (
    SELECT 
        c.course_id,
        c.course_name,
        t.teacher_name,
        COUNT(DISTINCT sc.student_id) AS enrollment_count,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
    FROM courses c
    JOIN teachers t ON c.teacher_id = t.teacher_id
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id
    LEFT JOIN attendance a ON sc.student_id = a.student_id
    GROUP BY c.course_id, c.course_name, t.teacher_name
)
SELECT 
    '講座統計' AS カテゴリ,
    COUNT(*) AS 講座数,
    ROUND(AVG(enrollment_count), 1) AS 平均受講者数,
    ROUND(AVG(avg_score), 1) AS 全体平均成績,
    ROUND(AVG(attendance_rate), 1) AS 全体平均出席率
FROM course_stats

UNION ALL

SELECT 
    '優秀講座' AS カテゴリ,
    COUNT(*) AS 講座数,
    ROUND(AVG(enrollment_count), 1) AS 平均受講者数,
    ROUND(AVG(avg_score), 1) AS 平均成績,
    ROUND(AVG(attendance_rate), 1) AS 平均出席率
FROM course_stats
WHERE avg_score >= 80 AND attendance_rate >= 85

UNION ALL

SELECT 
    '改善必要講座' AS カテゴリ,
    COUNT(*) AS 講座数,
    ROUND(AVG(enrollment_count), 1) AS 平均受講者数,
    ROUND(AVG(avg_score), 1) AS 平均成績,
    ROUND(AVG(attendance_rate), 1) AS 平均出席率
FROM course_stats
WHERE avg_score < 75 OR attendance_rate < 75;
```

この例では、`course_stats` CTEを3回再利用して、全体統計、優秀講座、改善が必要な講座の統計をまとめて取得しています。

## 再帰CTE

再帰CTEは、自分自身を参照して階層データや連続データを処理するために使用されます。

> **注意**：再帰CTEはMySQL 8.0以降でサポートされています。

### 再帰CTEの基本構文

```sql
WITH RECURSIVE CTE名 AS (
    -- アンカーメンバー（初期データ）
    SELECT ...
    
    UNION ALL
    
    -- 再帰メンバー（自分自身を参照）
    SELECT ...
    FROM CTE名
    WHERE 終了条件
)
SELECT * FROM CTE名;
```

### 例5：数列の生成（再帰CTEの基本例）

1から10までの数列を生成：

```sql
WITH RECURSIVE number_sequence AS (
    -- アンカーメンバー：開始値
    SELECT 1 AS n
    
    UNION ALL
    
    -- 再帰メンバー：次の値を生成
    SELECT n + 1
    FROM number_sequence
    WHERE n < 10  -- 終了条件
)
SELECT n AS 番号
FROM number_sequence;
```

実行結果：

| 番号 |
|------|
| 1    |
| 2    |
| 3    |
| 4    |
| 5    |
| 6    |
| 7    |
| 8    |
| 9    |
| 10   |

### 例6：日付系列の生成

指定期間の全日付を生成して、授業日と休日を識別：

```sql
WITH RECURSIVE date_series AS (
    -- アンカーメンバー：開始日
    SELECT DATE('2025-05-01') AS date_value
    
    UNION ALL
    
    -- 再帰メンバー：次の日を生成
    SELECT DATE_ADD(date_value, INTERVAL 1 DAY)
    FROM date_series
    WHERE date_value < DATE('2025-05-31')  -- 終了条件
)
SELECT 
    ds.date_value AS 日付,
    CASE DAYOFWEEK(ds.date_value)
        WHEN 1 THEN '日曜日'
        WHEN 2 THEN '月曜日'
        WHEN 3 THEN '火曜日'
        WHEN 4 THEN '水曜日'
        WHEN 5 THEN '木曜日'
        WHEN 6 THEN '金曜日'
        WHEN 7 THEN '土曜日'
    END AS 曜日,
    CASE 
        WHEN cs.schedule_date IS NOT NULL THEN '授業日'
        WHEN DAYOFWEEK(ds.date_value) IN (1, 7) THEN '休日'
        ELSE '平日（授業なし）'
    END AS 種別,
    COUNT(cs.schedule_id) AS 授業数
FROM date_series ds
LEFT JOIN course_schedule cs ON ds.date_value = cs.schedule_date
GROUP BY ds.date_value
ORDER BY ds.date_value;
```

### 例7：学習進捗の累積計算（再帰CTE）

各学生の学習進捗を段階的に追跡：

```sql
WITH RECURSIVE learning_progress AS (
    -- アンカーメンバー：最初の成績記録
    SELECT 
        g.student_id,
        s.student_name,
        g.grade_id,
        g.course_id,
        g.grade_type,
        g.score,
        g.submission_date,
        1 AS level,
        g.score AS cumulative_score,
        1 AS test_count
    FROM grades g
    JOIN students s ON g.student_id = s.student_id
    WHERE g.submission_date = (
        SELECT MIN(g2.submission_date)
        FROM grades g2
        WHERE g2.student_id = g.student_id
    )
    
    UNION ALL
    
    -- 再帰メンバー：次の成績記録
    SELECT 
        g.student_id,
        lp.student_name,
        g.grade_id,
        g.course_id,
        g.grade_type,
        g.score,
        g.submission_date,
        lp.level + 1,
        lp.cumulative_score + g.score,
        lp.test_count + 1
    FROM learning_progress lp
    JOIN grades g ON lp.student_id = g.student_id
    WHERE g.submission_date > lp.submission_date
    AND g.submission_date = (
        SELECT MIN(g3.submission_date)
        FROM grades g3
        WHERE g3.student_id = lp.student_id
        AND g3.submission_date > lp.submission_date
    )
    AND lp.level < 10  -- 無限ループ防止
)
SELECT 
    student_name AS 学生名,
    level AS レベル,
    grade_type AS 評価種別,
    score AS 今回点数,
    ROUND(cumulative_score / test_count, 1) AS 累積平均,
    submission_date AS 提出日
FROM learning_progress
WHERE student_id = 301
ORDER BY level;
```

## CTEとウィンドウ関数の組み合わせ

CTEとウィンドウ関数を組み合わせることで、さらに高度な分析が可能になります。

### 例8：段階的な分析とランキング

```sql
WITH 
-- ステップ1：基本統計の計算
basic_stats AS (
    SELECT 
        c.course_id,
        c.course_name,
        t.teacher_name,
        COUNT(DISTINCT sc.student_id) AS student_count,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROUND(STDDEV(g.score), 1) AS score_stddev,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
    FROM courses c
    JOIN teachers t ON c.teacher_id = t.teacher_id
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id AND g.grade_type = '中間テスト'
    LEFT JOIN attendance a ON sc.student_id = a.student_id
    GROUP BY c.course_id, c.course_name, t.teacher_name
),
-- ステップ2：ランキングの追加
ranked_courses AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY avg_score DESC) AS score_rank,
        RANK() OVER (ORDER BY attendance_rate DESC) AS attendance_rank,
        RANK() OVER (ORDER BY student_count DESC) AS popularity_rank
    FROM basic_stats
    WHERE student_count > 0
)
-- ステップ3：総合評価
SELECT 
    course_name AS 講座名,
    teacher_name AS 担当教師,
    student_count AS 受講者数,
    avg_score AS 平均点,
    attendance_rate AS 出席率,
    score_rank AS 成績順位,
    attendance_rank AS 出席率順位,
    popularity_rank AS 人気順位,
    ROUND((score_rank + attendance_rank + popularity_rank) / 3.0, 1) AS 総合順位
FROM ranked_courses
ORDER BY 総合順位, score_rank;
```

## CTEのパフォーマンス考慮点

CTEを効率的に使用するためのポイント：

### 1. 物理的実体化（Materialization）

CTEは、データベースによって実際のテーブルとして一時的に物理化される場合があります：

```sql
-- 効率的なCTEの例
WITH recent_grades AS (
    SELECT student_id, course_id, score
    FROM grades
    WHERE submission_date >= '2025-05-01'  -- 事前フィルタリング
)
SELECT 
    s.student_name,
    rg.score
FROM recent_grades rg
JOIN students s ON rg.student_id = s.student_id
WHERE rg.score >= 80;  -- さらなるフィルタリング
```

### 2. インデックスの活用

CTEで使用するカラムには適切なインデックスを設定：

```sql
-- インデックスが有効なCTEの例
WITH high_performers AS (
    SELECT student_id  -- student_idにインデックスが必要
    FROM grades
    WHERE score >= 90  -- scoreにインデックスが有効
)
SELECT s.student_name
FROM high_performers hp
JOIN students s ON hp.student_id = s.student_id;  -- 結合キーにインデックス
```

### 3. 再帰CTEの制限

再帰CTEでは無限ループを防ぐため、適切な終了条件と制限を設定：

```sql
WITH RECURSIVE safe_recursion AS (
    SELECT 1 AS level, student_id
    FROM students
    WHERE student_id = 301
    
    UNION ALL
    
    SELECT level + 1, student_id
    FROM safe_recursion
    WHERE level < 100  -- 明確な終了条件
)
SELECT * FROM safe_recursion;
```

## CTEの実践的な応用例

### 例9：学習ダッシュボードの作成

```sql
WITH 
-- 全体統計
overall_stats AS (
    SELECT 
        COUNT(DISTINCT s.student_id) AS total_students,
        COUNT(DISTINCT c.course_id) AS total_courses,
        COUNT(DISTINCT t.teacher_id) AS total_teachers,
        ROUND(AVG(g.score), 1) AS overall_avg_score
    FROM students s
    CROSS JOIN courses c
    CROSS JOIN teachers t
    LEFT JOIN grades g ON 1=1  -- 全体平均計算用
),
-- 今月の活動統計
monthly_stats AS (
    SELECT 
        COUNT(DISTINCT cs.schedule_id) AS classes_this_month,
        COUNT(DISTINCT CASE WHEN a.status = 'present' THEN a.student_id END) AS active_students,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS monthly_attendance_rate
    FROM course_schedule cs
    LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
    WHERE cs.schedule_date >= DATE_FORMAT(CURRENT_DATE, '%Y-%m-01')
),
-- トップパフォーマー
top_performers AS (
    SELECT 
        s.student_name,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROW_NUMBER() OVER (ORDER BY AVG(g.score) DESC) AS rank
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    GROUP BY s.student_id, s.student_name
    HAVING COUNT(g.grade_id) >= 3  -- 最低3つの成績記録
    LIMIT 5
),
-- 問題のある学生
at_risk_students AS (
    SELECT 
        s.student_name,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
    FROM students s
    LEFT JOIN grades g ON s.student_id = g.student_id
    LEFT JOIN attendance a ON s.student_id = a.student_id
    GROUP BY s.student_id, s.student_name
    HAVING (AVG(g.score) < 65 OR AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) < 70)
    AND COUNT(g.grade_id) > 0
)
-- ダッシュボード結果の統合
SELECT 
    '全体統計' AS カテゴリ,
    CONCAT('学生数: ', os.total_students, ', 講座数: ', os.total_courses, ', 教師数: ', os.total_teachers) AS 詳細,
    CONCAT('全体平均: ', os.overall_avg_score, '点') AS 追加情報
FROM overall_stats os

UNION ALL

SELECT 
    '今月の活動',
    CONCAT('授業数: ', ms.classes_this_month, ', アクティブ学生: ', ms.active_students),
    CONCAT('出席率: ', ms.monthly_attendance_rate, '%')
FROM monthly_stats ms

UNION ALL

SELECT 
    'トップ5学生',
    CONCAT(tp.rank, '位: ', tp.student_name),
    CONCAT('平均点: ', tp.avg_score, '点')
FROM top_performers tp

UNION ALL

SELECT 
    '要注意学生',
    ars.student_name,
    CONCAT('平均点: ', ars.avg_score, '点, 出席率: ', ars.attendance_rate, '%')
FROM at_risk_students ars;
```

## CTEのデバッグとトラブルシューティング

複雑なCTEのデバッグ方法：

### 1. 段階的な確認

```sql
-- ステップ1：最初のCTEのみを確認
WITH step1 AS (
    SELECT student_id, AVG(score) AS avg_score
    FROM grades
    GROUP BY student_id
)
SELECT * FROM step1 LIMIT 10;

-- ステップ2：2番目のCTEを追加
WITH 
step1 AS (
    SELECT student_id, AVG(score) AS avg_score
    FROM grades
    GROUP BY student_id
),
step2 AS (
    SELECT student_id, COUNT(*) AS course_count
    FROM student_courses
    GROUP BY student_id
)
SELECT s1.*, s2.course_count 
FROM step1 s1
LEFT JOIN step2 s2 ON s1.student_id = s2.student_id
LIMIT 10;
```

### 2. 中間結果の確認

```sql
WITH detailed_analysis AS (
    SELECT 
        s.student_id,
        s.student_name,
        AVG(g.score) AS avg_score,
        COUNT(g.grade_id) AS grade_count,
        'デバッグ用' AS debug_flag  -- デバッグ用カラム
    FROM students s
    LEFT JOIN grades g ON s.student_id = g.student_id
    GROUP BY s.student_id, s.student_name
)
-- デバッグ時は中間結果を直接確認
SELECT * FROM detailed_analysis
WHERE grade_count IS NULL OR grade_count = 0;  -- 問題のあるレコードを特定
```

## 練習問題

### 問題25-1
CTEを使用して、各講座の受講者数、平均点、出席率を計算し、それらの全体平均と比較するSQLを書いてください。結果には講座名、各統計値、および全体平均との差を含めてください。

### 問題25-2
複数のCTEを使用して、「優秀な学生」（平均点85点以上）と「出席率の高い学生」（出席率90%以上）を定義し、両方の条件を満たす学生、どちらか一方だけを満たす学生、どちらも満たさない学生を分類するSQLを書いてください。

### 問題25-3
再帰CTEを使用して、2025年5月の全日付（1日〜31日）を生成し、各日の授業数と出席者数を表示するSQLを書いてください。授業がない日は0と表示してください。

### 問題25-4
CTEとウィンドウ関数を組み合わせて、各学生の成績推移（中間テスト→レポート1→最終評価）を分析し、改善傾向、悪化傾向、安定傾向に分類するSQLを書いてください。

### 問題25-5
CTEを使用して教師の負荷分析を行い、担当講座数、総受講者数、平均成績、平均出席率を計算し、負荷が高い教師（担当講座数4以上または総受講者数40人以上）を特定するSQLを書いてください。

### 問題25-6
再帰CTEを使用して、各学生の「学習レベル」を定義するSQLを書いてください。レベル1は最初のテスト（60点以上）、レベル2は2回目のテスト（65点以上）、以降5点ずつ基準を上げて、最大レベル10まで計算してください。

## 解答

### 解答25-1
```sql
WITH 
course_stats AS (
    SELECT 
        c.course_id,
        c.course_name,
        COUNT(DISTINCT sc.student_id) AS enrollment_count,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
    FROM courses c
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id
    LEFT JOIN attendance a ON sc.student_id = a.student_id
    GROUP BY c.course_id, c.course_name
),
overall_averages AS (
    SELECT 
        ROUND(AVG(enrollment_count), 1) AS avg_enrollment,
        ROUND(AVG(avg_score), 1) AS overall_avg_score,
        ROUND(AVG(attendance_rate), 1) AS overall_attendance_rate
    FROM course_stats
    WHERE enrollment_count > 0
)
SELECT 
    cs.course_name AS 講座名,
    cs.enrollment_count AS 受講者数,
    cs.avg_score AS 平均点,
    cs.attendance_rate AS 出席率,
    oa.overall_avg_score AS 全体平均点,
    oa.overall_attendance_rate AS 全体平均出席率,
    ROUND(cs.avg_score - oa.overall_avg_score, 1) AS 平均点差,
    ROUND(cs.attendance_rate - oa.overall_attendance_rate, 1) AS 出席率差
FROM course_stats cs
CROSS JOIN overall_averages oa
WHERE cs.enrollment_count > 0
ORDER BY cs.avg_score DESC;
```

### 解答25-2
```sql
WITH 
excellent_students AS (
    SELECT s.student_id, s.student_name
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    GROUP BY s.student_id, s.student_name
    HAVING AVG(g.score) >= 85
),
high_attendance_students AS (
    SELECT s.student_id, s.student_name
    FROM students s
    JOIN attendance a ON s.student_id = a.student_id
    GROUP BY s.student_id, s.student_name
    HAVING AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90
)
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    CASE 
        WHEN es.student_id IS NOT NULL THEN '優秀'
        ELSE '一般'
    END AS 成績区分,
    CASE 
        WHEN has.student_id IS NOT NULL THEN '高出席'
        ELSE '通常出席'
    END AS 出席区分,
    CASE 
        WHEN es.student_id IS NOT NULL AND has.student_id IS NOT NULL THEN '両方満足'
        WHEN es.student_id IS NOT NULL AND has.student_id IS NULL THEN '成績のみ優秀'
        WHEN es.student_id IS NULL AND has.student_id IS NOT NULL THEN '出席のみ良好'
        ELSE 'どちらも未達'
    END AS 総合分類
FROM students s
LEFT JOIN excellent_students es ON s.student_id = es.student_id
LEFT JOIN high_attendance_students has ON s.student_id = has.student_id
ORDER BY 
    CASE 
        WHEN es.student_id IS NOT NULL AND has.student_id IS NOT NULL THEN 1
        WHEN es.student_id IS NOT NULL OR has.student_id IS NOT NULL THEN 2
        ELSE 3
    END,
    s.student_name;
```

### 解答25-3
```sql
WITH RECURSIVE may_dates AS (
    -- アンカーメンバー：5月1日
    SELECT DATE('2025-05-01') AS date_value
    
    UNION ALL
    
    -- 再帰メンバー：次の日
    SELECT DATE_ADD(date_value, INTERVAL 1 DAY)
    FROM may_dates
    WHERE date_value < DATE('2025-05-31')
)
SELECT 
    md.date_value AS 日付,
    CASE DAYOFWEEK(md.date_value)
        WHEN 1 THEN '日曜日'
        WHEN 2 THEN '月曜日'
        WHEN 3 THEN '火曜日'
        WHEN 4 THEN '水曜日'
        WHEN 5 THEN '木曜日'
        WHEN 6 THEN '金曜日'
        WHEN 7 THEN '土曜日'
    END AS 曜日,
    COALESCE(COUNT(cs.schedule_id), 0) AS 授業数,
    COALESCE(SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END), 0) AS 出席者数
FROM may_dates md
LEFT JOIN course_schedule cs ON md.date_value = cs.schedule_date
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY md.date_value
ORDER BY md.date_value;
```

### 解答25-4
```sql
WITH 
student_progress AS (
    SELECT 
        s.student_id,
        s.student_name,
        g.course_id,
        c.course_name,
        g.grade_type,
        g.score,
        ROW_NUMBER() OVER (PARTITION BY s.student_id, g.course_id 
                          ORDER BY CASE g.grade_type 
                              WHEN '中間テスト' THEN 1 
                              WHEN 'レポート1' THEN 2 
                              WHEN '最終評価' THEN 3 
                          END) AS test_sequence,
        LAG(g.score) OVER (PARTITION BY s.student_id, g.course_id 
                           ORDER BY CASE g.grade_type 
                               WHEN '中間テスト' THEN 1 
                               WHEN 'レポート1' THEN 2 
                               WHEN '最終評価' THEN 3 
                           END) AS prev_score
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    JOIN courses c ON g.course_id = c.course_id
    WHERE g.grade_type IN ('中間テスト', 'レポート1', '最終評価')
),
trend_analysis AS (
    SELECT 
        student_id,
        student_name,
        course_id,
        course_name,
        COUNT(*) AS test_count,
        SUM(CASE WHEN score > prev_score THEN 1 ELSE 0 END) AS improvements,
        SUM(CASE WHEN score < prev_score THEN 1 ELSE 0 END) AS declines,
        SUM(CASE WHEN score = prev_score THEN 1 ELSE 0 END) AS stable
    FROM student_progress
    WHERE prev_score IS NOT NULL
    GROUP BY student_id, student_name, course_id, course_name
)
SELECT 
    student_name AS 学生名,
    course_name AS 講座名,
    test_count AS 比較可能テスト数,
    improvements AS 改善回数,
    declines AS 悪化回数,
    stable AS 維持回数,
    CASE 
        WHEN improvements > declines THEN '改善傾向'
        WHEN declines > improvements THEN '悪化傾向'
        ELSE '安定傾向'
    END AS 総合傾向
FROM trend_analysis
WHERE test_count >= 2
ORDER BY student_name, course_name;
```

### 解答25-5
```sql
WITH 
teacher_workload AS (
    SELECT 
        t.teacher_id,
        t.teacher_name,
        COUNT(DISTINCT c.course_id) AS course_count,
        COUNT(DISTINCT sc.student_id) AS total_students,
        ROUND(AVG(g.score), 1) AS avg_grade,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS avg_attendance
    FROM teachers t
    LEFT JOIN courses c ON t.teacher_id = c.teacher_id
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id
    LEFT JOIN attendance a ON sc.student_id = a.student_id
    GROUP BY t.teacher_id, t.teacher_name
),
workload_classification AS (
    SELECT 
        *,
        CASE 
            WHEN course_count >= 4 OR total_students >= 40 THEN '高負荷'
            WHEN course_count >= 2 OR total_students >= 20 THEN '中負荷'
            ELSE '低負荷'
        END AS load_level
    FROM teacher_workload
    WHERE course_count > 0
)
SELECT 
    teacher_name AS 教師名,
    course_count AS 担当講座数,
    total_students AS 総受講者数,
    avg_grade AS 平均成績,
    avg_attendance AS 平均出席率,
    load_level AS 負荷レベル
FROM workload_classification
ORDER BY 
    CASE load_level 
        WHEN '高負荷' THEN 1 
        WHEN '中負荷' THEN 2 
        ELSE 3 
    END,
    total_students DESC;
```

### 解答25-6
```sql
WITH RECURSIVE student_levels AS (
    -- アンカーメンバー：レベル1（最初のテストで60点以上）
    SELECT 
        s.student_id,
        s.student_name,
        1 AS level,
        60 AS required_score,
        MIN(g.score) AS achieved_score,
        MIN(g.submission_date) AS achievement_date
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    WHERE g.score >= 60
    GROUP BY s.student_id, s.student_name
    
    UNION ALL
    
    -- 再帰メンバー：次のレベル
    SELECT 
        sl.student_id,
        sl.student_name,
        sl.level + 1,
        sl.required_score + 5,  -- 5点ずつ基準を上げる
        MIN(g.score),
        MIN(g.submission_date)
    FROM student_levels sl
    JOIN grades g ON sl.student_id = g.student_id
    WHERE g.score >= (sl.required_score + 5)
    AND g.submission_date > sl.achievement_date
    AND sl.level < 10  -- 最大レベル10
    GROUP BY sl.student_id, sl.student_name, sl.level, sl.required_score
    HAVING MIN(g.score) >= (sl.required_score + 5)
)
SELECT 
    student_name AS 学生名,
    MAX(level) AS 到達レベル,
    MAX(required_score) AS 最終基準点,
    COUNT(*) AS レベルアップ回数
FROM student_levels
GROUP BY student_id, student_name
ORDER BY MAX(level) DESC, student_name;
```

## まとめ

この章では、共通テーブル式（CTE）について詳しく学びました：

1. **CTEの基本概念**：
   - WITH句を使用した一時的な名前付き結果セットの定義
   - クエリの可読性と再利用性の向上
   - 複雑なクエリの構造化

2. **CTEの基本構文**：
   - 単一CTEと複数CTEの記述方法
   - CTEの参照と再利用
   - サブクエリとの比較

3. **複数CTEの活用**：
   - 段階的な処理の分解
   - 複雑な分析の構造化
   - 同一CTEの複数回参照

4. **再帰CTE**：
   - 自分自身を参照する再帰的な処理
   - アンカーメンバーと再帰メンバー
   - 階層データや連続データの処理

5. **CTEとウィンドウ関数の組み合わせ**：
   - 高度な分析機能の実現
   - ランキングと統計の複合処理
   - 段階的な計算とランキング

6. **パフォーマンス考慮点**：
   - 物理的実体化の理解
   - インデックスの効果的な活用
   - 再帰CTEの制限設定

7. **実践的な応用例**：
   - 学習ダッシュボードの作成
   - 総合分析システム
   - デバッグとトラブルシューティング

CTEは、複雑なSQLクエリをより読みやすく、保守しやすくするための重要な機能です。特に、段階的な処理や再帰的な操作において威力を発揮し、従来のサブクエリでは実現困難な高度な分析を可能にします。

これで第4章「高度なクエリ技術」が完了しました。サブクエリから始まり、相関サブクエリ、集合演算、EXISTS演算子、CASE式、ウィンドウ関数、そしてCTEまで、SQLの高度な機能を体系的に学習できました。これらの技術を組み合わせることで、実務で求められる複雑なデータ分析や処理を効率的に実現できるようになります。



---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [1. SELECT基本：単一テーブルから特定カラムを取得する](#1-select基本単一テーブルから特定カラムを取得する)
2. [2. WHERE句：条件に合ったレコードを絞り込む](#2-where句条件に合ったレコードを絞り込む)
3. [3. 論理演算子：AND、OR、NOTを使った複合条件](#3-論理演算子andornotを使った複合条件)
4. [4. パターンマッチング：LIKE演算子と%、_ワイルドカード](#4-パターンマッチングlike演算子と_ワイルドカード)
5. [5. 範囲指定：BETWEEN、IN演算子](#5-範囲指定betweenin演算子)
6. [6. NULL値の処理：IS NULL、IS NOT NULL](#6-null値の処理is-nullis-not-null)
7. [7. ORDER BY：結果の並び替え](#7-order-by結果の並び替え)
8. [8. LIMIT句：結果件数の制限とページネーション](#8-limit句結果件数の制限とページネーション)

---


# 1. SELECT基本：単一テーブルから特定カラムを取得する

## はじめに

データベースからデータを取り出す作業は、料理人が大きな冷蔵庫から必要な材料だけを取り出すようなものです。SQLでは、この「取り出す」作業を「SELECT文」で行います。

SELECT文はSQLの中で最も基本的で、最もよく使われる命令です。この章では、単一のテーブル（データの表）から必要な情報だけを取り出す方法を学びます。

## 基本構文

SELECT文の最も基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名;
```

この文は「テーブル名というテーブルからカラム名という列のデータを取り出してください」という意味です。

> **用語解説**：
> - **SELECT**：「選択する」という意味のSQLコマンドで、データを取り出すときに使います。
> - **カラム**：テーブルの縦の列のことで、同じ種類のデータが並んでいます（例：名前のカラム、年齢のカラムなど）。
> - **FROM**：「〜から」という意味で、どのテーブルからデータを取るかを指定します。
> - **テーブル**：データベース内の表のことで、行と列で構成されています。

## 実践例：単一カラムの取得

学校データベースの中の「teachers」テーブル（教師テーブル）から、教師の名前だけを取得してみましょう。

```sql
SELECT teacher_name FROM teachers;
```

実行結果：

| teacher_name |
|--------------|
| 寺内鞍       |
| 田尻朋美     |
| 内村海凪     |
| 藤本理恵     |
| 黒木大介     |
| 星野涼子     |
| 深山誠一     |
| 吉岡由佳     |
| 山田太郎     |
| 佐藤花子     |
| ...          |

これは「teachers」テーブルの「teacher_name」という列（先生の名前）だけを取り出しています。

## 複数のカラムを取得する

料理に複数の材料が必要なように、データを取り出すときも複数の列が必要なことがよくあります。複数のカラムを取得するには、カラム名をカンマ（,）で区切って指定します。

```sql
SELECT カラム名1, カラム名2, カラム名3 FROM テーブル名;
```

例えば、教師の番号（ID）と名前を一緒に取得してみましょう：

```sql
SELECT teacher_id, teacher_name FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| 104        | 藤本理恵     |
| 105        | 黒木大介     |
| 106        | 星野涼子     |
| ...        | ...          |

## すべてのカラムを取得する

テーブルのすべての列を取得したい場合は、アスタリスク（*）を使います。これは「すべての列」を意味するワイルドカードです。

```sql
SELECT * FROM テーブル名;
```

例：
```sql
SELECT * FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| ...        | ...          |

> **注意**：`SELECT *`は便利ですが、実際の業務では必要なカラムだけを指定する方が良いとされています。これは、データ量が多いときに処理速度が遅くなるのを防ぐためです。

## カラムに別名をつける（AS句）

取得したカラムに分かりやすい名前（別名）をつけることができます。これは「AS」句を使います。

```sql
SELECT カラム名 AS 別名 FROM テーブル名;
```

> **用語解説**：
> - **AS**：「〜として」という意味で、カラムに別名をつけるときに使います。この別名は結果を表示するときだけ使われます。

例えば、教師IDを「番号」、教師名を「名前」として表示してみましょう：

```sql
SELECT teacher_id AS 番号, teacher_name AS 名前 FROM teachers;
```

実行結果：

| 番号  | 名前       |
|------|------------|
| 101  | 寺内鞍     |
| 102  | 田尻朋美   |
| 103  | 内村海凪   |
| ...  | ...        |

ASは省略することも可能です：

```sql
SELECT teacher_id 番号, teacher_name 名前 FROM teachers;
```

## 計算式を使う

SELECT文では、カラムの値を使った計算もできます。例えば、成績テーブルから点数と満点を取得して、達成率（パーセント）を計算してみましょう。

```sql
SELECT student_id, course_id, grade_type, 
       score, max_score,
       (score / max_score) * 100 AS 達成率
FROM grades;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 301        | 1         | 中間テスト   | 85.5  | 100.0     | 85.5     |
| 302        | 1         | 中間テスト   | 92.0  | 100.0     | 92.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

## 重複を除外する（DISTINCT）

同じ値が複数ある場合に、重複を除いて一意の値だけを表示するには「DISTINCT」キーワードを使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別された」という意味で、重複する値を除外して一意の値だけを取得します。

例えば、どの講座にどの教師が担当しているかを重複なしで確認してみましょう：

```sql
SELECT DISTINCT teacher_id FROM courses;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

これにより、courses（講座）テーブルで使われている教師IDが重複なく表示されます。

## 文字列の結合

文字列を結合するには、MySQLでは「CONCAT」関数を使います。例えば、教師のIDと名前を組み合わせて表示してみましょう：

```sql
SELECT CONCAT('教師ID:', teacher_id, ' 名前:', teacher_name) AS 教師情報
FROM teachers;
```

実行結果：

| 教師情報                  |
|--------------------------|
| 教師ID:101 名前:寺内鞍   |
| 教師ID:102 名前:田尻朋美 |
| ...                      |

> **用語解説**：
> - **CONCAT**：複数の文字列を一つにつなげる関数です。

## SELECT文と終了記号

SQLの文は通常、セミコロン（;）で終わります。これは「この命令はここで終わりです」という合図です。

複数のSQL文を一度に実行する場合は、それぞれの文の最後にセミコロンをつけます。

## 練習問題

### 問題1-1
students（学生）テーブルから、すべての学生の名前（student_name）を取得するSQLを書いてください。

### 問題1-2
classrooms（教室）テーブルから、教室ID（classroom_id）と教室名（classroom_name）を取得するSQLを書いてください。

### 問題1-3
courses（講座）テーブルから、すべての列（カラム）を取得するSQLを書いてください。

### 問題1-4
class_periods（授業時間）テーブルから、時限ID（period_id）、開始時間（start_time）、終了時間（end_time）を取得し、開始時間には「開始」、終了時間には「終了」という別名をつけるSQLを書いてください。

### 問題1-5
grades（成績）テーブルから、学生ID（student_id）、講座ID（course_id）、評価タイプ（grade_type）、得点（score）、満点（max_score）、そして得点を満点で割って100を掛けた値を「パーセント」という別名で取得するSQLを書いてください。

### 問題1-6
course_schedule（授業カレンダー）テーブルから、schedule_date（予定日）カラムだけを重複なしで取得するSQLを書いてください。

## 解答

### 解答1-1
```sql
SELECT student_name FROM students;
```

### 解答1-2
```sql
SELECT classroom_id, classroom_name FROM classrooms;
```

### 解答1-3
```sql
SELECT * FROM courses;
```

### 解答1-4
```sql
SELECT period_id, start_time AS 開始, end_time AS 終了 FROM class_periods;
```

### 解答1-5
```sql
SELECT student_id, course_id, grade_type, score, max_score,
       (score / max_score) * 100 AS パーセント
FROM grades;
```

### 解答1-6
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

## まとめ

この章では、SQLのSELECT文の基本を学びました：

1. 単一カラムの取得: `SELECT カラム名 FROM テーブル名;`
2. 複数カラムの取得: `SELECT カラム名1, カラム名2 FROM テーブル名;`
3. すべてのカラムの取得: `SELECT * FROM テーブル名;`
4. カラムに別名をつける: `SELECT カラム名 AS 別名 FROM テーブル名;`
5. 計算式を使う: `SELECT カラム名, (計算式) AS 別名 FROM テーブル名;`
6. 重複を除外する: `SELECT DISTINCT カラム名 FROM テーブル名;`
7. 文字列の結合: `SELECT CONCAT(文字列1, カラム名, 文字列2) FROM テーブル名;`

これらの基本操作を使いこなせるようになれば、データベースから必要な情報を効率よく取り出せるようになります。次の章では、WHERE句を使って条件に合ったデータだけを取り出す方法を学びます。



---

# 2. WHERE句：条件に合ったレコードを絞り込む

## はじめに

前章では、テーブルからデータを取得する基本的な方法を学びました。しかし実際の業務では、すべてのデータではなく、特定の条件に合ったデータだけを取得したいことがほとんどです。

例えば、「全生徒の情報」ではなく「特定の学科の生徒だけ」や「成績が80点以上の学生だけ」といった形で、データを絞り込みたい場合があります。

このような場合に使用するのが「WHERE句」です。WHERE句は、SELECTコマンドの後に追加して使い、条件に合致するレコード（行）だけを取得します。

## 基本構文

WHERE句の基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件式;
```

> **用語解説**：
> - **WHERE**：「〜の場所で」「〜の条件で」という意味のSQLコマンドで、条件に合うデータだけを抽出するために使います。
> - **条件式**：データが満たすべき条件を指定するための式です。例えば「age > 20」（年齢が20より大きい）などです。
> - **レコード**：テーブルの横の行のことで、1つのデータの集まりを表します。

## 基本的な比較演算子

WHERE句では、様々な比較演算子を使って条件を指定できます：

| 演算子 | 意味                   | 例                    |
|--------|------------------------|------------------------|
| =      | 等しい                 | age = 25               |
| <>     | 等しくない（≠と同じ）  | gender <> 'male'       |
| >      | より大きい             | score > 80             |
| <      | より小さい             | price < 1000           |
| >=     | 以上                   | height >= 170          |
| <=     | 以下                   | weight <= 70           |

## 実践例：基本的な条件での絞り込み

### 例1：等しい（=）
例えば、教師ID（teacher_id）が101の教師のみを取得するには：

```sql
SELECT * FROM teachers WHERE teacher_id = 101;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |

### 例2：より大きい（>）
成績（grades）テーブルから、90点を超える成績だけを取得するには：

```sql
SELECT * FROM grades WHERE score > 90;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例3：等しくない（<>）
講座IDが3ではない講座に関する成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id <> '3';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト  | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 301        | 2         | 実技試験    | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 文字列の比較

テキスト（文字列）を条件にする場合は、シングルクォーテーション（'）またはダブルクォーテーション（"）で囲みます。MySQLではどちらも使えますが、多くの場合シングルクォーテーションが推奨されます。

```sql
SELECT * FROM テーブル名 WHERE テキストカラム = 'テキスト値';
```

例えば、教師名（teacher_name）が「田尻朋美」の教師を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name = '田尻朋美';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |

## 日付の比較

日付の比較も同様にシングルクォーテーションで囲みます。日付の形式はデータベースの設定によって異なりますが、一般的にはISO形式（YYYY-MM-DD）が使われます。

```sql
SELECT * FROM テーブル名 WHERE 日付カラム = '日付';
```

例えば、2025年5月20日に提出された成績を検索するには：

```sql
SELECT * FROM grades WHERE submission_date = '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

また、日付同士の大小関係も比較できます：

```sql
SELECT * FROM grades WHERE submission_date < '2025-05-15';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | レポート1   | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1   | 48.0  | 50.0      | 2025-05-10      |
| 304        | 5         | ER図作成課題 | 27.5  | 30.0      | 2025-05-14      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 複数の条件を指定する（次章の内容）

WHERE句では、複数の条件を組み合わせることもできます。この詳細は次章「論理演算子：AND、OR、NOTを使った複合条件」で説明します。

例えば、講座IDが1で、かつ、得点が90以上の成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id = '1' AND score >= 90;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題2-1
students（学生）テーブルから、学生ID（student_id）が「310」の学生情報を取得するSQLを書いてください。

### 問題2-2
classrooms（教室）テーブルから、収容人数（capacity）が30人より多い教室の情報をすべて取得するSQLを書いてください。

### 問題2-3
courses（講座）テーブルから、教師ID（teacher_id）が「105」の講座情報を取得するSQLを書いてください。

### 問題2-4
course_schedule（授業カレンダー）テーブルから、「2025-05-15」の授業スケジュールをすべて取得するSQLを書いてください。

### 問題2-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」で、得点（score）が80点未満の成績を取得するSQLを書いてください。

### 問題2-6
teachers（教師）テーブルから、教師ID（teacher_id）が「101」ではない教師の名前を取得するSQLを書いてください。

## 解答

### 解答2-1
```sql
SELECT * FROM students WHERE student_id = 310;
```

### 解答2-2
```sql
SELECT * FROM classrooms WHERE capacity > 30;
```

### 解答2-3
```sql
SELECT * FROM courses WHERE teacher_id = 105;
```

### 解答2-4
```sql
SELECT * FROM course_schedule WHERE schedule_date = '2025-05-15';
```

### 解答2-5
```sql
SELECT * FROM grades WHERE grade_type = '中間テスト' AND score < 80;
```

### 解答2-6
```sql
SELECT teacher_name FROM teachers WHERE teacher_id <> 101;
```

## まとめ

この章では、WHERE句を使って条件に合ったレコードを取得する方法を学びました：

1. 基本的な比較演算子（=, <>, >, <, >=, <=）の使い方
2. 数値による条件絞り込み
3. 文字列（テキスト）による条件絞り込み
4. 日付による条件絞り込み

WHERE句は、大量のデータから必要な情報だけを取り出すための非常に重要な機能です。実際のデータベース操作では、この条件絞り込みを頻繁に使います。

次の章では、複数の条件を組み合わせるための「論理演算子（AND、OR、NOT）」について学びます。



---

# 3. 論理演算子：AND、OR、NOTを使った複合条件

## はじめに

前章では、WHERE句を使って単一の条件でデータを絞り込む方法を学びました。しかし実際の業務では、より複雑な条件でデータを絞り込む必要があることがよくあります。

例えば：
- 「成績が80点以上**かつ**出席率が90%以上の学生」
- 「数学**または**英語の成績が優秀な学生」
- 「課題を**まだ提出していない**学生」

このような複合条件を指定するために使うのが論理演算子です。主な論理演算子は次の3つです：

- **AND**：両方の条件を満たす（かつ）
- **OR**：いずれかの条件を満たす（または）
- **NOT**：条件を満たさない（〜ではない）

## AND演算子

AND演算子は、指定した**すべての条件を満たす**レコードだけを取得したいときに使います。

> **用語解説**：
> - **AND**：「かつ」「そして」という意味の論理演算子です。複数の条件をすべて満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 AND 条件2;
```

### 例：ANDを使った複合条件

例えば、中間テストで90点以上かつ満点が100点の成績レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

この例では、「score >= 90」と「max_score = 100」の両方の条件を満たすレコードだけが取得されます。

### 3つ以上の条件の組み合わせ

ANDを使って3つ以上の条件を組み合わせることもできます：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100 AND grade_type = '中間テスト';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## OR演算子

OR演算子は、指定した条件の**いずれか一つでも満たす**レコードを取得したいときに使います。

> **用語解説**：
> - **OR**：「または」「もしくは」という意味の論理演算子です。複数の条件のうち少なくとも1つを満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 OR 条件2;
```

### 例：ORを使った複合条件

例えば、教師IDが101または102の講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id = 101 OR teacher_id = 102;
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 2         | UNIX入門             | 102        |
| 3         | Cプログラミング演習    | 101        |
| 29        | コードリファクタリングとクリーンコード | 101 |
| 40        | ソフトウェアアーキテクチャパターン | 102 |
| ...       | ...                  | ...        |

この例では、「teacher_id = 101」または「teacher_id = 102」のいずれかの条件を満たすレコードが取得されます。

## NOT演算子

NOT演算子は、指定した条件を**満たさない**レコードを取得したいときに使います。

> **用語解説**：
> - **NOT**：「〜ではない」という意味の論理演算子です。条件を否定して、その条件を満たさないデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE NOT 条件;
```

### 例：NOTを使った否定条件

例えば、完了（completed）状態ではない授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
WHERE NOT status = 'completed';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 45          | 11        | 2025-05-20    | 5         | 401G         | 106        | scheduled |
| 46          | 12        | 2025-05-21    | 1         | 301E         | 107        | scheduled |
| 50          | 2         | 2025-05-23    | 3         | 101A         | 102        | cancelled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

この例では、statusが「completed」ではないレコード（scheduled状態やcancelled状態）が取得されます。

NOT演算子は、「〜ではない」という否定の条件を作るために使われます。例えば次の2つの書き方は同じ意味になります：

```sql
SELECT * FROM teachers WHERE NOT teacher_id = 101;
SELECT * FROM teachers WHERE teacher_id <> 101;
```

## 複合論理条件（AND、OR、NOTの組み合わせ）

AND、OR、NOTを組み合わせて、より複雑な条件を指定することもできます。

### 例：ANDとORの組み合わせ

例えば、「成績が90点以上で中間テストである」または「成績が45点以上でレポートである」レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE (score >= 90 AND grade_type = '中間テスト') 
   OR (score >= 45 AND grade_type = 'レポート1');
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 308        | 1         | レポート1  | 47.0  | 50.0      | 2025-05-09      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 優先順位と括弧の使用

論理演算子を組み合わせる場合、演算子の優先順位に注意が必要です。基本的に**ANDはORよりも優先順位が高い**です。つまり、ANDが先に処理されます。

例えば：
```sql
WHERE 条件1 OR 条件2 AND 条件3
```

これは次のように解釈されます：
```sql
WHERE 条件1 OR (条件2 AND 条件3)
```

意図した条件と異なる場合は、**括弧（）を使って明示的にグループ化**することが重要です：
```sql
WHERE (条件1 OR 条件2) AND 条件3
```

### 例：括弧を使った条件のグループ化

教師IDが101または102で、かつ、講座名に「プログラミング」という単語が含まれる講座を取得するには：

```sql
SELECT * FROM courses 
WHERE (teacher_id = 101 OR teacher_id = 102) 
  AND course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

この例では、括弧を使って「teacher_id = 101 OR teacher_id = 102」の部分をグループ化し、その条件と「course_name LIKE '%プログラミング%'」の条件をANDで結合しています。

## 練習問題

### 問題3-1
grades（成績）テーブルから、課題タイプ（grade_type）が「中間テスト」かつ点数（score）が85点以上のレコードを取得するSQLを書いてください。

### 問題3-2
classrooms（教室）テーブルから、収容人数（capacity）が40人以下または建物（building）が「1号館」の教室を取得するSQLを書いてください。

### 問題3-3
teachers（教師）テーブルから、教師ID（teacher_id）が101、102、103ではない教師の情報を取得するSQLを書いてください。

### 問題3-4
course_schedule（授業カレンダー）テーブルから、2025年5月20日の授業で、時限（period_id）が1か2で、かつ状態（status）が「scheduled」の授業を取得するSQLを書いてください。

### 問題3-5
students（学生）テーブルから、学生名（student_name）に「田」または「山」を含む学生を取得するSQLを書いてください。

### 問題3-6
grades（成績）テーブルから、提出日（submission_date）が2025年5月15日以降で、かつ（「中間テスト」で90点以上または「レポート1」で45点以上）の成績を取得するSQLを書いてください。

## 解答

### 解答3-1
```sql
SELECT * FROM grades 
WHERE grade_type = '中間テスト' AND score >= 85;
```

### 解答3-2
```sql
SELECT * FROM classrooms 
WHERE capacity <= 40 OR building = '1号館';
```

### 解答3-3
```sql
SELECT * FROM teachers 
WHERE NOT (teacher_id = 101 OR teacher_id = 102 OR teacher_id = 103);
```
または
```sql
SELECT * FROM teachers 
WHERE teacher_id <> 101 AND teacher_id <> 102 AND teacher_id <> 103;
```

### 解答3-4
```sql
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-20' 
  AND (period_id = 1 OR period_id = 2) 
  AND status = 'scheduled';
```

### 解答3-5
```sql
SELECT * FROM students 
WHERE student_name LIKE '%田%' OR student_name LIKE '%山%';
```

### 解答3-6
```sql
SELECT * FROM grades 
WHERE submission_date >= '2025-05-15' 
  AND ((grade_type = '中間テスト' AND score >= 90) 
       OR (grade_type = 'レポート1' AND score >= 45));
```

## まとめ

この章では、論理演算子（AND、OR、NOT）を使って複合条件を作る方法を学びました：

1. **AND**：すべての条件を満たすレコードを取得（条件1 AND 条件2）
2. **OR**：いずれかの条件を満たすレコードを取得（条件1 OR 条件2）
3. **NOT**：指定した条件を満たさないレコードを取得（NOT 条件）
4. **複合条件**：AND、OR、NOTを組み合わせたより複雑な条件
5. **括弧（）**：条件をグループ化して優先順位を明示的に指定

これらの論理演算子を使いこなすことで、より複雑で細かな条件でデータを絞り込むことができるようになります。実際のデータベース操作では、複数の条件を組み合わせることが頻繁にあるため、この章で学んだ内容は非常に重要です。

次の章では、テキストデータに対する検索を行う「パターンマッチング」について学びます。



---

# 4. パターンマッチング：LIKE演算子と%、_ワイルドカード

## はじめに

前章までは、データの完全一致や数値の比較といった条件での絞り込みを学びました。しかし実際の業務では、もっと柔軟な検索が必要なケースがあります。例えば：

- 「山」で始まる名前の学生を検索したい
- 「プログラミング」という単語を含む講座名を探したい
- 電話番号の一部だけ覚えているデータを探したい

このような「部分一致」や「パターン一致」の検索を行うためのSQLの機能が「パターンマッチング」です。この章では、パターンマッチングを行うための「LIKE演算子」と「ワイルドカード文字」について学びます。

## LIKE演算子の基本

LIKE演算子は、文字列のパターンマッチングを行うための演算子です。WHERE句と組み合わせて使用します。

> **用語解説**：
> - **LIKE**：「〜のような」という意味の演算子で、パターンに一致する文字列を検索します。
> - **パターンマッチング**：完全一致ではなく、一定のパターンに合致するデータを検索する方法です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 文字列カラム LIKE 'パターン';
```

パターンには、通常の文字に加えて、特別な意味を持つ「ワイルドカード文字」を使用できます。

## ワイルドカード文字

SQLでは主に2つのワイルドカード文字があります：

1. **%（パーセント）**：0文字以上の任意の文字列に一致します。
2. **_（アンダースコア）**：任意の1文字に一致します。

> **用語解説**：
> - **ワイルドカード**：任意の文字や文字列に一致する特殊な文字記号です。トランプのジョーカーのように、様々な値に代用できます。

## LIKE演算子の使い方：実践例

### 例1：%（パーセント）を使ったパターンマッチング

#### 「〜で始まる」パターン：前方一致

例えば、「山」で始まる学生名を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '山%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 山本裕子     |
| 325        | 山田翔太     |
| ...        | ...          |

ここでの「山%」は「山で始まり、その後に0文字以上の任意の文字が続く」という意味です。

#### 「〜で終わる」パターン：後方一致

例えば、「子」で終わる教師名を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name LIKE '%子';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| 106        | 星野涼子     |
| 108        | 吉岡由佳     |
| 110        | 佐藤花子     |
| ...        | ...          |

#### 「〜を含む」パターン：部分一致

例えば、「プログラミング」という単語を含む講座名を検索するには：

```sql
SELECT * FROM courses WHERE course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| 14        | IoTデバイスプログラミング実践 | 110 |
| ...       | ...                  | ...        |

### 例2：_（アンダースコア）を使ったパターンマッチング

アンダースコアは任意の1文字に一致します。例えば、教室IDが「10_A」パターン（最初の2文字が「10」、3文字目が任意の1文字、最後が「A」）の教室を検索するには：

```sql
SELECT * FROM classrooms WHERE classroom_id LIKE '10_A';
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| ...          | ...            | ...      | ...      | ...        |

### 例3：%と_の組み合わせ

ワイルドカード文字は組み合わせて使うこともできます。例えば、「2文字目が田」の学生を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '_田%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 384        | 櫻井翼       |
| ...        | ...          |

## NOT LIKEを使った否定形のパターンマッチング

特定のパターンに一致しないレコードを検索したい場合は、「NOT LIKE」を使います。

> **用語解説**：
> - **NOT LIKE**：「〜のパターンに一致しない」という意味で、指定したパターンに一致しないデータを検索します。

例えば、講座名に「入門」を含まない講座を検索するには：

```sql
SELECT * FROM courses WHERE course_name NOT LIKE '%入門%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

## エスケープ文字の使用

もし検索したいパターンに「%」や「_」自体が含まれている場合は、それらを特別な文字としてではなく、通常の文字として扱うために「エスケープ文字」を使います。

> **用語解説**：
> - **エスケープ文字**：特別な意味を持つ文字を通常の文字として扱うための印です。

MySQLでは、バックスラッシュ（\）をエスケープ文字として使用できます。例えば、「50%」という値そのものを検索するには：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50\%';
```

または、ESCAPE句を使って明示的にエスケープ文字を指定することもできます：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50!%' ESCAPE '!';
```

この例では「!」をエスケープ文字として指定しています。

## 大文字と小文字の区別

MySQLのデフォルト設定では、LIKE演算子は大文字と小文字を区別しません（大文字小文字を同じものとして扱います）。

例えば、次の2つのクエリは同じ結果を返します：

```sql
SELECT * FROM courses WHERE course_name LIKE '%web%';
SELECT * FROM courses WHERE course_name LIKE '%Web%';
```

もし大文字と小文字を区別した検索が必要な場合は、「BINARY」キーワードを使用します：

```sql
SELECT * FROM courses WHERE course_name LIKE BINARY '%Web%';
```

この場合、「Web」は「web」とは一致しません。

## 複合条件との組み合わせ

LIKE演算子は、これまで学んだAND、OR、NOTなどの論理演算子と組み合わせて使うこともできます。

例えば、「田」で始まる名前で、かつ教師IDが102から105の間の教師を検索するには：

```sql
SELECT * FROM teachers 
WHERE teacher_name LIKE '田%' 
  AND teacher_id BETWEEN 102 AND 105;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| ...        | ...          |

## 練習問題

### 問題4-1
students（学生）テーブルから、学生名（student_name）が「佐藤」で始まる学生の情報をすべて取得するSQLを書いてください。

### 問題4-2
courses（講座）テーブルから、講座名（course_name）に「データ」という単語を含む講座の情報を取得するSQLを書いてください。

### 問題4-3
classrooms（教室）テーブルから、教室名（classroom_name）が「コンピュータ実習室」で終わる教室の情報を取得するSQLを書いてください。

### 問題4-4
teachers（教師）テーブルから、教師名（teacher_name）の2文字目が「木」である教師の情報を取得するSQLを書いてください。

### 問題4-5
courses（講座）テーブルから、講座名（course_name）に「入門」または「基礎」を含む講座を取得するSQLを書いてください。

### 問題4-6
students（学生）テーブルから、学生名（student_name）が「山」で始まり、かつ「子」で終わらない学生を取得するSQLを書いてください。

## 解答

### 解答4-1
```sql
SELECT * FROM students WHERE student_name LIKE '佐藤%';
```

### 解答4-2
```sql
SELECT * FROM courses WHERE course_name LIKE '%データ%';
```

### 解答4-3
```sql
SELECT * FROM classrooms WHERE classroom_name LIKE '%コンピュータ実習室';
```

### 解答4-4
```sql
SELECT * FROM teachers WHERE teacher_name LIKE '_木%';
```

### 解答4-5
```sql
SELECT * FROM courses 
WHERE course_name LIKE '%入門%' OR course_name LIKE '%基礎%';
```

### 解答4-6
```sql
SELECT * FROM students 
WHERE student_name LIKE '山%' AND student_name NOT LIKE '%子';
```

## まとめ

この章では、パターンマッチングを行うためのLIKE演算子と、その中で使用するワイルドカード文字（%と_）について学びました：

1. **LIKE演算子**：文字列パターンに一致するデータを検索するための演算子
2. **%（パーセント）**：0文字以上の任意の文字列に一致するワイルドカード
3. **_（アンダースコア）**：任意の1文字に一致するワイルドカード
4. **前方一致**：「パターン%」で「パターンで始まる」文字列に一致
5. **後方一致**：「%パターン」で「パターンで終わる」文字列に一致
6. **部分一致**：「%パターン%」で「パターンを含む」文字列に一致
7. **NOT LIKE**：指定したパターンに一致しないデータを検索
8. **エスケープ文字**：特殊文字（%や_）を通常の文字として扱うための方法
9. **複合条件との組み合わせ**：AND、ORなどと組み合わせたより複雑な条件

パターンマッチングは、特にテキストデータを扱う際に非常に便利な機能です。部分的な情報しか持っていない場合や、特定のパターンを持つデータを探す場合に活用できます。

次の章では、範囲指定のための「BETWEEN演算子」と「IN演算子」について学びます。



---

# 5. 範囲指定：BETWEEN、IN演算子

## はじめに

これまでの章では、等号（=）や不等号（>、<）を使って条件を指定する方法や、LIKE演算子を使ったパターンマッチングを学びました。この章では、値の範囲を指定する「BETWEEN演算子」と、複数の値を一度に指定できる「IN演算子」について学びます。

これらの演算子を使うと、次のような検索がより簡単になります：
- 「80点から90点の間の成績」
- 「2025年4月から6月の間のスケジュール」
- 「特定の教師IDリストに該当する講座」

## BETWEEN演算子：範囲を指定する

BETWEEN演算子は、ある値が指定した範囲内にあるかどうかを調べるために使います。

> **用語解説**：
> - **BETWEEN**：「〜の間に」という意味の演算子で、ある値が指定した最小値と最大値の間（両端の値を含む）にあるかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 BETWEEN 最小値 AND 最大値;
```

この構文は次の条件と同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 >= 最小値 AND カラム名 <= 最大値;
```

### 例1：数値範囲の指定

例えば、成績（grades）テーブルから、80点から90点の間の成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 308        | 6         | 小テスト1  | 89.0  | 100.0     | 2025-05-15      |
| ...        | ...       | ...        | ...   | ...       | ...             |

### 例2：日付範囲の指定

日付にもBETWEEN演算子が使えます。例えば、2025年5月10日から2025年5月20日までに提出された成績を取得するには：

```sql
SELECT * FROM grades 
WHERE submission_date BETWEEN '2025-05-10' AND '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | レポート1  | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## NOT BETWEEN：範囲外を指定する

NOT BETWEENを使うと、指定した範囲の外にある値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT BETWEEN 最小値 AND 最大値;
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 < 最小値 OR カラム名 > 最大値;
```

### 例：範囲外の値を取得

例えば、80点未満または90点より高い成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score NOT BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## IN演算子：複数の値を指定する

IN演算子は、ある値が指定した複数の値のリストのいずれかに一致するかどうかを調べるために使います。

> **用語解説**：
> - **IN**：「〜の中に含まれる」という意味の演算子で、ある値が指定したリストの中に含まれているかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (値1, 値2, 値3, ...);
```

この構文は次のOR条件の組み合わせと同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 = 値1 OR カラム名 = 値2 OR カラム名 = 値3 OR ...;
```

### 例1：数値リストの指定

例えば、教師ID（teacher_id）が101、103、105のいずれかである講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (101, 103, 105);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| 5         | データベース設計と実装  | 105        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

### 例2：文字列リストの指定

文字列のリストにも適用できます。例えば、特定の教室ID（classroom_id）のみの教室情報を取得するには：

```sql
SELECT * FROM classrooms 
WHERE classroom_id IN ('101A', '202D', '301E');
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| 202D         | 2号館コンピュータ実習室D | 25     | 2号館     | パソコン25台、プロジェクター、3Dプリンター |
| 301E         | 3号館講義室E      | 80       | 3号館     | プロジェクター、マイク設備、録画設備 |

## NOT IN：リストに含まれない値を指定する

NOT IN演算子を使うと、指定したリストに含まれない値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT IN (値1, 値2, 値3, ...);
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 <> 値1 AND カラム名 <> 値2 AND カラム名 <> 値3 AND ...;
```

### 例：リストに含まれない値を取得

例えば、教師IDが101、102、103以外の教師が担当する講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id NOT IN (101, 102, 103);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 4         | Webアプリケーション開発 | 104        |
| 5         | データベース設計と実装  | 105        |
| 6         | ネットワークセキュリティ | 107        |
| ...       | ...                  | ...        |

## IN演算子でのサブクエリの利用（基本）

IN演算子の括弧内には、直接値を書く代わりに、サブクエリ（別のSELECT文）を指定することもできます。これにより、動的に値のリストを生成できます。

> **用語解説**：
> - **サブクエリ**：SQL文の中に含まれる別のSQL文のことで、外側のSQL文（メインクエリ）に値や条件を提供します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (SELECT カラム名 FROM 別テーブル WHERE 条件);
```

### 例：サブクエリを使ったIN条件

例えば、教師名（teacher_name）に「田」を含む教師が担当している講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (
    SELECT teacher_id FROM teachers 
    WHERE teacher_name LIKE '%田%'
);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 2         | UNIX入門             | 102        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

この例では、まず「teachers」テーブルから名前に「田」を含む教師のIDを取得し、それらのIDを持つ講座を「courses」テーブルから取得しています。

## BETWEEN演算子とIN演算子の組み合わせ

BETWEEN演算子とIN演算子は、論理演算子（AND、OR）と組み合わせて、さらに複雑な条件を作ることができます。

### 例：BETWEENとINの組み合わせ

例えば、「教師IDが101、103、105のいずれかで、かつ、2025年5月15日から2025年6月15日の間に実施される授業」を取得するには：

```sql
SELECT * FROM course_schedule 
WHERE teacher_id IN (101, 103, 105) 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-06-15';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 38          | 1         | 2025-05-20    | 1         | 102B         | 101        | scheduled |
| 42          | 10        | 2025-05-23    | 3         | 201C         | 103        | scheduled |
| 45          | 5         | 2025-05-28    | 2         | 402H         | 105        | scheduled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

## 練習問題

### 問題5-1
grades（成績）テーブルから、得点（score）が85点から95点の間にある成績を取得するSQLを書いてください。

### 問題5-2
course_schedule（授業カレンダー）テーブルから、2025年5月1日から2025年5月31日までの授業スケジュールを取得するSQLを書いてください。

### 問題5-3
courses（講座）テーブルから、教師ID（teacher_id）が104、106、108のいずれかである講座の情報を取得するSQLを書いてください。

### 問題5-4
classrooms（教室）テーブルから、教室ID（classroom_id）が「101A」、「201C」、「301E」、「401G」以外の教室情報を取得するSQLを書いてください。

### 問題5-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」または「実技試験」で、かつ得点（score）が80点から90点の間にない成績を取得するSQLを書いてください。

### 問題5-6
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）が「101A」、「202D」のいずれかで、かつ2025年5月15日から2025年5月30日の間に実施される授業スケジュールを取得するSQLを書いてください。

## 解答

### 解答5-1
```sql
SELECT * FROM grades 
WHERE score BETWEEN 85 AND 95;
```

### 解答5-2
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

### 解答5-3
```sql
SELECT * FROM courses 
WHERE teacher_id IN (104, 106, 108);
```

### 解答5-4
```sql
SELECT * FROM classrooms 
WHERE classroom_id NOT IN ('101A', '201C', '301E', '401G');
```

### 解答5-5
```sql
SELECT * FROM grades 
WHERE grade_type IN ('中間テスト', '実技試験') 
  AND score NOT BETWEEN 80 AND 90;
```

### 解答5-6
```sql
SELECT * FROM course_schedule 
WHERE classroom_id IN ('101A', '202D') 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-05-30';
```

## まとめ

この章では、範囲指定のための「BETWEEN演算子」と複数値指定のための「IN演算子」について学びました：

1. **BETWEEN演算子**：値が指定した範囲内（両端を含む）にあるかどうかをチェック
2. **NOT BETWEEN**：値が指定した範囲外にあるかどうかをチェック
3. **IN演算子**：値が指定したリストのいずれかに一致するかどうかをチェック
4. **NOT IN**：値が指定したリストのいずれにも一致しないかどうかをチェック
5. **サブクエリとIN**：動的に生成された値のリストを使用する方法
6. **複合条件**：BETWEEN、IN、論理演算子を組み合わせたより複雑な条件

これらの演算子を使うことで、複数の条件を指定する場合に、SQLをより簡潔に書くことができます。特に、多くの値を指定する場合や範囲条件を指定する場合に便利です。

次の章では、「NULL値の処理：IS NULL、IS NOT NULL」について学びます。



---

# 6. NULL値の処理：IS NULL、IS NOT NULL

## はじめに

データベースの世界では、データがない状態を表すために「NULL」という特別な値が使われます。NULLは「空」や「0」や「空白文字」とは異なる、「値が存在しない」または「不明」であることを表す特殊な概念です。

例えば、学校データベースでは次のようなシナリオがあります：
- まだ成績が付けられていない（NULL）
- コメントが入力されていない（NULL）
- 授業がキャンセルされたため教室が割り当てられていない（NULL）

この章では、NULL値を正しく処理するための「IS NULL」と「IS NOT NULL」演算子について学びます。

## NULLとは何か？

NULL値には、いくつかの特徴があります：

1. **値がない**：NULLは値がないことを表します。0でも空文字列（''）でもなく、値そのものが存在しないことを示します。
2. **不明**：データが不明であることを表す場合もあります。
3. **未設定**：まだ値が設定されていないことを表す場合もあります。
4. **比較できない**：NULLは通常の比較演算子（=, <, >など）で比較できません。

> **用語解説**：
> - **NULL**：データベースにおいて「値がない」または「不明」を表す特殊な値です。0や空文字とは異なります。

## NULL値と通常の比較演算子

通常の比較演算子（=, <>, >, <, >=, <=）では、NULL値を正しく検出できません。例えば：

```sql
-- この条件はNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 = NULL;

-- この条件もNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 <> NULL;
```

これは、NULL値との等価比較は「不明」と評価されるためです。つまり、NULL = NULLでさえFALSEではなく「不明」になります。

## IS NULL演算子

NULL値を持つレコードを検索するには、「IS NULL」演算子を使います。

> **用語解説**：
> - **IS NULL**：カラムの値がNULLかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NULL;
```

### 例：IS NULLの使用

例えば、コメントが入力されていない（NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

実行結果：

| schedule_id | student_id | status  | comment |
|-------------|------------|---------|---------|
| 1           | 301        | present | NULL    |
| 1           | 306        | present | NULL    |
| 1           | 307        | present | NULL    |
| ...         | ...        | ...     | NULL    |

## IS NOT NULL演算子

逆に、NULL値を持たないレコード（つまり、何らかの値を持つレコード）を検索するには、「IS NOT NULL」演算子を使います。

> **用語解説**：
> - **IS NOT NULL**：カラムの値がNULLでないかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NOT NULL;
```

### 例：IS NOT NULLの使用

例えば、コメントが入力されている（NOT NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 302        | late   | 15分遅刻      |
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |

## NULL値の論理的な扱い

NULL値は論理演算（AND、OR、NOT）でも特殊な扱いを受けます。

- **NULL AND TRUE** → NULL（不明）
- **NULL AND FALSE** → FALSE
- **NULL OR TRUE** → TRUE
- **NULL OR FALSE** → NULL（不明）
- **NOT NULL** → NULL（不明）

この特殊な振る舞いが、バグや誤った結果の原因になることがあります。

## NULL値と結合条件

テーブル結合（JOINなど、後の章で学習）の際も、NULL値は特殊な扱いを受けます。NULL値同士は「等しい」とは判定されないため、通常の結合条件ではNULL値を持つレコードは結合されません。

## IS NULLとIS NOT NULLを使った複合条件

IS NULLとIS NOT NULLも、他の条件と組み合わせて使用できます。

### 例：複合条件でのIS NULLの使用

例えば、「出席状態が "absent"（欠席）で、コメントがNULLでない（理由が入力されている）レコード」を検索するには：

```sql
SELECT * FROM attendance 
WHERE status = 'absent' AND comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |

## NVL/IFNULL/COALESCE関数：NULL値の置換

NULL値を別の値に置き換えるための関数が用意されています。データベースによって関数名が異なることがありますが、機能は似ています：

- MySQL/MariaDB: **IFNULL(expr, replace_value)**
- Oracle: **NVL(expr, replace_value)**
- SQL Server: **ISNULL(expr, replace_value)**
- 標準SQL: **COALESCE(expr1, expr2, ..., exprN)** - 最初のNULLでない式を返します

### 例：IFNULL関数の使用（MySQL）

例えば、コメントがNULLの場合は「特記事項なし」と表示するには：

```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '特記事項なし') AS comment
FROM attendance;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | 特記事項なし  |
| 1           | 302        | late    | 15分遅刻      |
| 1           | 303        | absent  | 事前連絡あり  |
| ...         | ...        | ...     | ...           |

## NULLを使う際の注意点

1. **除外の罠**：`WHERE カラム名 <> 値` だけでは、NULL値を持つレコードは含まれません。すべてのレコードを対象にするには：
   ```sql
   WHERE カラム名 <> 値 OR カラム名 IS NULL
   ```

2. **集計関数**：COUNT(*)はすべての行を数えますが、COUNT(カラム名)はそのカラムがNULLでない行だけを数えます。

3. **インデックス**：多くのデータベースでは、NULL値にもインデックスを適用できますが、データベースによって動作が異なる場合があります。

4. **一意性制約**：一般的に、UNIQUE制約ではNULL値は重複としてカウントされません（複数のNULL値が許可されます）。

## 練習問題

### 問題6-1
attendance（出席）テーブルから、コメント（comment）がNULLの出席レコードをすべて取得するSQLを書いてください。

### 問題6-2
course_schedule（授業カレンダー）テーブルから、状態（status）が「cancelled」で、かつ教室ID（classroom_id）がNULLでないレコードを取得するSQLを書いてください。

### 問題6-3
grades（成績）テーブルから、提出日（submission_date）がNULLの成績レコードを取得するSQLを書いてください。

### 問題6-4
attendance（出席）テーブルから、出席状態（status）が「present」か「late」で、かつコメント（comment）がNULLのレコードを取得するSQLを書いてください。

### 問題6-5
以下のSQLで教師（teachers）テーブルから「佐藤」という名前を持つ教師を検索する場合、NULL値を持つレコードも含めるにはどう修正すべきですか？
```sql
SELECT * FROM teachers WHERE teacher_name <> '佐藤花子';
```

### 問題6-6
attendance（出席）テーブルのすべてのレコードを取得し、コメント（comment）がNULLの場合は「記録なし」と表示するSQLを書いてください。

## 解答

### 解答6-1
```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

### 解答6-2
```sql
SELECT * FROM course_schedule 
WHERE status = 'cancelled' AND classroom_id IS NOT NULL;
```

### 解答6-3
```sql
SELECT * FROM grades WHERE submission_date IS NULL;
```

### 解答6-4
```sql
SELECT * FROM attendance 
WHERE (status = 'present' OR status = 'late') AND comment IS NULL;
```
または
```sql
SELECT * FROM attendance 
WHERE status IN ('present', 'late') AND comment IS NULL;
```

### 解答6-5
```sql
SELECT * FROM teachers 
WHERE teacher_name <> '佐藤花子' OR teacher_name IS NULL;
```

### 解答6-6
```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '記録なし') AS comment
FROM attendance;
```

## まとめ

この章では、データベースにおけるNULL値の概念と、NULL値を扱うための演算子や関数について学びました：

1. **NULL値の概念**：値がない、不明、未設定を表す特殊な値
2. **IS NULL演算子**：NULL値を持つレコードを検索する方法
3. **IS NOT NULL演算子**：NULL値を持たないレコードを検索する方法
4. **NULL値の論理的扱い**：論理演算（AND、OR、NOT）におけるNULLの振る舞い
5. **複合条件**：IS NULL/IS NOT NULLと他の条件の組み合わせ
6. **NULL値の置換**：IFNULL/NVL/COALESCE関数の使用方法
7. **注意点**：NULL値を扱う際の一般的な落とし穴

NULL値の正確な理解と適切な処理は、SQLプログラミングの重要な部分です。不適切なNULL処理は、予期しない結果やバグの原因になります。

次の章では、クエリ結果の並び替えを行うための「ORDER BY：結果の並び替え」について学びます。



---

# 7. ORDER BY：結果の並び替え

## はじめに

これまでの章では、データベースから条件に合ったレコードを取得する方法を学んできました。しかし実際の業務では、取得したデータを見やすく整理する必要があります。例えば：

- 成績を高い順に表示したい
- 学生を名前の五十音順に並べたい
- 日付の新しい順にスケジュールを確認したい

このようなデータの「並び替え」を行うためのSQLコマンドが「ORDER BY」です。この章では、クエリ結果を特定の順序で並べる方法を学びます。

## ORDER BYの基本

ORDER BY句は、SELECT文の結果を指定したカラムの値に基づいて並び替えるために使います。

> **用語解説**：
> - **ORDER BY**：「〜の順に並べる」という意味のSQLコマンドで、クエリ結果の並び順を指定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] ORDER BY 並び替えカラム;
```

ORDER BY句は通常、SELECT文の最後に記述します。

### 例1：単一カラムでの並び替え

例えば、学生（students）テーブルから、学生名（student_name）の五十音順（辞書順）でデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_name;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 309        | 相沢吉夫      |
| 303        | 柴崎春花      |
| 306        | 河田咲奈      |
| 305        | 河口菜恵子    |
| ...        | ...          |

### デフォルトの並び順

ORDER BYを使わない場合、結果の順序は保証されません。多くの場合、データがデータベースに保存された順序で返されますが、これは信頼できるものではありません。

## 昇順と降順の指定

ORDER BY句では、並び順を「昇順」か「降順」のどちらかで指定できます。

> **用語解説**：
> - **昇順（ASC）**：小さい値から大きい値へ（A→Z、1→9）の順に並べます。
> - **降順（DESC）**：大きい値から小さい値へ（Z→A、9→1）の順に並べます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 ORDER BY 並び替えカラム [ASC|DESC];
```

ASC（昇順）がデフォルトのため、省略可能です。

### 例2：降順での並び替え

例えば、成績（grades）テーブルから、得点（score）の高い順（降順）に成績を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 複数カラムでの並び替え

複数のカラムを使って並び替えることもできます。最初に指定したカラムで並び替え、値が同じレコードがある場合は次のカラムで並び替えます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 
ORDER BY 並び替えカラム1 [ASC|DESC], 並び替えカラム2 [ASC|DESC], ...;
```

### 例3：複数カラムでの並び替え

例えば、成績（grades）テーブルから、課題タイプ（grade_type）の五十音順に並べ、同じ課題タイプ内では得点（score）の高い順に成績を取得するには：

```sql
SELECT * FROM grades 
ORDER BY grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| 321        | 2         | 実技試験     | 85.5  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト   | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| 302        | 1         | レポート1    | 48.0  | 50.0      | 2025-05-10      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例4：昇順と降順の混合

各カラムごとに並び順を指定することもできます。例えば、講座ID（course_id）の昇順、評価タイプ（grade_type）の昇順、得点（score）の降順で並べるには：

```sql
SELECT * FROM grades 
ORDER BY course_id ASC, grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## NULLの扱い

ORDER BYでNULL値を並び替える場合、データベース製品によって動作が異なります。多くのデータベースでは、NULL値は最小値または最大値として扱われます。

- MySQL/MariaDBでは、NULL値は昇順（ASC）の場合は最小値として（最初に表示）、降順（DESC）の場合は最大値として（最後に表示）扱われます。

一部のデータベース（PostgreSQLなど）では、NULL値の位置を明示的に指定するための「NULLS FIRST」「NULLS LAST」構文がサポートされています。

### 例5：NULL値の扱い

例えば、出席（attendance）テーブルからコメント（comment）でソートすると、NULLが最初に来ます：

```sql
SELECT * FROM attendance ORDER BY comment;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | NULL          |
| 1           | 306        | present | NULL          |
| ...         | ...        | ...     | NULL          |
| 1           | 308        | late    | 5分遅刻       |
| 1           | 323        | late    | 電車遅延      |
| ...         | ...        | ...     | ...           |

## カラム番号を使った並び替え

カラム名の代わりに、SELECT文の結果セットにおけるカラムの位置（番号）を使って並び替えることもできます。最初のカラムは1、2番目のカラムは2、という具合です。

### 構文

```sql
SELECT カラム名1, カラム名2, ... FROM テーブル名 ORDER BY カラム位置;
```

### 例6：カラム番号を使った並び替え

例えば、学生（students）テーブルから学生ID（student_id）と名前（student_name）を取得し、名前（2番目のカラム）で並べ替えるには：

```sql
SELECT student_id, student_name FROM students ORDER BY 2;
```

この場合、「ORDER BY 2」は「ORDER BY student_name」と同じ意味になります。

> **注意**：カラム番号を使う方法は、カラムの順序を変更すると問題が起きるため、実際の業務では使用を避けた方が良いとされています。

## 式や関数を使った並び替え

ORDER BY句で式や関数を使うことにより、計算結果に基づいて並び替えることもできます。

### 例7：式を使った並び替え

例えば、成績（grades）テーブルから、得点の達成率（score/max_score）の高い順に並べるには：

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY (score/max_score) DESC;
```

または

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY 達成率 DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 98.0     |
| 320        | 1         | レポート1    | 48.5  | 50.0      | 97.0     |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 95.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

### 例8：関数を使った並び替え

文字列関数を使って並び替えることもできます。例えば、月名で並べることを考えましょう：

```sql
SELECT schedule_date, MONTH(schedule_date) AS month
FROM course_schedule
ORDER BY MONTH(schedule_date);
```

実行結果：

| schedule_date | month |
|---------------|-------|
| 2025-04-07    | 4     |
| 2025-04-08    | 4     |
| ...           | ...   |
| 2025-05-01    | 5     |
| 2025-05-02    | 5     |
| ...           | ...   |
| 2025-06-01    | 6     |
| ...           | ...   |

## CASE式を使った条件付き並び替え

さらに高度な並び替えとして、CASE式を使って条件に応じた並び順を定義することもできます。

### 例9：CASE式を使った並び替え

例えば、出席（attendance）テーブルから、出席状況（status）を「欠席→遅刻→出席」の順に優先して表示するには：

```sql
SELECT * FROM attendance
ORDER BY CASE 
           WHEN status = 'absent' THEN 1
           WHEN status = 'late' THEN 2
           WHEN status = 'present' THEN 3
           ELSE 4
         END;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |
| 1           | 302        | late   | 15分遅刻      |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |
| 1           | 301        | present| NULL          |
| 1           | 306        | present| NULL          |
| ...         | ...        | ...    | ...           |

## 練習問題

### 問題7-1
students（学生）テーブルから、すべての学生情報を学生名（student_name）の降順（逆五十音順）で取得するSQLを書いてください。

### 問題7-2
grades（成績）テーブルから、得点（score）が85点以上の成績を得点の高い順に取得するSQLを書いてください。

### 問題7-3
course_schedule（授業カレンダー）テーブルから、2025年5月の授業スケジュールを日付（schedule_date）の昇順で取得するSQLを書いてください。

### 問題7-4
teachers（教師）テーブルから、教師IDと名前を取得し、名前（teacher_name）の五十音順で並べるSQLを書いてください。

### 問題7-5
grades（成績）テーブルから、講座ID（course_id）ごとに、成績を評価タイプ（grade_type）の五十音順に、同じ評価タイプ内では得点（score）の高い順に並べて取得するSQLを書いてください。

### 問題7-6
attendance（出席）テーブルから、すべての出席情報を出席状況（status）が「absent」「late」「present」の順番で、同じ状態内ではコメント（comment）の有無（NULLが後）で並べて取得するSQLを書いてください。

## 解答

### 解答7-1
```sql
SELECT * FROM students ORDER BY student_name DESC;
```

### 解答7-2
```sql
SELECT * FROM grades WHERE score >= 85 ORDER BY score DESC;
```

### 解答7-3
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31' 
ORDER BY schedule_date;
```

### 解答7-4
```sql
SELECT teacher_id, teacher_name FROM teachers ORDER BY teacher_name;
```

### 解答7-5
```sql
SELECT * FROM grades 
ORDER BY course_id, grade_type, score DESC;
```

### 解答7-6
```sql
SELECT * FROM attendance
ORDER BY 
  CASE 
    WHEN status = 'absent' THEN 1
    WHEN status = 'late' THEN 2
    WHEN status = 'present' THEN 3
    ELSE 4
  END,
  CASE 
    WHEN comment IS NULL THEN 2
    ELSE 1
  END;
```

## まとめ

この章では、クエリ結果を特定の順序で並べるための「ORDER BY」句について学びました：

1. **基本的な並び替え**：指定したカラムの値に基づいて結果を並べる方法
2. **昇順と降順**：ASC（昇順）とDESC（降順）の指定方法
3. **複数カラムでの並び替え**：優先順位の高いカラムから順に指定する方法
4. **NULL値の扱い**：NULL値が並び替えでどのように扱われるか
5. **カラム番号**：カラム名の代わりに位置で指定する方法（あまり推奨されない）
6. **式や関数**：計算結果に基づいて並べる方法
7. **CASE式**：条件付きの複雑な並び替え

ORDER BY句は、データを見やすく整理するために非常に重要です。特に大量のデータを扱う場合、適切な並び順はデータの理解を大きく助けます。

次の章では、取得する結果の件数を制限する「LIMIT句：結果件数の制限とページネーション」について学びます。



---

# 8. LIMIT句：結果件数の制限とページネーション

## はじめに

これまでの章では、条件に合うデータを取得し、それを特定の順序で並べる方法を学びました。しかし実際のアプリケーションでは、大量のデータがあるときに、その一部だけを表示したいことがよくあります。例えば：

- 成績上位10件だけを表示したい
- Webページで一度に20件ずつ表示したい（ページネーション）
- 最新の5件のお知らせだけを取得したい

このような「結果の件数を制限する」ためのSQLコマンドが「LIMIT句」です。この章では、クエリ結果の件数を制限する方法と、ページネーションの実装方法を学びます。

## LIMIT句の基本

LIMIT句は、SELECT文の結果から指定した件数だけを取得するために使います。

> **用語解説**：
> - **LIMIT**：「制限する」という意味のSQLコマンドで、取得する行数を制限します。

### 基本構文（MySQL/MariaDB）

MySQLやMariaDBでのLIMIT句の基本構文は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数;
```

LIMIT句は通常、SELECT文の最後に記述します（ORDER BYの後）。

### 例1：単純なLIMIT

例えば、学生（students）テーブルから最初の5人だけを取得するには：

```sql
SELECT * FROM students LIMIT 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |

### ORDER BYとLIMITの組み合わせ

通常、LIMIT句はORDER BY句と組み合わせて使用します。これにより、「上位N件」「最新N件」などの操作が可能になります。

### 例2：ORDER BYとLIMITの組み合わせ

例えば、成績（grades）テーブルから得点（score）の高い順に上位3件を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 3;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |

### 例3：最新のレコードを取得

日付でソートして最新のデータを取得することもよくあります。例えば、最新の3つの授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
ORDER BY schedule_date DESC LIMIT 3;
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 95          | 28        | 2026-12-21    | 3         | 202D         | 119        | scheduled |
| 94          | 1         | 2026-12-21    | 1         | 102B         | 101        | scheduled |
| 93          | 14        | 2026-12-15    | 4         | 202D         | 110        | scheduled |

## OFFSETとページネーション

Webアプリケーションなどでは、大量のデータを「ページ」に分けて表示することがよくあります（ページネーション）。この機能を実現するためには、「OFFSET」（オフセット）という機能が必要です。

> **用語解説**：
> - **OFFSET**：「ずらす」という意味で、結果セットの先頭から指定した数だけ行をスキップします。
> - **ページネーション**：大量のデータを複数のページに分割して表示する技術です。

### 基本構文（MySQL/MariaDB）

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数 OFFSET スキップ数;
```

または、短縮形として：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT スキップ数, 件数;
```

### 例4：OFFSETを使ったスキップ

例えば、学生（students）テーブルから6番目から10番目までの学生を取得するには：

```sql
SELECT * FROM students LIMIT 5 OFFSET 5;
```

または：

```sql
SELECT * FROM students LIMIT 5, 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 306        | 河田咲奈     |
| 307        | 織田柚夏     |
| 308        | 永田悦子     |
| 309        | 相沢吉夫     |
| 310        | 吉川伽羅     |

### 例5：ページネーションの実装

ページネーションを実装する場合、通常は以下の式を使ってOFFSETを計算します：

```
OFFSET = (ページ番号 - 1) × ページあたりの件数
```

例えば、1ページあたり10件表示で、3ページ目のデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 10 OFFSET 20;
```

または：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 20, 10;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 322        | 木村結衣     |
| 323        | 林正義       |
| 324        | 清水香織     |
| 325        | 山田翔太     |
| 326        | 葉山陽太     |
| 327        | 青山凛       |
| 328        | 沢村大和     |
| 329        | 白石優月     |
| 330        | 月岡星奈     |

## LIMIT句を使用する際の注意点

### 1. ORDER BYの重要性

LIMIT句を使用する場合、通常はORDER BY句も一緒に使うべきです。ORDER BYがなければ、どのレコードが取得されるかは保証されません。

```sql
-- 良い例：結果が予測可能
SELECT * FROM students ORDER BY student_id LIMIT 5;

-- 悪い例：結果が不確定
SELECT * FROM students LIMIT 5;
```

### 2. パフォーマンスへの影響

大規模なテーブルで大きなOFFSET値を使用すると、パフォーマンスが低下する可能性があります。これは、データベースがOFFSET分のレコードを読み込んでから破棄する必要があるためです。

### 3. データベース製品による構文の違い

LIMIT句の構文はデータベース製品によって異なります：

- **MySQL/MariaDB/SQLite**：`LIMIT 件数 OFFSET スキップ数` または `LIMIT スキップ数, 件数`
- **PostgreSQL**：`LIMIT 件数 OFFSET スキップ数`
- **Oracle**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY`
- **SQL Server**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY` または旧バージョンでは `TOP`句

この章では主にMySQL/MariaDBの構文を使用します。

## 実践的なページネーションの実装

実際のアプリケーションでページネーションを実装する場合、以下のようなコードになります（疑似コード）：

```
ページ番号 = URLから取得またはデフォルト値（例：1）
1ページあたりの件数 = 設定値（例：10）
総レコード数 = SELECTで取得（COUNT(*)を使用）
総ページ数 = CEILING(総レコード数 ÷ 1ページあたりの件数)
OFFSET = (ページ番号 - 1) × 1ページあたりの件数

SQLクエリ = "SELECT * FROM テーブル ORDER BY カラム LIMIT " + 1ページあたりの件数 + " OFFSET " + OFFSET
```

### 例6：総レコード数と総ページ数の取得

総レコード数を取得するには：

```sql
SELECT COUNT(*) AS total_records FROM students;
```

実行結果：

| total_records |
|---------------|
| 100           |

この場合、1ページあたり10件表示なら、総ページ数は10ページ（CEILING(100 ÷ 10)）になります。

## 練習問題

### 問題8-1
grades（成績）テーブルから、得点（score）の高い順に上位5件の成績レコードを取得するSQLを書いてください。

### 問題8-2
course_schedule（授業カレンダー）テーブルから、日付（schedule_date）の新しい順に3件のスケジュールを取得するSQLを書いてください。

### 問題8-3
students（学生）テーブルを学生ID（student_id）の昇順で並べ、11番目から15番目までの学生（5件）を取得するSQLを書いてください。

### 問題8-4
teachers（教師）テーブルから、教師名（teacher_name）の五十音順で6番目から10番目までの教師情報を取得するSQLを書いてください。

### 問題8-5
1ページあたり20件表示で、grades（成績）テーブルの3ページ目のデータを得点（score）の高い順に取得するSQLを書いてください。

### 問題8-6
course_schedule（授業カレンダー）テーブルから、状態（status）が「scheduled」のスケジュールを日付（schedule_date）の昇順で並べ、先頭から10件スキップして次の5件を取得するSQLを書いてください。

## 解答

### 解答8-1
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 5;
```

### 解答8-2
```sql
SELECT * FROM course_schedule ORDER BY schedule_date DESC LIMIT 3;
```

### 解答8-3
```sql
SELECT * FROM students ORDER BY student_id LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM students ORDER BY student_id LIMIT 10, 5;
```

### 解答8-4
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5 OFFSET 5;
```
または
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5, 5;
```

### 解答8-5
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 20 OFFSET 40;
```
または
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 40, 20;
```

### 解答8-6
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 10, 5;
```

## まとめ

この章では、クエリ結果の件数を制限するためのLIMIT句と、ページネーションの実装方法について学びました：

1. **LIMIT句の基本**：指定した件数だけのレコードを取得する方法
2. **ORDER BYとの組み合わせ**：順序付けされた結果から一部だけを取得する方法
3. **OFFSET**：結果の先頭から指定した数だけレコードをスキップする方法
4. **ページネーション**：大量のデータを複数のページに分けて表示する実装方法
5. **注意点**：LIMIT句を使用する際の留意事項
6. **データベース製品による違い**：異なるデータベースでの構文の違い

LIMIT句は特にWebアプリケーションの開発で重要な機能です。大量のデータを効率よく表示するためのページネーション機能を実装するために欠かせません。また、トップN（上位N件）やボトムN（下位N件）のデータを取得する際にも使われます。

次の章では、データの集計分析を行うための「集計関数：COUNT、SUM、AVG、MAX、MIN」について学びます。




---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [9. 集計関数：COUNT、SUM、AVG、MAX、MIN](#9-集計関数countsumavgmaxmin)
2. [10. GROUP BY：データのグループ化](#10-group-byデータのグループ化)
3. [11. HAVING：グループ化後の絞り込み](#11-havingグループ化後の絞り込み)
4. [12. DISTINCT：重複の除外](#12-distinct重複の除外)
5. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)

---


# 9. 集計関数：COUNT、SUM、AVG、MAX、MIN

## はじめに

これまでの章では、データベースからレコードを取得して表示する方法を学んできました。しかし、データベースを使う目的の一つは、大量のデータから有用な情報（集計、統計など）を抽出することです。例えば：

- 「学生の総数は何人か？」
- 「成績の平均点は？」
- 「最高点と最低点は？」
- 「全講座の合計受講者数は？」

このような「データの集計」を行うためのSQLの機能が「集計関数」です。この章では、最もよく使われる5つの集計関数（COUNT、SUM、AVG、MAX、MIN）について学びます。

## 集計関数の基本

集計関数は、複数の行のデータをまとめて一つの値を返す関数です。

> **用語解説**：
> - **集計関数**：複数の行（レコード）から計算された単一の値を返す関数です。データの集計や統計に使用されます。

### 主な集計関数

| 関数   | 説明                     | 例                                 |
|--------|--------------------------|-------------------------------------|
| COUNT  | レコード数を数える        | 学生の総数                           |
| SUM    | 値の合計を計算する        | 全成績の点数合計                     |
| AVG    | 値の平均を計算する        | 平均点                             |
| MAX    | 最大値を取得する         | 最高点                             |
| MIN    | 最小値を取得する         | 最低点                             |

## COUNT関数：レコード数をカウントする

COUNT関数は、条件に一致するレコードの数を数えるのに使用します。

### 基本構文

```sql
SELECT COUNT(カラム名) FROM テーブル名 [WHERE 条件];
```

または、すべての行を数える場合：

```sql
SELECT COUNT(*) FROM テーブル名 [WHERE 条件];
```

### 例1：テーブル内の全レコード数

例えば、学生（students）テーブルの全学生数を数えるには：

```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

実行結果：

| 学生総数 |
|---------|
| 100     |

### 例2：条件付きのカウント

WHERE句と組み合わせることで、条件に一致するレコードだけをカウントできます。例えば、「出席（present）」状態の出席レコードの数を数えるには：

```sql
SELECT COUNT(*) AS 出席数 FROM attendance WHERE status = 'present';
```

実行結果：

| 出席数 |
|-------|
| 42    |

### 例3：NULL以外の値をカウント

COUNT(カラム名)を使うと、そのカラムがNULLでない行だけがカウントされます。これは、COUNT(*)との大きな違いです。例えば、コメント（comment）が入力されている出席レコードの数を数えるには：

```sql
SELECT COUNT(comment) AS コメントあり FROM attendance;
```

実行結果：

| コメントあり |
|------------|
| 23         |

### 例4：DISTINCTを使った重複のないカウント

DISTINCTを使うと、重複を除外してカウントできます。例えば、何種類の評価タイプ（grade_type）があるかを数えるには：

```sql
SELECT COUNT(DISTINCT grade_type) AS 評価タイプ数 FROM grades;
```

実行結果：

| 評価タイプ数 |
|------------|
| 3          |

## SUM関数：合計を計算する

SUM関数は、数値カラムの合計を計算するのに使用します。

### 基本構文

```sql
SELECT SUM(数値カラム) FROM テーブル名 [WHERE 条件];
```

### 例1：単純な合計

例えば、全成績レコードの得点（score）の合計を計算するには：

```sql
SELECT SUM(score) AS 総得点 FROM grades;
```

実行結果：

| 総得点   |
|---------|
| 3542.5  |

### 例2：条件付きの合計

WHERE句と組み合わせることで、条件に一致するレコードだけの合計を計算できます。例えば、「中間テスト」の得点合計を計算するには：

```sql
SELECT SUM(score) AS 中間テスト合計点 
FROM grades 
WHERE grade_type = '中間テスト';
```

実行結果：

| 中間テスト合計点 |
|----------------|
| 1728.0         |

### 例3：計算式を使った合計

計算式と組み合わせることもできます。例えば、全成績の達成率（score/max_score）の合計を計算するには：

```sql
SELECT SUM(score/max_score) AS 達成率合計 FROM grades;
```

実行結果：

| 達成率合計 |
|-----------|
| 39.86     |

## AVG関数：平均を計算する

AVG関数は、数値カラムの平均値を計算するのに使用します。

### 基本構文

```sql
SELECT AVG(数値カラム) FROM テーブル名 [WHERE 条件];
```

### 例1：単純な平均

例えば、全成績レコードの得点（score）の平均を計算するには：

```sql
SELECT AVG(score) AS 平均点 FROM grades;
```

実行結果：

| 平均点  |
|--------|
| 82.38  |

### 例2：条件付きの平均

WHERE句と組み合わせることで、条件に一致するレコードだけの平均を計算できます。例えば、「実技試験」の平均点を計算するには：

```sql
SELECT AVG(score) AS 実技試験平均点 
FROM grades 
WHERE grade_type = '実技試験';
```

実行結果：

| 実技試験平均点 |
|--------------|
| 85.6         |

### 例3：達成率（%）の計算

計算式と組み合わせることで、例えば平均達成率（%）を計算できます：

```sql
SELECT AVG(score/max_score * 100) AS 平均達成率 FROM grades;
```

実行結果：

| 平均達成率 |
|-----------|
| 87.24     |

## MAX関数：最大値を取得する

MAX関数は、数値、文字列、日付などのカラムから最大値を取得するのに使用します。

### 基本構文

```sql
SELECT MAX(カラム名) FROM テーブル名 [WHERE 条件];
```

### 例1：数値の最大値

例えば、全成績レコードの中での最高点を取得するには：

```sql
SELECT MAX(score) AS 最高点 FROM grades;
```

実行結果：

| 最高点 |
|-------|
| 95.0  |

### 例2：文字列の最大値（辞書順で最後）

MAX関数は文字列にも使用でき、この場合は辞書順で「最後」の値を返します。例えば、学生名の辞書順で最後の値（最も「わ行」に近い名前）を取得するには：

```sql
SELECT MAX(student_name) AS 学生名最終 FROM students;
```

実行結果：

| 学生名最終 |
|----------|
| 吉川伽羅  |

### 例3：日付の最大値（最新の日付）

日付にMAX関数を使うと、最新（最も未来）の日付が取得できます。例えば、最も新しい提出日を取得するには：

```sql
SELECT MAX(submission_date) AS 最新提出日 FROM grades;
```

実行結果：

| 最新提出日   |
|------------|
| 2025-05-20 |

## MIN関数：最小値を取得する

MIN関数は、数値、文字列、日付などのカラムから最小値を取得するのに使用します。

### 基本構文

```sql
SELECT MIN(カラム名) FROM テーブル名 [WHERE 条件];
```

### 例1：数値の最小値

例えば、全成績レコードの中での最低点を取得するには：

```sql
SELECT MIN(score) AS 最低点 FROM grades;
```

実行結果：

| 最低点 |
|-------|
| 68.0  |

### 例2：文字列の最小値（辞書順で最初）

MIN関数は文字列にも使用でき、この場合は辞書順で「最初」の値を返します。例えば、学生名の辞書順で最初の値（最も「あ行」に近い名前）を取得するには：

```sql
SELECT MIN(student_name) AS 学生名最初 FROM students;
```

実行結果：

| 学生名最初 |
|----------|
| 相沢吉夫  |

### 例3：日付の最小値（最古の日付）

日付にMIN関数を使うと、最も古い日付が取得できます。例えば、最も古い提出日を取得するには：

```sql
SELECT MIN(submission_date) AS 最古提出日 FROM grades;
```

実行結果：

| 最古提出日   |
|------------|
| 2025-05-06 |

## 複数の集計関数の組み合わせ

複数の集計関数を一つのクエリで使用することもできます。

### 例：成績の統計情報

例えば、成績（grades）テーブルの統計情報を一度に取得するには：

```sql
SELECT 
    COUNT(*) AS レコード数,
    AVG(score) AS 平均点,
    SUM(score) AS 合計点,
    MAX(score) AS 最高点,
    MIN(score) AS 最低点
FROM grades;
```

実行結果：

| レコード数 | 平均点 | 合計点  | 最高点 | 最低点 |
|---------|--------|--------|-------|-------|
| 43      | 82.38  | 3542.5 | 95.0  | 68.0  |

## 集計関数とGROUP BY（次章の内容）

集計関数をより強力に使うためには、「GROUP BY」句と組み合わせます。これにより、データをグループ化して各グループごとに集計できます。GROUP BYについては次章で詳しく学びます。

例えば、講座（course_id）ごとの平均点を計算するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id;
```

実行結果：

| course_id | 平均点 |
|-----------|--------|
| 1         | 86.2   |
| 2         | 83.8   |
| 3         | 80.5   |
| ...       | ...    |

この例の詳細な説明は次章で行います。

## 練習問題

### 問題9-1
students（学生）テーブルから、学生の総数を取得するSQLを書いてください。

### 問題9-2
grades（成績）テーブルから、全成績の平均点（score）を取得するSQLを書いてください。

### 問題9-3
attendance（出席）テーブルから、出席状況（status）が「absent」のレコード数を取得するSQLを書いてください。

### 問題9-4
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」の成績の最高点と最低点を取得するSQLを書いてください。

### 問題9-5
course_schedule（授業カレンダー）テーブルから、最新（schedule_dateが最大）の授業スケジュールの日付を取得するSQLを書いてください。

### 問題9-6
grades（成績）テーブルから、成績の総数、平均点、合計点、最高点、最低点を一度に取得するSQLを書いてください。

## 解答

### 解答9-1
```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

### 解答9-2
```sql
SELECT AVG(score) AS 全成績平均点 FROM grades;
```

### 解答9-3
```sql
SELECT COUNT(*) AS 欠席数 FROM attendance WHERE status = 'absent';
```

### 解答9-4
```sql
SELECT 
    MAX(score) AS 中間テスト最高点,
    MIN(score) AS 中間テスト最低点
FROM grades 
WHERE grade_type = '中間テスト';
```

### 解答9-5
```sql
SELECT MAX(schedule_date) AS 最新授業日 FROM course_schedule;
```

### 解答9-6
```sql
SELECT 
    COUNT(*) AS 成績総数,
    AVG(score) AS 平均点,
    SUM(score) AS 合計点,
    MAX(score) AS 最高点,
    MIN(score) AS 最低点
FROM grades;
```

## まとめ

この章では、データの集計と分析に使用される主要な集計関数について学びました：

1. **COUNT**：レコード数をカウントする関数
2. **SUM**：数値の合計を計算する関数
3. **AVG**：数値の平均を計算する関数
4. **MAX**：最大値（数値、文字列、日付など）を取得する関数
5. **MIN**：最小値（数値、文字列、日付など）を取得する関数

これらの集計関数を使うことで、大量のデータから意味のある統計情報を簡単に抽出できます。ビジネスにおける意思決定や、データ分析において非常に重要な機能です。

次の章では、データをグループ化して集計を行うための「GROUP BY：データのグループ化」について学びます。



---

# 10. GROUP BY：データのグループ化

## はじめに

前章では、集計関数（COUNT、SUM、AVG、MAX、MIN）を使って全体的な集計や統計を計算する方法を学びました。しかし実際のデータ分析では、全体の集計だけでなく、特定のカテゴリや条件ごとに集計したい場合が多くあります。例えば：

- 「講座ごとの平均点は？」
- 「教師ごとの担当講座数は？」
- 「日付ごとの授業数は？」
- 「出席状況（出席/遅刻/欠席）の割合は？」

このような「グループごとの集計」を行うためのSQLコマンドが「GROUP BY」です。この章では、データをグループ化して集計する方法について学びます。

## GROUP BYの基本

GROUP BY句は、指定したカラムの値が同じレコードをグループ化し、それぞれのグループに対して集計関数を適用するために使います。

> **用語解説**：
> - **GROUP BY**：「〜でグループ化する」という意味のSQLコマンドで、同じ値を持つレコードをまとめてグループにします。
> - **グループ化**：データを特定の条件で分類し、それぞれの分類ごとに集計を行うこと。

### 基本構文

```sql
SELECT カラム名, 集計関数
FROM テーブル名
[WHERE 条件]
GROUP BY グループ化するカラム名;
```

重要なのは、SELECT句に含めるカラムは、GROUP BY句で指定したカラムか、集計関数（COUNT、SUM、AVG、MAX、MINなど）のいずれかでなければならないということです。

### 例1：単純なグループ化

例えば、成績（grades）テーブルから、評価タイプ（grade_type）ごとの成績レコード数を集計するには：

```sql
SELECT grade_type, COUNT(*) AS レコード数
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | レコード数 |
|-------------|-----------|
| 中間テスト   | 12        |
| レポート1    | 22        |
| 実技試験     | 9         |

### 例2：グループごとの平均

グループごとの平均を計算することも一般的です。例えば、各評価タイプごとの平均点を計算するには：

```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均点    |
|-------------|----------|
| 中間テスト   | 86.25    |
| レポート1    | 44.77    |
| 実技試験     | 85.61    |

## 複数のカラムによるグループ化

複数のカラムを指定してグループ化することもできます。この場合、指定したすべてのカラムの値の組み合わせがグループの単位になります。

### 例3：複数カラムでのグループ化

例えば、講座（course_id）と評価タイプ（grade_type）の組み合わせごとに成績の平均を計算するには：

```sql
SELECT course_id, grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY course_id, grade_type;
```

実行結果：

| course_id | grade_type  | 平均点    |
|-----------|-------------|----------|
| 1         | 中間テスト   | 87.33    |
| 1         | レポート1    | 45.39    |
| 2         | 実技試験     | 86.83    |
| ...       | ...         | ...      |

### グループ化の順序

GROUP BY句でカラムを指定する順序は、結果には影響しません。しかし、可読性のためにSELECT句と同じ順序で指定することが一般的です。

## WHERE句とGROUP BYの組み合わせ

WHERE句は、グループ化する前に行単位でレコードを絞り込むのに使います。

> **用語解説**：
> - **絞り込み順序**：WHERE句はGROUP BY句の前に評価され、条件に合うレコードだけがグループ化の対象になります。

### 例4：WHEREとGROUP BYの組み合わせ

例えば、得点（score）が80以上の成績だけを対象に、評価タイプごとの平均を計算するには：

```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
WHERE score >= 80
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均点    |
|-------------|----------|
| 中間テスト   | 88.92    |
| 実技試験     | 87.25    |

この例では、score >= 80の条件に一致するレコードだけがグループ化され、集計されています。レポート1はすべての点数が80未満なので、結果には表示されていません。

## GROUP BYとORDER BYの組み合わせ

GROUP BY句とORDER BY句を組み合わせることで、グループ化した結果を任意の順序で並べることができます。

### 例5：GROUP BYとORDER BYの組み合わせ

例えば、講座（course_id）ごとの平均点を計算し、平均点の高い順に並べるには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
ORDER BY 平均点 DESC;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| 2         | 83.79    |
| 5         | 82.33    |
| ...       | ...      |

## 集計関数の複数使用

一つのクエリで複数の集計関数を使用することもできます。

### 例6：複数の集計関数の使用

例えば、評価タイプごとの成績数、平均点、最高点、最低点を一度に取得するには：

```sql
SELECT grade_type, 
       COUNT(*) AS 成績数,
       AVG(score) AS 平均点,
       MAX(score) AS 最高点,
       MIN(score) AS 最低点
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 成績数 | 平均点    | 最高点 | 最低点 |
|-------------|-------|----------|-------|-------|
| 中間テスト   | 12    | 86.25    | 95.0  | 78.5  |
| レポート1    | 22    | 44.77    | 49.0  | 37.0  |
| 実技試験     | 9     | 85.61    | 88.0  | 79.5  |

## 計算式を含むグループ化

GROUP BY句で集計した結果に対して、さらに計算を加えることができます。

### 例7：計算式を含むグループ化

例えば、評価タイプごとに平均達成率（score/max_score）を計算するには：

```sql
SELECT grade_type, 
       AVG(score/max_score * 100) AS 平均達成率
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均達成率 |
|-------------|-----------|
| 中間テスト   | 86.25     |
| レポート1    | 89.54     |
| 実技試験     | 85.61     |

## GROUP BYとNULLの扱い

GROUP BY句でグループ化する際、NULL値も一つのグループとして扱われます。

### 例8：NULLを含むグループ化

例えば、出席（attendance）テーブルから、コメント（comment）の有無でグループ化し、それぞれの件数を数えるには：

```sql
SELECT 
    CASE 
        WHEN comment IS NULL THEN 'コメントなし'
        ELSE 'コメントあり'
    END AS コメント状態,
    COUNT(*) AS 件数
FROM attendance
GROUP BY 
    CASE 
        WHEN comment IS NULL THEN 'コメントなし'
        ELSE 'コメントあり'
    END;
```

実行結果：

| コメント状態   | 件数  |
|--------------|-------|
| コメントなし   | 20    |
| コメントあり   | 23    |

## HAVINGを使ったグループの絞り込み（次章の内容）

グループ化した後にさらに条件でグループを絞り込むには、「HAVING」句を使います。これについては次章で詳しく学びます。

例えば、5人以上の学生が受講している講座だけを取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 学生数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題10-1
courses（講座）テーブルから、教師ID（teacher_id）ごとに担当している講座の数を取得するSQLを書いてください。

### 問題10-2
attendance（出席）テーブルから、出席状況（status）ごとのレコード数を取得するSQLを書いてください。

### 問題10-3
grades（成績）テーブルから、学生ID（student_id）ごとの平均点を計算し、平均点の高い順に並べるSQLを書いてください。

### 問題10-4
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）ごとに予定されている授業の数を取得するSQLを書いてください。

### 問題10-5
grades（成績）テーブルから、講座ID（course_id）と評価タイプ（grade_type）の組み合わせごとの平均点を計算し、講座ID順、さらに評価タイプ順で並べるSQLを書いてください。

### 問題10-6
student_courses（受講）テーブルから、講座ID（course_id）ごとの受講者数を取得し、受講者数の多い順に並べるSQLを書いてください。

## 解答

### 解答10-1
```sql
SELECT teacher_id, COUNT(course_id) AS 担当講座数
FROM courses
GROUP BY teacher_id;
```

### 解答10-2
```sql
SELECT status, COUNT(*) AS レコード数
FROM attendance
GROUP BY status;
```

### 解答10-3
```sql
SELECT student_id, AVG(score) AS 平均点
FROM grades
GROUP BY student_id
ORDER BY 平均点 DESC;
```

### 解答10-4
```sql
SELECT classroom_id, COUNT(*) AS 授業数
FROM course_schedule
GROUP BY classroom_id;
```

### 解答10-5
```sql
SELECT course_id, grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY course_id, grade_type
ORDER BY course_id, grade_type;
```

### 解答10-6
```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
ORDER BY 受講者数 DESC;
```

## まとめ

この章では、データをグループ化して集計するためのGROUP BY句について学びました：

1. **GROUP BYの基本**：同じ値を持つレコードをグループ化する方法
2. **集計関数との組み合わせ**：グループごとの集計を行う方法
3. **複数カラムによるグループ化**：複数の条件でのグループ化
4. **WHERE句との組み合わせ**：グループ化前のレコード絞り込み
5. **ORDER BYとの組み合わせ**：グループ化結果の並び替え
6. **複数の集計関数の使用**：一度に複数の統計値を取得する方法
7. **計算式を含むグループ化**：より複雑な集計の実現
8. **NULLの扱い**：グループ化におけるNULL値の取り扱い

GROUP BY句を使うことで、データのさまざまな側面から分析が可能になり、意思決定のための有用な情報を抽出できるようになります。

次の章では、グループ化した結果をさらに条件で絞り込むための「HAVING：グループ化後の絞り込み」について学びます。



---

# 11. HAVING：グループ化後の絞り込み

## はじめに

前章では、GROUP BY句を使ってデータをグループ化し、各グループごとに集計を行う方法を学びました。しかし、すべてのグループの集計結果を表示するのではなく、特定の条件を満たすグループだけを表示したい場合があります。例えば：

- 「平均点が80点以上の講座だけを表示したい」
- 「5人以上の学生が登録している講座だけを取得したい」
- 「出席率が90%を超える学生だけをリストアップしたい」

このような「グループ化した結果をさらに絞り込む」ためのSQLコマンドが「HAVING」句です。この章では、グループ化した結果に条件を適用する方法について学びます。

## HAVINGの基本

HAVING句は、GROUP BY句でグループ化した後の結果に対して条件を適用し、条件を満たすグループだけを取得するために使います。

> **用語解説**：
> - **HAVING**：「〜を持っている」という意味のSQLコマンドで、グループ化した結果に対して条件を適用します。

### 基本構文

```sql
SELECT カラム名, 集計関数
FROM テーブル名
[WHERE 行レベルの条件]
GROUP BY グループ化するカラム名
HAVING グループレベルの条件;
```

### 例1：基本的なHAVINGの使用

例えば、受講者数が5人以上の講座だけを取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5;
```

実行結果：

| course_id | 受講者数 |
|-----------|---------|
| 1         | 12      |
| 2         | 8       |
| 4         | 7       |
| 5         | 7       |
| ...       | ...     |

この例では、まず講座ID（course_id）ごとに学生ID（student_id）の数を数え、その後でHAVING句を使って受講者数が5人以上のグループだけを抽出しています。

## WHEREとHAVINGの違い

WHERE句とHAVING句は似ていますが、適用されるタイミングと対象が異なります：

- **WHERE**：グループ化される前の個々の行（レコード）に対して条件を適用します。
- **HAVING**：グループ化された後のグループに対して条件を適用します。

> **用語解説**：
> - **行レベルのフィルタリング**：WHEREによる個々のレコードの絞り込み
> - **グループレベルのフィルタリング**：HAVINGによるグループの絞り込み

### 例2：WHEREとHAVINGの違い

以下の例で違いを確認しましょう：

```sql
-- WHERE（行レベル）：まず80点以上の成績だけを選び、それからグループ化
SELECT course_id, AVG(score) AS 平均点
FROM grades
WHERE score >= 80
GROUP BY course_id;

-- HAVING（グループレベル）：まずグループ化して平均点を計算し、それから平均点が80以上のグループを選ぶ
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
HAVING AVG(score) >= 80;
```

1つ目のクエリは、「80点以上の成績だけ」を対象に講座ごとの平均点を計算します。
2つ目のクエリは、「講座の平均点が80点以上」の講座だけを取得します。

**WHERE句の結果**：

| course_id | 平均点    |
|-----------|----------|
| 1         | 88.92    |
| 2         | 87.25    |
| ...       | ...      |

**HAVING句の結果**：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| 2         | 83.79    |
| 5         | 82.33    |
| ...       | ...      |

## HAVINGで使用できる条件

HAVING句では、集計関数（COUNT、SUM、AVG、MAX、MINなど）を使った条件や、GROUP BY句で指定したカラムに対する条件を指定できます。

### 例3：集計関数を使った条件

例えば、平均点が85点以上の講座を取得するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
HAVING AVG(score) >= 85;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| ...       | ...      |

### 例4：複数条件の指定

HAVING句も、WHERE句と同様に複数の条件を組み合わせることができます：

```sql
SELECT grade_type, COUNT(*) AS 件数, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type
HAVING COUNT(*) > 10 AND AVG(score) > 80;
```

実行結果：

| grade_type | 件数 | 平均点    |
|------------|-----|----------|
| 中間テスト  | 12  | 86.25    |
| ...        | ... | ...      |

## WHEREとHAVINGの組み合わせ

実際のクエリでは、WHERE句とHAVING句を組み合わせることが多いです。WHERE句でグループ化前の行を絞り込み、HAVING句でグループ化後の結果をさらに絞り込みます。

### 例5：WHEREとHAVINGの組み合わせ

例えば、「中間テストのみを対象として、平均点が85点以上の講座」を取得するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
WHERE grade_type = '中間テスト'
GROUP BY course_id
HAVING AVG(score) >= 85;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 87.33    |
| ...       | ...      |

## HAVINGとORDER BYの組み合わせ

HAVING句で絞り込んだ結果を並べ替えるには、ORDER BY句を追加します。

### 例6：HAVINGとORDER BYの組み合わせ

例えば、受講者数が5人以上の講座を、受講者数の多い順に並べて取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5
ORDER BY 受講者数 DESC;
```

実行結果：

| course_id | 受講者数 |
|-----------|---------|
| 1         | 12      |
| 20        | 11      |
| 9         | 10      |
| ...       | ...     |

## 実践的なHAVINGの使用例

### 例7：「平均達成率が90%を超える評価タイプ」の抽出

各評価タイプごとの平均達成率（score/max_score）を計算し、90%を超えるものだけを取得します：

```sql
SELECT grade_type, 
       AVG(score/max_score * 100) AS 平均達成率
FROM grades
GROUP BY grade_type
HAVING AVG(score/max_score * 100) > 90;
```

実行結果：

| grade_type | 平均達成率 |
|------------|----------|
| レポート1   | 93.54    |
| ...        | ...      |

### 例8：「特定の講座で成績データが存在する学生」の抽出

例えば、講座ID「1」の成績が2件以上ある学生を取得します：

```sql
SELECT student_id, COUNT(*) AS 成績件数
FROM grades
WHERE course_id = '1'
GROUP BY student_id
HAVING COUNT(*) >= 2;
```

実行結果：

| student_id | 成績件数 |
|------------|---------|
| 301        | 2       |
| 302        | 2       |
| ...        | ...     |

## HAVINGでの注意点

1. **集計関数の使用**: HAVINGで使用する条件には、通常、集計関数（COUNT、SUM、AVG、MAX、MINなど）が含まれます。単純なカラム比較だけならWHERE句を使用すべきです。

2. **パフォーマンスの考慮**: WHERE句はグループ化前に適用されるため、処理対象のレコード数を減らすことができます。可能な限り、グループ化前の条件はWHERE句で指定し、グループ化後の条件だけをHAVING句で指定するようにすると、効率的なクエリになります。

3. **グループレベルの条件**: HAVING句は、GROUP BY句で指定したカラムや集計関数の結果に対する条件でなければならないことを覚えておきましょう。

## 練習問題

### 問題11-1
student_courses（受講）テーブルから、受講者数が8人以上の講座ID（course_id）を取得するSQLを書いてください。

### 問題11-2
grades（成績）テーブルから、平均点（score）が85点以上の評価タイプ（grade_type）を取得するSQLを書いてください。

### 問題11-3
courses（講座）テーブルから、各教師（teacher_id）が担当する講座数を計算し、担当講座が3つ以上の教師だけを取得するSQLを書いてください。

### 問題11-4
grades（成績）テーブルから、講座ID（course_id）ごとの最高点（score）を計算し、最高点が90点以上の講座を、最高点の高い順に並べて取得するSQLを書いてください。

### 問題11-5
attendance（出席）テーブルから、欠席（status = 'absent'）の回数が2回以上ある学生ID（student_id）を取得するSQLを書いてください。

### 問題11-6
grades（成績）テーブルを使って、中間テスト（grade_type = '中間テスト'）のデータのみを対象に、平均点が85点以上で、かつ最低点が75点以上の講座ID（course_id）を取得するSQLを書いてください。

## 解答

### 解答11-1
```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 8;
```

### 解答11-2
```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type
HAVING AVG(score) >= 85;
```

### 解答11-3
```sql
SELECT teacher_id, COUNT(course_id) AS 担当講座数
FROM courses
GROUP BY teacher_id
HAVING COUNT(course_id) >= 3;
```

### 解答11-4
```sql
SELECT course_id, MAX(score) AS 最高点
FROM grades
GROUP BY course_id
HAVING MAX(score) >= 90
ORDER BY 最高点 DESC;
```

### 解答11-5
```sql
SELECT student_id, COUNT(*) AS 欠席回数
FROM attendance
WHERE status = 'absent'
GROUP BY student_id
HAVING COUNT(*) >= 2;
```

### 解答11-6
```sql
SELECT course_id, AVG(score) AS 平均点, MIN(score) AS 最低点
FROM grades
WHERE grade_type = '中間テスト'
GROUP BY course_id
HAVING AVG(score) >= 85 AND MIN(score) >= 75;
```

## まとめ

この章では、グループ化した結果に条件を適用するためのHAVING句について学びました：

1. **HAVINGの基本**：グループ化した結果に条件を適用する方法
2. **WHEREとHAVINGの違い**：
   - WHERE：グループ化前の行レベルのフィルタリング
   - HAVING：グループ化後のグループレベルのフィルタリング
3. **HAVING句での条件**：集計関数を使った条件設定
4. **複合条件**：ANDやORを使った複数条件の組み合わせ
5. **WHERE、HAVING、ORDER BYの組み合わせ**：複雑なデータ抽出の手法
6. **実践的な使用例**：実際の業務で使われるようなクエリパターン

HAVING句はデータ分析において非常に重要です。グループ化されたデータに対して「どのグループが重要か」「どのグループに注目すべきか」という条件を設定することで、より意味のある情報を抽出することができます。

次の章では、重複データを除外するための「DISTINCT：重複の除外」について学びます。



---

# 12. DISTINCT：重複の除外

## はじめに

データベースから情報を取得する際、同じ値が複数回出現することがよくあります。例えば、「どの講座がどの教室で行われているか」を調べると、同じ教室が複数回リストされるでしょう。しかし、時には重複を除いた一意の値のリストだけが必要な場合があります。例えば：

- 「学校にはどんな教室があるか」（重複なく知りたい）
- 「どの教師が授業を担当しているか」（重複なく知りたい）
- 「どのような評価タイプがあるか」（重複なく知りたい）

このような「重複を除外」するためのSQLキーワードが「DISTINCT」です。この章では、クエリ結果から重複するデータを除外する方法について学びます。

## DISTINCTの基本

DISTINCT句は、SELECT文の結果から重複する行を除外するために使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別される」という意味のSQLキーワードで、クエリ結果から重複する行を除外します。
> - **重複除外**：同じ値を持つレコードを1つだけにして、残りを除外すること。

### 基本構文

```sql
SELECT DISTINCT カラム名 FROM テーブル名 [WHERE 条件];
```

DISTINCTは、SELECT文の直後に配置され、すべての指定されたカラムの組み合わせに対して働きます。

### 例1：単一カラムでの重複除外

例えば、成績テーブル（grades）から、どのような評価タイプ（grade_type）があるかを重複なしで取得するには：

```sql
SELECT DISTINCT grade_type FROM grades;
```

実行結果：

| grade_type  |
|-------------|
| 中間テスト   |
| レポート1    |
| 実技試験     |

通常のSELECT文では、テーブル内の各行の評価タイプが表示されますが、DISTINCTを使うと、一意の評価タイプだけが表示されます。

### 例2：出席状況の種類の取得

出席（attendance）テーブルから、どのような出席状況（status）があるかを重複なしで取得するには：

```sql
SELECT DISTINCT status FROM attendance;
```

実行結果：

| status  |
|---------|
| present |
| late    |
| absent  |

## 複数カラムでのDISTINCT

DISTINCTは複数のカラムにも適用できます。この場合、指定したすべてのカラムの値の組み合わせが一意であるレコードだけが返されます。

### 基本構文

```sql
SELECT DISTINCT カラム名1, カラム名2, ... FROM テーブル名 [WHERE 条件];
```

### 例3：複数カラムでの重複除外

例えば、授業スケジュール（course_schedule）テーブルから、どの講座（course_id）がどの時限（period_id）に開講されているかを重複なしで取得するには：

```sql
SELECT DISTINCT course_id, period_id FROM course_schedule;
```

実行結果：

| course_id | period_id |
|-----------|-----------|
| 1         | 1         |
| 2         | 3         |
| 3         | 4         |
| 4         | 2         |
| ...       | ...       |

この結果は、course_idとperiod_idの組み合わせが一意のレコードのみを表示します。同じ講座が異なる時限に開講される場合や、異なる講座が同じ時限に開講される場合は、別々のレコードとして表示されます。

## COUNT関数との組み合わせ

DISTINCTはCOUNT関数と組み合わせることで、一意の値の数を数えることができます。

### 例4：一意の値の数を数える

例えば、学生（students）テーブルに何人の学生が登録されているかを数えるには：

```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

実行結果：

| 学生総数 |
|---------|
| 100     |

一方、受講（student_courses）テーブルに登録されている一意の学生数を数えるには：

```sql
SELECT COUNT(DISTINCT student_id) AS 受講学生数 FROM student_courses;
```

実行結果：

| 受講学生数 |
|-----------|
| 85        |

この2つの結果の差は、まだ1つも講座を受講していない学生が15人いることを意味します。

## DISTINCTとNULLの扱い

DISTINCTを使う場合、NULL値も1つの値として扱われます。複数のNULL値は1つのNULL値として集約されます。

### 例5：NULLを含むデータでのDISTINCT

例えば、出席（attendance）テーブルから、コメント（comment）の一意の値を取得するとします：

```sql
SELECT DISTINCT comment FROM attendance;
```

実行結果：

| comment       |
|---------------|
| NULL          |
| 15分遅刻      |
| 5分遅刻       |
| 事前連絡あり  |
| 体調不良      |
| ...           |

この結果には、NULL値も1つの行として含まれています。

## DISTINCTとORDER BYの組み合わせ

DISTINCTはORDER BY句と組み合わせて使うことができます。これにより、重複を除外した後で結果を並べ替えることができます。

### 例6：DISTINCTとORDER BYの組み合わせ

例えば、講座（courses）テーブルから、どの教師（teacher_id）が講座を担当しているかを重複なしで取得し、教師IDの順に並べるには：

```sql
SELECT DISTINCT teacher_id FROM courses ORDER BY teacher_id;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

## DISTINCTとWHEREの組み合わせ

DISTINCTはWHERE句と組み合わせて使うこともできます。これにより、特定の条件に合うレコードだけを対象に重複を除外できます。

### 例7：DISTINCTとWHEREの組み合わせ

例えば、2025年5月に授業がある教室（classroom_id）の一覧を重複なしで取得するには：

```sql
SELECT DISTINCT classroom_id
FROM course_schedule
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

実行結果：

| classroom_id |
|--------------|
| 101A         |
| 102B         |
| 201C         |
| 202D         |
| ...          |

## DISTINCTとGROUP BYの違い

DISTINCTとGROUP BYはどちらも「重複を除外する」という点では似ていますが、目的と使い方に違いがあります。

- **DISTINCT**：単純に重複する行を除外します。
- **GROUP BY**：グループごとに集計を行うために使います。集計関数（COUNT、SUM、AVG、MAX、MINなど）と一緒に使うことが一般的です。

### 例8：DISTINCTとGROUP BYの比較

例えば、講座（courses）テーブルから、どの教師（teacher_id）が講座を担当しているかを調べる場合：

DISTINCTを使う方法：
```sql
SELECT DISTINCT teacher_id FROM courses;
```

GROUP BYを使う方法：
```sql
SELECT teacher_id FROM courses GROUP BY teacher_id;
```

両方とも同じ結果を返しますが、目的が異なります。GROUP BYは集計を行うためのもので、例えば各教師が担当する講座数を数えたい場合は：

```sql
SELECT teacher_id, COUNT(*) AS 担当講座数
FROM courses
GROUP BY teacher_id;
```

このように、GROUP BYと集計関数を組み合わせて使います。

## パフォーマンスへの影響と注意点

1. **処理コスト**：DISTINCTはすべての行を調査して重複を除外するため、大量のデータがある場合は処理コストが高くなる可能性があります。

2. **代替手段の検討**：場合によっては、DISTINCTの代わりにGROUP BYを使ったり、EXISTS/NOT EXISTSを使ったりと、より効率的な方法があることがあります。

3. **部分一致には使えない**：DISTINCTは完全に一致するレコードのみを対象とします。部分的な一致や似ているレコードの除外には使えません。

## 練習問題

### 問題12-1
course_schedule（授業カレンダー）テーブルから、授業が行われる日付（schedule_date）のリストを重複なしで取得するSQLを書いてください。

### 問題12-2
grades（成績）テーブルから、何種類の評価タイプ（grade_type）があるかを数えるSQLを書いてください。

### 問題12-3
student_courses（受講）テーブルから、講座を受講している学生ID（student_id）を重複なしで取得し、IDの昇順に並べるSQLを書いてください。

### 問題12-4
course_schedule（授業カレンダー）テーブルから、どの教室（classroom_id）でどの時限（period_id）に授業が行われているかの組み合わせを重複なしで取得するSQLを書いてください。

### 問題12-5
attendance（出席）テーブルから、コメント（comment）が入力されている（NULLでない）一意のコメント内容を取得するSQLを書いてください。

### 問題12-6
grades（成績）テーブルから、どの学生（student_id）がどの講座（course_id）を受講したかの組み合わせを重複なしで取得し、学生ID、講座IDの順に並べるSQLを書いてください。

## 解答

### 解答12-1
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

### 解答12-2
```sql
SELECT COUNT(DISTINCT grade_type) AS 評価タイプ数 FROM grades;
```

### 解答12-3
```sql
SELECT DISTINCT student_id FROM student_courses ORDER BY student_id;
```

### 解答12-4
```sql
SELECT DISTINCT classroom_id, period_id FROM course_schedule;
```

### 解答12-5
```sql
SELECT DISTINCT comment FROM attendance WHERE comment IS NOT NULL;
```

### 解答12-6
```sql
SELECT DISTINCT student_id, course_id 
FROM grades 
ORDER BY student_id, course_id;
```

## まとめ

この章では、クエリ結果から重複を除外するためのDISTINCTキーワードについて学びました：

1. **DISTINCTの基本**：クエリ結果から重複する行を除外する方法
2. **単一カラムでの使用**：1つのカラムの重複を除外する方法
3. **複数カラムでの使用**：複数カラムの組み合わせの重複を除外する方法
4. **COUNT関数との組み合わせ**：一意の値の数を数える方法
5. **NULLの扱い**：DISTINCT使用時のNULL値の取り扱い
6. **ORDER BYとの組み合わせ**：重複除外後の並べ替え
7. **WHEREとの組み合わせ**：条件付きでの重複除外
8. **GROUP BYとの違い**：似た機能を持つGROUP BYとの使い分け
9. **パフォーマンスへの影響**：DISTINCTを使用する際の注意点

DISTINCTは、データベースから一意の値のリストを取得するための便利な機能です。特に、テーブル内の特定のカラムにどのような値が存在するかを調べたい場合や、重複のないマスターリストを作成したい場合に役立ちます。

次の章では、複数のテーブルを結合して情報を取得するための「JOIN基本：テーブル結合の概念」について学びます。



---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [1. SELECT基本：単一テーブルから特定カラムを取得する](#1-select基本単一テーブルから特定カラムを取得する)
2. [2. WHERE句：条件に合ったレコードを絞り込む](#2-where句条件に合ったレコードを絞り込む)
3. [3. 論理演算子：AND、OR、NOTを使った複合条件](#3-論理演算子andornotを使った複合条件)
4. [4. パターンマッチング：LIKE演算子と%、_ワイルドカード](#4-パターンマッチングlike演算子と_ワイルドカード)
5. [5. 範囲指定：BETWEEN、IN演算子](#5-範囲指定betweenin演算子)
6. [6. NULL値の処理：IS NULL、IS NOT NULL](#6-null値の処理is-nullis-not-null)
7. [7. ORDER BY：結果の並び替え](#7-order-by結果の並び替え)
8. [8. LIMIT句：結果件数の制限とページネーション](#8-limit句結果件数の制限とページネーション)

---


# 1. SELECT基本：単一テーブルから特定カラムを取得する

## はじめに

データベースからデータを取り出す作業は、料理人が大きな冷蔵庫から必要な材料だけを取り出すようなものです。SQLでは、この「取り出す」作業を「SELECT文」で行います。

SELECT文はSQLの中で最も基本的で、最もよく使われる命令です。この章では、単一のテーブル（データの表）から必要な情報だけを取り出す方法を学びます。

## 基本構文

SELECT文の最も基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名;
```

この文は「テーブル名というテーブルからカラム名という列のデータを取り出してください」という意味です。

> **用語解説**：
> - **SELECT**：「選択する」という意味のSQLコマンドで、データを取り出すときに使います。
> - **カラム**：テーブルの縦の列のことで、同じ種類のデータが並んでいます（例：名前のカラム、年齢のカラムなど）。
> - **FROM**：「〜から」という意味で、どのテーブルからデータを取るかを指定します。
> - **テーブル**：データベース内の表のことで、行と列で構成されています。

## 実践例：単一カラムの取得

学校データベースの中の「teachers」テーブル（教師テーブル）から、教師の名前だけを取得してみましょう。

```sql
SELECT teacher_name FROM teachers;
```

実行結果：

| teacher_name |
|--------------|
| 寺内鞍       |
| 田尻朋美     |
| 内村海凪     |
| 藤本理恵     |
| 黒木大介     |
| 星野涼子     |
| 深山誠一     |
| 吉岡由佳     |
| 山田太郎     |
| 佐藤花子     |
| ...          |

これは「teachers」テーブルの「teacher_name」という列（先生の名前）だけを取り出しています。

## 複数のカラムを取得する

料理に複数の材料が必要なように、データを取り出すときも複数の列が必要なことがよくあります。複数のカラムを取得するには、カラム名をカンマ（,）で区切って指定します。

```sql
SELECT カラム名1, カラム名2, カラム名3 FROM テーブル名;
```

例えば、教師の番号（ID）と名前を一緒に取得してみましょう：

```sql
SELECT teacher_id, teacher_name FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| 104        | 藤本理恵     |
| 105        | 黒木大介     |
| 106        | 星野涼子     |
| ...        | ...          |

## すべてのカラムを取得する

テーブルのすべての列を取得したい場合は、アスタリスク（*）を使います。これは「すべての列」を意味するワイルドカードです。

```sql
SELECT * FROM テーブル名;
```

例：
```sql
SELECT * FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| ...        | ...          |

> **注意**：`SELECT *`は便利ですが、実際の業務では必要なカラムだけを指定する方が良いとされています。これは、データ量が多いときに処理速度が遅くなるのを防ぐためです。

## カラムに別名をつける（AS句）

取得したカラムに分かりやすい名前（別名）をつけることができます。これは「AS」句を使います。

```sql
SELECT カラム名 AS 別名 FROM テーブル名;
```

> **用語解説**：
> - **AS**：「〜として」という意味で、カラムに別名をつけるときに使います。この別名は結果を表示するときだけ使われます。

例えば、教師IDを「番号」、教師名を「名前」として表示してみましょう：

```sql
SELECT teacher_id AS 番号, teacher_name AS 名前 FROM teachers;
```

実行結果：

| 番号  | 名前       |
|------|------------|
| 101  | 寺内鞍     |
| 102  | 田尻朋美   |
| 103  | 内村海凪   |
| ...  | ...        |

ASは省略することも可能です：

```sql
SELECT teacher_id 番号, teacher_name 名前 FROM teachers;
```

## 計算式を使う

SELECT文では、カラムの値を使った計算もできます。例えば、成績テーブルから点数と満点を取得して、達成率（パーセント）を計算してみましょう。

```sql
SELECT student_id, course_id, grade_type, 
       score, max_score,
       (score / max_score) * 100 AS 達成率
FROM grades;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 301        | 1         | 中間テスト   | 85.5  | 100.0     | 85.5     |
| 302        | 1         | 中間テスト   | 92.0  | 100.0     | 92.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

## 重複を除外する（DISTINCT）

同じ値が複数ある場合に、重複を除いて一意の値だけを表示するには「DISTINCT」キーワードを使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別された」という意味で、重複する値を除外して一意の値だけを取得します。

例えば、どの講座にどの教師が担当しているかを重複なしで確認してみましょう：

```sql
SELECT DISTINCT teacher_id FROM courses;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

これにより、courses（講座）テーブルで使われている教師IDが重複なく表示されます。

## 文字列の結合

文字列を結合するには、MySQLでは「CONCAT」関数を使います。例えば、教師のIDと名前を組み合わせて表示してみましょう：

```sql
SELECT CONCAT('教師ID:', teacher_id, ' 名前:', teacher_name) AS 教師情報
FROM teachers;
```

実行結果：

| 教師情報                  |
|--------------------------|
| 教師ID:101 名前:寺内鞍   |
| 教師ID:102 名前:田尻朋美 |
| ...                      |

> **用語解説**：
> - **CONCAT**：複数の文字列を一つにつなげる関数です。

## SELECT文と終了記号

SQLの文は通常、セミコロン（;）で終わります。これは「この命令はここで終わりです」という合図です。

複数のSQL文を一度に実行する場合は、それぞれの文の最後にセミコロンをつけます。

## 練習問題

### 問題1-1
students（学生）テーブルから、すべての学生の名前（student_name）を取得するSQLを書いてください。

### 問題1-2
classrooms（教室）テーブルから、教室ID（classroom_id）と教室名（classroom_name）を取得するSQLを書いてください。

### 問題1-3
courses（講座）テーブルから、すべての列（カラム）を取得するSQLを書いてください。

### 問題1-4
class_periods（授業時間）テーブルから、時限ID（period_id）、開始時間（start_time）、終了時間（end_time）を取得し、開始時間には「開始」、終了時間には「終了」という別名をつけるSQLを書いてください。

### 問題1-5
grades（成績）テーブルから、学生ID（student_id）、講座ID（course_id）、評価タイプ（grade_type）、得点（score）、満点（max_score）、そして得点を満点で割って100を掛けた値を「パーセント」という別名で取得するSQLを書いてください。

### 問題1-6
course_schedule（授業カレンダー）テーブルから、schedule_date（予定日）カラムだけを重複なしで取得するSQLを書いてください。

## 解答

### 解答1-1
```sql
SELECT student_name FROM students;
```

### 解答1-2
```sql
SELECT classroom_id, classroom_name FROM classrooms;
```

### 解答1-3
```sql
SELECT * FROM courses;
```

### 解答1-4
```sql
SELECT period_id, start_time AS 開始, end_time AS 終了 FROM class_periods;
```

### 解答1-5
```sql
SELECT student_id, course_id, grade_type, score, max_score,
       (score / max_score) * 100 AS パーセント
FROM grades;
```

### 解答1-6
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

## まとめ

この章では、SQLのSELECT文の基本を学びました：

1. 単一カラムの取得: `SELECT カラム名 FROM テーブル名;`
2. 複数カラムの取得: `SELECT カラム名1, カラム名2 FROM テーブル名;`
3. すべてのカラムの取得: `SELECT * FROM テーブル名;`
4. カラムに別名をつける: `SELECT カラム名 AS 別名 FROM テーブル名;`
5. 計算式を使う: `SELECT カラム名, (計算式) AS 別名 FROM テーブル名;`
6. 重複を除外する: `SELECT DISTINCT カラム名 FROM テーブル名;`
7. 文字列の結合: `SELECT CONCAT(文字列1, カラム名, 文字列2) FROM テーブル名;`

これらの基本操作を使いこなせるようになれば、データベースから必要な情報を効率よく取り出せるようになります。次の章では、WHERE句を使って条件に合ったデータだけを取り出す方法を学びます。



---

# 2. WHERE句：条件に合ったレコードを絞り込む

## はじめに

前章では、テーブルからデータを取得する基本的な方法を学びました。しかし実際の業務では、すべてのデータではなく、特定の条件に合ったデータだけを取得したいことがほとんどです。

例えば、「全生徒の情報」ではなく「特定の学科の生徒だけ」や「成績が80点以上の学生だけ」といった形で、データを絞り込みたい場合があります。

このような場合に使用するのが「WHERE句」です。WHERE句は、SELECTコマンドの後に追加して使い、条件に合致するレコード（行）だけを取得します。

## 基本構文

WHERE句の基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件式;
```

> **用語解説**：
> - **WHERE**：「〜の場所で」「〜の条件で」という意味のSQLコマンドで、条件に合うデータだけを抽出するために使います。
> - **条件式**：データが満たすべき条件を指定するための式です。例えば「age > 20」（年齢が20より大きい）などです。
> - **レコード**：テーブルの横の行のことで、1つのデータの集まりを表します。

## 基本的な比較演算子

WHERE句では、様々な比較演算子を使って条件を指定できます：

| 演算子 | 意味                   | 例                    |
|--------|------------------------|------------------------|
| =      | 等しい                 | age = 25               |
| <>     | 等しくない（≠と同じ）  | gender <> 'male'       |
| >      | より大きい             | score > 80             |
| <      | より小さい             | price < 1000           |
| >=     | 以上                   | height >= 170          |
| <=     | 以下                   | weight <= 70           |

## 実践例：基本的な条件での絞り込み

### 例1：等しい（=）
例えば、教師ID（teacher_id）が101の教師のみを取得するには：

```sql
SELECT * FROM teachers WHERE teacher_id = 101;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |

### 例2：より大きい（>）
成績（grades）テーブルから、90点を超える成績だけを取得するには：

```sql
SELECT * FROM grades WHERE score > 90;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例3：等しくない（<>）
講座IDが3ではない講座に関する成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id <> '3';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト  | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 301        | 2         | 実技試験    | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 文字列の比較

テキスト（文字列）を条件にする場合は、シングルクォーテーション（'）またはダブルクォーテーション（"）で囲みます。MySQLではどちらも使えますが、多くの場合シングルクォーテーションが推奨されます。

```sql
SELECT * FROM テーブル名 WHERE テキストカラム = 'テキスト値';
```

例えば、教師名（teacher_name）が「田尻朋美」の教師を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name = '田尻朋美';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |

## 日付の比較

日付の比較も同様にシングルクォーテーションで囲みます。日付の形式はデータベースの設定によって異なりますが、一般的にはISO形式（YYYY-MM-DD）が使われます。

```sql
SELECT * FROM テーブル名 WHERE 日付カラム = '日付';
```

例えば、2025年5月20日に提出された成績を検索するには：

```sql
SELECT * FROM grades WHERE submission_date = '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

また、日付同士の大小関係も比較できます：

```sql
SELECT * FROM grades WHERE submission_date < '2025-05-15';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | レポート1   | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1   | 48.0  | 50.0      | 2025-05-10      |
| 304        | 5         | ER図作成課題 | 27.5  | 30.0      | 2025-05-14      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 複数の条件を指定する（次章の内容）

WHERE句では、複数の条件を組み合わせることもできます。この詳細は次章「論理演算子：AND、OR、NOTを使った複合条件」で説明します。

例えば、講座IDが1で、かつ、得点が90以上の成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id = '1' AND score >= 90;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題2-1
students（学生）テーブルから、学生ID（student_id）が「310」の学生情報を取得するSQLを書いてください。

### 問題2-2
classrooms（教室）テーブルから、収容人数（capacity）が30人より多い教室の情報をすべて取得するSQLを書いてください。

### 問題2-3
courses（講座）テーブルから、教師ID（teacher_id）が「105」の講座情報を取得するSQLを書いてください。

### 問題2-4
course_schedule（授業カレンダー）テーブルから、「2025-05-15」の授業スケジュールをすべて取得するSQLを書いてください。

### 問題2-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」で、得点（score）が80点未満の成績を取得するSQLを書いてください。

### 問題2-6
teachers（教師）テーブルから、教師ID（teacher_id）が「101」ではない教師の名前を取得するSQLを書いてください。

## 解答

### 解答2-1
```sql
SELECT * FROM students WHERE student_id = 310;
```

### 解答2-2
```sql
SELECT * FROM classrooms WHERE capacity > 30;
```

### 解答2-3
```sql
SELECT * FROM courses WHERE teacher_id = 105;
```

### 解答2-4
```sql
SELECT * FROM course_schedule WHERE schedule_date = '2025-05-15';
```

### 解答2-5
```sql
SELECT * FROM grades WHERE grade_type = '中間テスト' AND score < 80;
```

### 解答2-6
```sql
SELECT teacher_name FROM teachers WHERE teacher_id <> 101;
```

## まとめ

この章では、WHERE句を使って条件に合ったレコードを取得する方法を学びました：

1. 基本的な比較演算子（=, <>, >, <, >=, <=）の使い方
2. 数値による条件絞り込み
3. 文字列（テキスト）による条件絞り込み
4. 日付による条件絞り込み

WHERE句は、大量のデータから必要な情報だけを取り出すための非常に重要な機能です。実際のデータベース操作では、この条件絞り込みを頻繁に使います。

次の章では、複数の条件を組み合わせるための「論理演算子（AND、OR、NOT）」について学びます。



---

# 3. 論理演算子：AND、OR、NOTを使った複合条件

## はじめに

前章では、WHERE句を使って単一の条件でデータを絞り込む方法を学びました。しかし実際の業務では、より複雑な条件でデータを絞り込む必要があることがよくあります。

例えば：
- 「成績が80点以上**かつ**出席率が90%以上の学生」
- 「数学**または**英語の成績が優秀な学生」
- 「課題を**まだ提出していない**学生」

このような複合条件を指定するために使うのが論理演算子です。主な論理演算子は次の3つです：

- **AND**：両方の条件を満たす（かつ）
- **OR**：いずれかの条件を満たす（または）
- **NOT**：条件を満たさない（〜ではない）

## AND演算子

AND演算子は、指定した**すべての条件を満たす**レコードだけを取得したいときに使います。

> **用語解説**：
> - **AND**：「かつ」「そして」という意味の論理演算子です。複数の条件をすべて満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 AND 条件2;
```

### 例：ANDを使った複合条件

例えば、中間テストで90点以上かつ満点が100点の成績レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

この例では、「score >= 90」と「max_score = 100」の両方の条件を満たすレコードだけが取得されます。

### 3つ以上の条件の組み合わせ

ANDを使って3つ以上の条件を組み合わせることもできます：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100 AND grade_type = '中間テスト';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## OR演算子

OR演算子は、指定した条件の**いずれか一つでも満たす**レコードを取得したいときに使います。

> **用語解説**：
> - **OR**：「または」「もしくは」という意味の論理演算子です。複数の条件のうち少なくとも1つを満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 OR 条件2;
```

### 例：ORを使った複合条件

例えば、教師IDが101または102の講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id = 101 OR teacher_id = 102;
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 2         | UNIX入門             | 102        |
| 3         | Cプログラミング演習    | 101        |
| 29        | コードリファクタリングとクリーンコード | 101 |
| 40        | ソフトウェアアーキテクチャパターン | 102 |
| ...       | ...                  | ...        |

この例では、「teacher_id = 101」または「teacher_id = 102」のいずれかの条件を満たすレコードが取得されます。

## NOT演算子

NOT演算子は、指定した条件を**満たさない**レコードを取得したいときに使います。

> **用語解説**：
> - **NOT**：「〜ではない」という意味の論理演算子です。条件を否定して、その条件を満たさないデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE NOT 条件;
```

### 例：NOTを使った否定条件

例えば、完了（completed）状態ではない授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
WHERE NOT status = 'completed';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 45          | 11        | 2025-05-20    | 5         | 401G         | 106        | scheduled |
| 46          | 12        | 2025-05-21    | 1         | 301E         | 107        | scheduled |
| 50          | 2         | 2025-05-23    | 3         | 101A         | 102        | cancelled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

この例では、statusが「completed」ではないレコード（scheduled状態やcancelled状態）が取得されます。

NOT演算子は、「〜ではない」という否定の条件を作るために使われます。例えば次の2つの書き方は同じ意味になります：

```sql
SELECT * FROM teachers WHERE NOT teacher_id = 101;
SELECT * FROM teachers WHERE teacher_id <> 101;
```

## 複合論理条件（AND、OR、NOTの組み合わせ）

AND、OR、NOTを組み合わせて、より複雑な条件を指定することもできます。

### 例：ANDとORの組み合わせ

例えば、「成績が90点以上で中間テストである」または「成績が45点以上でレポートである」レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE (score >= 90 AND grade_type = '中間テスト') 
   OR (score >= 45 AND grade_type = 'レポート1');
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 308        | 1         | レポート1  | 47.0  | 50.0      | 2025-05-09      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 優先順位と括弧の使用

論理演算子を組み合わせる場合、演算子の優先順位に注意が必要です。基本的に**ANDはORよりも優先順位が高い**です。つまり、ANDが先に処理されます。

例えば：
```sql
WHERE 条件1 OR 条件2 AND 条件3
```

これは次のように解釈されます：
```sql
WHERE 条件1 OR (条件2 AND 条件3)
```

意図した条件と異なる場合は、**括弧（）を使って明示的にグループ化**することが重要です：
```sql
WHERE (条件1 OR 条件2) AND 条件3
```

### 例：括弧を使った条件のグループ化

教師IDが101または102で、かつ、講座名に「プログラミング」という単語が含まれる講座を取得するには：

```sql
SELECT * FROM courses 
WHERE (teacher_id = 101 OR teacher_id = 102) 
  AND course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

この例では、括弧を使って「teacher_id = 101 OR teacher_id = 102」の部分をグループ化し、その条件と「course_name LIKE '%プログラミング%'」の条件をANDで結合しています。

## 練習問題

### 問題3-1
grades（成績）テーブルから、課題タイプ（grade_type）が「中間テスト」かつ点数（score）が85点以上のレコードを取得するSQLを書いてください。

### 問題3-2
classrooms（教室）テーブルから、収容人数（capacity）が40人以下または建物（building）が「1号館」の教室を取得するSQLを書いてください。

### 問題3-3
teachers（教師）テーブルから、教師ID（teacher_id）が101、102、103ではない教師の情報を取得するSQLを書いてください。

### 問題3-4
course_schedule（授業カレンダー）テーブルから、2025年5月20日の授業で、時限（period_id）が1か2で、かつ状態（status）が「scheduled」の授業を取得するSQLを書いてください。

### 問題3-5
students（学生）テーブルから、学生名（student_name）に「田」または「山」を含む学生を取得するSQLを書いてください。

### 問題3-6
grades（成績）テーブルから、提出日（submission_date）が2025年5月15日以降で、かつ（「中間テスト」で90点以上または「レポート1」で45点以上）の成績を取得するSQLを書いてください。

## 解答

### 解答3-1
```sql
SELECT * FROM grades 
WHERE grade_type = '中間テスト' AND score >= 85;
```

### 解答3-2
```sql
SELECT * FROM classrooms 
WHERE capacity <= 40 OR building = '1号館';
```

### 解答3-3
```sql
SELECT * FROM teachers 
WHERE NOT (teacher_id = 101 OR teacher_id = 102 OR teacher_id = 103);
```
または
```sql
SELECT * FROM teachers 
WHERE teacher_id <> 101 AND teacher_id <> 102 AND teacher_id <> 103;
```

### 解答3-4
```sql
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-20' 
  AND (period_id = 1 OR period_id = 2) 
  AND status = 'scheduled';
```

### 解答3-5
```sql
SELECT * FROM students 
WHERE student_name LIKE '%田%' OR student_name LIKE '%山%';
```

### 解答3-6
```sql
SELECT * FROM grades 
WHERE submission_date >= '2025-05-15' 
  AND ((grade_type = '中間テスト' AND score >= 90) 
       OR (grade_type = 'レポート1' AND score >= 45));
```

## まとめ

この章では、論理演算子（AND、OR、NOT）を使って複合条件を作る方法を学びました：

1. **AND**：すべての条件を満たすレコードを取得（条件1 AND 条件2）
2. **OR**：いずれかの条件を満たすレコードを取得（条件1 OR 条件2）
3. **NOT**：指定した条件を満たさないレコードを取得（NOT 条件）
4. **複合条件**：AND、OR、NOTを組み合わせたより複雑な条件
5. **括弧（）**：条件をグループ化して優先順位を明示的に指定

これらの論理演算子を使いこなすことで、より複雑で細かな条件でデータを絞り込むことができるようになります。実際のデータベース操作では、複数の条件を組み合わせることが頻繁にあるため、この章で学んだ内容は非常に重要です。

次の章では、テキストデータに対する検索を行う「パターンマッチング」について学びます。



---

# 4. パターンマッチング：LIKE演算子と%、_ワイルドカード

## はじめに

前章までは、データの完全一致や数値の比較といった条件での絞り込みを学びました。しかし実際の業務では、もっと柔軟な検索が必要なケースがあります。例えば：

- 「山」で始まる名前の学生を検索したい
- 「プログラミング」という単語を含む講座名を探したい
- 電話番号の一部だけ覚えているデータを探したい

このような「部分一致」や「パターン一致」の検索を行うためのSQLの機能が「パターンマッチング」です。この章では、パターンマッチングを行うための「LIKE演算子」と「ワイルドカード文字」について学びます。

## LIKE演算子の基本

LIKE演算子は、文字列のパターンマッチングを行うための演算子です。WHERE句と組み合わせて使用します。

> **用語解説**：
> - **LIKE**：「〜のような」という意味の演算子で、パターンに一致する文字列を検索します。
> - **パターンマッチング**：完全一致ではなく、一定のパターンに合致するデータを検索する方法です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 文字列カラム LIKE 'パターン';
```

パターンには、通常の文字に加えて、特別な意味を持つ「ワイルドカード文字」を使用できます。

## ワイルドカード文字

SQLでは主に2つのワイルドカード文字があります：

1. **%（パーセント）**：0文字以上の任意の文字列に一致します。
2. **_（アンダースコア）**：任意の1文字に一致します。

> **用語解説**：
> - **ワイルドカード**：任意の文字や文字列に一致する特殊な文字記号です。トランプのジョーカーのように、様々な値に代用できます。

## LIKE演算子の使い方：実践例

### 例1：%（パーセント）を使ったパターンマッチング

#### 「〜で始まる」パターン：前方一致

例えば、「山」で始まる学生名を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '山%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 山本裕子     |
| 325        | 山田翔太     |
| ...        | ...          |

ここでの「山%」は「山で始まり、その後に0文字以上の任意の文字が続く」という意味です。

#### 「〜で終わる」パターン：後方一致

例えば、「子」で終わる教師名を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name LIKE '%子';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| 106        | 星野涼子     |
| 108        | 吉岡由佳     |
| 110        | 佐藤花子     |
| ...        | ...          |

#### 「〜を含む」パターン：部分一致

例えば、「プログラミング」という単語を含む講座名を検索するには：

```sql
SELECT * FROM courses WHERE course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| 14        | IoTデバイスプログラミング実践 | 110 |
| ...       | ...                  | ...        |

### 例2：_（アンダースコア）を使ったパターンマッチング

アンダースコアは任意の1文字に一致します。例えば、教室IDが「10_A」パターン（最初の2文字が「10」、3文字目が任意の1文字、最後が「A」）の教室を検索するには：

```sql
SELECT * FROM classrooms WHERE classroom_id LIKE '10_A';
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| ...          | ...            | ...      | ...      | ...        |

### 例3：%と_の組み合わせ

ワイルドカード文字は組み合わせて使うこともできます。例えば、「2文字目が田」の学生を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '_田%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 384        | 櫻井翼       |
| ...        | ...          |

## NOT LIKEを使った否定形のパターンマッチング

特定のパターンに一致しないレコードを検索したい場合は、「NOT LIKE」を使います。

> **用語解説**：
> - **NOT LIKE**：「〜のパターンに一致しない」という意味で、指定したパターンに一致しないデータを検索します。

例えば、講座名に「入門」を含まない講座を検索するには：

```sql
SELECT * FROM courses WHERE course_name NOT LIKE '%入門%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

## エスケープ文字の使用

もし検索したいパターンに「%」や「_」自体が含まれている場合は、それらを特別な文字としてではなく、通常の文字として扱うために「エスケープ文字」を使います。

> **用語解説**：
> - **エスケープ文字**：特別な意味を持つ文字を通常の文字として扱うための印です。

MySQLでは、バックスラッシュ（\）をエスケープ文字として使用できます。例えば、「50%」という値そのものを検索するには：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50\%';
```

または、ESCAPE句を使って明示的にエスケープ文字を指定することもできます：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50!%' ESCAPE '!';
```

この例では「!」をエスケープ文字として指定しています。

## 大文字と小文字の区別

MySQLのデフォルト設定では、LIKE演算子は大文字と小文字を区別しません（大文字小文字を同じものとして扱います）。

例えば、次の2つのクエリは同じ結果を返します：

```sql
SELECT * FROM courses WHERE course_name LIKE '%web%';
SELECT * FROM courses WHERE course_name LIKE '%Web%';
```

もし大文字と小文字を区別した検索が必要な場合は、「BINARY」キーワードを使用します：

```sql
SELECT * FROM courses WHERE course_name LIKE BINARY '%Web%';
```

この場合、「Web」は「web」とは一致しません。

## 複合条件との組み合わせ

LIKE演算子は、これまで学んだAND、OR、NOTなどの論理演算子と組み合わせて使うこともできます。

例えば、「田」で始まる名前で、かつ教師IDが102から105の間の教師を検索するには：

```sql
SELECT * FROM teachers 
WHERE teacher_name LIKE '田%' 
  AND teacher_id BETWEEN 102 AND 105;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| ...        | ...          |

## 練習問題

### 問題4-1
students（学生）テーブルから、学生名（student_name）が「佐藤」で始まる学生の情報をすべて取得するSQLを書いてください。

### 問題4-2
courses（講座）テーブルから、講座名（course_name）に「データ」という単語を含む講座の情報を取得するSQLを書いてください。

### 問題4-3
classrooms（教室）テーブルから、教室名（classroom_name）が「コンピュータ実習室」で終わる教室の情報を取得するSQLを書いてください。

### 問題4-4
teachers（教師）テーブルから、教師名（teacher_name）の2文字目が「木」である教師の情報を取得するSQLを書いてください。

### 問題4-5
courses（講座）テーブルから、講座名（course_name）に「入門」または「基礎」を含む講座を取得するSQLを書いてください。

### 問題4-6
students（学生）テーブルから、学生名（student_name）が「山」で始まり、かつ「子」で終わらない学生を取得するSQLを書いてください。

## 解答

### 解答4-1
```sql
SELECT * FROM students WHERE student_name LIKE '佐藤%';
```

### 解答4-2
```sql
SELECT * FROM courses WHERE course_name LIKE '%データ%';
```

### 解答4-3
```sql
SELECT * FROM classrooms WHERE classroom_name LIKE '%コンピュータ実習室';
```

### 解答4-4
```sql
SELECT * FROM teachers WHERE teacher_name LIKE '_木%';
```

### 解答4-5
```sql
SELECT * FROM courses 
WHERE course_name LIKE '%入門%' OR course_name LIKE '%基礎%';
```

### 解答4-6
```sql
SELECT * FROM students 
WHERE student_name LIKE '山%' AND student_name NOT LIKE '%子';
```

## まとめ

この章では、パターンマッチングを行うためのLIKE演算子と、その中で使用するワイルドカード文字（%と_）について学びました：

1. **LIKE演算子**：文字列パターンに一致するデータを検索するための演算子
2. **%（パーセント）**：0文字以上の任意の文字列に一致するワイルドカード
3. **_（アンダースコア）**：任意の1文字に一致するワイルドカード
4. **前方一致**：「パターン%」で「パターンで始まる」文字列に一致
5. **後方一致**：「%パターン」で「パターンで終わる」文字列に一致
6. **部分一致**：「%パターン%」で「パターンを含む」文字列に一致
7. **NOT LIKE**：指定したパターンに一致しないデータを検索
8. **エスケープ文字**：特殊文字（%や_）を通常の文字として扱うための方法
9. **複合条件との組み合わせ**：AND、ORなどと組み合わせたより複雑な条件

パターンマッチングは、特にテキストデータを扱う際に非常に便利な機能です。部分的な情報しか持っていない場合や、特定のパターンを持つデータを探す場合に活用できます。

次の章では、範囲指定のための「BETWEEN演算子」と「IN演算子」について学びます。



---

# 5. 範囲指定：BETWEEN、IN演算子

## はじめに

これまでの章では、等号（=）や不等号（>、<）を使って条件を指定する方法や、LIKE演算子を使ったパターンマッチングを学びました。この章では、値の範囲を指定する「BETWEEN演算子」と、複数の値を一度に指定できる「IN演算子」について学びます。

これらの演算子を使うと、次のような検索がより簡単になります：
- 「80点から90点の間の成績」
- 「2025年4月から6月の間のスケジュール」
- 「特定の教師IDリストに該当する講座」

## BETWEEN演算子：範囲を指定する

BETWEEN演算子は、ある値が指定した範囲内にあるかどうかを調べるために使います。

> **用語解説**：
> - **BETWEEN**：「〜の間に」という意味の演算子で、ある値が指定した最小値と最大値の間（両端の値を含む）にあるかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 BETWEEN 最小値 AND 最大値;
```

この構文は次の条件と同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 >= 最小値 AND カラム名 <= 最大値;
```

### 例1：数値範囲の指定

例えば、成績（grades）テーブルから、80点から90点の間の成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 308        | 6         | 小テスト1  | 89.0  | 100.0     | 2025-05-15      |
| ...        | ...       | ...        | ...   | ...       | ...             |

### 例2：日付範囲の指定

日付にもBETWEEN演算子が使えます。例えば、2025年5月10日から2025年5月20日までに提出された成績を取得するには：

```sql
SELECT * FROM grades 
WHERE submission_date BETWEEN '2025-05-10' AND '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | レポート1  | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## NOT BETWEEN：範囲外を指定する

NOT BETWEENを使うと、指定した範囲の外にある値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT BETWEEN 最小値 AND 最大値;
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 < 最小値 OR カラム名 > 最大値;
```

### 例：範囲外の値を取得

例えば、80点未満または90点より高い成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score NOT BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## IN演算子：複数の値を指定する

IN演算子は、ある値が指定した複数の値のリストのいずれかに一致するかどうかを調べるために使います。

> **用語解説**：
> - **IN**：「〜の中に含まれる」という意味の演算子で、ある値が指定したリストの中に含まれているかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (値1, 値2, 値3, ...);
```

この構文は次のOR条件の組み合わせと同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 = 値1 OR カラム名 = 値2 OR カラム名 = 値3 OR ...;
```

### 例1：数値リストの指定

例えば、教師ID（teacher_id）が101、103、105のいずれかである講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (101, 103, 105);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| 5         | データベース設計と実装  | 105        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

### 例2：文字列リストの指定

文字列のリストにも適用できます。例えば、特定の教室ID（classroom_id）のみの教室情報を取得するには：

```sql
SELECT * FROM classrooms 
WHERE classroom_id IN ('101A', '202D', '301E');
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| 202D         | 2号館コンピュータ実習室D | 25     | 2号館     | パソコン25台、プロジェクター、3Dプリンター |
| 301E         | 3号館講義室E      | 80       | 3号館     | プロジェクター、マイク設備、録画設備 |

## NOT IN：リストに含まれない値を指定する

NOT IN演算子を使うと、指定したリストに含まれない値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT IN (値1, 値2, 値3, ...);
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 <> 値1 AND カラム名 <> 値2 AND カラム名 <> 値3 AND ...;
```

### 例：リストに含まれない値を取得

例えば、教師IDが101、102、103以外の教師が担当する講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id NOT IN (101, 102, 103);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 4         | Webアプリケーション開発 | 104        |
| 5         | データベース設計と実装  | 105        |
| 6         | ネットワークセキュリティ | 107        |
| ...       | ...                  | ...        |

## IN演算子でのサブクエリの利用（基本）

IN演算子の括弧内には、直接値を書く代わりに、サブクエリ（別のSELECT文）を指定することもできます。これにより、動的に値のリストを生成できます。

> **用語解説**：
> - **サブクエリ**：SQL文の中に含まれる別のSQL文のことで、外側のSQL文（メインクエリ）に値や条件を提供します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (SELECT カラム名 FROM 別テーブル WHERE 条件);
```

### 例：サブクエリを使ったIN条件

例えば、教師名（teacher_name）に「田」を含む教師が担当している講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (
    SELECT teacher_id FROM teachers 
    WHERE teacher_name LIKE '%田%'
);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 2         | UNIX入門             | 102        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

この例では、まず「teachers」テーブルから名前に「田」を含む教師のIDを取得し、それらのIDを持つ講座を「courses」テーブルから取得しています。

## BETWEEN演算子とIN演算子の組み合わせ

BETWEEN演算子とIN演算子は、論理演算子（AND、OR）と組み合わせて、さらに複雑な条件を作ることができます。

### 例：BETWEENとINの組み合わせ

例えば、「教師IDが101、103、105のいずれかで、かつ、2025年5月15日から2025年6月15日の間に実施される授業」を取得するには：

```sql
SELECT * FROM course_schedule 
WHERE teacher_id IN (101, 103, 105) 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-06-15';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 38          | 1         | 2025-05-20    | 1         | 102B         | 101        | scheduled |
| 42          | 10        | 2025-05-23    | 3         | 201C         | 103        | scheduled |
| 45          | 5         | 2025-05-28    | 2         | 402H         | 105        | scheduled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

## 練習問題

### 問題5-1
grades（成績）テーブルから、得点（score）が85点から95点の間にある成績を取得するSQLを書いてください。

### 問題5-2
course_schedule（授業カレンダー）テーブルから、2025年5月1日から2025年5月31日までの授業スケジュールを取得するSQLを書いてください。

### 問題5-3
courses（講座）テーブルから、教師ID（teacher_id）が104、106、108のいずれかである講座の情報を取得するSQLを書いてください。

### 問題5-4
classrooms（教室）テーブルから、教室ID（classroom_id）が「101A」、「201C」、「301E」、「401G」以外の教室情報を取得するSQLを書いてください。

### 問題5-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」または「実技試験」で、かつ得点（score）が80点から90点の間にない成績を取得するSQLを書いてください。

### 問題5-6
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）が「101A」、「202D」のいずれかで、かつ2025年5月15日から2025年5月30日の間に実施される授業スケジュールを取得するSQLを書いてください。

## 解答

### 解答5-1
```sql
SELECT * FROM grades 
WHERE score BETWEEN 85 AND 95;
```

### 解答5-2
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

### 解答5-3
```sql
SELECT * FROM courses 
WHERE teacher_id IN (104, 106, 108);
```

### 解答5-4
```sql
SELECT * FROM classrooms 
WHERE classroom_id NOT IN ('101A', '201C', '301E', '401G');
```

### 解答5-5
```sql
SELECT * FROM grades 
WHERE grade_type IN ('中間テスト', '実技試験') 
  AND score NOT BETWEEN 80 AND 90;
```

### 解答5-6
```sql
SELECT * FROM course_schedule 
WHERE classroom_id IN ('101A', '202D') 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-05-30';
```

## まとめ

この章では、範囲指定のための「BETWEEN演算子」と複数値指定のための「IN演算子」について学びました：

1. **BETWEEN演算子**：値が指定した範囲内（両端を含む）にあるかどうかをチェック
2. **NOT BETWEEN**：値が指定した範囲外にあるかどうかをチェック
3. **IN演算子**：値が指定したリストのいずれかに一致するかどうかをチェック
4. **NOT IN**：値が指定したリストのいずれにも一致しないかどうかをチェック
5. **サブクエリとIN**：動的に生成された値のリストを使用する方法
6. **複合条件**：BETWEEN、IN、論理演算子を組み合わせたより複雑な条件

これらの演算子を使うことで、複数の条件を指定する場合に、SQLをより簡潔に書くことができます。特に、多くの値を指定する場合や範囲条件を指定する場合に便利です。

次の章では、「NULL値の処理：IS NULL、IS NOT NULL」について学びます。



---

# 6. NULL値の処理：IS NULL、IS NOT NULL

## はじめに

データベースの世界では、データがない状態を表すために「NULL」という特別な値が使われます。NULLは「空」や「0」や「空白文字」とは異なる、「値が存在しない」または「不明」であることを表す特殊な概念です。

例えば、学校データベースでは次のようなシナリオがあります：
- まだ成績が付けられていない（NULL）
- コメントが入力されていない（NULL）
- 授業がキャンセルされたため教室が割り当てられていない（NULL）

この章では、NULL値を正しく処理するための「IS NULL」と「IS NOT NULL」演算子について学びます。

## NULLとは何か？

NULL値には、いくつかの特徴があります：

1. **値がない**：NULLは値がないことを表します。0でも空文字列（''）でもなく、値そのものが存在しないことを示します。
2. **不明**：データが不明であることを表す場合もあります。
3. **未設定**：まだ値が設定されていないことを表す場合もあります。
4. **比較できない**：NULLは通常の比較演算子（=, <, >など）で比較できません。

> **用語解説**：
> - **NULL**：データベースにおいて「値がない」または「不明」を表す特殊な値です。0や空文字とは異なります。

## NULL値と通常の比較演算子

通常の比較演算子（=, <>, >, <, >=, <=）では、NULL値を正しく検出できません。例えば：

```sql
-- この条件はNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 = NULL;

-- この条件もNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 <> NULL;
```

これは、NULL値との等価比較は「不明」と評価されるためです。つまり、NULL = NULLでさえFALSEではなく「不明」になります。

## IS NULL演算子

NULL値を持つレコードを検索するには、「IS NULL」演算子を使います。

> **用語解説**：
> - **IS NULL**：カラムの値がNULLかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NULL;
```

### 例：IS NULLの使用

例えば、コメントが入力されていない（NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

実行結果：

| schedule_id | student_id | status  | comment |
|-------------|------------|---------|---------|
| 1           | 301        | present | NULL    |
| 1           | 306        | present | NULL    |
| 1           | 307        | present | NULL    |
| ...         | ...        | ...     | NULL    |

## IS NOT NULL演算子

逆に、NULL値を持たないレコード（つまり、何らかの値を持つレコード）を検索するには、「IS NOT NULL」演算子を使います。

> **用語解説**：
> - **IS NOT NULL**：カラムの値がNULLでないかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NOT NULL;
```

### 例：IS NOT NULLの使用

例えば、コメントが入力されている（NOT NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 302        | late   | 15分遅刻      |
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |

## NULL値の論理的な扱い

NULL値は論理演算（AND、OR、NOT）でも特殊な扱いを受けます。

- **NULL AND TRUE** → NULL（不明）
- **NULL AND FALSE** → FALSE
- **NULL OR TRUE** → TRUE
- **NULL OR FALSE** → NULL（不明）
- **NOT NULL** → NULL（不明）

この特殊な振る舞いが、バグや誤った結果の原因になることがあります。

## NULL値と結合条件

テーブル結合（JOINなど、後の章で学習）の際も、NULL値は特殊な扱いを受けます。NULL値同士は「等しい」とは判定されないため、通常の結合条件ではNULL値を持つレコードは結合されません。

## IS NULLとIS NOT NULLを使った複合条件

IS NULLとIS NOT NULLも、他の条件と組み合わせて使用できます。

### 例：複合条件でのIS NULLの使用

例えば、「出席状態が "absent"（欠席）で、コメントがNULLでない（理由が入力されている）レコード」を検索するには：

```sql
SELECT * FROM attendance 
WHERE status = 'absent' AND comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |

## NVL/IFNULL/COALESCE関数：NULL値の置換

NULL値を別の値に置き換えるための関数が用意されています。データベースによって関数名が異なることがありますが、機能は似ています：

- MySQL/MariaDB: **IFNULL(expr, replace_value)**
- Oracle: **NVL(expr, replace_value)**
- SQL Server: **ISNULL(expr, replace_value)**
- 標準SQL: **COALESCE(expr1, expr2, ..., exprN)** - 最初のNULLでない式を返します

### 例：IFNULL関数の使用（MySQL）

例えば、コメントがNULLの場合は「特記事項なし」と表示するには：

```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '特記事項なし') AS comment
FROM attendance;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | 特記事項なし  |
| 1           | 302        | late    | 15分遅刻      |
| 1           | 303        | absent  | 事前連絡あり  |
| ...         | ...        | ...     | ...           |

## NULLを使う際の注意点

1. **除外の罠**：`WHERE カラム名 <> 値` だけでは、NULL値を持つレコードは含まれません。すべてのレコードを対象にするには：
   ```sql
   WHERE カラム名 <> 値 OR カラム名 IS NULL
   ```

2. **集計関数**：COUNT(*)はすべての行を数えますが、COUNT(カラム名)はそのカラムがNULLでない行だけを数えます。

3. **インデックス**：多くのデータベースでは、NULL値にもインデックスを適用できますが、データベースによって動作が異なる場合があります。

4. **一意性制約**：一般的に、UNIQUE制約ではNULL値は重複としてカウントされません（複数のNULL値が許可されます）。

## 練習問題

### 問題6-1
attendance（出席）テーブルから、コメント（comment）がNULLの出席レコードをすべて取得するSQLを書いてください。

### 問題6-2
course_schedule（授業カレンダー）テーブルから、状態（status）が「cancelled」で、かつ教室ID（classroom_id）がNULLでないレコードを取得するSQLを書いてください。

### 問題6-3
grades（成績）テーブルから、提出日（submission_date）がNULLの成績レコードを取得するSQLを書いてください。

### 問題6-4
attendance（出席）テーブルから、出席状態（status）が「present」か「late」で、かつコメント（comment）がNULLのレコードを取得するSQLを書いてください。

### 問題6-5
以下のSQLで教師（teachers）テーブルから「佐藤」という名前を持つ教師を検索する場合、NULL値を持つレコードも含めるにはどう修正すべきですか？
```sql
SELECT * FROM teachers WHERE teacher_name <> '佐藤花子';
```

### 問題6-6
attendance（出席）テーブルのすべてのレコードを取得し、コメント（comment）がNULLの場合は「記録なし」と表示するSQLを書いてください。

## 解答

### 解答6-1
```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

### 解答6-2
```sql
SELECT * FROM course_schedule 
WHERE status = 'cancelled' AND classroom_id IS NOT NULL;
```

### 解答6-3
```sql
SELECT * FROM grades WHERE submission_date IS NULL;
```

### 解答6-4
```sql
SELECT * FROM attendance 
WHERE (status = 'present' OR status = 'late') AND comment IS NULL;
```
または
```sql
SELECT * FROM attendance 
WHERE status IN ('present', 'late') AND comment IS NULL;
```

### 解答6-5
```sql
SELECT * FROM teachers 
WHERE teacher_name <> '佐藤花子' OR teacher_name IS NULL;
```

### 解答6-6
```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '記録なし') AS comment
FROM attendance;
```

## まとめ

この章では、データベースにおけるNULL値の概念と、NULL値を扱うための演算子や関数について学びました：

1. **NULL値の概念**：値がない、不明、未設定を表す特殊な値
2. **IS NULL演算子**：NULL値を持つレコードを検索する方法
3. **IS NOT NULL演算子**：NULL値を持たないレコードを検索する方法
4. **NULL値の論理的扱い**：論理演算（AND、OR、NOT）におけるNULLの振る舞い
5. **複合条件**：IS NULL/IS NOT NULLと他の条件の組み合わせ
6. **NULL値の置換**：IFNULL/NVL/COALESCE関数の使用方法
7. **注意点**：NULL値を扱う際の一般的な落とし穴

NULL値の正確な理解と適切な処理は、SQLプログラミングの重要な部分です。不適切なNULL処理は、予期しない結果やバグの原因になります。

次の章では、クエリ結果の並び替えを行うための「ORDER BY：結果の並び替え」について学びます。



---

# 7. ORDER BY：結果の並び替え

## はじめに

これまでの章では、データベースから条件に合ったレコードを取得する方法を学んできました。しかし実際の業務では、取得したデータを見やすく整理する必要があります。例えば：

- 成績を高い順に表示したい
- 学生を名前の五十音順に並べたい
- 日付の新しい順にスケジュールを確認したい

このようなデータの「並び替え」を行うためのSQLコマンドが「ORDER BY」です。この章では、クエリ結果を特定の順序で並べる方法を学びます。

## ORDER BYの基本

ORDER BY句は、SELECT文の結果を指定したカラムの値に基づいて並び替えるために使います。

> **用語解説**：
> - **ORDER BY**：「〜の順に並べる」という意味のSQLコマンドで、クエリ結果の並び順を指定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] ORDER BY 並び替えカラム;
```

ORDER BY句は通常、SELECT文の最後に記述します。

### 例1：単一カラムでの並び替え

例えば、学生（students）テーブルから、学生名（student_name）の五十音順（辞書順）でデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_name;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 309        | 相沢吉夫      |
| 303        | 柴崎春花      |
| 306        | 河田咲奈      |
| 305        | 河口菜恵子    |
| ...        | ...          |

### デフォルトの並び順

ORDER BYを使わない場合、結果の順序は保証されません。多くの場合、データがデータベースに保存された順序で返されますが、これは信頼できるものではありません。

## 昇順と降順の指定

ORDER BY句では、並び順を「昇順」か「降順」のどちらかで指定できます。

> **用語解説**：
> - **昇順（ASC）**：小さい値から大きい値へ（A→Z、1→9）の順に並べます。
> - **降順（DESC）**：大きい値から小さい値へ（Z→A、9→1）の順に並べます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 ORDER BY 並び替えカラム [ASC|DESC];
```

ASC（昇順）がデフォルトのため、省略可能です。

### 例2：降順での並び替え

例えば、成績（grades）テーブルから、得点（score）の高い順（降順）に成績を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 複数カラムでの並び替え

複数のカラムを使って並び替えることもできます。最初に指定したカラムで並び替え、値が同じレコードがある場合は次のカラムで並び替えます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 
ORDER BY 並び替えカラム1 [ASC|DESC], 並び替えカラム2 [ASC|DESC], ...;
```

### 例3：複数カラムでの並び替え

例えば、成績（grades）テーブルから、課題タイプ（grade_type）の五十音順に並べ、同じ課題タイプ内では得点（score）の高い順に成績を取得するには：

```sql
SELECT * FROM grades 
ORDER BY grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| 321        | 2         | 実技試験     | 85.5  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト   | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| 302        | 1         | レポート1    | 48.0  | 50.0      | 2025-05-10      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例4：昇順と降順の混合

各カラムごとに並び順を指定することもできます。例えば、講座ID（course_id）の昇順、評価タイプ（grade_type）の昇順、得点（score）の降順で並べるには：

```sql
SELECT * FROM grades 
ORDER BY course_id ASC, grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## NULLの扱い

ORDER BYでNULL値を並び替える場合、データベース製品によって動作が異なります。多くのデータベースでは、NULL値は最小値または最大値として扱われます。

- MySQL/MariaDBでは、NULL値は昇順（ASC）の場合は最小値として（最初に表示）、降順（DESC）の場合は最大値として（最後に表示）扱われます。

一部のデータベース（PostgreSQLなど）では、NULL値の位置を明示的に指定するための「NULLS FIRST」「NULLS LAST」構文がサポートされています。

### 例5：NULL値の扱い

例えば、出席（attendance）テーブルからコメント（comment）でソートすると、NULLが最初に来ます：

```sql
SELECT * FROM attendance ORDER BY comment;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | NULL          |
| 1           | 306        | present | NULL          |
| ...         | ...        | ...     | NULL          |
| 1           | 308        | late    | 5分遅刻       |
| 1           | 323        | late    | 電車遅延      |
| ...         | ...        | ...     | ...           |

## カラム番号を使った並び替え

カラム名の代わりに、SELECT文の結果セットにおけるカラムの位置（番号）を使って並び替えることもできます。最初のカラムは1、2番目のカラムは2、という具合です。

### 構文

```sql
SELECT カラム名1, カラム名2, ... FROM テーブル名 ORDER BY カラム位置;
```

### 例6：カラム番号を使った並び替え

例えば、学生（students）テーブルから学生ID（student_id）と名前（student_name）を取得し、名前（2番目のカラム）で並べ替えるには：

```sql
SELECT student_id, student_name FROM students ORDER BY 2;
```

この場合、「ORDER BY 2」は「ORDER BY student_name」と同じ意味になります。

> **注意**：カラム番号を使う方法は、カラムの順序を変更すると問題が起きるため、実際の業務では使用を避けた方が良いとされています。

## 式や関数を使った並び替え

ORDER BY句で式や関数を使うことにより、計算結果に基づいて並び替えることもできます。

### 例7：式を使った並び替え

例えば、成績（grades）テーブルから、得点の達成率（score/max_score）の高い順に並べるには：

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY (score/max_score) DESC;
```

または

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY 達成率 DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 98.0     |
| 320        | 1         | レポート1    | 48.5  | 50.0      | 97.0     |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 95.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

### 例8：関数を使った並び替え

文字列関数を使って並び替えることもできます。例えば、月名で並べることを考えましょう：

```sql
SELECT schedule_date, MONTH(schedule_date) AS month
FROM course_schedule
ORDER BY MONTH(schedule_date);
```

実行結果：

| schedule_date | month |
|---------------|-------|
| 2025-04-07    | 4     |
| 2025-04-08    | 4     |
| ...           | ...   |
| 2025-05-01    | 5     |
| 2025-05-02    | 5     |
| ...           | ...   |
| 2025-06-01    | 6     |
| ...           | ...   |

## CASE式を使った条件付き並び替え

さらに高度な並び替えとして、CASE式を使って条件に応じた並び順を定義することもできます。

### 例9：CASE式を使った並び替え

例えば、出席（attendance）テーブルから、出席状況（status）を「欠席→遅刻→出席」の順に優先して表示するには：

```sql
SELECT * FROM attendance
ORDER BY CASE 
           WHEN status = 'absent' THEN 1
           WHEN status = 'late' THEN 2
           WHEN status = 'present' THEN 3
           ELSE 4
         END;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |
| 1           | 302        | late   | 15分遅刻      |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |
| 1           | 301        | present| NULL          |
| 1           | 306        | present| NULL          |
| ...         | ...        | ...    | ...           |

## 練習問題

### 問題7-1
students（学生）テーブルから、すべての学生情報を学生名（student_name）の降順（逆五十音順）で取得するSQLを書いてください。

### 問題7-2
grades（成績）テーブルから、得点（score）が85点以上の成績を得点の高い順に取得するSQLを書いてください。

### 問題7-3
course_schedule（授業カレンダー）テーブルから、2025年5月の授業スケジュールを日付（schedule_date）の昇順で取得するSQLを書いてください。

### 問題7-4
teachers（教師）テーブルから、教師IDと名前を取得し、名前（teacher_name）の五十音順で並べるSQLを書いてください。

### 問題7-5
grades（成績）テーブルから、講座ID（course_id）ごとに、成績を評価タイプ（grade_type）の五十音順に、同じ評価タイプ内では得点（score）の高い順に並べて取得するSQLを書いてください。

### 問題7-6
attendance（出席）テーブルから、すべての出席情報を出席状況（status）が「absent」「late」「present」の順番で、同じ状態内ではコメント（comment）の有無（NULLが後）で並べて取得するSQLを書いてください。

## 解答

### 解答7-1
```sql
SELECT * FROM students ORDER BY student_name DESC;
```

### 解答7-2
```sql
SELECT * FROM grades WHERE score >= 85 ORDER BY score DESC;
```

### 解答7-3
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31' 
ORDER BY schedule_date;
```

### 解答7-4
```sql
SELECT teacher_id, teacher_name FROM teachers ORDER BY teacher_name;
```

### 解答7-5
```sql
SELECT * FROM grades 
ORDER BY course_id, grade_type, score DESC;
```

### 解答7-6
```sql
SELECT * FROM attendance
ORDER BY 
  CASE 
    WHEN status = 'absent' THEN 1
    WHEN status = 'late' THEN 2
    WHEN status = 'present' THEN 3
    ELSE 4
  END,
  CASE 
    WHEN comment IS NULL THEN 2
    ELSE 1
  END;
```

## まとめ

この章では、クエリ結果を特定の順序で並べるための「ORDER BY」句について学びました：

1. **基本的な並び替え**：指定したカラムの値に基づいて結果を並べる方法
2. **昇順と降順**：ASC（昇順）とDESC（降順）の指定方法
3. **複数カラムでの並び替え**：優先順位の高いカラムから順に指定する方法
4. **NULL値の扱い**：NULL値が並び替えでどのように扱われるか
5. **カラム番号**：カラム名の代わりに位置で指定する方法（あまり推奨されない）
6. **式や関数**：計算結果に基づいて並べる方法
7. **CASE式**：条件付きの複雑な並び替え

ORDER BY句は、データを見やすく整理するために非常に重要です。特に大量のデータを扱う場合、適切な並び順はデータの理解を大きく助けます。

次の章では、取得する結果の件数を制限する「LIMIT句：結果件数の制限とページネーション」について学びます。



---

# 8. LIMIT句：結果件数の制限とページネーション

## はじめに

これまでの章では、条件に合うデータを取得し、それを特定の順序で並べる方法を学びました。しかし実際のアプリケーションでは、大量のデータがあるときに、その一部だけを表示したいことがよくあります。例えば：

- 成績上位10件だけを表示したい
- Webページで一度に20件ずつ表示したい（ページネーション）
- 最新の5件のお知らせだけを取得したい

このような「結果の件数を制限する」ためのSQLコマンドが「LIMIT句」です。この章では、クエリ結果の件数を制限する方法と、ページネーションの実装方法を学びます。

## LIMIT句の基本

LIMIT句は、SELECT文の結果から指定した件数だけを取得するために使います。

> **用語解説**：
> - **LIMIT**：「制限する」という意味のSQLコマンドで、取得する行数を制限します。

### 基本構文（MySQL/MariaDB）

MySQLやMariaDBでのLIMIT句の基本構文は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数;
```

LIMIT句は通常、SELECT文の最後に記述します（ORDER BYの後）。

### 例1：単純なLIMIT

例えば、学生（students）テーブルから最初の5人だけを取得するには：

```sql
SELECT * FROM students LIMIT 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |

### ORDER BYとLIMITの組み合わせ

通常、LIMIT句はORDER BY句と組み合わせて使用します。これにより、「上位N件」「最新N件」などの操作が可能になります。

### 例2：ORDER BYとLIMITの組み合わせ

例えば、成績（grades）テーブルから得点（score）の高い順に上位3件を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 3;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |

### 例3：最新のレコードを取得

日付でソートして最新のデータを取得することもよくあります。例えば、最新の3つの授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
ORDER BY schedule_date DESC LIMIT 3;
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 95          | 28        | 2026-12-21    | 3         | 202D         | 119        | scheduled |
| 94          | 1         | 2026-12-21    | 1         | 102B         | 101        | scheduled |
| 93          | 14        | 2026-12-15    | 4         | 202D         | 110        | scheduled |

## OFFSETとページネーション

Webアプリケーションなどでは、大量のデータを「ページ」に分けて表示することがよくあります（ページネーション）。この機能を実現するためには、「OFFSET」（オフセット）という機能が必要です。

> **用語解説**：
> - **OFFSET**：「ずらす」という意味で、結果セットの先頭から指定した数だけ行をスキップします。
> - **ページネーション**：大量のデータを複数のページに分割して表示する技術です。

### 基本構文（MySQL/MariaDB）

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数 OFFSET スキップ数;
```

または、短縮形として：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT スキップ数, 件数;
```

### 例4：OFFSETを使ったスキップ

例えば、学生（students）テーブルから6番目から10番目までの学生を取得するには：

```sql
SELECT * FROM students LIMIT 5 OFFSET 5;
```

または：

```sql
SELECT * FROM students LIMIT 5, 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 306        | 河田咲奈     |
| 307        | 織田柚夏     |
| 308        | 永田悦子     |
| 309        | 相沢吉夫     |
| 310        | 吉川伽羅     |

### 例5：ページネーションの実装

ページネーションを実装する場合、通常は以下の式を使ってOFFSETを計算します：

```
OFFSET = (ページ番号 - 1) × ページあたりの件数
```

例えば、1ページあたり10件表示で、3ページ目のデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 10 OFFSET 20;
```

または：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 20, 10;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 322        | 木村結衣     |
| 323        | 林正義       |
| 324        | 清水香織     |
| 325        | 山田翔太     |
| 326        | 葉山陽太     |
| 327        | 青山凛       |
| 328        | 沢村大和     |
| 329        | 白石優月     |
| 330        | 月岡星奈     |

## LIMIT句を使用する際の注意点

### 1. ORDER BYの重要性

LIMIT句を使用する場合、通常はORDER BY句も一緒に使うべきです。ORDER BYがなければ、どのレコードが取得されるかは保証されません。

```sql
-- 良い例：結果が予測可能
SELECT * FROM students ORDER BY student_id LIMIT 5;

-- 悪い例：結果が不確定
SELECT * FROM students LIMIT 5;
```

### 2. パフォーマンスへの影響

大規模なテーブルで大きなOFFSET値を使用すると、パフォーマンスが低下する可能性があります。これは、データベースがOFFSET分のレコードを読み込んでから破棄する必要があるためです。

### 3. データベース製品による構文の違い

LIMIT句の構文はデータベース製品によって異なります：

- **MySQL/MariaDB/SQLite**：`LIMIT 件数 OFFSET スキップ数` または `LIMIT スキップ数, 件数`
- **PostgreSQL**：`LIMIT 件数 OFFSET スキップ数`
- **Oracle**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY`
- **SQL Server**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY` または旧バージョンでは `TOP`句

この章では主にMySQL/MariaDBの構文を使用します。

## 実践的なページネーションの実装

実際のアプリケーションでページネーションを実装する場合、以下のようなコードになります（疑似コード）：

```
ページ番号 = URLから取得またはデフォルト値（例：1）
1ページあたりの件数 = 設定値（例：10）
総レコード数 = SELECTで取得（COUNT(*)を使用）
総ページ数 = CEILING(総レコード数 ÷ 1ページあたりの件数)
OFFSET = (ページ番号 - 1) × 1ページあたりの件数

SQLクエリ = "SELECT * FROM テーブル ORDER BY カラム LIMIT " + 1ページあたりの件数 + " OFFSET " + OFFSET
```

### 例6：総レコード数と総ページ数の取得

総レコード数を取得するには：

```sql
SELECT COUNT(*) AS total_records FROM students;
```

実行結果：

| total_records |
|---------------|
| 100           |

この場合、1ページあたり10件表示なら、総ページ数は10ページ（CEILING(100 ÷ 10)）になります。

## 練習問題

### 問題8-1
grades（成績）テーブルから、得点（score）の高い順に上位5件の成績レコードを取得するSQLを書いてください。

### 問題8-2
course_schedule（授業カレンダー）テーブルから、日付（schedule_date）の新しい順に3件のスケジュールを取得するSQLを書いてください。

### 問題8-3
students（学生）テーブルを学生ID（student_id）の昇順で並べ、11番目から15番目までの学生（5件）を取得するSQLを書いてください。

### 問題8-4
teachers（教師）テーブルから、教師名（teacher_name）の五十音順で6番目から10番目までの教師情報を取得するSQLを書いてください。

### 問題8-5
1ページあたり20件表示で、grades（成績）テーブルの3ページ目のデータを得点（score）の高い順に取得するSQLを書いてください。

### 問題8-6
course_schedule（授業カレンダー）テーブルから、状態（status）が「scheduled」のスケジュールを日付（schedule_date）の昇順で並べ、先頭から10件スキップして次の5件を取得するSQLを書いてください。

## 解答

### 解答8-1
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 5;
```

### 解答8-2
```sql
SELECT * FROM course_schedule ORDER BY schedule_date DESC LIMIT 3;
```

### 解答8-3
```sql
SELECT * FROM students ORDER BY student_id LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM students ORDER BY student_id LIMIT 10, 5;
```

### 解答8-4
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5 OFFSET 5;
```
または
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5, 5;
```

### 解答8-5
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 20 OFFSET 40;
```
または
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 40, 20;
```

### 解答8-6
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 10, 5;
```

## まとめ

この章では、クエリ結果の件数を制限するためのLIMIT句と、ページネーションの実装方法について学びました：

1. **LIMIT句の基本**：指定した件数だけのレコードを取得する方法
2. **ORDER BYとの組み合わせ**：順序付けされた結果から一部だけを取得する方法
3. **OFFSET**：結果の先頭から指定した数だけレコードをスキップする方法
4. **ページネーション**：大量のデータを複数のページに分けて表示する実装方法
5. **注意点**：LIMIT句を使用する際の留意事項
6. **データベース製品による違い**：異なるデータベースでの構文の違い

LIMIT句は特にWebアプリケーションの開発で重要な機能です。大量のデータを効率よく表示するためのページネーション機能を実装するために欠かせません。また、トップN（上位N件）やボトムN（下位N件）のデータを取得する際にも使われます。

次の章では、データの集計分析を行うための「集計関数：COUNT、SUM、AVG、MAX、MIN」について学びます。





---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [13. JOIN基本：テーブル結合の概念](#13-join基本テーブル結合の概念)
2. [14. テーブル別名：AS句とその省略](#14-テーブル別名as句とその省略)
3. [15. 結合の種類：INNER JOIN、LEFT JOIN、RIGHT JOIN](#15-結合の種類inner-joinleft-joinright-join)
4. [16. 自己結合：同一テーブル内での関連付け](#16-自己結合同一テーブル内での関連付け)
5. [17. 複数テーブル結合：3つ以上のテーブルの連結](#17-複数テーブル結合3つ以上のテーブルの連結)
6. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)
7. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)

---


# 13. JOIN基本：テーブル結合の概念

## はじめに

これまでの章では、単一のテーブルからデータを取得する方法を学んできました。しかし実際のデータベースでは、情報は複数のテーブルに分散して保存されています。

例えば、学校データベースでは：
- 学生の基本情報は「students」テーブルに
- 講座の情報は「courses」テーブルに
- 成績データは「grades」テーブルに

このように別々のテーブルに保存されたデータを組み合わせて取得するための機能が「JOIN（結合）」です。この章では、複数のテーブルを結合して必要な情報を取得する基本的な方法を学びます。

## JOINとは

JOIN（結合）とは、2つ以上のテーブルを関連付けて、それらのテーブルから情報を組み合わせて取得するためのSQL機能です。

> **用語解説**：
> - **JOIN**：「結合する」という意味のSQLコマンドで、複数のテーブルを関連付けてデータを取得するために使います。
> - **結合キー**：テーブル間の関連付けに使用されるカラムのことで、通常は主キーと外部キーの関係にあります。

## テーブル結合の必要性

なぜテーブル結合が必要なのでしょうか？いくつかの理由があります：

1. **データの正規化**：データベース設計では、情報の重複を避けるためにデータを複数のテーブルに分割します（これを「正規化」と呼びます）。
2. **データの一貫性**：例えば、教師の名前を1か所（teachersテーブル）だけで管理することで、名前変更時の更新が容易になります。
3. **効率的なデータ管理**：関連するデータをグループ化して管理できます。

例えば、「どの学生がどの講座でどのような成績を取ったか」という情報を取得するには、students、courses、gradesの3つのテーブルを結合する必要があります。

## 基本的なJOINの種類

SQLでは主に4種類のJOINが使われます：

1. **JOIN**：両方のテーブルで一致するレコードだけを取得(INNER JOIN)
2. **LEFT JOIN**：左テーブルのすべてのレコードと、右テーブルの一致するレコード
3. **RIGHT JOIN**：右テーブルのすべてのレコードと、左テーブルの一致するレコード
4. **FULL JOIN**：両方のテーブルのすべてのレコード（MySQLでは直接サポートされていません）

この章では主にJOINについて学び、次章で他の種類のJOINを学びます。

## JOIN（内部結合）

JOINは、最も基本的な結合方法で、両方のテーブルで一致するレコードのみを取得します。

> **用語解説**：
> - **JOIN**：「内部結合」とも呼ばれ、結合条件に一致するレコードのみを返します。条件に一致しないレコードは結果に含まれません。

### 基本構文

```sql
SELECT カラム名
FROM テーブル1
JOIN テーブル2 ON テーブル1.結合カラム = テーブル2.結合カラム;
```

「ON」の後には結合条件を指定します。これは通常、一方のテーブルの主キーと他方のテーブルの外部キーを一致させる条件です。

> **用語解説**：
> - **ON**：「〜の条件で」という意味で、JOINの条件を指定するためのキーワードです。

## JOINの実践例

### 例1：講座とその担当教師の情報を取得

講座（courses）テーブルと教師（teachers）テーブルを結合して、各講座の名前と担当教師の名前を取得してみましょう：

```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id;
```

この例では：
- `c`と`t`はそれぞれcourses、teachersテーブルの「テーブル別名」（短縮名）です。
- `ON c.teacher_id = t.teacher_id`が結合条件です。
- 講座テーブルの`teacher_id`（外部キー）と教師テーブルの`teacher_id`（主キー）が一致するレコードが結合されます。

実行結果：

| course_id | course_name           | teacher_name |
|-----------|----------------------|--------------|
| 1         | ITのための基礎知識     | 寺内鞍       |
| 2         | UNIX入門             | 田尻朋美     |
| 3         | Cプログラミング演習    | 寺内鞍       |
| 4         | Webアプリケーション開発 | 藤本理恵     |
| ...       | ...                  | ...          |

### 例2：学生と受講講座の情報を取得

学生（students）テーブルと受講（student_courses）テーブルを結合して、特定の講座を受講している学生の一覧を取得してみましょう：

```sql
SELECT s.student_id, s.student_name, sc.course_id
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '1';
```

この例では、学生テーブルと受講テーブルを学生IDで結合し、講座ID = 1の学生だけを取得しています。

実行結果：

| student_id | student_name | course_id |
|------------|--------------|-----------|
| 301        | 黒沢春馬     | 1         |
| 302        | 新垣愛留     | 1         |
| 303        | 柴崎春花     | 1         |
| 306        | 河田咲奈     | 1         |
| ...        | ...          | ...       |

### 例3：3つのテーブルの結合

より複雑な例として、3つのテーブルを結合してみましょう。学生、講座、成績の情報を組み合わせて表示します：

```sql
SELECT s.student_name, c.course_name, g.score
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY g.score DESC;
```

この例では：
1. まず学生テーブルと成績テーブルを結合
2. その結果と講座テーブルを結合
3. 中間テストの成績だけを抽出
4. 点数の高い順にソート

実行結果：

| student_name | course_name           | score |
|--------------|----------------------|-------|
| 鈴木健太     | ITのための基礎知識     | 95.0  |
| 松本さくら   | ITのための基礎知識     | 93.5  |
| 新垣愛留     | ITのための基礎知識     | 92.0  |
| ...          | ...                  | ...    |

## JOIN時のカラム指定

テーブルを結合する際に、特に同じカラム名が両方のテーブルに存在する場合は、カラム名の前にテーブル名（または別名）を付けることで、どのテーブルのカラムを参照しているかを明確にする必要があります。

例えば：
```sql
SELECT students.student_id, students.student_name
FROM students;
```

これは次のように短縮できます：
```sql
SELECT s.student_id, s.student_name
FROM students s;
```

ここで`s`は`students`テーブルの別名です。

## テーブルの別名（エイリアス）

長いテーブル名は別名を使って短くすることができます。これにより、SQLが読みやすくなります。

> **用語解説**：
> - **テーブル別名（エイリアス）**：テーブルに一時的につける短い名前で、クエリ内でテーブルを参照するときに使用します。

構文：
```sql
SELECT t.カラム名
FROM テーブル名 AS t;
```

「AS」キーワードは省略可能です：
```sql
SELECT t.カラム名
FROM テーブル名 t;
```

### 例4：別名を使った結合

```sql
SELECT s.student_name, c.course_name, t.teacher_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE s.student_id = 301;
```

この例では4つのテーブルを結合して、学生ID=301の学生が受講しているすべての講座とその担当教師の情報を取得しています。

実行結果：

| student_name | course_name           | teacher_name |
|--------------|----------------------|--------------|
| 黒沢春馬     | ITのための基礎知識     | 寺内鞍       |
| 黒沢春馬     | UNIX入門             | 田尻朋美     |
| 黒沢春馬     | クラウドコンピューティング | 吉岡由佳  |
| ...          | ...                  | ...          |

## 結合条件の書き方

結合条件には複数の方法があります：

### 1. 等価結合（Equi-Join）

最も一般的な結合方法で、カラムの値が等しいことを条件に使います：
```sql
... ON テーブル1.カラム = テーブル2.カラム
```

### 2. 非等価結合（Non-Equi Join）

「等しい」以外の条件（<, >, <=, >=など）を使う結合方法です：
```sql
... ON テーブル1.カラム > テーブル2.カラム
```

### 3. 複合条件結合

複数の条件を組み合わせる結合方法です：
```sql
... ON テーブル1.カラム1 = テーブル2.カラム1
    AND テーブル1.カラム2 = テーブル2.カラム2
```

## JOINの特徴と注意点

JOINを使用する際には、以下の点に注意が必要です：

1. **一致しないレコードは含まれない**：結合条件に一致しないレコードは結果に含まれません。
2. **NULL値の扱い**：JOIN条件で使用するカラムにNULL値があると、その行は結果に含まれません。
3. **パフォーマンス**：大きなテーブル同士を結合すると、処理に時間がかかることがあります。

## 練習問題

### 問題13-1
courses（講座）テーブルとteachers（教師）テーブルを結合して、講座ID（course_id）、講座名（course_name）、担当教師名（teacher_name）を取得するSQLを書いてください。

### 問題13-2
students（学生）テーブルとstudent_courses（受講）テーブルを結合して、講座ID（course_id）が2の講座を受講している学生の学生ID（student_id）と学生名（student_name）を取得するSQLを書いてください。

### 問題13-3
course_schedule（授業カレンダー）テーブルとclassrooms（教室）テーブルを結合して、2025年5月20日に行われる授業のスケジュールIDと教室名（classroom_name）を取得するSQLを書いてください。

### 問題13-4
courses（講座）テーブル、teachers（教師）テーブル、course_schedule（授業カレンダー）テーブルの3つを結合して、2025年5月22日に行われる授業の講座名（course_name）と担当教師名（teacher_name）を取得するSQLを書いてください。

### 問題13-5
students（学生）テーブル、grades（成績）テーブル、courses（講座）テーブルを結合して、学生ID（student_id）が301の学生の成績情報（講座名、成績タイプ、点数）を取得するSQLを書いてください。

### 問題13-6
courses（講座）テーブル、course_schedule（授業カレンダー）テーブル、classrooms（教室）テーブル、class_periods（授業時間）テーブルの4つを結合して、2025年5月21日の授業スケジュール（講座名、教室名、開始時間、終了時間）を時間順に取得するSQLを書いてください。

## 解答

### 解答13-1
```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id;
```

### 解答13-2
```sql
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '2';
```

### 解答13-3
```sql
SELECT cs.schedule_id, cl.classroom_name
FROM course_schedule cs
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
WHERE cs.schedule_date = '2025-05-20';
```

### 解答13-4
```sql
SELECT c.course_name, t.teacher_name
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
WHERE cs.schedule_date = '2025-05-22';
```

### 解答13-5
```sql
SELECT c.course_name, g.grade_type, g.score
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE s.student_id = 301;
```

### 解答13-6
```sql
SELECT c.course_name, cl.classroom_name, cp.start_time, cp.end_time
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
WHERE cs.schedule_date = '2025-05-21'
ORDER BY cp.start_time;
```

## まとめ

この章では、複数のテーブルを結合して情報を取得するための基本的なJOIN操作について学びました：

1. **JOIN（結合）の概念**：複数のテーブルの情報を組み合わせる方法
2. **JOIN（内部結合）**：両方のテーブルで一致するレコードのみを取得
3. **結合条件**：ON句を使って結合条件を指定する方法
4. **テーブル別名**：テーブルに短い名前を付けて使う方法
5. **複数テーブルの結合**：3つ以上のテーブルを結合する方法
6. **結合条件の書き方**：等価結合、非等価結合、複合条件結合

JOINは実際のデータベース操作で非常に重要な機能です。データベースの性能を維持するために、関連情報は複数のテーブルに分散して保存されることが一般的で、必要な情報を取得するためにはこれらのテーブルを結合する必要があります。

次の章では、「テーブル別名：AS句とその省略」について詳しく学び、より効率的なJOINクエリの書き方を学びます。



---

# 14. テーブル別名：AS句とその省略

## はじめに

前章では複数のテーブルを結合する基本的な方法について学びました。テーブル結合を含むSQLクエリは、複数のテーブル名を扱うため長く複雑になりがちです。また、同じテーブル名やカラム名を繰り返し記述することも多くなります。

SQLでは、このような繰り返しを避け、クエリを簡潔に書くために「テーブル別名（エイリアス）」という機能が用意されています。この章では、テーブルやカラムに一時的な名前（別名）を付ける方法と、それを効果的に使用する方法について学びます。

## テーブル別名とは

テーブル別名（エイリアス）とは、SQLクエリの中で使用する仮の短い名前のことです。特に複数のテーブルを結合する場合や同じテーブルを複数回参照する場合に便利です。

> **用語解説**：
> - **テーブル別名（エイリアス）**：テーブルに一時的につける短い別名です。クエリ内でテーブルを参照するときに使用します。
> - **AS句**：「〜として」という意味のSQLキーワードで、テーブルやカラムに別名を付けるために使います。

## AS句を使ったテーブル別名の指定

テーブル別名を指定するには、FROMやJOIN句の中でテーブル名の後にASキーワードとともに別名を書きます。

### 基本構文

```sql
SELECT 列リスト
FROM テーブル名 AS 別名
[JOIN 別のテーブル AS 別名 ON 結合条件];
```

### 例1：AS句を使ったテーブル別名の指定

例えば、コースとその担当教師を取得するクエリでASを使用して別名を付けます：

```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses AS c
JOIN teachers AS t ON c.teacher_id = t.teacher_id;
```

この例では：
- `courses`テーブルに`c`という別名
- `teachers`テーブルに`t`という別名
を付けています。

## AS句の省略

SQLではAS句を省略することができます。これにより、クエリをさらに簡潔に書くことができます。

### 基本構文（AS省略）

```sql
SELECT 列リスト
FROM テーブル名 別名
[JOIN 別のテーブル 別名 ON 結合条件];
```

### 例2：AS句を省略したテーブル別名の指定

先ほどの例からASを省略してみましょう：

```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id;
```

この書き方は前の例と全く同じ結果を返します。ASを省略してもテーブル名の直後に別名を書くことで同じ効果が得られます。

実行結果：

| course_id | course_name           | teacher_name |
|-----------|----------------------|--------------|
| 1         | ITのための基礎知識     | 寺内鞍       |
| 2         | UNIX入門             | 田尻朋美     |
| 3         | Cプログラミング演習    | 寺内鞍       |
| ...       | ...                  | ...          |

## テーブル別名を使う利点

テーブル別名を使用することには、いくつかの利点があります：

1. **クエリの短縮**：長いテーブル名を短い別名で参照できるため、SQLの記述量が減ります。

2. **可読性の向上**：特に複数のテーブルを結合する複雑なクエリでは、どのテーブルのカラムを参照しているかが明確になります。

3. **同一テーブルの複数回使用**：後述する「自己結合」のように、同じテーブルを複数回使う場合に区別するために必須です。

4. **タイピングの労力削減**：繰り返し長いテーブル名を入力する必要がなくなります。

### 例3：複数テーブル結合での別名の活用

4つのテーブルを結合する複雑なクエリでテーブル別名を活用してみましょう：

```sql
SELECT s.student_name, c.course_name, cs.schedule_date, cl.classroom_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN course_schedule cs ON c.course_id = cs.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
WHERE s.student_id = 301 AND cs.schedule_date >= '2025-05-01';
```

このクエリでは以下の別名を使用しています：
- `students`テーブル → `s`
- `student_courses`テーブル → `sc`
- `courses`テーブル → `c`
- `course_schedule`テーブル → `cs`
- `classrooms`テーブル → `cl`

もし別名を使わないと、以下のような長く読みにくいクエリになります：

```sql
SELECT students.student_name, courses.course_name, course_schedule.schedule_date, classrooms.classroom_name
FROM students
JOIN student_courses ON students.student_id = student_courses.student_id
JOIN courses ON student_courses.course_id = courses.course_id
JOIN course_schedule ON courses.course_id = course_schedule.course_id
JOIN classrooms ON course_schedule.classroom_id = classrooms.classroom_id
WHERE students.student_id = 301 AND course_schedule.schedule_date >= '2025-05-01';
```

## カラム別名の指定

テーブルだけでなく、カラム（列）にも別名を付けることができます。カラム別名を使うと、結果セットの列見出しをわかりやすい名前に変更できます。

### 基本構文

```sql
SELECT 
    カラム名 AS 別名,
    計算式 AS 別名
FROM テーブル名;
```

### 例4：カラム別名の指定

```sql
SELECT 
    student_id AS 学生番号,
    student_name AS 氏名,
    CONCAT(student_id, ': ', student_name) AS 学生情報
FROM students
WHERE student_id < 305;
```

実行結果：

| 学生番号 | 氏名        | 学生情報          |
|---------|------------|------------------|
| 301     | 黒沢春馬    | 301: 黒沢春馬    |
| 302     | 新垣愛留    | 302: 新垣愛留    |
| 303     | 柴崎春花    | 303: 柴崎春花    |
| 304     | 森下風凛    | 304: 森下風凛    |

### カラム別名でもASは省略可能

カラム別名の場合もAS句は省略可能です：

```sql
SELECT 
    student_id 学生番号,
    student_name 氏名,
    CONCAT(student_id, ': ', student_name) 学生情報
FROM students
WHERE student_id < 305;
```

## スペースを含む別名

テーブル名やカラム名に含まれるスペースは通常問題になりますが、別名にスペースを含めたい場合は二重引用符（"）または（データベースによっては）バッククォート（`）で囲むことで指定できます。

### 例5：スペースを含む別名

```sql
SELECT 
    student_id AS "学生 ID",
    student_name AS "学生 氏名"
FROM students
WHERE student_id < 305;
```

実行結果：

| 学生 ID | 学生 氏名   |
|---------|------------|
| 301     | 黒沢春馬    |
| 302     | 新垣愛留    |
| 303     | 柴崎春花    |
| 304     | 森下風凛    |

## OrderByとテーブル別名

一般的に、ORDER BY句ではSELECT句で指定したカラム別名を使用できます：

### 例6：ORDER BY句での別名の使用

```sql
SELECT 
    student_id AS 学生番号,
    student_name AS 氏名
FROM students
WHERE student_id < 310
ORDER BY 氏名;
```

実行結果（氏名の五十音順）：

| 学生番号 | 氏名        |
|---------|------------|
| 309     | 相沢吉夫    |
| 305     | 河口菜恵子  |
| 306     | 河田咲奈    |
| 301     | 黒沢春馬    |
| 304     | 森下風凛    |
| 302     | 新垣愛留    |
| 303     | 柴崎春花    |
| 307     | 織田柚夏    |
| 308     | 永田悦子    |

## 別名の命名規則とベストプラクティス

テーブル別名やカラム別名を付ける際の一般的なルールとベストプラクティスを紹介します：

1. **テーブル別名は短く**：通常、1〜3文字程度の短い名前が好まれます（例：students → s）。

2. **意味のある別名**：テーブルの内容を表す頭文字や略語を使うと良いでしょう（例：teachers → t、course_schedule → cs）。

3. **一貫性**：プロジェクト内で同じテーブルには同じ別名を使うと可読性が向上します。

4. **カラム別名は説明的に**：カラム別名は、その内容がわかりやすい名前にします。特に計算列や関数の結果には説明的な名前を付けましょう。

5. **日本語の別名**：日本語環境では、カラム別名に日本語を使うとレポートが読みやすくなることがあります。

### 例7：ベストプラクティスに基づく別名

```sql
SELECT 
    c.course_name AS 講座名,
    t.teacher_name AS 担当教員,
    COUNT(sc.student_id) AS 受講者数
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name, t.teacher_name
ORDER BY 受講者数 DESC, 講座名;
```

実行結果：

| 講座名                 | 担当教員   | 受講者数 |
|----------------------|------------|---------|
| ITのための基礎知識       | 寺内鞍     | 12      |
| データサイエンスとビジネス応用 | 星野涼子   | 11      |
| クラウドネイティブアーキテクチャ | 吉岡由佳 | 10      |
| ...                  | ...        | ...     |

## テーブル別名を使用したJOINの応用

ここまで学んだテーブル別名の知識を使って、より実践的なJOINクエリを見てみましょう。

### 例8：出席状況と成績情報の結合

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    a.status AS 出席状況,
    g.score AS 得点,
    g.score / g.max_score * 100 AS 達成率
FROM students s
JOIN attendance a ON s.student_id = a.student_id
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN grades g ON s.student_id = g.student_id AND cs.course_id = g.course_id
WHERE cs.schedule_date = '2025-05-20'
ORDER BY c.course_name, s.student_name;
```

このクエリでは：
- 5つのテーブルを結合
- すべてのテーブルに別名を使用
- 結果のカラムにもわかりやすい別名を付与
- 成績は存在しない可能性があるためLEFT JOINを使用

## 練習問題

### 問題14-1
courses（講座）テーブルとteachers（教師）テーブルを結合して、講座名（course_name）と担当教師名（teacher_name）を「講座」と「担当者」という別名をつけて取得するSQLを書いてください。テーブル別名も使用してください。

### 問題14-2
students（学生）テーブルとgrades（成績）テーブルを結合して、学生名、成績タイプ、点数を「学生」「評価種別」「点数」という別名をつけて取得するSQLを書いてください。点数が90点以上のレコードだけを抽出し、点数の高い順にソートしてください。

### 問題14-3
course_schedule（授業カレンダー）テーブル、courses（講座）テーブル、classrooms（教室）テーブルを結合して、2025年5月21日の授業予定を「時間割」という形で取得するSQLを書いてください。結果には「講座名」「教室」「状態」という別名を付け、テーブル別名も使用してください。

### 問題14-4
学生の出席状況を確認するため、students（学生）テーブル、attendance（出席）テーブル、course_schedule（授業カレンダー）テーブルを結合して、学生ID=301の出席記録を取得するSQLを書いてください。結果には「日付」「状態」「コメント」という別名をつけ、日付順にソートしてください。

### 問題14-5
成績の集計情報を取得するため、students（学生）テーブル、grades（成績）テーブル、courses（講座）テーブルを結合し、学生ごとの平均点を計算するSQLを書いてください。結果には「学生名」「受講講座数」「平均点」という別名をつけ、平均点が高い順にソートしてください。

### 問題14-6
course_schedule（授業カレンダー）テーブル、teachers（教師）テーブル、teacher_unavailability（講師スケジュール管理）テーブルを結合して、講師が不在の日に予定されていた授業（status = 'cancelled'）を取得するSQLを書いてください。結果には「日付」「講師名」「不在理由」という別名をつけ、日付順にソートしてください。

## 解答

### 解答14-1
```sql
SELECT 
    c.course_name AS 講座,
    t.teacher_name AS 担当者
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id;
```

### 解答14-2
```sql
SELECT 
    s.student_name AS 学生,
    g.grade_type AS 評価種別,
    g.score AS 点数
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.score >= 90
ORDER BY 点数 DESC;
```

### 解答14-3
```sql
SELECT 
    c.course_name AS 講座名,
    cl.classroom_name AS 教室,
    cs.status AS 状態
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
WHERE cs.schedule_date = '2025-05-21'
ORDER BY cs.period_id;
```

### 解答14-4
```sql
SELECT 
    cs.schedule_date AS 日付,
    a.status AS 状態,
    a.comment AS コメント
FROM students s
JOIN attendance a ON s.student_id = a.student_id
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE s.student_id = 301
ORDER BY 日付;
```

### 解答14-5
```sql
SELECT 
    s.student_name AS 学生名,
    COUNT(DISTINCT g.course_id) AS 受講講座数,
    AVG(g.score) AS 平均点
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
GROUP BY s.student_id, s.student_name
ORDER BY 平均点 DESC;
```

### 解答14-6
```sql
SELECT 
    cs.schedule_date AS 日付,
    t.teacher_name AS 講師名,
    tu.reason AS 不在理由
FROM course_schedule cs
JOIN teachers t ON cs.teacher_id = t.teacher_id
JOIN teacher_unavailability tu ON t.teacher_id = tu.teacher_id
WHERE cs.status = 'cancelled'
  AND cs.schedule_date BETWEEN tu.start_date AND tu.end_date
ORDER BY 日付;
```

## まとめ

この章では、SQLクエリを簡潔で読みやすくするためのテーブル別名とカラム別名について学びました：

1. **テーブル別名の基本**：AS句を使ってテーブルに短い別名を付ける方法
2. **AS句の省略**：テーブル別名を指定する際にASキーワードを省略する書き方
3. **テーブル別名の利点**：クエリの短縮、可読性の向上、同一テーブルの複数回使用
4. **カラム別名**：SELECT句の結果セットの列に別名を付ける方法
5. **スペースを含む別名**：引用符を使って空白を含む別名を指定する方法
6. **ORDER BYでの別名使用**：ソート条件にカラム別名を使用する方法
7. **命名規則とベストプラクティス**：効果的な別名の付け方

テーブル別名とカラム別名はSQLの読みやすさと保守性を大きく向上させる重要な機能です。特に複数のテーブルを結合する複雑なクエリでは、適切な別名を使うことでコードの量が減り、理解しやすくなります。

次の章では、「結合の種類：JOIN、LEFT JOIN、RIGHT JOIN」について学び、さまざまな結合方法とその使い分けについて理解を深めていきます。



---

# 15. 結合の種類：INNER JOIN、LEFT JOIN、RIGHT JOIN

## はじめに

これまでの章で、テーブルを結合する基本的な方法であるINNER JOINと、クエリを簡潔にするためのテーブル別名について学びました。しかし実際のデータベース操作では、テーブル間の関係はさまざまであり、結合方法もそれに合わせて選ぶ必要があります。

例えば：
- 「すべての学生と、存在すれば成績情報も取得したい」
- 「課題を提出していない学生も含めて一覧を取得したい」
- 「担当講座のない教師も含めて教師一覧を表示したい」

このような要件に対応するためには、さまざまな種類の結合方法を理解する必要があります。この章では、主要な結合の種類（INNER JOIN、LEFT JOIN、RIGHT JOIN）とその使い分けについて学びます。

## 結合の種類とは

SQLでは、テーブルの結合方法として主に以下の種類があります：

1. **INNER JOIN（内部結合）**：両方のテーブルで一致するレコードのみを返します。
2. **LEFT JOIN（左外部結合）**：左テーブルのすべてのレコードと、右テーブルの一致するレコードを返します。
3. **RIGHT JOIN（右外部結合）**：右テーブルのすべてのレコードと、左テーブルの一致するレコードを返します。
4. **FULL JOIN（完全外部結合）**：両方のテーブルのすべてのレコードを返します（MySQLでは直接サポートされていません）。

> **用語解説**：
> - **内部結合**：両方のテーブルで条件に一致するレコードだけを返す結合方法。
> - **外部結合**：一方のテーブルのレコードがもう一方のテーブルに一致するレコードがなくても結果に含める結合方法。
> - **左テーブル**：FROM句で最初に指定されるテーブル。
> - **右テーブル**：JOIN句で指定されるテーブル。

## INNER JOIN（内部結合）の復習

INNER JOINは最も基本的な結合タイプで、13章で学んだ通り、両方のテーブルで結合条件に一致するレコードのみを返します。

### 基本構文

```sql
SELECT カラム名
FROM テーブル1
INNER JOIN テーブル2 ON 結合条件;
```

### 例1：INNER JOINの基本

学生と彼らが提出した成績情報を結合してみましょう：

```sql
SELECT s.student_id, s.student_name, g.course_id, g.score
FROM students s
INNER JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = '中間テスト'
ORDER BY s.student_id
LIMIT 5;
```

実行結果：

| student_id | student_name | course_id | score |
|------------|--------------|-----------|-------|
| 301        | 黒沢春馬     | 1         | 85.5  |
| 302        | 新垣愛留     | 1         | 92.0  |
| 303        | 柴崎春花     | 1         | 78.5  |
| 306        | 河田咲奈     | 1         | 88.0  |
| 307        | 織田柚夏     | 1         | 76.5  |

この結果には、成績テーブルに中間テストの記録がある学生だけが含まれています。成績記録のない学生は結果に含まれません。

## LEFT JOIN（左外部結合）

LEFT JOINは、左側のテーブル（FROM句のテーブル）のすべてのレコードを返し、右側のテーブル（JOIN句のテーブル）からは一致するレコードだけを返します。右側のテーブルに一致するレコードがない場合、そのカラムはNULLで埋められます。

> **用語解説**：
> - **LEFT JOIN**：左テーブルのすべてのレコードと、右テーブルの一致するレコードを返す結合方法です。
> - **NULL埋め**：一致するレコードがない場合、結果セット内の該当カラムはNULL値で埋められます。

### 基本構文

```sql
SELECT カラム名
FROM テーブル1
LEFT JOIN テーブル2 ON 結合条件;
```

### 例2：LEFT JOINの基本

すべての学生と、存在すれば彼らの成績情報を取得してみましょう：

```sql
SELECT s.student_id, s.student_name, g.course_id, g.score
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id AND g.grade_type = '中間テスト'
ORDER BY s.student_id
LIMIT 10;
```

実行結果：

| student_id | student_name | course_id | score |
|------------|--------------|-----------|-------|
| 301        | 黒沢春馬     | 1         | 85.5  |
| 302        | 新垣愛留     | 1         | 92.0  |
| 303        | 柴崎春花     | 1         | 78.5  |
| 304        | 森下風凛     | NULL      | NULL  |
| 305        | 河口菜恵子   | NULL      | NULL  |
| 306        | 河田咲奈     | 1         | 88.0  |
| 307        | 織田柚夏     | 1         | 76.5  |
| 308        | 永田悦子     | 1         | 91.0  |
| 309        | 相沢吉夫     | NULL      | NULL  |
| 310        | 吉川伽羅     | 1         | 82.5  |

この結果には、すべての学生が含まれています。成績記録がない学生（student_id = 304, 305, 309）の場合、course_idとscoreはNULLになっています。

### 例3：未提出者を見つける

LEFT JOINを使って、特定の課題を提出していない学生を見つけることができます：

```sql
SELECT s.student_id, s.student_name
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id AND g.grade_type = 'レポート1'
WHERE g.student_id IS NULL AND s.student_id < 320
ORDER BY s.student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |
| 309        | 相沢吉夫     |
| 313        | 佐藤大輔     |
| 314        | 中村彩香     |
| 316        | 渡辺美咲     |
| 319        | 加藤悠真     |

このクエリは、grades テーブルにレポート1の記録がない学生を探しています。WHEREで「g.student_id IS NULL」を指定することで、結合後にNULLになったレコード（＝提出していない学生）だけを抽出しています。

## RIGHT JOIN（右外部結合）

RIGHT JOINは、LEFT JOINの逆で、右側のテーブル（JOIN句のテーブル）のすべてのレコードを返し、左側のテーブル（FROM句のテーブル）からは一致するレコードだけを返します。

> **用語解説**：
> - **RIGHT JOIN**：右テーブルのすべてのレコードと、左テーブルの一致するレコードを返す結合方法です。

### 基本構文

```sql
SELECT カラム名
FROM テーブル1
RIGHT JOIN テーブル2 ON 結合条件;
```

### 例4：RIGHT JOINの基本

講座テーブルを基準に、その講座を受講している学生を取得してみましょう：

```sql
SELECT c.course_id, c.course_name, sc.student_id
FROM student_courses sc
RIGHT JOIN courses c ON sc.course_id = c.course_id AND sc.student_id = 301
ORDER BY c.course_id
LIMIT 10;
```

実行結果：

| course_id | course_name           | student_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 301        |
| 2         | UNIX入門             | 301        |
| 3         | Cプログラミング演習    | NULL       |
| 4         | Webアプリケーション開発 | NULL       |
| 5         | データベース設計と実装  | NULL       |
| 6         | ネットワークセキュリティ | NULL       |
| 7         | AI・機械学習入門      | NULL       |
| 8         | モバイルアプリ開発     | NULL       |
| 9         | クラウドコンピューティング | 301    |
| 10        | プロジェクト管理手法    | NULL       |

このクエリの結果には、すべての講座が含まれています。学生ID=301（黒沢春馬）が受講している講座（course_id = 1, 2, 9）では、student_idが表示され、それ以外の講座ではNULLになっています。

## LEFT JOINとRIGHT JOINの変換

LEFT JOINとRIGHT JOINは、テーブルの順序を入れ替えることで相互に変換できます。一般的には、LEFT JOINの方が直感的に理解しやすいため、多くの場合はLEFT JOINが好まれます。

次の2つのクエリは同等です：

```sql
-- LEFT JOINを使用
SELECT *
FROM テーブル1
LEFT JOIN テーブル2 ON 結合条件;

-- RIGHT JOINを使用（テーブルの順序を入れ替え）
SELECT *
FROM テーブル2
RIGHT JOIN テーブル1 ON 結合条件;
```

## 複数テーブルでの外部結合

外部結合は複数のテーブルを結合する場合にも使用できます。

### 例5：3つのテーブルを使った外部結合

学生、受講テーブル、講座テーブルを結合して、すべての学生と彼らが受講している講座（あれば）を取得してみましょう：

```sql
SELECT s.student_id, s.student_name, c.course_id, c.course_name
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN courses c ON sc.course_id = c.course_id
WHERE s.student_id BETWEEN 301 AND 305
ORDER BY s.student_id, c.course_id;
```

実行結果：

| student_id | student_name | course_id | course_name             |
|------------|--------------|-----------|------------------------|
| 301        | 黒沢春馬     | 1         | ITのための基礎知識       |
| 301        | 黒沢春馬     | 2         | UNIX入門               |
| 301        | 黒沢春馬     | 9         | クラウドコンピューティング |
| 301        | 黒沢春馬     | 16        | クラウドネイティブアーキテクチャ |
| ...        | ...          | ...       | ...                    |
| 302        | 新垣愛留     | 1         | ITのための基礎知識       |
| 302        | 新垣愛留     | 7         | AI・機械学習入門        |
| 302        | 新垣愛留     | 10        | プロジェクト管理手法      |
| ...        | ...          | ...       | ...                    |
| 303        | 柴崎春花     | 1         | ITのための基礎知識       |
| 303        | 柴崎春花     | 4         | Webアプリケーション開発   |
| 303        | 柴崎春花     | 10        | プロジェクト管理手法      |
| ...        | ...          | ...       | ...                    |
| 304        | 森下風凛     | 5         | データベース設計と実装    |
| 304        | 森下風凛     | 8         | モバイルアプリ開発       |
| 304        | 森下風凛     | 12        | サイバーセキュリティ対策  |
| ...        | ...          | ...       | ...                    |
| 305        | 河口菜恵子   | 4         | Webアプリケーション開発   |
| 305        | 河口菜恵子   | 7         | AI・機械学習入門        |
| 305        | 河口菜恵子   | 11        | データ分析と可視化       |
| ...        | ...          | ...       | ...                    |

このクエリでは2つのLEFT JOINを使用しています。最初のLEFT JOINは学生と受講テーブル、2つ目のLEFT JOINは受講テーブルと講座テーブルを結合しています。

## INNER JOINとLEFT JOINの使い分け

INNER JOINとLEFT JOIN（外部結合）は、用途に応じて使い分ける必要があります。以下のような基準で選択すると良いでしょう：

### INNER JOINを使う場合
- 両方のテーブルに対応するレコードが存在する場合のみデータを取得したい
- 関連付けられていないデータは不要な場合
- データの存在を確認したい場合

### LEFT JOIN（外部結合）を使う場合
- 主テーブルのすべてのレコードを表示したい
- 関連データがあるかどうかにかかわらず、主テーブルの情報は必要な場合
- 欠損データ（未提出、未登録など）を見つけたい場合
- レポート作成時に集計漏れを防ぎたい場合

## NULL値の処理に注意

外部結合を使用する場合、NULL値の処理に注意が必要です。特にWHERE句でフィルタリングする場合、通常の比較演算子（=, <, >など）はNULL値に対して常にFALSEを返します。

NULL値を検出するには「IS NULL」演算子を使用し、NULL値を除外するには「IS NOT NULL」演算子を使用します。

### 例6：NULL値の処理

```sql
-- 受講している講座がない学生を検索（NULLを検出）
SELECT s.student_id, s.student_name
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id IS NULL;

-- 少なくとも1つの講座を受講している学生を検索（NULLを除外）
SELECT DISTINCT s.student_id, s.student_name
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id IS NOT NULL;
```

## ON句とWHERE句の違い

LEFT JOINやRIGHT JOINを使用する場合、条件をON句に書くかWHERE句に書くかで結果が大きく変わることがあります。

- **ON句の条件**：結合操作の一部として適用され、外部結合の場合もNULL行を保持します。
- **WHERE句の条件**：結合後のすべての行に適用され、条件を満たさない行は結果から除外されます。

### 例7：ON句とWHERE句の違い

```sql
-- ON句に条件を書いた場合（外部結合の特性が保たれる）
SELECT s.student_id, s.student_name, g.score
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id AND g.grade_type = '中間テスト'
ORDER BY s.student_id
LIMIT 5;

-- WHERE句に条件を書いた場合（内部結合と同等になる）
SELECT s.student_id, s.student_name, g.score
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = '中間テスト'
ORDER BY s.student_id
LIMIT 5;
```

最初のクエリでは、すべての学生が結果に含まれ、中間テストのスコアがある場合はその値が表示され、ない場合はNULLになります。

2つ目のクエリでは、WHERE句でg.grade_type = '中間テスト'という条件を指定しているため、中間テストのスコアがない学生は結果から除外されます（実質的にINNER JOINと同等になります）。

## 練習問題

### 問題15-1
courses（講座）テーブルとteachers（教師）テーブルを使い、すべての講座とその担当教師（いれば）の情報を取得するSQLを書いてください。LEFT JOINを使用してください。

### 問題15-2
students（学生）テーブルとgrades（成績）テーブルを使い、講座ID（course_id）= 1の中間テストを受けていない学生を特定するSQLを書いてください。

### 問題15-3
teachers（教師）テーブルとcourses（講座）テーブルを使い、担当講座がない教師を特定するSQLを書いてください。

### 問題15-4
course_schedule（授業カレンダー）テーブルとattendance（出席）テーブルを使い、2025年5月20日の各授業に対する出席学生数と欠席学生数を集計するSQLを書いてください。

### 問題15-5
students（学生）テーブル、student_courses（受講）テーブル、courses（講座）テーブルを使い、各学生が受講している講座の数を取得するSQLを書いてください。受講していない学生も0として表示してください。

### 問題15-6
course_schedule（授業カレンダー）テーブル、teachers（教師）テーブル、teacher_unavailability（講師スケジュール管理）テーブルを使い、今後の授業予定（schedule_date >= '2025-05-20'）について、担当教師が不在期間と重なっているかどうかをチェックするSQLを書いてください。不在期間と重なっている場合は「要注意」、そうでない場合は「OK」と表示してください。

## 解答

### 解答15-1
```sql
SELECT c.course_id, c.course_name, t.teacher_id, t.teacher_name
FROM courses c
LEFT JOIN teachers t ON c.teacher_id = t.teacher_id
ORDER BY c.course_id;
```

### 解答15-2
```sql
SELECT s.student_id, s.student_name
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id 
                   AND g.course_id = '1' 
                   AND g.grade_type = '中間テスト'
WHERE g.student_id IS NULL
ORDER BY s.student_id;
```

### 解答15-3
```sql
SELECT t.teacher_id, t.teacher_name
FROM teachers t
LEFT JOIN courses c ON t.teacher_id = c.teacher_id
WHERE c.teacher_id IS NULL;
```

### 解答15-4
```sql
SELECT 
    cs.schedule_id,
    c.course_name,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS 出席数,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS 欠席数,
    SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS 遅刻数,
    COUNT(a.student_id) AS 総数
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
LEFT JOIN courses c ON cs.course_id = c.course_id
WHERE cs.schedule_date = '2025-05-20'
GROUP BY cs.schedule_id, c.course_name
ORDER BY cs.schedule_id;
```

### 解答15-5
```sql
SELECT 
    s.student_id,
    s.student_name,
    COUNT(sc.course_id) AS 受講講座数
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
GROUP BY s.student_id, s.student_name
ORDER BY s.student_id;
```

### 解答15-6
```sql
SELECT 
    cs.schedule_id,
    cs.schedule_date,
    t.teacher_name,
    c.course_name,
    CASE 
        WHEN tu.teacher_id IS NOT NULL THEN '要注意 - ' || tu.reason
        ELSE 'OK'
    END AS 状態
FROM course_schedule cs
INNER JOIN teachers t ON cs.teacher_id = t.teacher_id
INNER JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN teacher_unavailability tu ON cs.teacher_id = tu.teacher_id
                                    AND cs.schedule_date BETWEEN tu.start_date AND tu.end_date
WHERE cs.schedule_date >= '2025-05-20'
ORDER BY cs.schedule_date, cs.period_id;
```

## まとめ

この章では、データベースのさまざまな結合方法について学びました：

1. **INNER JOIN（内部結合）**：両方のテーブルで条件に一致するレコードのみを返す
2. **LEFT JOIN（左外部結合）**：左テーブルのすべてのレコードと、右テーブルの一致するレコードを返す
3. **RIGHT JOIN（右外部結合）**：右テーブルのすべてのレコードと、左テーブルの一致するレコードを返す
4. **結合方法の使い分け**：目的に応じてINNER JOINと外部結合を使い分ける基準
5. **NULL値の処理**：外部結合結果のNULL値を適切に処理する方法
6. **ON句とWHERE句の違い**：条件の記述場所による結果の違い

適切な結合方法を選択することで、より柔軟で正確なデータの抽出が可能になります。特に、データの欠損（未提出、未登録など）を検出したい場合や、すべてのレコードを漏れなく処理したい場合には、外部結合が非常に役立ちます。

次の章では、「自己結合：同一テーブル内での関連付け」について学び、同じテーブル内でのデータ間の関係を扱う方法を学びます。



---

# 16. 自己結合：同一テーブル内での関連付け

## はじめに

これまでの章では、異なるテーブル同士を結合する方法について学びました。しかし実際のデータベース設計では、同じテーブル内にデータ同士の関連がある場合があります。例えば：

- 社員テーブルで「上司」も同じ社員テーブル内の別の社員である
- 部品表で「部品」と「その部品の構成部品」が同じテーブルに格納されている
- 家系図データで「親」と「子」が同じ人物テーブルに格納されている

このような「同一テーブル内のレコード同士の関連」を取り扱うための結合方法が「自己結合（セルフジョイン）」です。この章では、テーブル自身と結合して情報を取得する方法について学びます。

## 自己結合（セルフジョイン）とは

自己結合とは、テーブルを自分自身と結合する技術です。テーブル内のあるレコードと、同じテーブル内の別のレコードとの関係を表現するために使用されます。

> **用語解説**：
> - **自己結合（セルフジョイン）**：同じテーブルを異なる別名で参照し、テーブル自身と結合する手法です。
> - **再帰的関係**：同じエンティティ（テーブル）内での親子関係や階層構造などの関係のこと。

## 自己結合の基本

自己結合を行うには、同じテーブルを異なる別名で参照する必要があります。これは通常、テーブル別名（エイリアス）を使用して実現します。

### 基本構文

```sql
SELECT a.カラム1, a.カラム2, b.カラム1, b.カラム2
FROM テーブル名 a
JOIN テーブル名 b ON a.関連カラム = b.主キー;
```

ここで、`a`と`b`は同じテーブルに対する異なる別名です。

## 自己結合の実践例

学校データベースでは、明示的な再帰的関係を持つテーブルはありませんが、自己結合の概念を理解するために簡単な例を見てみましょう。

### 例1：同じ教師が担当する講座を検索

```sql
SELECT 
    c1.course_id AS 講座ID, 
    c1.course_name AS 講座名,
    c2.course_id AS 関連講座ID,
    c2.course_name AS 関連講座名,
    t.teacher_name AS 担当教師
FROM courses c1
JOIN courses c2 ON c1.teacher_id = c2.teacher_id AND c1.course_id < c2.course_id
JOIN teachers t ON c1.teacher_id = t.teacher_id
ORDER BY t.teacher_name, c1.course_id, c2.course_id;
```

このクエリは、同じ教師が担当している講座の組み合わせを検索しています。
- `c1`と`c2`は同じcoursesテーブルの別名
- `c1.teacher_id = c2.teacher_id`で同じ教師を担当している講座を結合
- `c1.course_id < c2.course_id`でペアの重複を避けています（例：講座1と講座2、講座2と講座1が両方表示されることを防ぐ）

実行結果：

| 講座ID | 講座名                 | 関連講座ID | 関連講座名             | 担当教師   |
|-------|------------------------|-----------|------------------------|-----------|
| 4     | Webアプリケーション開発 | 8         | モバイルアプリ開発     | 藤本理恵   |
| 4     | Webアプリケーション開発 | 22        | フルスタック開発マスタークラス | 藤本理恵 |
| 8     | モバイルアプリ開発     | 22        | フルスタック開発マスタークラス | 藤本理恵 |
| 1     | ITのための基礎知識     | 3         | Cプログラミング演習     | 寺内鞍     |
| 1     | ITのための基礎知識     | 29        | コードリファクタリングとクリーンコード | 寺内鞍 |
| 3     | Cプログラミング演習     | 29        | コードリファクタリングとクリーンコード | 寺内鞍 |
| ...   | ...                    | ...       | ...                    | ...       |

### 例2：同じ日に複数の授業がある教師を検索

```sql
SELECT 
    cs1.schedule_date AS 日付,
    t.teacher_name AS 教師名,
    cs1.period_id AS 時限1,
    c1.course_name AS 講座1,
    cs2.period_id AS 時限2,
    c2.course_name AS 講座2
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.teacher_id = cs2.teacher_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.period_id < cs2.period_id
JOIN teachers t ON cs1.teacher_id = t.teacher_id
JOIN courses c1 ON cs1.course_id = c1.course_id
JOIN courses c2 ON cs2.course_id = c2.course_id
WHERE cs1.schedule_date = '2025-05-21'
ORDER BY cs1.schedule_date, t.teacher_name, cs1.period_id, cs2.period_id;
```

このクエリは、同じ日に複数の授業を担当する教師と、その授業の組み合わせを検索しています。
- `cs1`と`cs2`は同じcourse_scheduleテーブルの別名
- `cs1.teacher_id = cs2.teacher_id AND cs1.schedule_date = cs2.schedule_date`で同じ教師が同じ日に担当している授業を結合
- `cs1.period_id < cs2.period_id`でペアの重複を避けています

実行結果（例）：

| 日付       | 教師名     | 時限1 | 講座1                 | 時限2 | 講座2                 |
|-----------|------------|------|----------------------|------|----------------------|
| 2025-05-21 | 星野涼子   | 1    | 高度データ可視化技術   | 3    | データサイエンスとビジネス応用 |
| 2025-05-21 | 寺内鞍     | 2    | コードリファクタリングとクリーンコード | 4 | Cプログラミング演習 |
| ...       | ...        | ...  | ...                  | ...  | ...                  |

## 自己結合の応用：階層構造の表現

自己結合は、階層構造のデータを表現する際に特に役立ちます。例えば、組織図、カテゴリ階層、部品表などです。

ここでは、学校データベースにはない例として、架空の「社員」テーブルを使って階層構造を表現する例を示します：

### 例3：架空の社員テーブルを使った階層構造の表現

```sql
-- 架空の社員テーブル
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100),
  manager_id INT,
  FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- サンプルデータ
INSERT INTO employees VALUES (1, '山田太郎', NULL);  -- 社長（上司なし）
INSERT INTO employees VALUES (2, '佐藤次郎', 1);     -- 山田の部下
INSERT INTO employees VALUES (3, '鈴木三郎', 1);     -- 山田の部下
INSERT INTO employees VALUES (4, '高橋四郎', 2);     -- 佐藤の部下
INSERT INTO employees VALUES (5, '田中五郎', 2);     -- 佐藤の部下
INSERT INTO employees VALUES (6, '伊藤六郎', 3);     -- 鈴木の部下

-- 社員と直属の上司を取得
SELECT 
    e.employee_id,
    e.employee_name AS 社員名,
    m.employee_name AS 上司名
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;
```

結果：

| employee_id | 社員名     | 上司名     |
|-------------|------------|------------|
| 1           | 山田太郎   | NULL       |
| 2           | 佐藤次郎   | 山田太郎   |
| 3           | 鈴木三郎   | 山田太郎   |
| 4           | 高橋四郎   | 佐藤次郎   |
| 5           | 田中五郎   | 佐藤次郎   |
| 6           | 伊藤六郎   | 鈴木三郎   |

この例では、社員テーブルの`manager_id`が同じテーブルの`employee_id`を参照しています（自己参照）。自己結合を使用して、各社員の上司の名前を取得しています。

### 例4：架空の社員テーブルを使った部下の一覧表示

```sql
-- ある上司の直属の部下を取得
SELECT 
    m.employee_id AS 上司ID,
    m.employee_name AS 上司名,
    e.employee_id AS 部下ID,
    e.employee_name AS 部下名
FROM employees m
JOIN employees e ON m.employee_id = e.manager_id
WHERE m.employee_id = 2
ORDER BY e.employee_id;
```

結果：

| 上司ID | 上司名   | 部下ID | 部下名   |
|--------|----------|--------|----------|
| 2      | 佐藤次郎 | 4      | 高橋四郎 |
| 2      | 佐藤次郎 | 5      | 田中五郎 |

この例では、社員テーブルを`m`（上司）と`e`（部下）として自己結合し、上司ID=2の部下を取得しています。

## 学校データベースでの自己結合活用例

実際の学校データベースでは、自己結合を利用できる具体的なシナリオを見てみましょう。

### 例5：同じ教室を使用する授業の組み合わせ

```sql
SELECT 
    cs1.schedule_date AS 日付,
    cs1.classroom_id AS 教室,
    cs1.period_id AS 時限1,
    c1.course_name AS 講座1,
    t1.teacher_name AS 教師1,
    cs2.period_id AS 時限2,
    c2.course_name AS 講座2,
    t2.teacher_name AS 教師2
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.classroom_id = cs2.classroom_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.period_id < cs2.period_id
JOIN courses c1 ON cs1.course_id = c1.course_id
JOIN courses c2 ON cs2.course_id = c2.course_id
JOIN teachers t1 ON cs1.teacher_id = t1.teacher_id
JOIN teachers t2 ON cs2.teacher_id = t2.teacher_id
WHERE cs1.schedule_date = '2025-05-21'
ORDER BY cs1.classroom_id, cs1.period_id;
```

このクエリは、同じ日に同じ教室で行われる授業の組み合わせを検索しています。教室の利用状況や消毒・清掃のスケジュール計画などに役立ちます。

### 例6：同じ学生が受講している講座の組み合わせ

```sql
SELECT 
    sc1.student_id,
    s.student_name,
    c1.course_name AS 講座1,
    c2.course_name AS 講座2
FROM student_courses sc1
JOIN student_courses sc2 ON sc1.student_id = sc2.student_id AND sc1.course_id < sc2.course_id
JOIN students s ON sc1.student_id = s.student_id
JOIN courses c1 ON sc1.course_id = c1.course_id
JOIN courses c2 ON sc2.course_id = c2.course_id
WHERE sc1.student_id = 301
ORDER BY c1.course_name, c2.course_name;
```

このクエリは、学生ID=301の学生が受講しているすべての講座の組み合わせを検索しています。学生の履修パターンの分析や時間割の調整などに役立ちます。

## INNER JOINとLEFT JOINの自己結合

自己結合では、INNER JOIN、LEFT JOIN、RIGHT JOINなど、すべての結合タイプを使用できます。結合タイプの選択は、取得したいデータの性質に依存します。

### 例7：部下のいない社員を見つける（LEFT JOIN）

```sql
-- 架空の社員テーブルを使用
SELECT 
    m.employee_id,
    m.employee_name,
    COUNT(e.employee_id) AS 部下の数
FROM employees m
LEFT JOIN employees e ON m.employee_id = e.manager_id
GROUP BY m.employee_id, m.employee_name
HAVING COUNT(e.employee_id) = 0
ORDER BY m.employee_id;
```

このクエリは、部下のいない社員（つまり、誰も自分を上司として参照していない社員）を検索しています。結果として、employee_id = 4, 5, 6の社員（高橋四郎、田中五郎、伊藤六郎）が表示されるでしょう。

## 自己結合の注意点

自己結合を使用する際には、以下の点に注意が必要です：

1. **テーブル別名の明確化**：同じテーブルを複数回参照するため、わかりやすいテーブル別名を使用し、混乱を避けましょう。

2. **結合条件の正確性**：自己結合では結合条件が不適切だと、結果が指数関数的に増えることがあります。必要に応じて絞り込み条件を追加しましょう。

3. **重複の排除**：例1や例2で使用した`id1 < id2`のような条件を使って、組み合わせの重複を避けることが重要です。

4. **パフォーマンス**：自己結合は、特に大きなテーブルでは処理が重くなる可能性があります。必要に応じてインデックスを使用して最適化しましょう。

## 練習問題

### 問題16-1
教師（teachers）テーブルを自己結合して、教師IDが連続する教師のペア（例：ID 101と102, 102と103）を取得するSQLを書いてください。

### 問題16-2
course_schedule（授業カレンダー）テーブルを自己結合して、2025年5月15日に同じ教室で行われる授業のペアを時限の昇順で取得するSQLを書いてください。course_id、period_id、classroom_idの3つを表示してください。

### 問題16-3
生徒（students）テーブルを自己結合して、学生名（student_name）のファーストネーム（名前の最初の文字）が同じ学生のペアを取得するSQLを書いてください。ヒント：SUBSTRING関数を使用します。

### 問題16-4
course_schedule（授業カレンダー）テーブルを自己結合して、同じ日に同じ講師が担当する授業のペアを見つけるSQLを書いてください。期間が離れていない授業（period_idの差が1または2）のみを対象とします。

### 問題16-5
grades（成績）テーブルを自己結合して、同じ学生の異なる課題タイプ（grade_type）間で点数差が10点以上あるケースを検出するSQLを書いてください。

### 問題16-6
以下のような架空の「職階」テーブルを作成し、直接の上下関係（部下と上司）だけでなく、組織階層全体を表示するSQLを書いてください。

```sql
-- 架空の職階テーブル
CREATE TABLE job_hierarchy (
  level_id INT PRIMARY KEY,
  level_name VARCHAR(50),
  reports_to INT,
  FOREIGN KEY (reports_to) REFERENCES job_hierarchy(level_id)
);

-- データ挿入
INSERT INTO job_hierarchy VALUES (1, '学長', NULL);
INSERT INTO job_hierarchy VALUES (2, '副学長', 1);
INSERT INTO job_hierarchy VALUES (3, '学部長', 2);
INSERT INTO job_hierarchy VALUES (4, '学科長', 3);
INSERT INTO job_hierarchy VALUES (5, '教授', 4);
INSERT INTO job_hierarchy VALUES (6, '准教授', 5);
INSERT INTO job_hierarchy VALUES (7, '講師', 6);
INSERT INTO job_hierarchy VALUES (8, '助教', 7);
```

## 解答

### 解答16-1
```sql
SELECT 
    t1.teacher_id AS 教師ID1,
    t1.teacher_name AS 教師名1,
    t2.teacher_id AS 教師ID2,
    t2.teacher_name AS 教師名2
FROM teachers t1
JOIN teachers t2 ON t1.teacher_id + 1 = t2.teacher_id
ORDER BY t1.teacher_id;
```

### 解答16-2
```sql
SELECT 
    cs1.course_id AS 講座ID1,
    cs1.period_id AS 時限1,
    cs2.course_id AS 講座ID2,
    cs2.period_id AS 時限2,
    cs1.classroom_id AS 教室
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.classroom_id = cs2.classroom_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.period_id < cs2.period_id
WHERE cs1.schedule_date = '2025-05-15'
ORDER BY cs1.classroom_id, cs1.period_id, cs2.period_id;
```

### 解答16-3
```sql
SELECT 
    s1.student_id AS 学生ID1,
    s1.student_name AS 学生名1,
    s2.student_id AS 学生ID2,
    s2.student_name AS 学生名2,
    SUBSTRING(s1.student_name, 1, 1) AS 共通文字
FROM students s1
JOIN students s2 ON SUBSTRING(s1.student_name, 1, 1) = SUBSTRING(s2.student_name, 1, 1)
              AND s1.student_id < s2.student_id
ORDER BY 共通文字, s1.student_id, s2.student_id;
```

### 解答16-4
```sql
SELECT 
    cs1.schedule_date AS 日付,
    t.teacher_name AS 教師名,
    cs1.period_id AS 時限1,
    cs1.course_id AS 講座ID1,
    cs2.period_id AS 時限2,
    cs2.course_id AS 講座ID2,
    ABS(cs1.period_id - cs2.period_id) AS 時限差
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.teacher_id = cs2.teacher_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.schedule_id < cs2.schedule_id
JOIN teachers t ON cs1.teacher_id = t.teacher_id
WHERE ABS(cs1.period_id - cs2.period_id) IN (1, 2)
ORDER BY cs1.schedule_date, t.teacher_name, cs1.period_id;
```

### 解答16-5
```sql
SELECT 
    g1.student_id,
    s.student_name,
    g1.grade_type AS 評価タイプ1,
    g1.score AS 点数1,
    g2.grade_type AS 評価タイプ2,
    g2.score AS 点数2,
    ABS(g1.score - g2.score) AS 点数差
FROM grades g1
JOIN grades g2 ON g1.student_id = g2.student_id 
               AND g1.course_id = g2.course_id 
               AND g1.grade_type < g2.grade_type
JOIN students s ON g1.student_id = s.student_id
WHERE ABS(g1.score - g2.score) >= 10
ORDER BY 点数差 DESC, g1.student_id;
```

### 解答16-6
```sql
-- 組織階層全体を表示
WITH RECURSIVE hierarchy AS (
  -- 基点（学長）
  SELECT 
    level_id, 
    level_name, 
    reports_to, 
    0 AS depth, 
    CAST(level_name AS CHAR(200)) AS path
  FROM job_hierarchy
  WHERE reports_to IS NULL
  
  UNION ALL
  
  -- 再帰部分
  SELECT 
    j.level_id, 
    j.level_name, 
    j.reports_to, 
    h.depth + 1, 
    CONCAT(h.path, ' > ', j.level_name)
  FROM job_hierarchy j
  JOIN hierarchy h ON j.reports_to = h.level_id
)
SELECT 
  level_id,
  level_name,
  reports_to,
  depth,
  CONCAT(REPEAT('    ', depth), level_name) AS 階層表示,
  path AS 組織経路
FROM hierarchy
ORDER BY depth, level_id;
```

注意：最後の問題は再帰共通テーブル式（Recursive CTE）を使用しています。これはMySQL 8.0以降でサポートされています。再帰CTEはまだ学習していない高度な内容ですが、階層構造を扱う効果的な方法として参考になります。

## まとめ

この章では、同一テーブル内でのレコード間の関連を扱うための「自己結合」について学びました：

1. **自己結合の概念**：テーブルを自分自身と結合して、同一テーブル内のレコード間の関係を表現する方法
2. **基本的な構文**：テーブル別名を使用して同じテーブルを複数回参照する方法
3. **実践的な例**：同じ教師が担当する講座、同じ日の複数の授業など、実用的な自己結合のケース
4. **階層構造の表現**：上司と部下、組織階層など、再帰的な関係の表現方法
5. **さまざまな結合タイプ**：INNER JOINやLEFT JOINなど、自己結合でも利用可能な結合の種類
6. **注意点**：テーブル別名の明確化、結合条件の正確性、重複の排除、パフォーマンスの考慮

自己結合は、階層構造の表現や、同一エンティティ内での関連を取り扱う強力な手法です。特に組織図、部品表、カテゴリ階層、家系図など、再帰的な関係を含むデータモデルで頻繁に活用されます。

次の章では、「複数テーブル結合：3つ以上のテーブルの連結」について学び、より複雑なデータ関係を扱う方法を学びます。



---

# 17. 複数テーブル結合：3つ以上のテーブルの連結

## はじめに

これまでの章では、2つのテーブルを結合する方法や、同じテーブルを自己結合する方法について学びました。しかし、実際のデータベース操作では、3つ以上のテーブルを一度に結合して情報を取得する必要があることが多くあります。

例えば、以下のようなケースを考えてみましょう：
- 「学生の名前、受講している講座名、その担当教師名、教室情報を一度に取得したい」
- 「授業スケジュール、講座情報、教室情報、時間情報をまとめて表示したい」
- 「成績データに学生名、講座名、提出情報を関連付けて分析したい」

これらを実現するには、3つ以上のテーブルを連結する必要があります。この章では、複数のテーブルを効果的に結合する方法について学びます。

## 複数テーブル結合の基本

3つ以上のテーブルを結合する基本的な考え方は、2つのテーブルの結合を拡張したものです。2つのテーブルを結合した結果に、さらに別のテーブルを結合していきます。

> **用語解説**：
> - **複数結合**：3つ以上のテーブルを一度に連結して情報を取得する操作のことです。
> - **結合チェーン**：複数のJOIN句を連続して記述し、テーブルをつなげていく方法です。

### 基本構文

```sql
SELECT カラムリスト
FROM テーブル1
JOIN テーブル2 ON 結合条件1
JOIN テーブル3 ON 結合条件2
JOIN テーブル4 ON 結合条件3
...;
```

JOINの種類（INNER JOIN、LEFT JOIN、RIGHT JOINなど）は、各結合ごとに適切に選択できます。

## 3つのテーブルを結合する例

まずは、3つのテーブルを結合する基本的な例を見てみましょう。

### 例1：学生、講座、教師の情報を連結する

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE s.student_id = 301
ORDER BY c.course_id;
```

このクエリでは：
1. 学生テーブル(`students`)を基点に
2. 受講テーブル(`student_courses`)を結合し
3. 講座テーブル(`courses`)を結合し
4. 教師テーブル(`teachers`)を結合しています

実行結果：

| student_id | 学生名   | 講座名                 | 担当教師   |
|------------|----------|------------------------|------------|
| 301        | 黒沢春馬 | ITのための基礎知識     | 寺内鞍     |
| 301        | 黒沢春馬 | UNIX入門               | 田尻朋美   |
| 301        | 黒沢春馬 | クラウドコンピューティング | 吉岡由佳 |
| 301        | 黒沢春馬 | クラウドネイティブアーキテクチャ | 吉岡由佳 |
| ...        | ...      | ...                    | ...        |

## 4つ以上のテーブルを結合する例

より複雑な情報を取得するために、4つ以上のテーブルを結合してみましょう。

### 例2：授業スケジュール詳細の取得

```sql
SELECT 
    cs.schedule_date AS 日付,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師,
    cl.classroom_name AS 教室,
    cl.building AS 建物,
    cs.status AS 状態
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
WHERE cs.schedule_date = '2025-05-21'
ORDER BY cp.start_time, cl.classroom_id;
```

このクエリでは、5つのテーブルを結合して授業スケジュールの詳細情報を取得しています：
1. 授業カレンダーテーブル(`course_schedule`)を基点に
2. 講座テーブル(`courses`)を結合し
3. 教師テーブル(`teachers`)を結合し
4. 教室テーブル(`classrooms`)を結合し
5. 授業時間テーブル(`class_periods`)を結合しています

実行結果（例）：

| 日付       | 開始時間 | 終了時間 | 講座名                 | 担当教師   | 教室           | 建物  | 状態      |
|------------|----------|----------|------------------------|------------|----------------|-------|-----------|
| 2025-05-21 | 09:00:00 | 10:30:00 | 高度データ可視化技術   | 星野涼子   | 402Hコンピュータ実習室 | 4号館 | scheduled |
| 2025-05-21 | 09:00:00 | 10:30:00 | サイバーセキュリティ対策 | 深山誠一 | 301E講義室    | 3号館 | scheduled |
| 2025-05-21 | 10:40:00 | 12:10:00 | コードリファクタリングとクリーンコード | 寺内鞍 | 101Aコンピュータ実習室 | 1号館 | scheduled |
| ...        | ...      | ...      | ...                    | ...        | ...            | ...   | ...       |

## 複数テーブル結合のバリエーション

複数テーブルの結合では、さまざまな結合タイプを組み合わせることができます。

### 例3：INNER JOINとLEFT JOINの組み合わせ

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.grade_type AS 評価種別,
    g.score AS 点数,
    a.status AS 出席状況
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
LEFT JOIN grades g ON s.student_id = g.student_id AND sc.course_id = g.course_id AND g.grade_type = '中間テスト'
LEFT JOIN attendance a ON s.student_id = a.student_id
WHERE s.student_id = 301
ORDER BY c.course_id;
```

このクエリでは、以下のように異なる結合タイプを組み合わせています：
- students、student_courses、coursesテーブルには**INNER JOIN**を使用（関連データが必ず存在するため）
- gradesテーブルには**LEFT JOIN**を使用（中間テストの成績がない可能性があるため）
- attendanceテーブルにも**LEFT JOIN**を使用（出席情報がない可能性があるため）

## 結合順序とパフォーマンス

複数テーブルを結合する場合、結合の順序はSQLの実行計画に影響しますが、通常はデータベースのオプティマイザが最適な実行順序を決定します。ただし、以下の点に注意すると効率的なクエリを書くことができます：

1. **フィルタリングを早めに行う**：WHERE句での絞り込みを早い段階で行うことで、結合対象のレコード数を減らせます。

2. **小さいテーブルから大きいテーブルへ**：一般的に、小さいテーブルを基点に、より大きいテーブルを結合していく方が効率的です。

3. **結合条件の最適化**：インデックスが設定されているカラムを結合条件に使用すると、パフォーマンスが向上します。

### 例4：効率的な結合順序とフィルタリングの例

```sql
SELECT 
    cs.schedule_date,
    c.course_name,
    COUNT(a.student_id) AS 出席学生数
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND a.status = 'present'
WHERE cs.schedule_date BETWEEN '2025-05-01' AND '2025-05-31'
GROUP BY cs.schedule_id, cs.schedule_date, c.course_name
ORDER BY cs.schedule_date, c.course_name;
```

このクエリでは、以下の効率化を行っています：
- 日付範囲による絞り込みを早い段階で行っている（`course_schedule`テーブルへのWHERE句）
- 比較的小さい`course_schedule`テーブルを基点にしている
- 出席状態のフィルタリングを結合条件に含めている（`a.status = 'present'`）

## テーブル別名の重要性

複数テーブルの結合では、テーブル別名（エイリアス）の使用が特に重要になります。テーブル別名を使うことで：

1. コードが簡潔になる
2. 同じカラム名が複数のテーブルに存在する場合の曖昧さが解消される
3. SQLの可読性が向上する

### 例5：明確なテーブル別名の使用

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    t.teacher_name AS 教師名,
    cs.schedule_date AS 日付,
    cp.start_time AS 開始時間,
    cl.classroom_name AS 教室
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
JOIN course_schedule cs ON c.course_id = cs.course_id
JOIN class_periods cp ON cs.period_id = cp.period_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
WHERE s.student_id = 301
  AND cs.schedule_date >= '2025-05-01'
ORDER BY cs.schedule_date, cp.start_time;
```

このクエリでは、7つのテーブルに明確な別名を付けています：
- students → s
- student_courses → sc
- courses → c
- teachers → t
- course_schedule → cs
- class_periods → cp
- classrooms → cl

## 複雑な多テーブル結合の実用例

実際の業務でよく使われる、より複雑な多テーブル結合の例を見てみましょう。

### 例6：学生の成績と出席状況の総合分析

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_id,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師,
    -- 中間テストの点数
    MAX(CASE WHEN g.grade_type = '中間テスト' THEN g.score ELSE NULL END) AS 中間テスト,
    -- レポートの点数
    MAX(CASE WHEN g.grade_type = 'レポート1' THEN g.score ELSE NULL END) AS レポート,
    -- 出席情報の集計
    COUNT(DISTINCT cs.schedule_id) AS 授業回数,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS 出席回数,
    SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS 遅刻回数,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS 欠席回数,
    -- 出席率の計算
    ROUND(
        SUM(CASE 
            WHEN a.status = 'present' THEN 1 
            WHEN a.status = 'late' THEN 0.5 
            ELSE 0 
        END) / COUNT(DISTINCT cs.schedule_id) * 100, 
    1) AS 出席率
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
LEFT JOIN course_schedule cs ON c.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND s.student_id = a.student_id
WHERE s.student_id BETWEEN 301 AND 305
GROUP BY s.student_id, s.student_name, c.course_id, c.course_name, t.teacher_name
ORDER BY s.student_id, c.course_id;
```

このクエリは、複数のテーブルを結合して各学生の成績と出席状況を総合的に分析しています。特徴として：
- 複数テーブルの結合
- CASE式を使った条件付き集計
- GROUP BY句による集計
- 計算式を使った派生列（出席率）

## 練習問題

### 問題17-1
学生（students）、受講（student_courses）、講座（courses）の3つのテーブルを結合して、学生ID=302の学生が受講しているすべての講座名とその講座IDを取得するSQLを書いてください。

### 問題17-2
講座（courses）、授業カレンダー（course_schedule）、教室（classrooms）、授業時間（class_periods）の4つのテーブルを結合して、2025年5月22日のすべての授業スケジュールを、開始時間順に取得するSQLを書いてください。結果には講座名、教室名、開始時間、終了時間、担当教師名を含めてください。

### 問題17-3
学生（students）テーブル、成績（grades）テーブル、講座（courses）テーブルを結合して、「ITのための基礎知識」（course_id=1）の講座を受講している学生の中間テスト成績を、点数の高い順に取得するSQLを書いてください。結果には学生名、得点、および講座名を含めてください。

### 問題17-4
教師（teachers）テーブル、講座（courses）テーブル、授業カレンダー（course_schedule）テーブル、教室（classrooms）テーブルを結合して、教師ID=106（星野涼子）が2025年5月に担当するすべての授業の詳細を取得するSQLを書いてください。結果には授業日、講座名、教室名を含めてください。

### 問題17-5
学生（students）テーブル、受講（student_courses）テーブル、講座（courses）テーブル、成績（grades）テーブルを結合して、各学生の受講講座数と成績の平均点を計算するSQLを書いてください。成績がない場合も学生と講座は表示してください。結果を平均点の高い順に並べてください。

### 問題17-6
授業カレンダー（course_schedule）テーブル、講座（courses）テーブル、教師（teachers）テーブル、教師スケジュール管理（teacher_unavailability）テーブルを結合して、2025年5月20日以降に予定されている授業のうち、担当教師が不在期間と重なっている授業を特定するSQLを書いてください。結果には授業日、講座名、教師名、不在理由を含めてください。

## 解答

### 解答17-1
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_id,
    c.course_name AS 講座名
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE s.student_id = 302
ORDER BY c.course_id;
```

### 解答17-2
```sql
SELECT 
    c.course_name AS 講座名,
    cl.classroom_name AS 教室名,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間,
    t.teacher_name AS 担当教師名
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
WHERE cs.schedule_date = '2025-05-22'
ORDER BY cp.start_time, cl.classroom_id;
```

### 解答17-3
```sql
SELECT 
    s.student_name AS 学生名,
    g.score AS 得点,
    c.course_name AS 講座名
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE c.course_id = '1'
  AND g.grade_type = '中間テスト'
ORDER BY g.score DESC;
```

### 解答17-4
```sql
SELECT 
    cs.schedule_date AS 授業日,
    c.course_name AS 講座名,
    cl.classroom_name AS 教室名,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間
FROM teachers t
JOIN course_schedule cs ON t.teacher_id = cs.teacher_id
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
WHERE t.teacher_id = 106
  AND cs.schedule_date BETWEEN '2025-05-01' AND '2025-05-31'
ORDER BY cs.schedule_date, cp.start_time;
```

### 解答17-5
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    COUNT(DISTINCT sc.course_id) AS 受講講座数,
    AVG(g.score) AS 平均点
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN courses c ON sc.course_id = c.course_id
LEFT JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
GROUP BY s.student_id, s.student_name
ORDER BY 平均点 DESC NULLS LAST;
```

注：`NULLS LAST`はデータベースによってはサポートされていない場合があります。その場合は以下のように書き換えます：

```sql
ORDER BY CASE WHEN AVG(g.score) IS NULL THEN 0 ELSE 1 END DESC, AVG(g.score) DESC
```

### 解答17-6
```sql
SELECT 
    cs.schedule_date AS 授業日,
    c.course_name AS 講座名,
    t.teacher_name AS 教師名,
    tu.reason AS 不在理由
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
JOIN teacher_unavailability tu ON cs.teacher_id = tu.teacher_id
WHERE cs.schedule_date >= '2025-05-20'
  AND cs.schedule_date BETWEEN tu.start_date AND tu.end_date
ORDER BY cs.schedule_date, cs.period_id;
```

## まとめ

この章では、3つ以上のテーブルを結合して複雑な情報を取得する方法について学びました：

1. **複数テーブル結合の基本構文**：JOINをチェーンさせて3つ以上のテーブルを連結する方法
2. **さまざまな結合タイプの組み合わせ**：INNER JOIN、LEFT JOIN、RIGHT JOINを状況に応じて組み合わせる方法
3. **結合順序とパフォーマンスの考慮点**：効率的なクエリを作成するためのヒント
4. **テーブル別名の重要性**：複数テーブル結合での可読性と明確さの向上
5. **複雑な結合の実用例**：実際の業務で使われるような多テーブル結合の例

複数テーブルの結合は、関連するデータを効率的に取得し、有意義な情報を抽出するための重要なスキルです。特に正規化されたデータベースでは、必要な情報を得るためには複数のテーブルを結合することが必須となります。

次の章では、「サブクエリ：WHERE句内のサブクエリ」について学び、クエリの中に別のクエリを埋め込む高度なテクニックを習得していきます。



---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [1. SELECT基本：単一テーブルから特定カラムを取得する](#1-select基本単一テーブルから特定カラムを取得する)
2. [2. WHERE句：条件に合ったレコードを絞り込む](#2-where句条件に合ったレコードを絞り込む)
3. [3. 論理演算子：AND、OR、NOTを使った複合条件](#3-論理演算子andornotを使った複合条件)
4. [4. パターンマッチング：LIKE演算子と%、_ワイルドカード](#4-パターンマッチングlike演算子と_ワイルドカード)
5. [5. 範囲指定：BETWEEN、IN演算子](#5-範囲指定betweenin演算子)
6. [6. NULL値の処理：IS NULL、IS NOT NULL](#6-null値の処理is-nullis-not-null)
7. [7. ORDER BY：結果の並び替え](#7-order-by結果の並び替え)
8. [8. LIMIT句：結果件数の制限とページネーション](#8-limit句結果件数の制限とページネーション)

---


# 1. SELECT基本：単一テーブルから特定カラムを取得する

## はじめに

データベースからデータを取り出す作業は、料理人が大きな冷蔵庫から必要な材料だけを取り出すようなものです。SQLでは、この「取り出す」作業を「SELECT文」で行います。

SELECT文はSQLの中で最も基本的で、最もよく使われる命令です。この章では、単一のテーブル（データの表）から必要な情報だけを取り出す方法を学びます。

## 基本構文

SELECT文の最も基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名;
```

この文は「テーブル名というテーブルからカラム名という列のデータを取り出してください」という意味です。

> **用語解説**：
> - **SELECT**：「選択する」という意味のSQLコマンドで、データを取り出すときに使います。
> - **カラム**：テーブルの縦の列のことで、同じ種類のデータが並んでいます（例：名前のカラム、年齢のカラムなど）。
> - **FROM**：「〜から」という意味で、どのテーブルからデータを取るかを指定します。
> - **テーブル**：データベース内の表のことで、行と列で構成されています。

## 実践例：単一カラムの取得

学校データベースの中の「teachers」テーブル（教師テーブル）から、教師の名前だけを取得してみましょう。

```sql
SELECT teacher_name FROM teachers;
```

実行結果：

| teacher_name |
|--------------|
| 寺内鞍       |
| 田尻朋美     |
| 内村海凪     |
| 藤本理恵     |
| 黒木大介     |
| 星野涼子     |
| 深山誠一     |
| 吉岡由佳     |
| 山田太郎     |
| 佐藤花子     |
| ...          |

これは「teachers」テーブルの「teacher_name」という列（先生の名前）だけを取り出しています。

## 複数のカラムを取得する

料理に複数の材料が必要なように、データを取り出すときも複数の列が必要なことがよくあります。複数のカラムを取得するには、カラム名をカンマ（,）で区切って指定します。

```sql
SELECT カラム名1, カラム名2, カラム名3 FROM テーブル名;
```

例えば、教師の番号（ID）と名前を一緒に取得してみましょう：

```sql
SELECT teacher_id, teacher_name FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| 104        | 藤本理恵     |
| 105        | 黒木大介     |
| 106        | 星野涼子     |
| ...        | ...          |

## すべてのカラムを取得する

テーブルのすべての列を取得したい場合は、アスタリスク（*）を使います。これは「すべての列」を意味するワイルドカードです。

```sql
SELECT * FROM テーブル名;
```

例：
```sql
SELECT * FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| ...        | ...          |

> **注意**：`SELECT *`は便利ですが、実際の業務では必要なカラムだけを指定する方が良いとされています。これは、データ量が多いときに処理速度が遅くなるのを防ぐためです。

## カラムに別名をつける（AS句）

取得したカラムに分かりやすい名前（別名）をつけることができます。これは「AS」句を使います。

```sql
SELECT カラム名 AS 別名 FROM テーブル名;
```

> **用語解説**：
> - **AS**：「〜として」という意味で、カラムに別名をつけるときに使います。この別名は結果を表示するときだけ使われます。

例えば、教師IDを「番号」、教師名を「名前」として表示してみましょう：

```sql
SELECT teacher_id AS 番号, teacher_name AS 名前 FROM teachers;
```

実行結果：

| 番号  | 名前       |
|------|------------|
| 101  | 寺内鞍     |
| 102  | 田尻朋美   |
| 103  | 内村海凪   |
| ...  | ...        |

ASは省略することも可能です：

```sql
SELECT teacher_id 番号, teacher_name 名前 FROM teachers;
```

## 計算式を使う

SELECT文では、カラムの値を使った計算もできます。例えば、成績テーブルから点数と満点を取得して、達成率（パーセント）を計算してみましょう。

```sql
SELECT student_id, course_id, grade_type, 
       score, max_score,
       (score / max_score) * 100 AS 達成率
FROM grades;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 301        | 1         | 中間テスト   | 85.5  | 100.0     | 85.5     |
| 302        | 1         | 中間テスト   | 92.0  | 100.0     | 92.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

## 重複を除外する（DISTINCT）

同じ値が複数ある場合に、重複を除いて一意の値だけを表示するには「DISTINCT」キーワードを使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別された」という意味で、重複する値を除外して一意の値だけを取得します。

例えば、どの講座にどの教師が担当しているかを重複なしで確認してみましょう：

```sql
SELECT DISTINCT teacher_id FROM courses;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

これにより、courses（講座）テーブルで使われている教師IDが重複なく表示されます。

## 文字列の結合

文字列を結合するには、MySQLでは「CONCAT」関数を使います。例えば、教師のIDと名前を組み合わせて表示してみましょう：

```sql
SELECT CONCAT('教師ID:', teacher_id, ' 名前:', teacher_name) AS 教師情報
FROM teachers;
```

実行結果：

| 教師情報                  |
|--------------------------|
| 教師ID:101 名前:寺内鞍   |
| 教師ID:102 名前:田尻朋美 |
| ...                      |

> **用語解説**：
> - **CONCAT**：複数の文字列を一つにつなげる関数です。

## SELECT文と終了記号

SQLの文は通常、セミコロン（;）で終わります。これは「この命令はここで終わりです」という合図です。

複数のSQL文を一度に実行する場合は、それぞれの文の最後にセミコロンをつけます。

## 練習問題

### 問題1-1
students（学生）テーブルから、すべての学生の名前（student_name）を取得するSQLを書いてください。

### 問題1-2
classrooms（教室）テーブルから、教室ID（classroom_id）と教室名（classroom_name）を取得するSQLを書いてください。

### 問題1-3
courses（講座）テーブルから、すべての列（カラム）を取得するSQLを書いてください。

### 問題1-4
class_periods（授業時間）テーブルから、時限ID（period_id）、開始時間（start_time）、終了時間（end_time）を取得し、開始時間には「開始」、終了時間には「終了」という別名をつけるSQLを書いてください。

### 問題1-5
grades（成績）テーブルから、学生ID（student_id）、講座ID（course_id）、評価タイプ（grade_type）、得点（score）、満点（max_score）、そして得点を満点で割って100を掛けた値を「パーセント」という別名で取得するSQLを書いてください。

### 問題1-6
course_schedule（授業カレンダー）テーブルから、schedule_date（予定日）カラムだけを重複なしで取得するSQLを書いてください。

## 解答

### 解答1-1
```sql
SELECT student_name FROM students;
```

### 解答1-2
```sql
SELECT classroom_id, classroom_name FROM classrooms;
```

### 解答1-3
```sql
SELECT * FROM courses;
```

### 解答1-4
```sql
SELECT period_id, start_time AS 開始, end_time AS 終了 FROM class_periods;
```

### 解答1-5
```sql
SELECT student_id, course_id, grade_type, score, max_score,
       (score / max_score) * 100 AS パーセント
FROM grades;
```

### 解答1-6
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

## まとめ

この章では、SQLのSELECT文の基本を学びました：

1. 単一カラムの取得: `SELECT カラム名 FROM テーブル名;`
2. 複数カラムの取得: `SELECT カラム名1, カラム名2 FROM テーブル名;`
3. すべてのカラムの取得: `SELECT * FROM テーブル名;`
4. カラムに別名をつける: `SELECT カラム名 AS 別名 FROM テーブル名;`
5. 計算式を使う: `SELECT カラム名, (計算式) AS 別名 FROM テーブル名;`
6. 重複を除外する: `SELECT DISTINCT カラム名 FROM テーブル名;`
7. 文字列の結合: `SELECT CONCAT(文字列1, カラム名, 文字列2) FROM テーブル名;`

これらの基本操作を使いこなせるようになれば、データベースから必要な情報を効率よく取り出せるようになります。次の章では、WHERE句を使って条件に合ったデータだけを取り出す方法を学びます。



---

# 2. WHERE句：条件に合ったレコードを絞り込む

## はじめに

前章では、テーブルからデータを取得する基本的な方法を学びました。しかし実際の業務では、すべてのデータではなく、特定の条件に合ったデータだけを取得したいことがほとんどです。

例えば、「全生徒の情報」ではなく「特定の学科の生徒だけ」や「成績が80点以上の学生だけ」といった形で、データを絞り込みたい場合があります。

このような場合に使用するのが「WHERE句」です。WHERE句は、SELECTコマンドの後に追加して使い、条件に合致するレコード（行）だけを取得します。

## 基本構文

WHERE句の基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件式;
```

> **用語解説**：
> - **WHERE**：「〜の場所で」「〜の条件で」という意味のSQLコマンドで、条件に合うデータだけを抽出するために使います。
> - **条件式**：データが満たすべき条件を指定するための式です。例えば「age > 20」（年齢が20より大きい）などです。
> - **レコード**：テーブルの横の行のことで、1つのデータの集まりを表します。

## 基本的な比較演算子

WHERE句では、様々な比較演算子を使って条件を指定できます：

| 演算子 | 意味                   | 例                    |
|--------|------------------------|------------------------|
| =      | 等しい                 | age = 25               |
| <>     | 等しくない（≠と同じ）  | gender <> 'male'       |
| >      | より大きい             | score > 80             |
| <      | より小さい             | price < 1000           |
| >=     | 以上                   | height >= 170          |
| <=     | 以下                   | weight <= 70           |

## 実践例：基本的な条件での絞り込み

### 例1：等しい（=）
例えば、教師ID（teacher_id）が101の教師のみを取得するには：

```sql
SELECT * FROM teachers WHERE teacher_id = 101;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |

### 例2：より大きい（>）
成績（grades）テーブルから、90点を超える成績だけを取得するには：

```sql
SELECT * FROM grades WHERE score > 90;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例3：等しくない（<>）
講座IDが3ではない講座に関する成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id <> '3';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト  | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 301        | 2         | 実技試験    | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 文字列の比較

テキスト（文字列）を条件にする場合は、シングルクォーテーション（'）またはダブルクォーテーション（"）で囲みます。MySQLではどちらも使えますが、多くの場合シングルクォーテーションが推奨されます。

```sql
SELECT * FROM テーブル名 WHERE テキストカラム = 'テキスト値';
```

例えば、教師名（teacher_name）が「田尻朋美」の教師を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name = '田尻朋美';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |

## 日付の比較

日付の比較も同様にシングルクォーテーションで囲みます。日付の形式はデータベースの設定によって異なりますが、一般的にはISO形式（YYYY-MM-DD）が使われます。

```sql
SELECT * FROM テーブル名 WHERE 日付カラム = '日付';
```

例えば、2025年5月20日に提出された成績を検索するには：

```sql
SELECT * FROM grades WHERE submission_date = '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

また、日付同士の大小関係も比較できます：

```sql
SELECT * FROM grades WHERE submission_date < '2025-05-15';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | レポート1   | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1   | 48.0  | 50.0      | 2025-05-10      |
| 304        | 5         | ER図作成課題 | 27.5  | 30.0      | 2025-05-14      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 複数の条件を指定する（次章の内容）

WHERE句では、複数の条件を組み合わせることもできます。この詳細は次章「論理演算子：AND、OR、NOTを使った複合条件」で説明します。

例えば、講座IDが1で、かつ、得点が90以上の成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id = '1' AND score >= 90;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題2-1
students（学生）テーブルから、学生ID（student_id）が「310」の学生情報を取得するSQLを書いてください。

### 問題2-2
classrooms（教室）テーブルから、収容人数（capacity）が30人より多い教室の情報をすべて取得するSQLを書いてください。

### 問題2-3
courses（講座）テーブルから、教師ID（teacher_id）が「105」の講座情報を取得するSQLを書いてください。

### 問題2-4
course_schedule（授業カレンダー）テーブルから、「2025-05-15」の授業スケジュールをすべて取得するSQLを書いてください。

### 問題2-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」で、得点（score）が80点未満の成績を取得するSQLを書いてください。

### 問題2-6
teachers（教師）テーブルから、教師ID（teacher_id）が「101」ではない教師の名前を取得するSQLを書いてください。

## 解答

### 解答2-1
```sql
SELECT * FROM students WHERE student_id = 310;
```

### 解答2-2
```sql
SELECT * FROM classrooms WHERE capacity > 30;
```

### 解答2-3
```sql
SELECT * FROM courses WHERE teacher_id = 105;
```

### 解答2-4
```sql
SELECT * FROM course_schedule WHERE schedule_date = '2025-05-15';
```

### 解答2-5
```sql
SELECT * FROM grades WHERE grade_type = '中間テスト' AND score < 80;
```

### 解答2-6
```sql
SELECT teacher_name FROM teachers WHERE teacher_id <> 101;
```

## まとめ

この章では、WHERE句を使って条件に合ったレコードを取得する方法を学びました：

1. 基本的な比較演算子（=, <>, >, <, >=, <=）の使い方
2. 数値による条件絞り込み
3. 文字列（テキスト）による条件絞り込み
4. 日付による条件絞り込み

WHERE句は、大量のデータから必要な情報だけを取り出すための非常に重要な機能です。実際のデータベース操作では、この条件絞り込みを頻繁に使います。

次の章では、複数の条件を組み合わせるための「論理演算子（AND、OR、NOT）」について学びます。



---

# 3. 論理演算子：AND、OR、NOTを使った複合条件

## はじめに

前章では、WHERE句を使って単一の条件でデータを絞り込む方法を学びました。しかし実際の業務では、より複雑な条件でデータを絞り込む必要があることがよくあります。

例えば：
- 「成績が80点以上**かつ**出席率が90%以上の学生」
- 「数学**または**英語の成績が優秀な学生」
- 「課題を**まだ提出していない**学生」

このような複合条件を指定するために使うのが論理演算子です。主な論理演算子は次の3つです：

- **AND**：両方の条件を満たす（かつ）
- **OR**：いずれかの条件を満たす（または）
- **NOT**：条件を満たさない（〜ではない）

## AND演算子

AND演算子は、指定した**すべての条件を満たす**レコードだけを取得したいときに使います。

> **用語解説**：
> - **AND**：「かつ」「そして」という意味の論理演算子です。複数の条件をすべて満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 AND 条件2;
```

### 例：ANDを使った複合条件

例えば、中間テストで90点以上かつ満点が100点の成績レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

この例では、「score >= 90」と「max_score = 100」の両方の条件を満たすレコードだけが取得されます。

### 3つ以上の条件の組み合わせ

ANDを使って3つ以上の条件を組み合わせることもできます：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100 AND grade_type = '中間テスト';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## OR演算子

OR演算子は、指定した条件の**いずれか一つでも満たす**レコードを取得したいときに使います。

> **用語解説**：
> - **OR**：「または」「もしくは」という意味の論理演算子です。複数の条件のうち少なくとも1つを満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 OR 条件2;
```

### 例：ORを使った複合条件

例えば、教師IDが101または102の講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id = 101 OR teacher_id = 102;
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 2         | UNIX入門             | 102        |
| 3         | Cプログラミング演習    | 101        |
| 29        | コードリファクタリングとクリーンコード | 101 |
| 40        | ソフトウェアアーキテクチャパターン | 102 |
| ...       | ...                  | ...        |

この例では、「teacher_id = 101」または「teacher_id = 102」のいずれかの条件を満たすレコードが取得されます。

## NOT演算子

NOT演算子は、指定した条件を**満たさない**レコードを取得したいときに使います。

> **用語解説**：
> - **NOT**：「〜ではない」という意味の論理演算子です。条件を否定して、その条件を満たさないデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE NOT 条件;
```

### 例：NOTを使った否定条件

例えば、完了（completed）状態ではない授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
WHERE NOT status = 'completed';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 45          | 11        | 2025-05-20    | 5         | 401G         | 106        | scheduled |
| 46          | 12        | 2025-05-21    | 1         | 301E         | 107        | scheduled |
| 50          | 2         | 2025-05-23    | 3         | 101A         | 102        | cancelled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

この例では、statusが「completed」ではないレコード（scheduled状態やcancelled状態）が取得されます。

NOT演算子は、「〜ではない」という否定の条件を作るために使われます。例えば次の2つの書き方は同じ意味になります：

```sql
SELECT * FROM teachers WHERE NOT teacher_id = 101;
SELECT * FROM teachers WHERE teacher_id <> 101;
```

## 複合論理条件（AND、OR、NOTの組み合わせ）

AND、OR、NOTを組み合わせて、より複雑な条件を指定することもできます。

### 例：ANDとORの組み合わせ

例えば、「成績が90点以上で中間テストである」または「成績が45点以上でレポートである」レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE (score >= 90 AND grade_type = '中間テスト') 
   OR (score >= 45 AND grade_type = 'レポート1');
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 308        | 1         | レポート1  | 47.0  | 50.0      | 2025-05-09      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 優先順位と括弧の使用

論理演算子を組み合わせる場合、演算子の優先順位に注意が必要です。基本的に**ANDはORよりも優先順位が高い**です。つまり、ANDが先に処理されます。

例えば：
```sql
WHERE 条件1 OR 条件2 AND 条件3
```

これは次のように解釈されます：
```sql
WHERE 条件1 OR (条件2 AND 条件3)
```

意図した条件と異なる場合は、**括弧（）を使って明示的にグループ化**することが重要です：
```sql
WHERE (条件1 OR 条件2) AND 条件3
```

### 例：括弧を使った条件のグループ化

教師IDが101または102で、かつ、講座名に「プログラミング」という単語が含まれる講座を取得するには：

```sql
SELECT * FROM courses 
WHERE (teacher_id = 101 OR teacher_id = 102) 
  AND course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

この例では、括弧を使って「teacher_id = 101 OR teacher_id = 102」の部分をグループ化し、その条件と「course_name LIKE '%プログラミング%'」の条件をANDで結合しています。

## 練習問題

### 問題3-1
grades（成績）テーブルから、課題タイプ（grade_type）が「中間テスト」かつ点数（score）が85点以上のレコードを取得するSQLを書いてください。

### 問題3-2
classrooms（教室）テーブルから、収容人数（capacity）が40人以下または建物（building）が「1号館」の教室を取得するSQLを書いてください。

### 問題3-3
teachers（教師）テーブルから、教師ID（teacher_id）が101、102、103ではない教師の情報を取得するSQLを書いてください。

### 問題3-4
course_schedule（授業カレンダー）テーブルから、2025年5月20日の授業で、時限（period_id）が1か2で、かつ状態（status）が「scheduled」の授業を取得するSQLを書いてください。

### 問題3-5
students（学生）テーブルから、学生名（student_name）に「田」または「山」を含む学生を取得するSQLを書いてください。

### 問題3-6
grades（成績）テーブルから、提出日（submission_date）が2025年5月15日以降で、かつ（「中間テスト」で90点以上または「レポート1」で45点以上）の成績を取得するSQLを書いてください。

## 解答

### 解答3-1
```sql
SELECT * FROM grades 
WHERE grade_type = '中間テスト' AND score >= 85;
```

### 解答3-2
```sql
SELECT * FROM classrooms 
WHERE capacity <= 40 OR building = '1号館';
```

### 解答3-3
```sql
SELECT * FROM teachers 
WHERE NOT (teacher_id = 101 OR teacher_id = 102 OR teacher_id = 103);
```
または
```sql
SELECT * FROM teachers 
WHERE teacher_id <> 101 AND teacher_id <> 102 AND teacher_id <> 103;
```

### 解答3-4
```sql
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-20' 
  AND (period_id = 1 OR period_id = 2) 
  AND status = 'scheduled';
```

### 解答3-5
```sql
SELECT * FROM students 
WHERE student_name LIKE '%田%' OR student_name LIKE '%山%';
```

### 解答3-6
```sql
SELECT * FROM grades 
WHERE submission_date >= '2025-05-15' 
  AND ((grade_type = '中間テスト' AND score >= 90) 
       OR (grade_type = 'レポート1' AND score >= 45));
```

## まとめ

この章では、論理演算子（AND、OR、NOT）を使って複合条件を作る方法を学びました：

1. **AND**：すべての条件を満たすレコードを取得（条件1 AND 条件2）
2. **OR**：いずれかの条件を満たすレコードを取得（条件1 OR 条件2）
3. **NOT**：指定した条件を満たさないレコードを取得（NOT 条件）
4. **複合条件**：AND、OR、NOTを組み合わせたより複雑な条件
5. **括弧（）**：条件をグループ化して優先順位を明示的に指定

これらの論理演算子を使いこなすことで、より複雑で細かな条件でデータを絞り込むことができるようになります。実際のデータベース操作では、複数の条件を組み合わせることが頻繁にあるため、この章で学んだ内容は非常に重要です。

次の章では、テキストデータに対する検索を行う「パターンマッチング」について学びます。



---

# 4. パターンマッチング：LIKE演算子と%、_ワイルドカード

## はじめに

前章までは、データの完全一致や数値の比較といった条件での絞り込みを学びました。しかし実際の業務では、もっと柔軟な検索が必要なケースがあります。例えば：

- 「山」で始まる名前の学生を検索したい
- 「プログラミング」という単語を含む講座名を探したい
- 電話番号の一部だけ覚えているデータを探したい

このような「部分一致」や「パターン一致」の検索を行うためのSQLの機能が「パターンマッチング」です。この章では、パターンマッチングを行うための「LIKE演算子」と「ワイルドカード文字」について学びます。

## LIKE演算子の基本

LIKE演算子は、文字列のパターンマッチングを行うための演算子です。WHERE句と組み合わせて使用します。

> **用語解説**：
> - **LIKE**：「〜のような」という意味の演算子で、パターンに一致する文字列を検索します。
> - **パターンマッチング**：完全一致ではなく、一定のパターンに合致するデータを検索する方法です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 文字列カラム LIKE 'パターン';
```

パターンには、通常の文字に加えて、特別な意味を持つ「ワイルドカード文字」を使用できます。

## ワイルドカード文字

SQLでは主に2つのワイルドカード文字があります：

1. **%（パーセント）**：0文字以上の任意の文字列に一致します。
2. **_（アンダースコア）**：任意の1文字に一致します。

> **用語解説**：
> - **ワイルドカード**：任意の文字や文字列に一致する特殊な文字記号です。トランプのジョーカーのように、様々な値に代用できます。

## LIKE演算子の使い方：実践例

### 例1：%（パーセント）を使ったパターンマッチング

#### 「〜で始まる」パターン：前方一致

例えば、「山」で始まる学生名を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '山%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 山本裕子     |
| 325        | 山田翔太     |
| ...        | ...          |

ここでの「山%」は「山で始まり、その後に0文字以上の任意の文字が続く」という意味です。

#### 「〜で終わる」パターン：後方一致

例えば、「子」で終わる教師名を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name LIKE '%子';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| 106        | 星野涼子     |
| 108        | 吉岡由佳     |
| 110        | 佐藤花子     |
| ...        | ...          |

#### 「〜を含む」パターン：部分一致

例えば、「プログラミング」という単語を含む講座名を検索するには：

```sql
SELECT * FROM courses WHERE course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| 14        | IoTデバイスプログラミング実践 | 110 |
| ...       | ...                  | ...        |

### 例2：_（アンダースコア）を使ったパターンマッチング

アンダースコアは任意の1文字に一致します。例えば、教室IDが「10_A」パターン（最初の2文字が「10」、3文字目が任意の1文字、最後が「A」）の教室を検索するには：

```sql
SELECT * FROM classrooms WHERE classroom_id LIKE '10_A';
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| ...          | ...            | ...      | ...      | ...        |

### 例3：%と_の組み合わせ

ワイルドカード文字は組み合わせて使うこともできます。例えば、「2文字目が田」の学生を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '_田%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 384        | 櫻井翼       |
| ...        | ...          |

## NOT LIKEを使った否定形のパターンマッチング

特定のパターンに一致しないレコードを検索したい場合は、「NOT LIKE」を使います。

> **用語解説**：
> - **NOT LIKE**：「〜のパターンに一致しない」という意味で、指定したパターンに一致しないデータを検索します。

例えば、講座名に「入門」を含まない講座を検索するには：

```sql
SELECT * FROM courses WHERE course_name NOT LIKE '%入門%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

## エスケープ文字の使用

もし検索したいパターンに「%」や「_」自体が含まれている場合は、それらを特別な文字としてではなく、通常の文字として扱うために「エスケープ文字」を使います。

> **用語解説**：
> - **エスケープ文字**：特別な意味を持つ文字を通常の文字として扱うための印です。

MySQLでは、バックスラッシュ（\）をエスケープ文字として使用できます。例えば、「50%」という値そのものを検索するには：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50\%';
```

または、ESCAPE句を使って明示的にエスケープ文字を指定することもできます：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50!%' ESCAPE '!';
```

この例では「!」をエスケープ文字として指定しています。

## 大文字と小文字の区別

MySQLのデフォルト設定では、LIKE演算子は大文字と小文字を区別しません（大文字小文字を同じものとして扱います）。

例えば、次の2つのクエリは同じ結果を返します：

```sql
SELECT * FROM courses WHERE course_name LIKE '%web%';
SELECT * FROM courses WHERE course_name LIKE '%Web%';
```

もし大文字と小文字を区別した検索が必要な場合は、「BINARY」キーワードを使用します：

```sql
SELECT * FROM courses WHERE course_name LIKE BINARY '%Web%';
```

この場合、「Web」は「web」とは一致しません。

## 複合条件との組み合わせ

LIKE演算子は、これまで学んだAND、OR、NOTなどの論理演算子と組み合わせて使うこともできます。

例えば、「田」で始まる名前で、かつ教師IDが102から105の間の教師を検索するには：

```sql
SELECT * FROM teachers 
WHERE teacher_name LIKE '田%' 
  AND teacher_id BETWEEN 102 AND 105;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| ...        | ...          |

## 練習問題

### 問題4-1
students（学生）テーブルから、学生名（student_name）が「佐藤」で始まる学生の情報をすべて取得するSQLを書いてください。

### 問題4-2
courses（講座）テーブルから、講座名（course_name）に「データ」という単語を含む講座の情報を取得するSQLを書いてください。

### 問題4-3
classrooms（教室）テーブルから、教室名（classroom_name）が「コンピュータ実習室」で終わる教室の情報を取得するSQLを書いてください。

### 問題4-4
teachers（教師）テーブルから、教師名（teacher_name）の2文字目が「木」である教師の情報を取得するSQLを書いてください。

### 問題4-5
courses（講座）テーブルから、講座名（course_name）に「入門」または「基礎」を含む講座を取得するSQLを書いてください。

### 問題4-6
students（学生）テーブルから、学生名（student_name）が「山」で始まり、かつ「子」で終わらない学生を取得するSQLを書いてください。

## 解答

### 解答4-1
```sql
SELECT * FROM students WHERE student_name LIKE '佐藤%';
```

### 解答4-2
```sql
SELECT * FROM courses WHERE course_name LIKE '%データ%';
```

### 解答4-3
```sql
SELECT * FROM classrooms WHERE classroom_name LIKE '%コンピュータ実習室';
```

### 解答4-4
```sql
SELECT * FROM teachers WHERE teacher_name LIKE '_木%';
```

### 解答4-5
```sql
SELECT * FROM courses 
WHERE course_name LIKE '%入門%' OR course_name LIKE '%基礎%';
```

### 解答4-6
```sql
SELECT * FROM students 
WHERE student_name LIKE '山%' AND student_name NOT LIKE '%子';
```

## まとめ

この章では、パターンマッチングを行うためのLIKE演算子と、その中で使用するワイルドカード文字（%と_）について学びました：

1. **LIKE演算子**：文字列パターンに一致するデータを検索するための演算子
2. **%（パーセント）**：0文字以上の任意の文字列に一致するワイルドカード
3. **_（アンダースコア）**：任意の1文字に一致するワイルドカード
4. **前方一致**：「パターン%」で「パターンで始まる」文字列に一致
5. **後方一致**：「%パターン」で「パターンで終わる」文字列に一致
6. **部分一致**：「%パターン%」で「パターンを含む」文字列に一致
7. **NOT LIKE**：指定したパターンに一致しないデータを検索
8. **エスケープ文字**：特殊文字（%や_）を通常の文字として扱うための方法
9. **複合条件との組み合わせ**：AND、ORなどと組み合わせたより複雑な条件

パターンマッチングは、特にテキストデータを扱う際に非常に便利な機能です。部分的な情報しか持っていない場合や、特定のパターンを持つデータを探す場合に活用できます。

次の章では、範囲指定のための「BETWEEN演算子」と「IN演算子」について学びます。



---

# 5. 範囲指定：BETWEEN、IN演算子

## はじめに

これまでの章では、等号（=）や不等号（>、<）を使って条件を指定する方法や、LIKE演算子を使ったパターンマッチングを学びました。この章では、値の範囲を指定する「BETWEEN演算子」と、複数の値を一度に指定できる「IN演算子」について学びます。

これらの演算子を使うと、次のような検索がより簡単になります：
- 「80点から90点の間の成績」
- 「2025年4月から6月の間のスケジュール」
- 「特定の教師IDリストに該当する講座」

## BETWEEN演算子：範囲を指定する

BETWEEN演算子は、ある値が指定した範囲内にあるかどうかを調べるために使います。

> **用語解説**：
> - **BETWEEN**：「〜の間に」という意味の演算子で、ある値が指定した最小値と最大値の間（両端の値を含む）にあるかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 BETWEEN 最小値 AND 最大値;
```

この構文は次の条件と同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 >= 最小値 AND カラム名 <= 最大値;
```

### 例1：数値範囲の指定

例えば、成績（grades）テーブルから、80点から90点の間の成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 308        | 6         | 小テスト1  | 89.0  | 100.0     | 2025-05-15      |
| ...        | ...       | ...        | ...   | ...       | ...             |

### 例2：日付範囲の指定

日付にもBETWEEN演算子が使えます。例えば、2025年5月10日から2025年5月20日までに提出された成績を取得するには：

```sql
SELECT * FROM grades 
WHERE submission_date BETWEEN '2025-05-10' AND '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | レポート1  | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## NOT BETWEEN：範囲外を指定する

NOT BETWEENを使うと、指定した範囲の外にある値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT BETWEEN 最小値 AND 最大値;
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 < 最小値 OR カラム名 > 最大値;
```

### 例：範囲外の値を取得

例えば、80点未満または90点より高い成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score NOT BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## IN演算子：複数の値を指定する

IN演算子は、ある値が指定した複数の値のリストのいずれかに一致するかどうかを調べるために使います。

> **用語解説**：
> - **IN**：「〜の中に含まれる」という意味の演算子で、ある値が指定したリストの中に含まれているかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (値1, 値2, 値3, ...);
```

この構文は次のOR条件の組み合わせと同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 = 値1 OR カラム名 = 値2 OR カラム名 = 値3 OR ...;
```

### 例1：数値リストの指定

例えば、教師ID（teacher_id）が101、103、105のいずれかである講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (101, 103, 105);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| 5         | データベース設計と実装  | 105        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

### 例2：文字列リストの指定

文字列のリストにも適用できます。例えば、特定の教室ID（classroom_id）のみの教室情報を取得するには：

```sql
SELECT * FROM classrooms 
WHERE classroom_id IN ('101A', '202D', '301E');
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| 202D         | 2号館コンピュータ実習室D | 25     | 2号館     | パソコン25台、プロジェクター、3Dプリンター |
| 301E         | 3号館講義室E      | 80       | 3号館     | プロジェクター、マイク設備、録画設備 |

## NOT IN：リストに含まれない値を指定する

NOT IN演算子を使うと、指定したリストに含まれない値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT IN (値1, 値2, 値3, ...);
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 <> 値1 AND カラム名 <> 値2 AND カラム名 <> 値3 AND ...;
```

### 例：リストに含まれない値を取得

例えば、教師IDが101、102、103以外の教師が担当する講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id NOT IN (101, 102, 103);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 4         | Webアプリケーション開発 | 104        |
| 5         | データベース設計と実装  | 105        |
| 6         | ネットワークセキュリティ | 107        |
| ...       | ...                  | ...        |

## IN演算子でのサブクエリの利用（基本）

IN演算子の括弧内には、直接値を書く代わりに、サブクエリ（別のSELECT文）を指定することもできます。これにより、動的に値のリストを生成できます。

> **用語解説**：
> - **サブクエリ**：SQL文の中に含まれる別のSQL文のことで、外側のSQL文（メインクエリ）に値や条件を提供します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (SELECT カラム名 FROM 別テーブル WHERE 条件);
```

### 例：サブクエリを使ったIN条件

例えば、教師名（teacher_name）に「田」を含む教師が担当している講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (
    SELECT teacher_id FROM teachers 
    WHERE teacher_name LIKE '%田%'
);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 2         | UNIX入門             | 102        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

この例では、まず「teachers」テーブルから名前に「田」を含む教師のIDを取得し、それらのIDを持つ講座を「courses」テーブルから取得しています。

## BETWEEN演算子とIN演算子の組み合わせ

BETWEEN演算子とIN演算子は、論理演算子（AND、OR）と組み合わせて、さらに複雑な条件を作ることができます。

### 例：BETWEENとINの組み合わせ

例えば、「教師IDが101、103、105のいずれかで、かつ、2025年5月15日から2025年6月15日の間に実施される授業」を取得するには：

```sql
SELECT * FROM course_schedule 
WHERE teacher_id IN (101, 103, 105) 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-06-15';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 38          | 1         | 2025-05-20    | 1         | 102B         | 101        | scheduled |
| 42          | 10        | 2025-05-23    | 3         | 201C         | 103        | scheduled |
| 45          | 5         | 2025-05-28    | 2         | 402H         | 105        | scheduled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

## 練習問題

### 問題5-1
grades（成績）テーブルから、得点（score）が85点から95点の間にある成績を取得するSQLを書いてください。

### 問題5-2
course_schedule（授業カレンダー）テーブルから、2025年5月1日から2025年5月31日までの授業スケジュールを取得するSQLを書いてください。

### 問題5-3
courses（講座）テーブルから、教師ID（teacher_id）が104、106、108のいずれかである講座の情報を取得するSQLを書いてください。

### 問題5-4
classrooms（教室）テーブルから、教室ID（classroom_id）が「101A」、「201C」、「301E」、「401G」以外の教室情報を取得するSQLを書いてください。

### 問題5-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」または「実技試験」で、かつ得点（score）が80点から90点の間にない成績を取得するSQLを書いてください。

### 問題5-6
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）が「101A」、「202D」のいずれかで、かつ2025年5月15日から2025年5月30日の間に実施される授業スケジュールを取得するSQLを書いてください。

## 解答

### 解答5-1
```sql
SELECT * FROM grades 
WHERE score BETWEEN 85 AND 95;
```

### 解答5-2
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

### 解答5-3
```sql
SELECT * FROM courses 
WHERE teacher_id IN (104, 106, 108);
```

### 解答5-4
```sql
SELECT * FROM classrooms 
WHERE classroom_id NOT IN ('101A', '201C', '301E', '401G');
```

### 解答5-5
```sql
SELECT * FROM grades 
WHERE grade_type IN ('中間テスト', '実技試験') 
  AND score NOT BETWEEN 80 AND 90;
```

### 解答5-6
```sql
SELECT * FROM course_schedule 
WHERE classroom_id IN ('101A', '202D') 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-05-30';
```

## まとめ

この章では、範囲指定のための「BETWEEN演算子」と複数値指定のための「IN演算子」について学びました：

1. **BETWEEN演算子**：値が指定した範囲内（両端を含む）にあるかどうかをチェック
2. **NOT BETWEEN**：値が指定した範囲外にあるかどうかをチェック
3. **IN演算子**：値が指定したリストのいずれかに一致するかどうかをチェック
4. **NOT IN**：値が指定したリストのいずれにも一致しないかどうかをチェック
5. **サブクエリとIN**：動的に生成された値のリストを使用する方法
6. **複合条件**：BETWEEN、IN、論理演算子を組み合わせたより複雑な条件

これらの演算子を使うことで、複数の条件を指定する場合に、SQLをより簡潔に書くことができます。特に、多くの値を指定する場合や範囲条件を指定する場合に便利です。

次の章では、「NULL値の処理：IS NULL、IS NOT NULL」について学びます。



---

# 6. NULL値の処理：IS NULL、IS NOT NULL

## はじめに

データベースの世界では、データがない状態を表すために「NULL」という特別な値が使われます。NULLは「空」や「0」や「空白文字」とは異なる、「値が存在しない」または「不明」であることを表す特殊な概念です。

例えば、学校データベースでは次のようなシナリオがあります：
- まだ成績が付けられていない（NULL）
- コメントが入力されていない（NULL）
- 授業がキャンセルされたため教室が割り当てられていない（NULL）

この章では、NULL値を正しく処理するための「IS NULL」と「IS NOT NULL」演算子について学びます。

## NULLとは何か？

NULL値には、いくつかの特徴があります：

1. **値がない**：NULLは値がないことを表します。0でも空文字列（''）でもなく、値そのものが存在しないことを示します。
2. **不明**：データが不明であることを表す場合もあります。
3. **未設定**：まだ値が設定されていないことを表す場合もあります。
4. **比較できない**：NULLは通常の比較演算子（=, <, >など）で比較できません。

> **用語解説**：
> - **NULL**：データベースにおいて「値がない」または「不明」を表す特殊な値です。0や空文字とは異なります。

## NULL値と通常の比較演算子

通常の比較演算子（=, <>, >, <, >=, <=）では、NULL値を正しく検出できません。例えば：

```sql
-- この条件はNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 = NULL;

-- この条件もNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 <> NULL;
```

これは、NULL値との等価比較は「不明」と評価されるためです。つまり、NULL = NULLでさえFALSEではなく「不明」になります。

## IS NULL演算子

NULL値を持つレコードを検索するには、「IS NULL」演算子を使います。

> **用語解説**：
> - **IS NULL**：カラムの値がNULLかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NULL;
```

### 例：IS NULLの使用

例えば、コメントが入力されていない（NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

実行結果：

| schedule_id | student_id | status  | comment |
|-------------|------------|---------|---------|
| 1           | 301        | present | NULL    |
| 1           | 306        | present | NULL    |
| 1           | 307        | present | NULL    |
| ...         | ...        | ...     | NULL    |

## IS NOT NULL演算子

逆に、NULL値を持たないレコード（つまり、何らかの値を持つレコード）を検索するには、「IS NOT NULL」演算子を使います。

> **用語解説**：
> - **IS NOT NULL**：カラムの値がNULLでないかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NOT NULL;
```

### 例：IS NOT NULLの使用

例えば、コメントが入力されている（NOT NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 302        | late   | 15分遅刻      |
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |

## NULL値の論理的な扱い

NULL値は論理演算（AND、OR、NOT）でも特殊な扱いを受けます。

- **NULL AND TRUE** → NULL（不明）
- **NULL AND FALSE** → FALSE
- **NULL OR TRUE** → TRUE
- **NULL OR FALSE** → NULL（不明）
- **NOT NULL** → NULL（不明）

この特殊な振る舞いが、バグや誤った結果の原因になることがあります。

## NULL値と結合条件

テーブル結合（JOINなど、後の章で学習）の際も、NULL値は特殊な扱いを受けます。NULL値同士は「等しい」とは判定されないため、通常の結合条件ではNULL値を持つレコードは結合されません。

## IS NULLとIS NOT NULLを使った複合条件

IS NULLとIS NOT NULLも、他の条件と組み合わせて使用できます。

### 例：複合条件でのIS NULLの使用

例えば、「出席状態が "absent"（欠席）で、コメントがNULLでない（理由が入力されている）レコード」を検索するには：

```sql
SELECT * FROM attendance 
WHERE status = 'absent' AND comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |

## NVL/IFNULL/COALESCE関数：NULL値の置換

NULL値を別の値に置き換えるための関数が用意されています。データベースによって関数名が異なることがありますが、機能は似ています：

- MySQL/MariaDB: **IFNULL(expr, replace_value)**
- Oracle: **NVL(expr, replace_value)**
- SQL Server: **ISNULL(expr, replace_value)**
- 標準SQL: **COALESCE(expr1, expr2, ..., exprN)** - 最初のNULLでない式を返します

### 例：IFNULL関数の使用（MySQL）

例えば、コメントがNULLの場合は「特記事項なし」と表示するには：

```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '特記事項なし') AS comment
FROM attendance;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | 特記事項なし  |
| 1           | 302        | late    | 15分遅刻      |
| 1           | 303        | absent  | 事前連絡あり  |
| ...         | ...        | ...     | ...           |

## NULLを使う際の注意点

1. **除外の罠**：`WHERE カラム名 <> 値` だけでは、NULL値を持つレコードは含まれません。すべてのレコードを対象にするには：
   ```sql
   WHERE カラム名 <> 値 OR カラム名 IS NULL
   ```

2. **集計関数**：COUNT(*)はすべての行を数えますが、COUNT(カラム名)はそのカラムがNULLでない行だけを数えます。

3. **インデックス**：多くのデータベースでは、NULL値にもインデックスを適用できますが、データベースによって動作が異なる場合があります。

4. **一意性制約**：一般的に、UNIQUE制約ではNULL値は重複としてカウントされません（複数のNULL値が許可されます）。

## 練習問題

### 問題6-1
attendance（出席）テーブルから、コメント（comment）がNULLの出席レコードをすべて取得するSQLを書いてください。

### 問題6-2
course_schedule（授業カレンダー）テーブルから、状態（status）が「cancelled」で、かつ教室ID（classroom_id）がNULLでないレコードを取得するSQLを書いてください。

### 問題6-3
grades（成績）テーブルから、提出日（submission_date）がNULLの成績レコードを取得するSQLを書いてください。

### 問題6-4
attendance（出席）テーブルから、出席状態（status）が「present」か「late」で、かつコメント（comment）がNULLのレコードを取得するSQLを書いてください。

### 問題6-5
以下のSQLで教師（teachers）テーブルから「佐藤」という名前を持つ教師を検索する場合、NULL値を持つレコードも含めるにはどう修正すべきですか？
```sql
SELECT * FROM teachers WHERE teacher_name <> '佐藤花子';
```

### 問題6-6
attendance（出席）テーブルのすべてのレコードを取得し、コメント（comment）がNULLの場合は「記録なし」と表示するSQLを書いてください。

## 解答

### 解答6-1
```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

### 解答6-2
```sql
SELECT * FROM course_schedule 
WHERE status = 'cancelled' AND classroom_id IS NOT NULL;
```

### 解答6-3
```sql
SELECT * FROM grades WHERE submission_date IS NULL;
```

### 解答6-4
```sql
SELECT * FROM attendance 
WHERE (status = 'present' OR status = 'late') AND comment IS NULL;
```
または
```sql
SELECT * FROM attendance 
WHERE status IN ('present', 'late') AND comment IS NULL;
```

### 解答6-5
```sql
SELECT * FROM teachers 
WHERE teacher_name <> '佐藤花子' OR teacher_name IS NULL;
```

### 解答6-6
```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '記録なし') AS comment
FROM attendance;
```

## まとめ

この章では、データベースにおけるNULL値の概念と、NULL値を扱うための演算子や関数について学びました：

1. **NULL値の概念**：値がない、不明、未設定を表す特殊な値
2. **IS NULL演算子**：NULL値を持つレコードを検索する方法
3. **IS NOT NULL演算子**：NULL値を持たないレコードを検索する方法
4. **NULL値の論理的扱い**：論理演算（AND、OR、NOT）におけるNULLの振る舞い
5. **複合条件**：IS NULL/IS NOT NULLと他の条件の組み合わせ
6. **NULL値の置換**：IFNULL/NVL/COALESCE関数の使用方法
7. **注意点**：NULL値を扱う際の一般的な落とし穴

NULL値の正確な理解と適切な処理は、SQLプログラミングの重要な部分です。不適切なNULL処理は、予期しない結果やバグの原因になります。

次の章では、クエリ結果の並び替えを行うための「ORDER BY：結果の並び替え」について学びます。



---

# 7. ORDER BY：結果の並び替え

## はじめに

これまでの章では、データベースから条件に合ったレコードを取得する方法を学んできました。しかし実際の業務では、取得したデータを見やすく整理する必要があります。例えば：

- 成績を高い順に表示したい
- 学生を名前の五十音順に並べたい
- 日付の新しい順にスケジュールを確認したい

このようなデータの「並び替え」を行うためのSQLコマンドが「ORDER BY」です。この章では、クエリ結果を特定の順序で並べる方法を学びます。

## ORDER BYの基本

ORDER BY句は、SELECT文の結果を指定したカラムの値に基づいて並び替えるために使います。

> **用語解説**：
> - **ORDER BY**：「〜の順に並べる」という意味のSQLコマンドで、クエリ結果の並び順を指定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] ORDER BY 並び替えカラム;
```

ORDER BY句は通常、SELECT文の最後に記述します。

### 例1：単一カラムでの並び替え

例えば、学生（students）テーブルから、学生名（student_name）の五十音順（辞書順）でデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_name;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 309        | 相沢吉夫      |
| 303        | 柴崎春花      |
| 306        | 河田咲奈      |
| 305        | 河口菜恵子    |
| ...        | ...          |

### デフォルトの並び順

ORDER BYを使わない場合、結果の順序は保証されません。多くの場合、データがデータベースに保存された順序で返されますが、これは信頼できるものではありません。

## 昇順と降順の指定

ORDER BY句では、並び順を「昇順」か「降順」のどちらかで指定できます。

> **用語解説**：
> - **昇順（ASC）**：小さい値から大きい値へ（A→Z、1→9）の順に並べます。
> - **降順（DESC）**：大きい値から小さい値へ（Z→A、9→1）の順に並べます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 ORDER BY 並び替えカラム [ASC|DESC];
```

ASC（昇順）がデフォルトのため、省略可能です。

### 例2：降順での並び替え

例えば、成績（grades）テーブルから、得点（score）の高い順（降順）に成績を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 複数カラムでの並び替え

複数のカラムを使って並び替えることもできます。最初に指定したカラムで並び替え、値が同じレコードがある場合は次のカラムで並び替えます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 
ORDER BY 並び替えカラム1 [ASC|DESC], 並び替えカラム2 [ASC|DESC], ...;
```

### 例3：複数カラムでの並び替え

例えば、成績（grades）テーブルから、課題タイプ（grade_type）の五十音順に並べ、同じ課題タイプ内では得点（score）の高い順に成績を取得するには：

```sql
SELECT * FROM grades 
ORDER BY grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| 321        | 2         | 実技試験     | 85.5  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト   | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| 302        | 1         | レポート1    | 48.0  | 50.0      | 2025-05-10      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例4：昇順と降順の混合

各カラムごとに並び順を指定することもできます。例えば、講座ID（course_id）の昇順、評価タイプ（grade_type）の昇順、得点（score）の降順で並べるには：

```sql
SELECT * FROM grades 
ORDER BY course_id ASC, grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## NULLの扱い

ORDER BYでNULL値を並び替える場合、データベース製品によって動作が異なります。多くのデータベースでは、NULL値は最小値または最大値として扱われます。

- MySQL/MariaDBでは、NULL値は昇順（ASC）の場合は最小値として（最初に表示）、降順（DESC）の場合は最大値として（最後に表示）扱われます。

一部のデータベース（PostgreSQLなど）では、NULL値の位置を明示的に指定するための「NULLS FIRST」「NULLS LAST」構文がサポートされています。

### 例5：NULL値の扱い

例えば、出席（attendance）テーブルからコメント（comment）でソートすると、NULLが最初に来ます：

```sql
SELECT * FROM attendance ORDER BY comment;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | NULL          |
| 1           | 306        | present | NULL          |
| ...         | ...        | ...     | NULL          |
| 1           | 308        | late    | 5分遅刻       |
| 1           | 323        | late    | 電車遅延      |
| ...         | ...        | ...     | ...           |

## カラム番号を使った並び替え

カラム名の代わりに、SELECT文の結果セットにおけるカラムの位置（番号）を使って並び替えることもできます。最初のカラムは1、2番目のカラムは2、という具合です。

### 構文

```sql
SELECT カラム名1, カラム名2, ... FROM テーブル名 ORDER BY カラム位置;
```

### 例6：カラム番号を使った並び替え

例えば、学生（students）テーブルから学生ID（student_id）と名前（student_name）を取得し、名前（2番目のカラム）で並べ替えるには：

```sql
SELECT student_id, student_name FROM students ORDER BY 2;
```

この場合、「ORDER BY 2」は「ORDER BY student_name」と同じ意味になります。

> **注意**：カラム番号を使う方法は、カラムの順序を変更すると問題が起きるため、実際の業務では使用を避けた方が良いとされています。

## 式や関数を使った並び替え

ORDER BY句で式や関数を使うことにより、計算結果に基づいて並び替えることもできます。

### 例7：式を使った並び替え

例えば、成績（grades）テーブルから、得点の達成率（score/max_score）の高い順に並べるには：

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY (score/max_score) DESC;
```

または

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY 達成率 DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 98.0     |
| 320        | 1         | レポート1    | 48.5  | 50.0      | 97.0     |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 95.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

### 例8：関数を使った並び替え

文字列関数を使って並び替えることもできます。例えば、月名で並べることを考えましょう：

```sql
SELECT schedule_date, MONTH(schedule_date) AS month
FROM course_schedule
ORDER BY MONTH(schedule_date);
```

実行結果：

| schedule_date | month |
|---------------|-------|
| 2025-04-07    | 4     |
| 2025-04-08    | 4     |
| ...           | ...   |
| 2025-05-01    | 5     |
| 2025-05-02    | 5     |
| ...           | ...   |
| 2025-06-01    | 6     |
| ...           | ...   |

## CASE式を使った条件付き並び替え

さらに高度な並び替えとして、CASE式を使って条件に応じた並び順を定義することもできます。

### 例9：CASE式を使った並び替え

例えば、出席（attendance）テーブルから、出席状況（status）を「欠席→遅刻→出席」の順に優先して表示するには：

```sql
SELECT * FROM attendance
ORDER BY CASE 
           WHEN status = 'absent' THEN 1
           WHEN status = 'late' THEN 2
           WHEN status = 'present' THEN 3
           ELSE 4
         END;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |
| 1           | 302        | late   | 15分遅刻      |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |
| 1           | 301        | present| NULL          |
| 1           | 306        | present| NULL          |
| ...         | ...        | ...    | ...           |

## 練習問題

### 問題7-1
students（学生）テーブルから、すべての学生情報を学生名（student_name）の降順（逆五十音順）で取得するSQLを書いてください。

### 問題7-2
grades（成績）テーブルから、得点（score）が85点以上の成績を得点の高い順に取得するSQLを書いてください。

### 問題7-3
course_schedule（授業カレンダー）テーブルから、2025年5月の授業スケジュールを日付（schedule_date）の昇順で取得するSQLを書いてください。

### 問題7-4
teachers（教師）テーブルから、教師IDと名前を取得し、名前（teacher_name）の五十音順で並べるSQLを書いてください。

### 問題7-5
grades（成績）テーブルから、講座ID（course_id）ごとに、成績を評価タイプ（grade_type）の五十音順に、同じ評価タイプ内では得点（score）の高い順に並べて取得するSQLを書いてください。

### 問題7-6
attendance（出席）テーブルから、すべての出席情報を出席状況（status）が「absent」「late」「present」の順番で、同じ状態内ではコメント（comment）の有無（NULLが後）で並べて取得するSQLを書いてください。

## 解答

### 解答7-1
```sql
SELECT * FROM students ORDER BY student_name DESC;
```

### 解答7-2
```sql
SELECT * FROM grades WHERE score >= 85 ORDER BY score DESC;
```

### 解答7-3
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31' 
ORDER BY schedule_date;
```

### 解答7-4
```sql
SELECT teacher_id, teacher_name FROM teachers ORDER BY teacher_name;
```

### 解答7-5
```sql
SELECT * FROM grades 
ORDER BY course_id, grade_type, score DESC;
```

### 解答7-6
```sql
SELECT * FROM attendance
ORDER BY 
  CASE 
    WHEN status = 'absent' THEN 1
    WHEN status = 'late' THEN 2
    WHEN status = 'present' THEN 3
    ELSE 4
  END,
  CASE 
    WHEN comment IS NULL THEN 2
    ELSE 1
  END;
```

## まとめ

この章では、クエリ結果を特定の順序で並べるための「ORDER BY」句について学びました：

1. **基本的な並び替え**：指定したカラムの値に基づいて結果を並べる方法
2. **昇順と降順**：ASC（昇順）とDESC（降順）の指定方法
3. **複数カラムでの並び替え**：優先順位の高いカラムから順に指定する方法
4. **NULL値の扱い**：NULL値が並び替えでどのように扱われるか
5. **カラム番号**：カラム名の代わりに位置で指定する方法（あまり推奨されない）
6. **式や関数**：計算結果に基づいて並べる方法
7. **CASE式**：条件付きの複雑な並び替え

ORDER BY句は、データを見やすく整理するために非常に重要です。特に大量のデータを扱う場合、適切な並び順はデータの理解を大きく助けます。

次の章では、取得する結果の件数を制限する「LIMIT句：結果件数の制限とページネーション」について学びます。



---

# 8. LIMIT句：結果件数の制限とページネーション

## はじめに

これまでの章では、条件に合うデータを取得し、それを特定の順序で並べる方法を学びました。しかし実際のアプリケーションでは、大量のデータがあるときに、その一部だけを表示したいことがよくあります。例えば：

- 成績上位10件だけを表示したい
- Webページで一度に20件ずつ表示したい（ページネーション）
- 最新の5件のお知らせだけを取得したい

このような「結果の件数を制限する」ためのSQLコマンドが「LIMIT句」です。この章では、クエリ結果の件数を制限する方法と、ページネーションの実装方法を学びます。

## LIMIT句の基本

LIMIT句は、SELECT文の結果から指定した件数だけを取得するために使います。

> **用語解説**：
> - **LIMIT**：「制限する」という意味のSQLコマンドで、取得する行数を制限します。

### 基本構文（MySQL/MariaDB）

MySQLやMariaDBでのLIMIT句の基本構文は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数;
```

LIMIT句は通常、SELECT文の最後に記述します（ORDER BYの後）。

### 例1：単純なLIMIT

例えば、学生（students）テーブルから最初の5人だけを取得するには：

```sql
SELECT * FROM students LIMIT 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |

### ORDER BYとLIMITの組み合わせ

通常、LIMIT句はORDER BY句と組み合わせて使用します。これにより、「上位N件」「最新N件」などの操作が可能になります。

### 例2：ORDER BYとLIMITの組み合わせ

例えば、成績（grades）テーブルから得点（score）の高い順に上位3件を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 3;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |

### 例3：最新のレコードを取得

日付でソートして最新のデータを取得することもよくあります。例えば、最新の3つの授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
ORDER BY schedule_date DESC LIMIT 3;
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 95          | 28        | 2026-12-21    | 3         | 202D         | 119        | scheduled |
| 94          | 1         | 2026-12-21    | 1         | 102B         | 101        | scheduled |
| 93          | 14        | 2026-12-15    | 4         | 202D         | 110        | scheduled |

## OFFSETとページネーション

Webアプリケーションなどでは、大量のデータを「ページ」に分けて表示することがよくあります（ページネーション）。この機能を実現するためには、「OFFSET」（オフセット）という機能が必要です。

> **用語解説**：
> - **OFFSET**：「ずらす」という意味で、結果セットの先頭から指定した数だけ行をスキップします。
> - **ページネーション**：大量のデータを複数のページに分割して表示する技術です。

### 基本構文（MySQL/MariaDB）

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数 OFFSET スキップ数;
```

または、短縮形として：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT スキップ数, 件数;
```

### 例4：OFFSETを使ったスキップ

例えば、学生（students）テーブルから6番目から10番目までの学生を取得するには：

```sql
SELECT * FROM students LIMIT 5 OFFSET 5;
```

または：

```sql
SELECT * FROM students LIMIT 5, 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 306        | 河田咲奈     |
| 307        | 織田柚夏     |
| 308        | 永田悦子     |
| 309        | 相沢吉夫     |
| 310        | 吉川伽羅     |

### 例5：ページネーションの実装

ページネーションを実装する場合、通常は以下の式を使ってOFFSETを計算します：

```
OFFSET = (ページ番号 - 1) × ページあたりの件数
```

例えば、1ページあたり10件表示で、3ページ目のデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 10 OFFSET 20;
```

または：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 20, 10;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 322        | 木村結衣     |
| 323        | 林正義       |
| 324        | 清水香織     |
| 325        | 山田翔太     |
| 326        | 葉山陽太     |
| 327        | 青山凛       |
| 328        | 沢村大和     |
| 329        | 白石優月     |
| 330        | 月岡星奈     |

## LIMIT句を使用する際の注意点

### 1. ORDER BYの重要性

LIMIT句を使用する場合、通常はORDER BY句も一緒に使うべきです。ORDER BYがなければ、どのレコードが取得されるかは保証されません。

```sql
-- 良い例：結果が予測可能
SELECT * FROM students ORDER BY student_id LIMIT 5;

-- 悪い例：結果が不確定
SELECT * FROM students LIMIT 5;
```

### 2. パフォーマンスへの影響

大規模なテーブルで大きなOFFSET値を使用すると、パフォーマンスが低下する可能性があります。これは、データベースがOFFSET分のレコードを読み込んでから破棄する必要があるためです。

### 3. データベース製品による構文の違い

LIMIT句の構文はデータベース製品によって異なります：

- **MySQL/MariaDB/SQLite**：`LIMIT 件数 OFFSET スキップ数` または `LIMIT スキップ数, 件数`
- **PostgreSQL**：`LIMIT 件数 OFFSET スキップ数`
- **Oracle**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY`
- **SQL Server**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY` または旧バージョンでは `TOP`句

この章では主にMySQL/MariaDBの構文を使用します。

## 実践的なページネーションの実装

実際のアプリケーションでページネーションを実装する場合、以下のようなコードになります（疑似コード）：

```
ページ番号 = URLから取得またはデフォルト値（例：1）
1ページあたりの件数 = 設定値（例：10）
総レコード数 = SELECTで取得（COUNT(*)を使用）
総ページ数 = CEILING(総レコード数 ÷ 1ページあたりの件数)
OFFSET = (ページ番号 - 1) × 1ページあたりの件数

SQLクエリ = "SELECT * FROM テーブル ORDER BY カラム LIMIT " + 1ページあたりの件数 + " OFFSET " + OFFSET
```

### 例6：総レコード数と総ページ数の取得

総レコード数を取得するには：

```sql
SELECT COUNT(*) AS total_records FROM students;
```

実行結果：

| total_records |
|---------------|
| 100           |

この場合、1ページあたり10件表示なら、総ページ数は10ページ（CEILING(100 ÷ 10)）になります。

## 練習問題

### 問題8-1
grades（成績）テーブルから、得点（score）の高い順に上位5件の成績レコードを取得するSQLを書いてください。

### 問題8-2
course_schedule（授業カレンダー）テーブルから、日付（schedule_date）の新しい順に3件のスケジュールを取得するSQLを書いてください。

### 問題8-3
students（学生）テーブルを学生ID（student_id）の昇順で並べ、11番目から15番目までの学生（5件）を取得するSQLを書いてください。

### 問題8-4
teachers（教師）テーブルから、教師名（teacher_name）の五十音順で6番目から10番目までの教師情報を取得するSQLを書いてください。

### 問題8-5
1ページあたり20件表示で、grades（成績）テーブルの3ページ目のデータを得点（score）の高い順に取得するSQLを書いてください。

### 問題8-6
course_schedule（授業カレンダー）テーブルから、状態（status）が「scheduled」のスケジュールを日付（schedule_date）の昇順で並べ、先頭から10件スキップして次の5件を取得するSQLを書いてください。

## 解答

### 解答8-1
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 5;
```

### 解答8-2
```sql
SELECT * FROM course_schedule ORDER BY schedule_date DESC LIMIT 3;
```

### 解答8-3
```sql
SELECT * FROM students ORDER BY student_id LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM students ORDER BY student_id LIMIT 10, 5;
```

### 解答8-4
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5 OFFSET 5;
```
または
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5, 5;
```

### 解答8-5
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 20 OFFSET 40;
```
または
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 40, 20;
```

### 解答8-6
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 10, 5;
```

## まとめ

この章では、クエリ結果の件数を制限するためのLIMIT句と、ページネーションの実装方法について学びました：

1. **LIMIT句の基本**：指定した件数だけのレコードを取得する方法
2. **ORDER BYとの組み合わせ**：順序付けされた結果から一部だけを取得する方法
3. **OFFSET**：結果の先頭から指定した数だけレコードをスキップする方法
4. **ページネーション**：大量のデータを複数のページに分けて表示する実装方法
5. **注意点**：LIMIT句を使用する際の留意事項
6. **データベース製品による違い**：異なるデータベースでの構文の違い

LIMIT句は特にWebアプリケーションの開発で重要な機能です。大量のデータを効率よく表示するためのページネーション機能を実装するために欠かせません。また、トップN（上位N件）やボトムN（下位N件）のデータを取得する際にも使われます。

次の章では、データの集計分析を行うための「集計関数：COUNT、SUM、AVG、MAX、MIN」について学びます。




---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [9. 集計関数：COUNT、SUM、AVG、MAX、MIN](#9-集計関数countsumavgmaxmin)
2. [10. GROUP BY：データのグループ化](#10-group-byデータのグループ化)
3. [11. HAVING：グループ化後の絞り込み](#11-havingグループ化後の絞り込み)
4. [12. DISTINCT：重複の除外](#12-distinct重複の除外)
5. [SQL学習テキスト 完全版](#sql学習テキスト-完全版)

---


# 9. 集計関数：COUNT、SUM、AVG、MAX、MIN

## はじめに

これまでの章では、データベースからレコードを取得して表示する方法を学んできました。しかし、データベースを使う目的の一つは、大量のデータから有用な情報（集計、統計など）を抽出することです。例えば：

- 「学生の総数は何人か？」
- 「成績の平均点は？」
- 「最高点と最低点は？」
- 「全講座の合計受講者数は？」

このような「データの集計」を行うためのSQLの機能が「集計関数」です。この章では、最もよく使われる5つの集計関数（COUNT、SUM、AVG、MAX、MIN）について学びます。

## 集計関数の基本

集計関数は、複数の行のデータをまとめて一つの値を返す関数です。

> **用語解説**：
> - **集計関数**：複数の行（レコード）から計算された単一の値を返す関数です。データの集計や統計に使用されます。

### 主な集計関数

| 関数   | 説明                     | 例                                 |
|--------|--------------------------|-------------------------------------|
| COUNT  | レコード数を数える        | 学生の総数                           |
| SUM    | 値の合計を計算する        | 全成績の点数合計                     |
| AVG    | 値の平均を計算する        | 平均点                             |
| MAX    | 最大値を取得する         | 最高点                             |
| MIN    | 最小値を取得する         | 最低点                             |

## COUNT関数：レコード数をカウントする

COUNT関数は、条件に一致するレコードの数を数えるのに使用します。

### 基本構文

```sql
SELECT COUNT(カラム名) FROM テーブル名 [WHERE 条件];
```

または、すべての行を数える場合：

```sql
SELECT COUNT(*) FROM テーブル名 [WHERE 条件];
```

### 例1：テーブル内の全レコード数

例えば、学生（students）テーブルの全学生数を数えるには：

```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

実行結果：

| 学生総数 |
|---------|
| 100     |

### 例2：条件付きのカウント

WHERE句と組み合わせることで、条件に一致するレコードだけをカウントできます。例えば、「出席（present）」状態の出席レコードの数を数えるには：

```sql
SELECT COUNT(*) AS 出席数 FROM attendance WHERE status = 'present';
```

実行結果：

| 出席数 |
|-------|
| 42    |

### 例3：NULL以外の値をカウント

COUNT(カラム名)を使うと、そのカラムがNULLでない行だけがカウントされます。これは、COUNT(*)との大きな違いです。例えば、コメント（comment）が入力されている出席レコードの数を数えるには：

```sql
SELECT COUNT(comment) AS コメントあり FROM attendance;
```

実行結果：

| コメントあり |
|------------|
| 23         |

### 例4：DISTINCTを使った重複のないカウント

DISTINCTを使うと、重複を除外してカウントできます。例えば、何種類の評価タイプ（grade_type）があるかを数えるには：

```sql
SELECT COUNT(DISTINCT grade_type) AS 評価タイプ数 FROM grades;
```

実行結果：

| 評価タイプ数 |
|------------|
| 3          |

## SUM関数：合計を計算する

SUM関数は、数値カラムの合計を計算するのに使用します。

### 基本構文

```sql
SELECT SUM(数値カラム) FROM テーブル名 [WHERE 条件];
```

### 例1：単純な合計

例えば、全成績レコードの得点（score）の合計を計算するには：

```sql
SELECT SUM(score) AS 総得点 FROM grades;
```

実行結果：

| 総得点   |
|---------|
| 3542.5  |

### 例2：条件付きの合計

WHERE句と組み合わせることで、条件に一致するレコードだけの合計を計算できます。例えば、「中間テスト」の得点合計を計算するには：

```sql
SELECT SUM(score) AS 中間テスト合計点 
FROM grades 
WHERE grade_type = '中間テスト';
```

実行結果：

| 中間テスト合計点 |
|----------------|
| 1728.0         |

### 例3：計算式を使った合計

計算式と組み合わせることもできます。例えば、全成績の達成率（score/max_score）の合計を計算するには：

```sql
SELECT SUM(score/max_score) AS 達成率合計 FROM grades;
```

実行結果：

| 達成率合計 |
|-----------|
| 39.86     |

## AVG関数：平均を計算する

AVG関数は、数値カラムの平均値を計算するのに使用します。

### 基本構文

```sql
SELECT AVG(数値カラム) FROM テーブル名 [WHERE 条件];
```

### 例1：単純な平均

例えば、全成績レコードの得点（score）の平均を計算するには：

```sql
SELECT AVG(score) AS 平均点 FROM grades;
```

実行結果：

| 平均点  |
|--------|
| 82.38  |

### 例2：条件付きの平均

WHERE句と組み合わせることで、条件に一致するレコードだけの平均を計算できます。例えば、「実技試験」の平均点を計算するには：

```sql
SELECT AVG(score) AS 実技試験平均点 
FROM grades 
WHERE grade_type = '実技試験';
```

実行結果：

| 実技試験平均点 |
|--------------|
| 85.6         |

### 例3：達成率（%）の計算

計算式と組み合わせることで、例えば平均達成率（%）を計算できます：

```sql
SELECT AVG(score/max_score * 100) AS 平均達成率 FROM grades;
```

実行結果：

| 平均達成率 |
|-----------|
| 87.24     |

## MAX関数：最大値を取得する

MAX関数は、数値、文字列、日付などのカラムから最大値を取得するのに使用します。

### 基本構文

```sql
SELECT MAX(カラム名) FROM テーブル名 [WHERE 条件];
```

### 例1：数値の最大値

例えば、全成績レコードの中での最高点を取得するには：

```sql
SELECT MAX(score) AS 最高点 FROM grades;
```

実行結果：

| 最高点 |
|-------|
| 95.0  |

### 例2：文字列の最大値（辞書順で最後）

MAX関数は文字列にも使用でき、この場合は辞書順で「最後」の値を返します。例えば、学生名の辞書順で最後の値（最も「わ行」に近い名前）を取得するには：

```sql
SELECT MAX(student_name) AS 学生名最終 FROM students;
```

実行結果：

| 学生名最終 |
|----------|
| 吉川伽羅  |

### 例3：日付の最大値（最新の日付）

日付にMAX関数を使うと、最新（最も未来）の日付が取得できます。例えば、最も新しい提出日を取得するには：

```sql
SELECT MAX(submission_date) AS 最新提出日 FROM grades;
```

実行結果：

| 最新提出日   |
|------------|
| 2025-05-20 |

## MIN関数：最小値を取得する

MIN関数は、数値、文字列、日付などのカラムから最小値を取得するのに使用します。

### 基本構文

```sql
SELECT MIN(カラム名) FROM テーブル名 [WHERE 条件];
```

### 例1：数値の最小値

例えば、全成績レコードの中での最低点を取得するには：

```sql
SELECT MIN(score) AS 最低点 FROM grades;
```

実行結果：

| 最低点 |
|-------|
| 68.0  |

### 例2：文字列の最小値（辞書順で最初）

MIN関数は文字列にも使用でき、この場合は辞書順で「最初」の値を返します。例えば、学生名の辞書順で最初の値（最も「あ行」に近い名前）を取得するには：

```sql
SELECT MIN(student_name) AS 学生名最初 FROM students;
```

実行結果：

| 学生名最初 |
|----------|
| 相沢吉夫  |

### 例3：日付の最小値（最古の日付）

日付にMIN関数を使うと、最も古い日付が取得できます。例えば、最も古い提出日を取得するには：

```sql
SELECT MIN(submission_date) AS 最古提出日 FROM grades;
```

実行結果：

| 最古提出日   |
|------------|
| 2025-05-06 |

## 複数の集計関数の組み合わせ

複数の集計関数を一つのクエリで使用することもできます。

### 例：成績の統計情報

例えば、成績（grades）テーブルの統計情報を一度に取得するには：

```sql
SELECT 
    COUNT(*) AS レコード数,
    AVG(score) AS 平均点,
    SUM(score) AS 合計点,
    MAX(score) AS 最高点,
    MIN(score) AS 最低点
FROM grades;
```

実行結果：

| レコード数 | 平均点 | 合計点  | 最高点 | 最低点 |
|---------|--------|--------|-------|-------|
| 43      | 82.38  | 3542.5 | 95.0  | 68.0  |

## 集計関数とGROUP BY（次章の内容）

集計関数をより強力に使うためには、「GROUP BY」句と組み合わせます。これにより、データをグループ化して各グループごとに集計できます。GROUP BYについては次章で詳しく学びます。

例えば、講座（course_id）ごとの平均点を計算するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id;
```

実行結果：

| course_id | 平均点 |
|-----------|--------|
| 1         | 86.2   |
| 2         | 83.8   |
| 3         | 80.5   |
| ...       | ...    |

この例の詳細な説明は次章で行います。

## 練習問題

### 問題9-1
students（学生）テーブルから、学生の総数を取得するSQLを書いてください。

### 問題9-2
grades（成績）テーブルから、全成績の平均点（score）を取得するSQLを書いてください。

### 問題9-3
attendance（出席）テーブルから、出席状況（status）が「absent」のレコード数を取得するSQLを書いてください。

### 問題9-4
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」の成績の最高点と最低点を取得するSQLを書いてください。

### 問題9-5
course_schedule（授業カレンダー）テーブルから、最新（schedule_dateが最大）の授業スケジュールの日付を取得するSQLを書いてください。

### 問題9-6
grades（成績）テーブルから、成績の総数、平均点、合計点、最高点、最低点を一度に取得するSQLを書いてください。

## 解答

### 解答9-1
```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

### 解答9-2
```sql
SELECT AVG(score) AS 全成績平均点 FROM grades;
```

### 解答9-3
```sql
SELECT COUNT(*) AS 欠席数 FROM attendance WHERE status = 'absent';
```

### 解答9-4
```sql
SELECT 
    MAX(score) AS 中間テスト最高点,
    MIN(score) AS 中間テスト最低点
FROM grades 
WHERE grade_type = '中間テスト';
```

### 解答9-5
```sql
SELECT MAX(schedule_date) AS 最新授業日 FROM course_schedule;
```

### 解答9-6
```sql
SELECT 
    COUNT(*) AS 成績総数,
    AVG(score) AS 平均点,
    SUM(score) AS 合計点,
    MAX(score) AS 最高点,
    MIN(score) AS 最低点
FROM grades;
```

## まとめ

この章では、データの集計と分析に使用される主要な集計関数について学びました：

1. **COUNT**：レコード数をカウントする関数
2. **SUM**：数値の合計を計算する関数
3. **AVG**：数値の平均を計算する関数
4. **MAX**：最大値（数値、文字列、日付など）を取得する関数
5. **MIN**：最小値（数値、文字列、日付など）を取得する関数

これらの集計関数を使うことで、大量のデータから意味のある統計情報を簡単に抽出できます。ビジネスにおける意思決定や、データ分析において非常に重要な機能です。

次の章では、データをグループ化して集計を行うための「GROUP BY：データのグループ化」について学びます。



---

# 10. GROUP BY：データのグループ化

## はじめに

前章では、集計関数（COUNT、SUM、AVG、MAX、MIN）を使って全体的な集計や統計を計算する方法を学びました。しかし実際のデータ分析では、全体の集計だけでなく、特定のカテゴリや条件ごとに集計したい場合が多くあります。例えば：

- 「講座ごとの平均点は？」
- 「教師ごとの担当講座数は？」
- 「日付ごとの授業数は？」
- 「出席状況（出席/遅刻/欠席）の割合は？」

このような「グループごとの集計」を行うためのSQLコマンドが「GROUP BY」です。この章では、データをグループ化して集計する方法について学びます。

## GROUP BYの基本

GROUP BY句は、指定したカラムの値が同じレコードをグループ化し、それぞれのグループに対して集計関数を適用するために使います。

> **用語解説**：
> - **GROUP BY**：「〜でグループ化する」という意味のSQLコマンドで、同じ値を持つレコードをまとめてグループにします。
> - **グループ化**：データを特定の条件で分類し、それぞれの分類ごとに集計を行うこと。

### 基本構文

```sql
SELECT カラム名, 集計関数
FROM テーブル名
[WHERE 条件]
GROUP BY グループ化するカラム名;
```

重要なのは、SELECT句に含めるカラムは、GROUP BY句で指定したカラムか、集計関数（COUNT、SUM、AVG、MAX、MINなど）のいずれかでなければならないということです。

### 例1：単純なグループ化

例えば、成績（grades）テーブルから、評価タイプ（grade_type）ごとの成績レコード数を集計するには：

```sql
SELECT grade_type, COUNT(*) AS レコード数
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | レコード数 |
|-------------|-----------|
| 中間テスト   | 12        |
| レポート1    | 22        |
| 実技試験     | 9         |

### 例2：グループごとの平均

グループごとの平均を計算することも一般的です。例えば、各評価タイプごとの平均点を計算するには：

```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均点    |
|-------------|----------|
| 中間テスト   | 86.25    |
| レポート1    | 44.77    |
| 実技試験     | 85.61    |

## 複数のカラムによるグループ化

複数のカラムを指定してグループ化することもできます。この場合、指定したすべてのカラムの値の組み合わせがグループの単位になります。

### 例3：複数カラムでのグループ化

例えば、講座（course_id）と評価タイプ（grade_type）の組み合わせごとに成績の平均を計算するには：

```sql
SELECT course_id, grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY course_id, grade_type;
```

実行結果：

| course_id | grade_type  | 平均点    |
|-----------|-------------|----------|
| 1         | 中間テスト   | 87.33    |
| 1         | レポート1    | 45.39    |
| 2         | 実技試験     | 86.83    |
| ...       | ...         | ...      |

### グループ化の順序

GROUP BY句でカラムを指定する順序は、結果には影響しません。しかし、可読性のためにSELECT句と同じ順序で指定することが一般的です。

## WHERE句とGROUP BYの組み合わせ

WHERE句は、グループ化する前に行単位でレコードを絞り込むのに使います。

> **用語解説**：
> - **絞り込み順序**：WHERE句はGROUP BY句の前に評価され、条件に合うレコードだけがグループ化の対象になります。

### 例4：WHEREとGROUP BYの組み合わせ

例えば、得点（score）が80以上の成績だけを対象に、評価タイプごとの平均を計算するには：

```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
WHERE score >= 80
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均点    |
|-------------|----------|
| 中間テスト   | 88.92    |
| 実技試験     | 87.25    |

この例では、score >= 80の条件に一致するレコードだけがグループ化され、集計されています。レポート1はすべての点数が80未満なので、結果には表示されていません。

## GROUP BYとORDER BYの組み合わせ

GROUP BY句とORDER BY句を組み合わせることで、グループ化した結果を任意の順序で並べることができます。

### 例5：GROUP BYとORDER BYの組み合わせ

例えば、講座（course_id）ごとの平均点を計算し、平均点の高い順に並べるには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
ORDER BY 平均点 DESC;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| 2         | 83.79    |
| 5         | 82.33    |
| ...       | ...      |

## 集計関数の複数使用

一つのクエリで複数の集計関数を使用することもできます。

### 例6：複数の集計関数の使用

例えば、評価タイプごとの成績数、平均点、最高点、最低点を一度に取得するには：

```sql
SELECT grade_type, 
       COUNT(*) AS 成績数,
       AVG(score) AS 平均点,
       MAX(score) AS 最高点,
       MIN(score) AS 最低点
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 成績数 | 平均点    | 最高点 | 最低点 |
|-------------|-------|----------|-------|-------|
| 中間テスト   | 12    | 86.25    | 95.0  | 78.5  |
| レポート1    | 22    | 44.77    | 49.0  | 37.0  |
| 実技試験     | 9     | 85.61    | 88.0  | 79.5  |

## 計算式を含むグループ化

GROUP BY句で集計した結果に対して、さらに計算を加えることができます。

### 例7：計算式を含むグループ化

例えば、評価タイプごとに平均達成率（score/max_score）を計算するには：

```sql
SELECT grade_type, 
       AVG(score/max_score * 100) AS 平均達成率
FROM grades
GROUP BY grade_type;
```

実行結果：

| grade_type  | 平均達成率 |
|-------------|-----------|
| 中間テスト   | 86.25     |
| レポート1    | 89.54     |
| 実技試験     | 85.61     |

## GROUP BYとNULLの扱い

GROUP BY句でグループ化する際、NULL値も一つのグループとして扱われます。

### 例8：NULLを含むグループ化

例えば、出席（attendance）テーブルから、コメント（comment）の有無でグループ化し、それぞれの件数を数えるには：

```sql
SELECT 
    CASE 
        WHEN comment IS NULL THEN 'コメントなし'
        ELSE 'コメントあり'
    END AS コメント状態,
    COUNT(*) AS 件数
FROM attendance
GROUP BY 
    CASE 
        WHEN comment IS NULL THEN 'コメントなし'
        ELSE 'コメントあり'
    END;
```

実行結果：

| コメント状態   | 件数  |
|--------------|-------|
| コメントなし   | 20    |
| コメントあり   | 23    |

## HAVINGを使ったグループの絞り込み（次章の内容）

グループ化した後にさらに条件でグループを絞り込むには、「HAVING」句を使います。これについては次章で詳しく学びます。

例えば、5人以上の学生が受講している講座だけを取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 学生数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題10-1
courses（講座）テーブルから、教師ID（teacher_id）ごとに担当している講座の数を取得するSQLを書いてください。

### 問題10-2
attendance（出席）テーブルから、出席状況（status）ごとのレコード数を取得するSQLを書いてください。

### 問題10-3
grades（成績）テーブルから、学生ID（student_id）ごとの平均点を計算し、平均点の高い順に並べるSQLを書いてください。

### 問題10-4
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）ごとに予定されている授業の数を取得するSQLを書いてください。

### 問題10-5
grades（成績）テーブルから、講座ID（course_id）と評価タイプ（grade_type）の組み合わせごとの平均点を計算し、講座ID順、さらに評価タイプ順で並べるSQLを書いてください。

### 問題10-6
student_courses（受講）テーブルから、講座ID（course_id）ごとの受講者数を取得し、受講者数の多い順に並べるSQLを書いてください。

## 解答

### 解答10-1
```sql
SELECT teacher_id, COUNT(course_id) AS 担当講座数
FROM courses
GROUP BY teacher_id;
```

### 解答10-2
```sql
SELECT status, COUNT(*) AS レコード数
FROM attendance
GROUP BY status;
```

### 解答10-3
```sql
SELECT student_id, AVG(score) AS 平均点
FROM grades
GROUP BY student_id
ORDER BY 平均点 DESC;
```

### 解答10-4
```sql
SELECT classroom_id, COUNT(*) AS 授業数
FROM course_schedule
GROUP BY classroom_id;
```

### 解答10-5
```sql
SELECT course_id, grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY course_id, grade_type
ORDER BY course_id, grade_type;
```

### 解答10-6
```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
ORDER BY 受講者数 DESC;
```

## まとめ

この章では、データをグループ化して集計するためのGROUP BY句について学びました：

1. **GROUP BYの基本**：同じ値を持つレコードをグループ化する方法
2. **集計関数との組み合わせ**：グループごとの集計を行う方法
3. **複数カラムによるグループ化**：複数の条件でのグループ化
4. **WHERE句との組み合わせ**：グループ化前のレコード絞り込み
5. **ORDER BYとの組み合わせ**：グループ化結果の並び替え
6. **複数の集計関数の使用**：一度に複数の統計値を取得する方法
7. **計算式を含むグループ化**：より複雑な集計の実現
8. **NULLの扱い**：グループ化におけるNULL値の取り扱い

GROUP BY句を使うことで、データのさまざまな側面から分析が可能になり、意思決定のための有用な情報を抽出できるようになります。

次の章では、グループ化した結果をさらに条件で絞り込むための「HAVING：グループ化後の絞り込み」について学びます。



---

# 11. HAVING：グループ化後の絞り込み

## はじめに

前章では、GROUP BY句を使ってデータをグループ化し、各グループごとに集計を行う方法を学びました。しかし、すべてのグループの集計結果を表示するのではなく、特定の条件を満たすグループだけを表示したい場合があります。例えば：

- 「平均点が80点以上の講座だけを表示したい」
- 「5人以上の学生が登録している講座だけを取得したい」
- 「出席率が90%を超える学生だけをリストアップしたい」

このような「グループ化した結果をさらに絞り込む」ためのSQLコマンドが「HAVING」句です。この章では、グループ化した結果に条件を適用する方法について学びます。

## HAVINGの基本

HAVING句は、GROUP BY句でグループ化した後の結果に対して条件を適用し、条件を満たすグループだけを取得するために使います。

> **用語解説**：
> - **HAVING**：「〜を持っている」という意味のSQLコマンドで、グループ化した結果に対して条件を適用します。

### 基本構文

```sql
SELECT カラム名, 集計関数
FROM テーブル名
[WHERE 行レベルの条件]
GROUP BY グループ化するカラム名
HAVING グループレベルの条件;
```

### 例1：基本的なHAVINGの使用

例えば、受講者数が5人以上の講座だけを取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5;
```

実行結果：

| course_id | 受講者数 |
|-----------|---------|
| 1         | 12      |
| 2         | 8       |
| 4         | 7       |
| 5         | 7       |
| ...       | ...     |

この例では、まず講座ID（course_id）ごとに学生ID（student_id）の数を数え、その後でHAVING句を使って受講者数が5人以上のグループだけを抽出しています。

## WHEREとHAVINGの違い

WHERE句とHAVING句は似ていますが、適用されるタイミングと対象が異なります：

- **WHERE**：グループ化される前の個々の行（レコード）に対して条件を適用します。
- **HAVING**：グループ化された後のグループに対して条件を適用します。

> **用語解説**：
> - **行レベルのフィルタリング**：WHEREによる個々のレコードの絞り込み
> - **グループレベルのフィルタリング**：HAVINGによるグループの絞り込み

### 例2：WHEREとHAVINGの違い

以下の例で違いを確認しましょう：

```sql
-- WHERE（行レベル）：まず80点以上の成績だけを選び、それからグループ化
SELECT course_id, AVG(score) AS 平均点
FROM grades
WHERE score >= 80
GROUP BY course_id;

-- HAVING（グループレベル）：まずグループ化して平均点を計算し、それから平均点が80以上のグループを選ぶ
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
HAVING AVG(score) >= 80;
```

1つ目のクエリは、「80点以上の成績だけ」を対象に講座ごとの平均点を計算します。
2つ目のクエリは、「講座の平均点が80点以上」の講座だけを取得します。

**WHERE句の結果**：

| course_id | 平均点    |
|-----------|----------|
| 1         | 88.92    |
| 2         | 87.25    |
| ...       | ...      |

**HAVING句の結果**：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| 2         | 83.79    |
| 5         | 82.33    |
| ...       | ...      |

## HAVINGで使用できる条件

HAVING句では、集計関数（COUNT、SUM、AVG、MAX、MINなど）を使った条件や、GROUP BY句で指定したカラムに対する条件を指定できます。

### 例3：集計関数を使った条件

例えば、平均点が85点以上の講座を取得するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
GROUP BY course_id
HAVING AVG(score) >= 85;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 86.21    |
| ...       | ...      |

### 例4：複数条件の指定

HAVING句も、WHERE句と同様に複数の条件を組み合わせることができます：

```sql
SELECT grade_type, COUNT(*) AS 件数, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type
HAVING COUNT(*) > 10 AND AVG(score) > 80;
```

実行結果：

| grade_type | 件数 | 平均点    |
|------------|-----|----------|
| 中間テスト  | 12  | 86.25    |
| ...        | ... | ...      |

## WHEREとHAVINGの組み合わせ

実際のクエリでは、WHERE句とHAVING句を組み合わせることが多いです。WHERE句でグループ化前の行を絞り込み、HAVING句でグループ化後の結果をさらに絞り込みます。

### 例5：WHEREとHAVINGの組み合わせ

例えば、「中間テストのみを対象として、平均点が85点以上の講座」を取得するには：

```sql
SELECT course_id, AVG(score) AS 平均点
FROM grades
WHERE grade_type = '中間テスト'
GROUP BY course_id
HAVING AVG(score) >= 85;
```

実行結果：

| course_id | 平均点    |
|-----------|----------|
| 1         | 87.33    |
| ...       | ...      |

## HAVINGとORDER BYの組み合わせ

HAVING句で絞り込んだ結果を並べ替えるには、ORDER BY句を追加します。

### 例6：HAVINGとORDER BYの組み合わせ

例えば、受講者数が5人以上の講座を、受講者数の多い順に並べて取得するには：

```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 5
ORDER BY 受講者数 DESC;
```

実行結果：

| course_id | 受講者数 |
|-----------|---------|
| 1         | 12      |
| 20        | 11      |
| 9         | 10      |
| ...       | ...     |

## 実践的なHAVINGの使用例

### 例7：「平均達成率が90%を超える評価タイプ」の抽出

各評価タイプごとの平均達成率（score/max_score）を計算し、90%を超えるものだけを取得します：

```sql
SELECT grade_type, 
       AVG(score/max_score * 100) AS 平均達成率
FROM grades
GROUP BY grade_type
HAVING AVG(score/max_score * 100) > 90;
```

実行結果：

| grade_type | 平均達成率 |
|------------|----------|
| レポート1   | 93.54    |
| ...        | ...      |

### 例8：「特定の講座で成績データが存在する学生」の抽出

例えば、講座ID「1」の成績が2件以上ある学生を取得します：

```sql
SELECT student_id, COUNT(*) AS 成績件数
FROM grades
WHERE course_id = '1'
GROUP BY student_id
HAVING COUNT(*) >= 2;
```

実行結果：

| student_id | 成績件数 |
|------------|---------|
| 301        | 2       |
| 302        | 2       |
| ...        | ...     |

## HAVINGでの注意点

1. **集計関数の使用**: HAVINGで使用する条件には、通常、集計関数（COUNT、SUM、AVG、MAX、MINなど）が含まれます。単純なカラム比較だけならWHERE句を使用すべきです。

2. **パフォーマンスの考慮**: WHERE句はグループ化前に適用されるため、処理対象のレコード数を減らすことができます。可能な限り、グループ化前の条件はWHERE句で指定し、グループ化後の条件だけをHAVING句で指定するようにすると、効率的なクエリになります。

3. **グループレベルの条件**: HAVING句は、GROUP BY句で指定したカラムや集計関数の結果に対する条件でなければならないことを覚えておきましょう。

## 練習問題

### 問題11-1
student_courses（受講）テーブルから、受講者数が8人以上の講座ID（course_id）を取得するSQLを書いてください。

### 問題11-2
grades（成績）テーブルから、平均点（score）が85点以上の評価タイプ（grade_type）を取得するSQLを書いてください。

### 問題11-3
courses（講座）テーブルから、各教師（teacher_id）が担当する講座数を計算し、担当講座が3つ以上の教師だけを取得するSQLを書いてください。

### 問題11-4
grades（成績）テーブルから、講座ID（course_id）ごとの最高点（score）を計算し、最高点が90点以上の講座を、最高点の高い順に並べて取得するSQLを書いてください。

### 問題11-5
attendance（出席）テーブルから、欠席（status = 'absent'）の回数が2回以上ある学生ID（student_id）を取得するSQLを書いてください。

### 問題11-6
grades（成績）テーブルを使って、中間テスト（grade_type = '中間テスト'）のデータのみを対象に、平均点が85点以上で、かつ最低点が75点以上の講座ID（course_id）を取得するSQLを書いてください。

## 解答

### 解答11-1
```sql
SELECT course_id, COUNT(student_id) AS 受講者数
FROM student_courses
GROUP BY course_id
HAVING COUNT(student_id) >= 8;
```

### 解答11-2
```sql
SELECT grade_type, AVG(score) AS 平均点
FROM grades
GROUP BY grade_type
HAVING AVG(score) >= 85;
```

### 解答11-3
```sql
SELECT teacher_id, COUNT(course_id) AS 担当講座数
FROM courses
GROUP BY teacher_id
HAVING COUNT(course_id) >= 3;
```

### 解答11-4
```sql
SELECT course_id, MAX(score) AS 最高点
FROM grades
GROUP BY course_id
HAVING MAX(score) >= 90
ORDER BY 最高点 DESC;
```

### 解答11-5
```sql
SELECT student_id, COUNT(*) AS 欠席回数
FROM attendance
WHERE status = 'absent'
GROUP BY student_id
HAVING COUNT(*) >= 2;
```

### 解答11-6
```sql
SELECT course_id, AVG(score) AS 平均点, MIN(score) AS 最低点
FROM grades
WHERE grade_type = '中間テスト'
GROUP BY course_id
HAVING AVG(score) >= 85 AND MIN(score) >= 75;
```

## まとめ

この章では、グループ化した結果に条件を適用するためのHAVING句について学びました：

1. **HAVINGの基本**：グループ化した結果に条件を適用する方法
2. **WHEREとHAVINGの違い**：
   - WHERE：グループ化前の行レベルのフィルタリング
   - HAVING：グループ化後のグループレベルのフィルタリング
3. **HAVING句での条件**：集計関数を使った条件設定
4. **複合条件**：ANDやORを使った複数条件の組み合わせ
5. **WHERE、HAVING、ORDER BYの組み合わせ**：複雑なデータ抽出の手法
6. **実践的な使用例**：実際の業務で使われるようなクエリパターン

HAVING句はデータ分析において非常に重要です。グループ化されたデータに対して「どのグループが重要か」「どのグループに注目すべきか」という条件を設定することで、より意味のある情報を抽出することができます。

次の章では、重複データを除外するための「DISTINCT：重複の除外」について学びます。



---

# 12. DISTINCT：重複の除外

## はじめに

データベースから情報を取得する際、同じ値が複数回出現することがよくあります。例えば、「どの講座がどの教室で行われているか」を調べると、同じ教室が複数回リストされるでしょう。しかし、時には重複を除いた一意の値のリストだけが必要な場合があります。例えば：

- 「学校にはどんな教室があるか」（重複なく知りたい）
- 「どの教師が授業を担当しているか」（重複なく知りたい）
- 「どのような評価タイプがあるか」（重複なく知りたい）

このような「重複を除外」するためのSQLキーワードが「DISTINCT」です。この章では、クエリ結果から重複するデータを除外する方法について学びます。

## DISTINCTの基本

DISTINCT句は、SELECT文の結果から重複する行を除外するために使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別される」という意味のSQLキーワードで、クエリ結果から重複する行を除外します。
> - **重複除外**：同じ値を持つレコードを1つだけにして、残りを除外すること。

### 基本構文

```sql
SELECT DISTINCT カラム名 FROM テーブル名 [WHERE 条件];
```

DISTINCTは、SELECT文の直後に配置され、すべての指定されたカラムの組み合わせに対して働きます。

### 例1：単一カラムでの重複除外

例えば、成績テーブル（grades）から、どのような評価タイプ（grade_type）があるかを重複なしで取得するには：

```sql
SELECT DISTINCT grade_type FROM grades;
```

実行結果：

| grade_type  |
|-------------|
| 中間テスト   |
| レポート1    |
| 実技試験     |

通常のSELECT文では、テーブル内の各行の評価タイプが表示されますが、DISTINCTを使うと、一意の評価タイプだけが表示されます。

### 例2：出席状況の種類の取得

出席（attendance）テーブルから、どのような出席状況（status）があるかを重複なしで取得するには：

```sql
SELECT DISTINCT status FROM attendance;
```

実行結果：

| status  |
|---------|
| present |
| late    |
| absent  |

## 複数カラムでのDISTINCT

DISTINCTは複数のカラムにも適用できます。この場合、指定したすべてのカラムの値の組み合わせが一意であるレコードだけが返されます。

### 基本構文

```sql
SELECT DISTINCT カラム名1, カラム名2, ... FROM テーブル名 [WHERE 条件];
```

### 例3：複数カラムでの重複除外

例えば、授業スケジュール（course_schedule）テーブルから、どの講座（course_id）がどの時限（period_id）に開講されているかを重複なしで取得するには：

```sql
SELECT DISTINCT course_id, period_id FROM course_schedule;
```

実行結果：

| course_id | period_id |
|-----------|-----------|
| 1         | 1         |
| 2         | 3         |
| 3         | 4         |
| 4         | 2         |
| ...       | ...       |

この結果は、course_idとperiod_idの組み合わせが一意のレコードのみを表示します。同じ講座が異なる時限に開講される場合や、異なる講座が同じ時限に開講される場合は、別々のレコードとして表示されます。

## COUNT関数との組み合わせ

DISTINCTはCOUNT関数と組み合わせることで、一意の値の数を数えることができます。

### 例4：一意の値の数を数える

例えば、学生（students）テーブルに何人の学生が登録されているかを数えるには：

```sql
SELECT COUNT(*) AS 学生総数 FROM students;
```

実行結果：

| 学生総数 |
|---------|
| 100     |

一方、受講（student_courses）テーブルに登録されている一意の学生数を数えるには：

```sql
SELECT COUNT(DISTINCT student_id) AS 受講学生数 FROM student_courses;
```

実行結果：

| 受講学生数 |
|-----------|
| 85        |

この2つの結果の差は、まだ1つも講座を受講していない学生が15人いることを意味します。

## DISTINCTとNULLの扱い

DISTINCTを使う場合、NULL値も1つの値として扱われます。複数のNULL値は1つのNULL値として集約されます。

### 例5：NULLを含むデータでのDISTINCT

例えば、出席（attendance）テーブルから、コメント（comment）の一意の値を取得するとします：

```sql
SELECT DISTINCT comment FROM attendance;
```

実行結果：

| comment       |
|---------------|
| NULL          |
| 15分遅刻      |
| 5分遅刻       |
| 事前連絡あり  |
| 体調不良      |
| ...           |

この結果には、NULL値も1つの行として含まれています。

## DISTINCTとORDER BYの組み合わせ

DISTINCTはORDER BY句と組み合わせて使うことができます。これにより、重複を除外した後で結果を並べ替えることができます。

### 例6：DISTINCTとORDER BYの組み合わせ

例えば、講座（courses）テーブルから、どの教師（teacher_id）が講座を担当しているかを重複なしで取得し、教師IDの順に並べるには：

```sql
SELECT DISTINCT teacher_id FROM courses ORDER BY teacher_id;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

## DISTINCTとWHEREの組み合わせ

DISTINCTはWHERE句と組み合わせて使うこともできます。これにより、特定の条件に合うレコードだけを対象に重複を除外できます。

### 例7：DISTINCTとWHEREの組み合わせ

例えば、2025年5月に授業がある教室（classroom_id）の一覧を重複なしで取得するには：

```sql
SELECT DISTINCT classroom_id
FROM course_schedule
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

実行結果：

| classroom_id |
|--------------|
| 101A         |
| 102B         |
| 201C         |
| 202D         |
| ...          |

## DISTINCTとGROUP BYの違い

DISTINCTとGROUP BYはどちらも「重複を除外する」という点では似ていますが、目的と使い方に違いがあります。

- **DISTINCT**：単純に重複する行を除外します。
- **GROUP BY**：グループごとに集計を行うために使います。集計関数（COUNT、SUM、AVG、MAX、MINなど）と一緒に使うことが一般的です。

### 例8：DISTINCTとGROUP BYの比較

例えば、講座（courses）テーブルから、どの教師（teacher_id）が講座を担当しているかを調べる場合：

DISTINCTを使う方法：
```sql
SELECT DISTINCT teacher_id FROM courses;
```

GROUP BYを使う方法：
```sql
SELECT teacher_id FROM courses GROUP BY teacher_id;
```

両方とも同じ結果を返しますが、目的が異なります。GROUP BYは集計を行うためのもので、例えば各教師が担当する講座数を数えたい場合は：

```sql
SELECT teacher_id, COUNT(*) AS 担当講座数
FROM courses
GROUP BY teacher_id;
```

このように、GROUP BYと集計関数を組み合わせて使います。

## パフォーマンスへの影響と注意点

1. **処理コスト**：DISTINCTはすべての行を調査して重複を除外するため、大量のデータがある場合は処理コストが高くなる可能性があります。

2. **代替手段の検討**：場合によっては、DISTINCTの代わりにGROUP BYを使ったり、EXISTS/NOT EXISTSを使ったりと、より効率的な方法があることがあります。

3. **部分一致には使えない**：DISTINCTは完全に一致するレコードのみを対象とします。部分的な一致や似ているレコードの除外には使えません。

## 練習問題

### 問題12-1
course_schedule（授業カレンダー）テーブルから、授業が行われる日付（schedule_date）のリストを重複なしで取得するSQLを書いてください。

### 問題12-2
grades（成績）テーブルから、何種類の評価タイプ（grade_type）があるかを数えるSQLを書いてください。

### 問題12-3
student_courses（受講）テーブルから、講座を受講している学生ID（student_id）を重複なしで取得し、IDの昇順に並べるSQLを書いてください。

### 問題12-4
course_schedule（授業カレンダー）テーブルから、どの教室（classroom_id）でどの時限（period_id）に授業が行われているかの組み合わせを重複なしで取得するSQLを書いてください。

### 問題12-5
attendance（出席）テーブルから、コメント（comment）が入力されている（NULLでない）一意のコメント内容を取得するSQLを書いてください。

### 問題12-6
grades（成績）テーブルから、どの学生（student_id）がどの講座（course_id）を受講したかの組み合わせを重複なしで取得し、学生ID、講座IDの順に並べるSQLを書いてください。

## 解答

### 解答12-1
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

### 解答12-2
```sql
SELECT COUNT(DISTINCT grade_type) AS 評価タイプ数 FROM grades;
```

### 解答12-3
```sql
SELECT DISTINCT student_id FROM student_courses ORDER BY student_id;
```

### 解答12-4
```sql
SELECT DISTINCT classroom_id, period_id FROM course_schedule;
```

### 解答12-5
```sql
SELECT DISTINCT comment FROM attendance WHERE comment IS NOT NULL;
```

### 解答12-6
```sql
SELECT DISTINCT student_id, course_id 
FROM grades 
ORDER BY student_id, course_id;
```

## まとめ

この章では、クエリ結果から重複を除外するためのDISTINCTキーワードについて学びました：

1. **DISTINCTの基本**：クエリ結果から重複する行を除外する方法
2. **単一カラムでの使用**：1つのカラムの重複を除外する方法
3. **複数カラムでの使用**：複数カラムの組み合わせの重複を除外する方法
4. **COUNT関数との組み合わせ**：一意の値の数を数える方法
5. **NULLの扱い**：DISTINCT使用時のNULL値の取り扱い
6. **ORDER BYとの組み合わせ**：重複除外後の並べ替え
7. **WHEREとの組み合わせ**：条件付きでの重複除外
8. **GROUP BYとの違い**：似た機能を持つGROUP BYとの使い分け
9. **パフォーマンスへの影響**：DISTINCTを使用する際の注意点

DISTINCTは、データベースから一意の値のリストを取得するための便利な機能です。特に、テーブル内の特定のカラムにどのような値が存在するかを調べたい場合や、重複のないマスターリストを作成したい場合に役立ちます。

次の章では、複数のテーブルを結合して情報を取得するための「JOIN基本：テーブル結合の概念」について学びます。



---

# SQL学習テキスト 完全版

このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。
学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。

---
## 目次

1. [1. SELECT基本：単一テーブルから特定カラムを取得する](#1-select基本単一テーブルから特定カラムを取得する)
2. [2. WHERE句：条件に合ったレコードを絞り込む](#2-where句条件に合ったレコードを絞り込む)
3. [3. 論理演算子：AND、OR、NOTを使った複合条件](#3-論理演算子andornotを使った複合条件)
4. [4. パターンマッチング：LIKE演算子と%、_ワイルドカード](#4-パターンマッチングlike演算子と_ワイルドカード)
5. [5. 範囲指定：BETWEEN、IN演算子](#5-範囲指定betweenin演算子)
6. [6. NULL値の処理：IS NULL、IS NOT NULL](#6-null値の処理is-nullis-not-null)
7. [7. ORDER BY：結果の並び替え](#7-order-by結果の並び替え)
8. [8. LIMIT句：結果件数の制限とページネーション](#8-limit句結果件数の制限とページネーション)

---


# 1. SELECT基本：単一テーブルから特定カラムを取得する

## はじめに

データベースからデータを取り出す作業は、料理人が大きな冷蔵庫から必要な材料だけを取り出すようなものです。SQLでは、この「取り出す」作業を「SELECT文」で行います。

SELECT文はSQLの中で最も基本的で、最もよく使われる命令です。この章では、単一のテーブル（データの表）から必要な情報だけを取り出す方法を学びます。

## 基本構文

SELECT文の最も基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名;
```

この文は「テーブル名というテーブルからカラム名という列のデータを取り出してください」という意味です。

> **用語解説**：
> - **SELECT**：「選択する」という意味のSQLコマンドで、データを取り出すときに使います。
> - **カラム**：テーブルの縦の列のことで、同じ種類のデータが並んでいます（例：名前のカラム、年齢のカラムなど）。
> - **FROM**：「〜から」という意味で、どのテーブルからデータを取るかを指定します。
> - **テーブル**：データベース内の表のことで、行と列で構成されています。

## 実践例：単一カラムの取得

学校データベースの中の「teachers」テーブル（教師テーブル）から、教師の名前だけを取得してみましょう。

```sql
SELECT teacher_name FROM teachers;
```

実行結果：

| teacher_name |
|--------------|
| 寺内鞍       |
| 田尻朋美     |
| 内村海凪     |
| 藤本理恵     |
| 黒木大介     |
| 星野涼子     |
| 深山誠一     |
| 吉岡由佳     |
| 山田太郎     |
| 佐藤花子     |
| ...          |

これは「teachers」テーブルの「teacher_name」という列（先生の名前）だけを取り出しています。

## 複数のカラムを取得する

料理に複数の材料が必要なように、データを取り出すときも複数の列が必要なことがよくあります。複数のカラムを取得するには、カラム名をカンマ（,）で区切って指定します。

```sql
SELECT カラム名1, カラム名2, カラム名3 FROM テーブル名;
```

例えば、教師の番号（ID）と名前を一緒に取得してみましょう：

```sql
SELECT teacher_id, teacher_name FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| 104        | 藤本理恵     |
| 105        | 黒木大介     |
| 106        | 星野涼子     |
| ...        | ...          |

## すべてのカラムを取得する

テーブルのすべての列を取得したい場合は、アスタリスク（*）を使います。これは「すべての列」を意味するワイルドカードです。

```sql
SELECT * FROM テーブル名;
```

例：
```sql
SELECT * FROM teachers;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |
| 102        | 田尻朋美     |
| 103        | 内村海凪     |
| ...        | ...          |

> **注意**：`SELECT *`は便利ですが、実際の業務では必要なカラムだけを指定する方が良いとされています。これは、データ量が多いときに処理速度が遅くなるのを防ぐためです。

## カラムに別名をつける（AS句）

取得したカラムに分かりやすい名前（別名）をつけることができます。これは「AS」句を使います。

```sql
SELECT カラム名 AS 別名 FROM テーブル名;
```

> **用語解説**：
> - **AS**：「〜として」という意味で、カラムに別名をつけるときに使います。この別名は結果を表示するときだけ使われます。

例えば、教師IDを「番号」、教師名を「名前」として表示してみましょう：

```sql
SELECT teacher_id AS 番号, teacher_name AS 名前 FROM teachers;
```

実行結果：

| 番号  | 名前       |
|------|------------|
| 101  | 寺内鞍     |
| 102  | 田尻朋美   |
| 103  | 内村海凪   |
| ...  | ...        |

ASは省略することも可能です：

```sql
SELECT teacher_id 番号, teacher_name 名前 FROM teachers;
```

## 計算式を使う

SELECT文では、カラムの値を使った計算もできます。例えば、成績テーブルから点数と満点を取得して、達成率（パーセント）を計算してみましょう。

```sql
SELECT student_id, course_id, grade_type, 
       score, max_score,
       (score / max_score) * 100 AS 達成率
FROM grades;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 301        | 1         | 中間テスト   | 85.5  | 100.0     | 85.5     |
| 302        | 1         | 中間テスト   | 92.0  | 100.0     | 92.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

## 重複を除外する（DISTINCT）

同じ値が複数ある場合に、重複を除いて一意の値だけを表示するには「DISTINCT」キーワードを使います。

> **用語解説**：
> - **DISTINCT**：「異なる」「区別された」という意味で、重複する値を除外して一意の値だけを取得します。

例えば、どの講座にどの教師が担当しているかを重複なしで確認してみましょう：

```sql
SELECT DISTINCT teacher_id FROM courses;
```

実行結果：

| teacher_id |
|------------|
| 101        |
| 102        |
| 103        |
| 104        |
| ...        |

これにより、courses（講座）テーブルで使われている教師IDが重複なく表示されます。

## 文字列の結合

文字列を結合するには、MySQLでは「CONCAT」関数を使います。例えば、教師のIDと名前を組み合わせて表示してみましょう：

```sql
SELECT CONCAT('教師ID:', teacher_id, ' 名前:', teacher_name) AS 教師情報
FROM teachers;
```

実行結果：

| 教師情報                  |
|--------------------------|
| 教師ID:101 名前:寺内鞍   |
| 教師ID:102 名前:田尻朋美 |
| ...                      |

> **用語解説**：
> - **CONCAT**：複数の文字列を一つにつなげる関数です。

## SELECT文と終了記号

SQLの文は通常、セミコロン（;）で終わります。これは「この命令はここで終わりです」という合図です。

複数のSQL文を一度に実行する場合は、それぞれの文の最後にセミコロンをつけます。

## 練習問題

### 問題1-1
students（学生）テーブルから、すべての学生の名前（student_name）を取得するSQLを書いてください。

### 問題1-2
classrooms（教室）テーブルから、教室ID（classroom_id）と教室名（classroom_name）を取得するSQLを書いてください。

### 問題1-3
courses（講座）テーブルから、すべての列（カラム）を取得するSQLを書いてください。

### 問題1-4
class_periods（授業時間）テーブルから、時限ID（period_id）、開始時間（start_time）、終了時間（end_time）を取得し、開始時間には「開始」、終了時間には「終了」という別名をつけるSQLを書いてください。

### 問題1-5
grades（成績）テーブルから、学生ID（student_id）、講座ID（course_id）、評価タイプ（grade_type）、得点（score）、満点（max_score）、そして得点を満点で割って100を掛けた値を「パーセント」という別名で取得するSQLを書いてください。

### 問題1-6
course_schedule（授業カレンダー）テーブルから、schedule_date（予定日）カラムだけを重複なしで取得するSQLを書いてください。

## 解答

### 解答1-1
```sql
SELECT student_name FROM students;
```

### 解答1-2
```sql
SELECT classroom_id, classroom_name FROM classrooms;
```

### 解答1-3
```sql
SELECT * FROM courses;
```

### 解答1-4
```sql
SELECT period_id, start_time AS 開始, end_time AS 終了 FROM class_periods;
```

### 解答1-5
```sql
SELECT student_id, course_id, grade_type, score, max_score,
       (score / max_score) * 100 AS パーセント
FROM grades;
```

### 解答1-6
```sql
SELECT DISTINCT schedule_date FROM course_schedule;
```

## まとめ

この章では、SQLのSELECT文の基本を学びました：

1. 単一カラムの取得: `SELECT カラム名 FROM テーブル名;`
2. 複数カラムの取得: `SELECT カラム名1, カラム名2 FROM テーブル名;`
3. すべてのカラムの取得: `SELECT * FROM テーブル名;`
4. カラムに別名をつける: `SELECT カラム名 AS 別名 FROM テーブル名;`
5. 計算式を使う: `SELECT カラム名, (計算式) AS 別名 FROM テーブル名;`
6. 重複を除外する: `SELECT DISTINCT カラム名 FROM テーブル名;`
7. 文字列の結合: `SELECT CONCAT(文字列1, カラム名, 文字列2) FROM テーブル名;`

これらの基本操作を使いこなせるようになれば、データベースから必要な情報を効率よく取り出せるようになります。次の章では、WHERE句を使って条件に合ったデータだけを取り出す方法を学びます。



---

# 2. WHERE句：条件に合ったレコードを絞り込む

## はじめに

前章では、テーブルからデータを取得する基本的な方法を学びました。しかし実際の業務では、すべてのデータではなく、特定の条件に合ったデータだけを取得したいことがほとんどです。

例えば、「全生徒の情報」ではなく「特定の学科の生徒だけ」や「成績が80点以上の学生だけ」といった形で、データを絞り込みたい場合があります。

このような場合に使用するのが「WHERE句」です。WHERE句は、SELECTコマンドの後に追加して使い、条件に合致するレコード（行）だけを取得します。

## 基本構文

WHERE句の基本的な形は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件式;
```

> **用語解説**：
> - **WHERE**：「〜の場所で」「〜の条件で」という意味のSQLコマンドで、条件に合うデータだけを抽出するために使います。
> - **条件式**：データが満たすべき条件を指定するための式です。例えば「age > 20」（年齢が20より大きい）などです。
> - **レコード**：テーブルの横の行のことで、1つのデータの集まりを表します。

## 基本的な比較演算子

WHERE句では、様々な比較演算子を使って条件を指定できます：

| 演算子 | 意味                   | 例                    |
|--------|------------------------|------------------------|
| =      | 等しい                 | age = 25               |
| <>     | 等しくない（≠と同じ）  | gender <> 'male'       |
| >      | より大きい             | score > 80             |
| <      | より小さい             | price < 1000           |
| >=     | 以上                   | height >= 170          |
| <=     | 以下                   | weight <= 70           |

## 実践例：基本的な条件での絞り込み

### 例1：等しい（=）
例えば、教師ID（teacher_id）が101の教師のみを取得するには：

```sql
SELECT * FROM teachers WHERE teacher_id = 101;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 101        | 寺内鞍       |

### 例2：より大きい（>）
成績（grades）テーブルから、90点を超える成績だけを取得するには：

```sql
SELECT * FROM grades WHERE score > 90;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例3：等しくない（<>）
講座IDが3ではない講座に関する成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id <> '3';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト  | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| 301        | 2         | 実技試験    | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 文字列の比較

テキスト（文字列）を条件にする場合は、シングルクォーテーション（'）またはダブルクォーテーション（"）で囲みます。MySQLではどちらも使えますが、多くの場合シングルクォーテーションが推奨されます。

```sql
SELECT * FROM テーブル名 WHERE テキストカラム = 'テキスト値';
```

例えば、教師名（teacher_name）が「田尻朋美」の教師を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name = '田尻朋美';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |

## 日付の比較

日付の比較も同様にシングルクォーテーションで囲みます。日付の形式はデータベースの設定によって異なりますが、一般的にはISO形式（YYYY-MM-DD）が使われます。

```sql
SELECT * FROM テーブル名 WHERE 日付カラム = '日付';
```

例えば、2025年5月20日に提出された成績を検索するには：

```sql
SELECT * FROM grades WHERE submission_date = '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

また、日付同士の大小関係も比較できます：

```sql
SELECT * FROM grades WHERE submission_date < '2025-05-15';
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 1         | レポート1   | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1   | 48.0  | 50.0      | 2025-05-10      |
| 304        | 5         | ER図作成課題 | 27.5  | 30.0      | 2025-05-14      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## 複数の条件を指定する（次章の内容）

WHERE句では、複数の条件を組み合わせることもできます。この詳細は次章「論理演算子：AND、OR、NOTを使った複合条件」で説明します。

例えば、講座IDが1で、かつ、得点が90以上の成績を取得するには：

```sql
SELECT * FROM grades WHERE course_id = '1' AND score >= 90;
```

この例の詳細な説明は次章で行います。

## 練習問題

### 問題2-1
students（学生）テーブルから、学生ID（student_id）が「310」の学生情報を取得するSQLを書いてください。

### 問題2-2
classrooms（教室）テーブルから、収容人数（capacity）が30人より多い教室の情報をすべて取得するSQLを書いてください。

### 問題2-3
courses（講座）テーブルから、教師ID（teacher_id）が「105」の講座情報を取得するSQLを書いてください。

### 問題2-4
course_schedule（授業カレンダー）テーブルから、「2025-05-15」の授業スケジュールをすべて取得するSQLを書いてください。

### 問題2-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」で、得点（score）が80点未満の成績を取得するSQLを書いてください。

### 問題2-6
teachers（教師）テーブルから、教師ID（teacher_id）が「101」ではない教師の名前を取得するSQLを書いてください。

## 解答

### 解答2-1
```sql
SELECT * FROM students WHERE student_id = 310;
```

### 解答2-2
```sql
SELECT * FROM classrooms WHERE capacity > 30;
```

### 解答2-3
```sql
SELECT * FROM courses WHERE teacher_id = 105;
```

### 解答2-4
```sql
SELECT * FROM course_schedule WHERE schedule_date = '2025-05-15';
```

### 解答2-5
```sql
SELECT * FROM grades WHERE grade_type = '中間テスト' AND score < 80;
```

### 解答2-6
```sql
SELECT teacher_name FROM teachers WHERE teacher_id <> 101;
```

## まとめ

この章では、WHERE句を使って条件に合ったレコードを取得する方法を学びました：

1. 基本的な比較演算子（=, <>, >, <, >=, <=）の使い方
2. 数値による条件絞り込み
3. 文字列（テキスト）による条件絞り込み
4. 日付による条件絞り込み

WHERE句は、大量のデータから必要な情報だけを取り出すための非常に重要な機能です。実際のデータベース操作では、この条件絞り込みを頻繁に使います。

次の章では、複数の条件を組み合わせるための「論理演算子（AND、OR、NOT）」について学びます。



---

# 3. 論理演算子：AND、OR、NOTを使った複合条件

## はじめに

前章では、WHERE句を使って単一の条件でデータを絞り込む方法を学びました。しかし実際の業務では、より複雑な条件でデータを絞り込む必要があることがよくあります。

例えば：
- 「成績が80点以上**かつ**出席率が90%以上の学生」
- 「数学**または**英語の成績が優秀な学生」
- 「課題を**まだ提出していない**学生」

このような複合条件を指定するために使うのが論理演算子です。主な論理演算子は次の3つです：

- **AND**：両方の条件を満たす（かつ）
- **OR**：いずれかの条件を満たす（または）
- **NOT**：条件を満たさない（〜ではない）

## AND演算子

AND演算子は、指定した**すべての条件を満たす**レコードだけを取得したいときに使います。

> **用語解説**：
> - **AND**：「かつ」「そして」という意味の論理演算子です。複数の条件をすべて満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 AND 条件2;
```

### 例：ANDを使った複合条件

例えば、中間テストで90点以上かつ満点が100点の成績レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

この例では、「score >= 90」と「max_score = 100」の両方の条件を満たすレコードだけが取得されます。

### 3つ以上の条件の組み合わせ

ANDを使って3つ以上の条件を組み合わせることもできます：

```sql
SELECT * FROM grades 
WHERE score >= 90 AND max_score = 100 AND grade_type = '中間テスト';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## OR演算子

OR演算子は、指定した条件の**いずれか一つでも満たす**レコードを取得したいときに使います。

> **用語解説**：
> - **OR**：「または」「もしくは」という意味の論理演算子です。複数の条件のうち少なくとも1つを満たすデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件1 OR 条件2;
```

### 例：ORを使った複合条件

例えば、教師IDが101または102の講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id = 101 OR teacher_id = 102;
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 2         | UNIX入門             | 102        |
| 3         | Cプログラミング演習    | 101        |
| 29        | コードリファクタリングとクリーンコード | 101 |
| 40        | ソフトウェアアーキテクチャパターン | 102 |
| ...       | ...                  | ...        |

この例では、「teacher_id = 101」または「teacher_id = 102」のいずれかの条件を満たすレコードが取得されます。

## NOT演算子

NOT演算子は、指定した条件を**満たさない**レコードを取得したいときに使います。

> **用語解説**：
> - **NOT**：「〜ではない」という意味の論理演算子です。条件を否定して、その条件を満たさないデータを取得します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE NOT 条件;
```

### 例：NOTを使った否定条件

例えば、完了（completed）状態ではない授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
WHERE NOT status = 'completed';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 45          | 11        | 2025-05-20    | 5         | 401G         | 106        | scheduled |
| 46          | 12        | 2025-05-21    | 1         | 301E         | 107        | scheduled |
| 50          | 2         | 2025-05-23    | 3         | 101A         | 102        | cancelled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

この例では、statusが「completed」ではないレコード（scheduled状態やcancelled状態）が取得されます。

NOT演算子は、「〜ではない」という否定の条件を作るために使われます。例えば次の2つの書き方は同じ意味になります：

```sql
SELECT * FROM teachers WHERE NOT teacher_id = 101;
SELECT * FROM teachers WHERE teacher_id <> 101;
```

## 複合論理条件（AND、OR、NOTの組み合わせ）

AND、OR、NOTを組み合わせて、より複雑な条件を指定することもできます。

### 例：ANDとORの組み合わせ

例えば、「成績が90点以上で中間テストである」または「成績が45点以上でレポートである」レコードを取得するには：

```sql
SELECT * FROM grades 
WHERE (score >= 90 AND grade_type = '中間テスト') 
   OR (score >= 45 AND grade_type = 'レポート1');
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 308        | 1         | レポート1  | 47.0  | 50.0      | 2025-05-09      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 優先順位と括弧の使用

論理演算子を組み合わせる場合、演算子の優先順位に注意が必要です。基本的に**ANDはORよりも優先順位が高い**です。つまり、ANDが先に処理されます。

例えば：
```sql
WHERE 条件1 OR 条件2 AND 条件3
```

これは次のように解釈されます：
```sql
WHERE 条件1 OR (条件2 AND 条件3)
```

意図した条件と異なる場合は、**括弧（）を使って明示的にグループ化**することが重要です：
```sql
WHERE (条件1 OR 条件2) AND 条件3
```

### 例：括弧を使った条件のグループ化

教師IDが101または102で、かつ、講座名に「プログラミング」という単語が含まれる講座を取得するには：

```sql
SELECT * FROM courses 
WHERE (teacher_id = 101 OR teacher_id = 102) 
  AND course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

この例では、括弧を使って「teacher_id = 101 OR teacher_id = 102」の部分をグループ化し、その条件と「course_name LIKE '%プログラミング%'」の条件をANDで結合しています。

## 練習問題

### 問題3-1
grades（成績）テーブルから、課題タイプ（grade_type）が「中間テスト」かつ点数（score）が85点以上のレコードを取得するSQLを書いてください。

### 問題3-2
classrooms（教室）テーブルから、収容人数（capacity）が40人以下または建物（building）が「1号館」の教室を取得するSQLを書いてください。

### 問題3-3
teachers（教師）テーブルから、教師ID（teacher_id）が101、102、103ではない教師の情報を取得するSQLを書いてください。

### 問題3-4
course_schedule（授業カレンダー）テーブルから、2025年5月20日の授業で、時限（period_id）が1か2で、かつ状態（status）が「scheduled」の授業を取得するSQLを書いてください。

### 問題3-5
students（学生）テーブルから、学生名（student_name）に「田」または「山」を含む学生を取得するSQLを書いてください。

### 問題3-6
grades（成績）テーブルから、提出日（submission_date）が2025年5月15日以降で、かつ（「中間テスト」で90点以上または「レポート1」で45点以上）の成績を取得するSQLを書いてください。

## 解答

### 解答3-1
```sql
SELECT * FROM grades 
WHERE grade_type = '中間テスト' AND score >= 85;
```

### 解答3-2
```sql
SELECT * FROM classrooms 
WHERE capacity <= 40 OR building = '1号館';
```

### 解答3-3
```sql
SELECT * FROM teachers 
WHERE NOT (teacher_id = 101 OR teacher_id = 102 OR teacher_id = 103);
```
または
```sql
SELECT * FROM teachers 
WHERE teacher_id <> 101 AND teacher_id <> 102 AND teacher_id <> 103;
```

### 解答3-4
```sql
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-20' 
  AND (period_id = 1 OR period_id = 2) 
  AND status = 'scheduled';
```

### 解答3-5
```sql
SELECT * FROM students 
WHERE student_name LIKE '%田%' OR student_name LIKE '%山%';
```

### 解答3-6
```sql
SELECT * FROM grades 
WHERE submission_date >= '2025-05-15' 
  AND ((grade_type = '中間テスト' AND score >= 90) 
       OR (grade_type = 'レポート1' AND score >= 45));
```

## まとめ

この章では、論理演算子（AND、OR、NOT）を使って複合条件を作る方法を学びました：

1. **AND**：すべての条件を満たすレコードを取得（条件1 AND 条件2）
2. **OR**：いずれかの条件を満たすレコードを取得（条件1 OR 条件2）
3. **NOT**：指定した条件を満たさないレコードを取得（NOT 条件）
4. **複合条件**：AND、OR、NOTを組み合わせたより複雑な条件
5. **括弧（）**：条件をグループ化して優先順位を明示的に指定

これらの論理演算子を使いこなすことで、より複雑で細かな条件でデータを絞り込むことができるようになります。実際のデータベース操作では、複数の条件を組み合わせることが頻繁にあるため、この章で学んだ内容は非常に重要です。

次の章では、テキストデータに対する検索を行う「パターンマッチング」について学びます。



---

# 4. パターンマッチング：LIKE演算子と%、_ワイルドカード

## はじめに

前章までは、データの完全一致や数値の比較といった条件での絞り込みを学びました。しかし実際の業務では、もっと柔軟な検索が必要なケースがあります。例えば：

- 「山」で始まる名前の学生を検索したい
- 「プログラミング」という単語を含む講座名を探したい
- 電話番号の一部だけ覚えているデータを探したい

このような「部分一致」や「パターン一致」の検索を行うためのSQLの機能が「パターンマッチング」です。この章では、パターンマッチングを行うための「LIKE演算子」と「ワイルドカード文字」について学びます。

## LIKE演算子の基本

LIKE演算子は、文字列のパターンマッチングを行うための演算子です。WHERE句と組み合わせて使用します。

> **用語解説**：
> - **LIKE**：「〜のような」という意味の演算子で、パターンに一致する文字列を検索します。
> - **パターンマッチング**：完全一致ではなく、一定のパターンに合致するデータを検索する方法です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE 文字列カラム LIKE 'パターン';
```

パターンには、通常の文字に加えて、特別な意味を持つ「ワイルドカード文字」を使用できます。

## ワイルドカード文字

SQLでは主に2つのワイルドカード文字があります：

1. **%（パーセント）**：0文字以上の任意の文字列に一致します。
2. **_（アンダースコア）**：任意の1文字に一致します。

> **用語解説**：
> - **ワイルドカード**：任意の文字や文字列に一致する特殊な文字記号です。トランプのジョーカーのように、様々な値に代用できます。

## LIKE演算子の使い方：実践例

### 例1：%（パーセント）を使ったパターンマッチング

#### 「〜で始まる」パターン：前方一致

例えば、「山」で始まる学生名を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '山%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 山本裕子     |
| 325        | 山田翔太     |
| ...        | ...          |

ここでの「山%」は「山で始まり、その後に0文字以上の任意の文字が続く」という意味です。

#### 「〜で終わる」パターン：後方一致

例えば、「子」で終わる教師名を検索するには：

```sql
SELECT * FROM teachers WHERE teacher_name LIKE '%子';
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| 106        | 星野涼子     |
| 108        | 吉岡由佳     |
| 110        | 佐藤花子     |
| ...        | ...          |

#### 「〜を含む」パターン：部分一致

例えば、「プログラミング」という単語を含む講座名を検索するには：

```sql
SELECT * FROM courses WHERE course_name LIKE '%プログラミング%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 3         | Cプログラミング演習    | 101        |
| 14        | IoTデバイスプログラミング実践 | 110 |
| ...       | ...                  | ...        |

### 例2：_（アンダースコア）を使ったパターンマッチング

アンダースコアは任意の1文字に一致します。例えば、教室IDが「10_A」パターン（最初の2文字が「10」、3文字目が任意の1文字、最後が「A」）の教室を検索するには：

```sql
SELECT * FROM classrooms WHERE classroom_id LIKE '10_A';
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| ...          | ...            | ...      | ...      | ...        |

### 例3：%と_の組み合わせ

ワイルドカード文字は組み合わせて使うこともできます。例えば、「2文字目が田」の学生を検索するには：

```sql
SELECT * FROM students WHERE student_name LIKE '_田%';
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 384        | 櫻井翼       |
| ...        | ...          |

## NOT LIKEを使った否定形のパターンマッチング

特定のパターンに一致しないレコードを検索したい場合は、「NOT LIKE」を使います。

> **用語解説**：
> - **NOT LIKE**：「〜のパターンに一致しない」という意味で、指定したパターンに一致しないデータを検索します。

例えば、講座名に「入門」を含まない講座を検索するには：

```sql
SELECT * FROM courses WHERE course_name NOT LIKE '%入門%';
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| ...       | ...                  | ...        |

## エスケープ文字の使用

もし検索したいパターンに「%」や「_」自体が含まれている場合は、それらを特別な文字としてではなく、通常の文字として扱うために「エスケープ文字」を使います。

> **用語解説**：
> - **エスケープ文字**：特別な意味を持つ文字を通常の文字として扱うための印です。

MySQLでは、バックスラッシュ（\）をエスケープ文字として使用できます。例えば、「50%」という値そのものを検索するには：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50\%';
```

または、ESCAPE句を使って明示的にエスケープ文字を指定することもできます：

```sql
SELECT * FROM テーブル名 WHERE カラム LIKE '50!%' ESCAPE '!';
```

この例では「!」をエスケープ文字として指定しています。

## 大文字と小文字の区別

MySQLのデフォルト設定では、LIKE演算子は大文字と小文字を区別しません（大文字小文字を同じものとして扱います）。

例えば、次の2つのクエリは同じ結果を返します：

```sql
SELECT * FROM courses WHERE course_name LIKE '%web%';
SELECT * FROM courses WHERE course_name LIKE '%Web%';
```

もし大文字と小文字を区別した検索が必要な場合は、「BINARY」キーワードを使用します：

```sql
SELECT * FROM courses WHERE course_name LIKE BINARY '%Web%';
```

この場合、「Web」は「web」とは一致しません。

## 複合条件との組み合わせ

LIKE演算子は、これまで学んだAND、OR、NOTなどの論理演算子と組み合わせて使うこともできます。

例えば、「田」で始まる名前で、かつ教師IDが102から105の間の教師を検索するには：

```sql
SELECT * FROM teachers 
WHERE teacher_name LIKE '田%' 
  AND teacher_id BETWEEN 102 AND 105;
```

実行結果：

| teacher_id | teacher_name |
|------------|--------------|
| 102        | 田尻朋美     |
| ...        | ...          |

## 練習問題

### 問題4-1
students（学生）テーブルから、学生名（student_name）が「佐藤」で始まる学生の情報をすべて取得するSQLを書いてください。

### 問題4-2
courses（講座）テーブルから、講座名（course_name）に「データ」という単語を含む講座の情報を取得するSQLを書いてください。

### 問題4-3
classrooms（教室）テーブルから、教室名（classroom_name）が「コンピュータ実習室」で終わる教室の情報を取得するSQLを書いてください。

### 問題4-4
teachers（教師）テーブルから、教師名（teacher_name）の2文字目が「木」である教師の情報を取得するSQLを書いてください。

### 問題4-5
courses（講座）テーブルから、講座名（course_name）に「入門」または「基礎」を含む講座を取得するSQLを書いてください。

### 問題4-6
students（学生）テーブルから、学生名（student_name）が「山」で始まり、かつ「子」で終わらない学生を取得するSQLを書いてください。

## 解答

### 解答4-1
```sql
SELECT * FROM students WHERE student_name LIKE '佐藤%';
```

### 解答4-2
```sql
SELECT * FROM courses WHERE course_name LIKE '%データ%';
```

### 解答4-3
```sql
SELECT * FROM classrooms WHERE classroom_name LIKE '%コンピュータ実習室';
```

### 解答4-4
```sql
SELECT * FROM teachers WHERE teacher_name LIKE '_木%';
```

### 解答4-5
```sql
SELECT * FROM courses 
WHERE course_name LIKE '%入門%' OR course_name LIKE '%基礎%';
```

### 解答4-6
```sql
SELECT * FROM students 
WHERE student_name LIKE '山%' AND student_name NOT LIKE '%子';
```

## まとめ

この章では、パターンマッチングを行うためのLIKE演算子と、その中で使用するワイルドカード文字（%と_）について学びました：

1. **LIKE演算子**：文字列パターンに一致するデータを検索するための演算子
2. **%（パーセント）**：0文字以上の任意の文字列に一致するワイルドカード
3. **_（アンダースコア）**：任意の1文字に一致するワイルドカード
4. **前方一致**：「パターン%」で「パターンで始まる」文字列に一致
5. **後方一致**：「%パターン」で「パターンで終わる」文字列に一致
6. **部分一致**：「%パターン%」で「パターンを含む」文字列に一致
7. **NOT LIKE**：指定したパターンに一致しないデータを検索
8. **エスケープ文字**：特殊文字（%や_）を通常の文字として扱うための方法
9. **複合条件との組み合わせ**：AND、ORなどと組み合わせたより複雑な条件

パターンマッチングは、特にテキストデータを扱う際に非常に便利な機能です。部分的な情報しか持っていない場合や、特定のパターンを持つデータを探す場合に活用できます。

次の章では、範囲指定のための「BETWEEN演算子」と「IN演算子」について学びます。



---

# 5. 範囲指定：BETWEEN、IN演算子

## はじめに

これまでの章では、等号（=）や不等号（>、<）を使って条件を指定する方法や、LIKE演算子を使ったパターンマッチングを学びました。この章では、値の範囲を指定する「BETWEEN演算子」と、複数の値を一度に指定できる「IN演算子」について学びます。

これらの演算子を使うと、次のような検索がより簡単になります：
- 「80点から90点の間の成績」
- 「2025年4月から6月の間のスケジュール」
- 「特定の教師IDリストに該当する講座」

## BETWEEN演算子：範囲を指定する

BETWEEN演算子は、ある値が指定した範囲内にあるかどうかを調べるために使います。

> **用語解説**：
> - **BETWEEN**：「〜の間に」という意味の演算子で、ある値が指定した最小値と最大値の間（両端の値を含む）にあるかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 BETWEEN 最小値 AND 最大値;
```

この構文は次の条件と同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 >= 最小値 AND カラム名 <= 最大値;
```

### 例1：数値範囲の指定

例えば、成績（grades）テーブルから、80点から90点の間の成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| 308        | 6         | 小テスト1  | 89.0  | 100.0     | 2025-05-15      |
| ...        | ...       | ...        | ...   | ...       | ...             |

### 例2：日付範囲の指定

日付にもBETWEEN演算子が使えます。例えば、2025年5月10日から2025年5月20日までに提出された成績を取得するには：

```sql
SELECT * FROM grades 
WHERE submission_date BETWEEN '2025-05-10' AND '2025-05-20';
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 301        | 1         | レポート1  | 45.0  | 50.0      | 2025-05-10      |
| 302        | 1         | レポート1  | 48.0  | 50.0      | 2025-05-10      |
| 301        | 1         | 中間テスト | 85.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## NOT BETWEEN：範囲外を指定する

NOT BETWEENを使うと、指定した範囲の外にある値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT BETWEEN 最小値 AND 最大値;
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 < 最小値 OR カラム名 > 最大値;
```

### 例：範囲外の値を取得

例えば、80点未満または90点より高い成績を取得するには：

```sql
SELECT * FROM grades 
WHERE score NOT BETWEEN 80 AND 90;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |
| 303        | 1         | 中間テスト | 78.5  | 100.0     | 2025-05-20      |
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## IN演算子：複数の値を指定する

IN演算子は、ある値が指定した複数の値のリストのいずれかに一致するかどうかを調べるために使います。

> **用語解説**：
> - **IN**：「〜の中に含まれる」という意味の演算子で、ある値が指定したリストの中に含まれているかどうかを判定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (値1, 値2, 値3, ...);
```

この構文は次のOR条件の組み合わせと同じ意味です：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 = 値1 OR カラム名 = 値2 OR カラム名 = 値3 OR ...;
```

### 例1：数値リストの指定

例えば、教師ID（teacher_id）が101、103、105のいずれかである講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (101, 103, 105);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 1         | ITのための基礎知識     | 101        |
| 3         | Cプログラミング演習    | 101        |
| 5         | データベース設計と実装  | 105        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

### 例2：文字列リストの指定

文字列のリストにも適用できます。例えば、特定の教室ID（classroom_id）のみの教室情報を取得するには：

```sql
SELECT * FROM classrooms 
WHERE classroom_id IN ('101A', '202D', '301E');
```

実行結果：

| classroom_id | classroom_name | capacity | building | facilities |
|--------------|----------------|----------|----------|------------|
| 101A         | 1号館コンピュータ実習室A | 30     | 1号館     | パソコン30台、プロジェクター |
| 202D         | 2号館コンピュータ実習室D | 25     | 2号館     | パソコン25台、プロジェクター、3Dプリンター |
| 301E         | 3号館講義室E      | 80       | 3号館     | プロジェクター、マイク設備、録画設備 |

## NOT IN：リストに含まれない値を指定する

NOT IN演算子を使うと、指定したリストに含まれない値を持つレコードを取得できます。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 NOT IN (値1, 値2, 値3, ...);
```

これは次の条件と同じです：

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 <> 値1 AND カラム名 <> 値2 AND カラム名 <> 値3 AND ...;
```

### 例：リストに含まれない値を取得

例えば、教師IDが101、102、103以外の教師が担当する講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id NOT IN (101, 102, 103);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 4         | Webアプリケーション開発 | 104        |
| 5         | データベース設計と実装  | 105        |
| 6         | ネットワークセキュリティ | 107        |
| ...       | ...                  | ...        |

## IN演算子でのサブクエリの利用（基本）

IN演算子の括弧内には、直接値を書く代わりに、サブクエリ（別のSELECT文）を指定することもできます。これにより、動的に値のリストを生成できます。

> **用語解説**：
> - **サブクエリ**：SQL文の中に含まれる別のSQL文のことで、外側のSQL文（メインクエリ）に値や条件を提供します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE カラム名 IN (SELECT カラム名 FROM 別テーブル WHERE 条件);
```

### 例：サブクエリを使ったIN条件

例えば、教師名（teacher_name）に「田」を含む教師が担当している講座を取得するには：

```sql
SELECT * FROM courses 
WHERE teacher_id IN (
    SELECT teacher_id FROM teachers 
    WHERE teacher_name LIKE '%田%'
);
```

実行結果：

| course_id | course_name           | teacher_id |
|-----------|----------------------|------------|
| 2         | UNIX入門             | 102        |
| 10        | プロジェクト管理手法    | 103        |
| ...       | ...                  | ...        |

この例では、まず「teachers」テーブルから名前に「田」を含む教師のIDを取得し、それらのIDを持つ講座を「courses」テーブルから取得しています。

## BETWEEN演算子とIN演算子の組み合わせ

BETWEEN演算子とIN演算子は、論理演算子（AND、OR）と組み合わせて、さらに複雑な条件を作ることができます。

### 例：BETWEENとINの組み合わせ

例えば、「教師IDが101、103、105のいずれかで、かつ、2025年5月15日から2025年6月15日の間に実施される授業」を取得するには：

```sql
SELECT * FROM course_schedule 
WHERE teacher_id IN (101, 103, 105) 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-06-15';
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 38          | 1         | 2025-05-20    | 1         | 102B         | 101        | scheduled |
| 42          | 10        | 2025-05-23    | 3         | 201C         | 103        | scheduled |
| 45          | 5         | 2025-05-28    | 2         | 402H         | 105        | scheduled |
| ...         | ...       | ...           | ...       | ...          | ...        | ...       |

## 練習問題

### 問題5-1
grades（成績）テーブルから、得点（score）が85点から95点の間にある成績を取得するSQLを書いてください。

### 問題5-2
course_schedule（授業カレンダー）テーブルから、2025年5月1日から2025年5月31日までの授業スケジュールを取得するSQLを書いてください。

### 問題5-3
courses（講座）テーブルから、教師ID（teacher_id）が104、106、108のいずれかである講座の情報を取得するSQLを書いてください。

### 問題5-4
classrooms（教室）テーブルから、教室ID（classroom_id）が「101A」、「201C」、「301E」、「401G」以外の教室情報を取得するSQLを書いてください。

### 問題5-5
grades（成績）テーブルから、評価タイプ（grade_type）が「中間テスト」または「実技試験」で、かつ得点（score）が80点から90点の間にない成績を取得するSQLを書いてください。

### 問題5-6
course_schedule（授業カレンダー）テーブルから、教室ID（classroom_id）が「101A」、「202D」のいずれかで、かつ2025年5月15日から2025年5月30日の間に実施される授業スケジュールを取得するSQLを書いてください。

## 解答

### 解答5-1
```sql
SELECT * FROM grades 
WHERE score BETWEEN 85 AND 95;
```

### 解答5-2
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31';
```

### 解答5-3
```sql
SELECT * FROM courses 
WHERE teacher_id IN (104, 106, 108);
```

### 解答5-4
```sql
SELECT * FROM classrooms 
WHERE classroom_id NOT IN ('101A', '201C', '301E', '401G');
```

### 解答5-5
```sql
SELECT * FROM grades 
WHERE grade_type IN ('中間テスト', '実技試験') 
  AND score NOT BETWEEN 80 AND 90;
```

### 解答5-6
```sql
SELECT * FROM course_schedule 
WHERE classroom_id IN ('101A', '202D') 
  AND schedule_date BETWEEN '2025-05-15' AND '2025-05-30';
```

## まとめ

この章では、範囲指定のための「BETWEEN演算子」と複数値指定のための「IN演算子」について学びました：

1. **BETWEEN演算子**：値が指定した範囲内（両端を含む）にあるかどうかをチェック
2. **NOT BETWEEN**：値が指定した範囲外にあるかどうかをチェック
3. **IN演算子**：値が指定したリストのいずれかに一致するかどうかをチェック
4. **NOT IN**：値が指定したリストのいずれにも一致しないかどうかをチェック
5. **サブクエリとIN**：動的に生成された値のリストを使用する方法
6. **複合条件**：BETWEEN、IN、論理演算子を組み合わせたより複雑な条件

これらの演算子を使うことで、複数の条件を指定する場合に、SQLをより簡潔に書くことができます。特に、多くの値を指定する場合や範囲条件を指定する場合に便利です。

次の章では、「NULL値の処理：IS NULL、IS NOT NULL」について学びます。



---

# 6. NULL値の処理：IS NULL、IS NOT NULL

## はじめに

データベースの世界では、データがない状態を表すために「NULL」という特別な値が使われます。NULLは「空」や「0」や「空白文字」とは異なる、「値が存在しない」または「不明」であることを表す特殊な概念です。

例えば、学校データベースでは次のようなシナリオがあります：
- まだ成績が付けられていない（NULL）
- コメントが入力されていない（NULL）
- 授業がキャンセルされたため教室が割り当てられていない（NULL）

この章では、NULL値を正しく処理するための「IS NULL」と「IS NOT NULL」演算子について学びます。

## NULLとは何か？

NULL値には、いくつかの特徴があります：

1. **値がない**：NULLは値がないことを表します。0でも空文字列（''）でもなく、値そのものが存在しないことを示します。
2. **不明**：データが不明であることを表す場合もあります。
3. **未設定**：まだ値が設定されていないことを表す場合もあります。
4. **比較できない**：NULLは通常の比較演算子（=, <, >など）で比較できません。

> **用語解説**：
> - **NULL**：データベースにおいて「値がない」または「不明」を表す特殊な値です。0や空文字とは異なります。

## NULL値と通常の比較演算子

通常の比較演算子（=, <>, >, <, >=, <=）では、NULL値を正しく検出できません。例えば：

```sql
-- この条件はNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 = NULL;

-- この条件もNULL値に対して常にFALSEを返す
SELECT * FROM テーブル名 WHERE カラム名 <> NULL;
```

これは、NULL値との等価比較は「不明」と評価されるためです。つまり、NULL = NULLでさえFALSEではなく「不明」になります。

## IS NULL演算子

NULL値を持つレコードを検索するには、「IS NULL」演算子を使います。

> **用語解説**：
> - **IS NULL**：カラムの値がNULLかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NULL;
```

### 例：IS NULLの使用

例えば、コメントが入力されていない（NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

実行結果：

| schedule_id | student_id | status  | comment |
|-------------|------------|---------|---------|
| 1           | 301        | present | NULL    |
| 1           | 306        | present | NULL    |
| 1           | 307        | present | NULL    |
| ...         | ...        | ...     | NULL    |

## IS NOT NULL演算子

逆に、NULL値を持たないレコード（つまり、何らかの値を持つレコード）を検索するには、「IS NOT NULL」演算子を使います。

> **用語解説**：
> - **IS NOT NULL**：カラムの値がNULLでないかどうかを調べる演算子です。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 WHERE カラム名 IS NOT NULL;
```

### 例：IS NOT NULLの使用

例えば、コメントが入力されている（NOT NULL）出席レコードを検索するには：

```sql
SELECT * FROM attendance WHERE comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 302        | late   | 15分遅刻      |
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |

## NULL値の論理的な扱い

NULL値は論理演算（AND、OR、NOT）でも特殊な扱いを受けます。

- **NULL AND TRUE** → NULL（不明）
- **NULL AND FALSE** → FALSE
- **NULL OR TRUE** → TRUE
- **NULL OR FALSE** → NULL（不明）
- **NOT NULL** → NULL（不明）

この特殊な振る舞いが、バグや誤った結果の原因になることがあります。

## NULL値と結合条件

テーブル結合（JOINなど、後の章で学習）の際も、NULL値は特殊な扱いを受けます。NULL値同士は「等しい」とは判定されないため、通常の結合条件ではNULL値を持つレコードは結合されません。

## IS NULLとIS NOT NULLを使った複合条件

IS NULLとIS NOT NULLも、他の条件と組み合わせて使用できます。

### 例：複合条件でのIS NULLの使用

例えば、「出席状態が "absent"（欠席）で、コメントがNULLでない（理由が入力されている）レコード」を検索するには：

```sql
SELECT * FROM attendance 
WHERE status = 'absent' AND comment IS NOT NULL;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |

## NVL/IFNULL/COALESCE関数：NULL値の置換

NULL値を別の値に置き換えるための関数が用意されています。データベースによって関数名が異なることがありますが、機能は似ています：

- MySQL/MariaDB: **IFNULL(expr, replace_value)**
- Oracle: **NVL(expr, replace_value)**
- SQL Server: **ISNULL(expr, replace_value)**
- 標準SQL: **COALESCE(expr1, expr2, ..., exprN)** - 最初のNULLでない式を返します

### 例：IFNULL関数の使用（MySQL）

例えば、コメントがNULLの場合は「特記事項なし」と表示するには：

```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '特記事項なし') AS comment
FROM attendance;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | 特記事項なし  |
| 1           | 302        | late    | 15分遅刻      |
| 1           | 303        | absent  | 事前連絡あり  |
| ...         | ...        | ...     | ...           |

## NULLを使う際の注意点

1. **除外の罠**：`WHERE カラム名 <> 値` だけでは、NULL値を持つレコードは含まれません。すべてのレコードを対象にするには：
   ```sql
   WHERE カラム名 <> 値 OR カラム名 IS NULL
   ```

2. **集計関数**：COUNT(*)はすべての行を数えますが、COUNT(カラム名)はそのカラムがNULLでない行だけを数えます。

3. **インデックス**：多くのデータベースでは、NULL値にもインデックスを適用できますが、データベースによって動作が異なる場合があります。

4. **一意性制約**：一般的に、UNIQUE制約ではNULL値は重複としてカウントされません（複数のNULL値が許可されます）。

## 練習問題

### 問題6-1
attendance（出席）テーブルから、コメント（comment）がNULLの出席レコードをすべて取得するSQLを書いてください。

### 問題6-2
course_schedule（授業カレンダー）テーブルから、状態（status）が「cancelled」で、かつ教室ID（classroom_id）がNULLでないレコードを取得するSQLを書いてください。

### 問題6-3
grades（成績）テーブルから、提出日（submission_date）がNULLの成績レコードを取得するSQLを書いてください。

### 問題6-4
attendance（出席）テーブルから、出席状態（status）が「present」か「late」で、かつコメント（comment）がNULLのレコードを取得するSQLを書いてください。

### 問題6-5
以下のSQLで教師（teachers）テーブルから「佐藤」という名前を持つ教師を検索する場合、NULL値を持つレコードも含めるにはどう修正すべきですか？
```sql
SELECT * FROM teachers WHERE teacher_name <> '佐藤花子';
```

### 問題6-6
attendance（出席）テーブルのすべてのレコードを取得し、コメント（comment）がNULLの場合は「記録なし」と表示するSQLを書いてください。

## 解答

### 解答6-1
```sql
SELECT * FROM attendance WHERE comment IS NULL;
```

### 解答6-2
```sql
SELECT * FROM course_schedule 
WHERE status = 'cancelled' AND classroom_id IS NOT NULL;
```

### 解答6-3
```sql
SELECT * FROM grades WHERE submission_date IS NULL;
```

### 解答6-4
```sql
SELECT * FROM attendance 
WHERE (status = 'present' OR status = 'late') AND comment IS NULL;
```
または
```sql
SELECT * FROM attendance 
WHERE status IN ('present', 'late') AND comment IS NULL;
```

### 解答6-5
```sql
SELECT * FROM teachers 
WHERE teacher_name <> '佐藤花子' OR teacher_name IS NULL;
```

### 解答6-6
```sql
SELECT schedule_id, student_id, status, 
       IFNULL(comment, '記録なし') AS comment
FROM attendance;
```

## まとめ

この章では、データベースにおけるNULL値の概念と、NULL値を扱うための演算子や関数について学びました：

1. **NULL値の概念**：値がない、不明、未設定を表す特殊な値
2. **IS NULL演算子**：NULL値を持つレコードを検索する方法
3. **IS NOT NULL演算子**：NULL値を持たないレコードを検索する方法
4. **NULL値の論理的扱い**：論理演算（AND、OR、NOT）におけるNULLの振る舞い
5. **複合条件**：IS NULL/IS NOT NULLと他の条件の組み合わせ
6. **NULL値の置換**：IFNULL/NVL/COALESCE関数の使用方法
7. **注意点**：NULL値を扱う際の一般的な落とし穴

NULL値の正確な理解と適切な処理は、SQLプログラミングの重要な部分です。不適切なNULL処理は、予期しない結果やバグの原因になります。

次の章では、クエリ結果の並び替えを行うための「ORDER BY：結果の並び替え」について学びます。



---

# 7. ORDER BY：結果の並び替え

## はじめに

これまでの章では、データベースから条件に合ったレコードを取得する方法を学んできました。しかし実際の業務では、取得したデータを見やすく整理する必要があります。例えば：

- 成績を高い順に表示したい
- 学生を名前の五十音順に並べたい
- 日付の新しい順にスケジュールを確認したい

このようなデータの「並び替え」を行うためのSQLコマンドが「ORDER BY」です。この章では、クエリ結果を特定の順序で並べる方法を学びます。

## ORDER BYの基本

ORDER BY句は、SELECT文の結果を指定したカラムの値に基づいて並び替えるために使います。

> **用語解説**：
> - **ORDER BY**：「〜の順に並べる」という意味のSQLコマンドで、クエリ結果の並び順を指定します。

### 基本構文

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] ORDER BY 並び替えカラム;
```

ORDER BY句は通常、SELECT文の最後に記述します。

### 例1：単一カラムでの並び替え

例えば、学生（students）テーブルから、学生名（student_name）の五十音順（辞書順）でデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_name;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 309        | 相沢吉夫      |
| 303        | 柴崎春花      |
| 306        | 河田咲奈      |
| 305        | 河口菜恵子    |
| ...        | ...          |

### デフォルトの並び順

ORDER BYを使わない場合、結果の順序は保証されません。多くの場合、データがデータベースに保存された順序で返されますが、これは信頼できるものではありません。

## 昇順と降順の指定

ORDER BY句では、並び順を「昇順」か「降順」のどちらかで指定できます。

> **用語解説**：
> - **昇順（ASC）**：小さい値から大きい値へ（A→Z、1→9）の順に並べます。
> - **降順（DESC）**：大きい値から小さい値へ（Z→A、9→1）の順に並べます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 ORDER BY 並び替えカラム [ASC|DESC];
```

ASC（昇順）がデフォルトのため、省略可能です。

### 例2：降順での並び替え

例えば、成績（grades）テーブルから、得点（score）の高い順（降順）に成績を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト  | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト  | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト  | 92.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...        | ...   | ...       | ...             |

## 複数カラムでの並び替え

複数のカラムを使って並び替えることもできます。最初に指定したカラムで並び替え、値が同じレコードがある場合は次のカラムで並び替えます。

### 構文

```sql
SELECT カラム名 FROM テーブル名 
ORDER BY 並び替えカラム1 [ASC|DESC], 並び替えカラム2 [ASC|DESC], ...;
```

### 例3：複数カラムでの並び替え

例えば、成績（grades）テーブルから、課題タイプ（grade_type）の五十音順に並べ、同じ課題タイプ内では得点（score）の高い順に成績を取得するには：

```sql
SELECT * FROM grades 
ORDER BY grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| 321        | 2         | 実技試験     | 85.5  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト   | 93.5  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| 302        | 1         | レポート1    | 48.0  | 50.0      | 2025-05-10      |
| ...        | ...       | ...         | ...   | ...       | ...             |

### 例4：昇順と降順の混合

各カラムごとに並び順を指定することもできます。例えば、講座ID（course_id）の昇順、評価タイプ（grade_type）の昇順、得点（score）の降順で並べるには：

```sql
SELECT * FROM grades 
ORDER BY course_id ASC, grade_type ASC, score DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | submission_date |
|------------|-----------|-------------|-------|-----------|-----------------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 2025-05-08      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 2025-05-20      |
| ...        | ...       | ...         | ...   | ...       | ...             |
| 301        | 2         | 実技試験     | 88.0  | 100.0     | 2025-05-18      |
| ...        | ...       | ...         | ...   | ...       | ...             |

## NULLの扱い

ORDER BYでNULL値を並び替える場合、データベース製品によって動作が異なります。多くのデータベースでは、NULL値は最小値または最大値として扱われます。

- MySQL/MariaDBでは、NULL値は昇順（ASC）の場合は最小値として（最初に表示）、降順（DESC）の場合は最大値として（最後に表示）扱われます。

一部のデータベース（PostgreSQLなど）では、NULL値の位置を明示的に指定するための「NULLS FIRST」「NULLS LAST」構文がサポートされています。

### 例5：NULL値の扱い

例えば、出席（attendance）テーブルからコメント（comment）でソートすると、NULLが最初に来ます：

```sql
SELECT * FROM attendance ORDER BY comment;
```

実行結果：

| schedule_id | student_id | status  | comment       |
|-------------|------------|---------|---------------|
| 1           | 301        | present | NULL          |
| 1           | 306        | present | NULL          |
| ...         | ...        | ...     | NULL          |
| 1           | 308        | late    | 5分遅刻       |
| 1           | 323        | late    | 電車遅延      |
| ...         | ...        | ...     | ...           |

## カラム番号を使った並び替え

カラム名の代わりに、SELECT文の結果セットにおけるカラムの位置（番号）を使って並び替えることもできます。最初のカラムは1、2番目のカラムは2、という具合です。

### 構文

```sql
SELECT カラム名1, カラム名2, ... FROM テーブル名 ORDER BY カラム位置;
```

### 例6：カラム番号を使った並び替え

例えば、学生（students）テーブルから学生ID（student_id）と名前（student_name）を取得し、名前（2番目のカラム）で並べ替えるには：

```sql
SELECT student_id, student_name FROM students ORDER BY 2;
```

この場合、「ORDER BY 2」は「ORDER BY student_name」と同じ意味になります。

> **注意**：カラム番号を使う方法は、カラムの順序を変更すると問題が起きるため、実際の業務では使用を避けた方が良いとされています。

## 式や関数を使った並び替え

ORDER BY句で式や関数を使うことにより、計算結果に基づいて並び替えることもできます。

### 例7：式を使った並び替え

例えば、成績（grades）テーブルから、得点の達成率（score/max_score）の高い順に並べるには：

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY (score/max_score) DESC;
```

または

```sql
SELECT student_id, course_id, grade_type, score, max_score, 
       (score/max_score)*100 AS 達成率
FROM grades 
ORDER BY 達成率 DESC;
```

実行結果：

| student_id | course_id | grade_type  | score | max_score | 達成率   |
|------------|-----------|-------------|-------|-----------|----------|
| 311        | 1         | レポート1    | 49.0  | 50.0      | 98.0     |
| 320        | 1         | レポート1    | 48.5  | 50.0      | 97.0     |
| 311        | 1         | 中間テスト   | 95.0  | 100.0     | 95.0     |
| ...        | ...       | ...         | ...   | ...       | ...      |

### 例8：関数を使った並び替え

文字列関数を使って並び替えることもできます。例えば、月名で並べることを考えましょう：

```sql
SELECT schedule_date, MONTH(schedule_date) AS month
FROM course_schedule
ORDER BY MONTH(schedule_date);
```

実行結果：

| schedule_date | month |
|---------------|-------|
| 2025-04-07    | 4     |
| 2025-04-08    | 4     |
| ...           | ...   |
| 2025-05-01    | 5     |
| 2025-05-02    | 5     |
| ...           | ...   |
| 2025-06-01    | 6     |
| ...           | ...   |

## CASE式を使った条件付き並び替え

さらに高度な並び替えとして、CASE式を使って条件に応じた並び順を定義することもできます。

### 例9：CASE式を使った並び替え

例えば、出席（attendance）テーブルから、出席状況（status）を「欠席→遅刻→出席」の順に優先して表示するには：

```sql
SELECT * FROM attendance
ORDER BY CASE 
           WHEN status = 'absent' THEN 1
           WHEN status = 'late' THEN 2
           WHEN status = 'present' THEN 3
           ELSE 4
         END;
```

実行結果：

| schedule_id | student_id | status | comment       |
|-------------|------------|--------|---------------|
| 1           | 303        | absent | 事前連絡あり  |
| 1           | 317        | absent | 体調不良      |
| ...         | ...        | ...    | ...           |
| 1           | 302        | late   | 15分遅刻      |
| 1           | 308        | late   | 5分遅刻       |
| ...         | ...        | ...    | ...           |
| 1           | 301        | present| NULL          |
| 1           | 306        | present| NULL          |
| ...         | ...        | ...    | ...           |

## 練習問題

### 問題7-1
students（学生）テーブルから、すべての学生情報を学生名（student_name）の降順（逆五十音順）で取得するSQLを書いてください。

### 問題7-2
grades（成績）テーブルから、得点（score）が85点以上の成績を得点の高い順に取得するSQLを書いてください。

### 問題7-3
course_schedule（授業カレンダー）テーブルから、2025年5月の授業スケジュールを日付（schedule_date）の昇順で取得するSQLを書いてください。

### 問題7-4
teachers（教師）テーブルから、教師IDと名前を取得し、名前（teacher_name）の五十音順で並べるSQLを書いてください。

### 問題7-5
grades（成績）テーブルから、講座ID（course_id）ごとに、成績を評価タイプ（grade_type）の五十音順に、同じ評価タイプ内では得点（score）の高い順に並べて取得するSQLを書いてください。

### 問題7-6
attendance（出席）テーブルから、すべての出席情報を出席状況（status）が「absent」「late」「present」の順番で、同じ状態内ではコメント（comment）の有無（NULLが後）で並べて取得するSQLを書いてください。

## 解答

### 解答7-1
```sql
SELECT * FROM students ORDER BY student_name DESC;
```

### 解答7-2
```sql
SELECT * FROM grades WHERE score >= 85 ORDER BY score DESC;
```

### 解答7-3
```sql
SELECT * FROM course_schedule 
WHERE schedule_date BETWEEN '2025-05-01' AND '2025-05-31' 
ORDER BY schedule_date;
```

### 解答7-4
```sql
SELECT teacher_id, teacher_name FROM teachers ORDER BY teacher_name;
```

### 解答7-5
```sql
SELECT * FROM grades 
ORDER BY course_id, grade_type, score DESC;
```

### 解答7-6
```sql
SELECT * FROM attendance
ORDER BY 
  CASE 
    WHEN status = 'absent' THEN 1
    WHEN status = 'late' THEN 2
    WHEN status = 'present' THEN 3
    ELSE 4
  END,
  CASE 
    WHEN comment IS NULL THEN 2
    ELSE 1
  END;
```

## まとめ

この章では、クエリ結果を特定の順序で並べるための「ORDER BY」句について学びました：

1. **基本的な並び替え**：指定したカラムの値に基づいて結果を並べる方法
2. **昇順と降順**：ASC（昇順）とDESC（降順）の指定方法
3. **複数カラムでの並び替え**：優先順位の高いカラムから順に指定する方法
4. **NULL値の扱い**：NULL値が並び替えでどのように扱われるか
5. **カラム番号**：カラム名の代わりに位置で指定する方法（あまり推奨されない）
6. **式や関数**：計算結果に基づいて並べる方法
7. **CASE式**：条件付きの複雑な並び替え

ORDER BY句は、データを見やすく整理するために非常に重要です。特に大量のデータを扱う場合、適切な並び順はデータの理解を大きく助けます。

次の章では、取得する結果の件数を制限する「LIMIT句：結果件数の制限とページネーション」について学びます。



---

# 8. LIMIT句：結果件数の制限とページネーション

## はじめに

これまでの章では、条件に合うデータを取得し、それを特定の順序で並べる方法を学びました。しかし実際のアプリケーションでは、大量のデータがあるときに、その一部だけを表示したいことがよくあります。例えば：

- 成績上位10件だけを表示したい
- Webページで一度に20件ずつ表示したい（ページネーション）
- 最新の5件のお知らせだけを取得したい

このような「結果の件数を制限する」ためのSQLコマンドが「LIMIT句」です。この章では、クエリ結果の件数を制限する方法と、ページネーションの実装方法を学びます。

## LIMIT句の基本

LIMIT句は、SELECT文の結果から指定した件数だけを取得するために使います。

> **用語解説**：
> - **LIMIT**：「制限する」という意味のSQLコマンドで、取得する行数を制限します。

### 基本構文（MySQL/MariaDB）

MySQLやMariaDBでのLIMIT句の基本構文は次のとおりです：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数;
```

LIMIT句は通常、SELECT文の最後に記述します（ORDER BYの後）。

### 例1：単純なLIMIT

例えば、学生（students）テーブルから最初の5人だけを取得するには：

```sql
SELECT * FROM students LIMIT 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |

### ORDER BYとLIMITの組み合わせ

通常、LIMIT句はORDER BY句と組み合わせて使用します。これにより、「上位N件」「最新N件」などの操作が可能になります。

### 例2：ORDER BYとLIMITの組み合わせ

例えば、成績（grades）テーブルから得点（score）の高い順に上位3件を取得するには：

```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 3;
```

実行結果：

| student_id | course_id | grade_type | score | max_score | submission_date |
|------------|-----------|------------|-------|-----------|-----------------|
| 311        | 1         | 中間テスト | 95.0  | 100.0     | 2025-05-20      |
| 320        | 1         | 中間テスト | 93.5  | 100.0     | 2025-05-20      |
| 302        | 1         | 中間テスト | 92.0  | 100.0     | 2025-05-20      |

### 例3：最新のレコードを取得

日付でソートして最新のデータを取得することもよくあります。例えば、最新の3つの授業スケジュールを取得するには：

```sql
SELECT * FROM course_schedule 
ORDER BY schedule_date DESC LIMIT 3;
```

実行結果：

| schedule_id | course_id | schedule_date | period_id | classroom_id | teacher_id | status    |
|-------------|-----------|---------------|-----------|--------------|------------|-----------|
| 95          | 28        | 2026-12-21    | 3         | 202D         | 119        | scheduled |
| 94          | 1         | 2026-12-21    | 1         | 102B         | 101        | scheduled |
| 93          | 14        | 2026-12-15    | 4         | 202D         | 110        | scheduled |

## OFFSETとページネーション

Webアプリケーションなどでは、大量のデータを「ページ」に分けて表示することがよくあります（ページネーション）。この機能を実現するためには、「OFFSET」（オフセット）という機能が必要です。

> **用語解説**：
> - **OFFSET**：「ずらす」という意味で、結果セットの先頭から指定した数だけ行をスキップします。
> - **ページネーション**：大量のデータを複数のページに分割して表示する技術です。

### 基本構文（MySQL/MariaDB）

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT 件数 OFFSET スキップ数;
```

または、短縮形として：

```sql
SELECT カラム名 FROM テーブル名 [WHERE 条件] [ORDER BY 並び順] LIMIT スキップ数, 件数;
```

### 例4：OFFSETを使ったスキップ

例えば、学生（students）テーブルから6番目から10番目までの学生を取得するには：

```sql
SELECT * FROM students LIMIT 5 OFFSET 5;
```

または：

```sql
SELECT * FROM students LIMIT 5, 5;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 306        | 河田咲奈     |
| 307        | 織田柚夏     |
| 308        | 永田悦子     |
| 309        | 相沢吉夫     |
| 310        | 吉川伽羅     |

### 例5：ページネーションの実装

ページネーションを実装する場合、通常は以下の式を使ってOFFSETを計算します：

```
OFFSET = (ページ番号 - 1) × ページあたりの件数
```

例えば、1ページあたり10件表示で、3ページ目のデータを取得するには：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 10 OFFSET 20;
```

または：

```sql
SELECT * FROM students ORDER BY student_id LIMIT 20, 10;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 321        | 井上竜也     |
| 322        | 木村結衣     |
| 323        | 林正義       |
| 324        | 清水香織     |
| 325        | 山田翔太     |
| 326        | 葉山陽太     |
| 327        | 青山凛       |
| 328        | 沢村大和     |
| 329        | 白石優月     |
| 330        | 月岡星奈     |

## LIMIT句を使用する際の注意点

### 1. ORDER BYの重要性

LIMIT句を使用する場合、通常はORDER BY句も一緒に使うべきです。ORDER BYがなければ、どのレコードが取得されるかは保証されません。

```sql
-- 良い例：結果が予測可能
SELECT * FROM students ORDER BY student_id LIMIT 5;

-- 悪い例：結果が不確定
SELECT * FROM students LIMIT 5;
```

### 2. パフォーマンスへの影響

大規模なテーブルで大きなOFFSET値を使用すると、パフォーマンスが低下する可能性があります。これは、データベースがOFFSET分のレコードを読み込んでから破棄する必要があるためです。

### 3. データベース製品による構文の違い

LIMIT句の構文はデータベース製品によって異なります：

- **MySQL/MariaDB/SQLite**：`LIMIT 件数 OFFSET スキップ数` または `LIMIT スキップ数, 件数`
- **PostgreSQL**：`LIMIT 件数 OFFSET スキップ数`
- **Oracle**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY`
- **SQL Server**：`OFFSET スキップ数 ROWS FETCH NEXT 件数 ROWS ONLY` または旧バージョンでは `TOP`句

この章では主にMySQL/MariaDBの構文を使用します。

## 実践的なページネーションの実装

実際のアプリケーションでページネーションを実装する場合、以下のようなコードになります（疑似コード）：

```
ページ番号 = URLから取得またはデフォルト値（例：1）
1ページあたりの件数 = 設定値（例：10）
総レコード数 = SELECTで取得（COUNT(*)を使用）
総ページ数 = CEILING(総レコード数 ÷ 1ページあたりの件数)
OFFSET = (ページ番号 - 1) × 1ページあたりの件数

SQLクエリ = "SELECT * FROM テーブル ORDER BY カラム LIMIT " + 1ページあたりの件数 + " OFFSET " + OFFSET
```

### 例6：総レコード数と総ページ数の取得

総レコード数を取得するには：

```sql
SELECT COUNT(*) AS total_records FROM students;
```

実行結果：

| total_records |
|---------------|
| 100           |

この場合、1ページあたり10件表示なら、総ページ数は10ページ（CEILING(100 ÷ 10)）になります。

## 練習問題

### 問題8-1
grades（成績）テーブルから、得点（score）の高い順に上位5件の成績レコードを取得するSQLを書いてください。

### 問題8-2
course_schedule（授業カレンダー）テーブルから、日付（schedule_date）の新しい順に3件のスケジュールを取得するSQLを書いてください。

### 問題8-3
students（学生）テーブルを学生ID（student_id）の昇順で並べ、11番目から15番目までの学生（5件）を取得するSQLを書いてください。

### 問題8-4
teachers（教師）テーブルから、教師名（teacher_name）の五十音順で6番目から10番目までの教師情報を取得するSQLを書いてください。

### 問題8-5
1ページあたり20件表示で、grades（成績）テーブルの3ページ目のデータを得点（score）の高い順に取得するSQLを書いてください。

### 問題8-6
course_schedule（授業カレンダー）テーブルから、状態（status）が「scheduled」のスケジュールを日付（schedule_date）の昇順で並べ、先頭から10件スキップして次の5件を取得するSQLを書いてください。

## 解答

### 解答8-1
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 5;
```

### 解答8-2
```sql
SELECT * FROM course_schedule ORDER BY schedule_date DESC LIMIT 3;
```

### 解答8-3
```sql
SELECT * FROM students ORDER BY student_id LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM students ORDER BY student_id LIMIT 10, 5;
```

### 解答8-4
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5 OFFSET 5;
```
または
```sql
SELECT * FROM teachers ORDER BY teacher_name LIMIT 5, 5;
```

### 解答8-5
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 20 OFFSET 40;
```
または
```sql
SELECT * FROM grades ORDER BY score DESC LIMIT 40, 20;
```

### 解答8-6
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 5 OFFSET 10;
```
または
```sql
SELECT * FROM course_schedule 
WHERE status = 'scheduled' 
ORDER BY schedule_date 
LIMIT 10, 5;
```

## まとめ

この章では、クエリ結果の件数を制限するためのLIMIT句と、ページネーションの実装方法について学びました：

1. **LIMIT句の基本**：指定した件数だけのレコードを取得する方法
2. **ORDER BYとの組み合わせ**：順序付けされた結果から一部だけを取得する方法
3. **OFFSET**：結果の先頭から指定した数だけレコードをスキップする方法
4. **ページネーション**：大量のデータを複数のページに分けて表示する実装方法
5. **注意点**：LIMIT句を使用する際の留意事項
6. **データベース製品による違い**：異なるデータベースでの構文の違い

LIMIT句は特にWebアプリケーションの開発で重要な機能です。大量のデータを効率よく表示するためのページネーション機能を実装するために欠かせません。また、トップN（上位N件）やボトムN（下位N件）のデータを取得する際にも使われます。

次の章では、データの集計分析を行うための「集計関数：COUNT、SUM、AVG、MAX、MIN」について学びます。





