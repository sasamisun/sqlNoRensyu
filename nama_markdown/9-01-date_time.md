# 9-1. 日付と時刻：日付関数と操作

## はじめに

データベースでは、日付や時刻の情報を扱うことが非常に多くあります。学校データベースでも、授業の開催日、成績の提出日、教師の休暇期間など、様々な場面で日付や時刻の情報が使われています。

SQLでは、日付や時刻を効率的に操作するための専用の関数が多数用意されています。これらの関数を使うことで、以下のような作業を簡単に行うことができます：

- 「今月開催される授業」を検索する
- 「提出期限まで残り何日か」を計算する
- 「曜日別の授業数」を集計する
- 「過去1年間の成績データ」を分析する

この章では、MySQLにおける日付と時刻の基本的な扱い方と、よく使われる日付関数について学びます。

## 日付と時刻のデータ型

MySQLでは、日付と時刻を扱うための複数のデータ型が用意されています：

> **用語解説**：
> - **データ型**：データベースがデータをどのような形式で保存するかを定義するもの。日付専用のデータ型を使うことで、日付の計算や比較が正確に行えます。

### 主要な日付・時刻データ型

| データ型     | 説明                           | 形式例                |
|-------------|--------------------------------|-----------------------|
| **DATE**    | 日付のみを格納                  | '2025-05-27'          |
| **TIME**    | 時刻のみを格納                  | '14:30:00'            |
| **DATETIME** | 日付と時刻の両方を格納          | '2025-05-27 14:30:00' |
| **TIMESTAMP** | 日付と時刻（タイムゾーン考慮）  | '2025-05-27 14:30:00' |
| **YEAR**    | 年のみを格納                    | 2025                  |

学校データベースでは、以下のような使い分けがされています：
- `course_schedule.schedule_date`：DATE型（授業の開催日）
- `class_periods.start_time`、`end_time`：TIME型（授業時間）
- `grades.submission_date`：DATE型（成績の提出日）
- `teacher_unavailability.start_date`、`end_date`：DATE型（教師の休暇期間）

## 現在の日付と時刻を取得する関数

### NOW()関数：現在の日付と時刻

現在の日付と時刻を取得するには`NOW()`関数を使います。

> **用語解説**：
> - **NOW()関数**：「今」という意味で、実行した瞬間の日付と時刻を返す関数です。

```sql
SELECT NOW() AS 現在の日時;
```

実行結果：
| 現在の日時              |
|------------------------|
| 2025-05-27 14:30:00    |

### CURDATE()関数：現在の日付のみ

現在の日付だけが必要な場合は`CURDATE()`関数を使います。

> **用語解説**：
> - **CURDATE()関数**：「Current Date」の略で、現在の日付のみを返す関数です。

```sql
SELECT CURDATE() AS 今日の日付;
```

実行結果：
| 今日の日付    |
|--------------|
| 2025-05-27   |

### CURTIME()関数：現在の時刻のみ

現在の時刻だけが必要な場合は`CURTIME()`関数を使います。

> **用語解説**：
> - **CURTIME()関数**：「Current Time」の略で、現在の時刻のみを返す関数です。

```sql
SELECT CURTIME() AS 現在の時刻;
```

実行結果：
| 現在の時刻   |
|-------------|
| 14:30:00    |

## 日付の各部分を取得する関数

日付から年、月、日などの特定の部分だけを取り出すことができます。

### YEAR()、MONTH()、DAY()関数

```sql
SELECT schedule_date,
       YEAR(schedule_date) AS 年,
       MONTH(schedule_date) AS 月,
       DAY(schedule_date) AS 日
FROM course_schedule
WHERE schedule_id <= 5;
```

実行結果：
| schedule_date | 年   | 月 | 日 |
|---------------|------|----|----|
| 2025-05-14    | 2025 | 5  | 14 |
| 2025-05-15    | 2025 | 5  | 15 |
| 2025-05-16    | 2025 | 5  | 16 |
| 2025-05-20    | 2025 | 5  | 20 |
| 2025-05-21    | 2025 | 5  | 21 |

### DAYNAME()、MONTHNAME()関数：曜日名と月名

```sql
SELECT schedule_date,
       DAYNAME(schedule_date) AS 曜日,
       MONTHNAME(schedule_date) AS 月名
FROM course_schedule
WHERE schedule_id <= 5;
```

実行結果：
| schedule_date | 曜日      | 月名 |
|---------------|-----------|------|
| 2025-05-14    | Wednesday | May  |
| 2025-05-15    | Thursday  | May  |
| 2025-05-16    | Friday    | May  |
| 2025-05-20    | Tuesday   | May  |
| 2025-05-21    | Wednesday | May  |

