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
