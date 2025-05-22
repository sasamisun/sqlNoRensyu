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
