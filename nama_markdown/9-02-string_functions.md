# 9-2. 文字列操作：テキスト関数

## はじめに

データベースでは、テキスト（文字列）データを扱うことが非常に多くあります。学校データベースでも、学生名、教師名、講座名、コメントなど、様々な文字列データが保存されています。

これらの文字列データを効果的に操作するためのSQL関数を「文字列関数」または「テキスト関数」と呼びます。文字列関数を使うことで、以下のような作業を効率的に行うことができます：

- 「田中」という姓の学生を「田中さん」として表示する
- 講座名の最初の10文字だけを表示する
- 学生名から姓と名を分離する
- 大文字・小文字を統一して検索の精度を上げる
- 余分な空白を取り除いてデータを整理する

この章では、MySQLで使用できる主要な文字列関数について学び、実際の業務で役立つテキスト処理のテクニックを習得します。

> **用語解説**：
> - **文字列関数**：テキストデータを加工、検索、操作するための専用関数群です。
> - **テキスト処理**：文字列データを目的に応じて変換、抽出、結合などを行う作業のことです。

## 文字列の基本情報を取得する関数

### LENGTH()関数：文字列の長さを取得

文字列の文字数（バイト数）を取得するには`LENGTH()`関数を使います。

> **用語解説**：
> - **LENGTH()関数**：文字列の長さをバイト単位で返す関数です。日本語の場合、1文字が複数バイトになることがあります。

```sql
SELECT student_name,
       LENGTH(student_name) AS バイト数
FROM students
LIMIT 5;
```

実行結果：
| student_name | バイト数 |
|-------------|---------|
| 黒沢春馬     | 12      |
| 新垣愛留     | 12      |
| 柴崎春花     | 12      |
| 森下風凛     | 12      |
| 河口菜恵子   | 15      |

### CHAR_LENGTH()関数：文字数を取得

実際の文字数を取得するには`CHAR_LENGTH()`関数を使います。

> **用語解説**：
> - **CHAR_LENGTH()関数**：文字列の実際の文字数を返す関数です。日本語でも1文字は1としてカウントされます。

```sql
SELECT student_name,
       LENGTH(student_name) AS バイト数,
       CHAR_LENGTH(student_name) AS 文字数
FROM students
LIMIT 5;
```

実行結果：
| student_name | バイト数 | 文字数 |
|-------------|---------|--------|
| 黒沢春馬     | 12      | 4      |
| 新垣愛留     | 12      | 4      |
| 柴崎春花     | 12      | 4      |
| 森下風凛     | 12      | 4      |
| 河口菜恵子   | 15      | 5      |

## 文字列の抽出と部分取得

### SUBSTRING()関数：文字列の一部を抽出

文字列の指定した位置から指定した長さの部分を取り出すには`SUBSTRING()`関数を使います。

> **用語解説**：
> - **SUBSTRING()関数**：文字列の一部分を抽出する関数です。開始位置と長さを指定できます。

#### 基本構文

```sql
SUBSTRING(文字列, 開始位置, 長さ)
SUBSTRING(文字列, 開始位置)  -- 開始位置から最後まで
```

※ MySQLでは位置は1から始まります（0ではありません）

#### 例：文字列の部分抽出

```sql
SELECT course_name,
       SUBSTRING(course_name, 1, 10) AS 短縮名,
       SUBSTRING(course_name, 1, 5) AS 超短縮名
FROM courses
LIMIT 5;
```

実行結果：
| course_name           | 短縮名            | 超短縮名 |
|----------------------|------------------|---------|
| ITのための基礎知識     | ITのための基礎知識 | ITのた  |
| UNIX入門             | UNIX入門         | UNIX入 |
| Cプログラミング演習    | Cプログラミング演習 | Cプロ  |
| Webアプリケーション開発| Webアプリケーション開| Webア |
| データベース設計と実装 | データベース設計と実装| データ |

### LEFT()、RIGHT()関数：左端・右端から文字を取得

文字列の左端または右端から指定した文字数を取得するには`LEFT()`と`RIGHT()`関数を使います。

