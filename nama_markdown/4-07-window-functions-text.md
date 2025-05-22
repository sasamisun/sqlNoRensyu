# 24. ウィンドウ関数：OVER句とパーティション

## はじめに

これまでの章で、CASE式による条件分岐について学びました。SQLには、さらに高度な分析機能として「ウィンドウ関数」があります。ウィンドウ関数は、データ分析やレポート作成において非常に強力で、従来のGROUP BYでは実現が困難な複雑な集計や順位付けを可能にします。

ウィンドウ関数が活躍する場面の例：
- 「各学生の成績順位を求めたい」
- 「講座ごとの成績ランキングを作成したい」
- 「前回のテスト結果と今回の結果を比較したい」
- 「各月の累積出席者数を計算したい」
- 「移動平均を求めたい」

通常の集計関数（SUM、AVG、COUNT等）では、GROUP BYを使用すると元の行数が減ってしまいますが、ウィンドウ関数では元の行構造を保ったまま集計結果を取得できます。

この章では、ウィンドウ関数の基本概念から実践的な活用方法まで、詳しく学んでいきます。

## ウィンドウ関数とは

ウィンドウ関数は、指定された「ウィンドウ」（行の範囲）に対して計算を行う関数です。通常の集計関数と異なり、結果セットの行数を変更せず、各行に対して集計値や順位などの情報を追加できます。

> **用語解説**：
> - **ウィンドウ関数**：指定された行の範囲（ウィンドウ）に対して計算を行い、元の行構造を保ったまま結果を返す関数です。
> - **OVER句**：ウィンドウ関数でウィンドウの範囲や順序を指定する句です。
> - **パーティション**：データをグループに分割する仕組みで、各グループ内でウィンドウ関数が計算されます。
> - **ウィンドウフレーム**：各行において、計算対象となる行の範囲を指定します。
> - **順位関数**：ROW_NUMBER()、RANK()、DENSE_RANK()など、行に順位を付ける関数です。
> - **分析関数**：LAG()、LEAD()、FIRST_VALUE()、LAST_VALUE()など、行間の比較や分析を行う関数です。

## ウィンドウ関数の基本構文

```sql
関数名() OVER (
    [PARTITION BY カラム1, カラム2, ...]
    [ORDER BY カラム1 [ASC|DESC], カラム2 [ASC|DESC], ...]
    [フレーム指定]
)
```

### OVER句の構成要素

1. **PARTITION BY**：データをグループに分割（省略可能）
2. **ORDER BY**：ウィンドウ内での行の順序を指定（省略可能）
3. **フレーム指定**：計算対象の行範囲を指定（省略可能）

## 順位関数（Ranking Functions）

### ROW_NUMBER()

ROW_NUMBER()は、ウィンドウ内で各行に連続した番号を割り当てます。

### 例1：全体での成績順位

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    ROW_NUMBER() OVER (ORDER BY g.score DESC) AS 全体順位
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY g.score DESC;
```

実行結果：

| 学生名     | 講座名                 | 点数 | 全体順位 |
|------------|------------------------|------|----------|
| 鈴木健太   | ITのための基礎知識     | 95.0 | 1        |
| 松本さくら | ITのための基礎知識     | 93.5 | 2        |
| 新垣愛留   | ITのための基礎知識     | 92.0 | 3        |
| 永田悦子   | ITのための基礎知識     | 91.0 | 4        |
| 中村彩香   | AI・機械学習入門       | 89.5 | 5        |
| ...        | ...                    | ...  | ...      |

### 例2：講座別での成績順位（PARTITION BY）

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    ROW_NUMBER() OVER (PARTITION BY c.course_id ORDER BY g.score DESC) AS 講座内順位
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY c.course_name, g.score DESC;
```

実行結果：

