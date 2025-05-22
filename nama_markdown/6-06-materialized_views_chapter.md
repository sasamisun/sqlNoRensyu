# 37. マテリアライズドビュー：結果を保存するビュー

## はじめに

前章では、AUTO_INCREMENTによる連番生成について学習しました。この章では、クエリ結果を物理的に保存してパフォーマンスを向上させる「マテリアライズドビュー」について学習します。

**重要な注意事項：MySQLには標準的なマテリアライズドビュー機能はありません**が、同様の効果を得るための手法を学ぶことで、大幅なパフォーマンス向上を実現できます。

マテリアライズドビューが有効な場面の例：
- 「複雑な集計クエリの実行時間を短縮したい」
- 「リアルタイムでのレポート生成が遅すぎる」
- 「複数のテーブルを結合した重い処理を高速化したい」
- 「ダッシュボードの表示速度を改善したい」
- 「定期的なレポート作成を効率化したい」
- 「大量データの分析クエリを最適化したい」
- 「読み取り専用の集計データを高速提供したい」

この章では、MySQLでマテリアライズドビューと同等の機能を実現する方法から、自動更新システムの構築、実践的な運用まで詳しく学んでいきます。

## マテリアライズドビューとは

マテリアライズドビューは、ビューの実行結果を物理的なテーブルとして保存する仕組みです。通常のビューが実行時にクエリを動的に実行するのに対し、マテリアライズドビューは事前に計算された結果を保存しているため、非常に高速にデータを取得できます。

> **用語解説**：
> - **マテリアライズドビュー（Materialized View）**：クエリ結果を物理的に保存するビューです。
> - **通常のビュー（Regular View）**：実行時にクエリを動的に実行する仮想テーブルです。
> - **リフレッシュ（Refresh）**：マテリアライズドビューのデータを最新状態に更新することです。
> - **完全リフレッシュ（Complete Refresh）**：全データを再計算して更新する方法です。
> - **増分リフレッシュ（Incremental Refresh）**：変更された部分のみを更新する方法です。
> - **即座リフレッシュ（Immediate Refresh）**：元データの変更と同時に更新する方法です。
> - **遅延リフレッシュ（Deferred Refresh）**：定期的または手動でまとめて更新する方法です。
> - **集計テーブル（Summary Table）**：マテリアライズドビューの代替として使用される集計用テーブルです。
> - **ETLプロセス**：Extract, Transform, Loadの略で、データの抽出・変換・格納処理です。

## MySQLでのマテリアライズドビュー実装

### 1. 基本的な実装パターン

MySQLではマテリアライズドビューを手動で実装します。

```sql
-- 元データの確認（学生の成績統計）
SELECT 
    s.student_id,
    s.student_name,
    COUNT(g.grade_id) as total_grades,
    ROUND(AVG(g.score), 2) as average_score,
    MAX(g.score) as highest_score,
    MIN(g.score) as lowest_score
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
LIMIT 5;

-- マテリアライズドビュー相当のテーブルを作成
CREATE TABLE mv_student_grade_summary (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100),
    total_grades INT DEFAULT 0,
    average_score DECIMAL(5,2),
    highest_score DECIMAL(5,2),
    lowest_score DECIMAL(5,2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_average_score (average_score),
    INDEX idx_student_name (student_name)
);

-- 初期データの投入
INSERT INTO mv_student_grade_summary 
    (student_id, student_name, total_grades, average_score, highest_score, lowest_score)
SELECT 
    s.student_id,
    s.student_name,
    COUNT(g.grade_id) as total_grades,
    ROUND(AVG(g.score), 2) as average_score,
    MAX(g.score) as highest_score,
    MIN(g.score) as lowest_score
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name;

-- 結果確認
SELECT * FROM mv_student_grade_summary ORDER BY average_score DESC LIMIT 10;
```

### 2. 更新プロシージャの作成

```sql
-- 完全リフレッシュ用プロシージャ
DELIMITER //

CREATE PROCEDURE refresh_student_grade_summary()
BEGIN
    -- 既存データをクリア
    TRUNCATE TABLE mv_student_grade_summary;
    
    -- 最新データで再構築
    INSERT INTO mv_student_grade_summary 
        (student_id, student_name, total_grades, average_score, highest_score, lowest_score)
    SELECT 
        s.student_id,
        s.student_name,
        COUNT(g.grade_id) as total_grades,
        ROUND(AVG(g.score), 2) as average_score,
        MAX(g.score) as highest_score,
        MIN(g.score) as lowest_score
    FROM students s
    LEFT JOIN grades g ON s.student_id = g.student_id
    GROUP BY s.student_id, s.student_name;
    
    -- 更新ログ
    INSERT INTO mv_refresh_log (mv_name, refresh_type, refresh_time, record_count)
    SELECT 'mv_student_grade_summary', 'COMPLETE', NOW(), COUNT(*)
    FROM mv_student_grade_summary;
END //

DELIMITER ;

-- 更新ログテーブル
CREATE TABLE mv_refresh_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    mv_name VARCHAR(100) NOT NULL,
    refresh_type ENUM('COMPLETE', 'INCREMENTAL', 'MANUAL') NOT NULL,
    refresh_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    record_count INT,
    execution_time_ms INT,
    notes TEXT
);

-- プロシージャの実行
CALL refresh_student_grade_summary();

-- ログ確認
SELECT * FROM mv_refresh_log;
```

## 増分更新システム

### 1. 変更追跡テーブル

```sql
-- 変更追跡用テーブル
CREATE TABLE mv_change_log (
    change_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(64) NOT NULL,
    operation_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    record_id BIGINT NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    
    INDEX idx_table_processed (table_name, processed),
    INDEX idx_changed_at (changed_at)
);

-- 成績データの増分更新プロシージャ
DELIMITER //

CREATE PROCEDURE incremental_refresh_student_grades()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE affected_student_id BIGINT;
    DECLARE operation_type VARCHAR(10);
    
    -- 未処理の変更を取得するカーソル
    DECLARE change_cursor CURSOR FOR
        SELECT DISTINCT record_id, operation_type
        FROM mv_change_log 
        WHERE table_name = 'grades' AND processed = FALSE;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN change_cursor;
    
    change_loop: LOOP
        FETCH change_cursor INTO affected_student_id, operation_type;
        IF done THEN
            LEAVE change_loop;
        END IF;
        
        -- 該当学生の統計を再計算
        INSERT INTO mv_student_grade_summary 
            (student_id, student_name, total_grades, average_score, highest_score, lowest_score)
        SELECT 
            s.student_id,
            s.student_name,
            COUNT(g.grade_id) as total_grades,
            ROUND(AVG(g.score), 2) as average_score,
            MAX(g.score) as highest_score,
            MIN(g.score) as lowest_score
        FROM students s
        LEFT JOIN grades g ON s.student_id = g.student_id
        WHERE s.student_id = affected_student_id
        GROUP BY s.student_id, s.student_name
        ON DUPLICATE KEY UPDATE
            total_grades = VALUES(total_grades),
            average_score = VALUES(average_score),
            highest_score = VALUES(highest_score),
            lowest_score = VALUES(lowest_score),
            last_updated = CURRENT_TIMESTAMP;
            
    END LOOP;
    
    CLOSE change_cursor;
    
    -- 処理済みマークを設定
    UPDATE mv_change_log 
    SET processed = TRUE 
    WHERE table_name = 'grades' AND processed = FALSE;
    
    -- ログ記録
    INSERT INTO mv_refresh_log (mv_name, refresh_type, record_count)
    SELECT 'mv_student_grade_summary', 'INCREMENTAL', COUNT(DISTINCT record_id)
    FROM mv_change_log 
    WHERE table_name = 'grades' AND processed = TRUE;
    
END //

DELIMITER ;
```