### DAYOFWEEK()、WEEKDAY()関数：曜日を数値で取得

> **用語解説**：
> - **DAYOFWEEK()関数**：曜日を1（日曜日）から7（土曜日）の数値で返します。
> - **WEEKDAY()関数**：曜日を0（月曜日）から6（日曜日）の数値で返します。

```sql
SELECT schedule_date,
       DAYOFWEEK(schedule_date) AS 曜日番号_日曜始まり,
       WEEKDAY(schedule_date) AS 曜日番号_月曜始まり
FROM course_schedule
WHERE schedule_id <= 3;
```

実行結果：
| schedule_date | 曜日番号_日曜始まり | 曜日番号_月曜始まり |
|---------------|-------------------|-------------------|
| 2025-05-14    | 4                 | 2                 |
| 2025-05-15    | 5                 | 3                 |
| 2025-05-16    | 6                 | 4                 |

## 日付の計算と操作

### DATE_ADD()、DATE_SUB()関数：日付の加算と減算

日付に特定の期間を足したり引いたりするには、`DATE_ADD()`と`DATE_SUB()`関数を使います。

> **用語解説**：
> - **DATE_ADD()関数**：指定した日付に期間を加算する関数です。
> - **DATE_SUB()関数**：指定した日付から期間を減算する関数です。
> - **INTERVAL**：期間を表すキーワードで、「1 DAY」「2 WEEK」「3 MONTH」のように使います。

#### 基本構文

```sql
DATE_ADD(日付, INTERVAL 数値 単位)
DATE_SUB(日付, INTERVAL 数値 単位)
```

主な単位：
- `DAY`：日
- `WEEK`：週
- `MONTH`：月
- `YEAR`：年
- `HOUR`：時間
- `MINUTE`：分

#### 例：日付の加算・減算

```sql
SELECT schedule_date,
       DATE_ADD(schedule_date, INTERVAL 1 WEEK) AS 1週間後,
       DATE_SUB(schedule_date, INTERVAL 3 DAY) AS 3日前,
       DATE_ADD(schedule_date, INTERVAL 2 MONTH) AS 2ヶ月後
FROM course_schedule
WHERE schedule_id <= 3;
```

実行結果：
| schedule_date | 1週間後    | 3日前      | 2ヶ月後    |
|---------------|-----------|-----------|-----------|
| 2025-05-14    | 2025-05-21| 2025-05-11| 2025-07-14|
| 2025-05-15    | 2025-05-22| 2025-05-12| 2025-07-15|
| 2025-05-16    | 2025-05-23| 2025-05-13| 2025-07-16|

### DATEDIFF()関数：日付の差を計算

2つの日付の間の日数を計算するには`DATEDIFF()`関数を使います。

> **用語解説**：
> - **DATEDIFF()関数**：2つの日付の差を日数で返す関数です。「Date Difference」の略です。

```sql
SELECT submission_date,
       DATEDIFF(CURDATE(), submission_date) AS 提出からの経過日数
FROM grades
WHERE submission_date IS NOT NULL
LIMIT 5;
```

実行結果：
| submission_date | 提出からの経過日数 |
|----------------|------------------|
| 2025-05-20     | 7                |
| 2025-05-20     | 7                |
| 2025-05-10     | 17               |
| 2025-05-10     | 17               |
| 2025-05-18     | 9                |

## 日付の書式設定

### DATE_FORMAT()関数：日付の表示形式を変更

日付を様々な形式で表示するには`DATE_FORMAT()`関数を使います。

> **用語解説**：
> - **DATE_FORMAT()関数**：日付を任意の形式で表示するための関数です。
> - **書式指定子**：日付の表示形式を指定するための特殊な文字（%Y、%m、%dなど）です。

#### 主要な書式指定子

| 指定子 | 説明           | 例        |
|--------|---------------|-----------|
| %Y     | 4桁の年        | 2025      |
| %y     | 2桁の年        | 25        |
| %m     | 2桁の月（01-12）| 05        |
| %c     | 月（1-12）     | 5         |
| %d     | 2桁の日（01-31）| 14        |
| %e     | 日（1-31）     | 14        |
| %W     | 曜日名（英語）  | Wednesday |
| %a     | 曜日名（短縮）  | Wed       |

#### 例：様々な日付形式

```sql
SELECT schedule_date,
       DATE_FORMAT(schedule_date, '%Y年%m月%d日') AS 日本形式,
       DATE_FORMAT(schedule_date, '%m/%d/%Y') AS 米国形式,
       DATE_FORMAT(schedule_date, '%Y-%m-%d (%W)') AS 曜日付き
FROM course_schedule
WHERE schedule_id <= 3;
```

