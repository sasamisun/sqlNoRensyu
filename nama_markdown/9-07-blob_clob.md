# 9-7. 大きなオブジェクト（BLOB/CLOB）：バイナリデータの格納

## はじめに

現代の情報システムでは、テキストや数値データだけでなく、画像、動画、音声、文書ファイルなどの大きなバイナリデータを扱うことが一般的になっています。

学校データベースでは、以下のような場面で大きなオブジェクトデータが必要になります：

- **学生証明写真**：入学時や在学証明書用の写真データ
- **教材ファイル**：PDF資料、PowerPointスライド、動画教材
- **課題提出**：学生が提出するレポートファイル、プログラムファイル
- **授業録画**：オンライン授業の動画ファイル
- **音声データ**：語学学習用の音声ファイル、講義録音
- **スキャンデータ**：手書きノートや試験答案のスキャン画像
- **システムログ**：大容量のログファイルやデバッグ情報

MySQLでは、このような大きなデータを効率的に格納するために、BLOB（Binary Large Object）とTEXT（Character Large Object）という専用のデータ型が提供されています。この章では、これらのデータ型の特徴と使い方を学びます。

> **用語解説**：
> - **BLOB（Binary Large Object）**：画像、動画、音声などのバイナリデータを格納するためのデータ型です。
> - **CLOB（Character Large Object）**：大量のテキストデータを格納するためのデータ型で、MySQLではTEXT型がこれに相当します。
> - **バイナリデータ**：文字として解釈されない生のデータのことで、画像ファイルや実行ファイルなどが該当します。

## BLOBとTEXTデータ型の種類

MySQLでは、データのサイズに応じて複数のBLOB/TEXTデータ型が用意されています。

### BLOBデータ型（バイナリデータ用）

| データ型 | 最大サイズ | 用途例 |
|---------|-----------|--------|
| **TINYBLOB** | 255バイト | 小さなアイコン、短いバイナリデータ |
| **BLOB** | 65KB (64KB) | 一般的な画像ファイル、小さな文書 |
| **MEDIUMBLOB** | 16MB | 高解像度画像、短い動画、音声ファイル |
| **LONGBLOB** | 4GB | 長時間動画、大きな文書ファイル |

### TEXTデータ型（テキストデータ用）

| データ型 | 最大サイズ | 用途例 |
|---------|-----------|--------|
| **TINYTEXT** | 255文字 | 短いコメント、概要 |
| **TEXT** | 65KB | 一般的な文書、レポート |
| **MEDIUMTEXT** | 16MB | 長い文書、書籍テキスト |
| **LONGTEXT** | 4GB | 大量のログデータ、全文データ |

> **用語解説**：
> - **KB（キロバイト）**：約1,000バイトの単位で、1KB = 1,024バイトです。
> - **MB（メガバイト）**：約100万バイトの単位で、1MB = 1,024KBです。
> - **GB（ギガバイト）**：約10億バイトの単位で、1GB = 1,024MBです。

## 大きなオブジェクト用テーブルの作成

学校データベースで大きなオブジェクトを活用するためのテーブルを作成しましょう。

### 学生写真テーブルの作成

```sql
-- 学生の証明写真を保存するテーブル
CREATE TABLE student_photos (
    photo_id VARCHAR(16) PRIMARY KEY,
    student_id BIGINT NOT NULL,
    photo_type VARCHAR(20), -- 'profile', 'id_card', 'graduation'
    image_data MEDIUMBLOB,
    image_format VARCHAR(10), -- 'JPEG', 'PNG', 'GIF'
    image_size INT, -- バイト数
    image_width INT, -- ピクセル幅
    image_height INT, -- ピクセル高さ
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    INDEX idx_student_type (student_id, photo_type),
    INDEX idx_upload_date (upload_date)
);
```

### 教材ファイルテーブルの作成

