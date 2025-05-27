# 41. 行レベルセキュリティ：ビューとプロシージャによる細粒度制御

## はじめに

前章では、GRANT/REVOKE文を使った基本的な権限管理について学習しました。この章では、より細かい制御が可能な「行レベルセキュリティ」について学習します。

従来のテーブルレベル・カラムレベルの権限制御では、「教師は成績テーブルにアクセスできる」といったレベルの制御しかできませんでした。しかし実際の学校システムでは、「教師は担当クラスの学生の成績のみアクセスできる」「学生は自分の成績のみ閲覧できる」といった、データの行（レコード）レベルでの細かい制御が必要です。

行レベルセキュリティが必要となる場面の例：
- 「教師は担当するクラスの学生情報のみ閲覧・変更できる」
- 「学生は自分の成績や出席状況のみ確認できる」
- 「学年主任は担当学年の学生のみ管理できる」
- 「保護者は自分の子供の情報のみアクセスできる」
- 「事務職員は在籍中の学生のみ管理でき、卒業生は閲覧のみ」
- 「カウンセラーは相談対象の学生のみアクセスできる」
- 「医務室スタッフは健康診断対象の学生のみ健康情報を管理できる」

この章では、MySQLでビューとストアドプロシージャを活用して、柔軟で安全な行レベルセキュリティを実装する方法を学習します。

## 行レベルセキュリティの基本概念

### 行レベルセキュリティとは
**行レベルセキュリティ**（Row-Level Security, RLS）とは、テーブル内の特定の行に対するアクセスを、ユーザーの属性や条件に基づいて制御するセキュリティ機能です。

### 実装方式の比較

> **用語解説**：
> - **行レベルセキュリティ（Row-Level Security, RLS）**：テーブル内の特定の行へのアクセスを制御するセキュリティ機能です。
> - **セキュリティビュー（Security View）**：行レベルの制御を行うために作成される、特定の条件でデータをフィルタリングするビューです。
> - **セキュリティコンテキスト**：現在のユーザーの属性や権限を表す情報です（ユーザーID、役職、部署等）。
> - **述語（Predicate）**：行レベルセキュリティで使用される、アクセス可能な行を決定する条件式です。
> - **セキュリティポリシー**：どのユーザーがどの行にアクセスできるかを定義するルールです。
> - **動的セキュリティ**：ユーザーの属性やコンテキストに基づいて動的に変化するセキュリティ制御です。
> - **VPD（Virtual Private Database）**：各ユーザーに対して仮想的に専用のデータベースを提供する技術です。
> - **アプリケーションレベルセキュリティ**：データベース機能ではなく、アプリケーションコードで実装するセキュリティです。
> - **セキュリティコンテナ**：セキュリティ制御を行う単位（クラス、学年、部署等）です。

| 実装方式 | メリット | デメリット | 適用場面 |
|----------|----------|------------|----------|
| **セキュリティビュー** | 実装が簡単、理解しやすい | ビューの管理が複雑化 | 基本的な行レベル制御 |
| **ストアドプロシージャ** | 柔軟な制御、複雑なロジック対応 | 実装が複雑、保守が困難 | 高度な業務ロジック |
| **アプリケーション制御** | 最大の柔軟性 | セキュリティホールのリスク | 複雑な業務要件 |
| **関数ベース制御** | 再利用性が高い | パフォーマンスに注意が必要 | 共通ロジックの実装 |

## ビューによる行レベル制御

### 1. 基本的なセキュリティビューの作成

```sql
-- 学校システムでの基本的なセキュリティビュー例

-- 1. 教師用の担当学生ビュー
-- 教師は自分が担当する講座を受講している学生のみ閲覧可能
CREATE VIEW v_teacher_students AS
SELECT DISTINCT
    s.student_id,
    s.student_name,
    s.student_email,
    sc.course_id,
    c.course_name
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE t.teacher_name = USER() -- 現在のユーザー名と一致する教師
   OR USER() = 'root'; -- 管理者は全て閲覧可能

-- 2. 学生用の自分専用ビュー
-- 学生は自分の情報のみ閲覧可能
CREATE VIEW v_student_own_info AS
SELECT 
    student_id,
    student_name,
    student_email
FROM students
WHERE CONCAT('student_', student_id) = SUBSTRING_INDEX(USER(), '@', 1) -- student_301 のようなユーザー名
   OR USER() = 'root';

-- 3. 学生の成績閲覧ビュー
CREATE VIEW v_student_own_grades AS
SELECT 
    g.student_id,
    g.course_id,
    c.course_name,
    g.grade_type,
    g.score,
    g.max_score,
    g.submission_date,
    ROUND((g.score / g.max_score) * 100, 1) as percentage
FROM grades g
JOIN courses c ON g.course_id = c.course_id
WHERE CONCAT('student_', g.student_id) = SUBSTRING_INDEX(USER(), '@', 1)
   OR USER() = 'root';

-- ビューの使用例確認
SELECT * FROM v_teacher_students;
SELECT * FROM v_student_own_info;
SELECT * FROM v_student_own_grades;
```

### 2. 複雑な条件を持つセキュリティビュー

```sql
-- より複雑な業務ロジックを含むセキュリティビュー

-- 1. 学年主任用の担当学年学生ビュー
CREATE VIEW v_grade_supervisor_students AS
SELECT 
    s.student_id,
    s.student_name,
    s.student_email,
    s.admission_date,
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade,
    e.course_id,
    c.course_name
FROM students s
LEFT JOIN student_courses e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id
WHERE (
    -- 学年主任は担当学年の学生のみ
    CASE 
        WHEN USER() LIKE '%grade_1%' THEN YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 = 1
        WHEN USER() LIKE '%grade_2%' THEN YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 = 2
        WHEN USER() LIKE '%grade_3%' THEN YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 = 3
        ELSE FALSE
    END
    OR USER() = 'root'
);

-- 2. 事務職員用の在籍学生ビュー（卒業生は除外）
CREATE VIEW v_office_active_students AS
SELECT 
    s.student_id,
    s.student_name,
    s.student_email,
    s.admission_date,
    -- 在籍状況の判定
    CASE 
        WHEN YEAR(CURRENT_DATE) - YEAR(s.admission_date) >= 3 THEN '卒業予定'
        WHEN YEAR(CURRENT_DATE) - YEAR(s.admission_date) >= 2 THEN '3年生'
        WHEN YEAR(CURRENT_DATE) - YEAR(s.admission_date) >= 1 THEN '2年生'
        ELSE '1年生'
    END as student_status
FROM students s
WHERE (
    -- 事務職員は在籍中の学生のみ（3年未満）
    (USER() LIKE '%office%' AND YEAR(CURRENT_DATE) - YEAR(s.admission_date) < 3)
    OR USER() = 'root'
    OR USER() LIKE '%principal%' -- 校長は全て閲覧可能
);

-- 3. 動的な期間制限を含む成績ビュー
CREATE VIEW v_recent_grades_by_role AS
SELECT 
    g.student_id,
    s.student_name,
    g.course_id,
    c.course_name,
    g.grade_type,
    g.score,
    g.submission_date,
    -- ユーザーの役職に応じて閲覧期間を制限
    CASE 
        WHEN USER() LIKE '%teacher%' THEN DATEDIFF(CURRENT_DATE, g.submission_date) <= 365 -- 教師は1年分
        WHEN USER() LIKE '%student%' THEN DATEDIFF(CURRENT_DATE, g.submission_date) <= 180 -- 学生は半年分
        ELSE TRUE -- 管理者は全期間
    END as within_access_period
FROM grades g
JOIN courses c ON g.course_id = c.course_id
JOIN students s ON g.student_id = s.student_id
WHERE (
    -- 期間制限の適用
    CASE 
        WHEN USER() LIKE '%teacher%' THEN DATEDIFF(CURRENT_DATE, g.submission_date) <= 365
        WHEN USER() LIKE '%student%' THEN 
            DATEDIFF(CURRENT_DATE, g.submission_date) <= 180 
            AND CONCAT('student_', g.student_id) = SUBSTRING_INDEX(USER(), '@', 1)
        ELSE TRUE
    END
);

-- ビューのテスト
DESCRIBE v_grade_supervisor_students;
DESCRIBE v_office_active_students;
DESCRIBE v_recent_grades_by_role;
```

### 3. セキュリティビューの権限設定

```sql
-- セキュリティビューに対する適切な権限設定

-- 1. 教師向けビューの権限設定
-- 教師ロールに担当学生ビューの閲覧権限を付与
GRANT SELECT ON school_db.v_teacher_students TO 'teacher_role';

-- 担当学生の成績管理権限（ビューではなく条件付きテーブルアクセス）
-- 実際の成績入力用の制限付きビューを作成
CREATE VIEW v_teacher_grade_management AS
SELECT 
    g.student_id,
    g.course_id,
    g.grade_type,
    g.score,
    g.max_score,
    g.submission_date
FROM grades g
JOIN courses c ON g.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE t.teacher_name = USER() OR USER() = 'root';

-- 教師に成績管理ビューの更新権限を付与
GRANT SELECT, INSERT, UPDATE ON school_db.v_teacher_grade_management TO 'teacher_role';

-- 2. 学生向けビューの権限設定
GRANT SELECT ON school_db.v_student_own_info TO 'student_role';
GRANT SELECT ON school_db.v_student_own_grades TO 'student_role';

-- 3. 管理職向けビューの権限設定
GRANT SELECT ON school_db.v_grade_supervisor_students TO 'grade_supervisor_role';
GRANT SELECT ON school_db.v_office_active_students TO 'office_staff_role';

-- 4. 制限付きアクセスの確認
-- 各ロールに適切にビューの権限が設定されているか確認
SELECT 
    table_name,
    grantee,
    privilege_type
FROM information_schema.table_privileges
WHERE table_schema = 'school_db'
AND table_name LIKE 'v_%'
ORDER BY table_name, grantee;
```

## ストアドプロシージャによるセキュリティ実装

### 1. ユーザーコンテキスト管理

```sql
-- ユーザーコンテキスト管理システム

-- 1. ユーザーコンテキスト情報テーブル
CREATE TABLE user_security_context (
    context_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    user_type ENUM('student', 'teacher', 'grade_supervisor', 'office_staff', 'principal', 'admin') NOT NULL,
    associated_id BIGINT, -- 学生ID、教師ID等
    department_id INT,
    grade_level INT, -- 担当学年（学年主任の場合）
    access_restrictions JSON, -- 追加の制限条件
    context_expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_username (username),
    INDEX idx_user_type (user_type),
    INDEX idx_associated_id (associated_id)
);

-- サンプルコンテキストデータの挿入
INSERT INTO user_security_context (username, user_type, associated_id, grade_level) VALUES
('teacher_tanaka@localhost', 'teacher', 101, NULL),
('teacher_sato@localhost', 'teacher', 102, NULL),
('student_301@localhost', 'student', 301, NULL),
('student_302@localhost', 'student', 302, NULL),
('grade_head_1@localhost', 'grade_supervisor', NULL, 1),
('office_staff@localhost', 'office_staff', NULL, NULL);

-- 2. ユーザーコンテキスト取得プロシージャ
DELIMITER //

CREATE PROCEDURE get_user_security_context(
    OUT p_user_type VARCHAR(20),
    OUT p_associated_id BIGINT,
    OUT p_grade_level INT,
    OUT p_access_restrictions JSON
)
BEGIN
    DECLARE v_username VARCHAR(100);
    
    SET v_username = USER();
    
    SELECT user_type, associated_id, grade_level, access_restrictions
    INTO p_user_type, p_associated_id, p_grade_level, p_access_restrictions
    FROM user_security_context
    WHERE username = v_username;
    
    -- デフォルト値の設定（コンテキストが見つからない場合）
    IF p_user_type IS NULL THEN
        SET p_user_type = 'unknown';
        SET p_associated_id = NULL;
        SET p_grade_level = NULL;
        SET p_access_restrictions = '{}';
    END IF;
END //

DELIMITER ;

-- 3. セキュリティ検証プロシージャ
DELIMITER //

CREATE PROCEDURE verify_data_access(
    IN p_table_name VARCHAR(64),
    IN p_operation ENUM('SELECT', 'INSERT', 'UPDATE', 'DELETE'),
    IN p_student_id BIGINT,
    OUT p_access_granted BOOLEAN
)
BEGIN
    DECLARE v_user_type VARCHAR(20);
    DECLARE v_associated_id BIGINT;
    DECLARE v_grade_level INT;
    DECLARE v_restrictions JSON;
    DECLARE v_student_grade INT;
    
    SET p_access_granted = FALSE;
    
    -- ユーザーコンテキストを取得
    CALL get_user_security_context(v_user_type, v_associated_id, v_grade_level, v_restrictions);
    
    -- 管理者は常にアクセス許可
    IF USER() = 'root' OR v_user_type = 'admin' THEN
        SET p_access_granted = TRUE;
    ELSEIF v_user_type = 'student' THEN
        -- 学生は自分のデータのみアクセス可能
        IF p_student_id = v_associated_id THEN
            SET p_access_granted = TRUE;
        END IF;
    ELSEIF v_user_type = 'teacher' THEN
        -- 教師は担当講座の学生のみアクセス可能
        SELECT COUNT(*) > 0 INTO p_access_granted
        FROM student_courses sc
        JOIN courses c ON sc.course_id = c.course_id
        WHERE sc.student_id = p_student_id 
        AND c.teacher_id = v_associated_id;
    ELSEIF v_user_type = 'grade_supervisor' THEN
        -- 学年主任は担当学年の学生のみアクセス可能
        SELECT (YEAR(CURRENT_DATE) - YEAR(admission_date) + 1) INTO v_student_grade
        FROM students 
        WHERE student_id = p_student_id;
        
        IF v_student_grade = v_grade_level THEN
            SET p_access_granted = TRUE;
        END IF;
    ELSEIF v_user_type = 'office_staff' THEN
        -- 事務職員は在籍中の学生のみアクセス可能
        SELECT COUNT(*) > 0 INTO p_access_granted
        FROM students s
        WHERE s.student_id = p_student_id
        AND YEAR(CURRENT_DATE) - YEAR(s.admission_date) < 3; -- 3年未満
    END IF;
    
END //

DELIMITER ;
```

### 2. 安全なデータアクセスプロシージャ

