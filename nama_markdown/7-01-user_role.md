# 39. ユーザーとロール：アクセス権限管理

## はじめに

前章では、データベースの設計と構造管理について学習しました。この章からは「セキュリティと権限管理」について学習していきます。どんなに優れたデータベースを設計しても、適切なセキュリティ対策がなければ、データの漏洩や不正な操作が起こる可能性があります。

ユーザー管理とアクセス権限の制御は、データベースセキュリティの最も基本的で重要な要素です。特に学校のような教育機関では、学生の個人情報や成績情報などの機密データを扱うため、誰がどのデータにアクセスできるかを厳密に管理する必要があります。

ユーザーとロール管理が必要となる場面の例：
- 「学生は自分の成績のみ閲覧でき、他の学生の情報は見られないようにしたい」
- 「教師は担当クラスの成績入力はできるが、他のクラスは変更できないようにしたい」
- 「事務職員は学生の基本情報は管理できるが、成績は見られないようにしたい」
- 「システム管理者のみがユーザーの追加・削除を行えるようにしたい」
- 「開発者用のテスト環境では全権限を持つが、本番環境では制限をかけたい」
- 「外部業者にはバックアップ作業のみ許可し、データの閲覧は禁止したい」
- 「退職した職員のアカウントを無効化して、データアクセスを完全に遮断したい」

この章では、MySQLでのユーザー管理とロールベースのアクセス制御について、基本概念から実践的な運用まで詳しく学んでいきます。

## ユーザーとロールとは

### ユーザー（User）
**ユーザー**とは、データベースにアクセスする人やシステムのことです。各ユーザーには固有の名前とパスワードが設定され、それぞれに異なる権限を与えることができます。

### ロール（Role）
**ロール**とは、複数の権限をまとめたグループのことです。例えば「教師」というロールには「成績の閲覧・入力権限」をまとめて設定し、教師ユーザーにそのロールを割り当てることで、権限管理を効率化できます。

### アクセス制御の基本概念

> **用語解説**：
> - **ユーザー（User）**：データベースにログインして操作を行う主体のことです。
> - **ロール（Role）**：権限をまとめたグループで、複数のユーザーに同じ権限セットを効率的に付与できます。
> - **権限（Privilege）**：データベースで実行できる操作の種類です（SELECT、INSERT、UPDATE等）。
> - **認証（Authentication）**：ユーザーが本人であることを確認するプロセスです（ユーザー名とパスワードの確認等）。
> - **認可（Authorization）**：認証されたユーザーが特定の操作を実行する権限があるかを確認するプロセスです。
> - **最小権限の原則**：ユーザーには業務に必要な最小限の権限のみを与えるセキュリティの基本原則です。
> - **ホスト（Host）**：ユーザーがデータベースに接続する元のコンピューターやサーバーのことです。
> - **アカウント**：ユーザー名とホストの組み合わせで構成される、MySQLでの識別単位です。
> - **スキーマ**：データベース内のテーブルやビューなどのオブジェクトをまとめる名前空間です。

## MySQLのユーザー管理システム

### ユーザーアカウントの構成
MySQLでは、ユーザーアカウントは「ユーザー名@ホスト名」の形式で管理されます。

```
例：
- 'student_user'@'localhost'     # ローカルからのみアクセス可能
- 'teacher_user'@'192.168.1.%'   # 特定のネットワークからのみアクセス可能
- 'admin_user'@'%'               # どこからでもアクセス可能（非推奨）
```

### 権限の階層構造
MySQLの権限は以下のような階層構造になっています：

| 階層レベル | 説明 | 適用範囲 |
|-----------|------|----------|
| **グローバル** | サーバー全体 | 全データベース・全テーブル |
| **データベース** | 特定のデータベース | 指定されたデータベース内の全テーブル |
| **テーブル** | 特定のテーブル | 指定されたテーブルのみ |
| **カラム** | 特定のカラム | 指定されたカラムのみ |
| **ルーチン** | ストアドプロシージャ・関数 | 指定されたプロシージャ・関数のみ |

## 基本的なユーザー管理操作

### 1. 現在のユーザー情報確認

```sql
-- 現在ログインしているユーザーを確認
SELECT USER(), CURRENT_USER();

-- システム内の全ユーザーを確認
SELECT User, Host FROM mysql.user;

-- 現在のユーザーの権限を確認
SHOW GRANTS;

-- 特定ユーザーの権限を確認
SHOW GRANTS FOR 'username'@'hostname';
```

### 2. ユーザーの作成

#### 基本的なユーザー作成

```sql
-- 基本的なユーザー作成
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'secure_password';

-- 複数のユーザーを同時作成
CREATE USER 
    'student1'@'localhost' IDENTIFIED BY 'student_pass1',
    'student2'@'localhost' IDENTIFIED BY 'student_pass2',
    'teacher1'@'localhost' IDENTIFIED BY 'teacher_pass1';

-- 作成されたユーザーの確認
SELECT User, Host, account_locked, password_expired 
FROM mysql.user 
WHERE User IN ('student1', 'student2', 'teacher1');
```

#### パスワード要件の設定

```sql
-- パスワードの有効期限を設定したユーザー作成
CREATE USER 'temp_user'@'localhost' 
IDENTIFIED BY 'temporary_pass'
PASSWORD EXPIRE INTERVAL 90 DAY;

-- 初回ログイン時にパスワード変更を強制
CREATE USER 'new_employee'@'localhost' 
IDENTIFIED BY 'initial_pass'
PASSWORD EXPIRE;

-- アカウントをロックした状態で作成
CREATE USER 'inactive_user'@'localhost' 
IDENTIFIED BY 'locked_pass'
ACCOUNT LOCK;
```

### 3. ユーザーの変更

```sql
-- パスワードの変更
ALTER USER 'student1'@'localhost' IDENTIFIED BY 'new_student_pass';

-- 複数ユーザーのパスワードを同時変更
ALTER USER 
    'student1'@'localhost' IDENTIFIED BY 'new_pass1',
    'student2'@'localhost' IDENTIFIED BY 'new_pass2';

-- アカウントのロック・アンロック
ALTER USER 'student1'@'localhost' ACCOUNT LOCK;
ALTER USER 'student1'@'localhost' ACCOUNT UNLOCK;

-- パスワード有効期限の設定
ALTER USER 'teacher1'@'localhost' PASSWORD EXPIRE INTERVAL 180 DAY;
ALTER USER 'teacher1'@'localhost' PASSWORD EXPIRE NEVER;
```

### 4. ユーザーの削除

```sql
-- 単一ユーザーの削除
DROP USER 'temp_user'@'localhost';

-- 複数ユーザーの同時削除
DROP USER 
    'old_student'@'localhost',
    'graduated_student'@'localhost';

-- 存在しない場合でもエラーにしない安全な削除
DROP USER IF EXISTS 'might_not_exist'@'localhost';
```

## 学校システムでの実践的ユーザー管理

### 1. 学校システム用ユーザーの作成

