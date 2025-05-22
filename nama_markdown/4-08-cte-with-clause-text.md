# 25. 共通テーブル式（CTE）：WITH句の活用

## はじめに

これまでの章で、ウィンドウ関数による高度な分析機能について学びました。SQLの最後の重要な機能として「共通テーブル式（CTE：Common Table Expression）」について学びます。CTEは、WITH句を使用して一時的な結果セットを定義し、クエリ内で再利用できる機能です。

CTEが特に威力を発揮する場面：
- 「複雑なサブクエリを分かりやすく構造化したい」
- 「同じサブクエリを複数回使用したい」
- 「階層データを再帰的に処理したい」
- 「複雑な計算を段階的に行いたい」
- 「クエリの可読性と保守性を向上させたい」

従来のサブクエリやFROM句内のサブクエリと比較して、CTEはより読みやすく、再利用可能で、場合によってはパフォーマンスも向上させることができます。

この章では、CTEの基本概念から再帰CTE、実践的な活用方法まで、詳しく学んでいきます。

## 共通テーブル式（CTE）とは

共通テーブル式（CTE）は、WITH句を使用してクエリ内で一時的な名前付きの結果セットを定義する機能です。定義したCTEは、同じクエリ内で通常のテーブルと同様に参照できます。

> **用語解説**：
> - **CTE（Common Table Expression）**：共通テーブル式。WITH句で定義される一時的な名前付き結果セットです。
> - **WITH句**：CTEを定義するためのSQL句で、「〜と共に」という意味があります。
> - **非再帰CTE**：自分自身を参照しない通常のCTEです。
> - **再帰CTE**：自分自身を参照して反復処理を行うCTEです。
> - **アンカーメンバー**：再帰CTEにおいて、再帰の開始点となる初期データです。
> - **再帰メンバー**：再帰CTEにおいて、自分自身を参照する部分です。

## CTEの基本構文

### 単一CTE

```sql
WITH CTE名 AS (
    SELECT文
)
SELECT カラム1, カラム2, ...
FROM CTE名
WHERE 条件;
```

### 複数CTE

```sql
WITH 
CTE名1 AS (
    SELECT文1
),
CTE名2 AS (
    SELECT文2
)
SELECT カラム1, カラム2, ...
FROM CTE名1
JOIN CTE名2 ON 結合条件;
```

## 基本的なCTEの例

### 例1：単純なCTEの使用

成績優秀者を定義して、その詳細情報を取得：

```sql
WITH excellent_students AS (
    SELECT DISTINCT g.student_id
    FROM grades g
    WHERE g.score >= 90
)
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    COUNT(DISTINCT sc.course_id) AS 受講講座数,
    ROUND(AVG(g.score), 1) AS 平均点
FROM excellent_students es
JOIN students s ON es.student_id = s.student_id
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
ORDER BY 平均点 DESC;
```

このクエリでは、まず90点以上の成績を取った学生をCTEで定義し、その後でその学生たちの詳細情報を取得しています。

実行結果：

| student_id | 学生名     | 受講講座数 | 平均点 |
|------------|------------|------------|--------|
| 311        | 鈴木健太   | 6          | 89.8   |
| 302        | 新垣愛留   | 7          | 86.5   |
| 308        | 永田悦子   | 5          | 85.9   |
| 320        | 松本さくら | 4          | 84.2   |
| ...        | ...        | ...        | ...    |

### 例2：サブクエリとCTEの比較

同じ結果を得るためのサブクエリとCTEの比較：

#### サブクエリを使用した場合：
```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE s.student_id IN (
    SELECT g2.student_id
    FROM grades g2
    GROUP BY g2.student_id
    HAVING AVG(g2.score) >= 85
)
AND g.grade_type = '中間テスト'
ORDER BY s.student_name, g.score DESC;
```

#### CTEを使用した場合：
```sql
WITH high_performers AS (
    SELECT g.student_id
    FROM grades g
    GROUP BY g.student_id
    HAVING AVG(g.score) >= 85
)
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数
FROM high_performers hp
JOIN students s ON hp.student_id = s.student_id
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY s.student_name, g.score DESC;
```