> **用語解説**：
> - **LEFT()関数**：文字列の左端（最初）から指定した文字数を取得する関数です。
> - **RIGHT()関数**：文字列の右端（最後）から指定した文字数を取得する関数です。

```sql
SELECT student_name,
       LEFT(student_name, 2) AS 姓,
       RIGHT(student_name, 2) AS 名
FROM students
WHERE CHAR_LENGTH(student_name) = 4
LIMIT 5;
```

実行結果：
| student_name | 姓 | 名 |
|-------------|----|----|
| 黒沢春馬     | 黒沢| 春馬|
| 新垣愛留     | 新垣| 愛留|
| 柴崎春花     | 柴崎| 春花|
| 森下風凛     | 森下| 風凛|

## 文字列の検索と位置特定

### LOCATE()関数：文字列の位置を検索

特定の文字列が何文字目にあるかを調べるには`LOCATE()`関数を使います。

> **用語解説**：
> - **LOCATE()関数**：指定した文字列が対象の文字列の何文字目にあるかを返す関数です。見つからない場合は0を返します。

#### 基本構文

```sql
LOCATE(検索文字列, 対象文字列)
LOCATE(検索文字列, 対象文字列, 開始位置)
```

#### 例：文字列の位置検索

```sql
SELECT course_name,
       LOCATE('プログラミング', course_name) AS プログラミングの位置,
       LOCATE('入門', course_name) AS 入門の位置
FROM courses
WHERE course_name LIKE '%プログラミング%' OR course_name LIKE '%入門%'
LIMIT 5;
```

実行結果：
| course_name              | プログラミングの位置 | 入門の位置 |
|-------------------------|------------------|----------|
| UNIX入門                | 0                | 5        |
| Cプログラミング演習       | 2                | 0        |
| JavaScript入門とDOM操作  | 0                | 11       |
| モバイルアプリ開発入門    | 0                | 11       |
| IoTデバイスプログラミング実践 | 8            | 0        |

## 文字列の変換と加工

### UPPER()、LOWER()関数：大文字・小文字変換

英字の大文字・小文字を変換するには`UPPER()`と`LOWER()`関数を使います。

> **用語解説**：
> - **UPPER()関数**：英字を大文字に変換する関数です。
> - **LOWER()関数**：英字を小文字に変換する関数です。

```sql
SELECT classroom_id,
       UPPER(classroom_id) AS 大文字,
       LOWER(classroom_id) AS 小文字
FROM classrooms
LIMIT 5;
```

実行結果：
| classroom_id | 大文字 | 小文字 |
|-------------|-------|-------|
| 101A        | 101A  | 101a  |
| 102B        | 102B  | 102b  |
| 201C        | 201C  | 201c  |
| 202D        | 202D  | 202d  |
| 301E        | 301E  | 301e  |

### TRIM()、LTRIM()、RTRIM()関数：空白の除去

文字列の前後や片側の空白を除去するには`TRIM()`、`LTRIM()`、`RTRIM()`関数を使います。

> **用語解説**：
> - **TRIM()関数**：文字列の前後の空白を除去する関数です。
> - **LTRIM()関数**：文字列の左側（前）の空白を除去する関数です。
> - **RTRIM()関数**：文字列の右側（後）の空白を除去する関数です。

```sql
-- 例：空白を含むデータの処理（実際のデータでテスト）
SELECT CONCAT('「', '  テスト文字列  ', '」') AS 元の文字列,
       CONCAT('「', TRIM('  テスト文字列  '), '」') AS TRIM後,
       CONCAT('「', LTRIM('  テスト文字列  '), '」') AS LTRIM後,
       CONCAT('「', RTRIM('  テスト文字列  '), '」') AS RTRIM後;
```

実行結果：
| 元の文字列              | TRIM後            | LTRIM後           | RTRIM後           |
|----------------------|------------------|------------------|------------------|
| 「  テスト文字列  」   | 「テスト文字列」   | 「テスト文字列  」 | 「  テスト文字列」 |

