# 16. 自己結合：同一テーブル内での関連付け

## はじめに

これまでの章では、異なるテーブル同士を結合する方法について学びました。しかし実際のデータベース設計では、同じテーブル内にデータ同士の関連がある場合があります。例えば：

- 社員テーブルで「上司」も同じ社員テーブル内の別の社員である
- 部品表で「部品」と「その部品の構成部品」が同じテーブルに格納されている
- 家系図データで「親」と「子」が同じ人物テーブルに格納されている

このような「同一テーブル内のレコード同士の関連」を取り扱うための結合方法が「自己結合（セルフジョイン）」です。この章では、テーブル自身と結合して情報を取得する方法について学びます。

## 自己結合（セルフジョイン）とは

自己結合とは、テーブルを自分自身と結合する技術です。テーブル内のあるレコードと、同じテーブル内の別のレコードとの関係を表現するために使用されます。

> **用語解説**：
> - **自己結合（セルフジョイン）**：同じテーブルを異なる別名で参照し、テーブル自身と結合する手法です。
> - **再帰的関係**：同じエンティティ（テーブル）内での親子関係や階層構造などの関係のこと。

## 自己結合の基本

自己結合を行うには、同じテーブルを異なる別名で参照する必要があります。これは通常、テーブル別名（エイリアス）を使用して実現します。

### 基本構文

```sql
SELECT a.カラム1, a.カラム2, b.カラム1, b.カラム2
FROM テーブル名 a
JOIN テーブル名 b ON a.関連カラム = b.主キー;
```

ここで、`a`と`b`は同じテーブルに対する異なる別名です。

## 自己結合の実践例

学校データベースでは、明示的な再帰的関係を持つテーブルはありませんが、自己結合の概念を理解するために簡単な例を見てみましょう。

### 例1：同じ教師が担当する講座を検索

```sql
SELECT 
    c1.course_id AS 講座ID, 
    c1.course_name AS 講座名,
    c2.course_id AS 関連講座ID,
    c2.course_name AS 関連講座名,
    t.teacher_name AS 担当教師
FROM courses c1
JOIN courses c2 ON c1.teacher_id = c2.teacher_id AND c1.course_id < c2.course_id
JOIN teachers t ON c1.teacher_id = t.teacher_id
ORDER BY t.teacher_name, c1.course_id, c2.course_id;
```

このクエリは、同じ教師が担当している講座の組み合わせを検索しています。
- `c1`と`c2`は同じcoursesテーブルの別名
- `c1.teacher_id = c2.teacher_id`で同じ教師を担当している講座を結合
- `c1.course_id < c2.course_id`でペアの重複を避けています（例：講座1と講座2、講座2と講座1が両方表示されることを防ぐ）

実行結果：

| 講座ID | 講座名                 | 関連講座ID | 関連講座名             | 担当教師   |
|-------|------------------------|-----------|------------------------|-----------|
| 4     | Webアプリケーション開発 | 8         | モバイルアプリ開発     | 藤本理恵   |
| 4     | Webアプリケーション開発 | 22        | フルスタック開発マスタークラス | 藤本理恵 |
| 8     | モバイルアプリ開発     | 22        | フルスタック開発マスタークラス | 藤本理恵 |
| 1     | ITのための基礎知識     | 3         | Cプログラミング演習     | 寺内鞍     |
| 1     | ITのための基礎知識     | 29        | コードリファクタリングとクリーンコード | 寺内鞍 |
| 3     | Cプログラミング演習     | 29        | コードリファクタリングとクリーンコード | 寺内鞍 |
| ...   | ...                    | ...       | ...                    | ...       |

### 例2：同じ日に複数の授業がある教師を検索

```sql
SELECT 
    cs1.schedule_date AS 日付,
    t.teacher_name AS 教師名,
    cs1.period_id AS 時限1,
    c1.course_name AS 講座1,
    cs2.period_id AS 時限2,
    c2.course_name AS 講座2
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.teacher_id = cs2.teacher_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.period_id < cs2.period_id
JOIN teachers t ON cs1.teacher_id = t.teacher_id
JOIN courses c1 ON cs1.course_id = c1.course_id
JOIN courses c2 ON cs2.course_id = c2.course_id
WHERE cs1.schedule_date = '2025-05-21'
ORDER BY cs1.schedule_date, t.teacher_name, cs1.period_id, cs2.period_id;
```

このクエリは、同じ日に複数の授業を担当する教師と、その授業の組み合わせを検索しています。
- `cs1`と`cs2`は同じcourse_scheduleテーブルの別名
- `cs1.teacher_id = cs2.teacher_id AND cs1.schedule_date = cs2.schedule_date`で同じ教師が同じ日に担当している授業を結合
- `cs1.period_id < cs2.period_id`でペアの重複を避けています