```sql
-- 管理者ユーザー（システム全体の管理）
CREATE USER 'school_admin'@'localhost' 
IDENTIFIED BY 'AdminSecure2025!'
PASSWORD EXPIRE INTERVAL 60 DAY;

-- 教師ユーザー（成績管理・出席管理）
CREATE USER 'teacher_tanaka'@'localhost' 
IDENTIFIED BY 'TeacherPass2025!'
PASSWORD EXPIRE INTERVAL 90 DAY;

CREATE USER 'teacher_sato'@'localhost' 
IDENTIFIED BY 'TeacherPass2025!'
PASSWORD EXPIRE INTERVAL 90 DAY;

-- 学生ユーザー（自分の情報閲覧のみ）
CREATE USER 'student_301'@'localhost' 
IDENTIFIED BY 'StudentPass301!'
PASSWORD EXPIRE INTERVAL 180 DAY;

CREATE USER 'student_302'@'localhost' 
IDENTIFIED BY 'StudentPass302!'
PASSWORD EXPIRE INTERVAL 180 DAY;

-- 事務職員ユーザー（学生情報管理）
CREATE USER 'office_staff'@'localhost' 
IDENTIFIED BY 'OfficePass2025!'
PASSWORD EXPIRE INTERVAL 90 DAY;

-- 読み取り専用ユーザー（レポート作成用）
CREATE USER 'report_viewer'@'localhost' 
IDENTIFIED BY 'ReportView2025!'
PASSWORD EXPIRE INTERVAL 365 DAY;

-- 作成されたユーザーの確認
SELECT 
    User as username,
    Host as allowed_host,
    password_expired,
    account_locked,
    password_lifetime as password_expires_days
FROM mysql.user 
WHERE User LIKE 'school_%' OR User LIKE 'teacher_%' OR User LIKE 'student_%' OR User LIKE 'office_%' OR User LIKE 'report_%'
ORDER BY User;
```

### 2. 接続元制限の設定

```sql
-- 校内ネットワークからのみアクセス可能な教師ユーザー
CREATE USER 'teacher_remote'@'192.168.1.%' 
IDENTIFIED BY 'RemoteTeacher2025!';

-- 特定のIPアドレスからのみアクセス可能な管理者
CREATE USER 'secure_admin'@'192.168.1.100' 
IDENTIFIED BY 'SecureAdmin2025!';

-- 複数の接続元を許可する場合は、複数のアカウントを作成
CREATE USER 'flexible_teacher'@'localhost' IDENTIFIED BY 'FlexTeacher2025!';
CREATE USER 'flexible_teacher'@'192.168.1.%' IDENTIFIED BY 'FlexTeacher2025!';
CREATE USER 'flexible_teacher'@'10.0.0.%' IDENTIFIED BY 'FlexTeacher2025!';
```

### 3. ユーザー情報の管理

```sql
-- 現在アクティブなユーザーセッションの確認
SELECT 
    User,
    Host,
    db as current_database,
    Command,
    Time as session_time_seconds,
    State,
    Info as current_query
FROM information_schema.processlist
WHERE User != 'system user'
ORDER BY Time DESC;

-- ユーザーの最終ログイン時間確認（MySQL 8.0以降）
SELECT 
    USER,
    HOST,
    CURRENT_CONNECTIONS,
    TOTAL_CONNECTIONS
FROM performance_schema.accounts
WHERE USER NOT IN ('mysql.sys', 'mysql.session', 'mysql.infoschema')
ORDER BY TOTAL_CONNECTIONS DESC;

-- パスワード期限が近いユーザーの確認
SELECT 
    User,
    Host,
    password_expired,
    password_lifetime,
    password_last_changed
FROM mysql.user 
WHERE password_lifetime IS NOT NULL
AND password_last_changed IS NOT NULL
AND DATE_ADD(password_last_changed, INTERVAL password_lifetime DAY) <= DATE_ADD(NOW(), INTERVAL 7 DAY)
ORDER BY password_last_changed;
```

## ロールベースアクセス制御（MySQL 8.0以降）

### 1. ロールの基本概念

MySQL 8.0以降では、ロール機能が本格的にサポートされています。

```sql
-- ロール機能が有効かどうか確認
SELECT @@activate_all_roles_on_login;

-- ロール機能を有効化（必要に応じて）
SET GLOBAL activate_all_roles_on_login = ON;
```

### 2. 学校システム用ロールの作成

```sql
-- 基本的なロールの作成
CREATE ROLE 'school_admin_role';
CREATE ROLE 'teacher_role';
CREATE ROLE 'student_role';
CREATE ROLE 'office_staff_role';
CREATE ROLE 'report_reader_role';

-- 特定業務用のロール
CREATE ROLE 'grade_manager';      -- 成績管理専用
CREATE ROLE 'attendance_manager'; -- 出席管理専用
CREATE ROLE 'course_coordinator'; -- 講座管理専用

-- 作成されたロールの確認
SELECT User as role_name, Host 
FROM mysql.user 
WHERE account_locked = 'Y' AND password_expired = 'Y'
ORDER BY User;
```

### 3. ロールへの権限付与

```sql
-- 学生ロール：自分の情報のみ閲覧可能
GRANT SELECT ON school_db.students TO 'student_role';
GRANT SELECT ON school_db.grades TO 'student_role';
GRANT SELECT ON school_db.attendance TO 'student_role';

-- 教師ロール：担当クラスの管理が可能
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'teacher_role';
GRANT SELECT, INSERT, UPDATE ON school_db.attendance TO 'teacher_role';
GRANT SELECT ON school_db.students TO 'teacher_role';
GRANT SELECT ON school_db.courses TO 'teacher_role';

-- 事務職員ロール：学生情報の管理が可能
GRANT SELECT, INSERT, UPDATE ON school_db.students TO 'office_staff_role';
GRANT SELECT ON school_db.courses TO 'office_staff_role';
GRANT SELECT ON school_db.teachers TO 'office_staff_role';

-- 管理者ロール：すべての権限
GRANT ALL PRIVILEGES ON school_db.* TO 'school_admin_role';
GRANT CREATE USER, DROP USER, RELOAD ON *.* TO 'school_admin_role';

-- レポート閲覧ロール：読み取り専用
GRANT SELECT ON school_db.* TO 'report_reader_role';

-- 権限の確認
SHOW GRANTS FOR 'teacher_role';
SHOW GRANTS FOR 'student_role';
```

### 4. ユーザーにロールを割り当て

```sql
-- 既存ユーザーにロールを付与
GRANT 'school_admin_role' TO 'school_admin'@'localhost';
GRANT 'teacher_role' TO 'teacher_tanaka'@'localhost';
GRANT 'teacher_role' TO 'teacher_sato'@'localhost';
GRANT 'student_role' TO 'student_301'@'localhost';
GRANT 'student_role' TO 'student_302'@'localhost';
GRANT 'office_staff_role' TO 'office_staff'@'localhost';
GRANT 'report_reader_role' TO 'report_viewer'@'localhost';

-- 複数のロールを同時に付与
GRANT 'teacher_role', 'grade_manager' TO 'teacher_tanaka'@'localhost';

-- ロールの継承（ロールから別のロールへ）
GRANT 'grade_manager' TO 'teacher_role';
GRANT 'attendance_manager' TO 'teacher_role';

-- ユーザーの持つロールを確認
SHOW GRANTS FOR 'teacher_tanaka'@'localhost';

-- アクティブなロールを確認
SELECT CURRENT_ROLE();
```

### 5. ロールのアクティベーション

```sql
-- ログイン時に自動的にロールをアクティベート
ALTER USER 'teacher_tanaka'@'localhost' DEFAULT ROLE ALL;
ALTER USER 'student_301'@'localhost' DEFAULT ROLE ALL;

-- 特定のロールのみを自動アクティベート
ALTER USER 'teacher_sato'@'localhost' DEFAULT ROLE 'teacher_role';

-- セッション中にロールを手動でアクティベート
SET ROLE 'teacher_role';
SET ROLE ALL;
SET ROLE DEFAULT;

-- 現在アクティブなロールを確認
SELECT CURRENT_ROLE();
```