CTEを使用した方が、クエリの意図が明確で読みやすくなります。

## 複数CTEの活用

複数のCTEを定義することで、複雑な処理を段階的に分解できます。

### 例3：複数CTEによる総合分析

```sql
WITH 
-- 各学生の平均成績を計算
student_averages AS (
    SELECT 
        s.student_id,
        s.student_name,
        ROUND(AVG(g.score), 1) AS avg_score,
        COUNT(DISTINCT g.grade_id) AS total_grades
    FROM students s
    LEFT JOIN grades g ON s.student_id = g.student_id
    GROUP BY s.student_id, s.student_name
),
-- 各学生の出席率を計算
student_attendance AS (
    SELECT 
        s.student_id,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate,
        COUNT(a.schedule_id) AS total_classes
    FROM students s
    LEFT JOIN attendance a ON s.student_id = a.student_id
    GROUP BY s.student_id
),
-- 各学生の受講講座数を計算
student_courses_count AS (
    SELECT 
        s.student_id,
        COUNT(DISTINCT sc.course_id) AS course_count
    FROM students s
    LEFT JOIN student_courses sc ON s.student_id = sc.student_id
    GROUP BY s.student_id
)
-- すべての情報を統合
SELECT 
    sa.student_id,
    sa.student_name AS 学生名,
    sa.avg_score AS 平均成績,
    sat.attendance_rate AS 出席率,
    scc.course_count AS 受講講座数,
    CASE 
        WHEN sa.avg_score >= 85 AND sat.attendance_rate >= 90 THEN 'S評価'
        WHEN sa.avg_score >= 75 AND sat.attendance_rate >= 80 THEN 'A評価'
        WHEN sa.avg_score >= 65 AND sat.attendance_rate >= 70 THEN 'B評価'
        ELSE 'C評価'
    END AS 総合評価
FROM student_averages sa
LEFT JOIN student_attendance sat ON sa.student_id = sat.student_id
LEFT JOIN student_courses_count scc ON sa.student_id = scc.student_id
WHERE sa.total_grades > 0  -- 成績記録がある学生のみ
ORDER BY sa.avg_score DESC, sat.attendance_rate DESC;
```

この例では、3つのCTEを使用して：
1. 学生の平均成績を計算
2. 学生の出席率を計算
3. 学生の受講講座数を計算
4. 最終的にすべてを統合して総合評価を行っています

実行結果：

| student_id | 学生名     | 平均成績 | 出席率 | 受講講座数 | 総合評価 |
|------------|------------|----------|--------|------------|----------|
| 311        | 鈴木健太   | 89.8     | 92.5   | 6          | S評価    |
| 302        | 新垣愛留   | 86.5     | 88.9   | 7          | A評価    |
| 308        | 永田悦子   | 85.9     | 95.0   | 5          | S評価    |
| 301        | 黒沢春馬   | 82.3     | 85.7   | 8          | A評価    |
| ...        | ...        | ...      | ...    | ...        | ...      |

## CTEの再利用

同じCTEを複数回参照することで、計算の重複を避けることができます。

### 例4：CTEの再利用による効率化

```sql
WITH course_stats AS (
    SELECT 
        c.course_id,
        c.course_name,
        t.teacher_name,
        COUNT(DISTINCT sc.student_id) AS enrollment_count,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
    FROM courses c
    JOIN teachers t ON c.teacher_id = t.teacher_id
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id
    LEFT JOIN attendance a ON sc.student_id = a.student_id
    GROUP BY c.course_id, c.course_name, t.teacher_name
)
SELECT 
    '講座統計' AS カテゴリ,
    COUNT(*) AS 講座数,
    ROUND(AVG(enrollment_count), 1) AS 平均受講者数,
    ROUND(AVG(avg_score), 1) AS 全体平均成績,
    ROUND(AVG(attendance_rate), 1) AS 全体平均出席率
FROM course_stats

UNION ALL

SELECT 
    '優秀講座' AS カテゴリ,
    COUNT(*) AS 講座数,
    ROUND(AVG(enrollment_count), 1) AS 平均受講者数,
    ROUND(AVG(avg_score), 1) AS 平均成績,
    ROUND(AVG(attendance_rate), 1) AS 平均出席率
FROM course_stats
WHERE avg_score >= 80 AND attendance_rate >= 85

UNION ALL

SELECT 
    '改善必要講座' AS カテゴリ,
    COUNT(*) AS 講座数,
    ROUND(AVG(enrollment_count), 1) AS 平均受講者数,
    ROUND(AVG(avg_score), 1) AS 平均成績,
    ROUND(AVG(attendance_rate), 1) AS 平均出席率
FROM course_stats
WHERE avg_score < 75 OR attendance_rate < 75;
```