### 2. トリガーによる自動変更追跡

```sql
-- 成績テーブルの変更を自動追跡するトリガー
DELIMITER //

CREATE TRIGGER tr_grades_insert_mv
AFTER INSERT ON grades
FOR EACH ROW
BEGIN
    INSERT INTO mv_change_log (table_name, operation_type, record_id)
    VALUES ('grades', 'INSERT', NEW.student_id);
END //

CREATE TRIGGER tr_grades_update_mv
AFTER UPDATE ON grades
FOR EACH ROW
BEGIN
    INSERT INTO mv_change_log (table_name, operation_type, record_id)
    VALUES ('grades', 'UPDATE', NEW.student_id);
    
    -- 学生IDが変更された場合は旧IDも追跡
    IF OLD.student_id != NEW.student_id THEN
        INSERT INTO mv_change_log (table_name, operation_type, record_id)
        VALUES ('grades', 'UPDATE', OLD.student_id);
    END IF;
END //

CREATE TRIGGER tr_grades_delete_mv
AFTER DELETE ON grades
FOR EACH ROW
BEGIN
    INSERT INTO mv_change_log (table_name, operation_type, record_id)
    VALUES ('grades', 'DELETE', OLD.student_id);
END //

DELIMITER ;

-- トリガーのテスト
INSERT INTO grades (student_id, course_id, grade_type, score, max_score)
VALUES (301, '1', 'テストトリガー', 88.5, 100);

-- 変更ログの確認
SELECT * FROM mv_change_log WHERE table_name = 'grades' ORDER BY change_id DESC LIMIT 5;

-- 増分更新の実行
CALL incremental_refresh_student_grades();

-- 更新結果の確認
SELECT * FROM mv_student_grade_summary WHERE student_id = 301;
```

## 複雑なマテリアライズドビューの例

### 1. 月別出席統計ビュー

```sql
-- 月別出席統計のマテリアライズドビュー
CREATE TABLE mv_monthly_attendance_stats (
    year_month VARCHAR(7) PRIMARY KEY,  -- YYYY-MM
    total_classes INT DEFAULT 0,
    total_students INT DEFAULT 0,
    present_count INT DEFAULT 0,
    late_count INT DEFAULT 0,
    absent_count INT DEFAULT 0,
    attendance_rate DECIMAL(5,2) DEFAULT 0.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_attendance_rate (attendance_rate),
    INDEX idx_year_month (year_month)
);

-- 月別出席統計更新プロシージャ
DELIMITER //

CREATE PROCEDURE refresh_monthly_attendance_stats(IN target_year_month VARCHAR(7))
BEGIN
    DECLARE total_classes_count INT DEFAULT 0;
    DECLARE total_students_count INT DEFAULT 0;
    DECLARE present_count_val INT DEFAULT 0;
    DECLARE late_count_val INT DEFAULT 0;
    DECLARE absent_count_val INT DEFAULT 0;
    DECLARE attendance_rate_val DECIMAL(5,2) DEFAULT 0.00;
    
    -- 統計を計算
    SELECT 
        COUNT(DISTINCT cs.schedule_id),
        COUNT(DISTINCT a.student_id),
        SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END),
        SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END),
        SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END)
    INTO 
        total_classes_count,
        total_students_count,
        present_count_val,
        late_count_val,
        absent_count_val
    FROM course_schedule cs
    LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
    WHERE DATE_FORMAT(cs.schedule_date, '%Y-%m') = target_year_month;
    
    -- 出席率を計算
    IF (present_count_val + late_count_val + absent_count_val) > 0 THEN
        SET attendance_rate_val = ROUND((present_count_val * 100.0) / (present_count_val + late_count_val + absent_count_val), 2);
    END IF;
    
    -- マテリアライズドビューを更新
    INSERT INTO mv_monthly_attendance_stats 
        (year_month, total_classes, total_students, present_count, late_count, absent_count, attendance_rate)
    VALUES 
        (target_year_month, total_classes_count, total_students_count, present_count_val, late_count_val, absent_count_val, attendance_rate_val)
    ON DUPLICATE KEY UPDATE
        total_classes = VALUES(total_classes),
        total_students = VALUES(total_students),
        present_count = VALUES(present_count),
        late_count = VALUES(late_count),
        absent_count = VALUES(absent_count),
        attendance_rate = VALUES(attendance_rate),
        last_updated = CURRENT_TIMESTAMP;
        
    -- ログ記録
    INSERT INTO mv_refresh_log (mv_name, refresh_type, notes)
    VALUES ('mv_monthly_attendance_stats', 'MANUAL', CONCAT('Updated: ', target_year_month));
    
END //

DELIMITER ;

-- 月別統計の更新
CALL refresh_monthly_attendance_stats('2025-05');

-- 結果確認
SELECT * FROM mv_monthly_attendance_stats;
```

### 2. 講座別パフォーマンス分析ビュー

```sql
-- 講座別パフォーマンス分析のマテリアライズドビュー
CREATE TABLE mv_course_performance_analysis (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128),
    teacher_name VARCHAR(64),
    enrolled_students INT DEFAULT 0,
    total_grades INT DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0.00,
    pass_rate DECIMAL(5,2) DEFAULT 0.00,  -- 60点以上の割合
    excellent_rate DECIMAL(5,2) DEFAULT 0.00,  -- 90点以上の割合
    total_classes INT DEFAULT 0,
    average_attendance_rate DECIMAL(5,2) DEFAULT 0.00,
    course_rating ENUM('Excellent', 'Good', 'Average', 'Below Average', 'Poor') DEFAULT 'Average',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_average_score (average_score),
    INDEX idx_pass_rate (pass_rate),
    INDEX idx_course_rating (course_rating)
);

-- 講座パフォーマンス分析更新プロシージャ
DELIMITER //

CREATE PROCEDURE refresh_course_performance_analysis()
BEGIN
    TRUNCATE TABLE mv_course_performance_analysis;
    
    INSERT INTO mv_course_performance_analysis 
        (course_id, course_name, teacher_name, enrolled_students, total_grades, average_score, 
         pass_rate, excellent_rate, total_classes, average_attendance_rate, course_rating)
    SELECT 
        c.course_id,
        c.course_name,
        t.teacher_name,
        -- 受講者数
        (SELECT COUNT(*) FROM student_courses sc WHERE sc.course_id = c.course_id) as enrolled_students,
        -- 成績統計
        COUNT(g.grade_id) as total_grades,
        ROUND(AVG(g.score), 2) as average_score,
        ROUND(AVG(CASE WHEN g.score >= 60 THEN 100.0 ELSE 0 END), 2) as pass_rate,
        ROUND(AVG(CASE WHEN g.score >= 90 THEN 100.0 ELSE 0 END), 2) as excellent_rate,
        -- 出席統計
        (SELECT COUNT(DISTINCT cs.schedule_id) 
         FROM course_schedule cs 
         WHERE cs.course_id = c.course_id) as total_classes,
        (SELECT ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 2)
         FROM course_schedule cs2
         LEFT JOIN attendance a ON cs2.schedule_id = a.schedule_id
         WHERE cs2.course_id = c.course_id) as average_attendance_rate,
        -- 総合評価
        CASE 
            WHEN AVG(g.score) >= 85 AND AVG(CASE WHEN g.score >= 60 THEN 100.0 ELSE 0 END) >= 90 THEN 'Excellent'
            WHEN AVG(g.score) >= 75 AND AVG(CASE WHEN g.score >= 60 THEN 100.0 ELSE 0 END) >= 80 THEN 'Good'
            WHEN AVG(g.score) >= 65 AND AVG(CASE WHEN g.score >= 60 THEN 100.0 ELSE 0 END) >= 70 THEN 'Average'
            WHEN AVG(g.score) >= 55 THEN 'Below Average'
            ELSE 'Poor'
        END as course_rating
    FROM courses c
    JOIN teachers t ON c.teacher_id = t.teacher_id
    LEFT JOIN grades g ON c.course_id = g.course_id
    GROUP BY c.course_id, c.course_name, t.teacher_name;
    
    -- ログ記録
    INSERT INTO mv_refresh_log (mv_name, refresh_type, record_count)
    SELECT 'mv_course_performance_analysis', 'COMPLETE', COUNT(*)
    FROM mv_course_performance_analysis;
    
END //

DELIMITER ;

-- 講座パフォーマンス分析の更新
CALL refresh_course_performance_analysis();

-- 結果確認
SELECT 
    course_name,
    teacher_name,
    enrolled_students,
    average_score,
    pass_rate,
    average_attendance_rate,
    course_rating
FROM mv_course_performance_analysis 
ORDER BY course_rating, average_score DESC;
```