```sql
-- 教材ファイルを保存するテーブル
CREATE TABLE course_files (
    file_id VARCHAR(16) PRIMARY KEY,
    course_id VARCHAR(16),
    teacher_id BIGINT,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(50), -- 'pdf', 'pptx', 'docx', 'mp4', 'mp3'
    file_data LONGBLOB,
    file_size BIGINT, -- バイト数
    mime_type VARCHAR(100), -- 'application/pdf', 'video/mp4', など
    description TEXT,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_accessed TIMESTAMP,
    download_count INT DEFAULT 0,
    is_public BOOLEAN DEFAULT FALSE,
    
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    INDEX idx_course_type (course_id, file_type),
    INDEX idx_public_files (is_public, file_type),
    INDEX idx_upload_date (upload_date)
);
```

### 学生提出物テーブルの作成

```sql
-- 学生の課題提出ファイルを保存するテーブル
CREATE TABLE student_submissions (
    submission_id VARCHAR(16) PRIMARY KEY,
    student_id BIGINT NOT NULL,
    course_id VARCHAR(16) NOT NULL,
    assignment_name VARCHAR(200),
    submitted_file LONGBLOB,
    file_name VARCHAR(255),
    file_type VARCHAR(50),
    file_size BIGINT,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    submission_text LONGTEXT, -- テキスト形式の提出内容
    teacher_comments MEDIUMTEXT, -- 教師のフィードバック
    grade_score DECIMAL(5,2),
    
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    INDEX idx_student_course (student_id, course_id),
    INDEX idx_submission_date (submission_date),
    INDEX idx_assignment (assignment_name)
);
```

### システムログテーブルの作成

```sql
-- システムの詳細ログを保存するテーブル
CREATE TABLE system_logs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    log_level VARCHAR(20), -- 'INFO', 'WARNING', 'ERROR', 'DEBUG'
    log_source VARCHAR(100), -- ログの出力元
    log_message TEXT,
    detailed_log LONGTEXT, -- 詳細なログ情報
    log_data MEDIUMBLOB, -- バイナリ形式のログデータ
    user_id BIGINT,
    session_id VARCHAR(64),
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_level_date (log_level, created_at),
    INDEX idx_source_date (log_source, created_at),
    INDEX idx_user_date (user_id, created_at)
);
```

## BLOBデータの挿入と基本操作

### バイナリデータの挿入

バイナリデータをBLOBカラムに挿入する方法は複数あります。

#### 例1：HEX形式でのデータ挿入

```sql
-- 小さな画像データ（サンプル）をHEX形式で挿入
INSERT INTO student_photos (
    photo_id, student_id, photo_type, image_data, 
    image_format, image_size, image_width, image_height, notes
) VALUES (
    'PHT001', 301, 'profile',
    UNHEX('FFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080001000103012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B5110002010204040304070504040001027700010203110405213106124151076171132281913214227381A1B14232C152D1F016242533430A171819E125356491A2643443456537283726F1C120E1F255643747384859465A6B6C6D6E6F7485969748595A65A666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00'),
    'JPEG', 2048, 100, 100, '入学時に撮影された証明写真'
);
```

#### 例2：LOAD_FILE()関数での外部ファイル読み込み

```sql
-- 外部ファイルからデータを読み込んで挿入
INSERT INTO course_files (
    file_id, course_id, teacher_id, file_name, 
    file_type, file_data, file_size, mime_type, description
) VALUES (
    'FILE001', '1', 101, 'IT基礎知識_第1章.pdf',
    'pdf', LOAD_FILE('/path/to/textbook_chapter1.pdf'),
    (SELECT OCTET_LENGTH(LOAD_FILE('/path/to/textbook_chapter1.pdf'))),
    'application/pdf', 'IT基礎知識の第1章テキスト'
);
```

> **注意**：LOAD_FILE()関数を使用するには、MySQLサーバーに適切なファイルアクセス権限が必要です。また、セキュリティ上の理由から、多くの本番環境では制限されています。

### 大きなテキストデータの挿入