この例では、`course_stats` CTEを3回再利用して、全体統計、優秀講座、改善が必要な講座の統計をまとめて取得しています。

## 再帰CTE

再帰CTEは、自分自身を参照して階層データや連続データを処理するために使用されます。

> **注意**：再帰CTEはMySQL 8.0以降でサポートされています。

### 再帰CTEの基本構文

```sql
WITH RECURSIVE CTE名 AS (
    -- アンカーメンバー（初期データ）
    SELECT ...
    
    UNION ALL
    
    -- 再帰メンバー（自分自身を参照）
    SELECT ...
    FROM CTE名
    WHERE 終了条件
)
SELECT * FROM CTE名;
```

### 例5：数列の生成（再帰CTEの基本例）

1から10までの数列を生成：

```sql
WITH RECURSIVE number_sequence AS (
    -- アンカーメンバー：開始値
    SELECT 1 AS n
    
    UNION ALL
    
    -- 再帰メンバー：次の値を生成
    SELECT n + 1
    FROM number_sequence
    WHERE n < 10  -- 終了条件
)
SELECT n AS 番号
FROM number_sequence;
```

実行結果：

| 番号 |
|------|
| 1    |
| 2    |
| 3    |
| 4    |
| 5    |
| 6    |
| 7    |
| 8    |
| 9    |
| 10   |

### 例6：日付系列の生成

指定期間の全日付を生成して、授業日と休日を識別：

```sql
WITH RECURSIVE date_series AS (
    -- アンカーメンバー：開始日
    SELECT DATE('2025-05-01') AS date_value
    
    UNION ALL
    
    -- 再帰メンバー：次の日を生成
    SELECT DATE_ADD(date_value, INTERVAL 1 DAY)
    FROM date_series
    WHERE date_value < DATE('2025-05-31')  -- 終了条件
)
SELECT 
    ds.date_value AS 日付,
    CASE DAYOFWEEK(ds.date_value)
        WHEN 1 THEN '日曜日'
        WHEN 2 THEN '月曜日'
        WHEN 3 THEN '火曜日'
        WHEN 4 THEN '水曜日'
        WHEN 5 THEN '木曜日'
        WHEN 6 THEN '金曜日'
        WHEN 7 THEN '土曜日'
    END AS 曜日,
    CASE 
        WHEN cs.schedule_date IS NOT NULL THEN '授業日'
        WHEN DAYOFWEEK(ds.date_value) IN (1, 7) THEN '休日'
        ELSE '平日（授業なし）'
    END AS 種別,
    COUNT(cs.schedule_id) AS 授業数
FROM date_series ds
LEFT JOIN course_schedule cs ON ds.date_value = cs.schedule_date
GROUP BY ds.date_value
ORDER BY ds.date_value;
```

### 例7：学習進捗の累積計算（再帰CTE）

各学生の学習進捗を段階的に追跡：

