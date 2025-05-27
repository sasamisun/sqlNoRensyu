# 40. GRANT/REVOKE：権限の付与と取り消し

## はじめに

前章では、ユーザーとロールの基本的な作成・管理方法について学習しました。この章では、作成したユーザーやロールに対して具体的な権限を付与する「GRANT文」と、権限を取り消す「REVOKE文」について詳しく学習します。

権限管理は、データベースセキュリティの中核となる重要な機能です。学校システムを例に取ると、「教師は担当クラスの成績のみ変更できる」「学生は自分の成績のみ閲覧できる」「事務職員は学生の基本情報を管理できるが成績は見られない」といった、きめ細かな権限制御が必要になります。

GRANT/REVOKEが必要となる場面の例：
- 「新任の教師に成績入力権限を付与したい」
- 「退職する職員からすべての権限を取り消したい」
- 「臨時職員には期間限定で特定のテーブルの閲覧権限のみ与えたい」
- 「システム管理者から一部の危険な権限を一時的に取り消したい」
- 「部門異動により、職員の担当データへのアクセス権限を変更したい」
- 「外部監査のために、監査法人に読み取り専用権限を付与したい」
- 「セキュリティインシデント発生時に、該当ユーザーの権限を緊急停止したい」

この章では、基本的なGRANT/REVOKE文から、複雑な権限管理まで、実践的な例を通じて学習していきます。

## 権限管理の基本概念

### 権限の種類
MySQLでは、以下のような種類の権限が定義されています：

> **用語解説**：
> - **GRANT文**：ユーザーやロールに権限を付与するSQL文です。
> - **REVOKE文**：ユーザーやロールから権限を取り消すSQL文です。
> - **権限（Privilege）**：データベースで実行できる特定の操作を表します（SELECT、INSERT等）。
> - **グランター（Grantor）**：権限を付与する側のユーザーです。
> - **グランティー（Grantee）**：権限を付与される側のユーザーまたはロールです。
> - **WITH GRANT OPTION**：付与された権限を他のユーザーにさらに付与する権限です。
> - **権限の継承**：ロールからユーザーへ、またはロールから別のロールへ権限が継承される仕組みです。
> - **権限の累積**：複数の権限付与により、ユーザーが持つ権限が積み重なることです。
> - **最小権限の原則**：ユーザーには業務に必要な最小限の権限のみを付与するセキュリティの基本原則です。

### データベース権限の分類

| 権限カテゴリ | 主な権限 | 説明 |
|-------------|---------|------|
| **データ操作権限** | SELECT, INSERT, UPDATE, DELETE | テーブルのデータを操作する権限 |
| **構造管理権限** | CREATE, ALTER, DROP, INDEX | データベース構造を変更する権限 |
| **実行権限** | EXECUTE | ストアドプロシージャや関数を実行する権限 |
| **管理権限** | CREATE USER, GRANT OPTION, RELOAD | ユーザー管理やシステム管理の権限 |
| **特殊権限** | FILE, PROCESS, SUPER | ファイル操作やシステム制御の権限 |

### 権限の適用レベル

```
グローバルレベル：      GRANT SELECT ON *.* TO user;
データベースレベル：    GRANT SELECT ON database.* TO user;
テーブルレベル：        GRANT SELECT ON database.table TO user;
カラムレベル：          GRANT SELECT (column1, column2) ON database.table TO user;
```

## GRANT文の基本文法

### 1. 基本的なGRANT文

```sql
-- 基本文法
GRANT 権限 ON 対象 TO ユーザー [WITH GRANT OPTION];

-- 単一権限の付与
GRANT SELECT ON school_db.students TO 'teacher1'@'localhost';

-- 複数権限の同時付与
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'teacher1'@'localhost';

-- 全権限の付与
GRANT ALL PRIVILEGES ON school_db.* TO 'admin_user'@'localhost';
```

### 2. 学校システムでの基本的な権限付与例

```sql
-- 教師ユーザーに成績管理権限を付与
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'teacher_tanaka'@'localhost';
GRANT SELECT, INSERT, UPDATE ON school_db.attendance TO 'teacher_tanaka'@'localhost';
GRANT SELECT ON school_db.students TO 'teacher_tanaka'@'localhost';
GRANT SELECT ON school_db.courses TO 'teacher_tanaka'@'localhost';

-- 学生ユーザーに自分の情報閲覧権限を付与
GRANT SELECT ON school_db.students TO 'student_301'@'localhost';
GRANT SELECT ON school_db.grades TO 'student_301'@'localhost';
GRANT SELECT ON school_db.attendance TO 'student_301'@'localhost';

-- 事務職員に学生情報管理権限を付与
GRANT SELECT, INSERT, UPDATE ON school_db.students TO 'office_staff'@'localhost';
GRANT SELECT, INSERT, UPDATE ON school_db.student_courses TO 'office_staff'@'localhost';
GRANT SELECT ON school_db.courses TO 'office_staff'@'localhost';

-- 権限付与の確認
SHOW GRANTS FOR 'teacher_tanaka'@'localhost';
SHOW GRANTS FOR 'student_301'@'localhost';
SHOW GRANTS FOR 'office_staff'@'localhost';
```

### 3. カラムレベルの権限付与

```sql
-- 学生の個人情報の一部のみアクセス可能にする
GRANT SELECT (student_id, student_name) ON school_db.students TO 'limited_viewer'@'localhost';

-- 成績の特定項目のみ更新可能にする
GRANT UPDATE (score, submission_date) ON school_db.grades TO 'grade_assistant'@'localhost';

-- カラム権限と通常権限の組み合わせ
GRANT SELECT ON school_db.students TO 'counselor'@'localhost';
GRANT UPDATE (student_name, student_email) ON school_db.students TO 'counselor'@'localhost';

-- カラムレベル権限の確認
SHOW GRANTS FOR 'limited_viewer'@'localhost';
```

## REVOKE文の基本文法

### 1. 基本的なREVOKE文

```sql
-- 基本文法
REVOKE 権限 ON 対象 FROM ユーザー;

-- 単一権限の取り消し
REVOKE UPDATE ON school_db.grades FROM 'teacher1'@'localhost';

-- 複数権限の同時取り消し
REVOKE SELECT, INSERT ON school_db.students FROM 'temp_user'@'localhost';

-- 全権限の取り消し
REVOKE ALL PRIVILEGES ON school_db.* FROM 'old_admin'@'localhost';
```

### 2. 実践的な権限取り消し例

```sql
-- 退職した教師からすべての権限を取り消し
REVOKE ALL PRIVILEGES ON school_db.* FROM 'former_teacher'@'localhost';

-- 臨時職員から特定権限のみ取り消し
REVOKE INSERT, UPDATE, DELETE ON school_db.students FROM 'temp_staff'@'localhost';

-- 学生から一時的に閲覧権限を停止
REVOKE SELECT ON school_db.grades FROM 'suspended_student'@'localhost';

-- WITH GRANT OPTIONの取り消し
REVOKE GRANT OPTION ON school_db.* FROM 'supervisor'@'localhost';
```

## 実践的な権限管理シナリオ

### シナリオ1：新学期の教師権限設定

```sql
-- 新学期開始時の権限設定例

-- 1. 新任教師の基本権限設定
CREATE USER 'teacher_yamamoto'@'localhost' IDENTIFIED BY 'NewTeacher2025!';

-- 基本的な閲覧権限
GRANT SELECT ON school_db.students TO 'teacher_yamamoto'@'localhost';
GRANT SELECT ON school_db.courses TO 'teacher_yamamoto'@'localhost';
GRANT SELECT ON school_db.classrooms TO 'teacher_yamamoto'@'localhost';
GRANT SELECT ON school_db.class_periods TO 'teacher_yamamoto'@'localhost';

-- 担当講座の管理権限
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'teacher_yamamoto'@'localhost';
GRANT SELECT, INSERT, UPDATE ON school_db.attendance TO 'teacher_yamamoto'@'localhost';
GRANT SELECT, INSERT, UPDATE ON school_db.course_schedule TO 'teacher_yamamoto'@'localhost';

-- 2. 昇進した教師（学年主任）への追加権限
-- 従来の権限に加えて、学年全体の管理権限を追加
GRANT UPDATE ON school_db.student_courses TO 'teacher_promoted'@'localhost';
GRANT SELECT ON school_db.teacher_unavailability TO 'teacher_promoted'@'localhost';

-- 3. 兼任講師（パートタイム）の制限付き権限
CREATE USER 'parttime_lecturer'@'localhost' IDENTIFIED BY 'PartTime2025!';

-- 基本閲覧権限（制限付き）
GRANT SELECT ON school_db.students TO 'parttime_lecturer'@'localhost';
GRANT SELECT ON school_db.courses TO 'parttime_lecturer'@'localhost';

-- 担当講座のみの成績管理（UPDATEは制限）
GRANT SELECT, INSERT ON school_db.grades TO 'parttime_lecturer'@'localhost';
GRANT SELECT, INSERT ON school_db.attendance TO 'parttime_lecturer'@'localhost';

-- 接続制限も設定
ALTER USER 'parttime_lecturer'@'localhost' 
WITH MAX_USER_CONNECTIONS 2
     MAX_CONNECTIONS_PER_HOUR 50;

-- 設定した権限の確認
SHOW GRANTS FOR 'teacher_yamamoto'@'localhost';
SHOW GRANTS FOR 'teacher_promoted'@'localhost';
SHOW GRANTS FOR 'parttime_lecturer'@'localhost';
```

### シナリオ2：学期末の権限調整

```sql
-- 学期末の権限調整例

-- 1. 臨時職員の権限期限管理
-- 契約終了に伴う権限段階的削除

-- まず、データ変更権限を取り消し（閲覧は残す）
REVOKE INSERT, UPDATE, DELETE ON school_db.* FROM 'temp_assistant'@'localhost';

-- 一週間後に全権限を取り消し予定のため、制限を強化
ALTER USER 'temp_assistant'@'localhost' 
WITH MAX_CONNECTIONS_PER_HOUR 10
     MAX_USER_CONNECTIONS 1;

-- 2. 休職中の教師の権限一時停止
-- アカウントを無効化せずに権限のみ停止
REVOKE ALL PRIVILEGES ON school_db.* FROM 'teacher_on_leave'@'localhost';

-- 復帰予定があるため、ユーザーアカウントは維持
-- ALTER USER 'teacher_on_leave'@'localhost' ACCOUNT LOCK; -- 必要に応じて

-- 3. 成績確定後の権限制限
-- 成績変更期間終了後、教師から成績UPDATE権限を一時的に取り消し
REVOKE UPDATE ON school_db.grades FROM 'teacher_sato'@'localhost';
REVOKE UPDATE ON school_db.grades FROM 'teacher_tanaka'@'localhost';

-- 緊急時の成績修正が必要な場合に備え、管理者権限は維持
-- 必要時に再付与可能な状態を保持

-- 権限変更ログの記録
INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
VALUES 
    ('MODIFY', 'temp_assistant', 'localhost', 'temp_staff', USER(), 'Contract ending - reduced privileges'),
    ('MODIFY', 'teacher_on_leave', 'localhost', 'teacher', USER(), 'Medical leave - suspended privileges'),
    ('MODIFY', 'teacher_sato', 'localhost', 'teacher', USER(), 'Grade finalization - UPDATE revoked'),
    ('MODIFY', 'teacher_tanaka', 'localhost', 'teacher', USER(), 'Grade finalization - UPDATE revoked');
```