| 学生名     | 講座名                 | 点数 | 講座内順位 |
|------------|------------------------|------|------------|
| 新垣愛留   | AI・機械学習入門       | 91.0 | 1          |
| 中村彩香   | AI・機械学習入門       | 89.5 | 2          |
| 吉川伽羅   | AI・機械学習入門       | 82.5 | 3          |
| ...        | ...                    | ...  | ...        |
| 鈴木健太   | ITのための基礎知識     | 95.0 | 1          |
| 松本さくら | ITのための基礎知識     | 93.5 | 2          |
| 新垣愛留   | ITのための基礎知識     | 92.0 | 3          |
| ...        | ...                    | ...  | ...        |

PARTITION BYを使用することで、各講座内での順位を個別に計算できます。

### RANK()とDENSE_RANK()

- **RANK()**：同順位がある場合、次の順位をスキップします
- **DENSE_RANK()**：同順位がある場合でも、次の順位を連続させます

### 例3：順位関数の比較

```sql
SELECT 
    s.student_name AS 学生名,
    g.score AS 点数,
    ROW_NUMBER() OVER (ORDER BY g.score DESC) AS ROW_NUMBER,
    RANK() OVER (ORDER BY g.score DESC) AS RANK,
    DENSE_RANK() OVER (ORDER BY g.score DESC) AS DENSE_RANK
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE g.grade_type = '中間テスト' AND g.course_id = '1'
ORDER BY g.score DESC;
```

実行結果：

| 学生名     | 点数 | ROW_NUMBER | RANK | DENSE_RANK |
|------------|------|------------|------|------------|
| 鈴木健太   | 95.0 | 1          | 1    | 1          |
| 松本さくら | 93.5 | 2          | 2    | 2          |
| 新垣愛留   | 92.0 | 3          | 3    | 3          |
| 永田悦子   | 91.0 | 4          | 4    | 4          |
| 河田咲奈   | 88.0 | 5          | 5    | 5          |
| 河田咲奈   | 88.0 | 6          | 5    | 5          |
| 黒沢春馬   | 85.5 | 7          | 7    | 6          |
| ...        | ...  | ...        | ...  | ...        |

この例では、河田咲奈が同点の88.0点を取った場合の違いを示しています：
- ROW_NUMBER()：連続した番号（5, 6）
- RANK()：同順位で次をスキップ（5, 5, 7）
- DENSE_RANK()：同順位で次を連続（5, 5, 6）

## 分析関数（Analytic Functions）

### LAG()とLEAD()

LAG()は前の行の値を、LEAD()は次の行の値を取得します。

### 例4：前回テストとの点数比較

```sql
SELECT 
    s.student_name AS 学生名,
    g.grade_type AS テスト種別,
    g.score AS 今回点数,
    LAG(g.score) OVER (PARTITION BY s.student_id ORDER BY 
        CASE g.grade_type 
            WHEN '中間テスト' THEN 1 
            WHEN 'レポート1' THEN 2 
            WHEN '最終評価' THEN 3 
        END) AS 前回点数,
    g.score - LAG(g.score) OVER (PARTITION BY s.student_id ORDER BY 
        CASE g.grade_type 
            WHEN '中間テスト' THEN 1 
            WHEN 'レポート1' THEN 2 
            WHEN '最終評価' THEN 3 
        END) AS 点数変化
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE s.student_id = 301 AND g.course_id = '1'
ORDER BY CASE g.grade_type 
    WHEN '中間テスト' THEN 1 
    WHEN 'レポート1' THEN 2 
    WHEN '最終評価' THEN 3 
END;
```

実行結果：

| 学生名   | テスト種別 | 今回点数 | 前回点数 | 点数変化 |
|----------|------------|----------|----------|----------|
| 黒沢春馬 | 中間テスト | 85.5     | NULL     | NULL     |
| 黒沢春馬 | レポート1  | 85.0     | 85.5     | -0.5     |
| 黒沢春馬 | 最終評価   | 87.0     | 85.0     | 2.0      |

### 例5：月別の出席者数推移

