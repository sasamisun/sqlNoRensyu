# 27. データ更新：UPDATE文

## はじめに

前章では、INSERT文を使用してデータベースに新しいデータを挿入する方法を学びました。この章では、既存のデータを変更・更新するための「UPDATE文」について学習します。

UPDATE文は、テーブル内の既存レコードの値を変更するためのSQL文で、データベースの基本操作CRUD（Create、Read、Update、Delete）の「Update」に該当します。

UPDATE文が必要となる場面の例：
- 「学生の名前に変更があったので更新したい」
- 「講座の担当教師を変更したい」
- 「成績の入力ミスを修正したい」
- 「授業のステータスを『予定』から『完了』に変更したい」
- 「一括で出席ポイントを加算したい」
- 「データクリーニングで不正な値を修正したい」

UPDATE文は非常に強力な機能ですが、誤った使用により大量のデータが意図せず変更される危険性もあります。安全な使用方法も含めて詳しく学んでいきます。

## UPDATE文とは

UPDATE文は、テーブル内の既存レコードの一部または全部のカラム値を変更するためのSQL文です。WHERE句と組み合わせることで、特定の条件に一致するレコードのみを更新できます。

> **用語解説**：
> - **UPDATE文**：既存のレコードの値を変更するSQL文です。
> - **SET句**：更新するカラム名と新しい値を指定する部分です。
> - **WHERE句**：更新対象のレコードを限定するための条件を指定します。
> - **一括更新**：複数のレコードを一度のUPDATE文で更新することです。
> - **条件付き更新**：CASE式などを使用して、条件に応じて異なる値で更新することです。
> - **結合更新**：JOINを使用して他のテーブルの情報を参照しながら更新することです。

## UPDATE文の基本構文

```sql
UPDATE テーブル名
SET カラム1 = 値1, カラム2 = 値2, ...
WHERE 条件;
```

### 重要な注意事項

**WHERE句を省略すると、テーブル内のすべてのレコードが更新されます。**これは意図しない大量更新を引き起こす可能性があるため、特に注意が必要です。

## 基本的なUPDATE文の例

### 例1：単一レコードの単一カラム更新

学生ID=301の学生名を変更：

```sql
-- 更新前の確認
SELECT student_id, student_name FROM students WHERE student_id = 301;

-- 更新実行
UPDATE students
SET student_name = '黒沢春馬（更新済み）'
WHERE student_id = 301;

-- 更新後の確認
SELECT student_id, student_name FROM students WHERE student_id = 301;
```

### 例2：複数カラムの同時更新

教室の情報を複数のカラムで同時に更新：

```sql
-- 更新前の確認
SELECT * FROM classrooms WHERE classroom_id = '101A';

-- 複数カラムの同時更新
UPDATE classrooms
SET 
    capacity = 45,
    facilities = 'PC30台、プロジェクター、ホワイトボード、エアコン'
WHERE classroom_id = '101A';

-- 更新後の確認
SELECT * FROM classrooms WHERE classroom_id = '101A';
```

### 例3：計算による更新

すべての成績に5点のボーナスポイントを加算：

```sql
-- 更新前の確認（一部のデータ）
SELECT student_id, course_id, grade_type, score 
FROM grades 
WHERE grade_type = 'レポート1' 
LIMIT 5;

-- 計算による更新
UPDATE grades
SET score = score + 5
WHERE grade_type = 'レポート1' AND score <= 95;  -- 100点を超えないように制限

-- 更新後の確認
SELECT student_id, course_id, grade_type, score 
FROM grades 
WHERE grade_type = 'レポート1' 
LIMIT 5;
```

## 条件付きUPDATE

WHERE句を使用して、特定の条件に一致するレコードのみを更新できます。

### 例4：複数条件での更新

特定の講座の特定の評価タイプの成績を更新：

```sql
-- ITのための基礎知識の中間テストで80点未満の成績を底上げ
UPDATE grades
SET score = score + 10
WHERE course_id = '1' 
  AND grade_type = '中間テスト' 
  AND score < 80;
```

### 例5：日付条件での更新

特定の日付以降の授業ステータスを更新：

```sql
-- 過去の授業を「完了」ステータスに変更
UPDATE course_schedule
SET status = 'completed'
WHERE schedule_date < CURRENT_DATE 
  AND status = 'scheduled';
```

### 例6：範囲条件での更新

学生IDの範囲を指定した更新：

```sql
-- 学生ID 301-310の学生に特別なマークを追加
UPDATE students
SET student_name = CONCAT(student_name, ' ★')
WHERE student_id BETWEEN 301 AND 310
  AND student_name NOT LIKE '%★%';  -- 既にマークがついていない場合のみ
```

## CASE式を使った条件分岐更新

CASE式を使用することで、条件に応じて異なる値で更新できます。

