# 10-1. パフォーマンス最適化：効率的なクエリの書き方

## はじめに

これまでの章でSQLの基本的な書き方を学びました。この章では、実際の業務でデータベースを効率よく使うための「パフォーマンス最適化」について学びます。

データベースが大きくなったり、ユーザーが増えたりすると、SQLクエリの実行速度が遅くなることがあります。このような問題を解決するために、効率的なクエリの書き方を身につけることが重要です。

> **用語解説**：
> - **パフォーマンス最適化**：プログラムやシステムの動作速度を向上させるための改善作業です。
> - **クエリ**：データベースに対する問い合わせのことで、SELECT文などのSQL文を指します。
> - **実行速度**：SQLが処理される速さのことで、通常は秒数やミリ秒で測定されます。

## ケーススタディ1：インデックスを活用した検索の高速化

### 問題状況

学校データベースで「特定の教師が担当する講座」を検索するクエリが遅いという問題が発生しました。

```sql
-- 遅いクエリの例
SELECT * FROM courses WHERE teacher_id = 105;
```

このクエリは、教師テーブルに10,000件のデータがある場合、すべてのレコードを順番に確認する必要があり、時間がかかります。

### 解決方法：インデックスの活用

**インデックス**とは、データベースの検索を高速化するための仕組みです。本の索引のように、データの場所を素早く見つけることができます。

> **用語解説**：
> - **インデックス**：データベースのテーブルに対して作成される「検索の目印」です。本の索引と同じように、データを素早く見つけるために使われます。

```sql
-- teacher_idにインデックスを作成
CREATE INDEX idx_teacher_id ON courses(teacher_id);

-- これで同じクエリが高速化される
SELECT * FROM courses WHERE teacher_id = 105;
```

**効果**：
- 検索時間が大幅に短縮される
- 大量のデータがあっても検索速度が維持される

**注意点**：
- インデックスはデータの更新時に時間がかかる場合がある
- ストレージ容量を多く使用する

### 実践例：複合インデックス

複数のカラムを組み合わせた検索でも、インデックスを活用できます。

```sql
-- 日付と時限の組み合わせでよく検索する場合
CREATE INDEX idx_date_period ON course_schedule(schedule_date, period_id);

-- このクエリが高速化される
SELECT * FROM course_schedule 
WHERE schedule_date = '2025-05-20' AND period_id = 1;
```

## ケーススタディ2：適切なJOINの使用

### 問題状況

学生の成績情報と講座名を一緒に表示したいが、以下のような非効率なクエリを使用していました。

```sql
-- 非効率なクエリ例（サブクエリの多用）
SELECT student_id, score,
       (SELECT course_name FROM courses WHERE course_id = grades.course_id) AS course_name
FROM grades
WHERE score >= 80;
```

このクエリは、成績レコードの数だけサブクエリが実行されるため、非常に遅くなります。

> **用語解説**：
> - **サブクエリ**：SQL文の中に含まれる別の完全なSQL文のことです。
> - **JOIN**：複数のテーブルを結合してデータを取得する方法です。

### 解決方法：JOINの使用

```sql
-- 効率的なクエリ（JOINを使用）
SELECT g.student_id, g.score, c.course_name
FROM grades g
JOIN courses c ON g.course_id = c.course_id
WHERE g.score >= 80;
```

**効果**：
- サブクエリの繰り返し実行が避けられる
- データベースエンジンが最適化された結合処理を行う
- 大幅な速度向上が期待できる

### 実践例：適切なJOINの選択

```sql
-- 内部結合（INNER JOIN）- 両方のテーブルにデータがある場合のみ
SELECT s.student_name, g.score, c.course_name
FROM students s
INNER JOIN student_courses sc ON s.student_id = sc.student_id
INNER JOIN courses c ON sc.course_id = c.course_id
INNER JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id;

-- 左外部結合（LEFT JOIN）- 学生情報は全て表示、成績は有無を問わない
SELECT s.student_name, g.score
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id;
```

## ケーススタディ3：WHERE句の最適化

### 問題状況

以下のようなクエリで、条件の順序が効率的でない場合があります。

```sql
-- 最適化前：関数を使った条件
SELECT * FROM course_schedule 
WHERE YEAR(schedule_date) = 2025 AND teacher_id = 101;
```

この例では、`YEAR(schedule_date)`という関数を使っているため、インデックスが使用されません。

### 解決方法：条件の書き換え

```sql
-- 最適化後：範囲指定を使用
SELECT * FROM course_schedule 
WHERE schedule_date >= '2025-01-01' 
  AND schedule_date < '2026-01-01' 
  AND teacher_id = 101;
```

**改善のポイント**：
- 関数を使わずに範囲指定を使用
- インデックスが活用できるようになる
- より限定的な条件（teacher_id）を先に書く

### 実践例：効率的な条件の書き方