```sql
SELECT 
    DATE_FORMAT(cs.schedule_date, '%Y-%m') AS 年月,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS 今月出席者数,
    LAG(COUNT(CASE WHEN a.status = 'present' THEN 1 END)) 
        OVER (ORDER BY DATE_FORMAT(cs.schedule_date, '%Y-%m')) AS 前月出席者数,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) - 
    LAG(COUNT(CASE WHEN a.status = 'present' THEN 1 END)) 
        OVER (ORDER BY DATE_FORMAT(cs.schedule_date, '%Y-%m')) AS 増減
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY DATE_FORMAT(cs.schedule_date, '%Y-%m')
ORDER BY 年月;
```

## 集計ウィンドウ関数

通常の集計関数（SUM、AVG、COUNT等）もウィンドウ関数として使用できます。

### 例6：累積成績と移動平均

```sql
SELECT 
    s.student_name AS 学生名,
    g.grade_type AS 評価種別,
    g.score AS 点数,
    AVG(g.score) OVER (PARTITION BY s.student_id 
                       ORDER BY CASE g.grade_type 
                           WHEN '中間テスト' THEN 1 
                           WHEN 'レポート1' THEN 2 
                           WHEN '最終評価' THEN 3 
                       END) AS 累積平均,
    SUM(g.score) OVER (PARTITION BY s.student_id 
                       ORDER BY CASE g.grade_type 
                           WHEN '中間テスト' THEN 1 
                           WHEN 'レポート1' THEN 2 
                           WHEN '最終評価' THEN 3 
                       END) AS 累積合計
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE s.student_id = 302 AND g.course_id = '1'
ORDER BY CASE g.grade_type 
    WHEN '中間テスト' THEN 1 
    WHEN 'レポート1' THEN 2 
    WHEN '最終評価' THEN 3 
END;
```

実行結果：

| 学生名   | 評価種別   | 点数 | 累積平均 | 累積合計 |
|----------|------------|------|----------|----------|
| 新垣愛留 | 中間テスト | 92.0 | 92.0     | 92.0     |
| 新垣愛留 | レポート1  | 88.0 | 90.0     | 180.0    |
| 新垣愛留 | 最終評価   | 90.0 | 90.0     | 270.0    |

### 例7：各学生の講座別平均との比較

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 個人点数,
    ROUND(AVG(g.score) OVER (PARTITION BY g.course_id), 1) AS 講座平均,
    ROUND(g.score - AVG(g.score) OVER (PARTITION BY g.course_id), 1) AS 平均との差,
    ROUND(AVG(g.score) OVER (), 1) AS 全体平均
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト' AND s.student_id BETWEEN 301 AND 305
ORDER BY c.course_name, g.score DESC;
```

## フレーム指定（Window Frames）

フレーム指定により、計算対象となる行の範囲をより詳細に制御できます。

### 基本構文

```sql
ROWS BETWEEN 開始位置 AND 終了位置
```

### フレーム境界の指定方法

- `UNBOUNDED PRECEDING`：ウィンドウの最初
- `CURRENT ROW`：現在の行
- `UNBOUNDED FOLLOWING`：ウィンドウの最後
- `n PRECEDING`：現在行からn行前
- `n FOLLOWING`：現在行からn行後

### 例8：移動平均の計算

```sql
SELECT 
    cs.schedule_date AS 日付,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS 出席者数,
    ROUND(AVG(COUNT(CASE WHEN a.status = 'present' THEN 1 END)) 
        OVER (ORDER BY cs.schedule_date 
              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 1) AS 3日移動平均
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY cs.schedule_date
ORDER BY cs.schedule_date;
```

この例では、過去3日間（2 PRECEDING AND CURRENT ROW）の移動平均を計算しています。

### 例9：累積出席率の計算

```sql
SELECT 
    s.student_name AS 学生名,
    cs.schedule_date AS 日付,
    CASE WHEN a.status = 'present' THEN 1 ELSE 0 END AS 出席フラグ,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0 END) 
        OVER (PARTITION BY s.student_id 
              ORDER BY cs.schedule_date 
              ROWS UNBOUNDED PRECEDING) * 100, 1) AS 累積出席率
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN course_schedule cs ON sc.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND s.student_id = a.student_id
WHERE s.student_id = 301
ORDER BY cs.schedule_date;
```

## FIRST_VALUE()とLAST_VALUE()

ウィンドウ内の最初や最後の値を取得できます。

### 例10：各講座での最高点・最低点との比較

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    FIRST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                               ORDER BY g.score DESC 
                               ROWS UNBOUNDED PRECEDING) AS 最高点,
    LAST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                              ORDER BY g.score DESC 
                              ROWS BETWEEN UNBOUNDED PRECEDING 
                              AND UNBOUNDED FOLLOWING) AS 最低点,
    g.score - LAST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                                        ORDER BY g.score DESC 
                                        ROWS BETWEEN UNBOUNDED PRECEDING 
                                        AND UNBOUNDED FOLLOWING) AS 最低点との差
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト' AND g.course_id = '1'
ORDER BY g.score DESC;
```

