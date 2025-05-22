# 21. 集合演算：UNION、INTERSECT、EXCEPT

## はじめに

これまでの章では、サブクエリや相関サブクエリを使用して複雑なデータ検索を行う方法を学びました。SQLにはもう一つの強力な技術があります。それが「集合演算」です。

集合演算とは、複数のSELECT文の結果を結合したり、比較したりする操作のことです。例えば以下のようなケースで活用できます：
- 「複数の検索条件の結果を一つにまとめたい」
- 「二つの検索結果の共通部分だけを抽出したい」
- 「ある条件の結果から別の条件の結果を除外したい」

この章では、主要な集合演算（UNION、INTERSECT、EXCEPT）の基本概念と実践的な使用方法について学びます。

## 集合演算とは

集合演算とは、複数のクエリ結果を数学的な「集合」として扱い、それらを組み合わせる操作のことです。主な集合演算には以下の3種類があります：

> **用語解説**：
> - **集合演算**：複数のSELECT文の結果を集合として扱い、合成する演算のことです。
> - **UNION（和集合）**：二つのクエリ結果を結合し、重複を排除した結果を返します。
> - **INTERSECT（積集合）**：二つのクエリ結果の共通部分のみを返します。
> - **EXCEPT（差集合）**：一つ目のクエリ結果から二つ目のクエリ結果に含まれるレコードを除外した結果を返します。

## 集合演算の基本規則

集合演算を使用する際には、以下の基本規則に従う必要があります：

1. **カラム数の一致**：集合演算で結合する各SELECT文は、同じ数のカラムを持つ必要があります。
2. **データ型の互換性**：対応するカラムは互換性のあるデータ型である必要があります。
3. **カラム名**：最終的な結果のカラム名は、最初のSELECT文で指定されたものが使用されます。
4. **ORDER BY**：集合演算の結果全体に対して一番最後に一度だけ指定できます。
5. **NULL値**：集合演算においてNULL値も通常の値として扱われます。

## UNION（和集合）

UNIONは、二つ以上のクエリ結果を結合し、重複を排除した結果を返します。

> **用語解説**：
> - **UNION**：複数のSELECT文の結果を結合し、重複を排除する演算子です。
> - **UNION ALL**：複数のSELECT文の結果を結合し、重複を排除せずにすべての行を返す演算子です。

### 基本構文

```sql
SELECT カラム1, カラム2, ...
FROM テーブル1
WHERE 条件1

UNION

SELECT カラム1, カラム2, ...
FROM テーブル2
WHERE 条件2;
```

### 例1：UNIONの基本

ITかAI関連の講座を受講している学生の一覧を取得するクエリ：

```sql
-- ITのための基礎知識を受講している学生
SELECT s.student_id, s.student_name, '1' AS course_id, 'ITのための基礎知識' AS course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '1'

UNION

-- AI・機械学習入門を受講している学生
SELECT s.student_id, s.student_name, '7' AS course_id, 'AI・機械学習入門' AS course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '7'

ORDER BY student_id;
```

実行結果（一部）：

| student_id | student_name | course_id | course_name        |
|------------|--------------|-----------|-------------------|
| 301        | 黒沢春馬     | 1         | ITのための基礎知識  |
| 302        | 新垣愛留     | 1         | ITのための基礎知識  |
| 302        | 新垣愛留     | 7         | AI・機械学習入門    |
| 303        | 柴崎春花     | 1         | ITのための基礎知識  |
| 305        | 河口菜恵子   | 7         | AI・機械学習入門    |
| ...        | ...          | ...       | ...               |

このクエリでは、講座ID=1（ITのための基礎知識）または講座ID=7（AI・機械学習入門）を受講している学生をUNIONで結合しています。ある学生が両方の講座を受講している場合（例：302の新垣愛留）、その学生は両方の講座で結果に含まれます。

### 例2：UNION ALLを使用した重複を許容する例

