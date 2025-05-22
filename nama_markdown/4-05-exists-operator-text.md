# 22. EXISTS演算子：存在確認のクエリ

## はじめに

これまでの章で、サブクエリ、相関サブクエリ、集合演算について学び、その中でEXISTS演算子にも触れてきました。EXISTS演算子は、レコードの存在確認に特化した非常に強力で頻繁に使用されるSQL機能です。

EXISTS演算子は以下のような場面で特に威力を発揮します：
- 「特定の条件を満たすレコードが存在する場合のみ」という条件付き検索
- 「関連テーブルに対応するデータがある/ない」という存在チェック
- 「複数の条件をすべて満たす」または「いずれかの条件を満たす」という複雑な条件設定
- 大きなデータセットでの効率的な存在確認

この章では、EXISTS演算子の詳細な使い方、パフォーマンス特性、そして実践的な活用方法について深く学びます。

## EXISTS演算子とは

EXISTS演算子は、サブクエリが少なくとも1行の結果を返すかどうかをチェックする演算子です。結果の値そのものは重要ではなく、「存在するかどうか」だけが評価されます。

> **用語解説**：
> - **EXISTS**：サブクエリが少なくとも1行の結果を返すかどうかをチェックする演算子です。
> - **NOT EXISTS**：サブクエリが結果を1行も返さないかどうかをチェックする演算子です。
> - **存在確認**：データが存在するかどうかを確認することで、値そのものではなく存在の有無だけを調べる操作です。

### EXISTSの特徴

1. **真偽値の返却**：EXISTSは常にTRUE（真）またはFALSE（偽）を返します。
2. **効率的な処理**：サブクエリが1行でも条件に一致すれば、それ以上の検索を停止します（ショートサーキット評価）。
3. **NULLに影響されない**：サブクエリの結果にNULL値が含まれていても正常に動作します。
4. **相関サブクエリとの相性**：外部クエリとの相関関係を持つサブクエリと組み合わせて使用されることが多いです。

## EXISTS演算子の基本構文

```sql
SELECT カラム1, カラム2, ...
FROM テーブル1
WHERE EXISTS (
    SELECT 1  -- または任意のカラム
    FROM テーブル2
    WHERE 条件
);
```

EXISTSのサブクエリでは、`SELECT 1`や`SELECT *`のように書くのが一般的です。実際の値は使用されないため、どのような値を SELECT しても結果は同じです。

## EXISTS演算子の基本例

### 例1：EXISTSの基本的な使用

成績記録がある学生のみを取得：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
)
ORDER BY s.student_id;
```

このクエリでは：
1. 外部クエリでstudentsテーブルから各学生を処理します。
2. 各学生に対して、サブクエリでその学生の成績記録があるかチェックします。
3. 成績記録が存在する学生のみが結果に含まれます。

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| 306        | 河田咲奈     |
| ...        | ...          |

### 例2：NOT EXISTSの使用

成績記録がない学生を取得：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
)
ORDER BY s.student_id;
```

NOT EXISTSは、サブクエリが結果を1行も返さない場合にTRUEを返します。

実行結果：

| student_id | student_name |
|------------|--------------|
| 304        | 森下風凛     |
| 305        | 河口菜恵子   |
| 309        | 相沢吉夫     |
| 312        | 佐々木優斗   |
| ...        | ...          |

## EXISTS vs IN：違いとパフォーマンス

EXISTSとINは、似たような結果を得ることができる場合がありますが、重要な違いがあります。

### 例3：EXISTSとINの比較

#### EXISTSを使用した場合：
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
    AND sc.course_id = '1'
);
```

#### INを使用した場合：
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT sc.student_id
    FROM student_courses sc
    WHERE sc.course_id = '1'
);
```

### EXISTSとINの主な違い

| 項目 | EXISTS | IN |
|------|--------|-----|
| **NULL値の扱い** | NULL値に影響されない | サブクエリにNULLが含まれると予期しない結果になることがある |
| **パフォーマンス** | 1行見つかると検索停止（効率的） | 場合によってはすべての結果を評価する必要がある |
| **相関サブクエリ** | 外部クエリとの相関関係を自然に表現できる | 相関関係の表現が複雑になる場合がある |
| **重複の扱い** | 重複を気にする必要がない | サブクエリの重複が結果に影響することがある |