## 自動更新スケジューリング

### 1. 更新スケジュール管理

```sql
-- マテリアライズドビュー更新スケジュール管理
CREATE TABLE mv_refresh_schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    mv_name VARCHAR(100) NOT NULL,
    refresh_type ENUM('COMPLETE', 'INCREMENTAL') NOT NULL,
    refresh_frequency ENUM('HOURLY', 'DAILY', 'WEEKLY', 'MONTHLY', 'MANUAL') NOT NULL,
    refresh_time TIME,  -- 実行時刻
    last_refresh TIMESTAMP NULL,
    next_refresh TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,
    max_execution_time INT DEFAULT 3600,  -- 最大実行時間（秒）
    
    INDEX idx_next_refresh (next_refresh),
    INDEX idx_active (is_active)
);

-- スケジュール設定
INSERT INTO mv_refresh_schedule 
    (mv_name, refresh_type, refresh_frequency, refresh_time, is_active)
VALUES 
    ('mv_student_grade_summary', 'INCREMENTAL', 'HOURLY', '00:00:00', TRUE),
    ('mv_monthly_attendance_stats', 'COMPLETE', 'DAILY', '02:00:00', TRUE),
    ('mv_course_performance_analysis', 'COMPLETE', 'WEEKLY', '03:00:00', TRUE);

-- 次回実行時刻の計算と更新
UPDATE mv_refresh_schedule 
SET next_refresh = CASE 
    WHEN refresh_frequency = 'HOURLY' THEN 
        DATE_ADD(CONCAT(CURDATE(), ' ', refresh_time), INTERVAL 1 HOUR)
    WHEN refresh_frequency = 'DAILY' THEN 
        DATE_ADD(CONCAT(CURDATE(), ' ', refresh_time), INTERVAL 1 DAY)
    WHEN refresh_frequency = 'WEEKLY' THEN 
        DATE_ADD(CONCAT(CURDATE(), ' ', refresh_time), INTERVAL 1 WEEK)
    WHEN refresh_frequency = 'MONTHLY' THEN 
        DATE_ADD(CONCAT(CURDATE(), ' ', refresh_time), INTERVAL 1 MONTH)
END
WHERE is_active = TRUE;

-- スケジュール確認
SELECT * FROM mv_refresh_schedule;
```

### 2. 自動実行プロシージャ

```sql
-- 自動更新実行プロシージャ
DELIMITER //

CREATE PROCEDURE execute_scheduled_refreshes()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE mv_name_var VARCHAR(100);
    DECLARE refresh_type_var VARCHAR(20);
    DECLARE refresh_freq_var VARCHAR(20);
    DECLARE start_time TIMESTAMP;
    DECLARE execution_time INT;
    
    DECLARE schedule_cursor CURSOR FOR
        SELECT mv_name, refresh_type, refresh_frequency
        FROM mv_refresh_schedule 
        WHERE is_active = TRUE 
        AND next_refresh <= NOW();
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN schedule_cursor;
    
    refresh_loop: LOOP
        FETCH schedule_cursor INTO mv_name_var, refresh_type_var, refresh_freq_var;
        IF done THEN
            LEAVE refresh_loop;
        END IF;
        
        SET start_time = NOW();
        
        -- マテリアライズドビューに応じた更新実行
        CASE mv_name_var
            WHEN 'mv_student_grade_summary' THEN
                IF refresh_type_var = 'COMPLETE' THEN
                    CALL refresh_student_grade_summary();
                ELSE
                    CALL incremental_refresh_student_grades();
                END IF;
            
            WHEN 'mv_monthly_attendance_stats' THEN
                CALL refresh_monthly_attendance_stats(DATE_FORMAT(NOW(), '%Y-%m'));
            
            WHEN 'mv_course_performance_analysis' THEN
                CALL refresh_course_performance_analysis();
        END CASE;
        
        SET execution_time = TIMESTAMPDIFF(SECOND, start_time, NOW());
        
        -- スケジュール更新
        UPDATE mv_refresh_schedule 
        SET 
            last_refresh = start_time,
            next_refresh = CASE 
                WHEN refresh_freq_var = 'HOURLY' THEN DATE_ADD(start_time, INTERVAL 1 HOUR)
                WHEN refresh_freq_var = 'DAILY' THEN DATE_ADD(start_time, INTERVAL 1 DAY)
                WHEN refresh_freq_var = 'WEEKLY' THEN DATE_ADD(start_time, INTERVAL 1 WEEK)
                WHEN refresh_freq_var = 'MONTHLY' THEN DATE_ADD(start_time, INTERVAL 1 MONTH)
            END
        WHERE mv_name = mv_name_var;
        
        -- 実行ログ更新
        UPDATE mv_refresh_log 
        SET execution_time_ms = execution_time * 1000
        WHERE mv_name = mv_name_var 
        AND refresh_time = start_time;
        
    END LOOP;
    
    CLOSE schedule_cursor;
END //

DELIMITER ;

-- 手動実行テスト
CALL execute_scheduled_refreshes();

-- 実行結果確認
SELECT * FROM mv_refresh_log ORDER BY refresh_time DESC LIMIT 10;
SELECT * FROM mv_refresh_schedule;
```

## パフォーマンス比較と最適化

### 1. パフォーマンステスト