```sql
-- 長いテキストデータの挿入
INSERT INTO student_submissions (
    submission_id, student_id, course_id, assignment_name,
    file_name, file_type, submission_text, teacher_comments
) VALUES (
    'SUB001', 301, '1', 'ITの社会的影響レポート',
    'report_kurosawa.txt', 'text',
    'ITの社会的影響について

現代社会において、情報技術（IT）は私たちの生活のあらゆる面に深く浸透し、社会構造そのものを変革しています。本レポートでは、ITが社会に与える多面的な影響について詳細に分析し、その光と影の両面を考察します。

第1章：デジタル変革の概要
ITの普及により、従来のアナログベースの社会システムが急速にデジタル化されています。この変化は、効率性の向上、情報アクセスの民主化、新たなビジネスモデルの創出など、多くの利益をもたらしています。一方で、デジタルデバイドの拡大、プライバシーの侵害、サイバーセキュリティの脅威など、新たな課題も生み出しています。

第2章：経済への影響
IT産業の成長は、世界経済の重要な牽引力となっています。電子商取引の拡大により、従来の小売業界が大きく変化し、新しい雇用機会が創出される一方で、既存の職業が自動化により脅威にさらされています。また、フィンテック革命により、金融サービスの在り方も根本的に変化しています。

第3章：教育への影響
オンライン教育プラットフォームの普及により、教育へのアクセスが大幅に向上しました。地理的制約を超えて質の高い教育を受けることが可能になり、生涯学習の概念も変化しています。しかし、対面教育の重要性や、デジタルリテラシーの格差など、解決すべき課題も多く存在します。

第4章：社会インフラへの影響
スマートシティの概念により、都市インフラの効率性と持続可能性が向上しています。IoT技術の活用により、交通システム、エネルギー管理、廃棄物処理などが最適化されています。しかし、システムの複雑化により、障害時の影響範囲も拡大しています。

第5章：コミュニケーションへの影響
ソーシャルメディアの普及により、人々のコミュニケーション方法が大きく変化しました。距離を超えたつながりが可能になった一方で、フェイクニュースの拡散、エコーチェンバー効果、サイバーいじめなどの問題も深刻化しています。

結論：
ITの社会的影響は多岐にわたり、その恩恵を最大化しながら負の側面を最小化するためには、技術開発者、政策立案者、市民が協力して取り組む必要があります。デジタルリテラシーの向上、適切な規制の整備、倫理的なガイドラインの策定が急務です。

今後のIT発展においては、単なる技術的進歩だけでなく、社会全体の福祉と持続可能性を考慮したアプローチが求められます。私たち一人一人が、ITの恩恵を享受しながらも、その責任ある使用について考え続けることが重要です。',
    '内容が充実しており、多角的な視点からITの影響を分析できています。特に具体例を用いた説明が効果的です。今後は、より最新の技術動向（AI、ブロックチェーンなど）についても触れると、さらに良いレポートになるでしょう。'
);
```

## BLOBデータの検索と取得

### データサイズによる検索

```sql
-- ファイルサイズが1MB以上の教材を検索
SELECT file_id, file_name, file_type, 
       ROUND(file_size / 1024 / 1024, 2) AS サイズMB,
       upload_date
FROM course_files
WHERE file_size > 1024 * 1024
ORDER BY file_size DESC;
```

### メタデータによる検索

```sql
-- 特定の形式の画像ファイルを検索
SELECT photo_id, student_id, photo_type, 
       image_format, image_width, image_height,
       ROUND(image_size / 1024, 2) AS サイズKB
FROM student_photos
WHERE image_format = 'JPEG' 
  AND image_width >= 200 
  AND image_height >= 200;
```

### データの部分取得

```sql
-- BLOBデータの最初の100バイトのみを取得
SELECT file_id, file_name,
       LEFT(file_data, 100) AS ファイルヘッダー,
       HEX(LEFT(file_data, 20)) AS ヘッダーHEX
FROM course_files
WHERE file_type = 'pdf'
LIMIT 3;
```

## BLOBデータの操作関数

### LENGTH()とOCTET_LENGTH()関数