## ウィンドウ関数の実践的な応用例

### 例11：学生の成績改善状況分析

```sql
WITH student_progress AS (
    SELECT 
        s.student_id,
        s.student_name,
        g.course_id,
        c.course_name,
        g.grade_type,
        g.score,
        ROW_NUMBER() OVER (PARTITION BY s.student_id, g.course_id 
                          ORDER BY CASE g.grade_type 
                              WHEN '中間テスト' THEN 1 
                              WHEN 'レポート1' THEN 2 
                              WHEN '最終評価' THEN 3 
                          END) AS test_order,
        LAG(g.score) OVER (PARTITION BY s.student_id, g.course_id 
                          ORDER BY CASE g.grade_type 
                              WHEN '中間テスト' THEN 1 
                              WHEN 'レポート1' THEN 2 
                              WHEN '最終評価' THEN 3 
                          END) AS prev_score
    FROM grades g
    JOIN students s ON g.student_id = s.student_id
    JOIN courses c ON g.course_id = c.course_id
)
SELECT 
    student_name AS 学生名,
    course_name AS 講座名,
    grade_type AS 評価種別,
    score AS 今回点数,
    prev_score AS 前回点数,
    score - prev_score AS 点数変化,
    CASE 
        WHEN score - prev_score > 10 THEN '大幅改善'
        WHEN score - prev_score > 5 THEN '改善'
        WHEN score - prev_score > -5 THEN '維持'
        WHEN score - prev_score > -10 THEN '低下'
        ELSE '大幅低下'
    END AS 改善状況
FROM student_progress
WHERE prev_score IS NOT NULL
ORDER BY student_name, course_name, test_order;
```

### 例12：講座の人気度ランキング

```sql
SELECT 
    c.course_id,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師,
    COUNT(sc.student_id) AS 受講者数,
    RANK() OVER (ORDER BY COUNT(sc.student_id) DESC) AS 人気ランキング,
    ROUND(AVG(g.score), 1) AS 平均点,
    RANK() OVER (ORDER BY AVG(g.score) DESC) AS 成績ランキング,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    RANK() OVER (ORDER BY AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) DESC) AS 出席率ランキング
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
LEFT JOIN grades g ON sc.student_id = g.student_id AND sc.course_id = g.course_id
LEFT JOIN attendance a ON sc.student_id = a.student_id
GROUP BY c.course_id, c.course_name, t.teacher_name
ORDER BY 人気ランキング;
```

## パフォーマンス考慮点

ウィンドウ関数を効率的に使用するためのポイント：

1. **インデックスの活用**：PARTITION BYやORDER BYで使用するカラムにインデックスを設定
2. **適切なフレーム指定**：必要以上に大きなフレームを指定しない
3. **メモリ使用量**：大きなデータセットでは、ウィンドウ関数がメモリを多く消費する可能性
4. **クエリの最適化**：WHERE句で事前にデータを絞り込む

### パフォーマンス改善の例

```sql
-- 効率的なウィンドウ関数の使用例
SELECT 
    s.student_name,
    g.score,
    RANK() OVER (PARTITION BY g.course_id ORDER BY g.score DESC) AS course_rank
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE g.grade_type = '中間テスト'  -- 事前にフィルタリング
AND g.course_id IN ('1', '2', '3')  -- 必要な講座のみに限定
ORDER BY g.course_id, course_rank;
```

