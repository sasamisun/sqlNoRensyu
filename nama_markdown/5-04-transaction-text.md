# 29. トランザクション：BEGIN、COMMIT、ROLLBACK

## はじめに

これまでの章で、INSERT、UPDATE、DELETE文を学び、データベースの基本的な操作方法を習得しました。しかし、実際のシステムでは、複数の操作を組み合わせて一つの処理を完成させることが多くあります。この章では、複数のSQL文をまとめて安全に実行するための「トランザクション」について学習します。

トランザクションが必要となる場面の例：
- 「学生の転校処理：旧学校からの削除と新学校への登録を同時に実行」
- 「成績の一括更新：中間テストと期末テストの成績を同時に入力」
- 「講座の開設：講座作成、教師の割り当て、教室の予約を一連の処理として実行」
- 「システム障害時の復旧：エラーが発生した場合、変更をすべて取り消し」
- 「データ移行：複数テーブルのデータを整合性を保ちながら移行」

トランザクションは、これらの複雑な処理を安全かつ確実に実行するための仕組みです。「すべて成功するか、すべて失敗するか」のいずれかを保証し、中途半端な状態を防ぎます。

## トランザクションとは

トランザクションとは、データベースに対する一連の操作をひとまとまりとして扱う仕組みです。トランザクション内のすべての操作が成功した場合のみ変更を確定し、一つでも失敗した場合はすべての変更を取り消します。

> **用語解説**：
> - **トランザクション**：データベースに対する一連の操作をひとまとまりとして扱う単位です。
> - **BEGIN/START TRANSACTION**：トランザクションの開始を宣言する文です。
> - **COMMIT**：トランザクション内の変更をデータベースに確定する文です。
> - **ROLLBACK**：トランザクション内の変更をすべて取り消す文です。
> - **オートコミット**：各SQL文が自動的にコミットされるモードです。
> - **ACID特性**：トランザクションが満たすべき4つの特性（原子性、一貫性、独立性、永続性）です。

## ACID特性

トランザクションは、以下の4つの特性（ACID特性）を満たす必要があります：

### 1. Atomicity（原子性）
トランザクション内の操作は「すべて実行されるか、まったく実行されないか」のどちらかです。部分的な実行はありません。

### 2. Consistency（一貫性）
トランザクションの実行により、データベースは一つの整合性のある状態から別の整合性のある状態に移行します。

### 3. Isolation（独立性）
複数のトランザクションが同時に実行されても、それぞれが独立して実行されているように見えます。

### 4. Durability（永続性）
コミットされたトランザクションの結果は、システム障害が発生しても永続的に保持されます。

## トランザクションの基本構文

### 基本的な構文

```sql
-- トランザクションの開始
BEGIN;
-- または
START TRANSACTION;

-- 一連のSQL文
INSERT INTO ...;
UPDATE ...;
DELETE FROM ...;

-- 成功時：変更を確定
COMMIT;

-- 失敗時：変更を取り消し
-- ROLLBACK;
```

## 基本的なトランザクションの例

### 例1：新しい学生の登録処理

新しい学生を登録し、同時に指定された講座に受講登録する処理：

```sql
-- トランザクション開始
START TRANSACTION;

-- 学生の登録
INSERT INTO students (student_id, student_name)
VALUES (341, '新入生太郎');

-- 受講登録
INSERT INTO student_courses (course_id, student_id)
VALUES 
    ('1', 341),   -- ITのための基礎知識
    ('2', 341),   -- UNIX入門
    ('7', 341);   -- AI・機械学習入門

-- 出席記録の初期化（既存の授業分）
INSERT INTO attendance (schedule_id, student_id, status)
SELECT cs.schedule_id, 341, 'absent'  -- 過去の授業は欠席扱い
FROM course_schedule cs
WHERE cs.course_id IN ('1', '2', '7')
  AND cs.schedule_date < CURRENT_DATE;

-- すべて成功した場合、変更を確定
COMMIT;

-- 確認
SELECT s.student_name, c.course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE s.student_id = 341;
```

### 例2：成績の一括更新処理

複数の評価タイプの成績を同時に更新する処理：

```sql
-- トランザクション開始
BEGIN;

-- 中間テストの成績更新
UPDATE grades 
SET score = score * 1.05  -- 5%のボーナス
WHERE course_id = '1' 
  AND grade_type = '中間テスト' 
  AND score >= 80;

-- レポート評価の成績更新
UPDATE grades 
SET score = LEAST(score + 10, 100)  -- 10点加算（上限100点）
WHERE course_id = '1' 
  AND grade_type = 'レポート1' 
  AND score >= 75;

-- 最終評価の再計算
UPDATE grades 
SET score = (
    SELECT ROUND(AVG(g2.score), 1)
    FROM grades g2
    WHERE g2.student_id = grades.student_id
      AND g2.course_id = grades.course_id
      AND g2.grade_type IN ('中間テスト', 'レポート1')
)
WHERE course_id = '1' 
  AND grade_type = '最終評価';

-- 変更を確定
COMMIT;
```