## 実践的なセキュリティ設定

### 1. パスワードポリシーの設定

```sql
-- パスワード検証プラグインの状況確認
SHOW VARIABLES LIKE 'validate_password%';

-- パスワードポリシーの設定例（グローバル設定）
-- 注意：これらは管理者権限が必要です
-- SET GLOBAL validate_password.length = 12;
-- SET GLOBAL validate_password.mixed_case_count = 1;
-- SET GLOBAL validate_password.number_count = 1;
-- SET GLOBAL validate_password.special_char_count = 1;

-- 強力なパスワードでユーザーを作成
CREATE USER 'secure_teacher'@'localhost' 
IDENTIFIED BY 'TeacherSecure123!@#'
PASSWORD EXPIRE INTERVAL 60 DAY
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LOCK_TIME 1; -- 1日間ロック
```

### 2. 接続制限の設定

```sql
-- 同時接続数の制限付きユーザー作成
CREATE USER 'limited_user'@'localhost' 
IDENTIFIED BY 'LimitedPass2025!'
WITH MAX_CONNECTIONS_PER_HOUR 100
     MAX_UPDATES_PER_HOUR 50
     MAX_QUERIES_PER_HOUR 1000
     MAX_USER_CONNECTIONS 5;

-- 既存ユーザーに制限を追加
ALTER USER 'student_301'@'localhost'
WITH MAX_CONNECTIONS_PER_HOUR 50
     MAX_QUERIES_PER_HOUR 500
     MAX_USER_CONNECTIONS 2;

-- 制限の確認
SELECT 
    User, Host, max_connections, max_questions, 
    max_updates, max_user_connections
FROM mysql.user 
WHERE User = 'student_301';
```

### 3. 監査用のユーザー作成

```sql
-- 監査ログ専用ユーザー
CREATE USER 'audit_logger'@'localhost' 
IDENTIFIED BY 'AuditLog2025!'
PASSWORD EXPIRE NEVER
ACCOUNT LOCK;

-- 監査用ロール
CREATE ROLE 'audit_role';
GRANT SELECT ON mysql.general_log TO 'audit_role';
GRANT SELECT ON mysql.slow_log TO 'audit_role';
GRANT SELECT ON information_schema.* TO 'audit_role';

-- バックアップ専用ユーザー
CREATE USER 'backup_user'@'localhost' 
IDENTIFIED BY 'BackupSecure2025!'
PASSWORD EXPIRE INTERVAL 30 DAY;

CREATE ROLE 'backup_role';
GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER ON school_db.* TO 'backup_role';
GRANT 'backup_role' TO 'backup_user'@'localhost';
ALTER USER 'backup_user'@'localhost' DEFAULT ROLE ALL;
```

## エラーと対処法

### 1. ユーザー作成時の一般的なエラー

```sql
-- エラー例1：既存ユーザーの重複作成
-- CREATE USER 'existing_user'@'localhost' IDENTIFIED BY 'password';
-- エラー: ERROR 1396 (HY000): Operation CREATE USER failed for 'existing_user'@'localhost'

-- 対処法：IF NOT EXISTSを使用
CREATE USER IF NOT EXISTS 'existing_user'@'localhost' IDENTIFIED BY 'password';

-- または、事前にユーザーの存在を確認
SELECT COUNT(*) as user_exists 
FROM mysql.user 
WHERE User = 'test_user' AND Host = 'localhost';

-- 存在する場合は削除してから作成
DROP USER IF EXISTS 'test_user'@'localhost';
CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'new_password';
```

### 2. 権限関連のエラー

```sql
-- エラー例2：存在しないデータベースへの権限付与
-- GRANT SELECT ON non_existent_db.* TO 'user'@'localhost';
-- エラー: ERROR 1146 (42S02): Table 'non_existent_db.user' doesn't exist

-- 対処法：データベースの存在確認
SHOW DATABASES LIKE 'school_db';

-- データベースが存在しない場合は作成
CREATE DATABASE IF NOT EXISTS school_db;
GRANT SELECT ON school_db.* TO 'user'@'localhost';
```

### 3. ロール関連のエラー

```sql
-- エラー例3：MySQL 8.0未満でのロール使用
-- CREATE ROLE 'test_role';
-- エラー: ERROR 1064 (42000): You have an error in your SQL syntax

-- 対処法：MySQLバージョンの確認
SELECT VERSION();

-- MySQL 8.0未満の場合は、ユーザーベースの権限管理を使用
-- または、グループ用のユーザーを作成して権限管理を行う
CREATE USER 'group_teacher'@'localhost' IDENTIFIED BY 'unused_password' ACCOUNT LOCK;
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'group_teacher'@'localhost';
```

### 4. パスワードポリシー違反

```sql
-- エラー例4：弱いパスワードでのユーザー作成
-- CREATE USER 'weak_user'@'localhost' IDENTIFIED BY '123';
-- エラー: ERROR 1819 (HY000): Your password does not satisfy the current policy requirements

-- 対処法：パスワードポリシーに準拠したパスワードの使用
CREATE USER 'strong_user'@'localhost' IDENTIFIED BY 'StrongPassword123!';

-- または、一時的にポリシーを確認
SHOW VARIABLES LIKE 'validate_password%';
```

## 運用時のベストプラクティス

### 1. ユーザー管理の標準手順

```sql
-- 新規ユーザー作成の標準手順
DELIMITER //

CREATE PROCEDURE create_school_user(
    IN p_username VARCHAR(50),
    IN p_host VARCHAR(60),
    IN p_password VARCHAR(255),
    IN p_user_type ENUM('admin', 'teacher', 'student', 'office', 'report'),
    IN p_expire_days INT
)
BEGIN
    DECLARE user_exists INT DEFAULT 0;
    DECLARE role_name VARCHAR(50);
    
    -- ユーザーの存在確認
    SELECT COUNT(*) INTO user_exists
    FROM mysql.user 
    WHERE User = p_username AND Host = p_host;
    
    IF user_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User already exists';
    END IF;
    
    -- ユーザータイプに応じたロール設定
    SET role_name = CASE p_user_type
        WHEN 'admin' THEN 'school_admin_role'
        WHEN 'teacher' THEN 'teacher_role'
        WHEN 'student' THEN 'student_role'
        WHEN 'office' THEN 'office_staff_role'
        WHEN 'report' THEN 'report_reader_role'
    END;
    
    -- ユーザー作成
    SET @sql = CONCAT('CREATE USER ''', p_username, '''@''', p_host, ''' IDENTIFIED BY ''', p_password, ''' PASSWORD EXPIRE INTERVAL ', p_expire_days, ' DAY');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- ロール付与
    SET @sql = CONCAT('GRANT ''', role_name, ''' TO ''', p_username, '''@''', p_host, '''');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- デフォルトロール設定
    SET @sql = CONCAT('ALTER USER ''', p_username, '''@''', p_host, ''' DEFAULT ROLE ALL');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- ログ記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, created_at)
    VALUES ('CREATE', p_username, p_host, p_user_type, USER(), NOW());
    
END //

DELIMITER ;

-- ログテーブルの作成
CREATE TABLE IF NOT EXISTS user_management_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('CREATE', 'MODIFY', 'DELETE', 'LOCK', 'UNLOCK') NOT NULL,
    username VARCHAR(50) NOT NULL,
    host VARCHAR(60) NOT NULL,
    user_type VARCHAR(20),
    created_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    
    INDEX idx_username (username),
    INDEX idx_created_at (created_at)
);

-- プロシージャの使用例
-- CALL create_school_user('new_teacher', 'localhost', 'NewTeacher2025!', 'teacher', 90);
```