## 文字列の結合と分割

### CONCAT()関数：文字列の結合

複数の文字列を結合するには`CONCAT()`関数を使います。

> **用語解説**：
> - **CONCAT()関数**：複数の文字列を1つにつなげる関数です。「Concatenate（連結）」の略です。

```sql
SELECT teacher_name,
       CONCAT('講師：', teacher_name, '先生') AS 敬称付き名前,
       CONCAT('ID-', teacher_id, '：', teacher_name) AS ID付き名前
FROM teachers
LIMIT 5;
```

実行結果：
| teacher_name | 敬称付き名前      | ID付き名前          |
|-------------|-----------------|-------------------|
| 寺内鞍       | 講師：寺内鞍先生   | ID-101：寺内鞍      |
| 田尻朋美     | 講師：田尻朋美先生 | ID-102：田尻朋美    |
| 内村海凪     | 講師：内村海凪先生 | ID-103：内村海凪    |
| 藤本理恵     | 講師：藤本理恵先生 | ID-104：藤本理恵    |
| 黒木大介     | 講師：黒木大介先生 | ID-105：黒木大介    |

### CONCAT_WS()関数：区切り文字付き結合

区切り文字を指定して文字列を結合するには`CONCAT_WS()`関数を使います。

> **用語解説**：
> - **CONCAT_WS()関数**：「CONCAT With Separator」の略で、指定した区切り文字で複数の文字列を結合する関数です。

```sql
SELECT student_id,
       student_name,
       CONCAT_WS(' | ', student_id, student_name, '在籍中') AS 学生情報
FROM students
LIMIT 5;
```

実行結果：
| student_id | student_name | 学生情報                  |
|-----------|-------------|-------------------------|
| 301       | 黒沢春馬     | 301 | 黒沢春馬 | 在籍中     |
| 302       | 新垣愛留     | 302 | 新垣愛留 | 在籍中     |
| 303       | 柴崎春花     | 303 | 柴崎春花 | 在籍中     |
| 304       | 森下風凛     | 304 | 森下風凛 | 在籍中     |
| 305       | 河口菜恵子   | 305 | 河口菜恵子 | 在籍中   |

### SUBSTRING_INDEX()関数：区切り文字による分割

区切り文字を基準に文字列を分割するには`SUBSTRING_INDEX()`関数を使います。

> **用語解説**：
> - **SUBSTRING_INDEX()関数**：指定した区切り文字で文字列を分割し、指定した番目までの部分を返す関数です。

#### 基本構文

```sql
SUBSTRING_INDEX(文字列, 区切り文字, 番目)
```

- 正の数：左から数えて指定番目まで
- 負の数：右から数えて指定番目まで

#### 例：文字列の分割

```sql
-- 施設情報から最初の設備だけを取得
SELECT classroom_name,
       facilities,
       SUBSTRING_INDEX(facilities, '、', 1) AS 主要設備
FROM classrooms
WHERE facilities IS NOT NULL
LIMIT 5;
```

実行結果：
| classroom_name           | facilities                              | 主要設備    |
|-------------------------|-----------------------------------------|-----------|
| 1号館コンピュータ実習室A  | パソコン30台、プロジェクター              | パソコン30台 |
| 2号館コンピュータ実習室B  | パソコン25台、プロジェクター、大型モニター | パソコン25台 |
| 2号館コンピュータ実習室C  | パソコン25台、プロジェクター              | パソコン25台 |
| 2号館コンピュータ実習室D  | パソコン25台、プロジェクター、3Dプリンター | パソコン25台 |
| 3号館講義室E             | プロジェクター、マイク設備、録画設備       | プロジェクター |

## 文字列の置換と操作

### REPLACE()関数：文字列の置換

文字列の一部を別の文字列に置き換えるには`REPLACE()`関数を使います。

> **用語解説**：
> - **REPLACE()関数**：文字列内の指定した部分を別の文字列に置き換える関数です。

#### 基本構文

```sql
REPLACE(対象文字列, 検索文字列, 置換文字列)
```