```sql
-- 安全なデータアクセスのためのプロシージャ群

-- 1. 学生情報の安全な取得
DELIMITER //

CREATE PROCEDURE secure_get_student_info(
    IN p_student_id BIGINT
)
BEGIN
    DECLARE v_access_granted BOOLEAN DEFAULT FALSE;
    
    -- アクセス権限の検証
    CALL verify_data_access('students', 'SELECT', p_student_id, v_access_granted);
    
    IF v_access_granted THEN
        SELECT 
            student_id,
            student_name,
            student_email,
            admission_date,
            YEAR(CURRENT_DATE) - YEAR(admission_date) + 1 as current_grade
        FROM students
        WHERE student_id = p_student_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Insufficient privileges for student data';
    END IF;
END //

-- 2. 成績情報の安全な取得
CREATE PROCEDURE secure_get_student_grades(
    IN p_student_id BIGINT,
    IN p_course_id VARCHAR(16)
)
BEGIN
    DECLARE v_access_granted BOOLEAN DEFAULT FALSE;
    DECLARE v_user_type VARCHAR(20);
    DECLARE v_associated_id BIGINT;
    DECLARE v_grade_level INT;
    DECLARE v_restrictions JSON;
    
    -- アクセス権限の検証
    CALL verify_data_access('grades', 'SELECT', p_student_id, v_access_granted);
    CALL get_user_security_context(v_user_type, v_associated_id, v_grade_level, v_restrictions);
    
    IF v_access_granted THEN
        SELECT 
            g.student_id,
            s.student_name,
            g.course_id,
            c.course_name,
            g.grade_type,
            g.score,
            g.max_score,
            g.submission_date,
            ROUND((g.score / g.max_score) * 100, 1) as percentage
        FROM grades g
        JOIN students s ON g.student_id = s.student_id
        JOIN courses c ON g.course_id = c.course_id
        WHERE g.student_id = p_student_id
        AND (p_course_id IS NULL OR g.course_id = p_course_id)
        AND (
            v_user_type = 'admin'
            OR (v_user_type = 'student' AND g.student_id = v_associated_id)
            OR (v_user_type = 'teacher' AND c.teacher_id = v_associated_id)
            OR v_user_type IN ('grade_supervisor', 'office_staff')
        )
        ORDER BY g.submission_date DESC;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Insufficient privileges for grade data';
    END IF;
END //

-- 3. 成績の安全な更新
CREATE PROCEDURE secure_update_student_grade(
    IN p_student_id BIGINT,
    IN p_course_id VARCHAR(16),
    IN p_grade_type VARCHAR(32),
    IN p_score DECIMAL(5,2),
    IN p_max_score DECIMAL(5,2)
)
BEGIN
    DECLARE v_access_granted BOOLEAN DEFAULT FALSE;
    DECLARE v_user_type VARCHAR(20);
    DECLARE v_associated_id BIGINT;
    DECLARE v_grade_level INT;
    DECLARE v_restrictions JSON;
    DECLARE v_teacher_authorized BOOLEAN DEFAULT FALSE;
    
    -- ユーザーコンテキストを取得
    CALL get_user_security_context(v_user_type, v_associated_id, v_grade_level, v_restrictions);
    
    -- アクセス権限の検証
    CALL verify_data_access('grades', 'UPDATE', p_student_id, v_access_granted);
    
    -- 教師の場合、担当講座かどうかを追加確認
    IF v_user_type = 'teacher' THEN
        SELECT COUNT(*) > 0 INTO v_teacher_authorized
        FROM courses c
        WHERE c.course_id = p_course_id 
        AND c.teacher_id = v_associated_id;
        
        IF NOT v_teacher_authorized THEN
            SET v_access_granted = FALSE;
        END IF;
    END IF;
    
    IF v_access_granted THEN
        -- 成績の更新または挿入
        INSERT INTO grades (student_id, course_id, grade_type, score, max_score, submission_date)
        VALUES (p_student_id, p_course_id, p_grade_type, p_score, p_max_score, CURRENT_DATE)
        ON DUPLICATE KEY UPDATE
            score = p_score,
            max_score = p_max_score,
            submission_date = CURRENT_DATE;
        
        -- 操作ログの記録
        INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
        VALUES ('UPDATE', CONCAT('student_', p_student_id), 'system', 'grade_update', USER(),
                CONCAT('Updated grade for course ', p_course_id, ', type: ', p_grade_type));
        
        SELECT 'Grade updated successfully' as result;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Insufficient privileges to update grades';
    END IF;
END //

DELIMITER ;
```

### 3. 動的セキュリティプロシージャ

```sql
-- 動的な条件に基づくセキュリティ制御

-- 1. 時間制限付きアクセス制御
DELIMITER //

CREATE PROCEDURE secure_time_restricted_access(
    IN p_table_name VARCHAR(64),
    IN p_operation ENUM('SELECT', 'INSERT', 'UPDATE', 'DELETE'),
    IN p_filter_conditions TEXT,
    OUT p_access_result TEXT
)
BEGIN
    DECLARE v_user_type VARCHAR(20);
    DECLARE v_associated_id BIGINT;
    DECLARE v_grade_level INT;
    DECLARE v_restrictions JSON;
    DECLARE v_current_hour INT;
    DECLARE v_access_allowed BOOLEAN DEFAULT TRUE;
    
    SET v_current_hour = HOUR(NOW());
    
    -- ユーザーコンテキストを取得
    CALL get_user_security_context(v_user_type, v_associated_id, v_grade_level, v_restrictions);
    
    -- 時間制限の確認
    IF v_user_type = 'student' THEN
        -- 学生は平日の8:00-18:00のみアクセス可能
        IF DAYOFWEEK(CURRENT_DATE) IN (1, 7) OR v_current_hour < 8 OR v_current_hour > 18 THEN
            SET v_access_allowed = FALSE;
            SET p_access_result = 'Access denied: Outside allowed hours (weekdays 8:00-18:00)';
        END IF;
    ELSEIF v_user_type = 'teacher' THEN
        -- 教師は平日の7:00-20:00のみアクセス可能
        IF DAYOFWEEK(CURRENT_DATE) IN (1, 7) OR v_current_hour < 7 OR v_current_hour > 20 THEN
            SET v_access_allowed = FALSE;
            SET p_access_result = 'Access denied: Outside allowed hours (weekdays 7:00-20:00)';
        END IF;
    END IF;
    
    -- 操作制限の確認
    IF v_access_allowed AND p_operation IN ('UPDATE', 'DELETE') THEN
        IF v_user_type = 'student' THEN
            SET v_access_allowed = FALSE;
            SET p_access_result = 'Access denied: Students cannot modify data';
        END IF;
    END IF;
    
    IF v_access_allowed THEN
        SET p_access_result = 'Access granted';
    END IF;
    
    -- アクセスログの記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('ACCESS_CHECK', USER(), 'system', v_user_type, 'SECURITY_SYSTEM',
            CONCAT('Time-restricted access check: ', p_access_result));
    
END //

-- 2. 条件付きデータフィルタリング
CREATE PROCEDURE get_filtered_student_data(
    IN p_search_criteria JSON
)
BEGIN
    DECLARE v_user_type VARCHAR(20);
    DECLARE v_associated_id BIGINT;
    DECLARE v_grade_level INT;
    DECLARE v_restrictions JSON;
    DECLARE v_where_clause TEXT DEFAULT '';
    
    -- ユーザーコンテキストを取得
    CALL get_user_security_context(v_user_type, v_associated_id, v_grade_level, v_restrictions);
    
    -- ユーザータイプに応じた基本フィルターの設定
    CASE v_user_type
        WHEN 'student' THEN
            SET v_where_clause = CONCAT('s.student_id = ', v_associated_id);
        WHEN 'teacher' THEN
            SET v_where_clause = CONCAT(
                's.student_id IN (',
                'SELECT DISTINCT sc.student_id FROM student_courses sc ',
                'JOIN courses c ON sc.course_id = c.course_id ',
                'WHERE c.teacher_id = ', v_associated_id, ')'
            );
        WHEN 'grade_supervisor' THEN
            SET v_where_clause = CONCAT(
                'YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 = ', v_grade_level
            );
        WHEN 'office_staff' THEN
            SET v_where_clause = 'YEAR(CURRENT_DATE) - YEAR(s.admission_date) < 3';
        ELSE
            SET v_where_clause = '1=1'; -- 管理者等は制限なし
    END CASE;
    
    -- 動的クエリの構築と実行
    SET @sql = CONCAT(
        'SELECT s.student_id, s.student_name, s.student_email, ',
        'YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade ',
        'FROM students s WHERE ', v_where_clause
    );
    
    -- 追加の検索条件があれば適用
    IF JSON_UNQUOTE(JSON_EXTRACT(p_search_criteria, '$.name_pattern')) IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND s.student_name LIKE ''%', 
                         JSON_UNQUOTE(JSON_EXTRACT(p_search_criteria, '$.name_pattern')), '%''');
    END IF;
    
    SET @sql = CONCAT(@sql, ' ORDER BY s.student_id');
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
END //

DELIMITER ;
```

## 学校システムでの実践例

### 1. 担任教師システム

```sql
-- 担任教師に特化したセキュリティシステム

-- 1. 担任クラス管理テーブル
CREATE TABLE homeroom_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id BIGINT NOT NULL,
    class_name VARCHAR(50) NOT NULL,
    grade_level INT NOT NULL,
    academic_year YEAR NOT NULL,
    student_list JSON, -- 担当学生のIDリスト
    is_active BOOLEAN DEFAULT TRUE,
    start_date DATE NOT NULL,
    end_date DATE,
    
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    UNIQUE KEY unique_active_assignment (teacher_id, academic_year, is_active),
    INDEX idx_grade_year (grade_level, academic_year)
);

-- サンプルデータの挿入
INSERT INTO homeroom_assignments (teacher_id, class_name, grade_level, academic_year, student_list, start_date) VALUES
(101, '1年A組', 1, 2025, JSON_ARRAY(301, 302, 303), '2025-04-01'),
(102, '2年B組', 2, 2025, JSON_ARRAY(304, 305), '2025-04-01');

-- 2. 担任教師専用の包括的ビュー
CREATE VIEW v_homeroom_teacher_comprehensive AS
SELECT 
    s.student_id,
    s.student_name,
    s.student_email,
    s.admission_date,
    ha.class_name,
    ha.grade_level,
    -- 最新の成績情報
    recent_grades.latest_score,
    recent_grades.latest_submission,
    -- 出席状況
    attendance_stats.attendance_rate,
    attendance_stats.absent_days,
    -- 受講講座数
    course_stats.enrolled_courses
FROM students s
JOIN homeroom_assignments ha ON JSON_CONTAINS(ha.student_list, CAST(s.student_id AS JSON))
LEFT JOIN (
    SELECT 
        student_id,
        AVG(score/max_score*100) as latest_score,
        MAX(submission_date) as latest_submission
    FROM grades 
    WHERE submission_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    GROUP BY student_id
) recent_grades ON s.student_id = recent_grades.student_id
LEFT JOIN (
    SELECT 
        a.student_id,
        ROUND(COUNT(CASE WHEN a.status = 'present' THEN 1 END) * 100.0 / COUNT(*), 1) as attendance_rate,
        COUNT(CASE WHEN a.status = 'absent' THEN 1 END) as absent_days
    FROM attendance a
    JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
    WHERE cs.schedule_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    GROUP BY a.student_id
) attendance_stats ON s.student_id = attendance_stats.student_id
LEFT JOIN (
    SELECT student_id, COUNT(DISTINCT course_id) as enrolled_courses
    FROM student_courses
    GROUP BY student_id
) course_stats ON s.student_id = course_stats.student_id
WHERE ha.is_active = TRUE
AND ha.teacher_id = (
    SELECT teacher_id FROM teachers WHERE teacher_name = USER()
    UNION SELECT NULL WHERE USER() = 'root'
);

-- 3. 担任教師用の操作プロシージャ
DELIMITER //

CREATE PROCEDURE homeroom_get_class_summary()
BEGIN
    DECLARE v_teacher_id BIGINT;
    
    -- 現在のユーザーが教師かどうかを確認
    SELECT teacher_id INTO v_teacher_id
    FROM teachers 
    WHERE teacher_name = USER();
    
    IF v_teacher_id IS NULL AND USER() != 'root' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Not a registered teacher';
    END IF;
    
    -- クラス全体のサマリーを表示
    SELECT 
        ha.class_name,
        ha.grade_level,
        JSON_LENGTH(ha.student_list) as total_students,
        COUNT(s.student_id) as registered_students,
        ROUND(AVG(recent_grades.avg_score), 1) as class_average_grade,
        ROUND(AVG(attendance_stats.attendance_rate), 1) as class_attendance_rate
    FROM homeroom_assignments ha
    LEFT JOIN students s ON JSON_CONTAINS(ha.student_list, CAST(s.student_id AS JSON))
    LEFT JOIN (
        SELECT 
            student_id,
            AVG(score/max_score*100) as avg_score
        FROM grades 
        WHERE submission_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
        GROUP BY student_id
    ) recent_grades ON s.student_id = recent_grades.student_id
    LEFT JOIN (
        SELECT 
            a.student_id,
            COUNT(CASE WHEN a.status = 'present' THEN 1 END) * 100.0 / COUNT(*) as attendance_rate
        FROM attendance a
        JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
        WHERE cs.schedule_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
        GROUP BY a.student_id
    ) attendance_stats ON s.student_id = attendance_stats.student_id
    WHERE ha.teacher_id = v_teacher_id
    AND ha.is_active = TRUE
    GROUP BY ha.assignment_id, ha.class_name, ha.grade_level;
    
END //

CREATE PROCEDURE homeroom_get_student_detail(
    IN p_student_id BIGINT
)
BEGIN
    DECLARE v_teacher_id BIGINT;
    DECLARE v_student_authorized BOOLEAN DEFAULT FALSE;
    
    -- 現在のユーザーが教師かどうかを確認
    SELECT teacher_id INTO v_teacher_id
    FROM teachers 
    WHERE teacher_name = USER();
    
    IF v_teacher_id IS NULL AND USER() != 'root' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Not a registered teacher';
    END IF;
    
    -- 担任している学生かどうかを確認
    SELECT COUNT(*) > 0 INTO v_student_authorized
    FROM homeroom_assignments ha
    WHERE ha.teacher_id = v_teacher_id
    AND ha.is_active = TRUE
    AND JSON_CONTAINS(ha.student_list, CAST(p_student_id AS JSON));
    
    IF NOT v_student_authorized AND USER() != 'root' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Student not in your homeroom class';
    END IF;
    
    -- 学生の詳細情報を取得
    SELECT * FROM v_homeroom_teacher_comprehensive
    WHERE student_id = p_student_id;
    
END //

DELIMITER ;
```

### 2. 保護者アクセスシステム