実行結果：
| schedule_date | 日本形式      | 米国形式   | 曜日付き                    |
|---------------|-------------|-----------|----------------------------|
| 2025-05-14    | 2025年05月14日| 05/14/2025| 2025-05-14 (Wednesday)     |
| 2025-05-15    | 2025年05月15日| 05/15/2025| 2025-05-15 (Thursday)      |
| 2025-05-16    | 2025年05月16日| 05/16/2025| 2025-05-16 (Friday)        |

## 実践例：日付関数を活用したクエリ

### 例1：今月の授業スケジュールを取得

```sql
SELECT cs.schedule_date,
       DATE_FORMAT(cs.schedule_date, '%m月%d日(%a)') AS 開催日,
       c.course_name,
       t.teacher_name
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
WHERE YEAR(cs.schedule_date) = YEAR(CURDATE())
  AND MONTH(cs.schedule_date) = MONTH(CURDATE())
ORDER BY cs.schedule_date
LIMIT 5;
```

### 例2：教師の休暇期間の残り日数を計算

```sql
SELECT teacher_id,
       start_date,
       end_date,
       DATEDIFF(end_date, CURDATE()) AS 残り日数,
       CASE 
         WHEN DATEDIFF(end_date, CURDATE()) < 0 THEN '終了済み'
         WHEN DATEDIFF(end_date, CURDATE()) = 0 THEN '本日終了'
         ELSE CONCAT(DATEDIFF(end_date, CURDATE()), '日後終了')
       END AS 状況
FROM teacher_unavailability
LIMIT 5;
```

### 例3：曜日別の授業数を集計

```sql
SELECT DAYNAME(schedule_date) AS 曜日,
       COUNT(*) AS 授業数
FROM course_schedule
GROUP BY DAYNAME(schedule_date), DAYOFWEEK(schedule_date)
ORDER BY DAYOFWEEK(schedule_date);
```

## 練習問題

### 問題9-1-1
現在の日付と時刻、現在の日付のみ、現在の時刻のみを一つのクエリで取得するSQLを書いてください。

### 問題9-1-2
course_schedule（授業カレンダー）テーブルから、2025年5月に開催される授業の日付、年、月、日、曜日名を取得するSQLを書いてください。

### 問題9-1-3
grades（成績）テーブルから、提出日（submission_date）が今日から30日以内の成績レコードを取得するSQLを書いてください。

### 問題9-1-4
course_schedule（授業カレンダー）テーブルから、各授業日について「○年○月○日（○曜日）」の形式で表示するSQLを書いてください。

### 問題9-1-5
teacher_unavailability（講師スケジュール管理）テーブルから、休暇期間の日数（end_date - start_date + 1）を計算して表示するSQLを書いてください。

### 問題9-1-6
course_schedule（授業カレンダー）テーブルから、月曜日に開催される授業の数を取得するSQLを書いてください。

### 問題9-1-7
grades（成績）テーブルから、提出日が2025年5月15日から1週間以内（2025年5月21日まで）の成績を取得するSQLを書いてください。

### 問題9-1-8
course_schedule（授業カレンダー）テーブルから、今日から1ヶ月後に開催される授業スケジュールを取得するSQLを書いてください。

### 問題9-1-9
grades（成績）テーブルから、各月ごとの成績提出件数を「○月：○件」の形式で表示するSQLを書いてください。

### 問題9-1-10
course_schedule（授業カレンダー）テーブルから、金曜日に開催される授業について、授業日の2日前の日付も合わせて表示するSQLを書いてください。

## 解答と詳細な解説

### 解答9-1-1
```sql
SELECT NOW() AS 現在の日付と時刻,
       CURDATE() AS 現在の日付,
       CURTIME() AS 現在の時刻;
```

**解説**：
- `NOW()`：実行時点の日付と時刻を「YYYY-MM-DD HH:MM:SS」形式で返します
- `CURDATE()`：実行時点の日付を「YYYY-MM-DD」形式で返します
- `CURTIME()`：実行時点の時刻を「HH:MM:SS」形式で返します

### 解答9-1-2
```sql
SELECT schedule_date,
       YEAR(schedule_date) AS 年,
       MONTH(schedule_date) AS 月,
       DAY(schedule_date) AS 日,
       DAYNAME(schedule_date) AS 曜日名
FROM course_schedule
WHERE YEAR(schedule_date) = 2025 
  AND MONTH(schedule_date) = 5;
```

**解説**：
- `YEAR()`、`MONTH()`、`DAY()`関数で日付から各要素を抽出
- `DAYNAME()`関数で英語の曜日名を取得
- WHERE句で2025年5月の条件を指定

### 解答9-1-3
```sql
SELECT *
FROM grades
WHERE submission_date IS NOT NULL
  AND submission_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
```

