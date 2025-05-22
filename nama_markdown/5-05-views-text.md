# 30. ビュー：仮想テーブルの作成と利用

## はじめに

前章では、トランザクションを使って複数の操作を安全に実行する方法を学びました。この章では、複雑なクエリを再利用可能な形で管理するための「ビュー（View）」について学習します。

ビューは、一つまたは複数のテーブルから取得したデータを「仮想的なテーブル」として定義する機能です。実際のデータを格納するわけではなく、定義されたクエリを実行して動的に結果を生成します。

ビューが役立つ場面の例：
- 「複雑な集計クエリを何度も使いたい」
- 「機密情報を含むテーブルの一部だけを見せたい」
- 「複数のテーブルを結合した結果を簡単に参照したい」
- 「異なるユーザーに異なるデータの見せ方をしたい」
- 「レポート作成用の標準的なデータ形式を提供したい」
- 「複雑なビジネスロジックを隠蔽したい」

この章では、ビューの基本概念から実践的な活用方法、パフォーマンスの考慮点まで詳しく学んでいきます。

## ビューとは

ビューは、一つまたは複数のテーブルに基づいて定義される「仮想的なテーブル」です。ビュー自体はデータを格納せず、アクセス時に定義されたクエリを実行して結果を返します。

> **用語解説**：
> - **ビュー（View）**：テーブルやその他のビューに基づいて定義される仮想的なテーブルです。
> - **仮想テーブル**：実際のデータは格納せず、クエリの実行結果として動的に生成されるテーブルです。
> - **ベーステーブル**：ビューの定義で参照される元のテーブルです。
> - **更新可能ビュー**：INSERT、UPDATE、DELETEが可能なビューです。
> - **読み取り専用ビュー**：SELECT操作のみが可能なビューです。
> - **マテリアライズドビュー**：結果を物理的に格納するビュー（MySQLでは標準サポートなし）。

## ビューの利点

### 1. セキュリティの向上
機密情報を含むテーブルの一部のカラムやレコードのみを公開できます。

### 2. クエリの簡略化
複雑な結合や集計クエリを簡単な名前で参照できます。

### 3. データの論理的な統合
複数のテーブルから関連データを統合した形で提供できます。

### 4. データの抽象化
テーブル構造の変更をビューで吸収し、アプリケーションへの影響を最小化できます。

### 5. 再利用性
よく使用されるクエリパターンを標準化できます。

## ビューの基本構文

### CREATE VIEW文

```sql
CREATE VIEW ビュー名 AS
SELECT文;
```

### ビューの参照

```sql
SELECT * FROM ビュー名;
```

### ビューの削除

```sql
DROP VIEW ビュー名;
```

## 基本的なビューの例

### 例1：学生情報の簡略ビュー

学生の基本情報のみを表示するシンプルなビュー：

```sql
-- 学生基本情報ビューの作成
CREATE VIEW student_basic_info AS
SELECT 
    student_id,
    student_name
FROM students;

-- ビューの使用
SELECT * FROM student_basic_info;
```

実行結果：

| student_id | student_name |
|------------|--------------|
| 301        | 黒沢春馬     |
| 302        | 新垣愛留     |
| 303        | 柴崎春花     |
| ...        | ...          |

### 例2：講座と担当教師のビュー

講座と担当教師の情報を結合したビュー：

```sql
-- 講座詳細ビューの作成
CREATE VIEW course_details AS
SELECT 
    c.course_id,
    c.course_name,
    t.teacher_id,
    t.teacher_name,
    COUNT(sc.student_id) AS enrollment_count
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name, t.teacher_id, t.teacher_name;

-- ビューの使用
SELECT * FROM course_details 
WHERE enrollment_count > 10
ORDER BY enrollment_count DESC;
```

実行結果：

| course_id | course_name           | teacher_id | teacher_name | enrollment_count |
|-----------|----------------------|------------|--------------|------------------|
| 1         | ITのための基礎知識     | 101        | 寺内鞍       | 12               |
| 16        | データサイエンスとビジネス応用 | 106 | 星野涼子     | 11               |
| ...       | ...                  | ...        | ...          | ...              |

## 複雑なビューの例

### 例3：学生の成績サマリービュー

各学生の成績統計を表示するビュー：