```sql
-- 通常のビューでのクエリ実行時間測定
CREATE VIEW v_student_performance AS
SELECT 
    s.student_id,
    s.student_name,
    COUNT(g.grade_id) as total_grades,
    ROUND(AVG(g.score), 2) as average_score,
    MAX(g.score) as highest_score,
    MIN(g.score) as lowest_score,
    ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 2) as attendance_rate
FROM students s
LEFT JOIN grades g ON s.student_id = g.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.student_name;

-- 通常ビューでの実行時間測定
SET @start_time = NOW(6);
SELECT * FROM v_student_performance WHERE average_score >= 80 ORDER BY average_score DESC;
SET @view_time = TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6));

-- マテリアライズドビューでの実行時間測定
SET @start_time = NOW(6);
SELECT * FROM mv_student_grade_summary WHERE average_score >= 80 ORDER BY average_score DESC;
SET @mv_time = TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6));

-- パフォーマンス比較
SELECT 
    @view_time as regular_view_microseconds,
    @mv_time as materialized_view_microseconds,
    ROUND(@view_time / @mv_time, 2) as performance_improvement_ratio;
```

### 2. ストレージ使用量の確認

```sql
-- テーブルサイズの比較
SELECT 
    table_name,
    table_rows,
    ROUND(data_length / 1024 / 1024, 2) as data_mb,
    ROUND(index_length / 1024 / 1024, 2) as index_mb,
    ROUND((data_length + index_length) / 1024 / 1024, 2) as total_mb
FROM information_schema.tables 
WHERE table_schema = DATABASE() 
AND table_name IN ('students', 'grades', 'attendance', 'mv_student_grade_summary', 'mv_course_performance_analysis')
ORDER BY (data_length + index_length) DESC;
```

### 3. 最適化テクニック

```sql
-- パーティション化されたマテリアライズドビュー（年月別）
CREATE TABLE mv_monthly_grade_summary (
    year_month VARCHAR(7),
    student_id BIGINT,
    total_grades INT DEFAULT 0,
    average_score DECIMAL(5,2),
    grade_distribution JSON,  -- {'A': 5, 'B': 3, 'C': 2, 'D': 1, 'F': 0}
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (year_month, student_id),
    INDEX idx_average_score (average_score),
    INDEX idx_year_month (year_month)
);

-- 月別成績サマリー更新プロシージャ
DELIMITER //

CREATE PROCEDURE refresh_monthly_grade_summary(IN target_year_month VARCHAR(7))
BEGIN
    -- 該当月のデータを削除
    DELETE FROM mv_monthly_grade_summary WHERE year_month = target_year_month;
    
    -- 新しいデータを挿入
    INSERT INTO mv_monthly_grade_summary 
        (year_month, student_id, total_grades, average_score, grade_distribution)
    SELECT 
        target_year_month,
        s.student_id,
        COUNT(g.grade_id) as total_grades,
        ROUND(AVG(g.score), 2) as average_score,
        JSON_OBJECT(
            'A', SUM(CASE WHEN g.score >= 90 THEN 1 ELSE 0 END),
            'B', SUM(CASE WHEN g.score >= 80 AND g.score < 90 THEN 1 ELSE 0 END),
            'C', SUM(CASE WHEN g.score >= 70 AND g.score < 80 THEN 1 ELSE 0 END),
            'D', SUM(CASE WHEN g.score >= 60 AND g.score < 70 THEN 1 ELSE 0 END),
            'F', SUM(CASE WHEN g.score < 60 THEN 1 ELSE 0 END)
        ) as grade_distribution
    FROM students s
    LEFT JOIN grades g ON s.student_id = g.student_id 
        AND DATE_FORMAT(g.submission_date, '%Y-%m') = target_year_month
    GROUP BY s.student_id
    HAVING COUNT(g.grade_id) > 0;  -- 成績がある学生のみ
    
END //

DELIMITER ;

-- 月別サマリーの更新
CALL refresh_monthly_grade_summary('2025-05');

-- JSON データの活用例
SELECT 
    student_id,
    average_score,
    JSON_EXTRACT(grade_distribution, '$.A') as grade_A_count,
    JSON_EXTRACT(grade_distribution, '$.B') as grade_B_count,
    JSON_EXTRACT(grade_distribution, '$.C') as grade_C_count
FROM mv_monthly_grade_summary 
WHERE year_month = '2025-05'
ORDER BY average_score DESC
LIMIT 10;
```

## 実践的な運用例

### 1. ダッシュボード用マテリアライズドビュー

```sql
-- 管理者ダッシュボード用統合ビュー
CREATE TABLE mv_admin_dashboard (
    metric_name VARCHAR(50) PRIMARY KEY,
    metric_value DECIMAL(15,2),
    metric_unit VARCHAR(20),
    previous_value DECIMAL(15,2),
    change_percentage DECIMAL(5,2),
    status ENUM('UP', 'DOWN', 'STABLE') DEFAULT 'STABLE',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ダッシュボード更新プロシージャ
DELIMITER //

CREATE PROCEDURE refresh_admin_dashboard()
BEGIN
    DECLARE total_students_val INT;
    DECLARE total_courses_val INT;
    DECLARE avg_attendance_val DECIMAL(5,2);
    DECLARE avg_grade_val DECIMAL(5,2);
    
    -- 現在の統計を計算
    SELECT COUNT(*) INTO total_students_val FROM students;
    SELECT COUNT(*) INTO total_courses_val FROM courses;
    
    SELECT ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 2)
    INTO avg_attendance_val
    FROM attendance a
    JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
    WHERE cs.schedule_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
    
    SELECT ROUND(AVG(score), 2)
    INTO avg_grade_val
    FROM grades
    WHERE submission_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
    
    -- メトリクス更新（前回値も保存）
    INSERT INTO mv_admin_dashboard (metric_name, metric_value, metric_unit, previous_value)
    VALUES 
        ('total_students', total_students_val, 'count', NULL),
        ('total_courses', total_courses_val, 'count', NULL),
        ('avg_attendance_rate', avg_attendance_val, 'percentage', NULL),
        ('avg_grade_30days', avg_grade_val, 'score', NULL)
    ON DUPLICATE KEY UPDATE
        previous_value = metric_value,
        metric_value = VALUES(metric_value),
        change_percentage = CASE 
            WHEN previous_value > 0 THEN ROUND(((VALUES(metric_value) - previous_value) / previous_value) * 100, 2)
            ELSE 0 
        END,
        status = CASE 
            WHEN VALUES(metric_value) > previous_value THEN 'UP'
            WHEN VALUES(metric_value) < previous_value THEN 'DOWN'
            ELSE 'STABLE'
        END,
        last_updated = CURRENT_TIMESTAMP;
        
END //

DELIMITER ;

-- ダッシュボード更新
CALL refresh_admin_dashboard();

-- ダッシュボード表示
SELECT 
    metric_name,
    metric_value,
    metric_unit,
    CONCAT(
        CASE WHEN change_percentage > 0 THEN '+' ELSE '' END,
        change_percentage, '%'
    ) as change_from_previous,
    status,
    last_updated
FROM mv_admin_dashboard
ORDER BY metric_name;
```

### 2. 監査用マテリアライズドビュー

