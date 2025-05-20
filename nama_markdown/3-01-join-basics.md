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