```sql
-- データサイズの取得
SELECT file_id, file_name,
       LENGTH(file_data) AS データ長,
       OCTET_LENGTH(file_data) AS バイト数,
       file_size AS 記録サイズ
FROM course_files
WHERE file_data IS NOT NULL
LIMIT 5;
```

### HEX()とUNHEX()関数

```sql
-- バイナリデータを16進数文字列に変換
SELECT photo_id,
       HEX(LEFT(image_data, 10)) AS 画像ヘッダーHEX,
       image_format
FROM student_photos
WHERE image_data IS NOT NULL;
```

### SUBSTRING()関数でのバイナリデータ操作

```sql
-- バイナリデータの特定位置からの抽出
SELECT file_id, file_name,
       HEX(SUBSTRING(file_data, 1, 4)) AS ファイルシグネチャ,
       CASE 
         WHEN HEX(SUBSTRING(file_data, 1, 4)) = '25504446' THEN 'PDF'
         WHEN HEX(SUBSTRING(file_data, 1, 2)) = 'FFD8' THEN 'JPEG'
         WHEN HEX(SUBSTRING(file_data, 1, 8)) = '89504E470D0A1A0A' THEN 'PNG'
         ELSE 'Unknown'
       END AS ファイル種別判定
FROM course_files
WHERE file_data IS NOT NULL;
```

## パフォーマンスとストレージの考慮事項

### インデックス戦略

```sql
-- BLOBカラムを除いたインデックス作成
CREATE INDEX idx_file_metadata ON course_files (file_type, file_size, upload_date);
CREATE INDEX idx_photo_metadata ON student_photos (student_id, photo_type, image_format);

-- 部分インデックスの作成（TEXT型の場合）
CREATE INDEX idx_submission_text_partial ON student_submissions (submission_text(100));
```

### ストレージサイズの監視

```sql
-- テーブルごとのストレージ使用量を確認
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS テーブルサイズMB,
    ROUND((data_length / 1024 / 1024), 2) AS データサイズMB,
    ROUND((index_length / 1024 / 1024), 2) AS インデックスサイズMB,
    table_rows AS 行数
FROM information_schema.tables
WHERE table_schema = DATABASE()
  AND table_name IN ('student_photos', 'course_files', 'student_submissions')
ORDER BY (data_length + index_length) DESC;
```

### データ圧縮と最適化

```sql
-- 大きなデータの圧縮状況確認
SELECT file_id, file_name, file_type,
       file_size AS 元サイズ,
       LENGTH(file_data) AS 保存サイズ,
       ROUND((file_size - LENGTH(file_data)) / file_size * 100, 2) AS 圧縮率パーセント
FROM course_files
WHERE file_size > 0 AND file_data IS NOT NULL;
```

## 実践例：ファイル管理システム

### 例1：ファイルアップロード管理

```sql
-- ファイルアップロード処理のシミュレーション
DELIMITER $$

CREATE PROCEDURE UploadCourseFile(
    IN p_file_id VARCHAR(16),
    IN p_course_id VARCHAR(16),
    IN p_teacher_id BIGINT,
    IN p_file_name VARCHAR(255),
    IN p_file_type VARCHAR(50),
    IN p_file_data LONGBLOB,
    IN p_mime_type VARCHAR(100),
    IN p_description TEXT
)
BEGIN
    DECLARE file_size_bytes BIGINT;
    
    -- ファイルサイズを計算
    SET file_size_bytes = IFNULL(LENGTH(p_file_data), 0);
    
    -- ファイル情報を挿入
    INSERT INTO course_files (
        file_id, course_id, teacher_id, file_name, file_type,
        file_data, file_size, mime_type, description,
        upload_date
    ) VALUES (
        p_file_id, p_course_id, p_teacher_id, p_file_name, p_file_type,
        p_file_data, file_size_bytes, p_mime_type, p_description,
        NOW()
    );
    
    -- アップロード成功のログ記録（簡略化）
    INSERT INTO system_logs (log_level, log_source, log_message, user_id)
    VALUES ('INFO', 'FILE_UPLOAD', 
            CONCAT('File uploaded: ', p_file_name, ' (', file_size_bytes, ' bytes)'),
            p_teacher_id);
            
END$$

DELIMITER ;
```