### NULL値の問題例

INでの問題例：
```sql
-- NOT INでNULL値が含まれる場合の問題
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id NOT IN (
    SELECT sc.student_id
    FROM student_courses sc
    WHERE sc.course_id = '999'  -- 存在しない講座ID
);
-- 上記クエリは期待通りに動作しない可能性があります（NULLが含まれる場合）
```

NOT EXISTSを使用した場合：
```sql
-- NOT EXISTSは安全に動作します
SELECT s.student_id, s.student_name
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
    AND sc.course_id = '999'
);
```

## 複雑な存在確認パターン

### 例4：複数条件の存在確認

中間テストとレポート1の両方を提出している学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g1
    WHERE g1.student_id = s.student_id
    AND g1.grade_type = '中間テスト'
)
AND EXISTS (
    SELECT 1
    FROM grades g2
    WHERE g2.student_id = s.student_id
    AND g2.grade_type = 'レポート1'
)
ORDER BY s.student_id;
```

このクエリでは、各学生について「中間テストがある」AND「レポート1がある」という2つの条件をそれぞれ別のEXISTS句でチェックしています。

### 例5：条件付き存在確認

85点以上の成績を少なくとも1つ持つ学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
    AND g.score >= 85
)
ORDER BY s.student_id;
```

### 例6：複雑な相関条件

各講座において平均点以上を取った学生を検索：

```sql
SELECT DISTINCT s.student_id, s.student_name, c.course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
    AND g.course_id = sc.course_id
    AND g.score >= (
        SELECT AVG(score)
        FROM grades g2
        WHERE g2.course_id = g.course_id
    )
)
ORDER BY s.student_id, c.course_name;
```

このクエリでは、EXISTSサブクエリの中にさらにサブクエリが含まれており、各講座の平均点と比較しています。

## NOT EXISTSの高度な活用

NOT EXISTSは、「〜が存在しない」という条件を表現するために使用され、データの欠損や未達成条件の特定に非常に有効です。

### 例7：完全な条件の否定

すべての講座で80点以上を取っている学生（80点未満の成績が存在しない学生）を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 少なくとも1つの成績記録がある
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
)
AND NOT EXISTS (
    -- 80点未満の成績が存在しない
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
    AND g.score < 80
)
ORDER BY s.student_id;
```

### 例8：関連データの完全性チェック

受講しているすべての講座に出席している学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 受講している講座がある
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
)
AND NOT EXISTS (
    -- 欠席した授業が存在しない
    SELECT 1
    FROM student_courses sc
    JOIN course_schedule cs ON sc.course_id = cs.course_id
    WHERE sc.student_id = s.student_id
    AND NOT EXISTS (
        SELECT 1
        FROM attendance a
        WHERE a.student_id = sc.student_id
        AND a.schedule_id = cs.schedule_id
        AND a.status = 'present'
    )
)
ORDER BY s.student_id;
```

## EXISTS演算子を使った実践的なクエリパターン

### 例9：階層的な存在確認