```sql
WITH RECURSIVE learning_progress AS (
    -- アンカーメンバー：最初の成績記録
    SELECT 
        g.student_id,
        s.student_name,
        g.grade_id,
        g.course_id,
        g.grade_type,
        g.score,
        g.submission_date,
        1 AS level,
        g.score AS cumulative_score,
        1 AS test_count
    FROM grades g
    JOIN students s ON g.student_id = s.student_id
    WHERE g.submission_date = (
        SELECT MIN(g2.submission_date)
        FROM grades g2
        WHERE g2.student_id = g.student_id
    )
    
    UNION ALL
    
    -- 再帰メンバー：次の成績記録
    SELECT 
        g.student_id,
        lp.student_name,
        g.grade_id,
        g.course_id,
        g.grade_type,
        g.score,
        g.submission_date,
        lp.level + 1,
        lp.cumulative_score + g.score,
        lp.test_count + 1
    FROM learning_progress lp
    JOIN grades g ON lp.student_id = g.student_id
    WHERE g.submission_date > lp.submission_date
    AND g.submission_date = (
        SELECT MIN(g3.submission_date)
        FROM grades g3
        WHERE g3.student_id = lp.student_id
        AND g3.submission_date > lp.submission_date
    )
    AND lp.level < 10  -- 無限ループ防止
)
SELECT 
    student_name AS 学生名,
    level AS レベル,
    grade_type AS 評価種別,
    score AS 今回点数,
    ROUND(cumulative_score / test_count, 1) AS 累積平均,
    submission_date AS 提出日
FROM learning_progress
WHERE student_id = 301
ORDER BY level;
```

## CTEとウィンドウ関数の組み合わせ

CTEとウィンドウ関数を組み合わせることで、さらに高度な分析が可能になります。

### 例8：段階的な分析とランキング

```sql
WITH 
-- ステップ1：基本統計の計算
basic_stats AS (
    SELECT 
        c.course_id,
        c.course_name,
        t.teacher_name,
        COUNT(DISTINCT sc.student_id) AS student_count,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROUND(STDDEV(g.score), 1) AS score_stddev,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
    FROM courses c
    JOIN teachers t ON c.teacher_id = t.teacher_id
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id AND g.grade_type = '中間テスト'
    LEFT JOIN attendance a ON sc.student_id = a.student_id
    GROUP BY c.course_id, c.course_name, t.teacher_name
),
-- ステップ2：ランキングの追加
ranked_courses AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY avg_score DESC) AS score_rank,
        RANK() OVER (ORDER BY attendance_rate DESC) AS attendance_rank,
        RANK() OVER (ORDER BY student_count DESC) AS popularity_rank
    FROM basic_stats
    WHERE student_count > 0
)
-- ステップ3：総合評価
SELECT 
    course_name AS 講座名,
    teacher_name AS 担当教師,
    student_count AS 受講者数,
    avg_score AS 平均点,
    attendance_rate AS 出席率,
    score_rank AS 成績順位,
    attendance_rank AS 出席率順位,
    popularity_rank AS 人気順位,
    ROUND((score_rank + attendance_rank + popularity_rank) / 3.0, 1) AS 総合順位
FROM ranked_courses
ORDER BY 総合順位, score_rank;
```

## CTEのパフォーマンス考慮点

CTEを効率的に使用するためのポイント：

### 1. 物理的実体化（Materialization）

CTEは、データベースによって実際のテーブルとして一時的に物理化される場合があります：

```sql
-- 効率的なCTEの例
WITH recent_grades AS (
    SELECT student_id, course_id, score
    FROM grades
    WHERE submission_date >= '2025-05-01'  -- 事前フィルタリング
)
SELECT 
    s.student_name,
    rg.score
FROM recent_grades rg
JOIN students s ON rg.student_id = s.student_id
WHERE rg.score >= 80;  -- さらなるフィルタリング
```

### 2. インデックスの活用

CTEで使用するカラムには適切なインデックスを設定：

```sql
-- インデックスが有効なCTEの例
WITH high_performers AS (
    SELECT student_id  -- student_idにインデックスが必要
    FROM grades
    WHERE score >= 90  -- scoreにインデックスが有効
)
SELECT s.student_name
FROM high_performers hp
JOIN students s ON hp.student_id = s.student_id;  -- 結合キーにインデックス
```

### 3. 再帰CTEの制限

再帰CTEでは無限ループを防ぐため、適切な終了条件と制限を設定：