```sql
-- データ品質監査用ビュー
CREATE TABLE mv_data_quality_audit (
    audit_date DATE PRIMARY KEY,
    total_students INT,
    students_without_grades INT,
    students_without_attendance INT,
    courses_without_students INT,
    duplicate_grades_count INT,
    data_quality_score DECIMAL(5,2),
    issues_found JSON,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- データ品質監査プロシージャ
DELIMITER //

CREATE PROCEDURE refresh_data_quality_audit()
BEGIN
    DECLARE audit_date_val DATE DEFAULT CURRENT_DATE;
    DECLARE total_students_val INT;
    DECLARE students_no_grades_val INT;
    DECLARE students_no_attendance_val INT;
    DECLARE courses_no_students_val INT;
    DECLARE duplicate_grades_val INT;
    DECLARE quality_score DECIMAL(5,2);
    DECLARE issues JSON;
    
    -- データ品質指標の計算
    SELECT COUNT(*) INTO total_students_val FROM students;
    
    SELECT COUNT(*) INTO students_no_grades_val
    FROM students s
    LEFT JOIN grades g ON s.student_id = g.student_id
    WHERE g.student_id IS NULL;
    
    SELECT COUNT(*) INTO students_no_attendance_val
    FROM students s
    LEFT JOIN attendance a ON s.student_id = a.student_id
    WHERE a.student_id IS NULL;
    
    SELECT COUNT(*) INTO courses_no_students_val
    FROM courses c
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    WHERE sc.course_id IS NULL;
    
    SELECT COUNT(*) INTO duplicate_grades_val
    FROM (
        SELECT student_id, course_id, grade_type, COUNT(*) as cnt
        FROM grades
        GROUP BY student_id, course_id, grade_type
        HAVING cnt > 1
    ) duplicates;
    
    -- 品質スコアの計算（100点満点）
    SET quality_score = 100 - 
        (students_no_grades_val / total_students_val * 20) -
        (students_no_attendance_val / total_students_val * 15) -
        (courses_no_students_val * 10) -
        (duplicate_grades_val * 5);
    
    -- 問題点をJSON形式で記録
    SET issues = JSON_OBJECT(
        'students_without_grades', students_no_grades_val,
        'students_without_attendance', students_no_attendance_val,
        'courses_without_students', courses_no_students_val,
        'duplicate_grades', duplicate_grades_val
    );
    
    -- 監査結果を保存
    INSERT INTO mv_data_quality_audit 
        (audit_date, total_students, students_without_grades, students_without_attendance,
         courses_without_students, duplicate_grades_count, data_quality_score, issues_found)
    VALUES 
        (audit_date_val, total_students_val, students_no_grades_val, students_no_attendance_val,
         courses_no_students_val, duplicate_grades_val, quality_score, issues)
    ON DUPLICATE KEY UPDATE
        total_students = VALUES(total_students),
        students_without_grades = VALUES(students_without_grades),
        students_without_attendance = VALUES(students_without_attendance),
        courses_without_students = VALUES(courses_without_students),
        duplicate_grades_count = VALUES(duplicate_grades_count),
        data_quality_score = VALUES(data_quality_score),
        issues_found = VALUES(issues_found),
        last_updated = CURRENT_TIMESTAMP;
        
END //

DELIMITER ;

-- データ品質監査実行
CALL refresh_data_quality_audit();

-- 監査結果確認
SELECT 
    audit_date,
    data_quality_score,
    students_without_grades,
    students_without_attendance,
    courses_without_students,
    duplicate_grades_count,
    JSON_PRETTY(issues_found) as detailed_issues
FROM mv_data_quality_audit
ORDER BY audit_date DESC;
```

## 練習問題

### 問題37-1：基本的なマテリアライズドビュー
以下の要件でマテリアライズドビュー`mv_teacher_workload`を作成してください：
- 各教師の担当講座数、担当学生総数、平均成績を集計
- 更新プロシージャ`refresh_teacher_workload()`も作成
- 初期データを投入して動作確認

### 問題37-2：増分更新システム
学生テーブルの変更を追跡して、学生一覧のマテリアライズドビューを増分更新するシステムを実装してください：
1. 変更追跡テーブルを作成
2. 学生テーブルにトリガーを設定
3. 増分更新プロシージャを作成
4. テストデータで動作確認

### 問題37-3：時系列マテリアライズドビュー
日別の新規登録学生数と累計学生数を記録するマテリアライズドビュー`mv_daily_student_stats`を作成してください：
- 日付、新規登録数、累計学生数を記録
- 過去30日分のデータを生成する更新プロシージャ
- グラフ表示用のデータ形式で出力

### 問題37-4：複合指標マテリアライズドビュー
講座の総合評価指標を計算するマテリアライズドビュー`mv_course_quality_index`を作成してください：
- 平均成績、出席率、受講者数、教師評価を組み合わせた品質指数
- 指数計算式：`(平均成績 * 0.4 + 出席率 * 0.3 + 受講者充足率 * 0.2 + 教師評価 * 0.1)`
- ランキング表示機能も含める

### 問題37-5：自動更新スケジューラー
以下の機能を持つマテリアライズドビュー自動更新システムを実装してください：
1. 更新スケジュール管理テーブル
2. エラーハンドリング機能付き自動実行プロシージャ
3. 実行ログとパフォーマンス監視
4. 複数のマテリアライズドビューの管理

### 問題37-6：パフォーマンス最適化
大量データ用のマテリアライズドビューシステムを設計してください：
1. パーティション化戦略の実装
2. インデックス最適化
3. 並行更新対応
4. メモリ使用量とストレージの最適化
5. パフォーマンステストとベンチマーク

## 解答

### 解答37-1
```sql
-- 教師の作業負荷マテリアライズドビュー
CREATE TABLE mv_teacher_workload (
    teacher_id BIGINT PRIMARY KEY,
    teacher_name VARCHAR(64),
    courses_count INT DEFAULT 0,
    total_students INT DEFAULT 0,
    total_grades INT DEFAULT 0,
    average_grade DECIMAL(5,2) DEFAULT 0.00,
    workload_score DECIMAL(5,2) DEFAULT 0.00,  -- 総合作業負荷スコア
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_workload_score (workload_score),
    INDEX idx_courses_count (courses_count)
);

-- 更新プロシージャ
DELIMITER //
CREATE PROCEDURE refresh_teacher_workload()
BEGIN
    TRUNCATE TABLE mv_teacher_workload;
    
    INSERT INTO mv_teacher_workload 
        (teacher_id, teacher_name, courses_count, total_students, total_grades, average_grade, workload_score)
    SELECT 
        t.teacher_id,
        t.teacher_name,
        COUNT(DISTINCT c.course_id) as courses_count,
        COUNT(DISTINCT sc.student_id) as total_students,
        COUNT(g.grade_id) as total_grades,
        ROUND(AVG(g.score), 2) as average_grade,
        -- 作業負荷スコア：講座数×10 + 学生数×0.5 + 成績数×0.1
        ROUND(COUNT(DISTINCT c.course_id) * 10 + COUNT(DISTINCT sc.student_id) * 0.5 + COUNT(g.grade_id) * 0.1, 2) as workload_score
    FROM teachers t
    LEFT JOIN courses c ON t.teacher_id = c.teacher_id
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id
    GROUP BY t.teacher_id, t.teacher_name;
    
    -- ログ記録
    INSERT INTO mv_refresh_log (mv_name, refresh_type, record_count)
    SELECT 'mv_teacher_workload', 'COMPLETE', COUNT(*) FROM mv_teacher_workload;
END //
DELIMITER ;

-- 初期データ投入
CALL refresh_teacher_workload();

-- 結果確認
SELECT * FROM mv_teacher_workload ORDER BY workload_score DESC;
```