特定の教師が担当する講座を受講し、かつその講座で良い成績を収めている学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM student_courses sc
    JOIN courses c ON sc.course_id = c.course_id
    JOIN teachers t ON c.teacher_id = t.teacher_id
    WHERE sc.student_id = s.student_id
    AND t.teacher_name = '寺内鞍'
    AND EXISTS (
        SELECT 1
        FROM grades g
        WHERE g.student_id = s.student_id
        AND g.course_id = sc.course_id
        AND g.score >= 85
    )
)
ORDER BY s.student_id;
```

### 例10：時系列での存在確認

最近の授業（直近30日間）で欠席したことがない学生を検索：

```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 直近30日間に授業がある
    SELECT 1
    FROM student_courses sc
    JOIN course_schedule cs ON sc.course_id = cs.course_id
    WHERE sc.student_id = s.student_id
    AND cs.schedule_date >= CURRENT_DATE - INTERVAL 30 DAY
)
AND NOT EXISTS (
    -- 直近30日間で欠席していない
    SELECT 1
    FROM student_courses sc
    JOIN course_schedule cs ON sc.course_id = cs.course_id
    LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id 
                           AND a.student_id = s.student_id
    WHERE sc.student_id = s.student_id
    AND cs.schedule_date >= CURRENT_DATE - INTERVAL 30 DAY
    AND (a.status IS NULL OR a.status != 'present')
)
ORDER BY s.student_id;
```

## EXISTS演算子のパフォーマンス最適化

EXISTSを効率的に使用するためのポイントを説明します。

### 1. インデックスの活用

EXISTS句で使用される結合条件にはインデックスを設定することが重要です：

```sql
-- 効率的なEXISTSクエリの例
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id  -- student_idにインデックスが必要
    AND g.score >= 90
);
```

### 2. 適切な条件の配置

より選択性の高い条件を先に配置することで、処理を効率化できます：

```sql
-- 効率的な条件の配置
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.score >= 95  -- 選択性の高い条件を先に
    AND g.student_id = s.student_id  -- 結合条件を後に
);
```

### 3. 不要な結合の回避

EXISTSではサブクエリの結果値が使用されないため、必要最小限の結合にとどめます：

```sql
-- 効率的なEXISTSクエリ
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
    AND sc.course_id = '1'
    -- 不要な結合（coursesテーブルなど）は行わない
);
```

## EXISTS演算子と他の手法の使い分け

### 1. EXISTS vs JOIN

#### EXISTSが適している場合：
- 存在確認だけが目的
- 関連テーブルからのデータが不要
- 1対多の関係で重複を避けたい

```sql
-- EXISTS：存在確認のみ
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
);
```

#### JOINが適している場合：
- 関連テーブルからのデータも取得したい
- パフォーマンスが重要
- 集計などの追加処理が必要

```sql
-- JOIN：関連データも取得
SELECT DISTINCT s.student_id, s.student_name, g.score
FROM students s
JOIN grades g ON s.student_id = g.student_id;
```

### 2. EXISTS vs IN

#### EXISTSが適している場合：
- サブクエリにNULL値が含まれる可能性がある
- 相関サブクエリを使用する
- 複雑な条件がある

#### INが適している場合：
- 単純な値のリストとの照合
- サブクエリが非相関で簡潔
- NULLが含まれない確実な場合

## 練習問題

### 問題22-1
EXISTS演算子を使用して、レポート1の成績が90点以上の学生が在籍している講座を取得するSQLを書いてください。結果には講座ID、講座名、担当教師名を含めてください。

### 問題22-2
NOT EXISTS演算子を使用して、2025年5月20日以降の授業にまだ一度も欠席（status = 'absent'）していない学生を取得するSQLを書いてください。ただし、授業に出席した記録がある学生のみを対象とします。

### 問題22-3
EXISTS演算子を使用して、担当しているすべての講座で平均受講者数が10人以上の教師を取得するSQLを書いてください。NOT EXISTSも組み合わせて使用してください。

### 問題22-4
EXISTS演算子を使用して、プログラミング関連の講座（course_id = 3, 4, 8のいずれか）を受講し、かつそのすべての講座で80点以上を取得している学生を取得するSQLを書いてください。

### 問題22-5
EXISTS演算子を使用して、同じ教師が担当する複数の講座を受講している学生を取得するSQLを書いてください。結果には学生ID、学生名、教師名を含めてください。

### 問題22-6
NOT EXISTS演算子を使用して、受講している講座があるにも関わらず、成績記録が一切ない学生を特定するSQLを書いてください。このような学生は成績入力漏れの可能性があります。

## 解答

### 解答22-1
```sql
SELECT c.course_id, c.course_name, t.teacher_name
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE EXISTS (
    SELECT 1
    FROM grades g
    JOIN students s ON g.student_id = s.student_id
    JOIN student_courses sc ON s.student_id = sc.student_id
    WHERE sc.course_id = c.course_id
    AND g.course_id = c.course_id
    AND g.grade_type = 'レポート1'
    AND g.score >= 90
)
ORDER BY c.course_id;
```

### 解答22-2
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 出席記録がある学生
    SELECT 1
    FROM attendance a
    WHERE a.student_id = s.student_id
)
AND NOT EXISTS (
    -- 2025年5月20日以降に欠席していない
    SELECT 1
    FROM attendance a
    JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
    WHERE a.student_id = s.student_id
    AND cs.schedule_date >= '2025-05-20'
    AND a.status = 'absent'
)
ORDER BY s.student_id;
```