```sql
WITH RECURSIVE safe_recursion AS (
    SELECT 1 AS level, student_id
    FROM students
    WHERE student_id = 301
    
    UNION ALL
    
    SELECT level + 1, student_id
    FROM safe_recursion
    WHERE level < 100  -- 明確な終了条件
)
SELECT * FROM safe_recursion;
```

## CTEの実践的な応用例

### 例9：学習ダッシュボードの作成

```sql
WITH 
-- 全体統計
overall_stats AS (
    SELECT 
        COUNT(DISTINCT s.student_id) AS total_students,
        COUNT(DISTINCT c.course_id) AS total_courses,
        COUNT(DISTINCT t.teacher_id) AS total_teachers,
        ROUND(AVG(g.score), 1) AS overall_avg_score
    FROM students s
    CROSS JOIN courses c
    CROSS JOIN teachers t
    LEFT JOIN grades g ON 1=1  -- 全体平均計算用
),
-- 今月の活動統計
monthly_stats AS (
    SELECT 
        COUNT(DISTINCT cs.schedule_id) AS classes_this_month,
        COUNT(DISTINCT CASE WHEN a.status = 'present' THEN a.student_id END) AS active_students,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS monthly_attendance_rate
    FROM course_schedule cs
    LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
    WHERE cs.schedule_date >= DATE_FORMAT(CURRENT_DATE, '%Y-%m-01')
),
-- トップパフォーマー
top_performers AS (
    SELECT 
        s.student_name,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROW_NUMBER() OVER (ORDER BY AVG(g.score) DESC) AS rank
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    GROUP BY s.student_id, s.student_name
    HAVING COUNT(g.grade_id) >= 3  -- 最低3つの成績記録
    LIMIT 5
),
-- 問題のある学生
at_risk_students AS (
    SELECT 
        s.student_name,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
    FROM students s
    LEFT JOIN grades g ON s.student_id = g.student_id
    LEFT JOIN attendance a ON s.student_id = a.student_id
    GROUP BY s.student_id, s.student_name
    HAVING (AVG(g.score) < 65 OR AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) < 70)
    AND COUNT(g.grade_id) > 0
)
-- ダッシュボード結果の統合
SELECT 
    '全体統計' AS カテゴリ,
    CONCAT('学生数: ', os.total_students, ', 講座数: ', os.total_courses, ', 教師数: ', os.total_teachers) AS 詳細,
    CONCAT('全体平均: ', os.overall_avg_score, '点') AS 追加情報
FROM overall_stats os

UNION ALL

SELECT 
    '今月の活動',
    CONCAT('授業数: ', ms.classes_this_month, ', アクティブ学生: ', ms.active_students),
    CONCAT('出席率: ', ms.monthly_attendance_rate, '%')
FROM monthly_stats ms

UNION ALL

SELECT 
    'トップ5学生',
    CONCAT(tp.rank, '位: ', tp.student_name),
    CONCAT('平均点: ', tp.avg_score, '点')
FROM top_performers tp

UNION ALL

SELECT 
    '要注意学生',
    ars.student_name,
    CONCAT('平均点: ', ars.avg_score, '点, 出席率: ', ars.attendance_rate, '%')
FROM at_risk_students ars;
```

## CTEのデバッグとトラブルシューティング

複雑なCTEのデバッグ方法：

### 1. 段階的な確認

```sql
-- ステップ1：最初のCTEのみを確認
WITH step1 AS (
    SELECT student_id, AVG(score) AS avg_score
    FROM grades
    GROUP BY student_id
)
SELECT * FROM step1 LIMIT 10;

-- ステップ2：2番目のCTEを追加
WITH 
step1 AS (
    SELECT student_id, AVG(score) AS avg_score
    FROM grades
    GROUP BY student_id
),
step2 AS (
    SELECT student_id, COUNT(*) AS course_count
    FROM student_courses
    GROUP BY student_id
)
SELECT s1.*, s2.course_count 
FROM step1 s1
LEFT JOIN step2 s2 ON s1.student_id = s2.student_id
LIMIT 10;
```

### 2. 中間結果の確認