### シナリオ3：監査・検査対応の権限管理

```sql
-- 外部監査対応の特別権限設定

-- 1. 監査法人用の読み取り専用アカウント
CREATE USER 'audit_firm'@'192.168.100.%' 
IDENTIFIED BY 'AuditSecure2025!@#'
PASSWORD EXPIRE INTERVAL 30 DAY;

-- 必要なデータのみ閲覧権限を付与
GRANT SELECT ON school_db.students TO 'audit_firm'@'192.168.100.%';
GRANT SELECT ON school_db.grades TO 'audit_firm'@'192.168.100.%';
GRANT SELECT ON school_db.courses TO 'audit_firm'@'192.168.100.%';
GRANT SELECT ON school_db.teachers TO 'audit_firm'@'192.168.100.%';

-- システムログの閲覧権限（監査用）
GRANT SELECT ON mysql.general_log TO 'audit_firm'@'192.168.100.%';
GRANT SELECT ON information_schema.user_privileges TO 'audit_firm'@'192.168.100.%';

-- セッション数を制限
ALTER USER 'audit_firm'@'192.168.100.%' 
WITH MAX_USER_CONNECTIONS 3
     MAX_CONNECTIONS_PER_HOUR 100;

-- 2. 内部監査用の拡張権限アカウント
CREATE USER 'internal_auditor'@'localhost' 
IDENTIFIED BY 'InternalAudit2025!'
PASSWORD EXPIRE INTERVAL 60 DAY;

-- より広範囲なアクセス権限
GRANT SELECT ON school_db.* TO 'internal_auditor'@'localhost';
GRANT SELECT ON mysql.user TO 'internal_auditor'@'localhost';
GRANT SELECT ON performance_schema.accounts TO 'internal_auditor'@'localhost';

-- ユーザー管理ログの閲覧権限
GRANT SELECT ON school_db.user_management_log TO 'internal_auditor'@'localhost';

-- 3. 監査期間終了後の権限取り消し自動化
DELIMITER //

CREATE PROCEDURE revoke_audit_access()
BEGIN
    DECLARE audit_end_date DATE DEFAULT '2025-12-31';
    
    IF CURRENT_DATE > audit_end_date THEN
        -- 外部監査法人の権限を全て取り消し
        REVOKE ALL PRIVILEGES ON school_db.* FROM 'audit_firm'@'192.168.100.%';
        REVOKE ALL PRIVILEGES ON mysql.general_log FROM 'audit_firm'@'192.168.100.%';
        REVOKE ALL PRIVILEGES ON information_schema.user_privileges FROM 'audit_firm'@'192.168.100.%';
        
        -- アカウントをロック
        ALTER USER 'audit_firm'@'192.168.100.%' ACCOUNT LOCK;
        
        -- ログに記録
        INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
        VALUES ('REVOKE', 'audit_firm', '192.168.100.%', 'auditor', 'SYSTEM', 'Audit period ended - all privileges revoked');
        
        SELECT 'Audit access revoked successfully' as result;
    ELSE
        SELECT CONCAT('Audit period active until ', audit_end_date) as result;
    END IF;
END //

DELIMITER ;

-- 権限確認
SHOW GRANTS FOR 'audit_firm'@'192.168.100.%';
SHOW GRANTS FOR 'internal_auditor'@'localhost';
```

## WITH GRANT OPTIONの活用

### 1. 権限委譲の仕組み

```sql
-- WITH GRANT OPTIONの基本使用法
GRANT SELECT, INSERT, UPDATE ON school_db.students TO 'department_head'@'localhost' WITH GRANT OPTION;

-- 部門長が他のスタッフに権限を委譲
-- (department_headとしてログインした状態で実行)
-- GRANT SELECT ON school_db.students TO 'staff_member'@'localhost';

-- 2. 階層的な権限管理
-- 校長 → 教務主任 → 学年主任 → 一般教師

-- 校長への全権限付与（権限委譲可能）
GRANT ALL PRIVILEGES ON school_db.* TO 'principal'@'localhost' WITH GRANT OPTION;

-- 教務主任への成績管理権限付与（部下への権限委譲可能）
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'academic_director'@'localhost' WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON school_db.attendance TO 'academic_director'@'localhost' WITH GRANT OPTION;

-- 学年主任への制限付き委譲権限
GRANT SELECT ON school_db.students TO 'grade_supervisor'@'localhost' WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'grade_supervisor'@'localhost';
-- 注意：grade_supervisorはgradesの権限委譲はできない

-- 3. 委譲権限の管理と制限
CREATE VIEW v_grant_delegation AS
SELECT 
    grantor,
    grantee,
    table_schema,
    table_name,
    privilege_type,
    is_grantable
FROM information_schema.table_privileges
WHERE is_grantable = 'YES'
AND table_schema = 'school_db'
ORDER BY grantor, grantee;

-- 委譲状況の確認
SELECT * FROM v_grant_delegation;
```

### 2. GRANT OPTIONの取り消し

```sql
-- 特定の権限委譲能力のみ取り消し
REVOKE GRANT OPTION ON school_db.students FROM 'department_head'@'localhost';

-- 全ての権限委譲能力を取り消し
REVOKE ALL PRIVILEGES ON school_db.* FROM 'former_supervisor'@'localhost';

-- 委譲された権限の連鎖取り消し
-- 権限委譲者の権限を取り消すと、委譲された権限も自動的に取り消される場合がる
-- ただし、複数の経路で同じ権限が付与されている場合は残る

-- 安全な権限委譲取り消し手順
DELIMITER //

CREATE PROCEDURE safe_revoke_delegation(
    IN p_username VARCHAR(50),
    IN p_host VARCHAR(60)
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_grantee VARCHAR(100);
    
    -- 該当ユーザーが委譲した権限を受けているユーザーを取得
    DECLARE delegation_cursor CURSOR FOR
        SELECT DISTINCT grantee
        FROM information_schema.table_privileges
        WHERE grantor = CONCAT('''', p_username, '''@''', p_host, '''')
        AND is_grantable = 'YES'
        AND table_schema = 'school_db';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- 委譲関係をログに記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('AUDIT', p_username, p_host, 'delegation', USER(), 
            'Before revoking delegation - recording current state');
    
    OPEN delegation_cursor;
    
    read_loop: LOOP
        FETCH delegation_cursor INTO v_grantee;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 委譲関係をログに記録
        INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
        VALUES ('AUDIT', p_username, p_host, 'delegation', USER(), 
                CONCAT('Had delegated privileges to: ', v_grantee));
    END LOOP;
    
    CLOSE delegation_cursor;
    
    -- 実際の権限取り消し
    SET @sql = CONCAT('REVOKE ALL PRIVILEGES ON school_db.* FROM ''', p_username, '''@''', p_host, '''');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 最終ログ
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('REVOKE', p_username, p_host, 'delegation', USER(), 'All privileges and delegations revoked');
    
END //

DELIMITER ;

-- 使用例（コメントアウト）
-- CALL safe_revoke_delegation('department_head', 'localhost');
```

## 権限の確認と監査

### 1. 権限状況の確認方法

```sql
-- 1. 基本的な権限確認
SHOW GRANTS FOR 'teacher_tanaka'@'localhost';
SHOW GRANTS FOR CURRENT_USER();

-- 2. システム全体の権限状況確認
SELECT 
    grantee,
    table_schema,
    table_name,
    privilege_type,
    is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'school_db'
ORDER BY grantee, table_name, privilege_type;

-- 3. ユーザー別権限サマリー
SELECT 
    grantee,
    table_schema,
    COUNT(DISTINCT table_name) as accessible_tables,
    GROUP_CONCAT(DISTINCT privilege_type ORDER BY privilege_type) as privileges
FROM information_schema.table_privileges
WHERE table_schema = 'school_db'
GROUP BY grantee, table_schema
ORDER BY grantee;

-- 4. 危険な権限を持つユーザーの特定
SELECT DISTINCT
    grantee,
    privilege_type
FROM information_schema.user_privileges
WHERE privilege_type IN ('SUPER', 'CREATE USER', 'GRANT OPTION', 'FILE', 'PROCESS', 'RELOAD')
ORDER BY grantee, privilege_type;
```

### 2. 権限監査用ビューの作成

```sql
-- 包括的な権限監査ビュー
CREATE VIEW v_comprehensive_privileges AS
SELECT 
    'TABLE' as privilege_level,
    tp.grantee,
    tp.table_schema as db_name,
    tp.table_name as object_name,
    tp.privilege_type,
    tp.is_grantable,
    'N/A' as column_name
FROM information_schema.table_privileges tp
WHERE tp.table_schema NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys')

UNION ALL

SELECT 
    'COLUMN' as privilege_level,
    cp.grantee,
    cp.table_schema as db_name,
    cp.table_name as object_name,
    cp.privilege_type,
    cp.is_grantable,
    cp.column_name
FROM information_schema.column_privileges cp
WHERE cp.table_schema NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys')

UNION ALL

SELECT 
    'SCHEMA' as privilege_level,
    sp.grantee,
    sp.table_schema as db_name,
    'ALL_TABLES' as object_name,
    sp.privilege_type,
    sp.is_grantable,
    'N/A' as column_name
FROM information_schema.schema_privileges sp
WHERE sp.table_schema NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys')

UNION ALL

SELECT 
    'GLOBAL' as privilege_level,
    up.grantee,
    'GLOBAL' as db_name,
    'GLOBAL' as object_name,
    up.privilege_type,
    up.is_grantable,
    'N/A' as column_name
FROM information_schema.user_privileges up

ORDER BY grantee, privilege_level, db_name, object_name;

-- 監査レポートの生成
SELECT * FROM v_comprehensive_privileges WHERE grantee LIKE '%teacher%';

-- 権限統計レポート
SELECT 
    privilege_level,
    COUNT(DISTINCT grantee) as users_count,
    COUNT(*) as total_privileges,
    COUNT(CASE WHEN is_grantable = 'YES' THEN 1 END) as grantable_privileges
FROM v_comprehensive_privileges
WHERE db_name = 'school_db'
GROUP BY privilege_level
ORDER BY users_count DESC;
```

### 3. 権限変更履歴の管理