## エラー処理とROLLBACK

### 例3：エラーが発生した場合の処理

```sql
-- トランザクション開始
START TRANSACTION;

-- 教師の登録
INSERT INTO teachers (teacher_id, teacher_name)
VALUES (111, '新任教師');

-- 講座の作成
INSERT INTO courses (course_id, course_name, teacher_id)
VALUES ('33', '新講座', 111);

-- 授業スケジュールの作成
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id)
VALUES ('33', '2025-06-10', 1, '501A', 111);

-- ここで何らかのエラーが発生したとします
-- 例：存在しない教室IDを指定
-- INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id)
-- VALUES ('33', '2025-06-11', 1, '存在しない教室', 111);

-- エラーが発生した場合、すべての変更を取り消し
ROLLBACK;

-- 確認：データが挿入されていないことを確認
SELECT * FROM teachers WHERE teacher_id = 111;
SELECT * FROM courses WHERE course_id = '33';
-- 結果：0行（ROLLBACKにより挿入が取り消された）
```

## 条件付きトランザクション処理

### 例4：条件によるCOMMITとROLLBACK

```sql
DELIMITER //

CREATE PROCEDURE AddStudentWithValidation(
    IN p_student_id BIGINT,
    IN p_student_name VARCHAR(64),
    IN p_course_ids TEXT  -- カンマ区切りの講座ID
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 学生の重複チェック
    IF EXISTS (SELECT 1 FROM students WHERE student_id = p_student_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '学生IDが既に存在します';
    END IF;
    
    -- 学生の登録
    INSERT INTO students (student_id, student_name)
    VALUES (p_student_id, p_student_name);
    
    -- 講座の受講登録（講座IDが有効かチェック）
    INSERT INTO student_courses (course_id, student_id)
    SELECT course_id, p_student_id
    FROM courses
    WHERE FIND_IN_SET(course_id, p_course_ids) > 0;
    
    -- 登録された講座数をチェック
    IF (SELECT COUNT(*) FROM student_courses WHERE student_id = p_student_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '有効な講座が指定されていません';
    END IF;
    
    COMMIT;
END //

DELIMITER ;

-- プロシージャの使用例
CALL AddStudentWithValidation(342, '検証学生', '1,2,3');
```

## 複雑なトランザクションの例

### 例5：講座の統合処理

2つの講座を統合し、片方を削除する複雑な処理：

```sql
START TRANSACTION;

-- 統合前の確認
SELECT 
    '統合前' as timing,
    course_id,
    course_name,
    (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) as students
FROM courses c
WHERE course_id IN ('30', '31');

-- 講座31の学生を講座30に移動
UPDATE student_courses 
SET course_id = '30'
WHERE course_id = '31'
  AND student_id NOT IN (
      SELECT student_id FROM student_courses WHERE course_id = '30'
  );

-- 講座31の重複受講者を削除
DELETE FROM student_courses 
WHERE course_id = '31';

-- 講座31の成績を講座30に移動
UPDATE grades 
SET course_id = '30'
WHERE course_id = '31';

-- 講座31の授業スケジュールを講座30に移動
UPDATE course_schedule 
SET course_id = '30'
WHERE course_id = '31';

-- 講座31を削除
DELETE FROM courses WHERE course_id = '31';

-- 統合後の確認
SELECT 
    '統合後' as timing,
    course_id,
    course_name,
    (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) as students
FROM courses c
WHERE course_id = '30';

-- 問題がなければコミット
COMMIT;
```

## セーブポイント（SAVEPOINT）

大きなトランザクション内で部分的なロールバックを行うためにセーブポイントを使用できます。

### 例6：セーブポイントの使用

```sql
START TRANSACTION;

-- 基本データの挿入
INSERT INTO students (student_id, student_name) VALUES (343, 'セーブポイント学生');

-- セーブポイント1の設定
SAVEPOINT sp1;

-- 受講登録
INSERT INTO student_courses (course_id, student_id) VALUES ('1', 343);
INSERT INTO student_courses (course_id, student_id) VALUES ('2', 343);

-- セーブポイント2の設定
SAVEPOINT sp2;

-- 成績の初期化（この処理でエラーが発生したとします）
INSERT INTO grades (student_id, course_id, grade_type, score, max_score)
VALUES (343, '1', '中間テスト', 85, 100);

-- エラーが発生した場合、セーブポイント2まで戻る
-- ROLLBACK TO sp2;

-- または、セーブポイント1まで戻る
-- ROLLBACK TO sp1;

-- 最終的なコミット
COMMIT;
```