### 例7：成績に基づく等級の設定

成績テーブルに新しく等級カラムを追加して、点数に基づく等級を設定：

```sql
-- まず等級カラムを追加（実際の運用では必要）
-- ALTER TABLE grades ADD COLUMN grade_letter VARCHAR(2);

-- 点数に基づく等級の設定
UPDATE grades
SET grade_letter = CASE
    WHEN score >= 90 THEN 'A'
    WHEN score >= 80 THEN 'B'
    WHEN score >= 70 THEN 'C'
    WHEN score >= 60 THEN 'D'
    ELSE 'F'
END
WHERE grade_letter IS NULL OR grade_letter = '';
```

### 例8：出席状況に基づく総合評価

出席率に基づいて学生の総合評価を更新：

```sql
-- 学生テーブルに評価カラムを追加（実際の運用では必要）
-- ALTER TABLE students ADD COLUMN overall_rating VARCHAR(20);

-- 出席率に基づく総合評価の設定
UPDATE students s
SET overall_rating = CASE
    WHEN (
        SELECT AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END)
        FROM attendance a
        WHERE a.student_id = s.student_id
    ) >= 90 THEN '優秀'
    WHEN (
        SELECT AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END)
        FROM attendance a
        WHERE a.student_id = s.student_id
    ) >= 80 THEN '良好'
    WHEN (
        SELECT AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END)
        FROM attendance a
        WHERE a.student_id = s.student_id
    ) >= 70 THEN '普通'
    ELSE '要改善'
END;
```

## JOINを使ったUPDATE

他のテーブルの情報を参照しながら更新を行う場合に使用します。

### 例9：教師名に基づく講座情報の更新

教師テーブルの情報を参照して講座の説明を更新：

```sql
-- 講座テーブルに説明カラムを追加（実際の運用では必要）
-- ALTER TABLE courses ADD COLUMN description TEXT;

-- JOINを使用した更新
UPDATE courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
SET c.description = CONCAT('担当教師：', t.teacher_name, 'が指導する', c.course_name, 'の講座です。')
WHERE c.description IS NULL;
```

### 例10：平均点に基づく講座の難易度設定

各講座の平均点を基に難易度を設定：

```sql
-- 講座テーブルに難易度カラムを追加（実際の運用では必要）
-- ALTER TABLE courses ADD COLUMN difficulty_level VARCHAR(20);

-- 平均点に基づく難易度の設定
UPDATE courses c
JOIN (
    SELECT 
        course_id,
        AVG(score) as avg_score
    FROM grades
    GROUP BY course_id
) g ON c.course_id = g.course_id
SET c.difficulty_level = CASE
    WHEN g.avg_score >= 85 THEN '易しい'
    WHEN g.avg_score >= 75 THEN '標準'
    WHEN g.avg_score >= 65 THEN '難しい'
    ELSE '非常に難しい'
END;
```

## サブクエリを使ったUPDATE

### 例11：相対的な値での更新

各学生の平均点を基準とした相対評価を追加：

```sql
-- 成績テーブルに相対評価カラムを追加（実際の運用では必要）
-- ALTER TABLE grades ADD COLUMN relative_performance VARCHAR(20);

-- 学生の平均点と比較した相対評価
UPDATE grades g1
SET relative_performance = CASE
    WHEN g1.score > (
        SELECT AVG(g2.score)
        FROM grades g2
        WHERE g2.student_id = g1.student_id
    ) THEN '平均以上'
    WHEN g1.score = (
        SELECT AVG(g2.score)
        FROM grades g2
        WHERE g2.student_id = g1.student_id
    ) THEN '平均'
    ELSE '平均以下'
END;
```

### 例12：講座内順位に基づく更新

講座内での順位に基づいて特別マークを付与：

```sql
-- 成績テーブルに順位マークカラムを追加（実際の運用では必要）
-- ALTER TABLE grades ADD COLUMN rank_marker VARCHAR(10);

-- 講座内上位3位にマークを付与
UPDATE grades g1
SET rank_marker = '上位'
WHERE (
    SELECT COUNT(*)
    FROM grades g2
    WHERE g2.course_id = g1.course_id
      AND g2.grade_type = g1.grade_type
      AND g2.score > g1.score
) < 3
AND g1.grade_type = '中間テスト';
```

## NULL値の処理

### 例13：NULL値の置換

NULL値を適切なデフォルト値に置換：

```sql
-- NULLの成績を0に設定
UPDATE grades
SET score = 0
WHERE score IS NULL;

-- 空文字の評価タイプを「その他」に設定
UPDATE grades
SET grade_type = 'その他'
WHERE grade_type IS NULL OR grade_type = '';
```

### 例14：条件付きNULL設定

特定の条件下でNULLを設定：