```sql
CREATE VIEW student_grade_summary AS
SELECT 
    s.student_id,
    s.student_name,
    COUNT(DISTINCT g.course_id) AS courses_taken,
    COUNT(g.grade_id) AS total_grades,
    ROUND(AVG(g.score), 2) AS average_score,
    MAX(g.score) AS highest_score,
    MIN(g.score) AS lowest_score,
    CASE 
        WHEN AVG(g.score) >= 90 THEN 'A'
        WHEN AVG(g.score) >= 80 THEN 'B'
        WHEN AVG(g.score) >= 70 THEN 'C'
        WHEN AVG(g.score) >= 60 THEN 'D'
        ELSE 'F'
    END AS overall_grade
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name;

-- ビューの使用
SELECT * FROM student_grade_summary 
WHERE overall_grade IN ('A', 'B')
ORDER BY average_score DESC;
```

### 例4：出席率統計ビュー

各学生の出席状況を統計表示するビュー：

```sql
CREATE VIEW attendance_statistics AS
SELECT 
    s.student_id,
    s.student_name,
    COUNT(a.schedule_id) AS total_classes,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS present_count,
    SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS late_count,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS absent_count,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate,
    CASE 
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 95 THEN '優秀'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 85 THEN '良好'
        WHEN AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 75 THEN '普通'
        ELSE '要改善'
    END AS attendance_status
FROM students s
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name;

-- ビューの使用
SELECT student_name, attendance_rate, attendance_status
FROM attendance_statistics 
WHERE attendance_status = '要改善'
ORDER BY attendance_rate;
```

### 例5：総合ダッシュボードビュー

成績と出席率を統合した総合評価ビュー：

```sql
CREATE VIEW student_dashboard AS
SELECT 
    sgs.student_id,
    sgs.student_name,
    sgs.average_score,
    sgs.overall_grade,
    ats.attendance_rate,
    ats.attendance_status,
    CASE 
        WHEN sgs.overall_grade IN ('A', 'B') AND ats.attendance_rate >= 85 THEN '優秀学生'
        WHEN sgs.overall_grade IN ('A', 'B', 'C') AND ats.attendance_rate >= 75 THEN '良好学生'
        WHEN sgs.overall_grade = 'F' OR ats.attendance_rate < 60 THEN '要指導学生'
        ELSE '一般学生'
    END AS student_category,
    sgs.courses_taken,
    ats.total_classes
FROM student_grade_summary sgs
LEFT JOIN attendance_statistics ats ON sgs.student_id = ats.student_id;

-- ビューの使用
SELECT 
    student_category,
    COUNT(*) as student_count,
    ROUND(AVG(average_score), 1) as avg_grade,
    ROUND(AVG(attendance_rate), 1) as avg_attendance
FROM student_dashboard
GROUP BY student_category
ORDER BY avg_grade DESC;
```

## 更新可能ビューと更新不可能ビュー

### 更新可能ビューの条件

ビューがINSERT、UPDATE、DELETEを受け付けるには、以下の条件を満たす必要があります：

1. 単一のテーブルを参照している
2. GROUP BY、HAVING、集計関数を使用していない
3. DISTINCT、UNION、サブクエリを使用していない
4. 計算カラムがない

### 例6：更新可能ビューの作成と使用

```sql
-- 更新可能ビューの作成
CREATE VIEW active_students AS
SELECT student_id, student_name
FROM students
WHERE student_id >= 300;

-- ビューを通じた挿入
INSERT INTO active_students (student_id, student_name)
VALUES (347, 'ビューテスト学生');

-- ビューを通じた更新
UPDATE active_students
SET student_name = 'ビューテスト学生（更新済み）'
WHERE student_id = 347;

-- ビューを通じた削除
DELETE FROM active_students WHERE student_id = 347;

-- 確認
SELECT * FROM active_students WHERE student_id = 347;
```

### 例7：更新不可能ビューの例

```sql
-- 更新不可能ビュー（集計関数を使用）
CREATE VIEW course_enrollment_count AS
SELECT 
    c.course_id,
    c.course_name,
    COUNT(sc.student_id) as enrollment_count
FROM courses c
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name;

-- このビューに対するUPDATEは失敗する
-- UPDATE course_enrollment_count SET enrollment_count = 10 WHERE course_id = '1';
-- エラー: The target table course_enrollment_count of the UPDATE is not updatable
```

## WITH CHECK OPTIONの使用

WHERE句を含むビューで、条件に合わないデータの挿入を防ぐために使用します。

### 例8：WITH CHECK OPTIONの使用

