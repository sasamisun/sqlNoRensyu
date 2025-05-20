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