```sql
-- 良い例：限定的な条件を先に書く
SELECT * FROM grades 
WHERE course_id = '1'        -- 限定的（特定の講座）
  AND score >= 90            -- より広範囲（高得点）
  AND grade_type = '中間テスト';

-- 悪い例：LIKE演算子の前方一致以外
SELECT * FROM students 
WHERE student_name LIKE '%田%';  -- 中間一致は遅い

-- 良い例：前方一致を使用
SELECT * FROM students 
WHERE student_name LIKE '田%';   -- 前方一致は比較的高速
```

## ケーススタディ4：LIMIT句の効果的な使用

### 問題状況

管理画面で成績上位者を表示したいが、全データを取得してから並べ替えていました。

```sql
-- 非効率な例：全データを取得
SELECT * FROM grades ORDER BY score DESC;
-- アプリケーション側で上位10件を表示
```

### 解決方法：LIMIT句の使用

```sql
-- 効率的な例：必要な分だけ取得
SELECT student_id, course_id, score 
FROM grades 
ORDER BY score DESC 
LIMIT 10;
```

**効果**：
- ネットワーク転送量の削減
- メモリ使用量の削減
- 応答速度の向上

### 実践例：ページネーション

```sql
-- 1ページ目（1-10位）
SELECT student_id, course_id, score 
FROM grades 
ORDER BY score DESC 
LIMIT 10 OFFSET 0;

-- 2ページ目（11-20位）
SELECT student_id, course_id, score 
FROM grades 
ORDER BY score DESC 
LIMIT 10 OFFSET 10;
```

## ケーススタディ5：集計処理の最適化

### 問題状況

各講座の受講者数を計算するのに時間がかかっています。

```sql
-- 非効率な例：サブクエリで個別計算
SELECT course_id, course_name,
       (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) AS student_count
FROM courses c;
```

### 解決方法：GROUP BYの使用

```sql
-- 効率的な例：GROUP BYで一括集計
SELECT c.course_id, c.course_name, COUNT(sc.student_id) AS student_count
FROM courses c
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name;
```

**効果**：
- サブクエリの繰り返し実行を回避
- データベースエンジンの集計機能を活用
- 大幅な性能向上

### 実践例：条件付き集計

```sql
-- 各講座の成績分布を効率的に取得
SELECT course_id,
       COUNT(*) AS total_grades,
       COUNT(CASE WHEN score >= 90 THEN 1 END) AS excellent_count,
       COUNT(CASE WHEN score >= 80 THEN 1 END) AS good_count,
       AVG(score) AS average_score
FROM grades
GROUP BY course_id;
```

## ケーススタディ6：EXISTSとINの使い分け

### 問題状況

「成績データがある学生」を取得したいが、どちらの書き方が効率的か分からない。

```sql
-- パターン1：IN句を使用
SELECT * FROM students 
WHERE student_id IN (SELECT student_id FROM grades);

-- パターン2：EXISTS句を使用
SELECT * FROM students s
WHERE EXISTS (SELECT 1 FROM grades g WHERE g.student_id = s.student_id);
```

### 解決方法：適切な使い分け

**INを使う場合**：
- サブクエリの結果が少ない場合
- サブクエリにNULL値が含まれない場合

**EXISTSを使う場合**：
- サブクエリの結果が多い場合
- サブクエリの結果の存在だけを確認したい場合

```sql
-- 推奨：EXISTSを使用（通常はこちらが効率的）
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1 FROM grades g 
    WHERE g.student_id = s.student_id 
    AND g.score >= 80
);
```

## パフォーマンス測定のヒント

### 実行計画の確認

```sql
-- クエリの実行計画を確認（MySQL）
EXPLAIN SELECT * FROM courses WHERE teacher_id = 105;
```

実行計画では以下の項目を確認します：
- **type**: 結合タイプ（ALL, index, range, ref等）
- **key**: 使用されているインデックス
- **rows**: 処理対象の推定行数

> **用語解説**：
> - **実行計画**：データベースがクエリをどのように処理するかの計画書です。処理速度の改善点を見つけるために使います。

### 実行時間の測定

```sql
-- 実行時間を測定する設定（MySQL）
SET profiling = 1;

-- クエリを実行
SELECT * FROM courses WHERE teacher_id = 105;

-- 実行時間を確認
SHOW PROFILES;
```

## まとめ：効率的なクエリを書くための原則

1. **インデックスを活用する**
   - 検索条件によく使われるカラムにインデックスを作成
   - WHERE句の条件がインデックスを使えるように書く

2. **適切なJOINを使用する**
   - サブクエリよりもJOINを優先する
   - 必要なデータだけを結合する

3. **条件を効率的に書く**
   - 限定的な条件を先に書く
   - 関数の使用を避ける
   - 前方一致のLIKEを使用する

4. **必要なデータだけを取得する**
   - SELECT *を避けて、必要なカラムだけを指定
   - LIMIT句を適切に使用する

5. **集計処理を最適化する**
   - GROUP BYを活用する
   - サブクエリの繰り返し実行を避ける

これらの原則を意識することで、データベースの性能を大幅に改善することができます。実際の業務では、データ量やアクセスパターンに応じて最適な手法を選択することが重要です。