#### 例：文字列の置換

```sql
SELECT course_name,
       REPLACE(course_name, '入門', 'ベーシック') AS 置換後の講座名
FROM courses
WHERE course_name LIKE '%入門%'
LIMIT 5;
```

実行結果：
| course_name                | 置換後の講座名                      |
|---------------------------|-----------------------------------|
| UNIX入門                  | UNIXベーシック                     |
| JavaScript入門とDOM操作    | JavaScriptベーシックとDOM操作       |
| モバイルアプリ開発入門      | モバイルアプリ開発ベーシック        |
| クラウドサービス入門       | クラウドサービスベーシック          |
| UI/UXデザイン入門         | UI/UXデザインベーシック            |

### REVERSE()関数：文字列の反転

文字列を逆順にするには`REVERSE()`関数を使います。

> **用語解説**：
> - **REVERSE()関数**：文字列の文字順序を逆にする関数です。

```sql
SELECT classroom_id,
       REVERSE(classroom_id) AS 逆順ID
FROM classrooms
LIMIT 5;
```

実行結果：
| classroom_id | 逆順ID |
|-------------|-------|
| 101A        | A101  |
| 102B        | B201  |
| 201C        | C102  |
| 202D        | D202  |
| 301E        | E103  |

## 文字列の比較とパターンマッチング

### STRCMP()関数：文字列の比較

2つの文字列を辞書順で比較するには`STRCMP()`関数を使います。

> **用語解説**：
> - **STRCMP()関数**：「String Compare」の略で、2つの文字列を比較する関数です。結果は-1、0、1のいずれかを返します。

戻り値：
- 0：両方の文字列が同じ
- -1：最初の文字列が2番目より小さい（辞書順で前）
- 1：最初の文字列が2番目より大きい（辞書順で後）

```sql
SELECT student_name,
       STRCMP(student_name, '田中太郎') AS 田中太郎との比較
FROM students
WHERE student_name IN ('田中太郎', '佐藤花子', '山田翔太')
LIMIT 3;
```

## 実践例：文字列関数を活用したクエリ

### 例1：学生名の姓と名を分離して表示

```sql
SELECT student_name,
       CASE 
         WHEN CHAR_LENGTH(student_name) = 4 THEN
           CONCAT(LEFT(student_name, 2), '・', RIGHT(student_name, 2))
         WHEN CHAR_LENGTH(student_name) = 5 THEN
           CONCAT(LEFT(student_name, 3), '・', RIGHT(student_name, 2))
         ELSE student_name
       END AS 姓名分離
FROM students
WHERE CHAR_LENGTH(student_name) IN (4, 5)
LIMIT 8;
```

### 例2：講座名の長さによる分類とタグ付け

```sql
SELECT course_name,
       CHAR_LENGTH(course_name) AS 文字数,
       CASE 
         WHEN CHAR_LENGTH(course_name) <= 10 THEN '[短]'
         WHEN CHAR_LENGTH(course_name) <= 15 THEN '[中]'
         ELSE '[長]'
       END AS 長さタグ,
       CONCAT(
         CASE 
           WHEN CHAR_LENGTH(course_name) <= 10 THEN '[短] '
           WHEN CHAR_LENGTH(course_name) <= 15 THEN '[中] '
           ELSE '[長] '
         END,
         course_name
       ) AS タグ付き講座名
FROM courses
ORDER BY CHAR_LENGTH(course_name)
LIMIT 5;
```

### 例3：コメントの要約作成

```sql
SELECT student_id,
       comment,
       CASE 
         WHEN comment IS NULL THEN '(コメントなし)'
         WHEN CHAR_LENGTH(comment) <= 10 THEN comment
         ELSE CONCAT(LEFT(comment, 10), '...')
       END AS コメント要約
FROM attendance
WHERE schedule_id = 1
LIMIT 5;
```

## 練習問題

### 問題9-2-1
students（学生）テーブルから、学生名の文字数とバイト数を取得し、文字数が4文字の学生のみを表示するSQLを書いてください。