実行結果（例）：

| 日付       | 教師名     | 時限1 | 講座1                 | 時限2 | 講座2                 |
|-----------|------------|------|----------------------|------|----------------------|
| 2025-05-21 | 星野涼子   | 1    | 高度データ可視化技術   | 3    | データサイエンスとビジネス応用 |
| 2025-05-21 | 寺内鞍     | 2    | コードリファクタリングとクリーンコード | 4 | Cプログラミング演習 |
| ...       | ...        | ...  | ...                  | ...  | ...                  |

## 自己結合の応用：階層構造の表現

自己結合は、階層構造のデータを表現する際に特に役立ちます。例えば、組織図、カテゴリ階層、部品表などです。

ここでは、学校データベースにはない例として、架空の「社員」テーブルを使って階層構造を表現する例を示します：

### 例3：架空の社員テーブルを使った階層構造の表現

```sql
-- 架空の社員テーブル
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100),
  manager_id INT,
  FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- サンプルデータ
INSERT INTO employees VALUES (1, '山田太郎', NULL);  -- 社長（上司なし）
INSERT INTO employees VALUES (2, '佐藤次郎', 1);     -- 山田の部下
INSERT INTO employees VALUES (3, '鈴木三郎', 1);     -- 山田の部下
INSERT INTO employees VALUES (4, '高橋四郎', 2);     -- 佐藤の部下
INSERT INTO employees VALUES (5, '田中五郎', 2);     -- 佐藤の部下
INSERT INTO employees VALUES (6, '伊藤六郎', 3);     -- 鈴木の部下

-- 社員と直属の上司を取得
SELECT 
    e.employee_id,
    e.employee_name AS 社員名,
    m.employee_name AS 上司名
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;
```

結果：

| employee_id | 社員名     | 上司名     |
|-------------|------------|------------|
| 1           | 山田太郎   | NULL       |
| 2           | 佐藤次郎   | 山田太郎   |
| 3           | 鈴木三郎   | 山田太郎   |
| 4           | 高橋四郎   | 佐藤次郎   |
| 5           | 田中五郎   | 佐藤次郎   |
| 6           | 伊藤六郎   | 鈴木三郎   |

この例では、社員テーブルの`manager_id`が同じテーブルの`employee_id`を参照しています（自己参照）。自己結合を使用して、各社員の上司の名前を取得しています。

### 例4：架空の社員テーブルを使った部下の一覧表示

```sql
-- ある上司の直属の部下を取得
SELECT 
    m.employee_id AS 上司ID,
    m.employee_name AS 上司名,
    e.employee_id AS 部下ID,
    e.employee_name AS 部下名
FROM employees m
JOIN employees e ON m.employee_id = e.manager_id
WHERE m.employee_id = 2
ORDER BY e.employee_id;
```

結果：

| 上司ID | 上司名   | 部下ID | 部下名   |
|--------|----------|--------|----------|
| 2      | 佐藤次郎 | 4      | 高橋四郎 |
| 2      | 佐藤次郎 | 5      | 田中五郎 |

この例では、社員テーブルを`m`（上司）と`e`（部下）として自己結合し、上司ID=2の部下を取得しています。

## 学校データベースでの自己結合活用例

実際の学校データベースでは、自己結合を利用できる具体的なシナリオを見てみましょう。

### 例5：同じ教室を使用する授業の組み合わせ

```sql
SELECT 
    cs1.schedule_date AS 日付,
    cs1.classroom_id AS 教室,
    cs1.period_id AS 時限1,
    c1.course_name AS 講座1,
    t1.teacher_name AS 教師1,
    cs2.period_id AS 時限2,
    c2.course_name AS 講座2,
    t2.teacher_name AS 教師2
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.classroom_id = cs2.classroom_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.period_id < cs2.period_id
JOIN courses c1 ON cs1.course_id = c1.course_id
JOIN courses c2 ON cs2.course_id = c2.course_id
JOIN teachers t1 ON cs1.teacher_id = t1.teacher_id
JOIN teachers t2 ON cs2.teacher_id = t2.teacher_id
WHERE cs1.schedule_date = '2025-05-21'
ORDER BY cs1.classroom_id, cs1.period_id;
```

このクエリは、同じ日に同じ教室で行われる授業の組み合わせを検索しています。教室の利用状況や消毒・清掃のスケジュール計画などに役立ちます。

### 例6：同じ学生が受講している講座の組み合わせ

```sql
SELECT 
    sc1.student_id,
    s.student_name,
    c1.course_name AS 講座1,
    c2.course_name AS 講座2
FROM student_courses sc1
JOIN student_courses sc2 ON sc1.student_id = sc2.student_id AND sc1.course_id < sc2.course_id
JOIN students s ON sc1.student_id = s.student_id
JOIN courses c1 ON sc1.course_id = c1.course_id
JOIN courses c2 ON sc2.course_id = c2.course_id
WHERE sc1.student_id = 301
ORDER BY c1.course_name, c2.course_name;
```