```sql
-- 権限変更履歴テーブル
CREATE TABLE privilege_change_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    change_type ENUM('GRANT', 'REVOKE') NOT NULL,
    grantee VARCHAR(100) NOT NULL,
    privilege_type VARCHAR(50) NOT NULL,
    object_type ENUM('GLOBAL', 'SCHEMA', 'TABLE', 'COLUMN') NOT NULL,
    object_name VARCHAR(200),
    column_name VARCHAR(64),
    is_grantable ENUM('YES', 'NO') DEFAULT 'NO',
    changed_by VARCHAR(100) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    
    INDEX idx_grantee (grantee),
    INDEX idx_change_date (changed_at),
    INDEX idx_change_type (change_type)
);

-- 権限変更記録プロシージャ
DELIMITER //

CREATE PROCEDURE log_privilege_change(
    IN p_change_type ENUM('GRANT', 'REVOKE'),
    IN p_grantee VARCHAR(100),
    IN p_privilege_type VARCHAR(50),
    IN p_object_type ENUM('GLOBAL', 'SCHEMA', 'TABLE', 'COLUMN'),
    IN p_object_name VARCHAR(200),
    IN p_column_name VARCHAR(64),
    IN p_is_grantable ENUM('YES', 'NO'),
    IN p_reason TEXT
)
BEGIN
    INSERT INTO privilege_change_log 
        (change_type, grantee, privilege_type, object_type, object_name, 
         column_name, is_grantable, changed_by, reason)
    VALUES 
        (p_change_type, p_grantee, p_privilege_type, p_object_type, p_object_name,
         p_column_name, p_is_grantable, USER(), p_reason);
END //

DELIMITER ;

-- 使用例
-- CALL log_privilege_change('GRANT', 'teacher_yamamoto@localhost', 'SELECT', 'TABLE', 'school_db.students', NULL, 'NO', 'New teacher onboarding');
-- CALL log_privilege_change('REVOKE', 'former_teacher@localhost', 'UPDATE', 'TABLE', 'school_db.grades', NULL, 'NO', 'Staff departure');

-- 権限変更履歴レポート
SELECT 
    change_type,
    grantee,
    privilege_type,
    object_name,
    changed_by,
    changed_at,
    reason
FROM privilege_change_log
WHERE changed_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
ORDER BY changed_at DESC;
```

## エラーと対処法

### 1. 権限不足エラー

```sql
-- エラー例1: 権限を付与する権限がない
-- GRANT SELECT ON school_db.students TO 'new_user'@'localhost';
-- エラー: ERROR 1044 (42000): Access denied for user 'regular_user'@'localhost' to database 'school_db'

-- 対処法1: 適切な権限を持つユーザーで実行
-- 管理者としてログインして実行

-- 対処法2: WITH GRANT OPTIONを持つユーザーで実行
-- GRANT SELECT ON school_db.students TO 'department_head'@'localhost' WITH GRANT OPTION;

-- 現在のユーザーの権限確認
SHOW GRANTS FOR CURRENT_USER();

-- 権限付与に必要な権限を確認
SELECT 
    grantee,
    table_schema,
    privilege_type,
    is_grantable
FROM information_schema.table_privileges
WHERE grantee = CONCAT('''', USER(), '''')
AND table_schema = 'school_db'
AND is_grantable = 'YES';
```

### 2. 存在しないユーザーやテーブルへの権限付与

```sql
-- エラー例2: 存在しないユーザーへの権限付与
-- GRANT SELECT ON school_db.students TO 'nonexistent_user'@'localhost';
-- エラー: ERROR 1133 (42000): Can't find any matching row in the user table

-- 対処法: ユーザーの存在確認と作成
SELECT COUNT(*) as user_exists
FROM mysql.user 
WHERE User = 'nonexistent_user' AND Host = 'localhost';

-- ユーザーが存在しない場合は作成
CREATE USER IF NOT EXISTS 'nonexistent_user'@'localhost' IDENTIFIED BY 'SecurePassword2025!';
GRANT SELECT ON school_db.students TO 'nonexistent_user'@'localhost';

-- エラー例3: 存在しないテーブルへの権限付与
-- GRANT SELECT ON school_db.nonexistent_table TO 'user'@'localhost';
-- エラー: ERROR 1146 (42S02): Table 'school_db.nonexistent_table' doesn't exist

-- 対処法: テーブルの存在確認
SELECT COUNT(*) as table_exists
FROM information_schema.tables
WHERE table_schema = 'school_db' AND table_name = 'nonexistent_table';

-- テーブル一覧の確認
SHOW TABLES FROM school_db;
```

### 3. 権限取り消し時のエラー

```sql
-- エラー例4: 存在しない権限の取り消し
-- REVOKE UPDATE ON school_db.students FROM 'user'@'localhost';
-- エラー: ERROR 1147 (42000): There is no such grant defined for user 'user' on host 'localhost'

-- 対処法: 現在の権限を確認してから取り消し
SHOW GRANTS FOR 'user'@'localhost';

-- 安全な権限取り消しプロシージャ
DELIMITER //

CREATE PROCEDURE safe_revoke_privilege(
    IN p_privilege VARCHAR(50),
    IN p_object VARCHAR(200),
    IN p_grantee VARCHAR(100)
)
BEGIN
    DECLARE privilege_exists INT DEFAULT 0;
    
    -- 権限の存在確認（テーブルレベル権限の場合）
    SELECT COUNT(*) INTO privilege_exists
    FROM information_schema.table_privileges
    WHERE CONCAT(grantee) = CONCAT('''', p_grantee, '''')
    AND CONCAT(table_schema, '.', table_name) = p_object
    AND privilege_type = p_privilege;
    
    IF privilege_exists > 0 THEN
        SET @sql = CONCAT('REVOKE ', p_privilege, ' ON ', p_object, ' FROM ', p_grantee);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SELECT CONCAT('Successfully revoked ', p_privilege, ' on ', p_object, ' from ', p_grantee) as result;
    ELSE
        SELECT CONCAT('Privilege ', p_privilege, ' on ', p_object, ' does not exist for ', p_grantee) as result;
    END IF;
END //

DELIMITER ;

-- 使用例
-- CALL safe_revoke_privilege('UPDATE', 'school_db.students', 'user@localhost');
```

### 4. 循環的な権限委譲

```sql
-- 権限委譲の循環参照を防ぐチェック関数
DELIMITER //

CREATE FUNCTION check_delegation_cycle(
    p_grantor VARCHAR(100),
    p_grantee VARCHAR(100)
) RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE cycle_exists BOOLEAN DEFAULT FALSE;
    
    -- 簡単な循環チェック: 付与先が付与元に権限を委譲しているかチェック
    SELECT COUNT(*) > 0 INTO cycle_exists
    FROM information_schema.table_privileges
    WHERE grantee = p_grantor
    AND grantor = p_grantee
    AND is_grantable = 'YES';
    
    RETURN cycle_exists;
END //

DELIMITER ;

-- 安全な権限委譲プロシージャ
DELIMITER //

CREATE PROCEDURE safe_grant_with_option(
    IN p_privilege VARCHAR(50),
    IN p_object VARCHAR(200),
    IN p_grantee VARCHAR(100)
)
BEGIN
    DECLARE current_user_str VARCHAR(100);
    DECLARE cycle_risk BOOLEAN DEFAULT FALSE;
    
    SET current_user_str = CONCAT('''', SUBSTRING_INDEX(USER(), '@', 1), '''@''', SUBSTRING_INDEX(USER(), '@', -1), '''');
    
    -- 循環参照チェック
    SELECT check_delegation_cycle(current_user_str, p_grantee) INTO cycle_risk;
    
    IF cycle_risk THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Delegation cycle detected - operation cancelled';
    ELSE
        SET @sql = CONCAT('GRANT ', p_privilege, ' ON ', p_object, ' TO ', p_grantee, ' WITH GRANT OPTION');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SELECT CONCAT('Successfully granted ', p_privilege, ' with delegation rights') as result;
    END IF;
END //

DELIMITER ;
```

## 高度な権限管理テクニック

### 1. 条件付き権限管理

```sql
-- 時間制限付き権限管理
CREATE TABLE temporary_privileges (
    temp_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    grantee VARCHAR(100) NOT NULL,
    privilege_type VARCHAR(50) NOT NULL,
    object_name VARCHAR(200) NOT NULL,
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    granted_by VARCHAR(100) NOT NULL,
    
    INDEX idx_expiry (expires_at, is_active),
    INDEX idx_grantee (grantee)
);

-- 一時的権限付与プロシージャ
DELIMITER //

CREATE PROCEDURE grant_temporary_privilege(
    IN p_privilege VARCHAR(50),
    IN p_object VARCHAR(200),
    IN p_grantee VARCHAR(100),
    IN p_duration_hours INT
)
BEGIN
    DECLARE expiry_time TIMESTAMP;
    
    SET expiry_time = DATE_ADD(NOW(), INTERVAL p_duration_hours HOUR);
    
    -- 実際に権限を付与
    SET @sql = CONCAT('GRANT ', p_privilege, ' ON ', p_object, ' TO ', p_grantee);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 一時権限テーブルに記録
    INSERT INTO temporary_privileges (grantee, privilege_type, object_name, expires_at, granted_by)
    VALUES (p_grantee, p_privilege, p_object, expiry_time, USER());
    
    SELECT CONCAT('Temporary privilege granted until ', expiry_time) as result;
END //

-- 期限切れ権限の自動取り消し
CREATE PROCEDURE revoke_expired_privileges()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_grantee VARCHAR(100);
    DECLARE v_privilege VARCHAR(50);
    DECLARE v_object VARCHAR(200);
    DECLARE v_temp_id BIGINT;
    
    DECLARE expired_cursor CURSOR FOR
        SELECT temp_id, grantee, privilege_type, object_name
        FROM temporary_privileges
        WHERE expires_at <= NOW()
        AND is_active = TRUE;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN expired_cursor;
    
    read_loop: LOOP
        FETCH expired_cursor INTO v_temp_id, v_grantee, v_privilege, v_object;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 権限を取り消し
        SET @sql = CONCAT('REVOKE ', v_privilege, ' ON ', v_object, ' FROM ', v_grantee);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        -- 記録を無効化
        UPDATE temporary_privileges 
        SET is_active = FALSE 
        WHERE temp_id = v_temp_id;
        
    END LOOP;
    
    CLOSE expired_cursor;
    
    SELECT CONCAT('Revoked ', ROW_COUNT(), ' expired privileges') as result;
END //

DELIMITER ;

-- 使用例（コメントアウト）
-- CALL grant_temporary_privilege('SELECT', 'school_db.grades', 'temp_auditor@localhost', 24); -- 24時間限定
-- CALL revoke_expired_privileges(); -- 期限切れ権限の一括取り消し
```

### 2. 動的権限管理