## トランザクション分離レベル

複数のトランザクションが同時実行される際の動作を制御します。

### 分離レベルの種類

1. **READ UNCOMMITTED**：最も低い分離レベル
2. **READ COMMITTED**：コミットされたデータのみ読取り
3. **REPEATABLE READ**：同一トランザクション内での一貫した読取り（MySQLのデフォルト）
4. **SERIALIZABLE**：最も高い分離レベル

### 例7：分離レベルの設定

```sql
-- セッション単位での分離レベル設定
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- トランザクション単位での分離レベル設定
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;
-- トランザクション処理
COMMIT;
```

## デッドロックの理解と対策

デッドロックは、複数のトランザクションが互いの完了を待って停止状態になることです。

### 例8：デッドロックが発生しやすい状況

```sql
-- セッション1
START TRANSACTION;
UPDATE students SET student_name = '更新1' WHERE student_id = 301;
-- この時点で学生301をロック

-- セッション2
START TRANSACTION;
UPDATE students SET student_name = '更新2' WHERE student_id = 302;
-- この時点で学生302をロック

-- セッション1が学生302を更新しようとする
UPDATE students SET student_name = '更新1-2' WHERE student_id = 302;
-- 待機状態（セッション2が学生302をロック中）

-- セッション2が学生301を更新しようとする
UPDATE students SET student_name = '更新2-1' WHERE student_id = 301;
-- デッドロック発生！
```

### デッドロック対策

```sql
-- 対策1：常に同じ順序でテーブルにアクセス
START TRANSACTION;
-- 常に学生IDの昇順でアクセス
UPDATE students SET student_name = '安全な更新' WHERE student_id = 301;
UPDATE students SET student_name = '安全な更新' WHERE student_id = 302;
COMMIT;

-- 対策2：トランザクションを短時間で完了させる
START TRANSACTION;
UPDATE students SET student_name = '短時間更新' WHERE student_id = 301;
COMMIT;  -- 速やかにコミット
```

## オートコミットモードの制御

### 例9：オートコミットの制御

```sql
-- 現在のオートコミット設定を確認
SELECT @@autocommit;

-- オートコミットを無効化
SET autocommit = 0;

-- 以降のSQL文は明示的にCOMMITするまで確定されない
INSERT INTO students (student_id, student_name) VALUES (344, 'オートコミットテスト');

-- 確認（まだコミットされていない）
SELECT * FROM students WHERE student_id = 344;

-- 明示的にコミット
COMMIT;

-- オートコミットを再有効化
SET autocommit = 1;
```

## トランザクションのベストプラクティス

### 1. トランザクションは短時間で

```sql
-- 良い例：短時間のトランザクション
START TRANSACTION;
UPDATE grades SET score = 85 WHERE student_id = 301 AND course_id = '1';
INSERT INTO grade_history (student_id, course_id, old_score, new_score, changed_at)
VALUES (301, '1', 80, 85, NOW());
COMMIT;

-- 悪い例：長時間のトランザクション
START TRANSACTION;
-- 大量のデータ処理や時間のかかる処理
-- 他のトランザクションをブロックしてしまう
```

### 2. 適切なエラーハンドリング

```sql
START TRANSACTION;

BEGIN
    -- メイン処理
    INSERT INTO students (student_id, student_name) VALUES (345, 'エラーハンドリング学生');
    
    -- 関連処理
    INSERT INTO student_courses (course_id, student_id) VALUES ('1', 345);
    
    COMMIT;
END;

-- エラーが発生した場合の処理
IF @@error_count > 0 THEN
    ROLLBACK;
END IF;
```

### 3. リソースの適切な管理

```sql
-- 接続プールの考慮
START TRANSACTION;

-- 必要最小限の処理のみ
UPDATE students SET student_name = '更新済み' WHERE student_id = 301;

-- 速やかにコミット
COMMIT;

-- 長時間の処理は別途実行
```

## 実践的なトランザクション例

### 例10：学期末処理の自動化