```sql
-- 保護者向けの限定的アクセスシステム

-- 1. 保護者-学生関係テーブル
CREATE TABLE parent_student_relationships (
    relationship_id INT AUTO_INCREMENT PRIMARY KEY,
    parent_username VARCHAR(100) NOT NULL,
    student_id BIGINT NOT NULL,
    relationship_type ENUM('father', 'mother', 'guardian', 'emergency_contact') NOT NULL,
    is_primary_contact BOOLEAN DEFAULT FALSE,
    access_level ENUM('full', 'grades_only', 'attendance_only', 'emergency_only') DEFAULT 'full',
    authorized_by VARCHAR(100), -- 承認者
    authorized_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    UNIQUE KEY unique_primary_contact (student_id, relationship_type, is_primary_contact),
    INDEX idx_parent_username (parent_username),
    INDEX idx_student_id (student_id)
);

-- サンプル保護者関係データ
INSERT INTO parent_student_relationships (parent_username, student_id, relationship_type, is_primary_contact, authorized_by) VALUES
('parent_yamada@localhost', 301, 'father', TRUE, 'office_staff@localhost'),
('parent_tanaka@localhost', 302, 'mother', TRUE, 'office_staff@localhost'),
('parent_suzuki@localhost', 301, 'mother', FALSE, 'office_staff@localhost');

-- 2. 保護者専用セキュリティビュー
CREATE VIEW v_parent_student_info AS
SELECT 
    s.student_id,
    s.student_name,
    s.admission_date,
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade,
    psr.relationship_type,
    psr.access_level,
    -- 最新の成績情報（アクセスレベルに応じて）
    CASE 
        WHEN psr.access_level IN ('full', 'grades_only') THEN recent_grades.latest_average
        ELSE NULL
    END as latest_grade_average,
    -- 出席状況（アクセスレベルに応じて）
    CASE 
        WHEN psr.access_level IN ('full', 'attendance_only') THEN attendance_stats.attendance_rate
        ELSE NULL
    END as attendance_rate,
    CASE 
        WHEN psr.access_level IN ('full', 'attendance_only') THEN attendance_stats.recent_absences
        ELSE NULL
    END as recent_absences
FROM students s
JOIN parent_student_relationships psr ON s.student_id = psr.student_id
LEFT JOIN (
    SELECT 
        student_id,
        ROUND(AVG(score/max_score*100), 1) as latest_average
    FROM grades 
    WHERE submission_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    GROUP BY student_id
) recent_grades ON s.student_id = recent_grades.student_id
LEFT JOIN (
    SELECT 
        a.student_id,
        ROUND(COUNT(CASE WHEN a.status = 'present' THEN 1 END) * 100.0 / COUNT(*), 1) as attendance_rate,
        COUNT(CASE WHEN a.status = 'absent' THEN 1 END) as recent_absences
    FROM attendance a
    JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
    WHERE cs.schedule_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    GROUP BY a.student_id
) attendance_stats ON s.student_id = attendance_stats.student_id
WHERE psr.parent_username = USER()
AND psr.is_active = TRUE
AND (psr.expires_at IS NULL OR psr.expires_at > NOW());

-- 3. 保護者用アクセスプロシージャ
DELIMITER //

CREATE PROCEDURE parent_get_child_grades(
    IN p_student_id BIGINT
)
BEGIN
    DECLARE v_access_authorized BOOLEAN DEFAULT FALSE;
    DECLARE v_access_level VARCHAR(20);
    
    -- 保護者の子供へのアクセス権限を確認
    SELECT 
        COUNT(*) > 0,
        MAX(access_level)
    INTO v_access_authorized, v_access_level
    FROM parent_student_relationships psr
    WHERE psr.parent_username = USER()
    AND psr.student_id = p_student_id
    AND psr.is_active = TRUE
    AND (psr.expires_at IS NULL OR psr.expires_at > NOW())
    AND psr.access_level IN ('full', 'grades_only');
    
    IF NOT v_access_authorized THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: No authorization to view grades';
    END IF;
    
    -- 成績情報の取得（過去3ヶ月分）
    SELECT 
        g.course_id,
        c.course_name,
        g.grade_type,
        g.score,
        g.max_score,
        ROUND((g.score / g.max_score) * 100, 1) as percentage,
        g.submission_date
    FROM grades g
    JOIN courses c ON g.course_id = c.course_id
    WHERE g.student_id = p_student_id
    AND g.submission_date >= DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY)
    ORDER BY g.submission_date DESC, c.course_name;
    
END //

CREATE PROCEDURE parent_get_attendance_summary(
    IN p_student_id BIGINT
)
BEGIN
    DECLARE v_access_authorized BOOLEAN DEFAULT FALSE;
    
    -- 保護者の子供へのアクセス権限を確認
    SELECT COUNT(*) > 0 INTO v_access_authorized
    FROM parent_student_relationships psr
    WHERE psr.parent_username = USER()
    AND psr.student_id = p_student_id
    AND psr.is_active = TRUE
    AND (psr.expires_at IS NULL OR psr.expires_at > NOW())
    AND psr.access_level IN ('full', 'attendance_only');
    
    IF NOT v_access_authorized THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: No authorization to view attendance';
    END IF;
    
    -- 出席サマリーの取得（過去1ヶ月分）
    SELECT 
        cs.schedule_date,
        c.course_name,
        cp.start_time,
        cp.end_time,
        a.status,
        CASE a.status
            WHEN 'present' THEN '出席'
            WHEN 'absent' THEN '欠席'
            WHEN 'late' THEN '遅刻'
            ELSE '不明'
        END as status_japanese
    FROM attendance a
    JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
    JOIN courses c ON cs.course_id = c.course_id
    JOIN class_periods cp ON cs.period_id = cp.period_id
    WHERE a.student_id = p_student_id
    AND cs.schedule_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    ORDER BY cs.schedule_date DESC, cp.start_time;
    
END //

DELIMITER ;
```

## パフォーマンスとセキュリティの両立

### 1. インデックス戦略

```sql
-- セキュリティビューのパフォーマンス最適化

-- 1. セキュリティ制御用のインデックス作成
-- ユーザーコンテキストテーブル用
CREATE INDEX idx_user_context_username ON user_security_context (username);
CREATE INDEX idx_user_context_type_id ON user_security_context (user_type, associated_id);

-- 学生-講座関係の高速検索用
CREATE INDEX idx_student_courses_student ON student_courses (student_id, course_id);
CREATE INDEX idx_courses_teacher ON courses (teacher_id, course_id);

-- 成績テーブルの高速フィルタリング用
CREATE INDEX idx_grades_student_date ON grades (student_id, submission_date);
CREATE INDEX idx_grades_course_date ON grades (course_id, submission_date);

-- 出席テーブルの高速集計用
CREATE INDEX idx_attendance_student_status ON attendance (student_id, status);

-- 担任関係の高速検索用
CREATE INDEX idx_homeroom_teacher_active ON homeroom_assignments (teacher_id, is_active);

-- 保護者関係の高速検索用
CREATE INDEX idx_parent_relationships_active ON parent_student_relationships (parent_username, is_active);

-- 2. セキュリティビューのパフォーマンス分析
DELIMITER //

CREATE PROCEDURE analyze_security_view_performance()
BEGIN
    -- 各セキュリティビューの実行計画を分析
    SELECT 'Performance Analysis for Security Views' as analysis_title;
    
    -- 教師学生ビューの分析
    EXPLAIN FORMAT=JSON 
    SELECT * FROM v_teacher_students LIMIT 1;
    
    -- 学生専用ビューの分析
    EXPLAIN FORMAT=JSON 
    SELECT * FROM v_student_own_grades LIMIT 1;
    
    -- 担任ビューの分析
    EXPLAIN FORMAT=JSON 
    SELECT * FROM v_homeroom_teacher_comprehensive LIMIT 1;
    
END //

DELIMITER ;

-- 3. キャッシュ機能付きセキュリティプロシージャ
CREATE TABLE security_cache (
    cache_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cache_key VARCHAR(255) NOT NULL,
    cache_data JSON NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    
    UNIQUE KEY unique_cache_key (cache_key),
    INDEX idx_expires_at (expires_at)
);

DELIMITER //

CREATE PROCEDURE cached_secure_get_student_grades(
    IN p_student_id BIGINT,
    IN p_cache_minutes INT DEFAULT 15
)
BEGIN
    DECLARE v_cache_key VARCHAR(255);
    DECLARE v_cached_data JSON;
    DECLARE v_cache_expires TIMESTAMP;
    
    SET v_cache_key = CONCAT('student_grades_', p_student_id, '_', USER());
    
    -- キャッシュの確認
    SELECT cache_data, expires_at INTO v_cached_data, v_cache_expires
    FROM security_cache
    WHERE cache_key = v_cache_key
    AND expires_at > NOW();
    
    IF v_cached_data IS NOT NULL THEN
        -- キャッシュからデータを返す
        SELECT 
            JSON_UNQUOTE(JSON_EXTRACT(item, '$.course_name')) as course_name,
            JSON_UNQUOTE(JSON_EXTRACT(item, '$.grade_type')) as grade_type,
            CAST(JSON_UNQUOTE(JSON_EXTRACT(item, '$.score')) AS DECIMAL(5,2)) as score,
            JSON_UNQUOTE(JSON_EXTRACT(item, '$.submission_date')) as submission_date
        FROM JSON_TABLE(v_cached_data, '$[*]' COLUMNS (
            item JSON PATH '$'
        )) as cached_grades;
    ELSE
        -- データベースから取得してキャッシュに保存
        DROP TEMPORARY TABLE IF EXISTS temp_grades;
        CREATE TEMPORARY TABLE temp_grades AS
        SELECT 
            c.course_name,
            g.grade_type,
            g.score,
            g.submission_date
        FROM grades g
        JOIN courses c ON g.course_id = c.course_id
        WHERE g.student_id = p_student_id
        AND (
            USER() = 'root'
            OR CONCAT('student_', g.student_id) = SUBSTRING_INDEX(USER(), '@', 1)
            OR EXISTS (
                SELECT 1 FROM courses c2 
                JOIN teachers t ON c2.teacher_id = t.teacher_id 
                WHERE c2.course_id = g.course_id 
                AND t.teacher_name = USER()
            )
        );
        
        -- 結果をキャッシュに保存
        SET v_cached_data = (
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'course_name', course_name,
                    'grade_type', grade_type,
                    'score', score,
                    'submission_date', submission_date
                )
            )
            FROM temp_grades
        );
        
        INSERT INTO security_cache (cache_key, cache_data, created_by, expires_at)
        VALUES (v_cache_key, v_cached_data, USER(), DATE_ADD(NOW(), INTERVAL p_cache_minutes MINUTE))
        ON DUPLICATE KEY UPDATE
            cache_data = v_cached_data,
            expires_at = DATE_ADD(NOW(), INTERVAL p_cache_minutes MINUTE);
        
        -- 結果を返す
        SELECT * FROM temp_grades;
    END IF;
    
END //

DELIMITER ;
```

### 2. セキュリティとパフォーマンスの監視

```sql
-- セキュリティアクセスの監視システム

-- 1. アクセスログテーブル
CREATE TABLE security_access_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    access_type ENUM('VIEW', 'PROCEDURE', 'DIRECT') NOT NULL,
    target_object VARCHAR(100) NOT NULL,
    target_student_id BIGINT,
    access_granted BOOLEAN NOT NULL,
    execution_time_ms INT,
    rows_accessed INT,
    access_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_agent VARCHAR(500),
    ip_address VARCHAR(45),
    
    INDEX idx_username_timestamp (username, access_timestamp),
    INDEX idx_target_student (target_student_id, access_timestamp),
    INDEX idx_access_granted (access_granted, access_timestamp)
);

-- 2. アクセス監視プロシージャ
DELIMITER //

CREATE PROCEDURE log_security_access(
    IN p_access_type ENUM('VIEW', 'PROCEDURE', 'DIRECT'),
    IN p_target_object VARCHAR(100),
    IN p_target_student_id BIGINT,
    IN p_access_granted BOOLEAN,
    IN p_execution_time_ms INT,
    IN p_rows_accessed INT
)
BEGIN
    INSERT INTO security_access_log 
        (username, access_type, target_object, target_student_id, 
         access_granted, execution_time_ms, rows_accessed)
    VALUES 
        (USER(), p_access_type, p_target_object, p_target_student_id,
         p_access_granted, p_execution_time_ms, p_rows_accessed);
END //

-- 3. セキュリティ異常検知
CREATE PROCEDURE detect_security_anomalies()
BEGIN
    -- 異常なアクセスパターンの検知
    
    -- 1. 短時間での大量アクセス
    SELECT 'High Frequency Access Detected' as alert_type,
           username,
           COUNT(*) as access_count,
           MIN(access_timestamp) as start_time,
           MAX(access_timestamp) as end_time
    FROM security_access_log
    WHERE access_timestamp >= DATE_SUB(NOW(), INTERVAL 5 MINUTE)
    GROUP BY username
    HAVING COUNT(*) > 100;
    
    -- 2. 通常と異なる時間帯のアクセス
    SELECT 'Off-Hours Access Detected' as alert_type,
           username,
           target_object,
           access_timestamp,
           HOUR(access_timestamp) as access_hour
    FROM security_access_log
    WHERE access_timestamp >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
    AND (HOUR(access_timestamp) < 6 OR HOUR(access_timestamp) > 22)
    AND username NOT LIKE '%admin%'
    AND username != 'root';
    
    -- 3. アクセス拒否の集中
    SELECT 'Access Denial Spike Detected' as alert_type,
           username,
           COUNT(*) as denial_count,
           GROUP_CONCAT(DISTINCT target_object) as attempted_objects
    FROM security_access_log
    WHERE access_timestamp >= DATE_SUB(NOW(), INTERVAL 15 MINUTE)
    AND access_granted = FALSE
    GROUP BY username
    HAVING COUNT(*) > 10;
    
    -- 4. 学生IDの広範囲スキャン
    SELECT 'Student ID Scanning Detected' as alert_type,
           username,
           COUNT(DISTINCT target_student_id) as unique_students_accessed,
           COUNT(*) as total_attempts
    FROM security_access_log
    WHERE access_timestamp >= DATE_SUB(NOW(), INTERVAL 10 MINUTE)
    AND target_student_id IS NOT NULL
    GROUP BY username
    HAVING COUNT(DISTINCT target_student_id) > 20;
    
END //

DELIMITER ;

-- 4. パフォーマンス最適化レポート
CREATE PROCEDURE generate_security_performance_report()
BEGIN
    -- セキュリティ機能のパフォーマンス分析
    
    SELECT 'Security Performance Summary' as report_section;
    
    -- 平均実行時間
    SELECT 
        target_object,
        access_type,
        COUNT(*) as access_count,
        AVG(execution_time_ms) as avg_execution_time,
        MAX(execution_time_ms) as max_execution_time,
        AVG(rows_accessed) as avg_rows_accessed
    FROM security_access_log
    WHERE access_timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
    AND access_granted = TRUE
    GROUP BY target_object, access_type
    ORDER BY avg_execution_time DESC;
    
    -- キャッシュ効率
    SELECT 
        'Cache Performance' as metric,
        COUNT(CASE WHEN cache_key IS NOT NULL THEN 1 END) as cache_hits,
        COUNT(*) as total_requests,
        ROUND(COUNT(CASE WHEN cache_key IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) as cache_hit_rate
    FROM security_access_log sal
    LEFT JOIN security_cache sc ON CONCAT('student_grades_', sal.target_student_id, '_', sal.username) = sc.cache_key
    WHERE sal.access_timestamp >= DATE_SUB(NOW(), INTERVAL 1 HOUR);
    
END //

DELIMITER ;
```

