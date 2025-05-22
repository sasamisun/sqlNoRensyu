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