```sql
WITH detailed_analysis AS (
    SELECT 
        s.student_id,
        s.student_name,
        AVG(g.score) AS avg_score,
        COUNT(g.grade_id) AS grade_count,
        'デバッグ用' AS debug_flag  -- デバッグ用カラム
    FROM students s
    LEFT JOIN grades g ON s.student_id = g.student_id
    GROUP BY s.student_id, s.student_name
)
-- デバッグ時は中間結果を直接確認
SELECT * FROM detailed_analysis
WHERE grade_count IS NULL OR grade_count = 0;  -- 問題のあるレコードを特定
```

## 練習問題

### 問題25-1
CTEを使用して、各講座の受講者数、平均点、出席率を計算し、それらの全体平均と比較するSQLを書いてください。結果には講座名、各統計値、および全体平均との差を含めてください。

### 問題25-2
複数のCTEを使用して、「優秀な学生」（平均点85点以上）と「出席率の高い学生」（出席率90%以上）を定義し、両方の条件を満たす学生、どちらか一方だけを満たす学生、どちらも満たさない学生を分類するSQLを書いてください。

### 問題25-3
再帰CTEを使用して、2025年5月の全日付（1日〜31日）を生成し、各日の授業数と出席者数を表示するSQLを書いてください。授業がない日は0と表示してください。

### 問題25-4
CTEとウィンドウ関数を組み合わせて、各学生の成績推移（中間テスト→レポート1→最終評価）を分析し、改善傾向、悪化傾向、安定傾向に分類するSQLを書いてください。

### 問題25-5
CTEを使用して教師の負荷分析を行い、担当講座数、総受講者数、平均成績、平均出席率を計算し、負荷が高い教師（担当講座数4以上または総受講者数40人以上）を特定するSQLを書いてください。

### 問題25-6
再帰CTEを使用して、各学生の「学習レベル」を定義するSQLを書いてください。レベル1は最初のテスト（60点以上）、レベル2は2回目のテスト（65点以上）、以降5点ずつ基準を上げて、最大レベル10まで計算してください。

## 解答

### 解答25-1
```sql
WITH 
course_stats AS (
    SELECT 
        c.course_id,
        c.course_name,
        COUNT(DISTINCT sc.student_id) AS enrollment_count,
        ROUND(AVG(g.score), 1) AS avg_score,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
    FROM courses c
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id
    LEFT JOIN attendance a ON sc.student_id = a.student_id
    GROUP BY c.course_id, c.course_name
),
overall_averages AS (
    SELECT 
        ROUND(AVG(enrollment_count), 1) AS avg_enrollment,
        ROUND(AVG(avg_score), 1) AS overall_avg_score,
        ROUND(AVG(attendance_rate), 1) AS overall_attendance_rate
    FROM course_stats
    WHERE enrollment_count > 0
)
SELECT 
    cs.course_name AS 講座名,
    cs.enrollment_count AS 受講者数,
    cs.avg_score AS 平均点,
    cs.attendance_rate AS 出席率,
    oa.overall_avg_score AS 全体平均点,
    oa.overall_attendance_rate AS 全体平均出席率,
    ROUND(cs.avg_score - oa.overall_avg_score, 1) AS 平均点差,
    ROUND(cs.attendance_rate - oa.overall_attendance_rate, 1) AS 出席率差
FROM course_stats cs
CROSS JOIN overall_averages oa
WHERE cs.enrollment_count > 0
ORDER BY cs.avg_score DESC;
```