## 練習問題

### 問題24-1
ROW_NUMBER()を使用して、各教師が担当する講座を受講者数の多い順に順位付けするSQLを書いてください。結果には教師名、講座名、受講者数、教師内順位を含めてください。

### 問題24-2
LAG()関数を使用して、各学生の連続する成績評価（中間テスト→レポート1→最終評価）の点数変化を分析するSQLを書いてください。前回評価からの変化量も計算してください。

### 問題24-3
DENSE_RANK()を使用して、各講座内での成績上位3位までの学生を抽出するSQLを書いてください。同点の場合は同順位として扱ってください。

### 問題24-4
移動平均を使用して、過去3回の授業の平均出席率を計算するSQLを書いてください。授業日順に並べ、3日移動平均の出席率を表示してください。

### 問題24-5
SUM()のウィンドウ関数を使用して、各学生の累積出席回数と累積出席率を計算するSQLを書いてください。日付順に並べて表示してください。

### 問題24-6
FIRST_VALUE()とLAST_VALUE()を使用して、各講座において最高得点と最低得点を取った学生の情報を、全ての学生の行に追加するSQLを書いてください。中間テストの結果を対象とします。

## 解答

### 解答24-1
```sql
SELECT 
    t.teacher_name AS 教師名,
    c.course_name AS 講座名,
    COUNT(sc.student_id) AS 受講者数,
    ROW_NUMBER() OVER (PARTITION BY t.teacher_id 
                       ORDER BY COUNT(sc.student_id) DESC) AS 教師内順位
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY t.teacher_id, t.teacher_name, c.course_id, c.course_name
ORDER BY t.teacher_name, 教師内順位;
```

### 解答24-2
```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.grade_type AS 評価種別,
    g.score AS 今回点数,
    LAG(g.score) OVER (PARTITION BY s.student_id, g.course_id 
                       ORDER BY CASE g.grade_type 
                           WHEN '中間テスト' THEN 1 
                           WHEN 'レポート1' THEN 2 
                           WHEN '最終評価' THEN 3 
                       END) AS 前回点数,
    g.score - LAG(g.score) OVER (PARTITION BY s.student_id, g.course_id 
                                 ORDER BY CASE g.grade_type 
                                     WHEN '中間テスト' THEN 1 
                                     WHEN 'レポート1' THEN 2 
                                     WHEN '最終評価' THEN 3 
                                 END) AS 点数変化
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
ORDER BY s.student_name, c.course_name, 
         CASE g.grade_type 
             WHEN '中間テスト' THEN 1 
             WHEN 'レポート1' THEN 2 
             WHEN '最終評価' THEN 3 
         END;
```

### 解答24-3
```sql
WITH ranked_grades AS (
    SELECT 
        s.student_name AS 学生名,
        c.course_name AS 講座名,
        g.score AS 点数,
        DENSE_RANK() OVER (PARTITION BY g.course_id ORDER BY g.score DESC) AS 順位
    FROM grades g
    JOIN students s ON g.student_id = s.student_id
    JOIN courses c ON g.course_id = c.course_id
    WHERE g.grade_type = '中間テスト'
)
SELECT 学生名, 講座名, 点数, 順位
FROM ranked_grades
WHERE 順位 <= 3
ORDER BY 講座名, 順位;
```

### 解答24-4
```sql
SELECT 
    cs.schedule_date AS 授業日,
    c.course_name AS 講座名,
    COUNT(a.student_id) AS 対象学生数,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS 出席者数,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    ROUND(AVG(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END)) 
        OVER (PARTITION BY c.course_id 
              ORDER BY cs.schedule_date 
              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 1) AS 3日移動平均出席率
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY cs.schedule_id, cs.schedule_date, c.course_id, c.course_name
ORDER BY c.course_name, cs.schedule_date;
```