```sql
DELIMITER //

CREATE PROCEDURE EndOfSemesterProcessing()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_student_id BIGINT;
    DECLARE v_course_id VARCHAR(16);
    DECLARE v_final_score DECIMAL(5,2);
    
    DECLARE student_cursor CURSOR FOR
        SELECT DISTINCT student_id, course_id
        FROM grades
        WHERE grade_type IN ('中間テスト', 'レポート1', '課題1');
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 最終評価の計算と挿入
    OPEN student_cursor;
    
    student_loop: LOOP
        FETCH student_cursor INTO v_student_id, v_course_id;
        IF done THEN
            LEAVE student_loop;
        END IF;
        
        -- 最終スコアの計算
        SELECT AVG(score) INTO v_final_score
        FROM grades
        WHERE student_id = v_student_id 
          AND course_id = v_course_id
          AND grade_type IN ('中間テスト', 'レポート1', '課題1');
        
        -- 最終評価の挿入または更新
        INSERT INTO grades (student_id, course_id, grade_type, score, max_score, submission_date)
        VALUES (v_student_id, v_course_id, '最終評価', v_final_score, 100, CURRENT_DATE)
        ON DUPLICATE KEY UPDATE 
            score = v_final_score,
            submission_date = CURRENT_DATE;
    END LOOP;
    
    CLOSE student_cursor;
    
    -- 学期終了フラグの設定
    UPDATE course_schedule 
    SET status = 'completed'
    WHERE schedule_date <= CURRENT_DATE 
      AND status = 'scheduled';
    
    COMMIT;
END //

DELIMITER ;

-- プロシージャの実行
CALL EndOfSemesterProcessing();
```

## 練習問題

### 問題29-1
新しい教師（teacher_id=112, teacher_name='実習教師'）を登録し、同時にその教師が担当する新しい講座（course_id='34', course_name='実習講座'）を作成するトランザクションを書いてください。

### 問題29-2
学生ID=301の全成績に10%のボーナスを加算し（ただし100点を超えない）、同時に成績変更ログテーブル（grade_change_log）に変更記録を挿入するトランザクションを書いてください。

### 問題29-3
講座ID='32'を削除するために、関連するすべてのデータ（student_courses、grades、course_schedule、courses）を適切な順序で削除するトランザクションを書いてください。エラーが発生した場合はすべてロールバックしてください。

### 問題29-4
セーブポイントを使用して、学生の一括登録処理を書いてください。学生情報の登録後にセーブポイントを設定し、受講登録でエラーが発生した場合は受講登録のみをロールバックして学生情報は保持するトランザクションを作成してください。

### 問題29-5
2つの学生（student_id=301と302）の成績データを入れ替える（301の成績を302に、302の成績を301に移動）トランザクションを書いてください。一時的な学生ID（999）を使用して安全に実行してください。

### 問題29-6
出席率が70%未満の学生に対して警告フラグを設定し、同時に担当教師に通知メッセージを送信するためのデータを挿入する複合トランザクションを書いてください。

## 解答

### 解答29-1
```sql
START TRANSACTION;

-- 教師の登録
INSERT INTO teachers (teacher_id, teacher_name)
VALUES (112, '実習教師');

-- 講座の作成
INSERT INTO courses (course_id, course_name, teacher_id)
VALUES ('34', '実習講座', 112);

-- 成功時にコミット
COMMIT;

-- 確認
SELECT t.teacher_name, c.course_name
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
WHERE t.teacher_id = 112;
```

### 解答29-2
```sql
-- ログテーブルの作成（実際の運用では事前に作成）
CREATE TABLE IF NOT EXISTS grade_change_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT,
    course_id VARCHAR(16),
    grade_type VARCHAR(32),
    old_score DECIMAL(5,2),
    new_score DECIMAL(5,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

START TRANSACTION;

-- 変更前のデータをログに記録
INSERT INTO grade_change_log (student_id, course_id, grade_type, old_score, new_score)
SELECT 
    student_id,
    course_id,
    grade_type,
    score,
    LEAST(score * 1.1, 100)
FROM grades
WHERE student_id = 301;

-- 成績にボーナスを加算
UPDATE grades
SET score = LEAST(score * 1.1, 100)
WHERE student_id = 301;

COMMIT;
```

### 解答29-3
```sql
START TRANSACTION;

-- 関連データを適切な順序で削除
DELETE FROM attendance 
WHERE schedule_id IN (
    SELECT schedule_id FROM course_schedule WHERE course_id = '32'
);

DELETE FROM grades WHERE course_id = '32';

DELETE FROM student_courses WHERE course_id = '32';

DELETE FROM course_schedule WHERE course_id = '32';

DELETE FROM courses WHERE course_id = '32';

-- 削除結果の確認
SELECT COUNT(*) as remaining_courses FROM courses WHERE course_id = '32';

COMMIT;
```