### 例2：ファイルダウンロード追跡

```sql
-- ファイルダウンロード追跡の処理
CREATE VIEW popular_files AS
SELECT cf.file_id,
       cf.file_name,
       cf.file_type,
       c.course_name,
       t.teacher_name,
       cf.download_count,
       ROUND(cf.file_size / 1024 / 1024, 2) AS サイズMB,
       cf.upload_date,
       cf.last_accessed
FROM course_files cf
JOIN courses c ON cf.course_id = c.course_id
JOIN teachers t ON cf.teacher_id = t.teacher_id
WHERE cf.is_public = TRUE
ORDER BY cf.download_count DESC, cf.upload_date DESC;
```

### 例3：ストレージクリーンアップ

```sql
-- 古くて使用されていないファイルの特定
SELECT file_id, file_name, file_type,
       ROUND(file_size / 1024 / 1024, 2) AS サイズMB,
       upload_date,
       IFNULL(last_accessed, upload_date) AS 最終アクセス,
       DATEDIFF(NOW(), IFNULL(last_accessed, upload_date)) AS 未使用日数
FROM course_files
WHERE DATEDIFF(NOW(), IFNULL(last_accessed, upload_date)) > 365
  AND download_count = 0
ORDER BY file_size DESC;
```

## セキュリティとアクセス制御

### ファイルアクセス権限の管理

```sql
-- ファイルアクセス権限テーブル
CREATE TABLE file_permissions (
    permission_id VARCHAR(16) PRIMARY KEY,
    file_id VARCHAR(16),
    user_type VARCHAR(20), -- 'student', 'teacher', 'admin'
    user_id BIGINT,
    permission_level VARCHAR(20), -- 'read', 'write', 'admin'
    granted_by BIGINT,
    granted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_date TIMESTAMP NULL,
    
    FOREIGN KEY (file_id) REFERENCES course_files(file_id),
    INDEX idx_file_user (file_id, user_type, user_id),
    INDEX idx_expiry (expires_date)
);
```

### 安全なファイル取得

```sql
-- 権限チェック付きファイル取得
SELECT cf.file_id, cf.file_name, cf.mime_type,
       cf.file_data
FROM course_files cf
JOIN file_permissions fp ON cf.file_id = fp.file_id
WHERE cf.file_id = 'FILE001'
  AND fp.user_id = 301
  AND fp.permission_level IN ('read', 'admin')
  AND (fp.expires_date IS NULL OR fp.expires_date > NOW());
```

## 練習問題

### 問題9-7-1
student_photos テーブルから、すべての学生の写真情報（写真ID、学生ID、写真タイプ、画像形式、ファイルサイズ）を取得するSQLを書いてください。

### 問題9-7-2
course_files テーブルから、ファイルサイズが500KB以上のPDFファイルを検索し、ファイル名、サイズ（MB単位）、アップロード日を表示するSQLを書いてください。

### 問題9-7-3
student_submissions テーブルから、提出テキストの文字数が1000文字以上のレポートを検索し、学生ID、課題名、文字数を表示するSQLを書いてください。

### 問題9-7-4
student_photos テーブルから、各学生の写真枚数を集計するSQLを書いてください。

### 問題9-7-5
course_files テーブルから、各講座の教材ファイル数と総ファイルサイズ（MB単位）を計算するSQLを書いてください。

### 問題9-7-6
system_logs テーブルから、エラーレベルのログで詳細ログ（detailed_log）がNULLでないレコードを検索するSQLを書いてください。

### 問題9-7-7
student_submissions テーブルから、ファイル提出がない（submitted_file が NULL）学生のレポートを検索し、テキスト提出の文字数も表示するSQLを書いてください。

### 問題9-7-8
course_files テーブルから、各ファイルタイプ別の平均ファイルサイズと最大ファイルサイズを計算するSQLを書いてください。