### 問題9-2-2
courses（講座）テーブルから、講座名の最初の8文字と最後の3文字を表示するSQLを書いてください。

### 問題9-2-3
teachers（教師）テーブルから、教師名に「田」という文字が含まれる位置を表示するSQLを書いてください。

### 問題9-2-4
classrooms（教室）テーブルから、教室IDを大文字と小文字で表示し、「教室：」という文字を前に付けて表示するSQLを書いてください。

### 問題9-2-5
courses（講座）テーブルから、講座名に「プログラミング」という単語を「コーディング」に置き換えて表示するSQLを書いてください。

### 問題9-2-6
students（学生）テーブルから、学生IDと学生名を「ID：○○○、名前：○○」の形式で表示するSQLを書いてください。

### 問題9-2-7
classrooms（教室）テーブルから、施設情報（facilities）の最初の設備のみを抽出して表示するSQLを書いてください。（「、」で区切られている）

### 問題9-2-8
courses（講座）テーブルから、講座名の文字数が15文字を超える場合は最初の12文字に「...」を付けて表示し、15文字以下の場合はそのまま表示するSQLを書いてください。

### 問題9-2-9
students（学生）テーブルから、学生名を逆順にした文字列と、元の学生名を比較して同じかどうかを判定するSQLを書いてください。（回文の検出）

### 問題9-2-10
teachers（教師）テーブルとcourses（講座）テーブルを結合し、「○○先生が担当する『○○』講座」という形式で表示するSQLを書いてください。

## 解答と詳細な解説

### 解答9-2-1
```sql
SELECT student_name,
       CHAR_LENGTH(student_name) AS 文字数,
       LENGTH(student_name) AS バイト数
FROM students
WHERE CHAR_LENGTH(student_name) = 4;
```

**解説**：
- `CHAR_LENGTH()`で実際の文字数を取得
- `LENGTH()`でバイト数を取得（日本語は1文字3-4バイト）
- WHERE句で文字数が4文字の条件を指定
- 日本語の姓名は通常4文字（姓2文字+名2文字）が多いため、この条件で多くの学生が抽出される

### 解答9-2-2
```sql
SELECT course_name,
       LEFT(course_name, 8) AS 最初の8文字,
       RIGHT(course_name, 3) AS 最後の3文字
FROM courses;
```

**解説**：
- `LEFT(course_name, 8)`で文字列の左端から8文字を取得
- `RIGHT(course_name, 3)`で文字列の右端から3文字を取得
- 講座名が8文字未満の場合は、そのまま全体が表示される
- 講座名が3文字未満の場合も、そのまま全体が表示される

### 解答9-2-3
```sql
SELECT teacher_name,
       LOCATE('田', teacher_name) AS 田の位置,
       CASE 
         WHEN LOCATE('田', teacher_name) > 0 THEN
           CONCAT(LOCATE('田', teacher_name), '文字目に「田」があります')
         ELSE '「田」は含まれていません'
       END AS 結果
FROM teachers;
```

**解説**：
- `LOCATE('田', teacher_name)`で「田」の位置を検索
- 戻り値が0の場合は該当文字が見つからない
- CASE文で見つかった場合とそうでない場合の表示を分岐
- 位置は1から始まる（0ベースではない）

### 解答9-2-4
```sql
SELECT classroom_id,
       UPPER(classroom_id) AS 大文字,
       LOWER(classroom_id) AS 小文字,
       CONCAT('教室：', classroom_id) AS 教室表示
FROM classrooms;
```

**解説**：
- `UPPER()`で英字部分を大文字に変換
- `LOWER()`で英字部分を小文字に変換
- `CONCAT()`で「教室：」の文字列を前に結合
- 数字部分は大文字・小文字変換の影響を受けない

### 解答9-2-5
```sql
SELECT course_name,
       REPLACE(course_name, 'プログラミング', 'コーディング') AS 置換後の講座名
FROM courses;
```

