# 17. 複数テーブル結合：3つ以上のテーブルの連結

## はじめに

これまでの章では、2つのテーブルを結合する方法や、同じテーブルを自己結合する方法について学びました。しかし、実際のデータベース操作では、3つ以上のテーブルを一度に結合して情報を取得する必要があることが多くあります。

例えば、以下のようなケースを考えてみましょう：
- 「学生の名前、受講している講座名、その担当教師名、教室情報を一度に取得したい」
- 「授業スケジュール、講座情報、教室情報、時間情報をまとめて表示したい」
- 「成績データに学生名、講座名、提出情報を関連付けて分析したい」

これらを実現するには、3つ以上のテーブルを連結する必要があります。この章では、複数のテーブルを効果的に結合する方法について学びます。

## 複数テーブル結合の基本

3つ以上のテーブルを結合する基本的な考え方は、2つのテーブルの結合を拡張したものです。2つのテーブルを結合した結果に、さらに別のテーブルを結合していきます。

> **用語解説**：
> - **複数結合**：3つ以上のテーブルを一度に連結して情報を取得する操作のことです。
> - **結合チェーン**：複数のJOIN句を連続して記述し、テーブルをつなげていく方法です。

### 基本構文

```sql
SELECT カラムリスト
FROM テーブル1
JOIN テーブル2 ON 結合条件1
JOIN テーブル3 ON 結合条件2
JOIN テーブル4 ON 結合条件3
...;
```

JOINの種類（INNER JOIN、LEFT JOIN、RIGHT JOINなど）は、各結合ごとに適切に選択できます。

## 3つのテーブルを結合する例

まずは、3つのテーブルを結合する基本的な例を見てみましょう。

### 例1：学生、講座、教師の情報を連結する

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE s.student_id = 301
ORDER BY c.course_id;
```

このクエリでは：
1. 学生テーブル(`students`)を基点に
2. 受講テーブル(`student_courses`)を結合し
3. 講座テーブル(`courses`)を結合し
4. 教師テーブル(`teachers`)を結合しています

実行結果：

| student_id | 学生名   | 講座名                 | 担当教師   |
|------------|----------|------------------------|------------|
| 301        | 黒沢春馬 | ITのための基礎知識     | 寺内鞍     |
| 301        | 黒沢春馬 | UNIX入門               | 田尻朋美   |
| 301        | 黒沢春馬 | クラウドコンピューティング | 吉岡由佳 |
| 301        | 黒沢春馬 | クラウドネイティブアーキテクチャ | 吉岡由佳 |
| ...        | ...      | ...                    | ...        |

## 4つ以上のテーブルを結合する例

より複雑な情報を取得するために、4つ以上のテーブルを結合してみましょう。

### 例2：授業スケジュール詳細の取得

```sql
SELECT 
    cs.schedule_date AS 日付,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師,
    cl.classroom_name AS 教室,
    cl.building AS 建物,
    cs.status AS 状態
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
WHERE cs.schedule_date = '2025-05-21'
ORDER BY cp.start_time, cl.classroom_id;
```

このクエリでは、5つのテーブルを結合して授業スケジュールの詳細情報を取得しています：
1. 授業カレンダーテーブル(`course_schedule`)を基点に
2. 講座テーブル(`courses`)を結合し
3. 教師テーブル(`teachers`)を結合し
4. 教室テーブル(`classrooms`)を結合し
5. 授業時間テーブル(`class_periods`)を結合しています

実行結果（例）：

| 日付       | 開始時間 | 終了時間 | 講座名                 | 担当教師   | 教室           | 建物  | 状態      |
|------------|----------|----------|------------------------|------------|----------------|-------|-----------|
| 2025-05-21 | 09:00:00 | 10:30:00 | 高度データ可視化技術   | 星野涼子   | 402Hコンピュータ実習室 | 4号館 | scheduled |
| 2025-05-21 | 09:00:00 | 10:30:00 | サイバーセキュリティ対策 | 深山誠一 | 301E講義室    | 3号館 | scheduled |
| 2025-05-21 | 10:40:00 | 12:10:00 | コードリファクタリングとクリーンコード | 寺内鞍 | 101Aコンピュータ実習室 | 1号館 | scheduled |
| ...        | ...      | ...      | ...                    | ...        | ...            | ...   | ...       |

## 複数テーブル結合のバリエーション

複数テーブルの結合では、さまざまな結合タイプを組み合わせることができます。

### 例3：INNER JOINとLEFT JOINの組み合わせ

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    g.grade_type AS 評価種別,
    g.score AS 点数,
    a.status AS 出席状況
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
LEFT JOIN grades g ON s.student_id = g.student_id AND sc.course_id = g.course_id AND g.grade_type = '中間テスト'
LEFT JOIN attendance a ON s.student_id = a.student_id
WHERE s.student_id = 301
ORDER BY c.course_id;
```

