# 23. CASE式：条件分岐による値の変換

## はじめに

これまでの章で、サブクエリや EXISTS演算子など、SQLの高度な検索技術について学んできました。しかし、実際のデータ分析では、取得したデータを条件に応じて変換・分類する必要があることが多くあります。

例えば以下のような場合です：
- 「点数を文字等級（A、B、C、D、F）に変換したい」
- 「出席状況を『良好』『要注意』『問題あり』に分類したい」
- 「時間帯によって授業を『午前』『午後』『夜間』に分類したい」
- 「条件に応じて異なる計算を行いたい」

このような条件分岐による値の変換を実現するのが「CASE式」です。CASE式は、SQLにおけるプログラミング言語の「if-then-else」文に相当する機能で、条件に応じて異なる値を返すことができます。

この章では、CASE式の基本概念から高度な活用方法まで、実践的な例を通して詳しく学びます。

## CASE式とは

CASE式は、複数の条件を評価し、条件に応じて異なる値を返すSQL構文です。プログラミング言語の条件分岐（if-then-else）と同様の機能を提供します。

> **用語解説**：
> - **CASE式**：条件に応じて異なる値を返すSQL構文で、条件分岐を実現します。
> - **単純CASE式**：特定のカラムの値と複数の値を比較するCASE式です。
> - **検索CASE式**：複雑な条件式を評価できるCASE式です。
> - **WHEN句**：「〜の場合」という条件を指定する部分です。
> - **THEN句**：条件が真の場合に返される値を指定する部分です。
> - **ELSE句**：すべての条件が偽の場合に返される値を指定する部分です（省略可能）。

## CASE式の基本構文

CASE式には2つの形式があります：

### 1. 単純CASE式（Simple CASE）

```sql
CASE カラム名
    WHEN 値1 THEN 結果1
    WHEN 値2 THEN 結果2
    WHEN 値3 THEN 結果3
    ELSE デフォルト値
END
```

### 2. 検索CASE式（Searched CASE）

```sql
CASE
    WHEN 条件1 THEN 結果1
    WHEN 条件2 THEN 結果2
    WHEN 条件3 THEN 結果3
    ELSE デフォルト値
END
```

検索CASE式の方がより柔軟で一般的に使用されます。

## CASE式の基本例

### 例1：成績の等級変換（検索CASE式）

点数を文字等級に変換してみましょう：

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    CASE
        WHEN g.score >= 90 THEN 'A'
        WHEN g.score >= 80 THEN 'B'
        WHEN g.score >= 70 THEN 'C'
        WHEN g.score >= 60 THEN 'D'
        ELSE 'F'
    END AS 等級
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
ORDER BY g.score DESC;
```

実行結果：

| 学生名     | 講座名                 | 点数 | 等級 |
|------------|------------------------|------|------|
| 鈴木健太   | ITのための基礎知識     | 95.0 | A    |
| 松本さくら | ITのための基礎知識     | 93.5 | A    |
| 新垣愛留   | ITのための基礎知識     | 92.0 | A    |
| 永田悦子   | ITのための基礎知識     | 91.0 | A    |
| 河田咲奈   | ITのための基礎知識     | 88.0 | B    |
| 黒沢春馬   | ITのための基礎知識     | 85.5 | B    |
| ...        | ...                    | ...  | ...  |

### 例2：出席状況の分類（単純CASE式）

出席状況を日本語に変換：

```sql
SELECT 
    s.student_name AS 学生名,
    cs.schedule_date AS 日付,
    CASE a.status
        WHEN 'present' THEN '出席'
        WHEN 'absent' THEN '欠席'
        WHEN 'late' THEN '遅刻'
        ELSE '不明'
    END AS 出席状況
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE cs.schedule_date = '2025-05-20'
ORDER BY s.student_name;
```

実行結果：

| 学生名     | 日付       | 出席状況 |
|------------|------------|----------|
| 黒沢春馬   | 2025-05-20 | 出席     |
| 新垣愛留   | 2025-05-20 | 遅刻     |
| 柴崎春花   | 2025-05-20 | 出席     |
| 森下風凛   | 2025-05-20 | 欠席     |
| ...        | ...        | ...      |

## SELECT句でのCASE式の活用

### 例3：複雑な条件による分類

学生の学習状況を総合的に評価：

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    AVG(g.score) AS 平均点,
    COUNT(DISTINCT sc.course_id) AS 受講講座数,
    AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0.0 END) * 100 AS 出席率,
    CASE
        WHEN AVG(g.score) >= 85 AND 
             AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0.0 END) >= 0.9 THEN '優秀'
        WHEN AVG(g.score) >= 75 AND 
             AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0.0 END) >= 0.8 THEN '良好'
        WHEN AVG(g.score) >= 65 OR 
             AVG(CASE WHEN a.status = 'present' THEN 1.0 ELSE 0.0 END) >= 0.7 THEN '普通'
        ELSE '要指導'
    END AS 総合評価
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
WHERE s.student_id BETWEEN 301 AND 310
GROUP BY s.student_id, s.student_name
ORDER BY AVG(g.score) DESC;
```