```sql
-- 役職ベース動的権限管理
CREATE TABLE role_privilege_mapping (
    mapping_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL,
    privilege_type VARCHAR(50) NOT NULL,
    object_pattern VARCHAR(200) NOT NULL,
    condition_sql TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_role_privilege (role_name, privilege_type, object_pattern)
);

-- 基本的な役職-権限マッピング
INSERT INTO role_privilege_mapping (role_name, privilege_type, object_pattern, condition_sql) VALUES
('teacher', 'SELECT', 'school_db.students', 'WHERE teacher_id = @current_teacher_id'),
('teacher', 'UPDATE', 'school_db.grades', 'WHERE course_id IN (SELECT course_id FROM courses WHERE teacher_id = @current_teacher_id)'),
('student', 'SELECT', 'school_db.grades', 'WHERE student_id = @current_student_id'),
('office_staff', 'UPDATE', 'school_db.students', 'WHERE student_id NOT IN (SELECT student_id FROM restricted_students)');

-- 動的権限適用プロシージャ
DELIMITER //

CREATE PROCEDURE apply_role_based_privileges(
    IN p_username VARCHAR(50),
    IN p_host VARCHAR(60),
    IN p_role VARCHAR(50)
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_privilege VARCHAR(50);
    DECLARE v_object VARCHAR(200);
    
    DECLARE privilege_cursor CURSOR FOR
        SELECT privilege_type, object_pattern
        FROM role_privilege_mapping
        WHERE role_name = p_role
        AND is_active = TRUE;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN privilege_cursor;
    
    read_loop: LOOP
        FETCH privilege_cursor INTO v_privilege, v_object;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 権限を付与
        SET @sql = CONCAT('GRANT ', v_privilege, ' ON ', v_object, ' TO ''', p_username, '''@''', p_host, '''');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
    END LOOP;
    
    CLOSE privilege_cursor;
    
    -- 適用ログ
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('GRANT', p_username, p_host, p_role, USER(), 
            CONCAT('Applied role-based privileges for role: ', p_role));
    
END //

DELIMITER ;
```

## 練習問題

### 問題40-1：基本的な権限付与
学校システムに以下の3つの新しいユーザーを作成し、それぞれに適切な権限を付与してください：
1. `lab_assistant`：実験助手（ローカルからのみアクセス）
   - `students`テーブルの閲覧権限
   - `courses`テーブルの閲覧権限
   - `grades`テーブルの実験科目のみ入力・更新権限
2. `guest_lecturer`：外部講師（学内ネットワーク192.168.1.%からアクセス）
   - `students`テーブルの名前と学籍番号のみ閲覧権限
   - `attendance`テーブルの入力権限
3. `data_analyst`：データ分析専門職（どこからでもアクセス可能）
   - 全テーブルの閲覧権限のみ
   - ただし個人情報関連カラムは除外

各ユーザーの権限付与後、`SHOW GRANTS`で確認してください。

### 問題40-2：段階的権限管理
以下のシナリオに沿って権限の付与・取り消しを実行してください：
1. `temp_teacher`（臨時教師）を作成し、基本的な閲覧権限のみ付与
2. 正式採用決定により、成績入力権限を追加付与
3. 担当クラス変更により、出席管理権限も追加付与
4. 契約期間終了により、データ変更権限をすべて取り消し（閲覧は維持）
5. 最終退職により、すべての権限を取り消し

各段階で権限の状況を確認し、変更前後の権限の違いを記録してください。

### 問題40-3：WITH GRANT OPTIONの活用
以下の階層的権限管理システムを構築してください：
1. `department_head`（学科長）に以下の権限を`WITH GRANT OPTION`で付与：
   - `teachers`テーブルの管理権限
   - `courses`テーブルの管理権限
   - `grades`テーブルの閲覧・更新権限
2. `department_head`として、部下の`senior_teacher`に権限を委譲：
   - `grades`テーブルの閲覧・更新権限（委譲権限なし）
   - `courses`テーブルの閲覧権限
3. 権限委譲の確認と、`department_head`の権限取り消しが`senior_teacher`に与える影響を検証

### 問題40-4：カラムレベル権限制御
個人情報保護を考慮した細かい権限制御を実装してください：
1. `privacy_officer`ユーザーを作成
2. `students`テーブルの以下のカラムのみアクセス権限を付与：
   - 閲覧権限：`student_id`, `student_name`
   - 更新権限：`student_email`（メールアドレス変更対応）
3. `research_assistant`ユーザーを作成
4. `grades`テーブルの以下のカラムのみアクセス権限を付与：
   - 閲覧権限：`course_id`, `grade_type`, `score`（個人特定情報は除外）
5. 設定した権限で実際にデータアクセスを試し、制限が正しく働くことを確認

### 問題40-5：監査対応権限管理
外部監査に対応するための一時的権限管理システムを作成してください：
1. 監査期間（30日間）限定のアクセス権限設定：
   - `external_auditor`ユーザーの作成（特定IPからのみアクセス）
   - 全テーブルの閲覧権限（個人情報は制限）
   - システムログの閲覧権限
2. 内部監査人`internal_auditor`向けの権限設定：
   - より広範囲なデータアクセス権限
   - ユーザー管理ログの閲覧権限
   - 権限変更履歴の閲覧権限
3. 監査終了時の権限自動取り消し機能の実装
4. 監査期間中の権限使用状況の記録・レポート機能

### 問題40-6：総合的な権限管理システム
学校システム全体の包括的な権限管理システムを設計・実装してください：
1. 以下の役職に対応した権限体系の構築：
   - 校長：全権限
   - 教務主任：成績・授業管理権限
   - 学年主任：担当学年の管理権限
   - 一般教師：担当クラス管理権限
   - 事務職員：学生情報管理権限
   - 保健担当：健康関連情報管理権限
   - 図書館司書：図書館システム管理権限
2. 動的権限管理機能：
   - 役職変更時の自動権限更新
   - 期間限定権限の自動管理
   - 異常なアクセスパターンの検知
3. 監査機能：
   - 全権限変更の履歴管理
   - 定期的な権限レビューレポート
   - セキュリティリスクの自動検出
4. 運用管理機能：
   - 権限付与・取り消しの承認ワークフロー
   - 一括権限管理機能
   - 緊急時の権限停止機能

## 解答

### 解答40-1
```sql
-- 1. lab_assistant（実験助手）の作成と権限付与
CREATE USER 'lab_assistant'@'localhost' 
IDENTIFIED BY 'LabAssistant2025!'
PASSWORD EXPIRE INTERVAL 120 DAY;

-- 基本閲覧権限
GRANT SELECT ON school_db.students TO 'lab_assistant'@'localhost';
GRANT SELECT ON school_db.courses TO 'lab_assistant'@'localhost';

-- 実験科目の成績管理権限（実際の運用では条件付きビューを使用することが多い）
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'lab_assistant'@'localhost';

-- 2. guest_lecturer（外部講師）の作成と権限付与
CREATE USER 'guest_lecturer'@'192.168.1.%' 
IDENTIFIED BY 'GuestLecturer2025!'
PASSWORD EXPIRE INTERVAL 90 DAY;

-- 学生の名前と学籍番号のみ閲覧権限（カラムレベル権限）
GRANT SELECT (student_id, student_name) ON school_db.students TO 'guest_lecturer'@'192.168.1.%';

-- 出席入力権限
GRANT SELECT, INSERT ON school_db.attendance TO 'guest_lecturer'@'192.168.1.%';

-- 3. data_analyst（データ分析専門職）の作成と権限付与
CREATE USER 'data_analyst'@'%' 
IDENTIFIED BY 'DataAnalyst2025!'
PASSWORD EXPIRE INTERVAL 180 DAY;

-- 全テーブル閲覧権限（個人情報関連カラムは除外）
GRANT SELECT ON school_db.courses TO 'data_analyst'@'%';
GRANT SELECT ON school_db.classrooms TO 'data_analyst'@'%';
GRANT SELECT ON school_db.class_periods TO 'data_analyst'@'%';
GRANT SELECT ON school_db.terms TO 'data_analyst'@'%';
GRANT SELECT ON school_db.course_schedule TO 'data_analyst'@'%';

-- 学生テーブルは個人情報を除外したカラムのみ
GRANT SELECT (student_id) ON school_db.students TO 'data_analyst'@'%';

-- 成績テーブルは統計分析用カラムのみ
GRANT SELECT (course_id, grade_type, score, max_score, submission_date) ON school_db.grades TO 'data_analyst'@'%';

-- 出席テーブルも個人特定情報を除外
GRANT SELECT (schedule_id, status) ON school_db.attendance TO 'data_analyst'@'%';

-- 接続制限の設定
ALTER USER 'data_analyst'@'%' 
WITH MAX_USER_CONNECTIONS 3
     MAX_CONNECTIONS_PER_HOUR 100;

-- 権限確認
SHOW GRANTS FOR 'lab_assistant'@'localhost';
SHOW GRANTS FOR 'guest_lecturer'@'192.168.1.%';
SHOW GRANTS FOR 'data_analyst'@'%';

-- 作成したユーザーの一覧確認
SELECT 
    User as username,
    Host as allowed_host,
    account_locked,
    password_expired,
    max_user_connections
FROM mysql.user 
WHERE User IN ('lab_assistant', 'guest_lecturer', 'data_analyst')
ORDER BY User;
```

### 解答40-2
```sql
-- 段階的権限管理シナリオ

-- 1. temp_teacher（臨時教師）の作成と基本権限付与
CREATE USER 'temp_teacher'@'localhost' 
IDENTIFIED BY 'TempTeacher2025!'
PASSWORD EXPIRE INTERVAL 90 DAY;

-- 基本閲覧権限のみ
GRANT SELECT ON school_db.students TO 'temp_teacher'@'localhost';
GRANT SELECT ON school_db.courses TO 'temp_teacher'@'localhost';
GRANT SELECT ON school_db.classrooms TO 'temp_teacher'@'localhost';

-- 初期権限の確認
SELECT 'Step 1: Basic privileges only' as stage;
SHOW GRANTS FOR 'temp_teacher'@'localhost';

-- 2. 正式採用決定により成績入力権限を追加
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'temp_teacher'@'localhost';

-- 権限追加後の確認
SELECT 'Step 2: Added grade management privileges' as stage;
SHOW GRANTS FOR 'temp_teacher'@'localhost';

-- 3. 担当クラス変更により出席管理権限も追加
GRANT SELECT, INSERT, UPDATE ON school_db.attendance TO 'temp_teacher'@'localhost';
GRANT SELECT, INSERT, UPDATE ON school_db.course_schedule TO 'temp_teacher'@'localhost';

-- 権限追加後の確認
SELECT 'Step 3: Added attendance management privileges' as stage;
SHOW GRANTS FOR 'temp_teacher'@'localhost';

-- 4. 契約期間終了により、データ変更権限をすべて取り消し（閲覧は維持）
REVOKE INSERT, UPDATE ON school_db.grades FROM 'temp_teacher'@'localhost';
REVOKE INSERT, UPDATE ON school_db.attendance FROM 'temp_teacher'@'localhost';
REVOKE INSERT, UPDATE ON school_db.course_schedule FROM 'temp_teacher'@'localhost';

-- 権限取り消し後の確認
SELECT 'Step 4: Revoked modification privileges, kept read access' as stage;
SHOW GRANTS FOR 'temp_teacher'@'localhost';

-- 5. 最終退職により、すべての権限を取り消し
REVOKE ALL PRIVILEGES ON school_db.* FROM 'temp_teacher'@'localhost';

-- 最終状態の確認
SELECT 'Step 5: All privileges revoked' as stage;
SHOW GRANTS FOR 'temp_teacher'@'localhost';

-- 各段階の記録用テーブル作成とログ
CREATE TABLE IF NOT EXISTS privilege_change_demo_log (
    step_number INT,
    stage_description VARCHAR(200),
    privileges_granted TEXT,
    privileges_revoked TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 段階的変更の記録
INSERT INTO privilege_change_demo_log (step_number, stage_description, privileges_granted) VALUES
(1, 'Basic privileges only', 'SELECT on students, courses, classrooms'),
(2, 'Added grade management', 'SELECT, INSERT, UPDATE on grades'),
(3, 'Added attendance management', 'SELECT, INSERT, UPDATE on attendance, course_schedule'),
(4, 'Contract ending - revoked modifications', NULL),
(5, 'Final departure - all revoked', NULL);

UPDATE privilege_change_demo_log SET privileges_revoked = 'INSERT, UPDATE on grades, attendance, course_schedule' WHERE step_number = 4;
UPDATE privilege_change_demo_log SET privileges_revoked = 'ALL PRIVILEGES' WHERE step_number = 5;

-- ログの確認
SELECT * FROM privilege_change_demo_log ORDER BY step_number;
```