### 解答22-3
```sql
SELECT t.teacher_id, t.teacher_name
FROM teachers t
WHERE EXISTS (
    -- 担当講座がある
    SELECT 1
    FROM courses c
    WHERE c.teacher_id = t.teacher_id
)
AND NOT EXISTS (
    -- 受講者数が10人未満の講座が存在しない
    SELECT 1
    FROM courses c
    WHERE c.teacher_id = t.teacher_id
    AND (
        SELECT COUNT(*)
        FROM student_courses sc
        WHERE sc.course_id = c.course_id
    ) < 10
)
ORDER BY t.teacher_id;
```

### 解答22-4
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- プログラミング関連講座を受講している
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
    AND sc.course_id IN ('3', '4', '8')
)
AND NOT EXISTS (
    -- 受講しているプログラミング関連講座で80点未満の成績が存在しない
    SELECT 1
    FROM student_courses sc
    JOIN grades g ON sc.student_id = g.student_id AND sc.course_id = g.course_id
    WHERE sc.student_id = s.student_id
    AND sc.course_id IN ('3', '4', '8')
    AND g.score < 80
)
ORDER BY s.student_id;
```

### 解答22-5
```sql
SELECT DISTINCT s.student_id, s.student_name, t.teacher_name
FROM students s
JOIN student_courses sc1 ON s.student_id = sc1.student_id
JOIN courses c1 ON sc1.course_id = c1.course_id
JOIN teachers t ON c1.teacher_id = t.teacher_id
WHERE EXISTS (
    -- 同じ教師が担当する別の講座も受講している
    SELECT 1
    FROM student_courses sc2
    JOIN courses c2 ON sc2.course_id = c2.course_id
    WHERE sc2.student_id = s.student_id
    AND c2.teacher_id = t.teacher_id
    AND sc2.course_id != sc1.course_id
)
ORDER BY s.student_id, t.teacher_name;
```

### 解答22-6
```sql
SELECT s.student_id, s.student_name
FROM students s
WHERE EXISTS (
    -- 受講している講座がある
    SELECT 1
    FROM student_courses sc
    WHERE sc.student_id = s.student_id
)
AND NOT EXISTS (
    -- 成績記録が存在しない
    SELECT 1
    FROM grades g
    WHERE g.student_id = s.student_id
)
ORDER BY s.student_id;
```

## まとめ

この章では、EXISTS演算子について詳しく学びました：

1. **EXISTS演算子の基本概念**：
   - レコードの存在確認に特化した演算子
   - TRUE/FALSEの真偽値を返し、値そのものは評価しない
   - ショートサーキット評価による効率的な処理

2. **EXISTS vs IN の違い**：
   - NULL値の扱いにおける安全性の違い
   - パフォーマンス特性の違い
   - 相関サブクエリとの親和性

3. **NOT EXISTSの活用**：
   - 否定条件の表現
   - データの欠損や未達成条件の特定
   - 完全性チェックの実装

4. **複雑な存在確認パターン**：
   - 複数条件の組み合わせ
   - 階層的な存在確認
   - 条件付き存在確認

5. **パフォーマンス最適化**：
   - インデックスの重要性
   - 効率的な条件配置
   - 不要な結合の回避

6. **他の手法との使い分け**：
   - EXISTS vs JOIN の適切な選択
   - EXISTS vs IN の使い分け基準

EXISTS演算子は、データの存在確認において非常に強力で安全な方法を提供します。特に、NULL値の扱いやパフォーマンスの観点から、多くの場面でINよりも適切な選択となります。適切に使用することで、複雑な条件でのデータ検索や関連性の確認が効率的に行えるようになります。

次の章では、「CASE式：条件分岐による値の変換」について学び、SQLでの条件付きロジックの実装方法を深く理解していきます。