このクエリは、学生ID=301の学生が受講しているすべての講座の組み合わせを検索しています。学生の履修パターンの分析や時間割の調整などに役立ちます。

## INNER JOINとLEFT JOINの自己結合

自己結合では、INNER JOIN、LEFT JOIN、RIGHT JOINなど、すべての結合タイプを使用できます。結合タイプの選択は、取得したいデータの性質に依存します。

### 例7：部下のいない社員を見つける（LEFT JOIN）

```sql
-- 架空の社員テーブルを使用
SELECT 
    m.employee_id,
    m.employee_name,
    COUNT(e.employee_id) AS 部下の数
FROM employees m
LEFT JOIN employees e ON m.employee_id = e.manager_id
GROUP BY m.employee_id, m.employee_name
HAVING COUNT(e.employee_id) = 0
ORDER BY m.employee_id;
```

このクエリは、部下のいない社員（つまり、誰も自分を上司として参照していない社員）を検索しています。結果として、employee_id = 4, 5, 6の社員（高橋四郎、田中五郎、伊藤六郎）が表示されるでしょう。

## 自己結合の注意点

自己結合を使用する際には、以下の点に注意が必要です：

1. **テーブル別名の明確化**：同じテーブルを複数回参照するため、わかりやすいテーブル別名を使用し、混乱を避けましょう。

2. **結合条件の正確性**：自己結合では結合条件が不適切だと、結果が指数関数的に増えることがあります。必要に応じて絞り込み条件を追加しましょう。

3. **重複の排除**：例1や例2で使用した`id1 < id2`のような条件を使って、組み合わせの重複を避けることが重要です。

4. **パフォーマンス**：自己結合は、特に大きなテーブルでは処理が重くなる可能性があります。必要に応じてインデックスを使用して最適化しましょう。

## 練習問題

### 問題16-1
教師（teachers）テーブルを自己結合して、教師IDが連続する教師のペア（例：ID 101と102, 102と103）を取得するSQLを書いてください。

### 問題16-2
course_schedule（授業カレンダー）テーブルを自己結合して、2025年5月15日に同じ教室で行われる授業のペアを時限の昇順で取得するSQLを書いてください。course_id、period_id、classroom_idの3つを表示してください。

### 問題16-3
生徒（students）テーブルを自己結合して、学生名（student_name）のファーストネーム（名前の最初の文字）が同じ学生のペアを取得するSQLを書いてください。ヒント：SUBSTRING関数を使用します。

### 問題16-4
course_schedule（授業カレンダー）テーブルを自己結合して、同じ日に同じ講師が担当する授業のペアを見つけるSQLを書いてください。期間が離れていない授業（period_idの差が1または2）のみを対象とします。

### 問題16-5
grades（成績）テーブルを自己結合して、同じ学生の異なる課題タイプ（grade_type）間で点数差が10点以上あるケースを検出するSQLを書いてください。

### 問題16-6
以下のような架空の「職階」テーブルを作成し、直接の上下関係（部下と上司）だけでなく、組織階層全体を表示するSQLを書いてください。

```sql
-- 架空の職階テーブル
CREATE TABLE job_hierarchy (
  level_id INT PRIMARY KEY,
  level_name VARCHAR(50),
  reports_to INT,
  FOREIGN KEY (reports_to) REFERENCES job_hierarchy(level_id)
);

-- データ挿入
INSERT INTO job_hierarchy VALUES (1, '学長', NULL);
INSERT INTO job_hierarchy VALUES (2, '副学長', 1);
INSERT INTO job_hierarchy VALUES (3, '学部長', 2);
INSERT INTO job_hierarchy VALUES (4, '学科長', 3);
INSERT INTO job_hierarchy VALUES (5, '教授', 4);
INSERT INTO job_hierarchy VALUES (6, '准教授', 5);
INSERT INTO job_hierarchy VALUES (7, '講師', 6);
INSERT INTO job_hierarchy VALUES (8, '助教', 7);
```

## 解答

### 解答16-1
```sql
SELECT 
    t1.teacher_id AS 教師ID1,
    t1.teacher_name AS 教師名1,
    t2.teacher_id AS 教師ID2,
    t2.teacher_name AS 教師名2
FROM teachers t1
JOIN teachers t2 ON t1.teacher_id + 1 = t2.teacher_id
ORDER BY t1.teacher_id;
```

