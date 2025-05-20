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