```sql
-- チェックオプション付きビューの作成
CREATE VIEW high_grade_students AS
SELECT student_id, student_name
FROM students
WHERE student_id IN (
    SELECT DISTINCT student_id 
    FROM grades 
    WHERE score >= 80
)
WITH CHECK OPTION;

-- このビューを通じた挿入は、条件をチェックする
-- INSERT INTO high_grade_students VALUES (999, '新学生');
-- この場合、成績が80点以上でないとエラーになる
```

## セキュリティビューの例

### 例9：機密情報を隠すビュー

教師用の学生情報ビュー（個人情報の一部を制限）：

```sql
-- 教師用学生情報ビュー（制限付き）
CREATE VIEW teacher_student_view AS
SELECT 
    s.student_id,
    LEFT(s.student_name, 1) + '**' AS masked_name,  -- 名前をマスク
    sgs.average_score,
    sgs.overall_grade,
    ats.attendance_rate
FROM students s
LEFT JOIN student_grade_summary sgs ON s.student_id = sgs.student_id
LEFT JOIN attendance_statistics ats ON s.student_id = ats.student_id;

-- 管理者用学生情報ビュー（制限なし）
CREATE VIEW admin_student_view AS
SELECT 
    s.student_id,
    s.student_name,
    sgs.average_score,
    sgs.overall_grade,
    ats.attendance_rate,
    ats.total_classes,
    sgs.courses_taken
FROM students s
LEFT JOIN student_grade_summary sgs ON s.student_id = sgs.student_id
LEFT JOIN attendance_statistics ats ON s.student_id = ats.student_id;
```

## 複雑なレポートビューの例

### 例10：月次レポートビュー

```sql
CREATE VIEW monthly_report AS
SELECT 
    DATE_FORMAT(cs.schedule_date, '%Y-%m') AS report_month,
    COUNT(DISTINCT cs.schedule_id) AS total_classes,
    COUNT(DISTINCT cs.course_id) AS active_courses,
    COUNT(DISTINCT cs.teacher_id) AS active_teachers,
    COUNT(DISTINCT a.student_id) AS attending_students,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS average_attendance_rate,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS total_attendance,
    COUNT(CASE WHEN a.status = 'absent' THEN 1 END) AS total_absences,
    COUNT(CASE WHEN a.status = 'late' THEN 1 END) AS total_late
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
WHERE cs.schedule_date >= '2025-01-01'
GROUP BY DATE_FORMAT(cs.schedule_date, '%Y-%m')
ORDER BY report_month;

-- 月次レポートの確認
SELECT * FROM monthly_report;
```

### 例11：教師パフォーマンスビュー

```sql
CREATE VIEW teacher_performance AS
SELECT 
    t.teacher_id,
    t.teacher_name,
    COUNT(DISTINCT c.course_id) AS courses_taught,
    COUNT(DISTINCT sc.student_id) AS total_students,
    ROUND(AVG(g.score), 2) AS average_student_score,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS class_attendance_rate,
    COUNT(DISTINCT cs.schedule_id) AS classes_held,
    CASE 
        WHEN AVG(g.score) >= 85 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 90 THEN '優秀'
        WHEN AVG(g.score) >= 75 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80 THEN '良好'
        ELSE '標準'
    END AS performance_rating
FROM teachers t
LEFT JOIN courses c ON t.teacher_id = c.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
LEFT JOIN grades g ON c.course_id = g.course_id
LEFT JOIN course_schedule cs ON c.course_id = cs.course_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY t.teacher_id, t.teacher_name;

-- 教師パフォーマンスの確認
SELECT * FROM teacher_performance 
ORDER BY performance_rating, average_student_score DESC;
```

## ビューの管理

### ビューの変更

```sql
-- ビューの定義を変更
CREATE OR REPLACE VIEW student_basic_info AS
SELECT 
    student_id,
    student_name,
    'アクティブ' AS status  -- 新しいカラムを追加
FROM students
WHERE student_id >= 300;
```

### ビューの削除

```sql
-- ビューの削除
DROP VIEW IF EXISTS student_basic_info;
```

### ビューの情報確認

```sql
-- 存在するビューの一覧
SHOW TABLES;

-- ビューの詳細情報
SHOW CREATE VIEW student_dashboard;

-- ビューの構造確認
DESCRIBE student_dashboard;
```

## ビューのパフォーマンス考慮点

### 1. 複雑なビューのパフォーマンス