### 解答40-3
```sql
-- WITH GRANT OPTIONの活用例

-- 1. department_head（学科長）の作成とWITH GRANT OPTION権限付与
CREATE USER 'department_head'@'localhost' 
IDENTIFIED BY 'DeptHead2025!'
PASSWORD EXPIRE INTERVAL 60 DAY;

-- 権限委譲可能な権限を付与
GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.teachers TO 'department_head'@'localhost' WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.courses TO 'department_head'@'localhost' WITH GRANT OPTION;
GRANT SELECT, UPDATE ON school_db.grades TO 'department_head'@'localhost' WITH GRANT OPTION;

-- 学科長の権限確認
SELECT 'Department Head privileges with GRANT OPTION:' as status;
SHOW GRANTS FOR 'department_head'@'localhost';

-- 2. senior_teacher（上級教師）の作成
CREATE USER 'senior_teacher'@'localhost' 
IDENTIFIED BY 'SeniorTeacher2025!'
PASSWORD EXPIRE INTERVAL 90 DAY;

-- 3. department_headとして権限を委譲（実際の運用では学科長としてログインして実行）
-- ここでは管理者として代理実行し、委譲のシミュレーションを行う

-- senior_teacherに権限委譲（委譲権限なし）
GRANT SELECT, UPDATE ON school_db.grades TO 'senior_teacher'@'localhost';
GRANT SELECT ON school_db.courses TO 'senior_teacher'@'localhost';

-- 委譲記録用のログ
INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
VALUES ('GRANT', 'senior_teacher', 'localhost', 'teacher', 'department_head@localhost', 
        'Delegated by department head: grades SELECT/UPDATE, courses SELECT');

-- 委譲後の権限確認
SELECT 'Senior Teacher privileges (delegated):' as status;
SHOW GRANTS FOR 'senior_teacher'@'localhost';

-- 4. 権限委譲状況の確認
SELECT 
    grantee,
    table_schema,
    table_name,
    privilege_type,
    is_grantable,
    'Current delegation status' as note
FROM information_schema.table_privileges
WHERE grantee IN ('''department_head''@''localhost''', '''senior_teacher''@''localhost''')
AND table_schema = 'school_db'
ORDER BY grantee, table_name, privilege_type;

-- 5. department_headの権限取り消しによる影響検証

-- まず現在の委譲状況を記録
CREATE TEMPORARY TABLE delegation_before AS
SELECT 
    grantee,
    table_schema,
    table_name,
    privilege_type,
    is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'school_db'
AND (grantee LIKE '%department_head%' OR grantee LIKE '%senior_teacher%');

SELECT 'Before revoking department_head privileges:' as status;
SELECT * FROM delegation_before;

-- department_headの権限を取り消し
REVOKE ALL PRIVILEGES ON school_db.* FROM 'department_head'@'localhost';

-- 取り消し後の状況確認
SELECT 'After revoking department_head privileges:' as status;
SELECT 
    grantee,
    table_schema,
    table_name,
    privilege_type,
    is_grantable,
    'After revocation' as note
FROM information_schema.table_privileges
WHERE table_schema = 'school_db'
AND (grantee LIKE '%department_head%' OR grantee LIKE '%senior_teacher%')
ORDER BY grantee, table_name, privilege_type;

-- senior_teacherの権限が残っているか確認
SHOW GRANTS FOR 'senior_teacher'@'localhost';

-- 影響分析レポート
SELECT 
    'GRANT OPTION Impact Analysis' as report_type,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM information_schema.table_privileges 
            WHERE grantee = '''senior_teacher''@''localhost''' 
            AND table_schema = 'school_db'
        ) THEN 'senior_teacher privileges RETAINED (direct grant or other grantor)'
        ELSE 'senior_teacher privileges REVOKED (dependent on department_head)'
    END as impact_result;
```

### 解答40-4
```sql
-- カラムレベル権限制御の実装

-- 1. privacy_officer（個人情報保護担当）ユーザーの作成
CREATE USER 'privacy_officer'@'localhost' 
IDENTIFIED BY 'PrivacyOfficer2025!'
PASSWORD EXPIRE INTERVAL 90 DAY;

-- studentsテーブルの制限付きアクセス権限
GRANT SELECT (student_id, student_name) ON school_db.students TO 'privacy_officer'@'localhost';
GRANT UPDATE (student_email) ON school_db.students TO 'privacy_officer'@'localhost';

-- 2. research_assistant（研究助手）ユーザーの作成
CREATE USER 'research_assistant'@'localhost' 
IDENTIFIED BY 'ResearchAssist2025!'
PASSWORD EXPIRE INTERVAL 120 DAY;

-- gradesテーブルの統計分析用アクセス権限（個人特定情報は除外）
GRANT SELECT (course_id, grade_type, score, max_score, submission_date) ON school_db.grades TO 'research_assistant'@'localhost';

-- 統計分析に必要な関連テーブルの権限
GRANT SELECT ON school_db.courses TO 'research_assistant'@'localhost';
GRANT SELECT ON school_db.terms TO 'research_assistant'@'localhost';

-- 3. 設定した権限の確認
SELECT 'Privacy Officer column-level privileges:' as user_type;
SHOW GRANTS FOR 'privacy_officer'@'localhost';

SELECT 'Research Assistant column-level privileges:' as user_type;
SHOW GRANTS FOR 'research_assistant'@'localhost';

-- 4. カラムレベル権限の詳細確認
SELECT 
    grantee,
    table_schema,
    table_name,
    column_name,
    privilege_type,
    is_grantable
FROM information_schema.column_privileges
WHERE table_schema = 'school_db'
AND grantee IN ('''privacy_officer''@''localhost''', '''research_assistant''@''localhost''')
ORDER BY grantee, table_name, column_name;

-- 5. 権限制限の動作確認用テストクエリ（実際には各ユーザーでログインして実行）

-- privacy_officerでアクセス可能なクエリ例
SELECT 'Test queries for privacy_officer (would work):' as test_type;
-- SELECT student_id, student_name FROM school_db.students LIMIT 5;
-- UPDATE school_db.students SET student_email = 'new@example.com' WHERE student_id = 301;

-- privacy_officerで制限されるクエリ例
SELECT 'Test queries for privacy_officer (would FAIL):' as test_type;
-- SELECT * FROM school_db.students; -- エラー: アクセス権限のないカラムを含む
-- UPDATE school_db.students SET student_name = 'New Name' WHERE student_id = 301; -- エラー: 更新権限なし

-- research_assistantでアクセス可能なクエリ例
SELECT 'Test queries for research_assistant (would work):' as test_type;
-- SELECT course_id, AVG(score) as avg_score FROM school_db.grades GROUP BY course_id;
-- SELECT grade_type, COUNT(*) as count FROM school_db.grades GROUP BY grade_type;

-- research_assistantで制限されるクエリ例
SELECT 'Test queries for research_assistant (would FAIL):' as test_type;
-- SELECT student_id, score FROM school_db.grades; -- エラー: student_idカラムへのアクセス権限なし
-- INSERT INTO school_db.grades (...) VALUES (...); -- エラー: INSERT権限なし

-- 6. カラムレベル権限の監視用ビュー
CREATE VIEW v_column_level_privileges AS
SELECT 
    cp.grantee,
    cp.table_schema,
    cp.table_name,
    cp.column_name,
    cp.privilege_type,
    cp.is_grantable,
    'COLUMN' as privilege_level
FROM information_schema.column_privileges cp
WHERE cp.table_schema = 'school_db'

UNION ALL

SELECT 
    tp.grantee,
    tp.table_schema,
    tp.table_name,
    'ALL_COLUMNS' as column_name,
    tp.privilege_type,
    tp.is_grantable,
    'TABLE' as privilege_level
FROM information_schema.table_privileges tp
WHERE tp.table_schema = 'school_db'

ORDER BY grantee, table_name, privilege_level, column_name;

-- カラムレベル権限の現状確認
SELECT * FROM v_column_level_privileges 
WHERE grantee IN ('''privacy_officer''@''localhost''', '''research_assistant''@''localhost''');

-- 7. セキュリティ検証レポート
SELECT 
    'Column-Level Security Verification' as report_title,
    COUNT(DISTINCT grantee) as users_with_column_restrictions,
    COUNT(*) as total_column_privileges,
    COUNT(CASE WHEN privilege_type = 'SELECT' THEN 1 END) as read_only_columns,
    COUNT(CASE WHEN privilege_type = 'UPDATE' THEN 1 END) as updateable_columns
FROM information_schema.column_privileges
WHERE table_schema = 'school_db';
```