### 解答37-2
```sql
-- 学生マテリアライズドビュー
CREATE TABLE mv_student_list (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100),
    enrollment_count INT DEFAULT 0,
    grade_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 学生変更追跡用トリガー
DELIMITER //
CREATE TRIGGER tr_students_insert_mv
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    INSERT INTO mv_change_log (table_name, operation_type, record_id)
    VALUES ('students', 'INSERT', NEW.student_id);
END //

CREATE TRIGGER tr_students_update_mv
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
    INSERT INTO mv_change_log (table_name, operation_type, record_id)
    VALUES ('students', 'UPDATE', NEW.student_id);
END //

CREATE TRIGGER tr_students_delete_mv
AFTER DELETE ON students
FOR EACH ROW
BEGIN
    INSERT INTO mv_change_log (table_name, operation_type, record_id)
    VALUES ('students', 'DELETE', OLD.student_id);
END //
DELIMITER ;

-- 増分更新プロシージャ
DELIMITER //
CREATE PROCEDURE incremental_refresh_student_list()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE affected_student_id BIGINT;
    DECLARE operation_type VARCHAR(10);
    
    DECLARE change_cursor CURSOR FOR
        SELECT DISTINCT record_id, operation_type
        FROM mv_change_log 
        WHERE table_name = 'students' AND processed = FALSE;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN change_cursor;
    
    change_loop: LOOP
        FETCH change_cursor INTO affected_student_id, operation_type;
        IF done THEN
            LEAVE change_loop;
        END IF;
        
        IF operation_type = 'DELETE' THEN
            DELETE FROM mv_student_list WHERE student_id = affected_student_id;
        ELSE
            INSERT INTO mv_student_list 
                (student_id, student_name, enrollment_count, grade_count)
            SELECT 
                s.student_id,
                s.student_name,
                COUNT(DISTINCT sc.course_id) as enrollment_count,
                COUNT(g.grade_id) as grade_count
            FROM students s
            LEFT JOIN student_courses sc ON s.student_id = sc.student_id
            LEFT JOIN grades g ON s.student_id = g.student_id
            WHERE s.student_id = affected_student_id
            GROUP BY s.student_id, s.student_name
            ON DUPLICATE KEY UPDATE
                student_name = VALUES(student_name),
                enrollment_count = VALUES(enrollment_count),
                grade_count = VALUES(grade_count),
                last_updated = CURRENT_TIMESTAMP;
        END IF;
    END LOOP;
    
    CLOSE change_cursor;
    
    -- 処理済みマーク
    UPDATE mv_change_log 
    SET processed = TRUE 
    WHERE table_name = 'students' AND processed = FALSE;
END //
DELIMITER ;

-- 初期データ投入
INSERT INTO mv_student_list (student_id, student_name, enrollment_count, grade_count)
SELECT 
    s.student_id,
    s.student_name,
    COUNT(DISTINCT sc.course_id) as enrollment_count,
    COUNT(g.grade_id) as grade_count
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name;

-- テスト：学生データ更新
UPDATE students SET student_name = '田中太郎（更新）' WHERE student_id = 301;

-- 増分更新実行
CALL incremental_refresh_student_list();

-- 結果確認
SELECT * FROM mv_student_list WHERE student_id = 301;
```

### 解答37-3
```sql
-- 日別学生統計マテリアライズドビュー
CREATE TABLE mv_daily_student_stats (
    stat_date DATE PRIMARY KEY,
    new_registrations INT DEFAULT 0,
    cumulative_students INT DEFAULT 0,
    registration_rate DECIMAL(5,2) DEFAULT 0.00,  -- 前日比増加率
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_stat_date (stat_date)
);

-- 過去30日分データ生成プロシージャ
DELIMITER //
CREATE PROCEDURE refresh_daily_student_stats_30days()
BEGIN
    DECLARE current_date DATE;
    DECLARE end_date DATE DEFAULT CURRENT_DATE;
    DECLARE start_date DATE DEFAULT DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
    DECLARE new_reg_count INT;
    DECLARE cumulative_count INT;
    DECLARE prev_cumulative INT DEFAULT 0;
    DECLARE rate_calc DECIMAL(5,2);
    
    -- 既存の30日分データを削除
    DELETE FROM mv_daily_student_stats 
    WHERE stat_date >= start_date;
    
    SET current_date = start_date;
    
    WHILE current_date <= end_date DO
        -- その日の新規登録数を計算（admission_dateを使用）
        SELECT COUNT(*) INTO new_reg_count
        FROM students 
        WHERE DATE(created_at) = current_date;
        
        -- 累計学生数を計算
        SELECT COUNT(*) INTO cumulative_count
        FROM students 
        WHERE DATE(created_at) <= current_date;
        
        -- 前日比増加率を計算
        IF prev_cumulative > 0 THEN
            SET rate_calc = ROUND(((cumulative_count - prev_cumulative) / prev_cumulative) * 100, 2);
        ELSE
            SET rate_calc = 0.00;
        END IF;
        
        -- データ挿入
        INSERT INTO mv_daily_student_stats 
            (stat_date, new_registrations, cumulative_students, registration_rate)
        VALUES 
            (current_date, new_reg_count, cumulative_count, rate_calc);
        
        SET prev_cumulative = cumulative_count;
        SET current_date = DATE_ADD(current_date, INTERVAL 1 DAY);
    END WHILE;
    
    -- ログ記録
    INSERT INTO mv_refresh_log (mv_name, refresh_type, record_count)
    VALUES ('mv_daily_student_stats', 'COMPLETE', 30);
END //
DELIMITER ;

-- 更新実行
CALL refresh_daily_student_stats_30days();

-- グラフ表示用データ出力
SELECT 
    stat_date,
    new_registrations,
    cumulative_students,
    registration_rate,
    -- 7日移動平均
    ROUND(AVG(new_registrations) OVER (
        ORDER BY stat_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 1) as moving_avg_7days
FROM mv_daily_student_stats 
ORDER BY stat_date;
```