### 2. 定期的なユーザー監査

```sql
-- ユーザー監査レポート生成
CREATE VIEW v_user_audit_report AS
SELECT 
    u.User as username,
    u.Host as host,
    u.account_locked,
    u.password_expired,
    u.password_last_changed,
    CASE 
        WHEN u.password_lifetime IS NULL THEN 'Never expires'
        ELSE CONCAT(u.password_lifetime, ' days')
    END as password_policy,
    CASE 
        WHEN u.password_last_changed IS NULL THEN 'Unknown'
        WHEN DATE_ADD(u.password_last_changed, INTERVAL IFNULL(u.password_lifetime, 365) DAY) < NOW() THEN 'Expired'
        WHEN DATE_ADD(u.password_last_changed, INTERVAL IFNULL(u.password_lifetime, 365) DAY) < DATE_ADD(NOW(), INTERVAL 7 DAY) THEN 'Expires Soon'
        ELSE 'Valid'
    END as password_status,
    u.max_connections,
    u.max_user_connections,
    -- 最終ログイン情報（可能な場合）
    COALESCE(acc.TOTAL_CONNECTIONS, 0) as total_login_count,
    COALESCE(acc.CURRENT_CONNECTIONS, 0) as current_connections
FROM mysql.user u
LEFT JOIN performance_schema.accounts acc ON u.User = acc.USER AND u.Host = acc.HOST
WHERE u.User NOT IN ('mysql.sys', 'mysql.session', 'mysql.infoschema', 'root')
ORDER BY u.User, u.Host;

-- 監査レポートの実行
SELECT * FROM v_user_audit_report;

-- パスワード期限切れユーザーの確認
SELECT username, host, password_last_changed, password_status
FROM v_user_audit_report 
WHERE password_status IN ('Expired', 'Expires Soon')
ORDER BY password_last_changed;
```

### 3. セキュリティ設定の確認

```sql
-- セキュリティ関連設定の確認
SELECT 
    'Password Validation' as category,
    variable_name,
    variable_value
FROM performance_schema.global_variables 
WHERE variable_name LIKE 'validate_password%'

UNION ALL

SELECT 
    'SSL/TLS Configuration',
    variable_name,
    variable_value
FROM performance_schema.global_variables 
WHERE variable_name IN ('have_ssl', 'ssl_ca', 'ssl_cert', 'ssl_key', 'require_secure_transport')

UNION ALL

SELECT 
    'General Security',
    variable_name,
    variable_value
FROM performance_schema.global_variables 
WHERE variable_name IN ('local_infile', 'secure_file_priv', 'sql_mode')

ORDER BY category, variable_name;

-- 危険な設定のチェック
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN 'WARNING: Users with weak passwords found'
        ELSE 'OK: No users with empty passwords'
    END as password_check
FROM mysql.user 
WHERE authentication_string = '' OR authentication_string IS NULL;

-- 管理者権限を持つユーザーの確認
SELECT DISTINCT 
    grantee as privileged_user,
    'Has dangerous privileges' as warning
FROM information_schema.user_privileges 
WHERE privilege_type IN ('SUPER', 'CREATE USER', 'GRANT OPTION', 'FILE', 'PROCESS', 'RELOAD', 'SHUTDOWN')
AND grantee NOT LIKE '%root%'
ORDER BY grantee;
```

### 4. 自動化されたユーザー管理

```sql
-- 期限切れユーザーの自動処理
DELIMITER //

CREATE PROCEDURE maintain_user_accounts()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_user VARCHAR(50);
    DECLARE v_host VARCHAR(60);
    DECLARE v_expire_date DATE;
    
    -- 期限切れユーザーを取得するカーソル
    DECLARE expired_cursor CURSOR FOR
        SELECT User, Host,
               DATE_ADD(password_last_changed, INTERVAL IFNULL(password_lifetime, 90) DAY) as expire_date
        FROM mysql.user 
        WHERE password_last_changed IS NOT NULL
        AND DATE_ADD(password_last_changed, INTERVAL IFNULL(password_lifetime, 90) DAY) < NOW()
        AND account_locked = 'N'
        AND User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema');
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN expired_cursor;
    
    read_loop: LOOP
        FETCH expired_cursor INTO v_user, v_host, v_expire_date;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- アカウントをロック
        SET @sql = CONCAT('ALTER USER ''', v_user, '''@''', v_host, ''' ACCOUNT LOCK');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        -- ログに記録
        INSERT INTO user_management_log (action, username, host, notes, created_by)
        VALUES ('LOCK', v_user, v_host, 
               CONCAT('Auto-locked due to password expiry on ', v_expire_date), 
               'SYSTEM');
        
    END LOOP;
    
    CLOSE expired_cursor;
    
    -- 結果をレポート
    SELECT 
        CONCAT('Locked ', ROW_COUNT(), ' expired user accounts') as maintenance_result,
        NOW() as maintenance_time;
        
END //

DELIMITER ;

-- 定期メンテナンスの実行（例：毎日実行）
-- このプロシージャは管理者が定期的に実行するか、
-- cron job等で自動実行するように設定します
-- CALL maintain_user_accounts();
```

## 練習問題

### 問題39-1：基本的なユーザー作成
学校システム用に以下のユーザーを作成してください：
1. `librarian`：図書館司書用ユーザー（ローカルからのみアクセス、パスワード期限90日）
2. `counselor`：学習相談員用ユーザー（学内ネットワーク192.168.1.%からアクセス、パスワード期限180日）
3. `parent_viewer`：保護者用閲覧ユーザー（どこからでもアクセス可、パスワード期限365日）
各ユーザーに適切なパスワードを設定し、作成後にユーザー一覧で確認してください。

### 問題39-2：ロールベースの権限管理
以下の要件でロールを作成し、適切なユーザーに割り当ててください：
1. `library_manager_role`：図書館管理ロール
   - `books`テーブルの全操作権限
   - `book_loans`テーブルの全操作権限
   - `students`テーブルの閲覧権限のみ
2. `guidance_counselor_role`：相談員ロール
   - `students`テーブルの閲覧・更新権限
   - `grades`テーブルの閲覧権限のみ
   - `attendance`テーブルの閲覧権限のみ
3. 問題39-1で作成したユーザーに適切なロールを割り当て、デフォルトロールに設定

### 問題39-3：セキュリティ強化設定
以下のセキュリティ要件を満たすユーザーを作成してください：
1. `security_admin`ユーザー：
   - 特定IPアドレス（192.168.1.10）からのみアクセス可能
   - パスワード期限30日
   - ログイン失敗3回でアカウントロック
   - 同時接続数最大2まで
2. `temp_contractor`ユーザー：
   - 初回ログイン時にパスワード変更を強制
   - 1時間あたりの接続回数を50回に制限
   - 作成時はアカウントロック状態

### 問題39-4：ユーザー監査機能
以下の監査機能を実装してください：
1. パスワード期限が7日以内に切れるユーザーをリストアップするクエリ
2. 過去30日間ログインしていないユーザーを特定するクエリ（可能な範囲で）
3. 管理者権限を持つユーザーをすべて表示するクエリ
4. 同時接続数制限が設定されているユーザーの一覧表示