このクエリでは、以下のように異なる結合タイプを組み合わせています：
- students、student_courses、coursesテーブルには**INNER JOIN**を使用（関連データが必ず存在するため）
- gradesテーブルには**LEFT JOIN**を使用（中間テストの成績がない可能性があるため）
- attendanceテーブルにも**LEFT JOIN**を使用（出席情報がない可能性があるため）

## 結合順序とパフォーマンス

複数テーブルを結合する場合、結合の順序はSQLの実行計画に影響しますが、通常はデータベースのオプティマイザが最適な実行順序を決定します。ただし、以下の点に注意すると効率的なクエリを書くことができます：

1. **フィルタリングを早めに行う**：WHERE句での絞り込みを早い段階で行うことで、結合対象のレコード数を減らせます。

2. **小さいテーブルから大きいテーブルへ**：一般的に、小さいテーブルを基点に、より大きいテーブルを結合していく方が効率的です。

3. **結合条件の最適化**：インデックスが設定されているカラムを結合条件に使用すると、パフォーマンスが向上します。

### 例4：効率的な結合順序とフィルタリングの例

```sql
SELECT 
    cs.schedule_date,
    c.course_name,
    COUNT(a.student_id) AS 出席学生数
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND a.status = 'present'
WHERE cs.schedule_date BETWEEN '2025-05-01' AND '2025-05-31'
GROUP BY cs.schedule_id, cs.schedule_date, c.course_name
ORDER BY cs.schedule_date, c.course_name;
```

このクエリでは、以下の効率化を行っています：
- 日付範囲による絞り込みを早い段階で行っている（`course_schedule`テーブルへのWHERE句）
- 比較的小さい`course_schedule`テーブルを基点にしている
- 出席状態のフィルタリングを結合条件に含めている（`a.status = 'present'`）

## テーブル別名の重要性

複数テーブルの結合では、テーブル別名（エイリアス）の使用が特に重要になります。テーブル別名を使うことで：

1. コードが簡潔になる
2. 同じカラム名が複数のテーブルに存在する場合の曖昧さが解消される
3. SQLの可読性が向上する

### 例5：明確なテーブル別名の使用

```sql
SELECT 
    s.student_name AS 学生名,
    c.course_name AS 講座名,
    t.teacher_name AS 教師名,
    cs.schedule_date AS 日付,
    cp.start_time AS 開始時間,
    cl.classroom_name AS 教室
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
JOIN course_schedule cs ON c.course_id = cs.course_id
JOIN class_periods cp ON cs.period_id = cp.period_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
WHERE s.student_id = 301
  AND cs.schedule_date >= '2025-05-01'
ORDER BY cs.schedule_date, cp.start_time;
```

このクエリでは、7つのテーブルに明確な別名を付けています：
- students → s
- student_courses → sc
- courses → c
- teachers → t
- course_schedule → cs
- class_periods → cp
- classrooms → cl

## 複雑な多テーブル結合の実用例

実際の業務でよく使われる、より複雑な多テーブル結合の例を見てみましょう。

### 例6：学生の成績と出席状況の総合分析

```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_id,
    c.course_name AS 講座名,
    t.teacher_name AS 担当教師,
    -- 中間テストの点数
    MAX(CASE WHEN g.grade_type = '中間テスト' THEN g.score ELSE NULL END) AS 中間テスト,
    -- レポートの点数
    MAX(CASE WHEN g.grade_type = 'レポート1' THEN g.score ELSE NULL END) AS レポート,
    -- 出席情報の集計
    COUNT(DISTINCT cs.schedule_id) AS 授業回数,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS 出席回数,
    SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS 遅刻回数,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS 欠席回数,
    -- 出席率の計算
    ROUND(
        SUM(CASE 
            WHEN a.status = 'present' THEN 1 
            WHEN a.status = 'late' THEN 0.5 
            ELSE 0 
        END) / COUNT(DISTINCT cs.schedule_id) * 100, 
    1) AS 出席率
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
LEFT JOIN course_schedule cs ON c.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id AND s.student_id = a.student_id
WHERE s.student_id BETWEEN 301 AND 305
GROUP BY s.student_id, s.student_name, c.course_id, c.course_name, t.teacher_name
ORDER BY s.student_id, c.course_id;
```

このクエリは、複数のテーブルを結合して各学生の成績と出席状況を総合的に分析しています。特徴として：
- 複数テーブルの結合
- CASE式を使った条件付き集計
- GROUP BY句による集計
- 計算式を使った派生列（出席率）

## 練習問題

### 問題17-1
学生（students）、受講（student_courses）、講座（courses）の3つのテーブルを結合して、学生ID=302の学生が受講しているすべての講座名とその講座IDを取得するSQLを書いてください。

### 問題17-2
講座（courses）、授業カレンダー（course_schedule）、教室（classrooms）、授業時間（class_periods）の4つのテーブルを結合して、2025年5月22日のすべての授業スケジュールを、開始時間順に取得するSQLを書いてください。結果には講座名、教室名、開始時間、終了時間、担当教師名を含めてください。

### 問題17-3
学生（students）テーブル、成績（grades）テーブル、講座（courses）テーブルを結合して、「ITのための基礎知識」（course_id=1）の講座を受講している学生の中間テスト成績を、点数の高い順に取得するSQLを書いてください。結果には学生名、得点、および講座名を含めてください。