### 解答37-4
```sql
-- 講座品質指数マテリアライズドビュー
CREATE TABLE mv_course_quality_index (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128),
    teacher_name VARCHAR(64),
    average_score DECIMAL(5,2) DEFAULT 0.00,
    attendance_rate DECIMAL(5,2) DEFAULT 0.00,
    enrollment_rate DECIMAL(5,2) DEFAULT 0.00,  -- 受講者充足率
    teacher_rating DECIMAL(3,2) DEFAULT 3.00,   -- 教師評価（1-5）
    quality_index DECIMAL(5,2) DEFAULT 0.00,    -- 総合品質指数
    quality_rank INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_quality_index (quality_index),
    INDEX idx_quality_rank (quality_rank)
);

-- 品質指数計算プロシージャ
DELIMITER //
CREATE PROCEDURE refresh_course_quality_index()
BEGIN
    TRUNCATE TABLE mv_course_quality_index;
    
    INSERT INTO mv_course_quality_index 
        (course_id, course_name, teacher_name, average_score, attendance_rate, 
         enrollment_rate, teacher_rating, quality_index)
    SELECT 
        c.course_id,
        c.course_name,
        t.teacher_name,
        COALESCE(ROUND(AVG(g.score), 2), 0) as average_score,
        COALESCE(ROUND(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 2), 0) as attendance_rate,
        ROUND((COUNT(DISTINCT sc.student_id) / 30.0) * 100, 2) as enrollment_rate,  -- 定員30名と仮定
        4.0 as teacher_rating,  -- 固定値（実際は評価テーブルから取得）
        -- 品質指数計算
        ROUND(
            COALESCE(AVG(g.score), 0) * 0.4 +
            COALESCE(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 0) * 0.3 +
            LEAST((COUNT(DISTINCT sc.student_id) / 30.0) * 100, 100) * 0.2 +
            4.0 * 20 * 0.1,  -- 教師評価を100点満点に換算
            2
        ) as quality_index
    FROM courses c
    JOIN teachers t ON c.teacher_id = t.teacher_id
    LEFT JOIN student_courses sc ON c.course_id = sc.course_id
    LEFT JOIN grades g ON c.course_id = g.course_id
    LEFT JOIN course_schedule cs ON c.course_id = cs.course_id
    LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
    GROUP BY c.course_id, c.course_name, t.teacher_name;
    
    -- ランキング設定
    SET @rank = 0;
    UPDATE mv_course_quality_index cqi1
    JOIN (
        SELECT course_id, @rank := @rank + 1 as new_rank
        FROM mv_course_quality_index
        ORDER BY quality_index DESC
    ) cqi2 ON cqi1.course_id = cqi2.course_id
    SET cqi1.quality_rank = cqi2.new_rank;
    
    -- ログ記録
    INSERT INTO mv_refresh_log (mv_name, refresh_type, record_count)
    SELECT 'mv_course_quality_index', 'COMPLETE', COUNT(*) FROM mv_course_quality_index;
END //
DELIMITER ;

-- 更新実行
CALL refresh_course_quality_index();

-- ランキング表示
SELECT 
    quality_rank,
    course_name,
    teacher_name,
    quality_index,
    average_score,
    attendance_rate,
    enrollment_rate
FROM mv_course_quality_index 
ORDER BY quality_rank
LIMIT 10;
```

### 解答37-5
```sql
-- エラーログテーブル
CREATE TABLE mv_error_log (
    error_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    mv_name VARCHAR(100),
    error_message TEXT,
    error_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    execution_context JSON
);

-- 改良された自動実行プロシージャ
DELIMITER //
CREATE PROCEDURE execute_scheduled_refreshes_with_error_handling()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE mv_name_var VARCHAR(100);
    DECLARE refresh_type_var VARCHAR(20);
    DECLARE refresh_freq_var VARCHAR(20);
    DECLARE start_time TIMESTAMP;
    DECLARE execution_time INT;
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE error_message TEXT DEFAULT '';
    
    DECLARE schedule_cursor CURSOR FOR
        SELECT mv_name, refresh_type, refresh_frequency
        FROM mv_refresh_schedule 
        WHERE is_active = TRUE 
        AND next_refresh <= NOW();
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            error_message = MESSAGE_TEXT;
        SET error_occurred = TRUE;
    END;
    
    OPEN schedule_cursor;
    
    refresh_loop: LOOP
        FETCH schedule_cursor INTO mv_name_var, refresh_type_var, refresh_freq_var;
        IF done THEN
            LEAVE refresh_loop;
        END IF;
        
        SET start_time = NOW();
        SET error_occurred = FALSE;
        SET error_message = '';
        
        -- エラーハンドリング付きで更新実行
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            BEGIN
                GET DIAGNOSTICS CONDITION 1
                    error_message = MESSAGE_TEXT;
                SET error_occurred = TRUE;
            END;
            
            CASE mv_name_var
                WHEN 'mv_student_grade_summary' THEN
                    IF refresh_type_var = 'COMPLETE' THEN
                        CALL refresh_student_grade_summary();
                    ELSE
                        CALL incremental_refresh_student_grades();
                    END IF;
                
                WHEN 'mv_teacher_workload' THEN
                    CALL refresh_teacher_workload();
                
                WHEN 'mv_course_quality_index' THEN
                    CALL refresh_course_quality_index();
            END CASE;
        END;
        
        SET execution_time = TIMESTAMPDIFF(SECOND, start_time, NOW());
        
        IF error_occurred THEN
            -- エラーログ記録
            INSERT INTO mv_error_log (mv_name, error_message, execution_context)
            VALUES (mv_name_var, error_message, JSON_OBJECT(
                'refresh_type', refresh_type_var,
                'execution_time', execution_time,
                'start_time', start_time
            ));
            
            -- スケジュールは次回に延期
            UPDATE mv_refresh_schedule 
            SET next_refresh = DATE_ADD(NOW(), INTERVAL 1 HOUR)
            WHERE mv_name = mv_name_var;
        ELSE
            -- 正常終了時のスケジュール更新
            UPDATE mv_refresh_schedule 
            SET 
                last_refresh = start_time,
                next_refresh = CASE 
                    WHEN refresh_freq_var = 'HOURLY' THEN DATE_ADD(start_time, INTERVAL 1 HOUR)
                    WHEN refresh_freq_var = 'DAILY' THEN DATE_ADD(start_time, INTERVAL 1 DAY)
                    WHEN refresh_freq_var = 'WEEKLY' THEN DATE_ADD(start_time, INTERVAL 1 WEEK)
                    WHEN refresh_freq_var = 'MONTHLY' THEN DATE_ADD(start_time, INTERVAL 1 MONTH)
                END
            WHERE mv_name = mv_name_var;
            
            -- 成功ログ更新
            UPDATE mv_refresh_log 
            SET execution_time_ms = execution_time * 1000
            WHERE mv_name = mv_name_var 
            AND refresh_time >= start_time
            ORDER BY refresh_time DESC
            LIMIT 1;
        END IF;
        
    END LOOP;
    
    CLOSE schedule_cursor;
END //
DELIMITER ;

-- 監視クエリ
SELECT 
    'スケジュール状況' as report_type,
    mv_name,
    refresh_frequency,
    last_refresh,
    next_refresh,
    CASE WHEN next_refresh <= NOW() THEN '実行待ち' ELSE '待機中' END as status
FROM mv_refresh_schedule
UNION ALL
SELECT 
    'エラー状況',
    mv_name,
    COUNT(*),
    MAX(error_time),
    NULL,
    CONCAT(COUNT(*), '件のエラー')
FROM mv_error_log
WHERE error_time >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
GROUP BY mv_name;
```