```sql
-- 無効な成績データ（負の値や100超）をNULLに設定
UPDATE grades
SET score = NULL
WHERE score < 0 OR score > 100;
```

## 安全なUPDATE操作

### 1. 更新前の確認

```sql
-- 1. 更新対象レコードの確認
SELECT student_id, student_name 
FROM students 
WHERE student_id = 301;

-- 2. 更新実行
UPDATE students 
SET student_name = '新しい名前' 
WHERE student_id = 301;

-- 3. 更新後の確認
SELECT student_id, student_name 
FROM students 
WHERE student_id = 301;
```

### 2. 影響範囲の事前確認

```sql
-- 更新対象の件数を事前確認
SELECT COUNT(*) as update_count
FROM grades
WHERE course_id = '1' AND grade_type = '中間テスト' AND score < 70;

-- 確認後に更新実行
UPDATE grades
SET score = score + 5
WHERE course_id = '1' AND grade_type = '中間テスト' AND score < 70;
```

### 3. LIMIT句の使用（MySQLのみ）

```sql
-- 一度に更新する件数を制限
UPDATE students
SET student_name = CONCAT(student_name, ' (更新)')
WHERE student_id > 300
LIMIT 5;
```

## UPDATE文のパフォーマンス考慮点

### 1. インデックスの活用

```sql
-- WHERE句で使用するカラムにインデックスがあることを確認
-- CREATE INDEX idx_student_id ON grades(student_id);

-- インデックスを活用した効率的な更新
UPDATE grades
SET score = score + 2
WHERE student_id = 301;  -- student_idにインデックスがある場合高速
```

### 2. 大量更新時の分割実行

```sql
-- 大量データの分割更新例
UPDATE grades
SET score = LEAST(score + 3, 100)  -- 100点を超えないように制限
WHERE grade_type = 'レポート1'
  AND student_id BETWEEN 301 AND 310;  -- 範囲を限定

-- 次のバッチ
UPDATE grades
SET score = LEAST(score + 3, 100)
WHERE grade_type = 'レポート1'
  AND student_id BETWEEN 311 AND 320;
```

### 3. 効率的な結合更新

```sql
-- 効率的なJOIN UPDATE
UPDATE courses c
INNER JOIN (
    SELECT course_id, COUNT(*) as student_count
    FROM student_courses
    GROUP BY course_id
) sc ON c.course_id = sc.course_id
SET c.enrollment_count = sc.student_count;
```

## よくあるエラーと対処法

### 1. WHERE句の忘れ

```sql
-- 危険：WHERE句なし（全レコードが更新される）
-- UPDATE students SET student_name = 'テスト';

-- 安全：WHERE句あり
UPDATE students 
SET student_name = 'テスト' 
WHERE student_id = 999;  -- 存在しないIDなので実際は更新されない
```

### 2. 外部キー制約エラー

```sql
-- エラー例：存在しない教師IDに更新しようとする
-- UPDATE courses SET teacher_id = 999 WHERE course_id = '1';

-- 対処法：事前に存在確認
UPDATE courses 
SET teacher_id = 109 
WHERE course_id = '1'
  AND EXISTS (SELECT 1 FROM teachers WHERE teacher_id = 109);
```

### 3. データ型エラー

```sql
-- エラー例：文字列を数値カラムに設定
-- UPDATE grades SET score = '無効な値' WHERE grade_id = 1;

-- 対処法：適切なデータ型で更新
UPDATE grades 
SET score = 85.5 
WHERE student_id = 301 AND course_id = '1';
```

## UPDATE文のベストプラクティス

### 1. トランザクションの使用

```sql
START TRANSACTION;

-- 複数の関連する更新を実行
UPDATE students SET student_name = '更新名前' WHERE student_id = 301;
UPDATE grades SET score = score + 5 WHERE student_id = 301;

-- 問題がなければコミット
COMMIT;

-- 問題があればロールバック
-- ROLLBACK;
```

### 2. バックアップの作成

```sql
-- 重要な更新前にバックアップテーブルを作成
CREATE TABLE grades_backup AS SELECT * FROM grades;

-- 更新実行
UPDATE grades SET score = score * 1.05 WHERE grade_type = '最終評価';

-- 必要に応じて復元
-- DELETE FROM grades;
-- INSERT INTO grades SELECT * FROM grades_backup;
```

### 3. 段階的な更新

```sql
-- ステップ1：少数のレコードでテスト
UPDATE students 
SET student_name = UPPER(student_name) 
WHERE student_id = 301;

-- ステップ2：結果確認後、範囲を拡大
UPDATE students 
SET student_name = UPPER(student_name) 
WHERE student_id BETWEEN 301 AND 305;
```

## 練習問題

### 問題27-1
学生ID=302の学生名を「新垣愛留（修正版）」に更新するUPDATE文を書いてください。