```sql
-- パフォーマンスが重い可能性があるビュー
CREATE VIEW complex_student_analysis AS
SELECT 
    s.student_id,
    s.student_name,
    (SELECT AVG(score) FROM grades WHERE student_id = s.student_id) AS avg_score,
    (SELECT COUNT(*) FROM attendance WHERE student_id = s.student_id) AS total_classes,
    (SELECT COUNT(DISTINCT course_id) FROM student_courses WHERE student_id = s.student_id) AS course_count
FROM students s;

-- より効率的な書き方
CREATE VIEW efficient_student_analysis AS
SELECT 
    s.student_id,
    s.student_name,
    ROUND(AVG(g.score), 2) AS avg_score,
    COUNT(DISTINCT a.schedule_id) AS total_classes,
    COUNT(DISTINCT sc.course_id) AS course_count
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
GROUP BY s.student_id, s.student_name;
```

### 2. インデックスの重要性

ビューで使用されるベーステーブルのカラムに適切なインデックスを作成：

```sql
-- ビューのパフォーマンス向上のためのインデックス
-- CREATE INDEX idx_grades_student_id ON grades(student_id);
-- CREATE INDEX idx_attendance_student_id ON attendance(student_id);
-- CREATE INDEX idx_student_courses_student_id ON student_courses(student_id);
```

## ビューのベストプラクティス

### 1. 命名規則

```sql
-- わかりやすい命名規則を使用
CREATE VIEW v_student_summary AS        -- プレフィックス付き
SELECT ...;

CREATE VIEW student_grade_report AS     -- 用途が明確
SELECT ...;
```

### 2. ドキュメント化

```sql
-- コメント付きビューの作成
CREATE VIEW student_performance_metrics AS
-- 目的: 学生のパフォーマンス指標を統合表示
-- 作成者: 管理者
-- 作成日: 2025-05-22
-- 更新日: 2025-05-22
SELECT 
    s.student_id,
    s.student_name,
    -- 成績関連指標
    AVG(g.score) AS average_score,
    -- 出席関連指標
    AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) AS attendance_rate
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name;
```

### 3. 段階的なビュー構築

```sql
-- 基本ビュー
CREATE VIEW basic_student_info AS
SELECT student_id, student_name FROM students;

-- 拡張ビュー（基本ビューを利用）
CREATE VIEW extended_student_info AS
SELECT 
    bsi.*,
    COUNT(sc.course_id) AS course_count
FROM basic_student_info bsi
LEFT JOIN student_courses sc ON bsi.student_id = sc.student_id
GROUP BY bsi.student_id, bsi.student_name;
```

## 実践的なビュー活用例

### 例12：API用データビュー

アプリケーション向けのJSON形式データを提供するビュー：

```sql
CREATE VIEW api_student_data AS
SELECT 
    JSON_OBJECT(
        'student_id', s.student_id,
        'name', s.student_name,
        'grades', JSON_OBJECT(
            'average', ROUND(AVG(g.score), 2),
            'count', COUNT(g.grade_id)
        ),
        'attendance', JSON_OBJECT(
            'rate', ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1),
            'total_classes', COUNT(a.schedule_id)
        )
    ) AS student_data
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name;
```

## 練習問題

### 問題30-1
各講座の基本情報（講座ID、講座名、担当教師名、受講者数）を表示するビュー「course_overview」を作成してください。

### 問題30-2
学生の出席率が80%以上の学生のみを表示するビュー「good_attendance_students」を作成してください。このビューには学生ID、学生名、出席率を含めてください。

### 問題30-3
各教師について、担当講座数、総受講者数、担当講座の平均成績を表示するビュー「teacher_summary」を作成してください。

### 問題30-4
成績が85点以上の学生のみが更新可能な制限付きビュー「high_performers」を作成してください。WITH CHECK OPTIONを使用してください。

### 問題30-5
月別の授業統計（年月、実施授業数、出席者総数、平均出席率）を表示するビュー「monthly_class_stats」を作成してください。

### 問題30-6
学生、成績、出席率の情報を統合し、総合評価（S、A、B、C、D）を算出するビュー「student_comprehensive_evaluation」を作成してください。評価基準は以下の通りです：
- S: 平均点90点以上かつ出席率95%以上
- A: 平均点80点以上かつ出席率85%以上
- B: 平均点70点以上かつ出席率75%以上  
- C: 平均点60点以上かつ出席率65%以上
- D: 上記以外

## 解答

### 解答30-1
```sql
CREATE VIEW course_overview AS
SELECT 
    c.course_id,
    c.course_name,
    t.teacher_name,
    COUNT(sc.student_id) AS enrollment_count
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name, t.teacher_name;

-- 確認
SELECT * FROM course_overview ORDER BY enrollment_count DESC;
```