### 解答40-5
```sql
-- 監査対応権限管理システム

-- 1. 外部監査用の一時的権限設定

-- 外部監査人ユーザーの作成（特定IPからのみアクセス）
CREATE USER 'external_auditor'@'192.168.100.%' 
IDENTIFIED BY 'ExternalAudit2025!@#'
PASSWORD EXPIRE INTERVAL 30 DAY
WITH MAX_USER_CONNECTIONS 2
     MAX_CONNECTIONS_PER_HOUR 50;

-- 全テーブル閲覧権限（個人情報制限付き）
GRANT SELECT ON school_db.courses TO 'external_auditor'@'192.168.100.%';
GRANT SELECT ON school_db.teachers TO 'external_auditor'@'192.168.100.%';
GRANT SELECT ON school_db.classrooms TO 'external_auditor'@'192.168.100.%';
GRANT SELECT ON school_db.terms TO 'external_auditor'@'192.168.100.%';
GRANT SELECT ON school_db.course_schedule TO 'external_auditor'@'192.168.100.%';

-- 個人情報を除外したカラムのみアクセス
GRANT SELECT (student_id) ON school_db.students TO 'external_auditor'@'192.168.100.%';
GRANT SELECT (course_id, grade_type, score, max_score, submission_date) ON school_db.grades TO 'external_auditor'@'192.168.100.%';
GRANT SELECT (schedule_id, status) ON school_db.attendance TO 'external_auditor'@'192.168.100.%';

-- システムログ閲覧権限
GRANT SELECT ON mysql.general_log TO 'external_auditor'@'192.168.100.%';
GRANT SELECT ON information_schema.table_privileges TO 'external_auditor'@'192.168.100.%';
GRANT SELECT ON information_schema.user_privileges TO 'external_auditor'@'192.168.100.%';

-- 2. 内部監査人の権限設定
CREATE USER 'internal_auditor'@'localhost' 
IDENTIFIED BY 'InternalAudit2025!'
PASSWORD EXPIRE INTERVAL 60 DAY;

-- より広範囲なデータアクセス権限
GRANT SELECT ON school_db.* TO 'internal_auditor'@'localhost';

-- システム管理関連の権限
GRANT SELECT ON mysql.user TO 'internal_auditor'@'localhost';
GRANT SELECT ON mysql.db TO 'internal_auditor'@'localhost';
GRANT SELECT ON performance_schema.accounts TO 'internal_auditor'@'localhost';

-- ユーザー管理ログの閲覧権限
GRANT SELECT ON school_db.user_management_log TO 'internal_auditor'@'localhost';

-- 3. 監査期間管理テーブル
CREATE TABLE audit_periods (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    audit_type ENUM('external', 'internal') NOT NULL,
    auditor_user VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    
    INDEX idx_end_date (end_date, is_active),
    INDEX idx_auditor (auditor_user)
);

-- 監査期間の登録
INSERT INTO audit_periods (audit_type, auditor_user, start_date, end_date, created_by, notes) VALUES
('external', 'external_auditor@192.168.100.%', CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), USER(), 'Annual external audit'),
('internal', 'internal_auditor@localhost', CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 90 DAY), USER(), 'Quarterly internal audit');

-- 4. 監査期間終了時の自動権限取り消し機能
DELIMITER //

CREATE PROCEDURE auto_revoke_audit_access()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_auditor_user VARCHAR(100);
    DECLARE v_audit_type ENUM('external', 'internal');
    DECLARE v_audit_id INT;
    
    DECLARE expired_audits CURSOR FOR
        SELECT audit_id, audit_type, auditor_user
        FROM audit_periods
        WHERE end_date <= CURRENT_DATE
        AND is_active = TRUE;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN expired_audits;
    
    audit_loop: LOOP
        FETCH expired_audits INTO v_audit_id, v_audit_type, v_auditor_user;
        IF done THEN
            LEAVE audit_loop;
        END IF;
        
        -- 外部監査人の権限取り消し
        IF v_audit_type = 'external' THEN
            -- 全権限を取り消し
            SET @sql = CONCAT('REVOKE ALL PRIVILEGES ON school_db.* FROM ', v_auditor_user);
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            
            SET @sql = CONCAT('REVOKE ALL PRIVILEGES ON mysql.general_log FROM ', v_auditor_user);
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            
            -- アカウントをロック
            SET @sql = CONCAT('ALTER USER ', v_auditor_user, ' ACCOUNT LOCK');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END IF;
        
        -- 内部監査人は権限を減らすが完全には取り消さない
        IF v_audit_type = 'internal' THEN
            -- 管理者権限のみ取り消し
            SET @sql = CONCAT('REVOKE SELECT ON mysql.user FROM ', v_auditor_user);
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END IF;
        
        -- 監査期間を無効化
        UPDATE audit_periods SET is_active = FALSE WHERE audit_id = v_audit_id;
        
        -- ログ記録
        INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
        VALUES ('REVOKE', SUBSTRING_INDEX(v_auditor_user, '@', 1), SUBSTRING_INDEX(v_auditor_user, '@', -1), 
                v_audit_type, 'AUTO_SYSTEM', CONCAT('Audit period ended - privileges auto-revoked'));
    
    END LOOP;
    
    CLOSE expired_audits;
    
    SELECT CONCAT('Processed ', ROW_COUNT(), ' expired audit periods') as result;
END //

DELIMITER ;

-- 5. 監査期間中の権限使用状況記録
CREATE TABLE audit_access_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    auditor_user VARCHAR(100) NOT NULL,
    accessed_table VARCHAR(100),
    query_type ENUM('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'OTHER') NOT NULL,
    access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    query_hash VARCHAR(64), -- クエリのハッシュ値（プライバシー保護）
    row_count INT,
    
    INDEX idx_auditor_time (auditor_user, access_time),
    INDEX idx_access_time (access_time)
);

-- 監査アクセス記録プロシージャ
DELIMITER //

CREATE PROCEDURE log_audit_access(
    IN p_auditor_user VARCHAR(100),
    IN p_table_name VARCHAR(100),
    IN p_query_type ENUM('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'OTHER'),
    IN p_row_count INT
)
BEGIN
    INSERT INTO audit_access_log (auditor_user, accessed_table, query_type, row_count)
    VALUES (p_auditor_user, p_table_name, p_query_type, p_row_count);
END //

DELIMITER ;

-- 6. 監査レポート生成
CREATE VIEW v_audit_activity_report AS
SELECT 
    ap.audit_type,
    ap.auditor_user,
    ap.start_date,
    ap.end_date,
    ap.is_active,
    COALESCE(access_stats.total_accesses, 0) as total_accesses,
    COALESCE(access_stats.unique_tables, 0) as unique_tables_accessed,
    COALESCE(access_stats.total_rows_accessed, 0) as total_rows_accessed
FROM audit_periods ap
LEFT JOIN (
    SELECT 
        auditor_user,
        COUNT(*) as total_accesses,
        COUNT(DISTINCT accessed_table) as unique_tables,
        SUM(row_count) as total_rows_accessed
    FROM audit_access_log
    GROUP BY auditor_user
) access_stats ON ap.auditor_user = access_stats.auditor_user
ORDER BY ap.start_date DESC;

-- 監査状況の確認
SELECT * FROM v_audit_activity_report;

-- 現在アクティブな監査の確認
SELECT 
    audit_type,
    auditor_user,
    DATEDIFF(end_date, CURRENT_DATE) as days_remaining,
    CASE 
        WHEN end_date <= CURRENT_DATE THEN 'EXPIRED'
        WHEN DATEDIFF(end_date, CURRENT_DATE) <= 7 THEN 'EXPIRES_SOON'
        ELSE 'ACTIVE'
    END as status
FROM audit_periods
WHERE is_active = TRUE
ORDER BY end_date;

-- 権限確認
SHOW GRANTS FOR 'external_auditor'@'192.168.100.%';
SHOW GRANTS FOR 'internal_auditor'@'localhost';

-- 定期実行用（管理者が定期的に実行）
-- CALL auto_revoke_audit_access();
```