### 解答16-2
```sql
SELECT 
    cs1.course_id AS 講座ID1,
    cs1.period_id AS 時限1,
    cs2.course_id AS 講座ID2,
    cs2.period_id AS 時限2,
    cs1.classroom_id AS 教室
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.classroom_id = cs2.classroom_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.period_id < cs2.period_id
WHERE cs1.schedule_date = '2025-05-15'
ORDER BY cs1.classroom_id, cs1.period_id, cs2.period_id;
```

### 解答16-3
```sql
SELECT 
    s1.student_id AS 学生ID1,
    s1.student_name AS 学生名1,
    s2.student_id AS 学生ID2,
    s2.student_name AS 学生名2,
    SUBSTRING(s1.student_name, 1, 1) AS 共通文字
FROM students s1
JOIN students s2 ON SUBSTRING(s1.student_name, 1, 1) = SUBSTRING(s2.student_name, 1, 1)
              AND s1.student_id < s2.student_id
ORDER BY 共通文字, s1.student_id, s2.student_id;
```

### 解答16-4
```sql
SELECT 
    cs1.schedule_date AS 日付,
    t.teacher_name AS 教師名,
    cs1.period_id AS 時限1,
    cs1.course_id AS 講座ID1,
    cs2.period_id AS 時限2,
    cs2.course_id AS 講座ID2,
    ABS(cs1.period_id - cs2.period_id) AS 時限差
FROM course_schedule cs1
JOIN course_schedule cs2 ON cs1.teacher_id = cs2.teacher_id 
                         AND cs1.schedule_date = cs2.schedule_date 
                         AND cs1.schedule_id < cs2.schedule_id
JOIN teachers t ON cs1.teacher_id = t.teacher_id
WHERE ABS(cs1.period_id - cs2.period_id) IN (1, 2)
ORDER BY cs1.schedule_date, t.teacher_name, cs1.period_id;
```

### 解答16-5
```sql
SELECT 
    g1.student_id,
    s.student_name,
    g1.grade_type AS 評価タイプ1,
    g1.score AS 点数1,
    g2.grade_type AS 評価タイプ2,
    g2.score AS 点数2,
    ABS(g1.score - g2.score) AS 点数差
FROM grades g1
JOIN grades g2 ON g1.student_id = g2.student_id 
               AND g1.course_id = g2.course_id 
               AND g1.grade_type < g2.grade_type
JOIN students s ON g1.student_id = s.student_id
WHERE ABS(g1.score - g2.score) >= 10
ORDER BY 点数差 DESC, g1.student_id;
```

### 解答16-6
```sql
-- 組織階層全体を表示
WITH RECURSIVE hierarchy AS (
  -- 基点（学長）
  SELECT 
    level_id, 
    level_name, 
    reports_to, 
    0 AS depth, 
    CAST(level_name AS CHAR(200)) AS path
  FROM job_hierarchy
  WHERE reports_to IS NULL
  
  UNION ALL
  
  -- 再帰部分
  SELECT 
    j.level_id, 
    j.level_name, 
    j.reports_to, 
    h.depth + 1, 
    CONCAT(h.path, ' > ', j.level_name)
  FROM job_hierarchy j
  JOIN hierarchy h ON j.reports_to = h.level_id
)
SELECT 
  level_id,
  level_name,
  reports_to,
  depth,
  CONCAT(REPEAT('    ', depth), level_name) AS 階層表示,
  path AS 組織経路
FROM hierarchy
ORDER BY depth, level_id;
```

注意：最後の問題は再帰共通テーブル式（Recursive CTE）を使用しています。これはMySQL 8.0以降でサポートされています。再帰CTEはまだ学習していない高度な内容ですが、階層構造を扱う効果的な方法として参考になります。

## まとめ

この章では、同一テーブル内でのレコード間の関連を扱うための「自己結合」について学びました：

1. **自己結合の概念**：テーブルを自分自身と結合して、同一テーブル内のレコード間の関係を表現する方法
2. **基本的な構文**：テーブル別名を使用して同じテーブルを複数回参照する方法
3. **実践的な例**：同じ教師が担当する講座、同じ日の複数の授業など、実用的な自己結合のケース
4. **階層構造の表現**：上司と部下、組織階層など、再帰的な関係の表現方法
5. **さまざまな結合タイプ**：INNER JOINやLEFT JOINなど、自己結合でも利用可能な結合の種類
6. **注意点**：テーブル別名の明確化、結合条件の正確性、重複の排除、パフォーマンスの考慮

自己結合は、階層構造の表現や、同一エンティティ内での関連を取り扱う強力な手法です。特に組織図、部品表、カテゴリ階層、家系図など、再帰的な関係を含むデータモデルで頻繁に活用されます。

次の章では、「複数テーブル結合：3つ以上のテーブルの連結」について学び、より複雑なデータ関係を扱う方法を学びます。
