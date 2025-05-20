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