**解説**：
- `REPLACE()`関数で「プログラミング」を「コーディング」に置換
- 該当する文字列がない場合は元の文字列がそのまま表示される
- 文字列内に複数の「プログラミング」がある場合は、すべて置換される
- 大文字・小文字を区別する（MySQLのデフォルト設定による）

### 解答9-2-6
```sql
SELECT student_id,
       student_name,
       CONCAT('ID：', student_id, '、名前：', student_name) AS 学生情報
FROM students;
```

**解説**：
- `CONCAT()`で複数の文字列と値を結合
- 数値である`student_id`も自動的に文字列として結合される
- 日本語の句読点（、）も正常に表示される
- より読みやすい形式でデータを表示できる

### 解答9-2-7
```sql
SELECT classroom_name,
       facilities,
       SUBSTRING_INDEX(facilities, '、', 1) AS 最初の設備
FROM classrooms
WHERE facilities IS NOT NULL;
```

**解説**：
- `SUBSTRING_INDEX()`で「、」を区切り文字として1番目までを取得
- つまり最初の「、」より前の部分を抽出
- `WHERE facilities IS NOT NULL`でNULL値を除外
- 施設情報がない教室は結果に含まれない

### 解答9-2-8
```sql
SELECT course_name,
       CHAR_LENGTH(course_name) AS 文字数,
       CASE 
         WHEN CHAR_LENGTH(course_name) > 15 THEN
           CONCAT(LEFT(course_name, 12), '...')
         ELSE course_name
       END AS 表示用講座名
FROM courses;
```

**解説**：
- `CHAR_LENGTH(course_name) > 15`で15文字を超えるかを判定
- 超える場合は`LEFT(course_name, 12)`で最初の12文字を取得し「...」を追加
- 15文字以下の場合は元の講座名をそのまま表示
- CASE文で条件分岐を明確に表現

### 解答9-2-9
```sql
SELECT student_name,
       REVERSE(student_name) AS 逆順名前,
       CASE 
         WHEN student_name = REVERSE(student_name) THEN '回文です'
         ELSE '回文ではありません'
       END AS 回文判定
FROM students;
```

**解説**：
- `REVERSE()`で文字列を逆順にする
- 元の文字列と逆順の文字列を比較
- 同じ場合は回文（前から読んでも後ろから読んでも同じ）
- 日本語の名前で回文になることは稀だが、データ処理の例として有用

### 解答9-2-10
```sql
SELECT t.teacher_name,
       c.course_name,
       CONCAT(t.teacher_name, '先生が担当する『', c.course_name, '』講座') AS 担当講座情報
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id;
```

**解説**：
- `JOIN`で教師テーブルと講座テーブルを結合
- `CONCAT()`で複数の要素を組み合わせて読みやすい文章を作成
- 『』で講座名を囲んで視認性を向上
- 実際の業務でよく使われる形式でデータを表示

## まとめ

この章では、MySQLにおける文字列操作について学びました：

1. **文字列の基本情報取得**：LENGTH()、CHAR_LENGTH()で長さを測定
2. **文字列の抽出**：SUBSTRING()、LEFT()、RIGHT()で部分文字列を取得
3. **文字列の検索**：LOCATE()で特定の文字列の位置を特定
4. **文字列の変換**：UPPER()、LOWER()で大文字・小文字変換、TRIM()で空白除去
5. **文字列の結合**：CONCAT()、CONCAT_WS()で複数の文字列を結合
6. **文字列の分割**：SUBSTRING_INDEX()で区切り文字による分割
7. **文字列の置換**：REPLACE()で特定の文字列を別の文字列に置換
8. **実践的な活用**：複数の関数を組み合わせた複雑なテキスト処理

文字列関数は、データの表示形式を整えたり、データクレンジング（データの清浄化）を行ったり、レポート作成時に読みやすい形式に変換したりする際に非常に重要な機能です。特に学校データベースのような多様なテキストデータを扱うシステムでは、これらの関数を効果的に使うことで、より使いやすく、理解しやすいデータ表示が可能になります。

次のセクションでは、「JSON：構造化データの格納と操作」について学び、より複雑なデータ構造を扱う技術を習得します。