実行結果：

| student_id | 学生名     | 平均点 | 受講講座数 | 出席率 | 総合評価 |
|------------|------------|--------|------------|--------|----------|
| 311        | 鈴木健太   | 89.8   | 6          | 92.5   | 優秀     |
| 302        | 新垣愛留   | 86.5   | 7          | 88.9   | 良好     |
| 308        | 永田悦子   | 85.9   | 5          | 95.0   | 優秀     |
| 301        | 黒沢春馬   | 82.3   | 8          | 85.7   | 良好     |
| ...        | ...        | ...    | ...        | ...    | ...      |

### 例4：時間帯による授業の分類

```sql
SELECT 
    c.course_name AS 講座名,
    cp.start_time AS 開始時間,
    CASE
        WHEN cp.start_time < '12:00:00' THEN '午前'
        WHEN cp.start_time < '17:00:00' THEN '午後'
        ELSE '夜間'
    END AS 時間帯,
    COUNT(*) AS 授業回数
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN class_periods cp ON cs.period_id = cp.period_id
GROUP BY c.course_name, cp.start_time
ORDER BY c.course_name, cp.start_time;
```

## WHERE句でのCASE式

CASE式はWHERE句でも使用できます。これにより、複雑な条件を分かりやすく表現できます。

### 例5：条件付きフィルタリング

成績のタイプに応じて異なる合格基準を適用：

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.grade_type AS 評価タイプ,
    g.score AS 点数,
    CASE g.grade_type
        WHEN '中間テスト' THEN 70
        WHEN 'レポート1' THEN 60
        WHEN '最終評価' THEN 75
        ELSE 65
    END AS 合格基準
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE g.score >= CASE g.grade_type
                    WHEN '中間テスト' THEN 70
                    WHEN 'レポート1' THEN 60
                    WHEN '最終評価' THEN 75
                    ELSE 65
                 END
ORDER BY s.student_name, c.course_name;
```

## ORDER BY句でのCASE式

ORDER BY句でCASE式を使用することで、カスタムソート順を実現できます。

### 例6：カスタムソート順

出席状況を優先度順でソート：

```sql
SELECT 
    s.student_name AS 学生名,
    cs.schedule_date AS 日付,
    CASE a.status
        WHEN 'present' THEN '出席'
        WHEN 'late' THEN '遅刻'
        WHEN 'absent' THEN '欠席'
        ELSE '不明'
    END AS 出席状況
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
WHERE cs.schedule_date = '2025-05-20'
ORDER BY 
    CASE a.status
        WHEN 'absent' THEN 1   -- 欠席を最初に
        WHEN 'late' THEN 2     -- 遅刻を次に
        WHEN 'present' THEN 3  -- 出席を最後に
        ELSE 4
    END,
    s.student_name;