## 練習問題

### 問題41-1：基本的なセキュリティビューの作成
学校システムに以下の要件でセキュリティビューを作成してください：
1. `v_counselor_student_info`：カウンセラー用ビュー
   - カウンセラーは全学生の基本情報を閲覧可能
   - ただし、個人的な連絡先情報（メールアドレス）は除外
   - 現在の学年と入学年度を表示
2. `v_librarian_student_basic`：図書館司書用ビュー
   - 図書館司書は学生の基本情報のみ閲覧可能
   - 学籍番号、氏名、学年のみ表示
   - 休学・退学者は除外
3. 各ビューに適切な権限を設定し、動作確認を行ってください

### 問題41-2：動的セキュリティプロシージャの実装
以下の要件でセキュリティプロシージャを作成してください：
1. `secure_get_class_roster(class_identifier)`
   - クラス担任のみが担当クラスの名簿を取得可能
   - 学生の基本情報、最新の出席率、平均成績を含む
   - 非担任からのアクセスは拒否
2. `secure_update_attendance(student_id, schedule_id, status)`
   - 教師のみが担当講座の出席を更新可能
   - 担当外の講座への更新は拒否
   - 更新履歴をログに記録
3. エラーハンドリングとアクセスログ機能を含めてください

### 問題41-3：多階層セキュリティシステム
以下の階層的なアクセス制御システムを実装してください：
1. **レベル1（学生）**：自分の情報のみアクセス
2. **レベル2（教師）**：担当講座の学生情報にアクセス
3. **レベル3（学年主任）**：担当学年の全学生情報にアクセス
4. **レベル4（教務主任）**：全学年の学生情報にアクセス
5. **レベル5（校長）**：全ての情報にアクセス

各レベルで適切なビューとプロシージャを作成し、権限設定を行ってください。

### 問題41-4：時間制限付きアクセス制御
以下の時間制限機能を実装してください：
1. **平常時間制限**：
   - 学生：平日8:00-18:00のみアクセス可能
   - 教師：平日7:00-20:00のみアクセス可能
   - 管理職：時間制限なし
2. **定期試験期間制限**：
   - 学生の成績閲覧を一時的に制限
   - 教師の成績入力期間を限定
3. **緊急時アクセス**：
   - 緊急連絡先登録者は24時間アクセス可能
4. 時間制限の管理テーブルと制御プロシージャを作成してください

### 問題41-5：保護者アクセスシステムの拡張
以下の機能を持つ保護者システムを実装してください：
1. **段階的アクセス権限**：
   - フルアクセス（成績・出席・健康情報）
   - 制限アクセス（出席情報のみ）
   - 緊急時のみ（緊急連絡情報のみ）
2. **通知機能**：
   - 子供の出席状況に問題がある場合の自動通知
   - 成績変動の通知
3. **アクセス履歴管理**：
   - 保護者のアクセス履歴を記録
   - 異常なアクセスパターンの検知
4. **承認ワークフロー**：
   - 保護者アカウントの新規作成・変更に承認プロセス

### 問題41-6：総合セキュリティシステム
学校全体の包括的な行レベルセキュリティシステムを設計・実装してください：
1. **ユーザー管理**：
   - 動的なユーザーコンテキスト管理
   - 役職変更時の自動権限更新
   - 一時的な権限委譲機能
2. **データアクセス制御**：
   - 全テーブルに対する行レベル制御
   - 動的なフィルタリング条件
   - カスタムアクセスポリシー
3. **監査・ログ機能**：
   - 全アクセスの記録
   - 異常検知機能
   - コンプライアンスレポート生成
4. **パフォーマンス最適化**：
   - セキュリティキャッシュ機能
   - インデックス最適化
   - 実行計画の分析・改善

## 解答

### 解答41-1
```sql
-- 基本的なセキュリティビューの作成

-- 1. カウンセラー用ビューの作成
CREATE VIEW v_counselor_student_info AS
SELECT 
    s.student_id,
    s.student_name,
    s.admission_date,
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade,
    YEAR(s.admission_date) as admission_year,
    -- メールアドレスは除外してセキュリティを確保
    'カウンセラー権限では非表示' as email_status,
    -- 在籍状況の判定
    CASE 
        WHEN YEAR(CURRENT_DATE) - YEAR(s.admission_date) >= 3 THEN '卒業予定'
        WHEN YEAR(CURRENT_DATE) - YEAR(s.admission_date) >= 2 THEN '3年生'
        WHEN YEAR(CURRENT_DATE) - YEAR(s.admission_date) >= 1 THEN '2年生'
        ELSE '1年生'
    END as student_status
FROM students s
WHERE (
    USER() LIKE '%counselor%' 
    OR USER() LIKE '%カウンセラー%'
    OR USER() = 'root'
    OR USER() LIKE '%principal%'
);

-- 2. 図書館司書用ビューの作成
CREATE VIEW v_librarian_student_basic AS
SELECT 
    s.student_id,
    s.student_name,
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade
FROM students s
WHERE (
    -- 在籍中の学生のみ（休学・退学者は除外）
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) < 3
    AND (
        USER() LIKE '%librarian%' 
        OR USER() LIKE '%図書%'
        OR USER() = 'root'
        OR USER() LIKE '%principal%'
    )
);

-- 3. 権限設定

-- カウンセラーロールが存在しない場合は作成
CREATE ROLE IF NOT EXISTS 'counselor_role';
CREATE ROLE IF NOT EXISTS 'librarian_role';

-- カウンセラー用ビューの権限付与
GRANT SELECT ON school_db.v_counselor_student_info TO 'counselor_role';

-- 図書館司書用ビューの権限付与
GRANT SELECT ON school_db.v_librarian_student_basic TO 'librarian_role';

-- 4. テスト用ユーザーの作成（実際の運用では管理者が実行）
-- CREATE USER 'counselor_test'@'localhost' IDENTIFIED BY 'Counselor2025!';
-- CREATE USER 'librarian_test'@'localhost' IDENTIFIED BY 'Librarian2025!';
-- GRANT 'counselor_role' TO 'counselor_test'@'localhost';
-- GRANT 'librarian_role' TO 'librarian_test'@'localhost';
-- ALTER USER 'counselor_test'@'localhost' DEFAULT ROLE ALL;
-- ALTER USER 'librarian_test'@'localhost' DEFAULT ROLE ALL;

-- 5. 動作確認用クエリ

-- ビューの構造確認
DESCRIBE v_counselor_student_info;
DESCRIBE v_librarian_student_basic;

-- データ確認（管理者として）
SELECT 'Counselor View Sample:' as test_type;
SELECT * FROM v_counselor_student_info LIMIT 5;

SELECT 'Librarian View Sample:' as test_type;
SELECT * FROM v_librarian_student_basic LIMIT 5;

-- 権限確認
SELECT 
    table_name,
    grantee,
    privilege_type
FROM information_schema.table_privileges
WHERE table_schema = 'school_db'
AND table_name IN ('v_counselor_student_info', 'v_librarian_student_basic')
ORDER BY table_name, grantee;

-- ビューが正しくフィルタリングしているかテスト
SELECT 
    'View Security Test' as test_type,
    COUNT(*) as total_students_in_base_table
FROM students;

SELECT 
    'Counselor View Count' as test_type,
    COUNT(*) as visible_students
FROM v_counselor_student_info;

SELECT 
    'Librarian View Count' as test_type,
    COUNT(*) as visible_students
FROM v_librarian_student_basic;

-- カウンセラービューでメール情報が除外されているか確認
SELECT DISTINCT email_status FROM v_counselor_student_info;
```

### 解答41-2
```sql
-- 動的セキュリティプロシージャの実装

-- 1. 前提テーブルの確認・作成
-- クラス情報を管理するテーブル（存在しない場合）
CREATE TABLE IF NOT EXISTS class_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id BIGINT NOT NULL,
    class_name VARCHAR(50) NOT NULL,
    grade_level INT NOT NULL,
    academic_year YEAR NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    INDEX idx_teacher_active (teacher_id, is_active)
);

-- サンプルクラス割当データ
INSERT IGNORE INTO class_assignments (teacher_id, class_name, grade_level, academic_year) VALUES
(101, '1年A組', 1, 2025),
(102, '2年B組', 2, 2025);

-- アクセスログテーブル（存在しない場合）
CREATE TABLE IF NOT EXISTS security_procedure_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    procedure_name VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL,
    parameters JSON,
    access_granted BOOLEAN NOT NULL,
    execution_time_ms INT,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_procedure_user (procedure_name, username),
    INDEX idx_created_at (created_at)
);

-- 2. クラス名簿取得プロシージャ
DELIMITER //

CREATE PROCEDURE secure_get_class_roster(
    IN p_class_identifier VARCHAR(50)
)
BEGIN
    DECLARE v_start_time TIMESTAMP DEFAULT NOW(6);
    DECLARE v_teacher_id BIGINT;
    DECLARE v_class_authorized BOOLEAN DEFAULT FALSE;
    DECLARE v_execution_time INT;
    DECLARE v_error_msg TEXT DEFAULT NULL;
    
    -- 現在のユーザーが教師かどうかを確認
    SELECT teacher_id INTO v_teacher_id
    FROM teachers 
    WHERE teacher_name = USER()
    LIMIT 1;
    
    IF v_teacher_id IS NULL AND USER() != 'root' THEN
        SET v_error_msg = 'Access denied: User is not a registered teacher';
        SET v_execution_time = TIMESTAMPDIFF(MICROSECOND, v_start_time, NOW(6)) / 1000;
        
        INSERT INTO security_procedure_log 
            (procedure_name, username, parameters, access_granted, execution_time_ms, error_message)
        VALUES 
            ('secure_get_class_roster', USER(), JSON_OBJECT('class_identifier', p_class_identifier), 
             FALSE, v_execution_time, v_error_msg);
        
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;
    
    -- 担当クラスかどうかを確認
    SELECT COUNT(*) > 0 INTO v_class_authorized
    FROM class_assignments ca
    WHERE ca.teacher_id = v_teacher_id
    AND ca.class_name = p_class_identifier
    AND ca.is_active = TRUE;
    
    IF NOT v_class_authorized AND USER() != 'root' THEN
        SET v_error_msg = CONCAT('Access denied: Not authorized for class ', p_class_identifier);
        SET v_execution_time = TIMESTAMPDIFF(MICROSECOND, v_start_time, NOW(6)) / 1000;
        
        INSERT INTO security_procedure_log 
            (procedure_name, username, parameters, access_granted, execution_time_ms, error_message)
        VALUES 
            ('secure_get_class_roster', USER(), JSON_OBJECT('class_identifier', p_class_identifier), 
             FALSE, v_execution_time, v_error_msg);
        
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;
    
    -- クラスの名簿と統計情報を取得
    SELECT 
        s.student_id,
        s.student_name,
        s.student_email,
        s.admission_date,
        ca.class_name,
        ca.grade_level,
        -- 最新の出席率（過去30日）
        COALESCE(attendance_stats.attendance_rate, 0) as attendance_rate_30days,
        COALESCE(attendance_stats.total_classes, 0) as total_classes_30days,
        -- 平均成績（過去30日）
        COALESCE(grade_stats.average_score, 0) as average_score_30days,
        COALESCE(grade_stats.grade_count, 0) as grade_count_30days
    FROM students s
    CROSS JOIN class_assignments ca
    LEFT JOIN (
        SELECT 
            a.student_id,
            ROUND(COUNT(CASE WHEN a.status = 'present' THEN 1 END) * 100.0 / COUNT(*), 1) as attendance_rate,
            COUNT(*) as total_classes
        FROM attendance a
        JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
        WHERE cs.schedule_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
        GROUP BY a.student_id
    ) attendance_stats ON s.student_id = attendance_stats.student_id
    LEFT JOIN (
        SELECT 
            g.student_id,
            ROUND(AVG(g.score / g.max_score * 100), 1) as average_score,
            COUNT(*) as grade_count
        FROM grades g
        WHERE g.submission_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
        GROUP BY g.student_id
    ) grade_stats ON s.student_id = grade_stats.student_id
    WHERE ca.teacher_id = v_teacher_id
    AND ca.class_name = p_class_identifier
    AND ca.is_active = TRUE
    AND YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 = ca.grade_level
    ORDER BY s.student_name;
    
    -- 成功ログの記録
    SET v_execution_time = TIMESTAMPDIFF(MICROSECOND, v_start_time, NOW(6)) / 1000;
    INSERT INTO security_procedure_log 
        (procedure_name, username, parameters, access_granted, execution_time_ms)
    VALUES 
        ('secure_get_class_roster', USER(), JSON_OBJECT('class_identifier', p_class_identifier), 
         TRUE, v_execution_time);
    
END //

-- 3. 出席情報安全更新プロシージャ
CREATE PROCEDURE secure_update_attendance(
    IN p_student_id BIGINT,
    IN p_schedule_id BIGINT,
    IN p_status ENUM('present', 'absent', 'late')
)
BEGIN
    DECLARE v_start_time TIMESTAMP DEFAULT NOW(6);
    DECLARE v_teacher_id BIGINT;
    DECLARE v_course_authorized BOOLEAN DEFAULT FALSE;
    DECLARE v_execution_time INT;
    DECLARE v_error_msg TEXT DEFAULT NULL;
    DECLARE v_course_id VARCHAR(16);
    
    -- 現在のユーザーが教師かどうかを確認
    SELECT teacher_id INTO v_teacher_id
    FROM teachers 
    WHERE teacher_name = USER()
    LIMIT 1;
    
    IF v_teacher_id IS NULL AND USER() != 'root' THEN
        SET v_error_msg = 'Access denied: User is not a registered teacher';
        SET v_execution_time = TIMESTAMPDIFF(MICROSECOND, v_start_time, NOW(6)) / 1000;
        
        INSERT INTO security_procedure_log 
            (procedure_name, username, parameters, access_granted, execution_time_ms, error_message)
        VALUES 
            ('secure_update_attendance', USER(), 
             JSON_OBJECT('student_id', p_student_id, 'schedule_id', p_schedule_id, 'status', p_status), 
             FALSE, v_execution_time, v_error_msg);
        
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;
    
    -- スケジュールIDから講座IDを取得し、担当教師かどうかを確認
    SELECT cs.course_id INTO v_course_id
    FROM course_schedule cs
    WHERE cs.schedule_id = p_schedule_id;
    
    IF v_course_id IS NULL THEN
        SET v_error_msg = 'Invalid schedule ID';
        SET v_execution_time = TIMESTAMPDIFF(MICROSECOND, v_start_time, NOW(6)) / 1000;
        
        INSERT INTO security_procedure_log 
            (procedure_name, username, parameters, access_granted, execution_time_ms, error_message)
        VALUES 
            ('secure_update_attendance', USER(), 
             JSON_OBJECT('student_id', p_student_id, 'schedule_id', p_schedule_id, 'status', p_status), 
             FALSE, v_execution_time, v_error_msg);
        
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;
    
    -- 担当講座かどうかを確認
    SELECT COUNT(*) > 0 INTO v_course_authorized
    FROM courses c
    WHERE c.course_id = v_course_id
    AND c.teacher_id = v_teacher_id;
    
    IF NOT v_course_authorized AND USER() != 'root' THEN
        SET v_error_msg = CONCAT('Access denied: Not authorized for course ', v_course_id);
        SET v_execution_time = TIMESTAMPDIFF(MICROSECOND, v_start_time, NOW(6)) / 1000;
        
        INSERT INTO security_procedure_log 
            (procedure_name, username, parameters, access_granted, execution_time_ms, error_message)
        VALUES 
            ('secure_update_attendance', USER(), 
             JSON_OBJECT('student_id', p_student_id, 'schedule_id', p_schedule_id, 'status', p_status), 
             FALSE, v_execution_time, v_error_msg);
        
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;
    
    -- 出席情報の更新
    INSERT INTO attendance (schedule_id, student_id, status)
    VALUES (p_schedule_id, p_student_id, p_status)
    ON DUPLICATE KEY UPDATE
        status = p_status;
    
    -- 成功ログの記録
    SET v_execution_time = TIMESTAMPDIFF(MICROSECOND, v_start_time, NOW(6)) / 1000;
    INSERT INTO security_procedure_log 
        (procedure_name, username, parameters, access_granted, execution_time_ms)
    VALUES 
        ('secure_update_attendance', USER(), 
         JSON_OBJECT('student_id', p_student_id, 'schedule_id', p_schedule_id, 'status', p_status), 
         TRUE, v_execution_time);
    
    -- 更新履歴を別途記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('UPDATE', CONCAT('student_', p_student_id), 'system', 'attendance_update', USER(),
            CONCAT('Updated attendance for schedule ', p_schedule_id, ' to: ', p_status));
    
    SELECT CONCAT('Attendance updated successfully for student ', p_student_id) as result;
    
END //

DELIMITER ;

-- 4. テスト実行（管理者として）

-- プロシージャの動作テスト
-- CALL secure_get_class_roster('1年A組');
-- CALL secure_update_attendance(301, 1, 'present');

-- ログの確認
SELECT 
    procedure_name,
    username,
    access_granted,
    execution_time_ms,
    created_at,
    error_message
FROM security_procedure_log
ORDER BY created_at DESC
LIMIT 10;

-- エラーケースのテスト用クエリ（実際には適切なユーザーで実行）
-- 存在しないクラスでのテスト
-- CALL secure_get_class_roster('存在しないクラス');

-- 権限のないスケジュールでの出席更新テスト
-- CALL secure_update_attendance(999, 999, 'present');
```