### 問題27-2
「ITのための基礎知識」講座（course_id='1'）の中間テストで70点未満の成績をすべて70点に更新するUPDATE文を書いてください。

### 問題27-3
CASE式を使用して、出席テーブルの'late'（遅刻）を'present'（出席）に、'absent'（欠席）はそのまま、'present'も変更しないUPDATE文を書いてください。

### 問題27-4
JOINを使用して、各講座の受講者数を基に、20人以上の講座の名前に「【人気】」、10人未満の講座の名前に「【少人数】」の接頭辞を追加するUPDATE文を書いてください。

### 問題27-5
サブクエリを使用して、各学生の平均点が85点以上の場合に「優秀学生」、75点以上85点未満の場合に「良好学生」、それ未満の場合に「一般学生」というコメントを学生名の後に追加するUPDATE文を書いてください。

### 問題27-6
2025年5月20日より前の授業スケジュールのステータスを'completed'に、それ以降で現在日より前の授業を'ongoing'に、将来の授業は'scheduled'のままにするUPDATE文を書いてください。

## 解答

### 解答27-1
```sql
UPDATE students
SET student_name = '新垣愛留（修正版）'
WHERE student_id = 302;
```

### 解答27-2
```sql
UPDATE grades
SET score = 70
WHERE course_id = '1' 
  AND grade_type = '中間テスト' 
  AND score < 70;
```

### 解答27-3
```sql
UPDATE attendance
SET status = CASE
    WHEN status = 'late' THEN 'present'
    ELSE status
END
WHERE status = 'late';
```

### 解答27-4
```sql
UPDATE courses c
JOIN (
    SELECT 
        course_id,
        COUNT(student_id) as enrollment_count
    FROM student_courses
    GROUP BY course_id
) sc ON c.course_id = sc.course_id
SET c.course_name = CASE
    WHEN sc.enrollment_count >= 20 THEN CONCAT('【人気】', c.course_name)
    WHEN sc.enrollment_count < 10 THEN CONCAT('【少人数】', c.course_name)
    ELSE c.course_name
END
WHERE c.course_name NOT LIKE '【%】%';  -- 既に接頭辞がついていない場合のみ
```

### 解答27-5
```sql
UPDATE students s
SET student_name = CONCAT(
    s.student_name,
    CASE
        WHEN (
            SELECT AVG(score)
            FROM grades g
            WHERE g.student_id = s.student_id
        ) >= 85 THEN '（優秀学生）'
        WHEN (
            SELECT AVG(score)
            FROM grades g
            WHERE g.student_id = s.student_id
        ) >= 75 THEN '（良好学生）'
        ELSE '（一般学生）'
    END
)
WHERE EXISTS (
    SELECT 1 FROM grades g WHERE g.student_id = s.student_id
)
AND s.student_name NOT LIKE '%（%学生）';  -- 既にコメントがない場合のみ
```

### 解答27-6
```sql
UPDATE course_schedule
SET status = CASE
    WHEN schedule_date < '2025-05-20' THEN 'completed'
    WHEN schedule_date < CURRENT_DATE THEN 'ongoing'
    ELSE 'scheduled'
END
WHERE status != 'cancelled';  -- キャンセルされた授業は除外
```

## まとめ

この章では、UPDATE文について詳しく学びました：

1. **UPDATE文の基本概念**：
   - 既存レコードの値を変更するSQL文
   - SET句による値の指定
   - WHERE句による更新対象の限定

2. **基本的なUPDATE操作**：
   - 単一カラムの更新
   - 複数カラムの同時更新
   - 計算による値の更新

3. **条件付きUPDATE**：
   - WHERE句による条件指定
   - 複数条件の組み合わせ
   - 日付や範囲条件での更新

4. **CASE式を使った条件分岐更新**：
   - 条件に応じた異なる値での更新
   - 複雑な条件分岐の実現

5. **JOINを使ったUPDATE**：
   - 他のテーブルの情報を参照した更新
   - 関連データに基づく値の設定

6. **サブクエリを使ったUPDATE**：
   - 動的な条件での更新
   - 集計結果に基づく更新

7. **安全なUPDATE操作**：
   - 更新前後の確認方法
   - 影響範囲の事前チェック
   - LIMIT句による制限

8. **パフォーマンスとエラー対処**：
   - インデックスの活用
   - 大量更新時の分割実行
   - よくあるエラーの回避

9. **ベストプラクティス**：
   - トランザクションの使用
   - バックアップの作成
   - 段階的な更新アプローチ

UPDATE文は強力な機能ですが、WHERE句の忘れなどにより意図しない大量更新が発生する危険性があります。常に安全性を意識し、適切な手順で実行することが重要です。

次の章では、「データ削除：DELETE文」について学び、不要なデータを安全に削除する方法を理解していきます。