```

### 例7：成績タイプのカスタムソート

```sql
SELECT 
    s.student_name AS 学生名,
    g.grade_type AS 評価タイプ,
    g.score AS 点数
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE s.student_id = 301
ORDER BY 
    CASE g.grade_type
        WHEN '中間テスト' THEN 1
        WHEN 'レポート1' THEN 2
        WHEN '課題1' THEN 3
        WHEN '最終評価' THEN 4
        ELSE 5
    END;
```

## 集計関数とCASE式の組み合わせ

CASE式を集計関数と組み合わせることで、条件付き集計が可能になります。

### 例8：条件付きカウント

各講座の出席状況別人数を集計：

```sql
SELECT 
    c.course_name AS 講座名,
    cs.schedule_date AS 日付,
    COUNT(*) AS 受講者数,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS 出席者数,
    SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS 遅刻者数,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS 欠席者数,
    ROUND(SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS 出席率
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
WHERE cs.schedule_date = '2025-05-20'
GROUP BY c.course_name, cs.schedule_date
ORDER BY 出席率 DESC;
```

実行結果：

| 講座名                 | 日付       | 受講者数 | 出席者数 | 遅刻者数 | 欠席者数 | 出席率 |
|------------------------|------------|----------|----------|----------|----------|--------|
| データベース設計と実装 | 2025-05-20 | 8        | 7        | 1        | 0        | 87.5   |
| ITのための基礎知識     | 2025-05-20 | 12       | 9        | 2        | 1        | 75.0   |
| AI・機械学習入門       | 2025-05-20 | 10       | 7        | 1        | 2        | 70.0   |
| ...                    | ...        | ...      | ...      | ...      | ...      | ...    |

### 例9：成績レベル別の統計

```sql
SELECT 
    c.course_name AS 講座名,
    COUNT(*) AS 総受験者数,
    SUM(CASE WHEN g.score >= 90 THEN 1 ELSE 0 END) AS A評価数,
    SUM(CASE WHEN g.score >= 80 AND g.score < 90 THEN 1 ELSE 0 END) AS B評価数,
    SUM(CASE WHEN g.score >= 70 AND g.score < 80 THEN 1 ELSE 0 END) AS C評価数,
    SUM(CASE WHEN g.score >= 60 AND g.score < 70 THEN 1 ELSE 0 END) AS D評価数,
    SUM(CASE WHEN g.score < 60 THEN 1 ELSE 0 END) AS F評価数,
    ROUND(AVG(g.score), 1) AS 平均点
FROM grades g
JOIN courses c ON g.course_id = c.course_id
WHERE g.grade_type = '中間テスト'
GROUP BY c.course_name
ORDER BY 平均点 DESC;
```

実行結果：

| 講座名                 | 総受験者数 | A評価数 | B評価数 | C評価数 | D評価数 | F評価数 | 平均点 |
|------------------------|------------|---------|---------|---------|---------|---------|--------|
| ITのための基礎知識     | 12         | 4       | 5       | 2       | 1       | 0       | 86.2   |
| データベース設計と実装 | 7          | 2       | 3       | 2       | 0       | 0       | 82.3   |
| AI・機械学習入門       | 8          | 2       | 2       | 3       | 1       | 0       | 78.9   |
| ...                    | ...        | ...     | ...     | ...     | ...     | ...     | ...    |

## CASE式のネスト（入れ子）

CASE式の中に別のCASE式を含めることで、より複雑な条件分岐を表現できます。

### 例10：複雑な成績評価システム

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.score AS 点数,
    CASE g.grade_type
        WHEN '中間テスト' THEN
            CASE
                WHEN g.score >= 95 THEN 'A+'
                WHEN g.score >= 90 THEN 'A'
                WHEN g.score >= 85 THEN 'A-'
                WHEN g.score >= 80 THEN 'B+'
                WHEN g.score >= 75 THEN 'B'
                WHEN g.score >= 70 THEN 'B-'
                WHEN g.score >= 65 THEN 'C+'
                WHEN g.score >= 60 THEN 'C'
                ELSE 'F'
            END
        WHEN 'レポート1' THEN
            CASE
                WHEN g.score >= 90 THEN 'A'
                WHEN g.score >= 80 THEN 'B'
                WHEN g.score >= 70 THEN 'C'
                WHEN g.score >= 60 THEN 'D'
                ELSE 'F'
            END
        ELSE
            CASE
                WHEN g.score >= 85 THEN 'A'
                WHEN g.score >= 75 THEN 'B'
                WHEN g.score >= 65 THEN 'C'
                WHEN g.score >= 55 THEN 'D'
                ELSE 'F'
            END
    END AS 等級
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN courses c ON g.course_id = c.course_id
ORDER BY s.student_name, c.course_name, g.grade_type;
```

## NULL値の処理

CASE式では、NULL値を適切に処理することが重要です。

### 例11：NULL値を含む条件分岐

```sql
SELECT 
    s.student_name AS 学生名,
    sc.course_id AS 講座ID,
    CASE
        WHEN g.score IS NULL THEN '未提出'
        WHEN g.score >= 80 THEN '合格'
        WHEN g.score >= 60 THEN '条件付き合格'
        ELSE '不合格'
    END AS 結果,
    COALESCE(g.score, 0) AS 点数
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN grades g ON s.student_id = g.student_id 
                   AND sc.course_id = g.course_id 
                   AND g.grade_type = '中間テスト'
WHERE s.student_id BETWEEN 301 AND 305
ORDER BY s.student_name, sc.course_id;
```

## CASE式の実践的な応用例

### 例12：学習進捗ダッシュボード

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    COUNT(DISTINCT sc.course_id) AS 受講講座数,
    CASE
        WHEN COUNT(DISTINCT sc.course_id) >= 8 THEN '多い'
        WHEN COUNT(DISTINCT sc.course_id) >= 5 THEN '適正'
        WHEN COUNT(DISTINCT sc.course_id) >= 3 THEN '少ない'
        ELSE '非常に少ない'
    END AS 履修状況,
    ROUND(AVG(CASE WHEN g.score IS NOT NULL THEN g.score END), 1) AS 平均点,
    CASE
        WHEN AVG(CASE WHEN g.score IS NOT NULL THEN g.score END) IS NULL THEN '未評価'
        WHEN AVG(CASE WHEN g.score IS NOT NULL THEN g.score END) >= 85 THEN '優秀'
        WHEN AVG(CASE WHEN g.score IS NOT NULL THEN g.score END) >= 75 THEN '良好'
        WHEN AVG(CASE WHEN g.score IS NOT NULL THEN g.score END) >= 65 THEN '普通'
        ELSE '要改善'
    END AS 成績評価,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    CASE
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90 THEN '良好'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80 THEN '普通'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 70 THEN '要注意'
        ELSE '問題あり'
    END AS 出席評価
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
WHERE s.student_id BETWEEN 301 AND 310
GROUP BY s.student_id, s.student_name
ORDER BY s.student_id;
```

## CASE式のパフォーマンス考慮点

CASE式を効率的に使用するためのポイント：

1. **条件の順序**：最も頻繁に該当する条件を最初に配置することで、評価回数を減らせます。

2. **複雑な条件の分解**：非常に複雑なCASE式は、複数のステップに分解したり、一時テーブルを使用したりすることを検討しましょう。

3. **インデックスの活用**：CASE式で使用するカラムにインデックスがある場合、WHERE句でそのカラムを直接使用することも検討しましょう。

### パフォーマンス改善の例：

```sql
-- 効率的なCASE式の例（頻度の高い条件を先に）
SELECT 
    student_name,
    CASE
        WHEN score >= 70 THEN '合格'      -- 最も頻度が高い
        WHEN score >= 60 THEN '条件付き'   -- 次に頻度が高い
        WHEN score IS NULL THEN '未受験'   -- まれなケース
        ELSE '不合格'                     -- 最も少ない
    END AS 結果
FROM students s
JOIN grades g ON s.student_id = g.student_id;
```

## 練習問題

### 問題23-1
CASE式を使用して、講座の受講者数を「多い」（15人以上）、「普通」（10〜14人）、「少ない」（5〜9人）、「非常に少ない」（4人以下）に分類するSQLを書いてください。結果には講座ID、講座名、受講者数、分類を含めてください。

### 問題23-2
CASE式を使用して、各学生の出席率を計算し、「優秀」（90%以上）、「良好」（80%以上）、「普通」（70%以上）、「要改善」（70%未満）に分類するSQLを書いてください。出席率も合わせて表示してください。

### 問題23-3
CASE式を使用して、教師の担当負荷を「重い」（4講座以上）、「適正」（2〜3講座）、「軽い」（1講座）、「なし」（担当なし）に分類するSQLを書いてください。結果には教師ID、教師名、担当講座数、負荷分類を含めてください。

### 問題23-4
CASE式と集計関数を組み合わせて、各講座について成績分布を分析するSQLを書いてください。「90点以上」「80-89点」「70-79点」「60-69点」「60点未満」「未提出」の各カテゴリの人数を表示してください。

### 問題23-5
CASE式を使用して、学生の学習パフォーマンスを総合評価するSQLを書いてください。平均点と出席率の両方を考慮し、以下の基準で評価してください：
- 平均点85点以上かつ出席率90%以上：「S」
- 平均点75点以上かつ出席率80%以上：「A」  
- 平均点65点以上かつ出席率70%以上：「B」
- それ以外：「C」

### 問題23-6
CASE式を使用して、時間割を見やすく整理するSQLを書いてください。授業時間を「1限目」「2限目」...として表示し、教室を建物別（1号館、2号館など）に分類して、曜日別に整理してください。2025年5月21日の授業スケジュールを対象とします。

## 解答

### 解答23-1
```sql
SELECT 
    c.course_id,
    c.course_name AS 講座名,
    COUNT(sc.student_id) AS 受講者数,
    CASE
        WHEN COUNT(sc.student_id) >= 15 THEN '多い'
        WHEN COUNT(sc.student_id) >= 10 THEN '普通'
        WHEN COUNT(sc.student_id) >= 5 THEN '少ない'
        ELSE '非常に少ない'
    END AS 分類
FROM courses c
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name
ORDER BY 受講者数 DESC;
```

### 解答23-2
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    CASE
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90 THEN '優秀'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80 THEN '良好'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 70 THEN '普通'
        ELSE '要改善'
    END AS 出席評価
FROM students s
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING COUNT(a.student_id) > 0  -- 出席記録がある学生のみ
ORDER BY 出席率 DESC;
```

### 解答23-3
```sql
SELECT 
    t.teacher_id,
    t.teacher_name AS 教師名,
    COUNT(c.course_id) AS 担当講座数,
    CASE
        WHEN COUNT(c.course_id) >= 4 THEN '重い'
        WHEN COUNT(c.course_id) >= 2 THEN '適正'
        WHEN COUNT(c.course_id) = 1 THEN '軽い'
        ELSE 'なし'
    END AS 負荷分類
FROM teachers t
LEFT JOIN courses c ON t.teacher_id = c.teacher_id
GROUP BY t.teacher_id, t.teacher_name
ORDER BY 担当講座数 DESC;
```

### 解答23-4
```sql
SELECT 
    c.course_id,
    c.course_name AS 講座名,
    SUM(CASE WHEN g.score >= 90 THEN 1 ELSE 0 END) AS '90点以上',
    SUM(CASE WHEN g.score >= 80 AND g.score < 90 THEN 1 ELSE 0 END) AS '80-89点',
    SUM(CASE WHEN g.score >= 70 AND g.score < 80 THEN 1 ELSE 0 END) AS '70-79点',
    SUM(CASE WHEN g.score >= 60 AND g.score < 70 THEN 1 ELSE 0 END) AS '60-69点',
    SUM(CASE WHEN g.score < 60 THEN 1 ELSE 0 END) AS '60点未満',
    (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) - 
    COUNT(g.score) AS 未提出
FROM courses c
LEFT JOIN grades g ON c.course_id = g.course_id AND g.grade_type = '中間テスト'
GROUP BY c.course_id, c.course_name
ORDER BY c.course_id;
```

### 解答23-5
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    ROUND(AVG(g.score), 1) AS 平均点,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS 出席率,
    CASE
        WHEN AVG(g.score) >= 85 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90 THEN 'S'
        WHEN AVG(g.score) >= 75 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80 THEN 'A'
        WHEN AVG(g.score) >= 65 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 70 THEN 'B'
        ELSE 'C'
    END AS 総合評価
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING COUNT(DISTINCT g.grade_id) > 0 AND COUNT(DISTINCT a.schedule_id) > 0
ORDER BY 総合評価, 平均点 DESC;
```

### 解答23-6
```sql
SELECT 
    CASE cp.period_id
        WHEN 1 THEN '1限目'
        WHEN 2 THEN '2限目'
        WHEN 3 THEN '3限目'
        WHEN 4 THEN '4限目'
        WHEN 5 THEN '5限目'
        ELSE CONCAT(cp.period_id, '限目')
    END AS 時限,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間,
    c.course_name AS 講座名,
    cl.classroom_name AS 教室名,
    CASE
        WHEN cl.building LIKE '1号館%' THEN '1号館'
        WHEN cl.building LIKE '2号館%' THEN '2号館'
        WHEN cl.building LIKE '3号館%' THEN '3号館'
        WHEN cl.building LIKE '4号館%' THEN '4号館'
        ELSE cl.building
    END AS 建物,
    t.teacher_name AS 担当教師
FROM course_schedule cs
JOIN class_periods cp ON cs.period_id = cp.period_id
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
WHERE cs.schedule_date = '2025-05-21'
ORDER BY cp.period_id, cl.building, cl.classroom_name;
```

## まとめ

この章では、CASE式について詳しく学びました：

1. **CASE式の基本概念**：
   - 条件分岐による値の変換を実現するSQL構文
   - 単純CASE式と検索CASE式の2つの形式
   - プログラミング言語のif-then-else文に相当する機能

2. **CASE式の基本構文**：
   - WHEN-THEN-ELSE-ENDの基本構造
   - 複数条件の評価順序
   - ELSE句の省略とNULL値の扱い

3. **様々な場面でのCASE式の活用**：
   - SELECT句での値の変換と分類
   - WHERE句での複雑な条件指定
   - ORDER BY句でのカスタムソート順

4. **集計関数との組み合わせ**：
   - 条件付きカウントとSUM関数
   - カテゴリ別の統計集計
   - 複雑な分析レポートの作成

5. **高度なCASE式の使用法**：
   - ネストしたCASE式
   - NULL値の適切な処理
   - 複雑な条件分岐の実装

6. **実践的な応用例**：
   - 成績の等級変換システム
   - 学習進捗ダッシュボード
   - 出席状況の分類と分析

7. **パフォーマンスの考慮点**：
   - 条件の順序の最適化
   - 複雑なCASE式の分解方法
   - インデックスの効果的な活用

CASE式は、データの分類、変換、条件付き処理において非常に強力なツールです。適切に使用することで、複雑なビジネスロジックをSQLで直接実装でき、レポート作成やデータ分析の効率を大幅に向上させることができます。

次の章では、「ウィンドウ関数：OVER句とパーティション」について学び、より高度な分析機能を理解していきます。