### 問題39-5：動的ユーザー管理
以下の機能を持つストアドプロシージャを作成してください：
1. `manage_student_user(action, student_id, operation)`：
   - `action`が'CREATE'の場合：学生IDベースでユーザーを作成
   - `action`が'LOCK'の場合：該当ユーザーをロック
   - `action`が'UNLOCK'の場合：該当ユーザーのロックを解除
   - `action`が'DELETE'の場合：該当ユーザーを削除
   - すべての操作をログテーブルに記録
2. 5名の架空の学生ユーザーで動作テストを実行

### 問題39-6：包括的なユーザー管理システム
学校システムの完全なユーザー管理システムを設計・実装してください：
1. 以下の役職すべてに対応したロールとユーザーの作成：
   - 校長（全データアクセス可能）
   - 教務主任（成績・出席管理）
   - 学年主任（担当学年のみ管理）
   - 一般教師（担当クラスのみ管理）
   - 事務職員（学生情報管理）
   - 保健室職員（健康情報管理）
   - 図書館司書（図書管理）
   - システム管理者（ユーザー管理）
2. 各役職の責任範囲に応じた適切な権限設定
3. ユーザー作成・管理の自動化プロシージャ
4. セキュリティ監査機能
5. 運用ドキュメントの作成（コメント形式）

## 解答

### 解答39-1
```sql
-- 1. 図書館司書用ユーザー
CREATE USER 'librarian'@'localhost' 
IDENTIFIED BY 'LibrarianSecure2025!'
PASSWORD EXPIRE INTERVAL 90 DAY;

-- 2. 学習相談員用ユーザー
CREATE USER 'counselor'@'192.168.1.%' 
IDENTIFIED BY 'CounselorSecure2025!'
PASSWORD EXPIRE INTERVAL 180 DAY;

-- 3. 保護者用閲覧ユーザー
CREATE USER 'parent_viewer'@'%' 
IDENTIFIED BY 'ParentView2025!'
PASSWORD EXPIRE INTERVAL 365 DAY;

-- 作成したユーザーの確認
SELECT 
    User as username,
    Host as allowed_host,
    password_expired,
    password_lifetime as password_expires_days,
    account_locked
FROM mysql.user 
WHERE User IN ('librarian', 'counselor', 'parent_viewer')
ORDER BY User;

-- より詳細な確認
SHOW GRANTS FOR 'librarian'@'localhost';
SHOW GRANTS FOR 'counselor'@'192.168.1.%';
SHOW GRANTS FOR 'parent_viewer'@'%';
```

### 解答39-2
```sql
-- 1. ロールの作成
CREATE ROLE 'library_manager_role';
CREATE ROLE 'guidance_counselor_role';

-- 2. library_manager_roleの権限設定
GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.books TO 'library_manager_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.book_loans TO 'library_manager_role';
GRANT SELECT ON school_db.students TO 'library_manager_role';

-- 3. guidance_counselor_roleの権限設定
GRANT SELECT, UPDATE ON school_db.students TO 'guidance_counselor_role';
GRANT SELECT ON school_db.grades TO 'guidance_counselor_role';
GRANT SELECT ON school_db.attendance TO 'guidance_counselor_role';

-- 4. ユーザーにロールを割り当て
GRANT 'library_manager_role' TO 'librarian'@'localhost';
GRANT 'guidance_counselor_role' TO 'counselor'@'192.168.1.%';

-- 保護者用は閲覧のみのロールを作成
CREATE ROLE 'parent_viewer_role';
GRANT SELECT ON school_db.students TO 'parent_viewer_role';
GRANT SELECT ON school_db.grades TO 'parent_viewer_role';
GRANT 'parent_viewer_role' TO 'parent_viewer'@'%';

-- 5. デフォルトロールの設定
ALTER USER 'librarian'@'localhost' DEFAULT ROLE ALL;
ALTER USER 'counselor'@'192.168.1.%' DEFAULT ROLE ALL;
ALTER USER 'parent_viewer'@'%' DEFAULT ROLE ALL;

-- 権限の確認
SHOW GRANTS FOR 'library_manager_role';
SHOW GRANTS FOR 'guidance_counselor_role';
SHOW GRANTS FOR 'parent_viewer_role';

-- ユーザーの権限確認
SHOW GRANTS FOR 'librarian'@'localhost';
SHOW GRANTS FOR 'counselor'@'192.168.1.%';
SHOW GRANTS FOR 'parent_viewer'@'%';
```

### 解答39-3
```sql
-- 1. security_adminユーザーの作成
CREATE USER 'security_admin'@'192.168.1.10' 
IDENTIFIED BY 'SecurityAdmin2025!@#'
PASSWORD EXPIRE INTERVAL 30 DAY
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LOCK_TIME 1
WITH MAX_USER_CONNECTIONS 2;

-- 2. temp_contractorユーザーの作成
CREATE USER 'temp_contractor'@'localhost' 
IDENTIFIED BY 'TempInitial2025!'
PASSWORD EXPIRE
WITH MAX_CONNECTIONS_PER_HOUR 50
ACCOUNT LOCK;

-- 作成結果の確認
SELECT 
    User,
    Host,
    account_locked,
    password_expired,
    password_lifetime,
    Failed_login_attempts,
    Password_lock_time,
    max_connections,
    max_user_connections
FROM mysql.user 
WHERE User IN ('security_admin', 'temp_contractor');

-- 接続制限の詳細確認
SELECT 
    User,
    Host,
    max_questions as hourly_queries,
    max_updates as hourly_updates,
    max_connections as hourly_connections,
    max_user_connections as concurrent_connections
FROM mysql.user 
WHERE User IN ('security_admin', 'temp_contractor');
```

### 解答39-4
```sql
-- 1. パスワード期限が7日以内に切れるユーザーのリストアップ
SELECT 
    User as username,
    Host as host,
    password_last_changed,
    password_lifetime,
    DATE_ADD(password_last_changed, INTERVAL password_lifetime DAY) as expires_on,
    DATEDIFF(DATE_ADD(password_last_changed, INTERVAL password_lifetime DAY), CURRENT_DATE) as days_until_expiry
FROM mysql.user 
WHERE password_last_changed IS NOT NULL
    AND password_lifetime IS NOT NULL
    AND DATE_ADD(password_last_changed, INTERVAL password_lifetime DAY) <= DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)
    AND DATE_ADD(password_last_changed, INTERVAL password_lifetime DAY) >= CURRENT_DATE
    AND User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema')
ORDER BY expires_on;

-- 2. 過去30日間ログインしていないユーザー（performance_schemaを使用）
SELECT 
    u.User as username,
    u.Host as host,
    COALESCE(acc.TOTAL_CONNECTIONS, 0) as total_login_count,
    COALESCE(acc.CURRENT_CONNECTIONS, 0) as current_connections,
    CASE 
        WHEN acc.USER IS NULL THEN 'Never logged in'
        WHEN acc.TOTAL_CONNECTIONS = 0 THEN 'Never logged in'
        ELSE 'Login history exists (detailed tracking not available in this version)'
    END as login_status
FROM mysql.user u
LEFT JOIN performance_schema.accounts acc ON u.User = acc.USER AND u.Host = acc.HOST
WHERE u.User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema')
ORDER BY u.User;

-- 3. 管理者権限を持つユーザーの表示
SELECT DISTINCT
    up.grantee as privileged_user,
    GROUP_CONCAT(DISTINCT up.privilege_type ORDER BY up.privilege_type) as dangerous_privileges
FROM information_schema.user_privileges up
WHERE up.privilege_type IN ('SUPER', 'CREATE USER', 'GRANT OPTION', 'FILE', 'PROCESS', 'RELOAD', 'SHUTDOWN', 'ALL PRIVILEGES')
    AND up.grantee NOT LIKE '%root%@%'
GROUP BY up.grantee
ORDER BY up.grantee;

-- グローバル権限の詳細確認
SELECT 
    grantee,
    privilege_type,
    is_grantable
FROM information_schema.user_privileges 
WHERE privilege_type IN ('SUPER', 'CREATE USER', 'GRANT OPTION', 'ALL PRIVILEGES')
ORDER BY grantee, privilege_type;

-- 4. 同時接続数制限が設定されているユーザーの一覧
SELECT 
    User as username,
    Host as host,
    max_questions as hourly_queries_limit,
    max_updates as hourly_updates_limit, 
    max_connections as hourly_connections_limit,
    max_user_connections as concurrent_connections_limit,
    CASE 
        WHEN max_user_connections > 0 OR max_connections > 0 OR max_questions > 0 OR max_updates > 0 
        THEN 'Has Limits'
        ELSE 'No Limits' 
    END as limitation_status
FROM mysql.user
WHERE (max_user_connections > 0 OR max_connections > 0 OR max_questions > 0 OR max_updates > 0)
    AND User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema')
ORDER BY User;
```