### 解答30-2
```sql
CREATE VIEW good_attendance_students AS
SELECT 
    s.student_id,
    s.student_name,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 80;

-- 確認
SELECT * FROM good_attendance_students ORDER BY attendance_rate DESC;
```

### 解答30-3
```sql
CREATE VIEW teacher_summary AS
SELECT 
    t.teacher_id,
    t.teacher_name,
    COUNT(DISTINCT c.course_id) AS courses_taught,
    COUNT(DISTINCT sc.student_id) AS total_students,
    ROUND(AVG(g.score), 2) AS average_grade
FROM teachers t
LEFT JOIN courses c ON t.teacher_id = c.teacher_id
LEFT JOIN student_courses sc ON c.course_id = sc.course_id
LEFT JOIN grades g ON c.course_id = g.course_id
GROUP BY t.teacher_id, t.teacher_name;

-- 確認
SELECT * FROM teacher_summary ORDER BY average_grade DESC;
```

### 解答30-4
```sql
CREATE VIEW high_performers AS
SELECT 
    s.student_id,
    s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT student_id
    FROM grades
    GROUP BY student_id
    HAVING AVG(score) >= 85
)
WITH CHECK OPTION;

-- 使用例（平均85点以上の学生のみ追加可能）
-- INSERT INTO high_performers VALUES (999, 'テスト学生');
```

### 解答30-5
```sql
CREATE VIEW monthly_class_stats AS
SELECT 
    DATE_FORMAT(cs.schedule_date, '%Y-%m') AS month_year,
    COUNT(DISTINCT cs.schedule_id) AS classes_held,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS total_attendance,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS average_attendance_rate
FROM course_schedule cs
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY DATE_FORMAT(cs.schedule_date, '%Y-%m')
ORDER BY month_year;

-- 確認
SELECT * FROM monthly_class_stats;
```

### 解答30-6
```sql
CREATE VIEW student_comprehensive_evaluation AS
SELECT 
    s.student_id,
    s.student_name,
    ROUND(AVG(g.score), 2) AS average_score,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 1) AS attendance_rate,
    CASE 
        WHEN AVG(g.score) >= 90 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 95 THEN 'S'
        WHEN AVG(g.score) >= 80 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 85 THEN 'A'
        WHEN AVG(g.score) >= 70 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 75 THEN 'B'
        WHEN AVG(g.score) >= 60 AND AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) >= 65 THEN 'C'
        ELSE 'D'
    END AS comprehensive_grade
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name;

-- 確認
SELECT 
    comprehensive_grade,
    COUNT(*) as student_count,
    ROUND(AVG(average_score), 1) as avg_score,
    ROUND(AVG(attendance_rate), 1) as avg_attendance
FROM student_comprehensive_evaluation
GROUP BY comprehensive_grade
ORDER BY comprehensive_grade;
```

## まとめ

この章では、ビューについて詳しく学びました：

1. **ビューの基本概念**：
   - 仮想テーブルとしてのビューの理解
   - ベーステーブルとの関係
   - セキュリティと簡略化の利点

2. **基本的なビューの作成**：
   - CREATE VIEW文の構文
   - シンプルなビューの例
   - 複数テーブルの結合ビュー

3. **複雑なビューの活用**：
   - 集計関数を使ったビュー
   - 条件分岐を含むビュー
   - 複数ビューの組み合わせ

4. **更新可能ビュー**：
   - 更新可能な条件の理解
   - WITH CHECK OPTIONの使用
   - セキュリティ制限の実装

5. **実践的な応用**：
   - ダッシュボードビューの作成
   - レポート用ビューの構築
   - API用データビューの設計

6. **ビューの管理**：
   - ビューの変更と削除
   - 情報確認の方法
   - 適切な命名規則

7. **パフォーマンス考慮点**：
   - 効率的なビューの設計
   - インデックスの重要性
   - 複雑さとパフォーマンスのバランス

8. **ベストプラクティス**：
   - 段階的なビュー構築
   - ドキュメント化の重要性
   - 保守性の向上

ビューは、データベースの複雑さを隠蔽し、ユーザーに使いやすいインターフェースを提供する強力な機能です。適切に設計・活用することで、セキュリティの向上、開発効率の向上、保守性の向上を実現できます。

次の章では、「インデックス：検索効率化の基本」について学び、データベースのパフォーマンスを向上させる方法を理解していきます。