### 解答37-6
```sql
-- パーティション化マテリアライズドビュー（年月別）
CREATE TABLE mv_large_performance_data (
    data_date DATE NOT NULL,
    student_id BIGINT NOT NULL,
    performance_metrics JSON,
    aggregated_score DECIMAL(8,2),
    ranking_position INT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (data_date, student_id),
    INDEX idx_aggregated_score (aggregated_score),
    INDEX idx_ranking (ranking_position)
) PARTITION BY RANGE (YEAR(data_date) * 100 + MONTH(data_date)) (
    PARTITION p202401 VALUES LESS THAN (202402),
    PARTITION p202402 VALUES LESS THAN (202403),
    PARTITION p202403 VALUES LESS THAN (202404),
    PARTITION p202404 VALUES LESS THAN (202405),
    PARTITION p202405 VALUES LESS THAN (202406),
    PARTITION p202406 VALUES LESS THAN (202407),
    PARTITION p202407 VALUES LESS THAN (202408),
    PARTITION p202408 VALUES LESS THAN (202409),
    PARTITION p202409 VALUES LESS THAN (202410),
    PARTITION p202410 VALUES LESS THAN (202411),
    PARTITION p202411 VALUES LESS THAN (202412),
    PARTITION p202412 VALUES LESS THAN (202501),
    PARTITION p202501 VALUES LESS THAN (202502),
    PARTITION p202502 VALUES LESS THAN (202503),
    PARTITION p202503 VALUES LESS THAN (202504),
    PARTITION p202504 VALUES LESS THAN (202505),
    PARTITION p202505 VALUES LESS THAN (202506),
    PARTITION p202506 VALUES LESS THAN (MAXVALUE)
);

-- 並行更新対応プロシージャ
DELIMITER //
CREATE PROCEDURE refresh_large_performance_data_concurrent(
    IN target_date DATE,
    IN worker_id INT,
    IN total_workers INT
)
BEGIN
    DECLARE batch_size INT DEFAULT 1000;
    DECLARE offset_val INT DEFAULT 0;
    DECLARE processed_count INT DEFAULT 0;
    
    -- 該当日付のパーティションデータを削除
    DELETE FROM mv_large_performance_data 
    WHERE data_date = target_date
    AND MOD(student_id, total_workers) = worker_id - 1;
    
    -- バッチ処理でデータ挿入
    batch_loop: LOOP
        SET @sql = CONCAT(
            'INSERT INTO mv_large_performance_data ',
            '(data_date, student_id, performance_metrics, aggregated_score, ranking_position) ',
            'SELECT ?, s.student_id, ',
            'JSON_OBJECT(', 
                '"avg_grade", COALESCE(AVG(g.score), 0), ',
                '"attendance_rate", COALESCE(AVG(CASE WHEN a.status = "present" THEN 100.0 ELSE 0 END), 0), ',
                '"assignment_completion", COALESCE(COUNT(g.grade_id) / 10.0 * 100, 0)',
            '), ',
            'ROUND(COALESCE(AVG(g.score), 0) * 0.6 + ',
            'COALESCE(AVG(CASE WHEN a.status = "present" THEN 100.0 ELSE 0 END), 0) * 0.4, 2), ',
            '0 ',
            'FROM students s ',
            'LEFT JOIN grades g ON s.student_id = g.student_id ',
            'LEFT JOIN attendance a ON s.student_id = a.student_id ',
            'WHERE MOD(s.student_id, ?) = ? ',
            'GROUP BY s.student_id ',
            'LIMIT ? OFFSET ?'
        );
        
        PREPARE stmt FROM @sql;
        EXECUTE stmt USING target_date, total_workers, worker_id - 1, batch_size, offset_val;
        DEALLOCATE PREPARE stmt;
        
        -- 処理件数確認
        SET processed_count = ROW_COUNT();
        IF processed_count < batch_size THEN
            LEAVE batch_loop;
        END IF;
        
        SET offset_val = offset_val + batch_size;
    END LOOP;
    
    -- ランキング更新（該当ワーカーの担当分のみ）
    SET @rank = 0;
    UPDATE mv_large_performance_data lpd1
    JOIN (
        SELECT 
            student_id, 
            @rank := @rank + 1 as new_rank
        FROM mv_large_performance_data
        WHERE data_date = target_date
        AND MOD(student_id, total_workers) = worker_id - 1
        ORDER BY aggregated_score DESC
    ) lpd2 ON lpd1.student_id = lpd2.student_id
    SET lpd1.ranking_position = lpd2.new_rank
    WHERE lpd1.data_date = target_date;
    
END //
DELIMITER ;

-- パフォーマンステスト
DELIMITER //
CREATE PROCEDURE benchmark_materialized_view_performance()
BEGIN
    DECLARE start_time TIMESTAMP;
    DECLARE end_time TIMESTAMP;
    DECLARE mv_time INT;
    DECLARE regular_time INT;
    
    -- マテリアライズドビューのクエリ
    SET start_time = NOW(6);
    SELECT COUNT(*), AVG(aggregated_score), MAX(aggregated_score)
    FROM mv_large_performance_data 
    WHERE data_date = CURRENT_DATE;
    SET end_time = NOW(6);
    SET mv_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time);
    
    -- 通常クエリ
    SET start_time = NOW(6);
    SELECT COUNT(*), AVG(score_calc), MAX(score_calc)
    FROM (
        SELECT s.student_id,
               ROUND(COALESCE(AVG(g.score), 0) * 0.6 + 
                     COALESCE(AVG(CASE WHEN a.status = 'present' THEN 100.0 ELSE 0 END), 0) * 0.4, 2) as score_calc
        FROM students s
        LEFT JOIN grades g ON s.student_id = g.student_id
        LEFT JOIN attendance a ON s.student_id = a.student_id
        GROUP BY s.student_id
    ) calculated;
    SET end_time = NOW(6);
    SET regular_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time);
    
    -- ベンチマーク結果
    SELECT 
        mv_time as materialized_view_microseconds,
        regular_time as regular_query_microseconds,
        ROUND(regular_time / mv_time, 2) as performance_improvement,
        ROUND((regular_time - mv_time) / 1000, 2) as time_saved_ms;
END //
DELIMITER ;

-- ベンチマーク実行
CALL benchmark_materialized_view_performance();

-- ストレージ使用量分析
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) as data_mb,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) as index_mb
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'mv_large_performance_data'
AND PARTITION_NAME IS NOT NULL
ORDER BY PARTITION_NAME;
```

## まとめ

この章では、MySQLでのマテリアライズドビューの実装について詳しく学びました：

1. **マテリアライズドビューの基本概念**：
   - 通常のビューとの違い
   - パフォーマンス向上の仕組み
   - MySQLでの代替実装方法

2. **基本的な実装パターン**：
   - 集計テーブルの作成
   - 更新プロシージャの設計
   - 初期データの投入

3. **増分更新システム**：
   - 変更追跡メカニズム
   - トリガーによる自動検知
   - 効率的な部分更新

4. **複雑な集計ビューの構築**：
   - 月別統計の管理
   - パフォーマンス分析指標
   - JSON形式での柔軟なデータ格納

5. **自動更新システム**：
   - スケジュール管理
   - エラーハンドリング
   - 実行ログと監視

6. **パフォーマンス最適化**：
   - パーティション化戦略
   - インデックス設計
   - 並行処理対応

7. **実践的な運用例**：
   - ダッシュボード用ビュー
   - データ品質監査
   - ベンチマークと最適化

8. **大規模データ対応**：
   - 分散更新処理
   - メモリ使用量最適化
   - ストレージ効率化

マテリアライズドビューは、適切に設計・運用することで劇的なパフォーマンス向上をもたらします。ただし、データの整合性とリフレッシュコストのバランスを慎重に考慮する必要があります。

次の章では、「スキーマ設計：正規化と非正規化」について学び、効率的なデータベース設計の原則を理解していきます。