### 解答25-2
```sql
WITH 
excellent_students AS (
    SELECT s.student_id, s.student_name
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    GROUP BY s.student_id, s.student_name
    HAVING AVG(g.score) >= 85
),
high_attendance_students AS (
    SELECT s.student_id, s.student_name
    FROM students s
    JOIN attendance a ON s.student_id = a.student_id
    GROUP BY s.student_id, s.student_name
    HAVING AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90
)
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    CASE 
        WHEN es.student_id IS NOT NULL THEN '優秀'
        ELSE '一般'
    END AS 成績区分,
    CASE 
        WHEN has.student_id IS NOT NULL THEN '高出席'
        ELSE '通常出席'
    END AS 出席区分,
    CASE 
        WHEN es.student_id IS NOT NULL AND has.student_id IS NOT NULL THEN '両方満足'
        WHEN es.student_id IS NOT NULL AND has.student_id IS NULL THEN '成績のみ優秀'
        WHEN es.student_id IS NULL AND has.student_id IS NOT NULL THEN '出席のみ良好'
        ELSE 'どちらも未達'
    END AS 総合分類
FROM students s
LEFT JOIN excellent_students es ON s.student_id = es.student_id
LEFT JOIN high_attendance_students has ON s.student_id = has.student_id
ORDER BY 
    CASE 
        WHEN es.student_id IS NOT NULL AND has.student_id IS NOT NULL THEN 1
        WHEN es.student_id IS NOT NULL OR has.student_id IS NOT NULL THEN 2
        ELSE 3
    END,
    s.student_name;
```

### 解答25-3
```sql
WITH RECURSIVE may_dates AS (
    -- アンカーメンバー：5月1日
    SELECT DATE('2025-05-01') AS date_value
    
    UNION ALL
    
    -- 再帰メンバー：次の日
    SELECT DATE_ADD(date_value, INTERVAL 1 DAY)
    FROM may_dates
    WHERE date_value < DATE('2025-05-31')
)
SELECT 
    md.date_value AS 日付,
    CASE DAYOFWEEK(md.date_value)
        WHEN 1 THEN '日曜日'
        WHEN 2 THEN '月曜日'
        WHEN 3 THEN '火曜日'
        WHEN 4 THEN '水曜日'
        WHEN 5 THEN '木曜日'
        WHEN 6 THEN '金曜日'
        WHEN 7 THEN '土曜日'
    END AS 曜日,
    COALESCE(COUNT(cs.schedule_id), 0) AS 授業数,
    COALESCE(SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END), 0) AS 出席者数
FROM may_dates md
LEFT JOIN course_schedule cs ON md.date_value = cs.schedule_date
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY md.date_value
ORDER BY md.date_value;
```

### 解答25-4
```sql
WITH 
student_progress AS (
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
                          END) AS test_sequence,
        LAG(g.score) OVER (PARTITION BY s.student_id, g.course_id 
                           ORDER BY CASE g.grade_type 
                               WHEN '中間テスト' THEN 1 
                               WHEN 'レポート1' THEN 2 
                               WHEN '最終評価' THEN 3 
                           END) AS prev_score
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    JOIN courses c ON g.course_id = c.course_id
    WHERE g.grade_type IN ('中間テスト', 'レポート1', '最終評価')
),
trend_analysis AS (
    SELECT 
        student_id,
        student_name,
        course_id,
        course_name,
        COUNT(*) AS test_count,
        SUM(CASE WHEN score > prev_score THEN 1 ELSE 0 END) AS improvements,
        SUM(CASE WHEN score < prev_score THEN 1 ELSE 0 END) AS declines,
        SUM(CASE WHEN score = prev_score THEN 1 ELSE 0 END) AS stable
    FROM student_progress
    WHERE prev_score IS NOT NULL
    GROUP BY student_id, student_name, course_id, course_name
)
SELECT 
    student_name AS 学生名,
    course_name AS 講座名,
    test_count AS 比較可能テスト数,
    improvements AS 改善回数,
    declines AS 悪化回数,
    stable AS 維持回数,
    CASE 
        WHEN improvements > declines THEN '改善傾向'
        WHEN declines > improvements THEN '悪化傾向'
        ELSE '安定傾向'
    END AS 総合傾向
FROM trend_analysis
WHERE test_count >= 2
ORDER BY student_name, course_name;
```