### 解答39-5
```sql
-- ログテーブルの作成（まだ存在しない場合）
CREATE TABLE IF NOT EXISTS user_management_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('CREATE', 'MODIFY', 'DELETE', 'LOCK', 'UNLOCK') NOT NULL,
    username VARCHAR(50) NOT NULL,
    host VARCHAR(60) NOT NULL,
    user_type VARCHAR(20),
    created_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    
    INDEX idx_username (username),
    INDEX idx_created_at (created_at),
    INDEX idx_action (action)
);

-- 学生ユーザー管理プロシージャ
DELIMITER //

CREATE PROCEDURE manage_student_user(
    IN p_action ENUM('CREATE', 'LOCK', 'UNLOCK', 'DELETE'),
    IN p_student_id BIGINT,
    IN p_operation VARCHAR(100)
)
BEGIN
    DECLARE v_username VARCHAR(50);
    DECLARE v_host VARCHAR(60) DEFAULT 'localhost';
    DECLARE v_password VARCHAR(50);
    DECLARE user_exists INT DEFAULT 0;
    DECLARE operation_result VARCHAR(200);
    
    -- 学生IDからユーザー名を生成
    SET v_username = CONCAT('student_', p_student_id);
    SET v_password = CONCAT('Student', p_student_id, 'Pass2025!');
    
    -- ユーザーの存在確認
    SELECT COUNT(*) INTO user_exists
    FROM mysql.user 
    WHERE User = v_username AND Host = v_host;
    
    CASE p_action
        WHEN 'CREATE' THEN
            IF user_exists > 0 THEN
                SET operation_result = 'ERROR: User already exists';
            ELSE
                -- ユーザー作成
                SET @sql = CONCAT('CREATE USER ''', v_username, '''@''', v_host, ''' IDENTIFIED BY ''', v_password, ''' PASSWORD EXPIRE INTERVAL 180 DAY');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
                
                -- 学生ロールが存在する場合は付与
                IF EXISTS (SELECT 1 FROM mysql.user WHERE User = 'student_role' AND Host = '') THEN
                    SET @sql = CONCAT('GRANT ''student_role'' TO ''', v_username, '''@''', v_host, '''');
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
                    DEALLOCATE PREPARE stmt;
                    
                    SET @sql = CONCAT('ALTER USER ''', v_username, '''@''', v_host, ''' DEFAULT ROLE ALL');
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
                    DEALLOCATE PREPARE stmt;
                END IF;
                
                SET operation_result = 'SUCCESS: User created';
            END IF;
            
        WHEN 'LOCK' THEN
            IF user_exists = 0 THEN
                SET operation_result = 'ERROR: User does not exist';
            ELSE
                SET @sql = CONCAT('ALTER USER ''', v_username, '''@''', v_host, ''' ACCOUNT LOCK');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
                SET operation_result = 'SUCCESS: User locked';
            END IF;
            
        WHEN 'UNLOCK' THEN
            IF user_exists = 0 THEN
                SET operation_result = 'ERROR: User does not exist';
            ELSE
                SET @sql = CONCAT('ALTER USER ''', v_username, '''@''', v_host, ''' ACCOUNT UNLOCK');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
                SET operation_result = 'SUCCESS: User unlocked';
            END IF;
            
        WHEN 'DELETE' THEN
            IF user_exists = 0 THEN
                SET operation_result = 'ERROR: User does not exist';
            ELSE
                SET @sql = CONCAT('DROP USER ''', v_username, '''@''', v_host, '''');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
                SET operation_result = 'SUCCESS: User deleted';
            END IF;
            
        ELSE
            SET operation_result = 'ERROR: Invalid action';
    END CASE;
    
    -- ログに記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES (p_action, v_username, v_host, 'student', USER(), 
            CONCAT(p_operation, ' - Result: ', operation_result));
    
    -- 結果を返す
    SELECT 
        p_action as requested_action,
        v_username as target_user,
        operation_result as result,
        NOW() as operation_time;
        
END //

DELIMITER ;

-- テスト実行：5名の架空学生ユーザーで動作テスト

-- 1. ユーザー作成テスト
CALL manage_student_user('CREATE', 1001, 'Create test student 1001');
CALL manage_student_user('CREATE', 1002, 'Create test student 1002');
CALL manage_student_user('CREATE', 1003, 'Create test student 1003');
CALL manage_student_user('CREATE', 1004, 'Create test student 1004');
CALL manage_student_user('CREATE', 1005, 'Create test student 1005');

-- 2. 作成されたユーザーの確認
SELECT User, Host, account_locked, password_expired
FROM mysql.user 
WHERE User LIKE 'student_100%'
ORDER BY User;

-- 3. ロック/アンロックテスト
CALL manage_student_user('LOCK', 1001, 'Lock test for student 1001');
CALL manage_student_user('UNLOCK', 1001, 'Unlock test for student 1001');

-- 4. 削除テスト
CALL manage_student_user('DELETE', 1005, 'Delete test for student 1005');

-- 5. エラーケーステスト
CALL manage_student_user('CREATE', 1001, 'Duplicate creation test'); -- 重複作成エラー
CALL manage_student_user('DELETE', 9999, 'Delete non-existent user test'); -- 存在しないユーザー削除

-- 6. ログの確認
SELECT 
    action,
    username,
    notes,
    created_by,
    created_at
FROM user_management_log 
WHERE username LIKE 'student_100%'
ORDER BY created_at DESC;

-- 7. 最終状態確認
SELECT 
    User as username,
    Host as host,
    account_locked,
    password_expired,
    'Active' as status
FROM mysql.user 
WHERE User LIKE 'student_100%'
ORDER BY User;
```