### 解答41-3
```sql
-- 多階層セキュリティシステムの実装

-- 1. ユーザー階層定義テーブル
CREATE TABLE user_access_levels (
    level_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    access_level INT NOT NULL, -- 1=学生, 2=教師, 3=学年主任, 4=教務主任, 5=校長
    level_name VARCHAR(50) NOT NULL,
    associated_id BIGINT, -- 学生ID、教師ID等
    grade_restriction INT, -- 学年主任の場合の担当学年
    department_restriction VARCHAR(100), -- 部署制限
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_username (username),
    INDEX idx_access_level (access_level),
    INDEX idx_active (is_active)
);

-- サンプル階層データ
INSERT INTO user_access_levels (username, access_level, level_name, associated_id, grade_restriction) VALUES
('student_301@localhost', 1, '学生', 301, NULL),
('student_302@localhost', 1, '学生', 302, NULL),
('teacher_tanaka@localhost', 2, '教師', 101, NULL),
('teacher_sato@localhost', 2, '教師', 102, NULL),
('grade_head_1@localhost', 3, '学年主任', 103, 1),
('grade_head_2@localhost', 3, '学年主任', 104, 2),
('academic_director@localhost', 4, '教務主任', 105, NULL),
('principal@localhost', 5, '校長', 106, NULL);

-- 2. 階層別セキュリティビュー

-- レベル1: 学生専用ビュー（自分の情報のみ）
CREATE VIEW v_level1_student_own AS
SELECT 
    s.student_id,
    s.student_name,
    s.student_email,
    s.admission_date,
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade,
    'レベル1アクセス' as access_level_info
FROM students s
JOIN user_access_levels ual ON ual.associated_id = s.student_id
WHERE ual.username = USER()
AND ual.access_level = 1
AND ual.is_active = TRUE;

-- レベル2: 教師ビュー（担当講座の学生）
CREATE VIEW v_level2_teacher_students AS
SELECT 
    s.student_id,
    s.student_name,
    s.student_email,
    s.admission_date,
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade,
    c.course_id,
    c.course_name,
    'レベル2アクセス' as access_level_info
FROM students s
JOIN student_courses sc ON s.student_id = sc.student_id
JOIN courses c ON sc.course_id = c.course_id
JOIN user_access_levels ual ON ual.associated_id = c.teacher_id
WHERE ual.username = USER()
AND ual.access_level = 2
AND ual.is_active = TRUE;

-- レベル3: 学年主任ビュー（担当学年の学生）
CREATE VIEW v_level3_grade_supervisor AS
SELECT 
    s.student_id,
    s.student_name,
    s.student_email,
    s.admission_date,
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade,
    'レベル3アクセス' as access_level_info
FROM students s
JOIN user_access_levels ual ON ual.username = USER()
WHERE ual.access_level = 3
AND ual.is_active = TRUE
AND YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 = ual.grade_restriction;

-- レベル4: 教務主任ビュー（全学年の学生）
CREATE VIEW v_level4_academic_director AS
SELECT 
    s.student_id,
    s.student_name,
    s.student_email,
    s.admission_date,
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade,
    'レベル4アクセス' as access_level_info
FROM students s
WHERE EXISTS (
    SELECT 1 FROM user_access_levels ual 
    WHERE ual.username = USER()
    AND ual.access_level = 4
    AND ual.is_active = TRUE
);

-- レベル5: 校長ビュー（全ての情報）
CREATE VIEW v_level5_principal AS
SELECT 
    s.student_id,
    s.student_name,
    s.student_email,
    s.admission_date,
    YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade,
    'レベル5アクセス' as access_level_info,
    -- 追加情報
    COUNT(DISTINCT sc.course_id) as enrolled_courses,
    AVG(g.score/g.max_score*100) as overall_average
FROM students s
LEFT JOIN student_courses sc ON s.student_id = sc.student_id
LEFT JOIN grades g ON s.student_id = g.student_id
WHERE EXISTS (
    SELECT 1 FROM user_access_levels ual 
    WHERE ual.username = USER()
    AND ual.access_level = 5
    AND ual.is_active = TRUE
)
GROUP BY s.student_id, s.student_name, s.student_email, s.admission_date;

-- 3. 統合アクセス制御プロシージャ
DELIMITER //

CREATE PROCEDURE get_accessible_student_info(
    IN p_student_id BIGINT DEFAULT NULL
)
BEGIN
    DECLARE v_access_level INT;
    DECLARE v_associated_id BIGINT;
    DECLARE v_grade_restriction INT;
    
    -- ユーザーのアクセスレベルを取得
    SELECT access_level, associated_id, grade_restriction
    INTO v_access_level, v_associated_id, v_grade_restriction
    FROM user_access_levels
    WHERE username = USER()
    AND is_active = TRUE;
    
    -- アクセスレベルが見つからない場合
    IF v_access_level IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: User not registered in access control system';
    END IF;
    
    -- アクセスレベルに応じた処理
    CASE v_access_level
        WHEN 1 THEN -- 学生
            IF p_student_id IS NOT NULL AND p_student_id != v_associated_id THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Level 1 Access: Can only view own information';
            END IF;
            SELECT * FROM v_level1_student_own
            WHERE (p_student_id IS NULL OR student_id = p_student_id);
            
        WHEN 2 THEN -- 教師
            SELECT * FROM v_level2_teacher_students
            WHERE (p_student_id IS NULL OR student_id = p_student_id);
            
        WHEN 3 THEN -- 学年主任
            SELECT * FROM v_level3_grade_supervisor
            WHERE (p_student_id IS NULL OR student_id = p_student_id);
            
        WHEN 4 THEN -- 教務主任
            SELECT * FROM v_level4_academic_director
            WHERE (p_student_id IS NULL OR student_id = p_student_id);
            
        WHEN 5 THEN -- 校長
            SELECT * FROM v_level5_principal
            WHERE (p_student_id IS NULL OR student_id = p_student_id);
            
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid access level';
    END CASE;
    
    -- アクセスログの記録
    INSERT INTO security_procedure_log 
        (procedure_name, username, parameters, access_granted, execution_time_ms)
    VALUES 
        ('get_accessible_student_info', USER(), 
         JSON_OBJECT('student_id', p_student_id, 'access_level', v_access_level), 
         TRUE, 0);
    
END //

-- 4. 階層権限チェック関数
CREATE FUNCTION check_hierarchical_access(
    p_target_student_id BIGINT,
    p_required_level INT
) RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_user_level INT;
    DECLARE v_associated_id BIGINT;
    DECLARE v_grade_restriction INT;
    DECLARE v_student_grade INT;
    DECLARE v_has_access BOOLEAN DEFAULT FALSE;
    
    -- ユーザーのアクセスレベルを取得
    SELECT access_level, associated_id, grade_restriction
    INTO v_user_level, v_associated_id, v_grade_restriction
    FROM user_access_levels
    WHERE username = USER()
    AND is_active = TRUE;
    
    -- アクセスレベルが要求レベル以上かチェック
    IF v_user_level >= p_required_level THEN
        CASE v_user_level
            WHEN 1 THEN -- 学生：自分の情報のみ
                SET v_has_access = (p_target_student_id = v_associated_id);
            WHEN 2 THEN -- 教師：担当講座の学生のみ
                SELECT COUNT(*) > 0 INTO v_has_access
                FROM student_courses sc
                JOIN courses c ON sc.course_id = c.course_id
                WHERE sc.student_id = p_target_student_id
                AND c.teacher_id = v_associated_id;
            WHEN 3 THEN -- 学年主任：担当学年の学生のみ
                SELECT YEAR(CURRENT_DATE) - YEAR(admission_date) + 1 INTO v_student_grade
                FROM students WHERE student_id = p_target_student_id;
                SET v_has_access = (v_student_grade = v_grade_restriction);
            WHEN 4, 5 THEN -- 教務主任、校長：全アクセス
                SET v_has_access = TRUE;
        END CASE;
    END IF;
    
    RETURN v_has_access;
END //

DELIMITER ;

-- 5. 権限設定
-- 各レベルのロールに対応するビューの権限を設定
CREATE ROLE IF NOT EXISTS 'level1_student_role';
CREATE ROLE IF NOT EXISTS 'level2_teacher_role';
CREATE ROLE IF NOT EXISTS 'level3_grade_supervisor_role';
CREATE ROLE IF NOT EXISTS 'level4_academic_director_role';
CREATE ROLE IF NOT EXISTS 'level5_principal_role';

-- 各レベルのビューに権限付与
GRANT SELECT ON school_db.v_level1_student_own TO 'level1_student_role';
GRANT SELECT ON school_db.v_level2_teacher_students TO 'level2_teacher_role';
GRANT SELECT ON school_db.v_level3_grade_supervisor TO 'level3_grade_supervisor_role';
GRANT SELECT ON school_db.v_level4_academic_director TO 'level4_academic_director_role';
GRANT SELECT ON school_db.v_level5_principal TO 'level5_principal_role';

-- プロシージャの実行権限
GRANT EXECUTE ON PROCEDURE school_db.get_accessible_student_info TO 'level1_student_role';
GRANT EXECUTE ON PROCEDURE school_db.get_accessible_student_info TO 'level2_teacher_role';
GRANT EXECUTE ON PROCEDURE school_db.get_accessible_student_info TO 'level3_grade_supervisor_role';
GRANT EXECUTE ON PROCEDURE school_db.get_accessible_student_info TO 'level4_academic_director_role';
GRANT EXECUTE ON PROCEDURE school_db.get_accessible_student_info TO 'level5_principal_role';

-- 6. テスト実行例

-- 各レベルでのアクセステスト
SELECT 'Level 1 Test (Student Own Info):' as test_type;
-- CALL get_accessible_student_info(301);

SELECT 'Level 2 Test (Teacher Students):' as test_type;
-- CALL get_accessible_student_info(NULL);

-- 階層権限チェック関数のテスト
SELECT 
    'Hierarchical Access Check Results' as test_type,
    301 as student_id,
    check_hierarchical_access(301, 1) as level1_access,
    check_hierarchical_access(301, 2) as level2_access,
    check_hierarchical_access(301, 3) as level3_access;

-- アクセスレベル確認
SELECT 
    username,
    access_level,
    level_name,
    associated_id,
    grade_restriction
FROM user_access_levels
WHERE is_active = TRUE
ORDER BY access_level, username;
```