### 解答25-5
```sql
WITH 
teacher_workload AS (
    SELECT 
        t.teacher_id,
        t.teacher_name,
        COUNT(DISTINCT c.course_id) AS course_count,
        COUNT(DISTINCT sc.student_id) AS total_students,
        ROUND(AVG(g.score), 1) AS avg_grade,
        ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS avg_attendance
    FROM teachers t
    LEFT JOIN courses c ON t.teacher_id = c.teacher_id
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id
    LEFT JOIN attendance a ON sc.student_id = a.student_id
    GROUP BY t.teacher_id, t.teacher_name
),
workload_classification AS (
    SELECT 
        *,
        CASE 
            WHEN course_count >= 4 OR total_students >= 40 THEN '高負荷'
            WHEN course_count >= 2 OR total_students >= 20 THEN '中負荷'
            ELSE '低負荷'
        END AS load_level
    FROM teacher_workload
    WHERE course_count > 0
)
SELECT 
    teacher_name AS 教師名,
    course_count AS 担当講座数,
    total_students AS 総受講者数,
    avg_grade AS 平均成績,
    avg_attendance AS 平均出席率,
    load_level AS 負荷レベル
FROM workload_classification
ORDER BY 
    CASE load_level 
        WHEN '高負荷' THEN 1 
        WHEN '中負荷' THEN 2 
        ELSE 3 
    END,
    total_students DESC;
```

### 解答25-6
```sql
WITH RECURSIVE student_levels AS (
    -- アンカーメンバー：レベル1（最初のテストで60点以上）
    SELECT 
        s.student_id,
        s.student_name,
        1 AS level,
        60 AS required_score,
        MIN(g.score) AS achieved_score,
        MIN(g.submission_date) AS achievement_date
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    WHERE g.score >= 60
    GROUP BY s.student_id, s.student_name
    
    UNION ALL
    
    -- 再帰メンバー：次のレベル
    SELECT 
        sl.student_id,
        sl.student_name,
        sl.level + 1,
        sl.required_score + 5,  -- 5点ずつ基準を上げる
        MIN(g.score),
        MIN(g.submission_date)
    FROM student_levels sl
    JOIN grades g ON sl.student_id = g.student_id
    WHERE g.score >= (sl.required_score + 5)
    AND g.submission_date > sl.achievement_date
    AND sl.level < 10  -- 最大レベル10
    GROUP BY sl.student_id, sl.student_name, sl.level, sl.required_score
    HAVING MIN(g.score) >= (sl.required_score + 5)
)
SELECT 
    student_name AS 学生名,
    MAX(level) AS 到達レベル,
    MAX(required_score) AS 最終基準点,
    COUNT(*) AS レベルアップ回数
FROM student_levels
GROUP BY student_id, student_name
ORDER BY MAX(level) DESC, student_name;
```

## まとめ

この章では、共通テーブル式（CTE）について詳しく学びました：

1. **CTEの基本概念**：
   - WITH句を使用した一時的な名前付き結果セットの定義
   - クエリの可読性と再利用性の向上
   - 複雑なクエリの構造化

2. **CTEの基本構文**：
   - 単一CTEと複数CTEの記述方法
   - CTEの参照と再利用
   - サブクエリとの比較

3. **複数CTEの活用**：
   - 段階的な処理の分解
   - 複雑な分析の構造化
   - 同一CTEの複数回参照

4. **再帰CTE**：
   - 自分自身を参照する再帰的な処理
   - アンカーメンバーと再帰メンバー
   - 階層データや連続データの処理

5. **CTEとウィンドウ関数の組み合わせ**：
   - 高度な分析機能の実現
   - ランキングと統計の複合処理
   - 段階的な計算とランキング

6. **パフォーマンス考慮点**：
   - 物理的実体化の理解
   - インデックスの効果的な活用
   - 再帰CTEの制限設定

7. **実践的な応用例**：
   - 学習ダッシュボードの作成
   - 総合分析システム
   - デバッグとトラブルシューティング

CTEは、複雑なSQLクエリをより読みやすく、保守しやすくするための重要な機能です。特に、段階的な処理や再帰的な操作において威力を発揮し、従来のサブクエリでは実現困難な高度な分析を可能にします。

これで第4章「高度なクエリ技術」が完了しました。サブクエリから始まり、相関サブクエリ、集合演算、EXISTS演算子、CASE式、ウィンドウ関数、そしてCTEまで、SQLの高度な機能を体系的に学習できました。これらの技術を組み合わせることで、実務で求められる複雑なデータ分析や処理を効率的に実現できるようになります。
