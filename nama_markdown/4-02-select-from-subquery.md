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