### 問題17-4
教師（teachers）テーブル、講座（courses）テーブル、授業カレンダー（course_schedule）テーブル、教室（classrooms）テーブルを結合して、教師ID=106（星野涼子）が2025年5月に担当するすべての授業の詳細を取得するSQLを書いてください。結果には授業日、講座名、教室名を含めてください。

### 問題17-5
学生（students）テーブル、受講（student_courses）テーブル、講座（courses）テーブル、成績（grades）テーブルを結合して、各学生の受講講座数と成績の平均点を計算するSQLを書いてください。成績がない場合も学生と講座は表示してください。結果を平均点の高い順に並べてください。

### 問題17-6
授業カレンダー（course_schedule）テーブル、講座（courses）テーブル、教師（teachers）テーブル、教師スケジュール管理（teacher_unavailability）テーブルを結合して、2025年5月20日以降に予定されている授業のうち、担当教師が不在期間と重なっている授業を特定するSQLを書いてください。結果には授業日、講座名、教師名、不在理由を含めてください。

## 解答

### 解答17-1
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    c.course_id,
    c.course_name AS 講座名
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE s.student_id = 302
ORDER BY c.course_id;
```

### 解答17-2
```sql
SELECT 
    c.course_name AS 講座名,
    cl.classroom_name AS 教室名,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間,
    t.teacher_name AS 担当教師名
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
WHERE cs.schedule_date = '2025-05-22'
ORDER BY cp.start_time, cl.classroom_id;
```

### 解答17-3
```sql
SELECT 
    s.student_name AS 学生名,
    g.score AS 得点,
    c.course_name AS 講座名
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN courses c ON g.course_id = c.course_id
WHERE c.course_id = '1'
  AND g.grade_type = '中間テスト'
ORDER BY g.score DESC;
```

### 解答17-4
```sql
SELECT 
    cs.schedule_date AS 授業日,
    c.course_name AS 講座名,
    cl.classroom_name AS 教室名,
    cp.start_time AS 開始時間,
    cp.end_time AS 終了時間
FROM teachers t
JOIN course_schedule cs ON t.teacher_id = cs.teacher_id
JOIN courses c ON cs.course_id = c.course_id
JOIN classrooms cl ON cs.classroom_id = cl.classroom_id
JOIN class_periods cp ON cs.period_id = cp.period_id
WHERE t.teacher_id = 106
  AND cs.schedule_date BETWEEN '2025-05-01' AND '2025-05-31'
ORDER BY cs.schedule_date, cp.start_time;
```

### 解答17-5
```sql
SELECT 
    s.student_id,
    s.student_name AS 学生名,
    COUNT(DISTINCT sc.course_id) AS 受講講座数,
    AVG(g.score) AS 平均点
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN courses c ON sc.course_id = c.course_id
LEFT JOIN grades g ON s.student_id = g.student_id AND c.course_id = g.course_id
GROUP BY s.student_id, s.student_name
ORDER BY 平均点 DESC NULLS LAST;
```

注：`NULLS LAST`はデータベースによってはサポートされていない場合があります。その場合は以下のように書き換えます：

```sql
ORDER BY CASE WHEN AVG(g.score) IS NULL THEN 0 ELSE 1 END DESC, AVG(g.score) DESC
```

### 解答17-6
```sql
SELECT 
    cs.schedule_date AS 授業日,
    c.course_name AS 講座名,
    t.teacher_name AS 教師名,
    tu.reason AS 不在理由
FROM course_schedule cs
JOIN courses c ON cs.course_id = c.course_id
JOIN teachers t ON cs.teacher_id = t.teacher_id
JOIN teacher_unavailability tu ON cs.teacher_id = tu.teacher_id
WHERE cs.schedule_date >= '2025-05-20'
  AND cs.schedule_date BETWEEN tu.start_date AND tu.end_date
ORDER BY cs.schedule_date, cs.period_id;
```

## まとめ

この章では、3つ以上のテーブルを結合して複雑な情報を取得する方法について学びました：

1. **複数テーブル結合の基本構文**：JOINをチェーンさせて3つ以上のテーブルを連結する方法
2. **さまざまな結合タイプの組み合わせ**：INNER JOIN、LEFT JOIN、RIGHT JOINを状況に応じて組み合わせる方法
3. **結合順序とパフォーマンスの考慮点**：効率的なクエリを作成するためのヒント
4. **テーブル別名の重要性**：複数テーブル結合での可読性と明確さの向上
5. **複雑な結合の実用例**：実際の業務で使われるような多テーブル結合の例

複数テーブルの結合は、関連するデータを効率的に取得し、有意義な情報を抽出するための重要なスキルです。特に正規化されたデータベースでは、必要な情報を得るためには複数のテーブルを結合することが必須となります。

次の章では、「サブクエリ：WHERE句内のサブクエリ」について学び、クエリの中に別のクエリを埋め込む高度なテクニックを習得していきます。