```sql
-- 出席率が高い学生（90%以上）
SELECT s.student_id, s.student_name, '高出席率' AS category
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(CASE WHEN a.status = 'present' THEN 100 ELSE 0 END) >= 90

UNION ALL

-- 成績が優秀な学生（85点以上）
SELECT s.student_id, s.student_name, '高成績' AS category
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(g.score) >= 85

ORDER BY category, student_id;
```

このクエリでは、出席率の高い学生と成績が優秀な学生を `UNION ALL` で結合しています。`UNION ALL` は重複を排除しないため、ある学生が両方の条件を満たす場合、結果に2回含まれます（出席率が高く、かつ成績も優秀な学生）。

実行結果（一部）：

| student_id | student_name | category |
|------------|--------------|----------|
| 301        | 黒沢春馬     | 高出席率  |
| 302        | 新垣愛留     | 高出席率  |
| 307        | 織田柚夏     | 高出席率  |
| 302        | 新垣愛留     | 高成績    |
| 308        | 永田悦子     | 高成績    |
| 311        | 鈴木健太     | 高成績    |
| ...        | ...          | ...      |

### UNIONとUNION ALLの違い

- **UNION**：重複する行を排除します（重複チェックのためにソートが行われるため、パフォーマンスへの影響があります）。
- **UNION ALL**：重複する行もすべて保持します（ソートが不要なため、通常UNIONより高速です）。

重複を排除する必要がなければ、パフォーマンスの観点から`UNION ALL`を使用する方が好ましいことが多いです。

## INTERSECT（積集合）

INTERSECTは、二つのクエリ結果の共通部分（両方のクエリ結果に含まれる行）のみを返します。

> **用語解説**：
> - **INTERSECT**：二つのSELECT文の結果の共通部分のみを返す演算子です。

### 基本構文

```sql
SELECT カラム1, カラム2, ...
FROM テーブル1
WHERE 条件1

INTERSECT

SELECT カラム1, カラム2, ...
FROM テーブル2
WHERE 条件2;
```

### 例3：INTERSECTの基本

ITの基礎知識とAI・機械学習入門の両方を受講している学生を検索：

```sql
-- ITのための基礎知識を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '1'

INTERSECT

-- AI・機械学習入門を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '7'

ORDER BY student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 302        | 新垣愛留     |
| 310        | 吉川伽羅     |
| 315        | 遠藤勇気     |
| ...        | ...          |

このクエリでは、講座ID=1と講座ID=7の両方を受講している学生のみが結果に含まれます。

### 例4：複数条件の共通部分

中間テストとレポート1の両方で85点以上を取得した学生を検索：

```sql
-- 中間テストで85点以上の学生
SELECT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = '中間テスト' AND g.score >= 85

INTERSECT

-- レポート1で85点以上の学生
SELECT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = 'レポート1' AND g.score >= 85

ORDER BY student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 302        | 新垣愛留     |
| 308        | 永田悦子     |
| 311        | 鈴木健太     |
| ...        | ...          |

## EXCEPT（差集合）

EXCEPTは、最初のクエリ結果から2番目のクエリ結果に含まれる行を除外した結果を返します。

> **用語解説**：
> - **EXCEPT**：一つ目のSELECT文の結果から二つ目のSELECT文の結果に含まれる行を除外する演算子です。一部のデータベース（例：Oracle）では、MINUS演算子が同じ目的で使用されます。

### 基本構文

```sql
SELECT カラム1, カラム2, ...
FROM テーブル1
WHERE 条件1

EXCEPT

SELECT カラム1, カラム2, ...
FROM テーブル2
WHERE 条件2;
```

### 例5：EXCEPTの基本

ITのための基礎知識は受講しているが、AI・機械学習入門は受講していない学生を検索：