### 解答41-4
```sql
-- 時間制限付きアクセス制御の実装

-- 1. 時間制限管理テーブル
CREATE TABLE time_access_policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_name VARCHAR(100) NOT NULL,
    user_type ENUM('student', 'teacher', 'admin', 'emergency') NOT NULL,
    allowed_days JSON, -- [1,2,3,4,5] (月-金)
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_type (user_type),
    INDEX idx_active (is_active)
);

-- 基本的な時間制限ポリシー
INSERT INTO time_access_policies (policy_name, user_type, allowed_days, start_time, end_time) VALUES
('学生平常時間', 'student', JSON_ARRAY(2,3,4,5,6), '08:00:00', '18:00:00'),
('教師平常時間', 'teacher', JSON_ARRAY(2,3,4,5,6), '07:00:00', '20:00:00'),
('管理者時間', 'admin', JSON_ARRAY(1,2,3,4,5,6,7), '00:00:00', '23:59:59'),
('緊急時アクセス', 'emergency', JSON_ARRAY(1,2,3,4,5,6,7), '00:00:00', '23:59:59');

-- 2. 特別期間管理テーブル
CREATE TABLE special_access_periods (
    period_id INT AUTO_INCREMENT PRIMARY KEY,
    period_name VARCHAR(100) NOT NULL,
    period_type ENUM('exam', 'maintenance', 'emergency', 'holiday') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    access_modifications JSON, -- 特別期間中のアクセス変更ルール
    is_active BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_period_dates (start_date, end_date),
    INDEX idx_period_type (period_type)
);

-- 定期試験期間の設定例
INSERT INTO special_access_periods (period_name, period_type, start_date, end_date, access_modifications, created_by) VALUES
('2025年度第1回定期試験', 'exam', '2025-07-01', '2025-07-15', 
 JSON_OBJECT(
     'student_grade_access', false,
     'teacher_grade_input_only', true,
     'extended_teacher_hours', JSON_OBJECT('start_time', '06:00:00', 'end_time', '22:00:00')
 ), 
 'admin'),
('夏季休暇期間', 'holiday', '2025-08-01', '2025-08-31',
 JSON_OBJECT(
     'student_access', false,
     'teacher_limited', true,
     'admin_maintenance', true
 ),
 'admin');

-- 3. 緊急連絡先管理テーブル
CREATE TABLE emergency_contacts (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    contact_type ENUM('parent', 'guardian', 'medical', 'admin') NOT NULL,
    student_id BIGINT,
    contact_reason VARCHAR(200),
    authorized_by VARCHAR(100),
    expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    INDEX idx_username (username),
    INDEX idx_student_contact (student_id, contact_type)
);

-- 緊急連絡先の例
INSERT INTO emergency_contacts (username, contact_type, student_id, contact_reason, authorized_by) VALUES
('emergency_parent_301@localhost', 'parent', 301, '緊急時連絡', 'admin'),
('emergency_medical@localhost', 'medical', NULL, '医療緊急時', 'admin');

-- 4. 時間制限チェックプロシージャ
DELIMITER //

CREATE PROCEDURE check_time_access_permission(
    OUT p_access_granted BOOLEAN,
    OUT p_restriction_reason TEXT
)
BEGIN
    DECLARE v_current_day INT;
    DECLARE v_current_time TIME;
    DECLARE v_current_date DATE;
    DECLARE v_user_type VARCHAR(20);
    DECLARE v_is_emergency_contact BOOLEAN DEFAULT FALSE;
    DECLARE v_special_period JSON DEFAULT NULL;
    DECLARE v_policy_found BOOLEAN DEFAULT FALSE;
    
    SET p_access_granted = FALSE;
    SET p_restriction_reason = '';
    SET v_current_day = DAYOFWEEK(CURRENT_DATE); -- 1=日曜日, 2=月曜日...
    SET v_current_time = CURRENT_TIME;
    SET v_current_date = CURRENT_DATE;
    
    -- ユーザータイプの判定
    SET v_user_type = CASE 
        WHEN USER() LIKE '%student%' THEN 'student'
        WHEN USER() LIKE '%teacher%' THEN 'teacher'
        WHEN USER() LIKE '%admin%' OR USER() = 'root' THEN 'admin'
        ELSE 'unknown'
    END;
    
    -- 緊急連絡先かどうかチェック
    SELECT COUNT(*) > 0 INTO v_is_emergency_contact
    FROM emergency_contacts
    WHERE username = USER()
    AND is_active = TRUE
    AND (expires_at IS NULL OR expires_at > NOW());
    
    IF v_is_emergency_contact THEN
        SET v_user_type = 'emergency';
    END IF;
    
    -- 特別期間中かどうかチェック
    SELECT access_modifications INTO v_special_period
    FROM special_access_periods
    WHERE v_current_date BETWEEN start_date AND end_date
    AND is_active = TRUE
    ORDER BY period_id DESC
    LIMIT 1;
    
    -- 特別期間中の制限チェック
    IF v_special_period IS NOT NULL THEN
        CASE v_user_type
            WHEN 'student' THEN
                IF JSON_EXTRACT(v_special_period, '$.student_access') = false THEN
                    SET p_restriction_reason = 'Student access restricted during special period';
                    LEAVE check_proc;
                END IF;
                IF JSON_EXTRACT(v_special_period, '$.student_grade_access') = false THEN
                    SET p_restriction_reason = 'Student grade access restricted during exam period';
                    LEAVE check_proc;
                END IF;
            WHEN 'teacher' THEN
                IF JSON_EXTRACT(v_special_period, '$.teacher_limited') = true THEN
                    -- 特別期間中の教師時間制限適用
                    IF JSON_EXTRACT(v_special_period, '$.extended_teacher_hours') IS NOT NULL THEN
                        -- 拡張時間の適用
                        SET v_current_time = v_current_time; -- 拡張時間チェックは後で実装
                    END IF;
                END IF;
        END CASE;
    END IF;
    
    -- 通常の時間制限ポリシーチェック
    SELECT COUNT(*) > 0 INTO v_policy_found
    FROM time_access_policies
    WHERE user_type = v_user_type
    AND is_active = TRUE
    AND JSON_CONTAINS(allowed_days, CAST(v_current_day AS JSON))
    AND v_current_time BETWEEN start_time AND end_time;
    
    IF v_policy_found THEN
        SET p_access_granted = TRUE;
    ELSE
        SET p_restriction_reason = CONCAT('Access denied: Outside allowed hours for ', v_user_type);
    END IF;
    
    check_proc: BEGIN END; -- ラベル用
    
    -- アクセスログの記録
    INSERT INTO security_procedure_log 
        (procedure_name, username, parameters, access_granted, execution_time_ms, error_message)
    VALUES 
        ('check_time_access_permission', USER(), 
         JSON_OBJECT('user_type', v_user_type, 'check_time', v_current_time), 
         p_access_granted, 0, p_restriction_reason);
    
END //

-- 5. 時間制限付きデータアクセスプロシージャ
CREATE PROCEDURE time_restricted_get_student_info(
    IN p_student_id BIGINT
)
BEGIN
    DECLARE v_access_granted BOOLEAN;
    DECLARE v_restriction_reason TEXT;
    
    -- 時間制限チェック
    CALL check_time_access_permission(v_access_granted, v_restriction_reason);
    
    IF NOT v_access_granted THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_restriction_reason;
    END IF;
    
    -- 通常のセキュリティチェック後、データを取得
    CALL get_accessible_student_info(p_student_id);
    
END //

-- 6. 特別期間管理プロシージャ
CREATE PROCEDURE set_special_access_period(
    IN p_period_name VARCHAR(100),
    IN p_period_type ENUM('exam', 'maintenance', 'emergency', 'holiday'),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_access_modifications JSON
)
BEGIN
    -- 管理者権限チェック
    IF USER() NOT LIKE '%admin%' AND USER() != 'root' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Admin privileges required';
    END IF;
    
    -- 特別期間の登録
    INSERT INTO special_access_periods 
        (period_name, period_type, start_date, end_date, access_modifications, created_by)
    VALUES 
        (p_period_name, p_period_type, p_start_date, p_end_date, p_access_modifications, USER());
    
    -- 通知ログの記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('SPECIAL_PERIOD', 'SYSTEM', 'SYSTEM', 'time_control', USER(),
            CONCAT('Special access period set: ', p_period_name, ' (', p_start_date, ' to ', p_end_date, ')'));
    
    SELECT CONCAT('Special access period "', p_period_name, '" has been set') as result;
    
END //

DELIMITER ;

-- 7. 時間制限監視システム
CREATE EVENT IF NOT EXISTS cleanup_expired_emergency_contacts
ON SCHEDULE EVERY 1 HOUR
DO
  UPDATE emergency_contacts 
  SET is_active = FALSE 
  WHERE expires_at <= NOW() AND is_active = TRUE;

-- テスト実行例
-- CALL check_time_access_permission(@granted, @reason);
-- SELECT @granted as access_granted, @reason as restriction_reason;

-- 特別期間設定例
-- CALL set_special_access_period('緊急メンテナンス', 'maintenance', '2025-06-01', '2025-06-01', 
--      JSON_OBJECT('student_access', false, 'teacher_access', false, 'admin_only', true));
```