### 解答40-6
```sql
-- 総合的な権限管理システム

-- 1. 役職体系に対応したロールの作成
CREATE ROLE 'principal_role';           -- 校長
CREATE ROLE 'academic_director_role';   -- 教務主任
CREATE ROLE 'grade_supervisor_role';    -- 学年主任
CREATE ROLE 'general_teacher_role';     -- 一般教師
CREATE ROLE 'office_staff_role';        -- 事務職員
CREATE ROLE 'health_coordinator_role';  -- 保健担当
CREATE ROLE 'librarian_role';           -- 図書館司書

-- 2. 各ロールの権限設定

-- 校長：全権限
GRANT ALL PRIVILEGES ON school_db.* TO 'principal_role';
GRANT CREATE USER, DROP USER ON *.* TO 'principal_role';

-- 教務主任：成績・授業管理権限
GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.grades TO 'academic_director_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.attendance TO 'academic_director_role';
GRANT SELECT, INSERT, UPDATE ON school_db.courses TO 'academic_director_role';
GRANT SELECT, INSERT, UPDATE ON school_db.course_schedule TO 'academic_director_role';
GRANT SELECT ON school_db.students TO 'academic_director_role';
GRANT SELECT ON school_db.teachers TO 'academic_director_role';

-- 学年主任：担当学年の管理権限
GRANT SELECT, UPDATE ON school_db.students TO 'grade_supervisor_role';
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'grade_supervisor_role';
GRANT SELECT, INSERT, UPDATE ON school_db.attendance TO 'grade_supervisor_role';
GRANT SELECT ON school_db.courses TO 'grade_supervisor_role';

-- 一般教師：担当クラス管理権限
GRANT SELECT ON school_db.students TO 'general_teacher_role';
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'general_teacher_role';
GRANT SELECT, INSERT, UPDATE ON school_db.attendance TO 'general_teacher_role';
GRANT SELECT ON school_db.courses TO 'general_teacher_role';

-- 事務職員：学生情報管理権限
GRANT SELECT, INSERT, UPDATE ON school_db.students TO 'office_staff_role';
GRANT SELECT, INSERT, UPDATE ON school_db.student_courses TO 'office_staff_role';
GRANT SELECT ON school_db.courses TO 'office_staff_role';
GRANT SELECT ON school_db.teachers TO 'office_staff_role';

-- 保健担当：健康関連情報管理権限
GRANT SELECT ON school_db.students TO 'health_coordinator_role';
-- 健康管理テーブルがある場合の例
-- GRANT SELECT, INSERT, UPDATE ON school_db.health_records TO 'health_coordinator_role';

-- 図書館司書：図書館システム管理権限
GRANT SELECT ON school_db.students TO 'librarian_role';
-- 図書館管理テーブルがある場合の例
-- GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.books TO 'librarian_role';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.book_loans TO 'librarian_role';

-- 3. 役職管理テーブル
CREATE TABLE staff_positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    user_account VARCHAR(100) NOT NULL,
    position_type ENUM('principal', 'academic_director', 'grade_supervisor', 'general_teacher', 
                      'office_staff', 'health_coordinator', 'librarian') NOT NULL,
    role_name VARCHAR(50) NOT NULL,
    department VARCHAR(100),
    grade_level INT, -- 学年主任の場合の担当学年
    start_date DATE NOT NULL,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    updated_by VARCHAR(100),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_active_position (user_account, position_type, is_active),
    INDEX idx_position_type (position_type),
    INDEX idx_active_positions (is_active, end_date)
);

-- 4. 動的権限管理機能
DELIMITER //

-- 役職変更時の自動権限更新
CREATE PROCEDURE update_staff_position(
    IN p_user_account VARCHAR(100),
    IN p_old_position ENUM('principal', 'academic_director', 'grade_supervisor', 'general_teacher', 
                          'office_staff', 'health_coordinator', 'librarian'),
    IN p_new_position ENUM('principal', 'academic_director', 'grade_supervisor', 'general_teacher', 
                          'office_staff', 'health_coordinator', 'librarian'),
    IN p_department VARCHAR(100),
    IN p_grade_level INT
)
BEGIN
    DECLARE v_old_role VARCHAR(50);
    DECLARE v_new_role VARCHAR(50);
    
    -- 役職に対応するロール名を設定
    SET v_old_role = CONCAT(p_old_position, '_role');
    SET v_new_role = CONCAT(p_new_position, '_role');
    
    -- 古い役職の記録を無効化
    UPDATE staff_positions 
    SET is_active = FALSE, end_date = CURRENT_DATE, updated_by = USER()
    WHERE user_account = p_user_account AND position_type = p_old_position AND is_active = TRUE;
    
    -- 新しい役職の記録を追加
    INSERT INTO staff_positions (user_account, position_type, role_name, department, grade_level, start_date, updated_by)
    VALUES (p_user_account, p_new_position, v_new_role, p_department, p_grade_level, CURRENT_DATE, USER());
    
    -- 古いロールを取り消し
    SET @sql = CONCAT('REVOKE ''', v_old_role, ''' FROM ', p_user_account);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 新しいロールを付与
    SET @sql = CONCAT('GRANT ''', v_new_role, ''' TO ', p_user_account);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- デフォルトロールを更新
    SET @sql = CONCAT('ALTER USER ', p_user_account, ' DEFAULT ROLE ALL');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 変更ログを記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('MODIFY', SUBSTRING_INDEX(p_user_account, '@', 1), SUBSTRING_INDEX(p_user_account, '@', -1),
            p_new_position, USER(), 
            CONCAT('Position changed from ', p_old_position, ' to ', p_new_position));
    
    SELECT CONCAT('Successfully updated position from ', p_old_position, ' to ', p_new_position) as result;
END //

-- 期間限定権限の管理
CREATE PROCEDURE grant_temporary_role_privilege(
    IN p_user_account VARCHAR(100),
    IN p_additional_role VARCHAR(50),
    IN p_duration_days INT,
    IN p_reason TEXT
)
BEGIN
    DECLARE expiry_date DATE;
    
    SET expiry_date = DATE_ADD(CURRENT_DATE, INTERVAL p_duration_days DAY);
    
    -- 追加ロールを付与
    SET @sql = CONCAT('GRANT ''', p_additional_role, ''' TO ', p_user_account);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 一時権限記録
    INSERT INTO temporary_privileges (grantee, privilege_type, object_name, expires_at, granted_by, notes)
    VALUES (p_user_account, 'ROLE', p_additional_role, 
            TIMESTAMP(expiry_date), USER(), p_reason);
    
    SELECT CONCAT('Granted temporary role ', p_additional_role, ' until ', expiry_date) as result;
END //

-- 異常なアクセスパターンの検知
CREATE PROCEDURE detect_unusual_access_patterns()
BEGIN
    DECLARE unusual_activity_found BOOLEAN DEFAULT FALSE;
    
    -- 深夜の大量アクセス検知
    SELECT COUNT(*) > 0 INTO unusual_activity_found
    FROM information_schema.processlist p
    WHERE TIME(NOW()) BETWEEN '22:00:00' AND '06:00:00'
    AND p.User NOT IN ('root', 'mysql.sys', 'mysql.session')
    AND p.Command != 'Sleep'
    GROUP BY p.User
    HAVING COUNT(*) > 10;
    
    IF unusual_activity_found THEN
        INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
        VALUES ('ALERT', 'SYSTEM', 'SYSTEM', 'security', 'AUTO_MONITOR', 
                'Unusual access pattern detected - high activity during off-hours');
    END IF;
    
    -- 権限昇格の検知
    SELECT COUNT(*) > 0 INTO unusual_activity_found
    FROM mysql.general_log
    WHERE event_time >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
    AND argument LIKE '%GRANT%'
    AND user_host NOT LIKE '%root%';
    
    IF unusual_activity_found THEN
        INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
        VALUES ('ALERT', 'SYSTEM', 'SYSTEM', 'security', 'AUTO_MONITOR', 
                'Privilege escalation activity detected');
    END IF;
    
END //

DELIMITER ;

-- 5. 監査機能

-- 包括的権限監査ビュー
CREATE VIEW v_comprehensive_privilege_audit AS
SELECT 
    sp.user_account,
    sp.position_type,
    sp.role_name,
    sp.department,
    sp.grade_level,
    sp.start_date,
    sp.end_date,
    sp.is_active as position_active,
    tp.privilege_type as table_privilege,
    tp.table_name,
    tp.is_grantable,
    CASE 
        WHEN tp.grantee IS NULL THEN 'NO_TABLE_PRIVILEGES'
        ELSE 'HAS_TABLE_PRIVILEGES'
    END as privilege_status
FROM staff_positions sp
LEFT JOIN information_schema.table_privileges tp ON sp.user_account = tp.grantee
WHERE sp.is_active = TRUE
ORDER BY sp.position_type, sp.user_account;

-- 定期権限レビューレポート
CREATE PROCEDURE generate_privilege_review_report()
BEGIN
    -- アクティブユーザーの権限サマリー
    SELECT 
        'Active User Privilege Summary' as report_section,
        position_type,
        COUNT(DISTINCT user_account) as user_count,
        COUNT(DISTINCT role_name) as roles_assigned,
        AVG(DATEDIFF(CURRENT_DATE, start_date)) as avg_tenure_days
    FROM staff_positions
    WHERE is_active = TRUE
    GROUP BY position_type
    ORDER BY user_count DESC;
    
    -- 長期未使用アカウントの特定
    SELECT 
        'Long-term Inactive Accounts' as report_section,
        u.User as username,
        u.Host,
        COALESCE(acc.TOTAL_CONNECTIONS, 0) as total_logins,
        sp.position_type,
        sp.start_date
    FROM mysql.user u
    LEFT JOIN performance_schema.accounts acc ON u.User = acc.USER AND u.Host = acc.HOST
    LEFT JOIN staff_positions sp ON CONCAT('''', u.User, '''@''', u.Host, '''') = sp.user_account
    WHERE u.User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema')
    AND (acc.TOTAL_CONNECTIONS IS NULL OR acc.TOTAL_CONNECTIONS = 0)
    AND sp.start_date < DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY)
    ORDER BY sp.start_date;
    
    -- 危険な権限を持つユーザー
    SELECT 
        'Users with High-Risk Privileges' as report_section,
        up.grantee,
        sp.position_type,
        GROUP_CONCAT(up.privilege_type) as dangerous_privileges
    FROM information_schema.user_privileges up
    LEFT JOIN staff_positions sp ON up.grantee = sp.user_account AND sp.is_active = TRUE
    WHERE up.privilege_type IN ('SUPER', 'CREATE USER', 'GRANT OPTION', 'FILE', 'PROCESS')
    GROUP BY up.grantee, sp.position_type
    ORDER BY sp.position_type;
END //

-- セキュリティリスクの自動検出
CREATE PROCEDURE detect_security_risks()
BEGIN
    -- 共有アカウントの検出
    SELECT 
        'Potential Shared Accounts' as risk_category,
        acc.USER,
        acc.HOST,
        acc.CURRENT_CONNECTIONS,
        'Multiple simultaneous connections from same account' as risk_description
    FROM performance_schema.accounts acc
    WHERE acc.CURRENT_CONNECTIONS > 3
    AND acc.USER NOT IN ('root', 'mysql.sys');
    
    -- 過度な権限を持つアカウント
    SELECT 
        'Over-privileged Accounts' as risk_category,
        tp.grantee,
        COUNT(DISTINCT tp.table_name) as accessible_tables,
        'Access to excessive number of tables' as risk_description
    FROM information_schema.table_privileges tp
    WHERE tp.table_schema = 'school_db'
    GROUP BY tp.grantee
    HAVING COUNT(DISTINCT tp.table_name) > 8; -- 閾値は環境に応じて調整
    
    -- 期限切れパスワードで有効なアカウント
    SELECT 
        'Expired Password Active Accounts' as risk_category,
        u.User,
        u.Host,
        u.password_expired,
        u.account_locked,
        'Account with expired password still active' as risk_description
    FROM mysql.user u
    WHERE u.password_expired = 'Y'
    AND u.account_locked = 'N'
    AND u.User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema');
    
END //

DELIMITER ;

-- 6. 運用管理機能

-- 権限付与・取り消しの承認ワークフロー
CREATE TABLE privilege_approval_requests (
    request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    requested_by VARCHAR(100) NOT NULL,
    target_user VARCHAR(100) NOT NULL,
    request_type ENUM('GRANT', 'REVOKE') NOT NULL,
    privilege_details TEXT NOT NULL,
    business_justification TEXT NOT NULL,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by VARCHAR(100),
    approved_at TIMESTAMP NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'EXECUTED') DEFAULT 'PENDING',
    execution_notes TEXT,
    
    INDEX idx_status (status),
    INDEX idx_requested_by (requested_by),
    INDEX idx_target_user (target_user)
);

-- 承認ワークフロープロシージャ
DELIMITER //

CREATE PROCEDURE submit_privilege_request(
    IN p_target_user VARCHAR(100),
    IN p_request_type ENUM('GRANT', 'REVOKE'),
    IN p_privilege_details TEXT,
    IN p_justification TEXT
)
BEGIN
    INSERT INTO privilege_approval_requests 
        (requested_by, target_user, request_type, privilege_details, business_justification)
    VALUES (USER(), p_target_user, p_request_type, p_privilege_details, p_justification);
    
    SELECT CONCAT('Privilege request submitted with ID: ', LAST_INSERT_ID()) as result;
END //

CREATE PROCEDURE approve_privilege_request(
    IN p_request_id BIGINT,
    IN p_execution_notes TEXT
)
BEGIN
    DECLARE v_target_user VARCHAR(100);
    DECLARE v_request_type ENUM('GRANT', 'REVOKE');
    DECLARE v_privilege_details TEXT;
    DECLARE v_status ENUM('PENDING', 'APPROVED', 'REJECTED', 'EXECUTED');
    
    -- リクエスト情報を取得
    SELECT target_user, request_type, privilege_details, status
    INTO v_target_user, v_request_type, v_privilege_details, v_status
    FROM privilege_approval_requests
    WHERE request_id = p_request_id;
    
    IF v_status != 'PENDING' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Request is not in pending status';
    END IF;
    
    -- 承認状態に更新
    UPDATE privilege_approval_requests
    SET approved_by = USER(),
        approved_at = NOW(),
        status = 'APPROVED',
        execution_notes = p_execution_notes
    WHERE request_id = p_request_id;
    
    -- 実際の権限変更を実行（簡単な例）
    IF v_request_type = 'GRANT' THEN
        -- 実際の環境では、privilege_detailsを解析して適切なGRANT文を構築
        SET @sql = v_privilege_details;
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSEIF v_request_type = 'REVOKE' THEN
        -- 実際の環境では、privilege_detailsを解析して適切なREVOKE文を構築
        SET @sql = v_privilege_details;
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    -- 実行完了状態に更新
    UPDATE privilege_approval_requests
    SET status = 'EXECUTED'
    WHERE request_id = p_request_id;
    
    -- ログ記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES (v_request_type, SUBSTRING_INDEX(v_target_user, '@', 1), SUBSTRING_INDEX(v_target_user, '@', -1),
            'workflow', USER(), CONCAT('Approved request ID: ', p_request_id));
    
    SELECT 'Privilege request approved and executed' as result;
END //

DELIMITER ;

-- 一括権限管理機能
DELIMITER //

CREATE PROCEDURE bulk_privilege_management(
    IN p_operation ENUM('GRANT', 'REVOKE'),
    IN p_role_name VARCHAR(50),
    IN p_user_list TEXT -- カンマ区切りのユーザーリスト
)
BEGIN
    DECLARE v_user VARCHAR(100);
    DECLARE v_pos INT DEFAULT 1;
    DECLARE v_next_pos INT;
    
    -- ユーザーリストを分割して処理
    WHILE v_pos <= LENGTH(p_user_list) DO
        SET v_next_pos = LOCATE(',', p_user_list, v_pos);
        
        IF v_next_pos = 0 THEN
            SET v_next_pos = LENGTH(p_user_list) + 1;
        END IF;
        
        SET v_user = TRIM(SUBSTRING(p_user_list, v_pos, v_next_pos - v_pos));
        
        IF LENGTH(v_user) > 0 THEN
            IF p_operation = 'GRANT' THEN
                SET @sql = CONCAT('GRANT ''', p_role_name, ''' TO ', v_user);
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
                
                SET @sql = CONCAT('ALTER USER ', v_user, ' DEFAULT ROLE ALL');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
            ELSE
                SET @sql = CONCAT('REVOKE ''', p_role_name, ''' FROM ', v_user);
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
            END IF;
            
            -- ログ記録
            INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
            VALUES (p_operation, SUBSTRING_INDEX(v_user, '@', 1), SUBSTRING_INDEX(v_user, '@', -1),
                    'bulk', USER(), CONCAT('Bulk ', p_operation, ' of role: ', p_role_name));
        END IF;
        
        SET v_pos = v_next_pos + 1;
    END WHILE;
    
    SELECT CONCAT('Bulk ', p_operation, ' completed for role: ', p_role_name) as result;
END //

DELIMITER ;

-- 緊急時の権限停止機能
DELIMITER //

CREATE PROCEDURE emergency_privilege_suspension(
    IN p_user_account VARCHAR(100),
    IN p_reason TEXT
)
BEGIN
    -- アカウントを即座にロック
    SET @sql = CONCAT('ALTER USER ', p_user_account, ' ACCOUNT LOCK');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 現在のセッションを強制終了
    -- 注意: 実際の環境では慎重に実行する必要がある
    /*
    UPDATE information_schema.processlist 
    SET COMMAND = 'Kill'
    WHERE USER = SUBSTRING_INDEX(p_user_account, '@', 1)
    AND HOST LIKE CONCAT('%', SUBSTRING_INDEX(p_user_account, '@', -1), '%');
    */
    
    -- 緊急停止ログを記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('EMERGENCY_LOCK', SUBSTRING_INDEX(p_user_account, '@', 1), SUBSTRING_INDEX(p_user_account, '@', -1),
            'emergency', USER(), CONCAT('EMERGENCY SUSPENSION: ', p_reason));
    
    -- 管理者に通知（実際の環境では外部通知システムと連携）
    SELECT CONCAT('EMERGENCY: User ', p_user_account, ' has been suspended. Reason: ', p_reason) as alert;
END //

DELIMITER ;

-- 7. システム使用例とテスト

-- サンプルユーザーの作成（コメントアウト状態）
/*
-- 各役職のサンプルユーザー作成
CREATE USER 'principal_yamada'@'localhost' IDENTIFIED BY 'Principal2025!';
CREATE USER 'academic_suzuki'@'localhost' IDENTIFIED BY 'Academic2025!';
CREATE USER 'grade_head_tanaka'@'localhost' IDENTIFIED BY 'GradeHead2025!';
CREATE USER 'teacher_sato'@'localhost' IDENTIFIED BY 'Teacher2025!';
CREATE USER 'office_kimura'@'localhost' IDENTIFIED BY 'Office2025!';
CREATE USER 'health_takahashi'@'localhost' IDENTIFIED BY 'Health2025!';
CREATE USER 'librarian_watanabe'@'localhost' IDENTIFIED BY 'Library2025!';

-- ロールの付与
GRANT 'principal_role' TO 'principal_yamada'@'localhost';
GRANT 'academic_director_role' TO 'academic_suzuki'@'localhost';
GRANT 'grade_supervisor_role' TO 'grade_head_tanaka'@'localhost';
GRANT 'general_teacher_role' TO 'teacher_sato'@'localhost';
GRANT 'office_staff_role' TO 'office_kimura'@'localhost';
GRANT 'health_coordinator_role' TO 'health_takahashi'@'localhost';
GRANT 'librarian_role' TO 'librarian_watanabe'@'localhost';

-- デフォルトロールの設定
ALTER USER 'principal_yamada'@'localhost' DEFAULT ROLE ALL;
ALTER USER 'academic_suzuki'@'localhost' DEFAULT ROLE ALL;
ALTER USER 'grade_head_tanaka'@'localhost' DEFAULT ROLE ALL;
ALTER USER 'teacher_sato'@'localhost' DEFAULT ROLE ALL;
ALTER USER 'office_kimura'@'localhost' DEFAULT ROLE ALL;
ALTER USER 'health_takahashi'@'localhost' DEFAULT ROLE ALL;
ALTER USER 'librarian_watanabe'@'localhost' DEFAULT ROLE ALL;

-- 役職情報の登録
INSERT INTO staff_positions (user_account, position_type, role_name, department, start_date, updated_by) VALUES
('principal_yamada@localhost', 'principal', 'principal_role', '学校全体', CURRENT_DATE, USER()),
('academic_suzuki@localhost', 'academic_director', 'academic_director_role', '教務部', CURRENT_DATE, USER()),
('grade_head_tanaka@localhost', 'grade_supervisor', 'grade_supervisor_role', '普通科', 2, CURRENT_DATE, USER()),
('teacher_sato@localhost', 'general_teacher', 'general_teacher_role', '普通科', CURRENT_DATE, USER()),
('office_kimura@localhost', 'office_staff', 'office_staff_role', '事務部', CURRENT_DATE, USER()),
('health_takahashi@localhost', 'health_coordinator', 'health_coordinator_role', '保健室', CURRENT_DATE, USER()),
('librarian_watanabe@localhost', 'librarian', 'librarian_role', '図書館', CURRENT_DATE, USER());
*/

-- 8. 運用レポートとモニタリング

-- 現在の権限状況レポート
SELECT 'Current System Privilege Status' as report_title;

SELECT 
    'Active Staff Positions' as section,
    position_type,
    COUNT(*) as count,
    GROUP_CONCAT(DISTINCT role_name) as assigned_roles
FROM staff_positions
WHERE is_active = TRUE
GROUP BY position_type
ORDER BY count DESC;

-- 権限変更履歴サマリー
SELECT 
    'Recent Privilege Changes (Last 30 Days)' as section,
    action,
    user_type,
    COUNT(*) as change_count,
    COUNT(DISTINCT username) as affected_users
FROM user_management_log
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY action, user_type
ORDER BY change_count DESC;

-- セキュリティアラート状況
SELECT 
    'Security Alerts Summary' as section,
    DATE(created_at) as alert_date,
    COUNT(*) as alert_count,
    GROUP_CONCAT(DISTINCT notes) as alert_types
FROM user_management_log
WHERE action = 'ALERT'
AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY DATE(created_at)
ORDER BY alert_date DESC;

-- 権限承認ワークフロー状況
SELECT 
    'Privilege Request Workflow Status' as section,
    status,
    COUNT(*) as request_count,
    AVG(TIMESTAMPDIFF(HOUR, requested_at, IFNULL(approved_at, NOW()))) as avg_processing_hours
FROM privilege_approval_requests
WHERE requested_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY status
ORDER BY request_count DESC;

-- 最終チェック: 全体的な権限監査
SELECT * FROM v_comprehensive_privilege_audit LIMIT 10;

-- 定期メンテナンス実行例（コメントアウト）
-- CALL generate_privilege_review_report();
-- CALL detect_security_risks();
-- CALL auto_revoke_audit_access();
```