```sql
-- ITのための基礎知識を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '1'

EXCEPT

-- AI・機械学習入門を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '7'

ORDER BY student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 303        | 柴崎春花     |
| 306        | 河田咲奈     |
| ...        | ...          |

このクエリでは、講座ID=1を受講しているが、講座ID=7は受講していない学生だけが結果に含まれます。

### 例6：除外条件を使った検索

出席記録はあるが、成績記録がない学生を検索：

```sql
-- 出席記録がある学生
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN attendance a ON s.student_id = a.student_id

EXCEPT

-- 成績記録がある学生
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id

ORDER BY student_id;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 312        | 佐々木優斗   |
| 317        | 長谷川結衣   |
| 321        | 西山太一     |
| ...        | ...          |

## 集合演算子の組み合わせ

複数の集合演算子を組み合わせて使用することもできます。その場合、括弧（）を使用して演算の優先順位を明確にしましょう。

### 例7：集合演算子の組み合わせ

IT関連の講座か、クラウド関連の講座を受講していて、かつプログラミング関連の講座は受講していない学生を検索：

```sql
-- IT関連の講座を受講している学生
(SELECT DISTINCT s.student_id, s.student_name
 FROM students s
 JOIN student_courses sc ON s.student_id = sc.student_id
 WHERE sc.course_id IN ('1', '7')  -- ITの基礎知識またはAI・機械学習入門

 UNION

 -- クラウド関連の講座を受講している学生
 SELECT DISTINCT s.student_id, s.student_name
 FROM students s
 JOIN student_courses sc ON s.student_id = sc.student_id
 WHERE sc.course_id IN ('9', '16'))  -- クラウドコンピューティングまたはクラウドネイティブアーキテクチャ

EXCEPT

-- プログラミング関連の講座を受講している学生
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id IN ('3', '4', '8');  -- Cプログラミングまたはウェブアプリまたはモバイルアプリ

```

このクエリでは：
1. まず、IT関連またはクラウド関連の講座を受講している学生を`UNION`で結合
2. 次に、プログラミング関連の講座を受講している学生を`EXCEPT`で除外

## 集合演算を使用する状況

集合演算は以下のような状況で特に役立ちます：

1. **複数の条件を満たすレコードの検索**：
   - 複数の条件すべてを満たすレコード（`INTERSECT`）
   - いずれかの条件を満たすレコード（`UNION`）
   - 特定の条件は満たすが別の条件は満たさないレコード（`EXCEPT`）

2. **異なるテーブルからの類似データの結合**：
   - 構造は同じだが別々のテーブルにあるデータを結合する（例：アーカイブと現行データ）

3. **複雑なレポート作成**：
   - 複数のカテゴリを含むレポート作成
   - 異なる条件のデータを一つのレポートにまとめる

4. **差分分析**：
   - 二つのデータセット間の違いを特定する（例：前月と今月の比較）

## 集合演算とサブクエリやJOINの比較

集合演算に代わる方法として、サブクエリやJOINを使用することも可能な場合があります。以下に、それぞれの方法の比較を示します：

### 例8：集合演算とサブクエリの比較

**集合演算を使う場合（INTERSECT）**：
```sql
-- 中間テストで85点以上の学生
SELECT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = '中間テスト' AND g.score >= 85

INTERSECT

-- レポート1で85点以上の学生
SELECT s.student_id, s.student_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade_type = 'レポート1' AND g.score >= 85;
```