### 解答41-5
```sql
-- 保護者アクセスシステムの拡張実装

-- 1. 拡張保護者関係テーブル
CREATE TABLE enhanced_parent_relationships (
    relationship_id INT AUTO_INCREMENT PRIMARY KEY,
    parent_username VARCHAR(100) NOT NULL,
    student_id BIGINT NOT NULL,
    relationship_type ENUM('father', 'mother', 'guardian', 'emergency_contact') NOT NULL,
    access_level ENUM('full', 'attendance_only', 'emergency_only') DEFAULT 'full',
    is_primary_contact BOOLEAN DEFAULT FALSE,
    notification_preferences JSON, -- 通知設定
    access_restrictions JSON, -- 追加制限
    approval_status ENUM('pending', 'approved', 'rejected', 'suspended') DEFAULT 'pending',
    approved_by VARCHAR(100),
    approved_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT FALSE, -- 承認後にTRUEに
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    INDEX idx_parent_student (parent_username, student_id),
    INDEX idx_approval_status (approval_status),
    INDEX idx_active_relationships (is_active, expires_at)
);

-- 保護者関係サンプルデータ
INSERT INTO enhanced_parent_relationships 
    (parent_username, student_id, relationship_type, access_level, notification_preferences, approval_status, approved_by, approved_at, is_active) 
VALUES
('parent_yamada@localhost', 301, 'father', 'full', 
 JSON_OBJECT('grade_alerts', true, 'attendance_alerts', true, 'emergency_alerts', true), 
 'approved', 'admin', NOW(), TRUE),
('parent_tanaka@localhost', 302, 'mother', 'attendance_only', 
 JSON_OBJECT('grade_alerts', false, 'attendance_alerts', true, 'emergency_alerts', true), 
 'approved', 'admin', NOW(), TRUE);

-- 2. 通知管理テーブル
CREATE TABLE parent_notifications (
    notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_username VARCHAR(100) NOT NULL,
    student_id BIGINT NOT NULL,
    notification_type ENUM('attendance_alert', 'grade_change', 'emergency', 'general') NOT NULL,
    severity ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    related_data JSON, -- 関連データ（成績、出席等）
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    
    INDEX idx_parent_unread (parent_username, is_read),
    INDEX idx_student_notifications (student_id, created_at),
    INDEX idx_notification_type (notification_type, severity)
);

-- 3. 保護者アクセス履歴テーブル
CREATE TABLE parent_access_history (
    access_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_username VARCHAR(100) NOT NULL,
    student_id BIGINT,
    access_type ENUM('login', 'view_grades', 'view_attendance', 'view_info', 'download_report') NOT NULL,
    access_details JSON,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    session_duration_seconds INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_parent_access (parent_username, created_at),
    INDEX idx_student_access (student_id, created_at),
    INDEX idx_access_type (access_type)
);

-- 4. 段階的アクセス権限管理プロシージャ
DELIMITER //

CREATE PROCEDURE parent_get_child_info_enhanced(
    IN p_student_id BIGINT,
    IN p_info_type ENUM('basic', 'grades', 'attendance', 'health', 'emergency')
)
BEGIN
    DECLARE v_access_level VARCHAR(20);
    DECLARE v_relationship_active BOOLEAN DEFAULT FALSE;
    DECLARE v_notification_prefs JSON;
    DECLARE v_access_granted BOOLEAN DEFAULT FALSE;
    
    -- 保護者の子供へのアクセス権限確認
    SELECT 
        access_level,
        is_active,
        notification_preferences
    INTO v_access_level, v_relationship_active, v_notification_prefs
    FROM enhanced_parent_relationships
    WHERE parent_username = USER()
    AND student_id = p_student_id
    AND approval_status = 'approved'
    AND (expires_at IS NULL OR expires_at > NOW());
    
    IF NOT v_relationship_active THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: No active relationship with student';
    END IF;
    
    -- アクセスレベルに応じた権限チェック
    CASE v_access_level
        WHEN 'full' THEN
            SET v_access_granted = TRUE;
        WHEN 'attendance_only' THEN
            SET v_access_granted = (p_info_type IN ('basic', 'attendance'));
        WHEN 'emergency_only' THEN
            SET v_access_granted = (p_info_type = 'emergency');
        ELSE
            SET v_access_granted = FALSE;
    END CASE;
    
    IF NOT v_access_granted THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
            CONCAT('Access denied: ', v_access_level, ' access does not permit ', p_info_type, ' information');
    END IF;
    
    -- 要求された情報タイプに応じてデータを返す
    CASE p_info_type
        WHEN 'basic' THEN
            SELECT 
                s.student_id,
                s.student_name,
                YEAR(CURRENT_DATE) - YEAR(s.admission_date) + 1 as current_grade,
                s.admission_date,
                '基本情報' as info_type
            FROM students s
            WHERE s.student_id = p_student_id;
            
        WHEN 'grades' THEN
            SELECT 
                g.course_id,
                c.course_name,
                g.grade_type,
                g.score,
                g.max_score,
                ROUND((g.score / g.max_score) * 100, 1) as percentage,
                g.submission_date
            FROM grades g
            JOIN courses c ON g.course_id = c.course_id
            WHERE g.student_id = p_student_id
            AND g.submission_date >= DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY)
            ORDER BY g.submission_date DESC;
            
        WHEN 'attendance' THEN
            SELECT 
                cs.schedule_date,
                c.course_name,
                cp.start_time,
                cp.end_time,
                a.status,
                CASE a.status
                    WHEN 'present' THEN '出席'
                    WHEN 'absent' THEN '欠席'
                    WHEN 'late' THEN '遅刻'
                END as status_japanese
            FROM attendance a
            JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
            JOIN courses c ON cs.course_id = c.course_id
            JOIN class_periods cp ON cs.period_id = cp.period_id
            WHERE a.student_id = p_student_id
            AND cs.schedule_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
            ORDER BY cs.schedule_date DESC;
            
        WHEN 'emergency' THEN
            SELECT 
                s.student_name,
                '緊急連絡情報のみ表示' as emergency_info,
                ec.contact_type,
                ec.contact_reason
            FROM students s
            JOIN emergency_contacts ec ON s.student_id = ec.student_id
            WHERE s.student_id = p_student_id
            AND ec.is_active = TRUE;
    END CASE;
    
    -- アクセス履歴の記録
    INSERT INTO parent_access_history (parent_username, student_id, access_type, access_details)
    VALUES (USER(), p_student_id, CONCAT('view_', p_info_type), 
            JSON_OBJECT('access_level', v_access_level, 'timestamp', NOW()));
    
END //

-- 5. 自動通知システム
CREATE PROCEDURE generate_parent_notifications()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_parent_username VARCHAR(100);
    DECLARE v_student_id BIGINT;
    DECLARE v_notification_prefs JSON;
    
    DECLARE parent_cursor CURSOR FOR
        SELECT parent_username, student_id, notification_preferences
        FROM enhanced_parent_relationships
        WHERE is_active = TRUE
        AND approval_status = 'approved';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN parent_cursor;
    
    notification_loop: LOOP
        FETCH parent_cursor INTO v_parent_username, v_student_id, v_notification_prefs;
        IF done THEN
            LEAVE notification_loop;
        END IF;
        
        -- 出席アラートの生成
        IF JSON_EXTRACT(v_notification_prefs, '$.attendance_alerts') = true THEN
            INSERT INTO parent_notifications 
                (parent_username, student_id, notification_type, severity, title, message, related_data)
            SELECT 
                v_parent_username,
                v_student_id,
                'attendance_alert',
                'medium',
                CONCAT(s.student_name, 'さんの出席状況について'),
                CONCAT('過去1週間で', absent_count, '回の欠席があります。'),
                JSON_OBJECT('absent_days', absent_count, 'period', 'last_7_days')
            FROM students s
            JOIN (
                SELECT 
                    a.student_id,
                    COUNT(CASE WHEN a.status = 'absent' THEN 1 END) as absent_count
                FROM attendance a
                JOIN course_schedule cs ON a.schedule_id = cs.schedule_id
                WHERE a.student_id = v_student_id
                AND cs.schedule_date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
                GROUP BY a.student_id
                HAVING absent_count >= 3
            ) attendance_summary ON s.student_id = attendance_summary.student_id
            WHERE s.student_id = v_student_id
            AND NOT EXISTS (
                SELECT 1 FROM parent_notifications pn
                WHERE pn.parent_username = v_parent_username
                AND pn.student_id = v_student_id
                AND pn.notification_type = 'attendance_alert'
                AND pn.created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY)
            );
        END IF;
        
        -- 成績変動アラートの生成
        IF JSON_EXTRACT(v_notification_prefs, '$.grade_alerts') = true THEN
            INSERT INTO parent_notifications 
                (parent_username, student_id, notification_type, severity, title, message, related_data)
            SELECT 
                v_parent_username,
                v_student_id,
                'grade_change',
                'low',
                CONCAT(s.student_name, 'さんの新しい成績が登録されました'),
                CONCAT(c.course_name, 'の', g.grade_type, ': ', g.score, '/', g.max_score, '点'),
                JSON_OBJECT('course_id', g.course_id, 'grade_type', g.grade_type, 'score', g.score)
            FROM grades g
            JOIN students s ON g.student_id = s.student_id
            JOIN courses c ON g.course_id = c.course_id
            WHERE g.student_id = v_student_id
            AND g.submission_date >= DATE_SUB(NOW(), INTERVAL 1 DAY)
            AND NOT EXISTS (
                SELECT 1 FROM parent_notifications pn
                WHERE pn.parent_username = v_parent_username
                AND pn.student_id = v_student_id
                AND pn.notification_type = 'grade_change'
                AND JSON_EXTRACT(pn.related_data, '$.course_id') = g.course_id
                AND JSON_EXTRACT(pn.related_data, '$.grade_type') = g.grade_type
            );
        END IF;
        
    END LOOP;
    
    CLOSE parent_cursor;
    
    SELECT CONCAT('Generated notifications for active parent relationships') as result;
    
END //

-- 6. 異常アクセス検知プロシージャ
CREATE PROCEDURE detect_parent_access_anomalies()
BEGIN
    -- 短時間での大量アクセス検知
    INSERT INTO parent_notifications 
        (parent_username, student_id, notification_type, severity, title, message, related_data)
    SELECT 
        pah.parent_username,
        pah.student_id,
        'general',
        'high',
        'セキュリティアラート: 異常なアクセスパターン',
        CONCAT('過去1時間で', access_count, '回のアクセスがありました。'),
        JSON_OBJECT('access_count', access_count, 'time_period', '1_hour', 'alert_type', 'high_frequency')
    FROM (
        SELECT 
            parent_username,
            student_id,
            COUNT(*) as access_count
        FROM parent_access_history
        WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
        GROUP BY parent_username, student_id
        HAVING access_count > 50
    ) pah
    WHERE NOT EXISTS (
        SELECT 1 FROM parent_notifications pn
        WHERE pn.parent_username = pah.parent_username
        AND pn.notification_type = 'general'
        AND JSON_EXTRACT(pn.related_data, '$.alert_type') = 'high_frequency'
        AND pn.created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
    );
    
    -- 深夜アクセスの検知
    INSERT INTO parent_notifications 
        (parent_username, student_id, notification_type, severity, title, message, related_data)
    SELECT DISTINCT
        pah.parent_username,
        pah.student_id,
        'general',
        'medium',
        'セキュリティ通知: 深夜時間帯のアクセス',
        '深夜時間帯（22:00-6:00）にアクセスがありました。',
        JSON_OBJECT('access_time', pah.created_at, 'alert_type', 'off_hours')
    FROM parent_access_history pah
    WHERE pah.created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY)
    AND (HOUR(pah.created_at) >= 22 OR HOUR(pah.created_at) <= 6)
    AND NOT EXISTS (
        SELECT 1 FROM parent_notifications pn
        WHERE pn.parent_username = pah.parent_username
        AND pn.notification_type = 'general'
        AND JSON_EXTRACT(pn.related_data, '$.alert_type') = 'off_hours'
        AND DATE(pn.created_at) = DATE(pah.created_at)
    );
    
END //

-- 7. 承認ワークフロープロシージャ
CREATE PROCEDURE approve_parent_relationship(
    IN p_relationship_id INT,
    IN p_approval_decision ENUM('approved', 'rejected'),
    IN p_approval_notes TEXT
)
BEGIN
    DECLARE v_parent_username VARCHAR(100);
    DECLARE v_student_id BIGINT;
    
    -- 管理者権限チェック
    IF USER() NOT LIKE '%admin%' AND USER() NOT LIKE '%office%' AND USER() != 'root' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Admin or office staff privileges required';
    END IF;
    
    -- 関係情報を取得
    SELECT parent_username, student_id
    INTO v_parent_username, v_student_id
    FROM enhanced_parent_relationships
    WHERE relationship_id = p_relationship_id
    AND approval_status = 'pending';
    
    IF v_parent_username IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Relationship not found or not pending approval';
    END IF;
    
    -- 承認状態を更新
    UPDATE enhanced_parent_relationships
    SET 
        approval_status = p_approval_decision,
        approved_by = USER(),
        approved_at = NOW(),
        is_active = (p_approval_decision = 'approved')
    WHERE relationship_id = p_relationship_id;
    
    -- 承認通知を生成
    INSERT INTO parent_notifications 
        (parent_username, student_id, notification_type, severity, title, message, related_data)
    VALUES 
        (v_parent_username, v_student_id, 'general',
         CASE p_approval_decision WHEN 'approved' THEN 'low' ELSE 'medium' END,
         CASE p_approval_decision 
             WHEN 'approved' THEN 'アカウント承認完了'
             ELSE 'アカウント承認拒否'
         END,
         CASE p_approval_decision
             WHEN 'approved' THEN 'お子様の情報へのアクセスが承認されました。'
             ELSE CONCAT('アカウント承認が拒否されました。理由: ', IFNULL(p_approval_notes, '詳細は学校にお問い合わせください。'))
         END,
         JSON_OBJECT('approval_decision', p_approval_decision, 'approved_by', USER()));
    
    -- ログ記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('APPROVAL', v_parent_username, 'parent_system', 'parent_approval', USER(),
            CONCAT('Parent relationship ', p_approval_decision, ' for student ', v_student_id));
    
    SELECT CONCAT('Parent relationship ', p_approval_decision, ' successfully') as result;
    
END //

DELIMITER ;

-- 8. 定期実行イベント
CREATE EVENT IF NOT EXISTS parent_notification_generator
ON SCHEDULE EVERY 1 HOUR
DO
  CALL generate_parent_notifications();

CREATE EVENT IF NOT EXISTS parent_access_anomaly_detector
ON SCHEDULE EVERY 6 HOUR
DO
  CALL detect_parent_access_anomalies();

-- テスト実行例
-- CALL parent_get_child_info_enhanced(301, 'grades');
-- CALL approve_parent_relationship(1, 'approved', 'Initial setup');
-- CALL generate_parent_notifications();
```