### 問題9-7-9
student_photos テーブルから、画像の幅と高さが同じ（正方形）の写真を検索するSQLを書いてください。

### 問題9-7-10
course_files テーブルから、最近30日以内にアップロードされたファイルの中で、ダウンロード数が0回のファイルを検索し、ファイル名、サイズ、アップロード日を表示するSQLを書いてください。

## 解答と詳細な解説

### 解答9-7-1
```sql
SELECT photo_id,
       student_id,
       photo_type,
       image_format,
       ROUND(image_size / 1024, 2) AS ファイルサイズKB
FROM student_photos
ORDER BY student_id, photo_type;
```

**解説**：
- ROUND()関数でバイト単位のサイズをKB単位に変換
- 1024で割ることでバイトをキロバイトに変換
- ORDER BYで学生IDと写真タイプ順に並び替え

### 解答9-7-2
```sql
SELECT file_name,
       ROUND(file_size / 1024 / 1024, 2) AS サイズMB,
       upload_date
FROM course_files
WHERE file_type = 'pdf' 
  AND file_size >= 500 * 1024
ORDER BY file_size DESC;
```

**解説**：
- WHERE句で複数条件を指定（ファイルタイプとサイズ）
- 500 * 1024で500KBをバイト単位に変換
- ファイルサイズの大きい順に並び替え

### 解答9-7-3
```sql
SELECT student_id,
       assignment_name,
       CHAR_LENGTH(submission_text) AS 文字数
FROM student_submissions
WHERE CHAR_LENGTH(submission_text) >= 1000
ORDER BY 文字数 DESC;
```

**解説**：
- `CHAR_LENGTH()`関数でテキストの文字数を取得
- WHERE句で1000文字以上の条件を指定
- 文字数の多い順に並び替えて表示

### 解答9-7-4
```sql
SELECT student_id,
       COUNT(*) AS 写真枚数
FROM student_photos
GROUP BY student_id
ORDER BY 写真枚数 DESC;
```

**解説**：
- GROUP BYで学生IDごとにグループ化
- COUNT(*)で各グループの行数（写真枚数）を集計
- 写真枚数の多い順に並び替え

### 解答9-7-5
```sql
SELECT course_id,
       COUNT(*) AS ファイル数,
       ROUND(SUM(file_size) / 1024 / 1024, 2) AS 総サイズMB
FROM course_files
WHERE file_data IS NOT NULL
GROUP BY course_id
ORDER BY 総サイズMB DESC;
```

**解説**：
- GROUP BYで講座IDごとにグループ化
- COUNT(*)でファイル数、SUM(file_size)で総サイズを計算
- WHERE句でNULLデータを除外
- MB単位に変換して表示

### 解答9-7-6
```sql
SELECT log_id,
       log_source,
       log_message,
       created_at,
       CHAR_LENGTH(detailed_log) AS 詳細ログ文字数
FROM system_logs
WHERE log_level = 'ERROR' 
  AND detailed_log IS NOT NULL
ORDER BY created_at DESC;
```

**解説**：
- WHERE句で複数条件（エラーレベルかつ詳細ログが存在）
- IS NOT NULLでNULL値を除外
- CHAR_LENGTH()で詳細ログの文字数も表示
- 作成日時の新しい順に並び替え

### 解答9-7-7
```sql
SELECT student_id,
       assignment_name,
       CHAR_LENGTH(submission_text) AS テキスト文字数,
       submission_date
FROM student_submissions
WHERE submitted_file IS NULL
  AND submission_text IS NOT NULL
ORDER BY テキスト文字数 DESC;
```

**解説**：
- WHERE句でファイル提出がなく、テキスト提出がある条件
- IS NULLとIS NOT NULLを組み合わせた条件指定
- テキストのみで提出された課題を特定

### 解答9-7-8
```sql
SELECT file_type,
       COUNT(*) AS ファイル数,
       ROUND(AVG(file_size) / 1024 / 1024, 2) AS 平均サイズMB,
       ROUND(MAX(file_size) / 1024 / 1024, 2) AS 最大サイズMB
FROM course_files
WHERE file_size > 0
GROUP BY file_type
ORDER BY 平均サイズMB DESC;
```