**サブクエリを使う場合（IN）**：
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT g1.student_id
    FROM grades g1
    WHERE g1.grade_type = '中間テスト' AND g1.score >= 85
)
AND s.student_id IN (
    SELECT g2.student_id
    FROM grades g2
    WHERE g2.grade_type = 'レポート1' AND g2.score >= 85
);
```

**JOINを使う場合**：
```sql
SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN grades g1 ON s.student_id = g1.student_id
JOIN grades g2 ON s.student_id = g2.student_id
WHERE g1.grade_type = '中間テスト' AND g1.score >= 85
AND g2.grade_type = 'レポート1' AND g2.score >= 85;
```

### 使い分けの基準：

1. **集合演算が適している場合**：
   - クエリが概念的に「和集合」「積集合」「差集合」として考えやすい場合
   - 複数の異なるクエリ結果を組み合わせる場合
   - クエリが複雑で、分割して考えた方が理解しやすい場合

2. **サブクエリが適している場合**：
   - 一方のクエリ結果がフィルタとして使用される場合
   - EXISTS/NOT EXISTSでの存在チェックが必要な場合
   - 相関サブクエリで行ごとの条件チェックが必要な場合

3. **JOINが適している場合**：
   - 複数のテーブルからの情報を組み合わせて表示する場合
   - 結合条件が明確で、パフォーマンスが重要な場合
   - 追加の集計や条件が必要な場合

## 集合演算のパフォーマンスと注意点

集合演算を使用する際の主な注意点は以下の通りです：

1. **ソーティングコスト**：
   - `UNION`、`INTERSECT`、`EXCEPT`は重複排除のためのソートが必要なため、大きなデータセットでは処理が遅くなる可能性があります。
   - 重複排除が不要な場合は`UNION ALL`を使用すると効率的です。

2. **メモリ消費**：
   - 大きなデータセットを結合する場合、メモリ消費が大きくなることがあります。
   - 特に、`INTERSECT`と`EXCEPT`は両方のクエリ結果を一時的に保存する必要があります。

3. **クエリの最適化**：
   - 大きなデータセットの集合演算では、各SELECT文を最適化して、必要最小限のデータだけを処理するようにしましょう。
   - 可能な限り、集合演算の前に条件でフィルタリングして結果セットを小さくしましょう。

4. **代替手段の検討**：
   - 同じ結果を得るためのJOINや条件式など、より効率的な方法がないか検討しましょう。
   - 特にパフォーマンスが重要な場合は、実行計画を比較して最適な方法を選択しましょう。

## 練習問題

### 問題21-1
UNION演算子を使用して、「ITのための基礎知識」（course_id = 1）と「データベース設計と実装」（course_id = 5）のいずれかを受講している学生の一覧を取得するSQLを書いてください。結果には学生ID、学生名、講座名を含めてください。

### 問題21-2
INTERSECT演算子を使用して、「Webアプリケーション開発」（course_id = 4）と「モバイルアプリ開発」（course_id = 8）の両方を受講している学生の一覧を取得するSQLを書いてください。

### 問題21-3
EXCEPT演算子を使用して、「プロジェクト管理手法」（course_id = 10）は受講しているが、「UNIX入門」（course_id = 2）は受講していない学生の一覧を取得するSQLを書いてください。

### 問題21-4
UNION ALL演算子を使用して、出席率（status = 'present'の割合）が85%以上の学生と、平均点が85点以上の学生をそれぞれ「高出席」「高成績」のカテゴリー別に一覧表示し、同じ学生が両方の条件を満たす場合は両方のカテゴリーに表示されるようにするSQLを書いてください。

### 問題21-5
UNION、INTERSECTおよびEXCEPT演算子を組み合わせて、次の条件を満たす学生の一覧を取得するSQLを書いてください：
- 「データベース設計と実装」または「データ分析と可視化」を受講している
- 「プロジェクト管理手法」は受講していない
- 中間テストの成績が80点以上である

### 問題21-6
講座の組み合わせのうち、同じ学生が受講している頻度の高い組み合わせトップ5を見つけるために、INTERSECT演算子とUNION演算子を組み合わせたSQLを書いてください。結果には講座ID、講座名、受講者数を含めてください。

## 解答

### 解答21-1
```sql
-- ITのための基礎知識を受講している学生
SELECT s.student_id, s.student_name, c.course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE c.course_id = '1'

UNION

-- データベース設計と実装を受講している学生
SELECT s.student_id, s.student_name, c.course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE c.course_id = '5'

ORDER BY student_id;
```

### 解答21-2
```sql
-- Webアプリケーション開発を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '4'

INTERSECT

-- モバイルアプリ開発を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '8'

ORDER BY student_id;
```

### 解答21-3
```sql
-- プロジェクト管理手法を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '10'