### 解答39-6
```sql
-- 包括的なユーザー管理システム

-- 1. 役職別ロールの作成
CREATE ROLE 'principal_role';           -- 校長
CREATE ROLE 'academic_director_role';   -- 教務主任
CREATE ROLE 'grade_supervisor_role';    -- 学年主任
CREATE ROLE 'teacher_role';             -- 一般教師
CREATE ROLE 'office_staff_role';        -- 事務職員
CREATE ROLE 'health_staff_role';        -- 保健室職員
CREATE ROLE 'librarian_role';           -- 図書館司書
CREATE ROLE 'system_admin_role';        -- システム管理者

-- 2. 権限設定

-- 校長ロール：全データアクセス可能
GRANT ALL PRIVILEGES ON school_db.* TO 'principal_role';
GRANT SELECT ON mysql.user TO 'principal_role';

-- 教務主任ロール：成績・出席管理
GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.grades TO 'academic_director_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.attendance TO 'academic_director_role';
GRANT SELECT, INSERT, UPDATE ON school_db.courses TO 'academic_director_role';
GRANT SELECT, INSERT, UPDATE ON school_db.course_schedule TO 'academic_director_role';
GRANT SELECT ON school_db.students TO 'academic_director_role';
GRANT SELECT ON school_db.teachers TO 'academic_director_role';

-- 学年主任ロール：担当学年のみ管理
GRANT SELECT, INSERT, UPDATE ON school_db.students TO 'grade_supervisor_role';
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'grade_supervisor_role';
GRANT SELECT, INSERT, UPDATE ON school_db.attendance TO 'grade_supervisor_role';
GRANT SELECT ON school_db.courses TO 'grade_supervisor_role';
GRANT SELECT ON school_db.teachers TO 'grade_supervisor_role';

-- 一般教師ロール：担当クラスのみ管理
GRANT SELECT ON school_db.students TO 'teacher_role';
GRANT SELECT, INSERT, UPDATE ON school_db.grades TO 'teacher_role';
GRANT SELECT, INSERT, UPDATE ON school_db.attendance TO 'teacher_role';
GRANT SELECT ON school_db.courses TO 'teacher_role';

-- 事務職員ロール：学生情報管理
GRANT SELECT, INSERT, UPDATE ON school_db.students TO 'office_staff_role';
GRANT SELECT ON school_db.courses TO 'office_staff_role';
GRANT SELECT ON school_db.teachers TO 'office_staff_role';
GRANT SELECT, INSERT, UPDATE ON school_db.student_courses TO 'office_staff_role';

-- 保健室職員ロール：健康情報管理
GRANT SELECT ON school_db.students TO 'health_staff_role';
-- 健康情報テーブルがある場合
-- GRANT SELECT, INSERT, UPDATE ON school_db.health_records TO 'health_staff_role';

-- 図書館司書ロール：図書管理
-- 図書関連テーブルがある場合の権限設定例
-- GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.books TO 'librarian_role';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON school_db.book_loans TO 'librarian_role';
GRANT SELECT ON school_db.students TO 'librarian_role';

-- システム管理者ロール：ユーザー管理
GRANT CREATE USER, DROP USER, RELOAD ON *.* TO 'system_admin_role';
GRANT SELECT, INSERT, UPDATE ON mysql.user TO 'system_admin_role';
GRANT ALL PRIVILEGES ON school_db.user_management_log TO 'system_admin_role';

-- 3. 役職別ユーザーの作成プロシージャ
DELIMITER //

CREATE PROCEDURE create_school_staff_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_position ENUM('principal', 'academic_director', 'grade_supervisor', 'teacher', 'office_staff', 'health_staff', 'librarian', 'system_admin'),
    IN p_host VARCHAR(60) DEFAULT 'localhost',
    IN p_expire_days INT DEFAULT 90
)
BEGIN
    DECLARE v_role_name VARCHAR(50);
    DECLARE user_exists INT DEFAULT 0;
    
    -- ユーザーの存在確認
    SELECT COUNT(*) INTO user_exists
    FROM mysql.user 
    WHERE User = p_username AND Host = p_host;
    
    IF user_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User already exists';
    END IF;
    
    -- 役職に応じたロール名の設定
    SET v_role_name = CASE p_position
        WHEN 'principal' THEN 'principal_role'
        WHEN 'academic_director' THEN 'academic_director_role'
        WHEN 'grade_supervisor' THEN 'grade_supervisor_role'
        WHEN 'teacher' THEN 'teacher_role'
        WHEN 'office_staff' THEN 'office_staff_role'
        WHEN 'health_staff' THEN 'health_staff_role'
        WHEN 'librarian' THEN 'librarian_role'
        WHEN 'system_admin' THEN 'system_admin_role'
    END;
    
    -- ユーザー作成
    SET @sql = CONCAT('CREATE USER ''', p_username, '''@''', p_host, ''' IDENTIFIED BY ''', p_password, ''' PASSWORD EXPIRE INTERVAL ', p_expire_days, ' DAY');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- ロール付与
    SET @sql = CONCAT('GRANT ''', v_role_name, ''' TO ''', p_username, '''@''', p_host, '''');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- デフォルトロール設定
    SET @sql = CONCAT('ALTER USER ''', p_username, '''@''', p_host, ''' DEFAULT ROLE ALL');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 追加の制限設定（役職に応じて）
    IF p_position IN ('teacher', 'office_staff', 'health_staff', 'librarian') THEN
        SET @sql = CONCAT('ALTER USER ''', p_username, '''@''', p_host, ''' WITH MAX_USER_CONNECTIONS 3');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    -- ログ記録
    INSERT INTO user_management_log (action, username, host, user_type, created_by, notes)
    VALUES ('CREATE', p_username, p_host, p_position, USER(), 
            CONCAT('Created ', p_position, ' user with role: ', v_role_name));
    
    -- 結果返却
    SELECT 
        p_username as created_user,
        p_host as host,
        p_position as position,
        v_role_name as assigned_role,
        'SUCCESS' as result;
        
END //

DELIMITER ;

-- 4. セキュリティ監査機能
CREATE VIEW v_comprehensive_user_audit AS
SELECT 
    u.User as username,
    u.Host as host,
    CASE 
        WHEN u.User LIKE '%principal%' THEN 'Principal'
        WHEN u.User LIKE '%academic%' THEN 'Academic Director'
        WHEN u.User LIKE '%grade%' THEN 'Grade Supervisor'
        WHEN u.User LIKE '%teacher%' THEN 'Teacher'
        WHEN u.User LIKE '%office%' THEN 'Office Staff'
        WHEN u.User LIKE '%health%' THEN 'Health Staff'
        WHEN u.User LIKE '%librarian%' THEN 'Librarian'
        WHEN u.User LIKE '%admin%' THEN 'System Admin'
        WHEN u.User LIKE '%student%' THEN 'Student'
        ELSE 'Other'
    END as estimated_role,
    u.account_locked,
    u.password_expired,
    u.password_last_changed,
    u.password_lifetime,
    CASE 
        WHEN u.password_last_changed IS NULL THEN 'Never changed'
        WHEN DATE_ADD(u.password_last_changed, INTERVAL IFNULL(u.password_lifetime, 90) DAY) < NOW() THEN 'EXPIRED'
        WHEN DATE_ADD(u.password_last_changed, INTERVAL IFNULL(u.password_lifetime, 90) DAY) < DATE_ADD(NOW(), INTERVAL 7 DAY) THEN 'EXPIRES SOON'
        ELSE 'Valid'
    END as password_status,
    u.max_user_connections,
    COALESCE(acc.TOTAL_CONNECTIONS, 0) as total_logins,
    COALESCE(acc.CURRENT_CONNECTIONS, 0) as current_sessions
FROM mysql.user u
LEFT JOIN performance_schema.accounts acc ON u.User = acc.USER AND u.Host = acc.HOST
WHERE u.User NOT IN ('mysql.sys', 'mysql.session', 'mysql.infoschema', 'root')
ORDER BY 
    CASE estimated_role
        WHEN 'Principal' THEN 1
        WHEN 'System Admin' THEN 2
        WHEN 'Academic Director' THEN 3
        WHEN 'Grade Supervisor' THEN 4
        WHEN 'Teacher' THEN 5
        WHEN 'Office Staff' THEN 6
        WHEN 'Health Staff' THEN 7
        WHEN 'Librarian' THEN 8
        WHEN 'Student' THEN 9
        ELSE 10
    END,
    u.User;

-- 5. サンプルユーザーの作成（コメントアウト状態）
/*
CALL create_school_staff_user('principal_yamada', 'PrincipalSecure2025!', 'principal', 'localhost', 60);
CALL create_school_staff_user('academic_suzuki', 'AcademicSecure2025!', 'academic_director', 'localhost', 90);
CALL create_school_staff_user('grade_head_tanaka', 'GradeSecure2025!', 'grade_supervisor', 'localhost', 90);
CALL create_school_staff_user('teacher_sato', 'TeacherSecure2025!', 'teacher', 'localhost', 120);
CALL create_school_staff_user('office_kimura', 'OfficeSecure2025!', 'office_staff', 'localhost', 90);
CALL create_school_staff_user('nurse_takahashi', 'HealthSecure2025!', 'health_staff', 'localhost', 120);
CALL create_school_staff_user('librarian_watanabe', 'LibrarySecure2025!', 'librarian', 'localhost', 120);
CALL create_school_staff_user('sysadmin_ito', 'SystemSecure2025!', 'system_admin', 'localhost', 30);
*/

-- 6. 定期メンテナンスプロシージャ
DELIMITER //

CREATE PROCEDURE comprehensive_user_maintenance()
BEGIN
    DECLARE maintenance_summary TEXT DEFAULT '';
    
    -- 期限切れアカウントのロック
    UPDATE mysql.user 
    SET account_locked = 'Y'
    WHERE password_last_changed IS NOT NULL
    AND DATE_ADD(password_last_changed, INTERVAL IFNULL(password_lifetime, 90) DAY) < NOW()
    AND account_locked = 'N'
    AND User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema');
    
    SET maintenance_summary = CONCAT('Locked ', ROW_COUNT(), ' expired accounts. ');
    
    -- 警告が必要なアカウントのカウント
    SELECT COUNT(*) INTO @warning_count
    FROM mysql.user
    WHERE password_last_changed IS NOT NULL
    AND DATE_ADD(password_last_changed, INTERVAL IFNULL(password_lifetime, 90) DAY) <= DATE_ADD(NOW(), INTERVAL 7 DAY)
    AND DATE_ADD(password_last_changed, INTERVAL IFNULL(password_lifetime, 90) DAY) > NOW()
    AND User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema');
    
    SET maintenance_summary = CONCAT(maintenance_summary, @warning_count, ' accounts expire within 7 days.');
    
    -- メンテナンスログ
    INSERT INTO user_management_log (action, username, host, created_by, notes)
    VALUES ('MAINTENANCE', 'SYSTEM', 'SYSTEM', 'AUTO_MAINTENANCE', maintenance_summary);
    
    -- 結果レポート
    SELECT 
        'User Maintenance Completed' as status,
        maintenance_summary as summary,
        NOW() as maintenance_time;
        
END //

DELIMITER ;

-- 7. 運用ドキュメント（コメント形式）
/*
=== 学校システム ユーザー管理運用ガイド ===

【役職別権限一覧】
1. 校長 (principal_role)
   - 全データベースへの完全アクセス権限
   - ユーザー情報の閲覧権限
   - 最高責任者として全権限を保有

2. 教務主任 (academic_director_role)
   - 成績データの完全管理権限
   - 出席データの完全管理権限
   - 講座・スケジュールの管理権限
   - 学生・教師情報の閲覧権限

3. 学年主任 (grade_supervisor_role)
   - 担当学年の学生情報管理権限
   - 成績・出席データの管理権限
   - 講座・教師情報の閲覧権限

4. 一般教師 (teacher_role)
   - 担当クラスの成績入力・修正権限
   - 担当クラスの出席管理権限
   - 学生・講座情報の閲覧権限

5. 事務職員 (office_staff_role)
   - 学生基本情報の管理権限
   - 受講情報の管理権限
   - 講座・教師情報の閲覧権限

6. 保健室職員 (health_staff_role)
   - 学生基本情報の閲覧権限
   - 健康関連情報の管理権限（該当テーブル存在時）

7. 図書館司書 (librarian_role)
   - 図書関連データの管理権限（該当テーブル存在時）
   - 学生基本情報の閲覧権限

8. システム管理者 (system_admin_role)
   - ユーザー管理の完全権限
   - システム関連権限
   - 監査ログの管理権限

【セキュリティ設定】
- パスワード有効期限：校長・システム管理者30-60日、その他90-120日
- 同時接続制限：一般ユーザー3接続まで
- 接続元制限：必要に応じてIPアドレス制限を実装
- 自動ロック：パスワード期限切れで自動ロック

【定期メンテナンス】
1. 毎日：comprehensive_user_maintenance()の実行
2. 週次：v_comprehensive_user_audit視野でのユーザー状況確認
3. 月次：不要アカウントの棚卸し・削除
4. 四半期：権限設定の見直し

【緊急時対応】
1. アカウント侵害疑い：即座にACCOUNT LOCK実行
2. 大量ログイン失敗：該当アカウントの確認・一時ロック
3. 権限昇格攻撃：システム管理者アカウントの緊急確認

【問い合わせ対応】
1. パスワードリセット：管理者がALTER USERで対応
2. 権限追加要求：役職に応じた適切な権限確認後対応
3. アカウント無効化：退職者等のアカウント即座にロック・削除

【監査要求対応】
1. v_comprehensive_user_audit視野でのレポート生成
2. user_management_logテーブルでの操作履歴確認
3. 定期的なアクセスログの分析・報告
*/

-- 監査レポートの確認
SELECT * FROM v_comprehensive_user_audit;

-- 最新の管理ログ確認
SELECT * FROM user_management_log ORDER BY created_at DESC LIMIT 10;
```