### 解答41-6
```sql
-- 総合セキュリティシステムの実装

-- 1. 統合ユーザーコンテキスト管理
CREATE TABLE unified_security_context (
    context_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    primary_role ENUM('student', 'teacher', 'grade_supervisor', 'academic_director', 'principal', 'office_staff', 'parent', 'admin') NOT NULL,
    role_hierarchy_level INT NOT NULL, -- 1-10の階層レベル
    associated_entities JSON, -- 関連するID群（学生ID、教師ID、クラスID等）
    access_policies JSON, -- カスタムアクセスポリシー
    temporary_permissions JSON, -- 一時的な権限
    security_clearance_level INT DEFAULT 1, -- セキュリティクリアランス
    context_metadata JSON, -- 追加のメタデータ
    is_active BOOLEAN DEFAULT TRUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_username (username),
    INDEX idx_role_level (primary_role, role_hierarchy_level),
    INDEX idx_clearance (security_clearance_level),
    INDEX idx_active (is_active)
);

-- 統合コンテキストサンプルデータ
INSERT INTO unified_security_context 
    (username, primary_role, role_hierarchy_level, associated_entities, access_policies, security_clearance_level) 
VALUES
('student_301@localhost', 'student', 1, JSON_OBJECT('student_id', 301), 
 JSON_OBJECT('data_retention_days', 90, 'export_allowed', false), 1),
('teacher_tanaka@localhost', 'teacher', 3, JSON_OBJECT('teacher_id', 101, 'courses', JSON_ARRAY('1', '2')), 
 JSON_OBJECT('grade_modification_window_hours', 72, 'bulk_operations', true), 2),
('principal@localhost', 'principal', 8, JSON_OBJECT('authority_scope', 'all'), 
 JSON_OBJECT('emergency_override', true, 'audit_exempt', false), 4);

-- 2. 動的アクセスポリシーエンジン
CREATE TABLE access_policy_rules (
    rule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    rule_name VARCHAR(100) NOT NULL,
    target_table VARCHAR(64) NOT NULL,
    operation_type ENUM('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'ALL') NOT NULL,
    condition_template TEXT NOT NULL, -- 動的条件のテンプレート
    role_requirements JSON, -- 必要な役職・レベル
    time_restrictions JSON, -- 時間制限
    data_sensitivity_level INT DEFAULT 1, -- データ機密レベル
    is_active BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_target_operation (target_table, operation_type),
    INDEX idx_sensitivity (data_sensitivity_level),
    INDEX idx_active (is_active)
);

-- 動的ポリシールールの例
INSERT INTO access_policy_rules 
    (rule_name, target_table, operation_type, condition_template, role_requirements, time_restrictions, data_sensitivity_level, created_by) 
VALUES
('学生自分情報アクセス', 'students', 'SELECT', 
 'student_id = {{user.associated_entities.student_id}}', 
 JSON_OBJECT('min_level', 1, 'allowed_roles', JSON_ARRAY('student')), 
 JSON_OBJECT('weekdays_only', true, 'hours', JSON_OBJECT('start', 8, 'end', 18)), 2, 'system'),
('教師担当学生アクセス', 'students', 'SELECT', 
 'student_id IN (SELECT sc.student_id FROM student_courses sc JOIN courses c ON sc.course_id = c.course_id WHERE c.teacher_id = {{user.associated_entities.teacher_id}})', 
 JSON_OBJECT('min_level', 3, 'allowed_roles', JSON_ARRAY('teacher', 'grade_supervisor')), 
 JSON_OBJECT('weekdays_only', true, 'hours', JSON_OBJECT('start', 7, 'end', 20)), 2, 'system');

-- 3. カスタムアクセスポリシー管理
DELIMITER //

CREATE PROCEDURE apply_dynamic_access_policy(
    IN p_username VARCHAR(100),
    IN p_table_name VARCHAR(64),
    IN p_operation ENUM('SELECT', 'INSERT', 'UPDATE', 'DELETE'),
    OUT p_access_condition TEXT,
    OUT p_access_granted BOOLEAN
)
BEGIN
    DECLARE v_user_context JSON;
    DECLARE v_role VARCHAR(50);
    DECLARE v_level INT;
    DECLARE v_clearance INT;
    DECLARE v_rule_condition TEXT;
    DECLARE v_time_allowed BOOLEAN DEFAULT TRUE;
    DECLARE v_current_hour INT;
    
    SET p_access_granted = FALSE;
    SET p_access_condition = '1=0'; -- デフォルトでアクセス拒否
    SET v_current_hour = HOUR(NOW());
    
    -- ユーザーコンテキストを取得
    SELECT 
        JSON_OBJECT(
            'role', primary_role,
            'level', role_hierarchy_level,
            'clearance', security_clearance_level,
            'entities', associated_entities,
            'policies', access_policies
        ),
        primary_role,
        role_hierarchy_level,
        security_clearance_level
    INTO v_user_context, v_role, v_level, v_clearance
    FROM unified_security_context
    WHERE username = p_username
    AND is_active = TRUE;
    
    IF v_user_context IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User security context not found';
    END IF;
    
    -- 適用可能なポリシールールを検索
    SELECT condition_template INTO v_rule_condition
    FROM access_policy_rules apr
    WHERE apr.target_table = p_table_name
    AND (apr.operation_type = p_operation OR apr.operation_type = 'ALL')
    AND JSON_CONTAINS(JSON_EXTRACT(apr.role_requirements, '$.allowed_roles'), JSON_QUOTE(v_role))
    AND v_level >= JSON_EXTRACT(apr.role_requirements, '$.min_level')
    AND v_clearance >= apr.data_sensitivity_level
    AND apr.is_active = TRUE
    ORDER BY apr.data_sensitivity_level DESC, apr.rule_id
    LIMIT 1;
    
    IF v_rule_condition IS NOT NULL THEN
        -- 時間制限チェック
        SELECT COUNT(*) = 0 INTO v_time_allowed
        FROM access_policy_rules apr
        WHERE apr.target_table = p_table_name
        AND JSON_EXTRACT(apr.time_restrictions, '$.weekdays_only') = true
        AND DAYOFWEEK(NOW()) IN (1, 7); -- 土日
        
        IF v_time_allowed THEN
            SELECT COUNT(*) = 0 INTO v_time_allowed
            FROM access_policy_rules apr
            WHERE apr.target_table = p_table_name
            AND (v_current_hour < JSON_EXTRACT(apr.time_restrictions, '$.hours.start')
                 OR v_current_hour > JSON_EXTRACT(apr.time_restrictions, '$.hours.end'));
        END IF;
        
        IF v_time_allowed THEN
            -- テンプレート変数を実際の値に置換
            SET p_access_condition = REPLACE(v_rule_condition, '{{user.associated_entities.student_id}}', 
                                           JSON_UNQUOTE(JSON_EXTRACT(v_user_context, '$.entities.student_id')));
            SET p_access_condition = REPLACE(p_access_condition, '{{user.associated_entities.teacher_id}}', 
                                           JSON_UNQUOTE(JSON_EXTRACT(v_user_context, '$.entities.teacher_id')));
            SET p_access_granted = TRUE;
        END IF;
    END IF;
    
    -- アクセスログ記録
    INSERT INTO security_procedure_log 
        (procedure_name, username, parameters, access_granted, execution_time_ms, error_message)
    VALUES 
        ('apply_dynamic_access_policy', p_username,
         JSON_OBJECT('table', p_table_name, 'operation', p_operation, 'condition', p_access_condition),
         p_access_granted, 0, CASE WHEN NOT p_access_granted THEN 'Policy evaluation failed' ELSE NULL END);
         
END //

-- 4. 一時的権限委譲システム
CREATE PROCEDURE delegate_temporary_permission(
    IN p_grantor_username VARCHAR(100),
    IN p_grantee_username VARCHAR(100),
    IN p_permission_scope JSON, -- 委譲する権限の範囲
    IN p_duration_hours INT,
    IN p_justification TEXT
)
BEGIN
    DECLARE v_grantor_level INT;
    DECLARE v_grantee_level INT;
    DECLARE v_expiry_time TIMESTAMP;
    
    SET v_expiry_time = DATE_ADD(NOW(), INTERVAL p_duration_hours HOUR);
    
    -- 委譲者の権限レベルチェック
    SELECT role_hierarchy_level INTO v_grantor_level
    FROM unified_security_context
    WHERE username = p_grantor_username AND is_active = TRUE;
    
    SELECT role_hierarchy_level INTO v_grantee_level
    FROM unified_security_context
    WHERE username = p_grantee_username AND is_active = TRUE;
    
    IF v_grantor_level IS NULL OR v_grantee_level IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid grantor or grantee';
    END IF;
    
    IF v_grantor_level <= v_grantee_level THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delegate to equal or higher level user';
    END IF;
    
    -- 一時的権限を付与
    UPDATE unified_security_context
    SET temporary_permissions = JSON_MERGE_PATCH(
        IFNULL(temporary_permissions, '{}'),
        JSON_OBJECT(
            CONCAT('delegation_', UNIX_TIMESTAMP()), 
            JSON_OBJECT(
                'grantor', p_grantor_username,
                'scope', p_permission_scope,
                'expires_at', v_expiry_time,
                'justification', p_justification
            )
        )
    )
    WHERE username = p_grantee_username;
    
    -- 委譲ログ記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('DELEGATE', p_grantee_username, 'delegation_system', 'temp_permission', p_grantor_username,
            CONCAT('Temporary permission delegated until ', v_expiry_time, '. Scope: ', p_permission_scope));
    
    SELECT CONCAT('Permission delegated successfully until ', v_expiry_time) as result;
    
END //

-- 5. 全テーブル行レベル制御システム
CREATE PROCEDURE setup_universal_row_level_security()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_table_name VARCHAR(64);
    
    -- 学校DBの全テーブルを取得
    DECLARE table_cursor CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'school_db'
        AND table_type = 'BASE TABLE';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN table_cursor;
    
    security_loop: LOOP
        FETCH table_cursor INTO v_table_name;
        IF done THEN
            LEAVE security_loop;
        END IF;
        
        -- 各テーブルに対してセキュリティビューを作成
        CASE v_table_name
            WHEN 'students' THEN
                -- 学生テーブル用セキュリティビュー（既存のロジックを使用）
                SET @sql = CONCAT('CREATE OR REPLACE VIEW v_secure_', v_table_name, ' AS 
                    SELECT * FROM ', v_table_name, ' WHERE 1=1'); -- 基本フレーム
            WHEN 'grades' THEN
                -- 成績テーブル用セキュリティビュー
                SET @sql = CONCAT('CREATE OR REPLACE VIEW v_secure_', v_table_name, ' AS 
                    SELECT * FROM ', v_table_name, ' WHERE 1=1'); -- 基本フレーム
            ELSE
                -- その他のテーブル用デフォルトビュー
                SET @sql = CONCAT('CREATE OR REPLACE VIEW v_secure_', v_table_name, ' AS 
                    SELECT * FROM ', v_table_name, ' WHERE 1=1'); -- 基本フレーム
        END CASE;
        
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
    END LOOP;
    
    CLOSE table_cursor;
    
    SELECT 'Universal row-level security views created' as result;
    
END //

-- 6. 包括的監査システム
CREATE TABLE comprehensive_audit_log (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    event_timestamp TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
    username VARCHAR(100) NOT NULL,
    session_id VARCHAR(64),
    event_type ENUM('LOGIN', 'LOGOUT', 'DATA_ACCESS', 'DATA_MODIFY', 'PERMISSION_CHANGE', 'POLICY_VIOLATION', 'SECURITY_ALERT') NOT NULL,
    target_object VARCHAR(100),
    operation VARCHAR(20),
    affected_records JSON, -- 影響を受けたレコードのID
    query_hash VARCHAR(64), -- 実行されたクエリのハッシュ
    execution_time_ms INT,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    risk_score INT DEFAULT 0, -- 0-100のリスクスコア
    compliance_tags JSON, -- コンプライアンス関連タグ
    additional_metadata JSON,
    
    INDEX idx_timestamp (event_timestamp),
    INDEX idx_username_timestamp (username, event_timestamp),
    INDEX idx_event_type (event_type),
    INDEX idx_risk_score (risk_score),
    PARTITION BY RANGE (YEAR(event_timestamp)) (
        PARTITION p2024 VALUES LESS THAN (2025),
        PARTITION p2025 VALUES LESS THAN (2026),
        PARTITION p2026 VALUES LESS THAN (2027),
        PARTITION pmax VALUES LESS THAN MAXVALUE
    )
);

-- 監査ログ記録プロシージャ
CREATE PROCEDURE log_comprehensive_audit(
    IN p_event_type ENUM('LOGIN', 'LOGOUT', 'DATA_ACCESS', 'DATA_MODIFY', 'PERMISSION_CHANGE', 'POLICY_VIOLATION', 'SECURITY_ALERT'),
    IN p_target_object VARCHAR(100),
    IN p_operation VARCHAR(20),
    IN p_affected_records JSON,
    IN p_risk_score INT,
    IN p_additional_metadata JSON
)
BEGIN
    DECLARE v_session_id VARCHAR(64);
    DECLARE v_query_hash VARCHAR(64);
    
    -- セッションIDの生成（簡易版）
    SET v_session_id = CONCAT(CONNECTION_ID(), '_', UNIX_TIMESTAMP());
    
    -- クエリハッシュの生成（実際の環境では実行されたクエリをハッシュ化）
    SET v_query_hash = SHA2(CONCAT(p_target_object, p_operation, NOW()), 256);
    
    INSERT INTO comprehensive_audit_log 
        (username, session_id, event_type, target_object, operation, affected_records, 
         query_hash, risk_score, additional_metadata)
    VALUES 
        (USER(), v_session_id, p_event_type, p_target_object, p_operation, p_affected_records,
         v_query_hash, p_risk_score, p_additional_metadata);
    
END //

-- 7. コンプライアンスレポート生成
CREATE PROCEDURE generate_compliance_report(
    IN p_report_type ENUM('GDPR', 'FERPA', 'SECURITY_SUMMARY', 'ACCESS_REVIEW'),
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    CASE p_report_type
        WHEN 'GDPR' THEN
            -- GDPR準拠レポート（個人データアクセス記録）
            SELECT 
                'GDPR Compliance Report' as report_type,
                cal.username,
                cal.target_object,
                COUNT(*) as access_count,
                MIN(cal.event_timestamp) as first_access,
                MAX(cal.event_timestamp) as last_access,
                GROUP_CONCAT(DISTINCT cal.operation) as operations,
                JSON_ARRAYAGG(cal.affected_records) as accessed_records
            FROM comprehensive_audit_log cal
            WHERE cal.event_timestamp BETWEEN p_start_date AND DATE_ADD(p_end_date, INTERVAL 1 DAY)
            AND cal.event_type IN ('DATA_ACCESS', 'DATA_MODIFY')
            AND cal.target_object IN ('students', 'grades', 'attendance')
            GROUP BY cal.username, cal.target_object
            ORDER BY access_count DESC;
            
        WHEN 'FERPA' THEN
            -- FERPA準拠レポート（教育記録アクセス）
            SELECT 
                'FERPA Compliance Report' as report_type,
                cal.username,
                COUNT(*) as educational_record_accesses,
                AVG(cal.risk_score) as avg_risk_score,
                COUNT(CASE WHEN cal.risk_score > 50 THEN 1 END) as high_risk_accesses
            FROM comprehensive_audit_log cal
            WHERE cal.event_timestamp BETWEEN p_start_date AND DATE_ADD(p_end_date, INTERVAL 1 DAY)
            AND cal.target_object IN ('grades', 'attendance', 'students')
            GROUP BY cal.username
            ORDER BY educational_record_accesses DESC;
            
        WHEN 'SECURITY_SUMMARY' THEN
            -- セキュリティサマリーレポート
            SELECT 
                'Security Summary Report' as report_type,
                cal.event_type,
                COUNT(*) as event_count,
                AVG(cal.risk_score) as avg_risk_score,
                COUNT(DISTINCT cal.username) as unique_users,
                MAX(cal.risk_score) as max_risk_score
            FROM comprehensive_audit_log cal
            WHERE cal.event_timestamp BETWEEN p_start_date AND DATE_ADD(p_end_date, INTERVAL 1 DAY)
            GROUP BY cal.event_type
            ORDER BY avg_risk_score DESC;
            
        WHEN 'ACCESS_REVIEW' THEN
            -- アクセスレビューレポート
            SELECT 
                'Access Review Report' as report_type,
                usc.username,
                usc.primary_role,
                usc.role_hierarchy_level,
                usc.security_clearance_level,
                access_summary.total_accesses,
                access_summary.high_risk_accesses,
                access_summary.last_access,
                CASE 
                    WHEN access_summary.last_access < DATE_SUB(NOW(), INTERVAL 30 DAY) THEN 'INACTIVE'
                    WHEN access_summary.high_risk_accesses > 10 THEN 'HIGH_RISK'
                    ELSE 'NORMAL'
                END as access_status
            FROM unified_security_context usc
            LEFT JOIN (
                SELECT 
                    cal.username,
                    COUNT(*) as total_accesses,
                    COUNT(CASE WHEN cal.risk_score > 70 THEN 1 END) as high_risk_accesses,
                    MAX(cal.event_timestamp) as last_access
                FROM comprehensive_audit_log cal
                WHERE cal.event_timestamp BETWEEN p_start_date AND DATE_ADD(p_end_date, INTERVAL 1 DAY)
                GROUP BY cal.username
            ) access_summary ON usc.username = access_summary.username
            WHERE usc.is_active = TRUE
            ORDER BY access_summary.high_risk_accesses DESC, access_summary.total_accesses DESC;
    END CASE;
    
END //

DELIMITER ;

-- 8. セキュリティダッシュボード機能
CREATE VIEW v_security_dashboard AS
SELECT 
    'Active Users' as metric_name,
    COUNT(*) as metric_value,
    'count' as metric_type
FROM unified_security_context 
WHERE is_active = TRUE

UNION ALL

SELECT 
    'High Risk Activities (Last 24h)',
    COUNT(*),
    'count'
FROM comprehensive_audit_log 
WHERE event_timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
AND risk_score > 70

UNION ALL

SELECT 
    'Policy Violations (Last 7 days)',
    COUNT(*),
    'count'
FROM comprehensive_audit_log 
WHERE event_timestamp >= DATE_SUB(NOW(), INTERVAL 7 DAY)
AND event_type = 'POLICY_VIOLATION'

UNION ALL

SELECT 
    'Unique Data Accessors (Today)',
    COUNT(DISTINCT username),
    'count'
FROM comprehensive_audit_log 
WHERE DATE(event_timestamp) = CURRENT_DATE
AND event_type = 'DATA_ACCESS';

-- 9. 自動化タスク
CREATE EVENT IF NOT EXISTS cleanup_expired_permissions
ON SCHEDULE EVERY 1 HOUR
DO
  UPDATE unified_security_context 
  SET temporary_permissions = JSON_REMOVE(
      temporary_permissions,
      CONCAT('$."', 
             (SELECT JSON_UNQUOTE(JSON_EXTRACT(JSON_KEYS(temporary_permissions), '$[0]'))
              WHERE JSON_UNQUOTE(JSON_EXTRACT(temporary_permissions, CONCAT('$.', JSON_UNQUOTE(JSON_EXTRACT(JSON_KEYS(temporary_permissions), '$[0]')), '.expires_at'))) < NOW()
              LIMIT 1),
             '"')
  )
  WHERE temporary_permissions IS NOT NULL;

-- セキュリティダッシュボードの確認
SELECT * FROM v_security_dashboard;

-- テスト実行例
-- CALL setup_universal_row_level_security();
-- CALL generate_compliance_report('SECURITY_SUMMARY', '2025-05-01', '2025-05-31');
-- CALL delegate_temporary_permission('principal@localhost', 'teacher_tanaka@localhost', 
--      JSON_OBJECT('tables', JSON_ARRAY('students'), 'operations', JSON_ARRAY('SELECT')), 24, 'Emergency access');
```

## まとめ

この章では、MySQLにおける行レベルセキュリティの実装について詳しく学びました：

1. **行レベルセキュリティの基本概念**：
   - テーブルレベルを超えた細粒度なアクセス制御
   - ビュー、プロシージャ、関数を活用した実装手法
   - セキュリティコンテキストとポリシーの管理

2. **ビューによる行レベル制御**：
   - 基本的なセキュリティビューの作成
   - 複雑な条件を持つ動的フィルタリング
   - ユーザーコンテキストに基づく制御

3. **ストアドプロシージャによる高度な制御**：
   - ユーザーコンテキスト管理システム
   - 安全なデータアクセスプロシージャ
   - 動的セキュリティ制御の実装

4. **実践的なセキュリティシステム**：
   - 担任教師システム
   - 保護者アクセスシステム
   - 多階層権限管理

5. **パフォーマンスとセキュリティの両立**：
   - セキュリティビューの最適化
   - キャッシュ機能の実装
   - 監視システムの構築

6. **包括的なセキュリティフレームワーク**：
   - 統合セキュリティコンテキスト
   - 動的アクセスポリシー
   - 一時的権限委譲
   - 包括的な監査システム

行レベルセキュリティは、データベースセキュリティの最も細かいレベルでの制御を可能にします。**データの機密性を保ちつつ、業務効率を損なわない**バランスの取れた実装が重要です。また、セキュリティ制御が複雑になるほど、適切な監査とログ管理が不可欠になります。

次の章では、「データ暗号化：実用的なデータ保護手法」について学び、データそのものを保護する手法を理解していきます。