EXCEPT

-- UNIX入門を受講している学生
SELECT s.student_id, s.student_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
WHERE sc.course_id = '2'

ORDER BY student_id;
```

### 解答21-4
```sql
-- 出席率が85%以上の学生
SELECT s.student_id, s.student_name, '高出席' AS category
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 85

UNION ALL

-- 平均点が85点以上の学生
SELECT s.student_id, s.student_name, '高成績' AS category
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(g.score) >= 85

ORDER BY student_id, category;
```

### 解答21-5
```sql
-- データベース設計と実装またはデータ分析と可視化を受講している学生
(SELECT DISTINCT s.student_id, s.student_name
 FROM students s
 JOIN student_courses sc ON s.student_id = sc.student_id
 WHERE sc.course_id IN ('5', '11'))

EXCEPT

-- プロジェクト管理手法を受講している学生
(SELECT s.student_id, s.student_name
 FROM students s
 JOIN student_courses sc ON s.student_id = sc.student_id
 WHERE sc.course_id = '10')

INTERSECT

-- 中間テストの成績が80点以上の学生
(SELECT s.student_id, s.student_name
 FROM students s
 JOIN grades g ON s.student_id = g.student_id
 WHERE g.grade_type = '中間テスト' AND g.score >= 80)

ORDER BY student_id;
```

### 解答21-6
```sql
WITH course_pairs AS (
    -- 講座ペアごとの受講学生数を計算
    SELECT 
        c1.course_id AS course_id1,
        c1.course_name AS course_name1,
        c2.course_id AS course_id2,
        c2.course_name AS course_name2,
        COUNT(*) AS common_students
    FROM courses c1
    JOIN student_courses sc1 ON c1.course_id = sc1.course_id
    JOIN student_courses sc2 ON sc1.student_id = sc2.student_id
    JOIN courses c2 ON sc2.course_id = c2.course_id
    WHERE c1.course_id < c2.course_id  -- 重複を避ける
    GROUP BY c1.course_id, c1.course_name, c2.course_id, c2.course_name
)
-- 上位5件を取得
SELECT 
    course_id1, 
    course_name1, 
    course_id2, 
    course_name2, 
    common_students AS 共通受講者数
FROM course_pairs
ORDER BY common_students DESC
LIMIT 5;
```

注：この解答の例は、共通テーブル式（WITH句）を使用しています。これは次の章で詳しく学習する内容ですが、ここでは効率的な解答のために先行して使用しています。

## まとめ

この章では、SQL集合演算について詳しく学びました：

1. **集合演算の基本概念**：
   - 複数のクエリ結果を集合として扱う演算
   - 集合演算を使用する際の基本規則（カラム数の一致、データ型の互換性など）

2. **UNION（和集合）**：
   - 複数のクエリ結果を結合し、重複を排除する方法
   - UNION ALLで重複を保持する方法
   - パフォーマンスの違いと使い分け

3. **INTERSECT（積集合）**：
   - 複数のクエリ結果の共通部分を抽出する方法
   - 複数条件をすべて満たすレコードの検索

4. **EXCEPT（差集合）**：
   - 一方のクエリ結果から他方のクエリ結果を除外する方法
   - 特定の条件を満たすが別の条件は満たさないレコードの検索

5. **集合演算子の組み合わせ**：
   - 複数の集合演算子を組み合わせた複雑な条件の表現
   - 括弧を使った演算優先順位の制御

6. **集合演算とサブクエリやJOINの比較**：
   - 同じ結果を得るための異なるアプローチ
   - 使い分けの基準

集合演算は、複雑なレポート作成や条件付きデータ分析において強力なツールとなります。適切に使用することで、複雑な条件を持つデータの抽出や異なるデータセットの比較が効率的に行えるようになります。

次の章では、「EXISTS演算子：存在確認のクエリ」について学び、レコードの存在確認に特化したSQLテクニックを深く理解していきます。