### 解答24-5
```sql
SELECT 
    s.student_name AS 学生名,
    cs.schedule_date AS 授業日,
    CASE WHEN a.status = 'present' THEN 1 ELSE 0 END AS 今日の出席,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) 
        OVER (PARTITION BY s.student_id 
              ORDER BY cs.schedule_date 
              ROWS UNBOUNDED PRECEDING) AS 累積出席回数,
    COUNT(*) OVER (PARTITION BY s.student_id 
                   ORDER BY cs.schedule_date 
                   ROWS UNBOUNDED PRECEDING) AS 累積授業回数,
    ROUND(SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) 
        OVER (PARTITION BY s.student_id 
              ORDER BY cs.schedule_date 
              ROWS UNBOUNDED PRECEDING) * 100.0 /
        COUNT(*) OVER (PARTITION BY s.student_id 
                       ORDER BY cs.schedule_date 
                       ROWS UNBOUNDED PRECEDING), 1) AS 累積出席率
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN course_schedule cs ON sc.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND s.student_id = a.student_id
WHERE s.student_id BETWEEN 301 AND 305
ORDER BY s.student_name, cs.schedule_date;
```

### 解答24-6
```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    FIRST_VALUE(s2.student_name) OVER (PARTITION BY g.course_id 
                                       ORDER BY g.score DESC 
                                       ROWS UNBOUNDED PRECEDING) AS 最高得点者,
    FIRST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                               ORDER BY g.score DESC 
                               ROWS UNBOUNDED PRECEDING) AS 最高点,
    LAST_VALUE(s2.student_name) OVER (PARTITION BY g.course_id 
                                      ORDER BY g.score DESC 
                                      ROWS BETWEEN UNBOUNDED PRECEDING 
                                      AND UNBOUNDED FOLLOWING) AS 最低得点者,
    LAST_VALUE(g.score) OVER (PARTITION BY g.course_id 
                              ORDER BY g.score DESC 
                              ROWS BETWEEN UNBOUNDED PRECEDING 
                              AND UNBOUNDED FOLLOWING) AS 最低点
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN students s2 ON g.student_id = s2.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY c.course_name, g.score DESC;
```

## まとめ

この章では、ウィンドウ関数について詳しく学びました：

1. **ウィンドウ関数の基本概念**：
   - 指定されたウィンドウ（行の範囲）に対して計算を行う関数
   - 元の行構造を保ったまま集計結果を取得
   - OVER句によるウィンドウの定義

2. **OVER句の構成要素**：
   - PARTITION BY：データのグループ化
   - ORDER BY：ウィンドウ内での行の順序
   - フレーム指定：計算対象の行範囲

3. **順位関数**：
   - ROW_NUMBER()：連続した番号の割り当て
   - RANK()：同順位考慮の順位付け（次の順位をスキップ）
   - DENSE_RANK()：同順位考慮の順位付け（次の順位を連続）

4. **分析関数**：
   - LAG()とLEAD()：前後の行の値の取得
   - FIRST_VALUE()とLAST_VALUE()：ウィンドウ内の最初・最後の値

5. **集計ウィンドウ関数**：
   - SUM()、AVG()、COUNT()等の集計関数をウィンドウ関数として使用
   - 累積計算や移動平均の実現

6. **フレーム指定**：
   - ROWS BETWEENによる計算対象範囲の詳細制御
   - 移動平均や累積計算での活用

7. **実践的な応用例**：
   - 成績ランキングの作成
   - 学習進捗の分析
   - 講座人気度の評価
   - 出席率の推移分析

8. **パフォーマンス考慮点**：
   - インデックスの重要性
   - 適切なフレーム指定
   - メモリ使用量への配慮

ウィンドウ関数は、従来のGROUP BYでは実現困難な複雑な分析を可能にする強力なツールです。データ分析、レポート作成、ランキング作成など、様々な場面で活用できる重要なSQL機能です。

次の章では、「共通テーブル式（CTE）：WITH句の活用」について学び、複雑なクエリを構造化して分かりやすく記述する方法を理解していきます。