## まとめ

この章では、MySQLにおけるユーザーとロールの管理について詳しく学びました：

1. **ユーザー管理の基本概念**：
   - ユーザーアカウントの構成（ユーザー名@ホスト名）
   - 認証と認可の違い
   - 権限の階層構造（グローバル→データベース→テーブル→カラム）

2. **基本的なユーザー操作**：
   - CREATE USER文によるユーザー作成
   - ALTER USER文によるユーザー設定変更
   - DROP USER文によるユーザー削除
   - パスワードポリシーと有効期限の設定

3. **ロールベースアクセス制御**：
   - MySQL 8.0以降のロール機能
   - ロールの作成と権限付与
   - ユーザーへのロール割り当て
   - ロールのアクティベーション管理

4. **学校システムでの実践応用**：
   - 役職別ロールの設計
   - 適切な権限分離
   - セキュリティポリシーの実装
   - 接続制限とアカウント管理

5. **セキュリティ強化策**：
   - 強力なパスワードポリシー
   - 接続元制限とアクセス制御
   - アカウントロック機能
   - 定期的な監査とメンテナンス

6. **運用管理手法**：
   - 自動化されたユーザー管理プロシージャ
   - 包括的な監査システム
   - エラー処理と例外対応
   - 運用ドキュメントの整備

ユーザー管理は、データベースセキュリティの最も基本的で重要な要素です。**最小権限の原則**を守り、各ユーザーには業務に必要な最小限の権限のみを付与することが、安全なデータベース運用の鍵となります。

次の章では、「GRANT/REVOKE：権限の付与と取り消し」について学び、より詳細な権限管理の手法を理解していきます。