### 解答29-4
```sql
START TRANSACTION;

-- 学生の登録
INSERT INTO students (student_id, student_name) VALUES (346, 'セーブポイント学生');

-- セーブポイント設定
SAVEPOINT after_student_insert;

-- 受講登録の試行
BEGIN
    INSERT INTO student_courses (course_id, student_id) VALUES ('1', 346);
    INSERT INTO student_courses (course_id, student_id) VALUES ('2', 346);
    INSERT INTO student_courses (course_id, student_id) VALUES ('存在しない講座', 346);
EXCEPTION
    WHEN OTHERS THEN
        -- 受講登録でエラーが発生した場合、セーブポイントまでロールバック
        ROLLBACK TO after_student_insert;
        -- 学生情報は保持される
END;

COMMIT;

-- 確認
SELECT * FROM students WHERE student_id = 346;
SELECT * FROM student_courses WHERE student_id = 346;
```

### 解答29-5
```sql
START TRANSACTION;

-- 一時的な学生ID（999）を使用して安全に成績を入れ替え

-- Step 1: 301の成績を一時的に999に移動
UPDATE grades SET student_id = 999 WHERE student_id = 301;

-- Step 2: 302の成績を301に移動
UPDATE grades SET student_id = 301 WHERE student_id = 302;

-- Step 3: 999の成績を302に移動
UPDATE grades SET student_id = 302 WHERE student_id = 999;

-- 入れ替え完了の確認
SELECT 
    student_id,
    course_id,
    grade_type,
    score
FROM grades
WHERE student_id IN (301, 302)
ORDER BY student_id, course_id, grade_type;

COMMIT;
```

### 解答29-6
```sql
-- 通知テーブルの作成（実際の運用では事前に作成）
CREATE TABLE IF NOT EXISTS teacher_notifications (
    notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    teacher_id BIGINT,
    student_id BIGINT,
    message TEXT,
    notification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE
);

-- 学生テーブルに警告フラグカラムを追加（実際の運用では事前に作成）
-- ALTER TABLE students ADD COLUMN warning_flag BOOLEAN DEFAULT FALSE;

START TRANSACTION;

-- 出席率が70%未満の学生に警告フラグを設定
UPDATE students s
SET warning_flag = TRUE
WHERE s.student_id IN (
    SELECT DISTINCT a.student_id
    FROM attendance a
    GROUP BY a.student_id
    HAVING AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END) < 70
);

-- 担当教師への通知メッセージを作成
INSERT INTO teacher_notifications (teacher_id, student_id, message)
SELECT DISTINCT
    c.teacher_id,
    s.student_id,
    CONCAT('学生 ', s.student_name, '（ID: ', s.student_id, '）の出席率が70%を下回りました。面談が必要です。')
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
WHERE s.warning_flag = TRUE;

COMMIT;

-- 確認
SELECT 
    s.student_name,
    s.warning_flag,
    t.teacher_name,
    tn.message
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN teacher_notifications tn ON t.teacher_id = tn.teacher_id AND s.student_id = tn.student_id
WHERE s.warning_flag = TRUE;
```

## まとめ

この章では、トランザクションについて詳しく学びました：

1. **トランザクションの基本概念**：
   - 複数の操作をひとまとまりとして扱う仕組み
   - ACID特性（原子性、一貫性、独立性、永続性）
   - BEGIN/START TRANSACTION、COMMIT、ROLLBACKの使い方

2. **基本的なトランザクション操作**：
   - 学生登録と受講登録の組み合わせ
   - 成績の一括更新処理
   - エラー発生時のロールバック

3. **高度なトランザクション技術**：
   - 条件付きCOMMITとROLLBACK
   - セーブポイント（SAVEPOINT）の使用
   - 複雑な業務処理の実装

4. **同時実行制御**：
   - トランザクション分離レベル
   - デッドロックの理解と対策
   - オートコミットモードの制御

5. **実践的な応用**：
   - 学期末処理の自動化
   - データ整合性の保証
   - 複雑な業務ロジックの実装

6. **ベストプラクティス**：
   - 短時間でのトランザクション完了
   - 適切なエラーハンドリング
   - リソースの効率的な管理

トランザクションは、データベースの整合性を保つための重要な仕組みです。適切に使用することで、複雑な業務処理を安全かつ確実に実行できます。特に、複数のテーブルにまたがる処理や、エラーが発生した場合の復旧処理において、トランザクションは不可欠な機能です。

次の章では、「ビュー：仮想テーブルの作成と利用」について学び、複雑なクエリを再利用可能な形で管理する方法を理解していきます。
