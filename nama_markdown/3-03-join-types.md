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