**解説**：
- GROUP BYでファイルタイプごとに集計
- AVG()で平均、MAX()で最大値を計算
- WHERE句でサイズが0より大きいファイルのみを対象
- ファイルタイプ別の統計情報を取得

### 解答9-7-9
```sql
SELECT photo_id,
       student_id,
       photo_type,
       image_width,
       image_height,
       image_format
FROM student_photos
WHERE image_width = image_height
  AND image_width IS NOT NULL
  AND image_height IS NOT NULL
ORDER BY image_width DESC;
```

**解説**：
- WHERE句で幅と高さが等しい条件
- IS NOT NULLでNULL値を除外
- 正方形の画像を特定する条件
- 画像サイズの大きい順に並び替え

### 解答9-7-10
```sql
SELECT file_name,
       ROUND(file_size / 1024 / 1024, 2) AS サイズMB,
       upload_date,
       download_count
FROM course_files
WHERE upload_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
  AND download_count = 0
ORDER BY upload_date DESC;
```

**解説**：
- DATE_SUB()関数で30日前の日付を計算
- WHERE句で期間条件とダウンロード数条件を組み合わせ
- アップロードされたが使用されていないファイルを特定
- 新しいアップロード順に並び替え

## まとめ

この章では、MySQLにおける大きなオブジェクト（BLOB/CLOB）データの格納と操作について学びました：

1. **BLOBとTEXTデータ型の理解**：各サイズ別データ型の特徴と用途
2. **大きなオブジェクト用テーブル設計**：写真、ファイル、提出物、ログデータの効率的な格納
3. **バイナリデータの挿入**：HEX形式、LOAD_FILE()関数の使用方法
4. **BLOBデータの検索**：メタデータによる検索、サイズ条件での絞り込み
5. **データ操作関数**：LENGTH()、HEX()、SUBSTRING()などの専用関数
6. **パフォーマンス考慮事項**：インデックス戦略、ストレージ監視、データ圧縮
7. **実践的な活用**：ファイル管理システム、アクセス制御、セキュリティ対策

大きなオブジェクトデータの管理は、現代の情報システムにおいて重要な要素です。特に学校データベースのような教育コンテンツを多く扱うシステムでは、画像、動画、文書ファイルなどの効率的な管理が学習体験の質に直結します。

ただし、BLOBデータは通常のリレーショナルデータと比べてストレージ容量やパフォーマンスに大きな影響を与えるため、適切な設計と運用が重要です。特に以下の点に注意が必要です：

- **ストレージ容量の計画**：大容量データの増加を見込んだ容量設計
- **バックアップ戦略**：大きなファイルを含むバックアップの時間とストレージ考慮
- **ネットワーク負荷**：大きなデータの転送によるネットワーク負荷
- **セキュリティ**：機密性の高いファイルのアクセス制御

これらの考慮事項を適切に管理することで、BLOBデータの利点を最大限に活用できます。

## 第9章全体のまとめ

第9章「特殊なデータ型と操作」では、以下の7つのセクションを通じて、現代のデータベースシステムで重要な特殊データ型について学習しました：

1. **日付と時刻**：時間データの効率的な管理と分析
2. **文字列操作**：テキストデータの加工と検索最適化
3. **JSON**：構造化データの柔軟な格納と操作
4. **地理空間データ**：位置情報の管理と空間分析
5. **全文検索**：大量テキストからの高速情報検索
6. **XML**：階層構造データの標準的な操作方法
7. **BLOB/CLOB**：バイナリデータと大容量テキストの管理

これらの技術を組み合わせることで、従来のリレーショナルデータベースの枠を超えた、より柔軟で強力なデータ管理システムを構築できます。特に学校データベースのような多様なデータ形式を扱うシステムでは、これらの技術の適切な活用が、システムの価値と使いやすさを大幅に向上させることができます。