## まとめ

この章では、MySQLにおけるGRANT/REVOKEを使った権限の付与と取り消しについて詳しく学びました：

1. **権限管理の基本概念**：
   - 権限の種類と分類（データ操作、構造管理、実行、管理、特殊権限）
   - 権限の適用レベル（グローバル、データベース、テーブル、カラム）
   - グランターとグランティーの関係

2. **GRANT文の活用**：
   - 基本的な権限付与の構文
   - 複数権限の同時付与
   - カラムレベルの細かい権限制御
   - WITH GRANT OPTIONによる権限委譲

3. **REVOKE文による権限取り消し**：
   - 基本的な権限取り消し構文
   - 段階的な権限削減
   - 安全な権限取り消し手順
   - 委譲権限の連鎖取り消し

4. **実践的な権限管理シナリオ**：
   - 新学期の教師権限設定
   - 学期末の権限調整
   - 監査・検査対応の特別権限設定
   - 役職変更に伴う権限更新

5. **高度な権限管理テクニック**：
   - 条件付き権限管理
   - 時間制限付き権限
   - 動的権限管理
   - 役職ベースの権限体系

6. **包括的な権限管理システム**：
   - 承認ワークフローの実装
   - 一括権限管理機能
   - 緊急時の権限停止機能
   - 監査とレポート機能

7. **エラー処理と安全対策**：
   - 権限不足エラーの対処
   - 存在しないオブジェクトへの権限付与エラー
   - 循環的な権限委譲の防止
   - セキュリティリスクの自動検出

GRANT/REVOKEは、データベースセキュリティの中核となる重要な機能です。**最小権限の原則**を基本とし、各ユーザーには業務に必要な最小限の権限のみを付与することが安全な運用の鍵となります。また、権限の変更は必ず記録し、定期的な監査を行うことで、セキュリティインシデントの防止と早期発見が可能になります。

次の章では、「行レベルセキュリティ：ビューとプロシージャによる細粒度制御」について学び、より詳細なアクセス制御手法を理解していきます。