**解説**：
- `DATE_SUB(CURDATE(), INTERVAL 30 DAY)`で今日から30日前の日付を計算
- `submission_date IS NOT NULL`でNULL値を除外
- 提出日が30日前以降（つまり30日以内）の条件を指定

### 解答9-1-4
```sql
SELECT schedule_date,
       DATE_FORMAT(schedule_date, '%Y年%m月%d日（%W）') AS 開催日
FROM course_schedule;
```

**解説**：
- `DATE_FORMAT()`関数で日付の表示形式をカスタマイズ
- `%Y`：4桁年、`%m`：2桁月、`%d`：2桁日、`%W`：英語曜日名
- 日本語の「年月日」と括弧付きの曜日で表示

### 解答9-1-5
```sql
SELECT teacher_id,
       start_date,
       end_date,
       DATEDIFF(end_date, start_date) + 1 AS 休暇日数
FROM teacher_unavailability;
```

**解説**：
- `DATEDIFF(end_date, start_date)`で終了日と開始日の差を日数で計算
- 開始日と終了日の両方を含めるため、結果に1を加算
- 例：5月1日〜5月3日の場合、DATEDIFF結果は2だが、実際は3日間なので+1

### 解答9-1-6
```sql
SELECT COUNT(*) AS 月曜日の授業数
FROM course_schedule
WHERE DAYOFWEEK(schedule_date) = 2;
```

**解説**：
- `DAYOFWEEK()`関数は1（日曜）〜7（土曜）の数字を返す
- 月曜日は2に対応するため、`DAYOFWEEK(schedule_date) = 2`で条件指定
- `COUNT(*)`で該当する授業の数を集計

### 解答9-1-7
```sql
SELECT *
FROM grades
WHERE submission_date BETWEEN '2025-05-15' AND '2025-05-21';
```

または

```sql
SELECT *
FROM grades
WHERE submission_date >= '2025-05-15'
  AND submission_date <= DATE_ADD('2025-05-15', INTERVAL 1 WEEK);
```

**解説**：
- 1つ目の解答では`BETWEEN`演算子を使用してシンプルに期間指定
- 2つ目の解答では`DATE_ADD()`関数で1週間後を動的に計算
- どちらも同じ結果を返すが、2つ目の方が「1週間以内」という条件をより明確に表現

### 解答9-1-8
```sql
SELECT *
FROM course_schedule
WHERE schedule_date = DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
```

**解説**：
- `DATE_ADD(CURDATE(), INTERVAL 1 MONTH)`で今日から1ヶ月後の日付を計算
- 完全一致（=）で該当する日の授業のみを取得
- もし「1ヶ月後以降」の意味なら、`>=`を使用

### 解答9-1-9
```sql
SELECT CONCAT(MONTH(submission_date), '月：', COUNT(*), '件') AS 月別提出件数
FROM grades
WHERE submission_date IS NOT NULL
GROUP BY MONTH(submission_date)
ORDER BY MONTH(submission_date);
```

**解説**：
- `MONTH()`関数で提出日から月を抽出
- `GROUP BY MONTH(submission_date)`で月ごとにグループ化
- `CONCAT()`関数で「○月：○件」の形式に文字列結合
- `submission_date IS NOT NULL`でNULL値を除外

### 解答9-1-10
```sql
SELECT schedule_date,
       DAYNAME(schedule_date) AS 曜日,
       DATE_SUB(schedule_date, INTERVAL 2 DAY) AS 2日前の日付
FROM course_schedule
WHERE DAYOFWEEK(schedule_date) = 6;
```

**解説**：
- `DAYOFWEEK(schedule_date) = 6`で金曜日を指定（6が金曜日）
- `DATE_SUB(schedule_date, INTERVAL 2 DAY)`で授業日の2日前を計算
- 金曜日の授業なら水曜日が2日前として表示される

## まとめ

この章では、MySQLにおける日付と時刻の操作について学びました：

1. **基本的な日付関数**：NOW()、CURDATE()、CURTIME()で現在の日時を取得
2. **日付要素の抽出**：YEAR()、MONTH()、DAY()、DAYNAME()で日付の各部分を取得
3. **日付の計算**：DATE_ADD()、DATE_SUB()、DATEDIFF()で日付の加減算と差の計算
4. **日付の書式設定**：DATE_FORMAT()で任意の形式での日付表示
5. **実践的な活用**：複数の関数を組み合わせた実用的なクエリの作成

日付関数は、データ分析やレポート作成において非常に重要な機能です。特に学校データベースのような時系列データを多く扱うシステムでは、これらの関数を効果的に使うことで、より深い洞察を得ることができます。

次のセクションでは、「文字列操作：テキスト関数」について学び、テキストデータの加工や検索の技術を習得します。