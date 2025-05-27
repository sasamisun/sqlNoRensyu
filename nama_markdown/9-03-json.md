# 9-3. JSON：構造化データの格納と操作

## はじめに

現代のWebアプリケーションやシステムでは、複雑な構造を持つデータを扱うことが増えています。従来のリレーショナルデータベースでは、このような構造化データを複数のテーブルに分けて保存する必要がありましたが、MySQLではJSON（JavaScript Object Notation）データ型を使って、構造化データを1つのカラムに格納できるようになりました。

学校データベースでも、以下のような場面でJSONが活用できます：

- 学生の詳細情報（趣味、スキル、連絡先情報など）
- 講座の設定情報（評価基準、カリキュラム詳細など）
- 教室の設備詳細（機器の仕様、配置情報など）
- 授業のメタデータ（使用教材、課題設定など）

この章では、MySQLでのJSON データ型の基本的な使い方から、JSON データの作成、検索、更新、操作方法について学びます。

> **用語解説**：
> - **JSON（JavaScript Object Notation）**：軽量なデータ交換フォーマットで、人間が読みやすく、機械が解析しやすい構造化データの表現方法です。
> - **構造化データ**：階層構造や複雑な関係を持つデータのことで、配列やオブジェクトなどの形式で表現されます。

## JSONデータ型とは

MySQLのJSONデータ型は、有効なJSONドキュメントを格納するために設計された専用のデータ型です。通常のTEXT型と比べて、以下の利点があります：

### JSONデータ型の利点

1. **自動検証**：無効なJSONが挿入されるとエラーになる
2. **最適化された格納**：JSON構造に最適化された内部形式で保存
3. **専用関数**：JSON操作のための豊富な関数群
4. **インデックス対応**：JSON内の特定の要素にインデックスを作成可能

### JSONの基本構造

```json
{
  "name": "田中太郎",
  "age": 20,
  "skills": ["Java", "Python", "SQL"],
  "contact": {
    "email": "tanaka@example.com",
    "phone": "090-1234-5678"
  },
  "active": true
}
```

> **用語解説**：
> - **オブジェクト**：`{}`で囲まれた、キーと値のペアの集合です。
> - **配列**：`[]`で囲まれた、値のリストです。
> - **キー**：JSONオブジェクト内でデータを識別するための文字列です。
> - **値**：文字列、数値、真偽値、null、オブジェクト、配列のいずれかです。

## JSON データの作成と挿入

### テーブルの作成

まず、JSON カラムを含むテーブルを作成してみましょう。学校データベースに学生の詳細情報を格納するテーブルを追加します：

```sql
CREATE TABLE student_profiles (
    student_id BIGINT PRIMARY KEY,
    profile_data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
```

### JSON データの挿入

#### 例1：基本的なJSON データの挿入

```sql
INSERT INTO student_profiles (student_id, profile_data) VALUES
(301, JSON_OBJECT(
    'name', '黒沢春馬',
    'birth_year', 2003,
    'skills', JSON_ARRAY('Java', 'HTML', 'CSS'),
    'contact', JSON_OBJECT(
        'email', 'kurosawa@example.com',
        'emergency_phone', '090-1111-2222'
    ),
    'interests', JSON_ARRAY('プログラミング', 'ゲーム開発', '映画鑑賞'),
    'active', true
));
```

#### 例2：文字列形式のJSON の挿入

```sql
INSERT INTO student_profiles (student_id, profile_data) VALUES
(302, '{
    "name": "新垣愛留",
    "birth_year": 2004,
    "skills": ["Python", "データ分析", "機械学習"],
    "contact": {
        "email": "aragaki@example.com",
        "emergency_phone": "090-2222-3333"
    },
    "interests": ["AI", "データサイエンス", "読書"],
    "active": true
}'),
(303, '{
    "name": "柴崎春花",
    "birth_year": 2003,
    "skills": ["JavaScript", "React", "Node.js"],
    "contact": {
        "email": "shibasaki@example.com", 
        "emergency_phone": "090-3333-4444"
    },
    "interests": ["Webデザイン", "UI/UX", "音楽"],
    "active": true
}');
```

> **用語解説**：
> - **JSON_OBJECT()関数**：キーと値のペアからJSONオブジェクトを作成する関数です。
> - **JSON_ARRAY()関数**：複数の値からJSON配列を作成する関数です。

## JSON データの検索と抽出

### JSON_EXTRACT() 関数：値の抽出

JSON データから特定の値を抽出するには `JSON_EXTRACT()` 関数または `->` 演算子を使用します。

> **用語解説**：
> - **JSON_EXTRACT()関数**：JSONドキュメントから指定したパスの値を抽出する関数です。
> - **JSONパス**：JSON内の特定の要素を指定するための記法（例：$.name、$.contact.email）です。

#### 基本構文

```sql
JSON_EXTRACT(json_doc, path)
-- または短縮形
json_doc -> path
-- 引用符を除去する場合
json_doc ->> path
```

#### 例1：基本的な値の抽出

```sql
SELECT student_id,
       profile_data -> '$.name' AS 名前,
       profile_data -> '$.birth_year' AS 生年,
       profile_data ->> '$.contact.email' AS メールアドレス
FROM student_profiles;
```

実行結果：
| student_id | 名前      | 生年 | メールアドレス           |
|-----------|----------|------|------------------------|
| 301       | "黒沢春馬" | 2003 | kurosawa@example.com   |
| 302       | "新垣愛留" | 2004 | aragaki@example.com    |
| 303       | "柴崎春花" | 2003 | shibasaki@example.com  |

#### 例2：配列要素の抽出

```sql
SELECT student_id,
       profile_data ->> '$.name' AS 名前,
       profile_data -> '$.skills[0]' AS 主要スキル1,
       profile_data -> '$.skills[1]' AS 主要スキル2,
       JSON_LENGTH(profile_data -> '$.skills') AS スキル数
FROM student_profiles;
```

実行結果：
| student_id | 名前     | 主要スキル1 | 主要スキル2 | スキル数 |
|-----------|---------|-----------|-----------|---------|
| 301       | 黒沢春馬 | "Java"    | "HTML"    | 3       |
| 302       | 新垣愛留 | "Python"  | "データ分析" | 3       |
| 303       | 柴崎春花 | "JavaScript" | "React" | 3       |

### JSON検索関数

#### JSON_CONTAINS()関数：値の存在確認

JSON内に特定の値が含まれているかを確認します。

```sql
-- 特定のスキルを持つ学生を検索
SELECT student_id,
       profile_data ->> '$.name' AS 名前,
       profile_data -> '$.skills' AS スキル一覧
FROM student_profiles
WHERE JSON_CONTAINS(profile_data -> '$.skills', '"Java"');
```

#### JSON_SEARCH()関数：値の位置検索

JSON内で特定の値の位置（パス）を検索します。

```sql
-- メールアドレスに'kurosawa'を含む学生を検索
SELECT student_id,
       profile_data ->> '$.name' AS 名前,
       JSON_SEARCH(profile_data, 'one', '%kurosawa%') AS 検索結果パス
FROM student_profiles
WHERE JSON_SEARCH(profile_data, 'one', '%kurosawa%') IS NOT NULL;
```

### WHERE句でのJSON検索

#### 例1：JSON値での条件絞り込み

```sql
-- 2003年生まれの学生を検索
SELECT student_id,
       profile_data ->> '$.name' AS 名前,
       profile_data -> '$.birth_year' AS 生年
FROM student_profiles
WHERE profile_data -> '$.birth_year' = 2003;
```

#### 例2：JSON配列での検索

```sql
-- 'プログラミング'に興味がある学生を検索
SELECT student_id,
       profile_data ->> '$.name' AS 名前,
       profile_data -> '$.interests' AS 興味分野
FROM student_profiles
WHERE JSON_CONTAINS(profile_data -> '$.interests', '"プログラミング"');
```

## JSON データの更新

### JSON_SET()関数：値の設定・更新

既存のJSONデータに新しい値を設定したり、既存の値を更新したりします。

> **用語解説**：
> - **JSON_SET()関数**：JSONドキュメント内の指定したパスに値を設定する関数です。パスが存在しない場合は新規作成し、存在する場合は上書きします。

#### 例1：既存の値を更新

```sql
-- 学生の生年を更新
UPDATE student_profiles 
SET profile_data = JSON_SET(profile_data, '$.birth_year', 2004)
WHERE student_id = 301;
```

#### 例2：新しい要素を追加

```sql
-- 学生に新しい情報（GPAスコア）を追加
UPDATE student_profiles 
SET profile_data = JSON_SET(
    profile_data, 
    '$.gpa', 3.8,
    '$.last_updated', NOW()
)
WHERE student_id = 301;
```

### JSON_INSERT()関数：新規追加のみ

値が存在しない場合のみ新しい値を追加します。

```sql
-- 存在しない場合のみ、学習時間の情報を追加
UPDATE student_profiles 
SET profile_data = JSON_INSERT(profile_data, '$.study_hours_per_week', 25)
WHERE student_id = 302;
```

### JSON_REPLACE()関数：既存値の置換のみ

既存の値のみを置換し、新しい要素は追加しません。

```sql
-- 既存のメールアドレスのみを更新
UPDATE student_profiles 
SET profile_data = JSON_REPLACE(
    profile_data, 
    '$.contact.email', 'new.kurosawa@example.com'
)
WHERE student_id = 301;
```

## JSON配列の操作

### JSON_ARRAY_APPEND()関数：配列要素の追加

既存の配列に新しい要素を追加します。

```sql
-- スキルに新しい項目を追加
UPDATE student_profiles 
SET profile_data = JSON_ARRAY_APPEND(
    profile_data, 
    '$.skills', 'Docker'
)
WHERE student_id = 301;
```

### JSON_ARRAY_INSERT()関数：配列の特定位置に挿入

配列の指定した位置に新しい要素を挿入します。

```sql
-- スキルの最初に新しい項目を挿入
UPDATE student_profiles 
SET profile_data = JSON_ARRAY_INSERT(
    profile_data, 
    '$.skills[0]', 'Git'
)
WHERE student_id = 302;
```

### JSON_REMOVE()関数：要素の削除

JSON から特定の要素を削除します。

```sql
-- 特定のスキルを削除
UPDATE student_profiles 
SET profile_data = JSON_REMOVE(profile_data, '$.skills[2]')
WHERE student_id = 303;
```

## JSON データの集計と分析

### 例1：スキル別の学生数集計

```sql
SELECT skill,
       COUNT(*) AS 学生数
FROM student_profiles,
     JSON_TABLE(profile_data, '$.skills[*]' 
                COLUMNS (skill VARCHAR(50) PATH '$')) AS skills_table
GROUP BY skill
ORDER BY 学生数 DESC;
```

### 例2：生年別の分析

```sql
SELECT profile_data -> '$.birth_year' AS 生年,
       COUNT(*) AS 人数,
       GROUP_CONCAT(profile_data ->> '$.name') AS 学生名一覧
FROM student_profiles
GROUP BY profile_data -> '$.birth_year';
```

### 例3：アクティブな学生の興味分野分析

```sql
SELECT interest,
       COUNT(*) AS 興味を持つ学生数
FROM student_profiles,
     JSON_TABLE(profile_data, '$.interests[*]' 
                COLUMNS (interest VARCHAR(100) PATH '$')) AS interests_table
WHERE profile_data -> '$.active' = true
GROUP BY interest
ORDER BY 興味を持つ学生数 DESC;
```

## 実践例：学校データベースでのJSON活用

### 例1：講座設定情報の管理

```sql
-- 講座の詳細設定を格納するテーブル
CREATE TABLE course_settings (
    course_id VARCHAR(16) PRIMARY KEY,
    settings JSON,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 講座設定の挿入
INSERT INTO course_settings (course_id, settings) VALUES
('1', '{
    "grading": {
        "midterm_weight": 0.3,
        "final_weight": 0.4,
        "assignments_weight": 0.2,
        "participation_weight": 0.1
    },
    "requirements": ["基礎数学", "コンピュータリテラシー"],
    "tools": ["Eclipse", "MySQL Workbench"],
    "difficulty_level": "初級",
    "estimated_hours": 60
}');
```

### 例2：教室の詳細設備情報

```sql
-- 教室の設備詳細を管理
CREATE TABLE classroom_details (
    classroom_id VARCHAR(16) PRIMARY KEY,
    equipment JSON,
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id)
);

-- 設備詳細の挿入
INSERT INTO classroom_details (classroom_id, equipment) VALUES
('101A', '{
    "computers": {
        "count": 30,
        "specs": {
            "cpu": "Intel Core i5",
            "ram": "8GB",
            "storage": "256GB SSD"
        },
        "software": ["Windows 11", "Office 2021", "Visual Studio"]
    },
    "projector": {
        "model": "EPSON EB-X41",
        "resolution": "1024x768"
    },
    "network": {
        "wifi": true,
        "ethernet_ports": 32
    },
    "accessibility": ["車椅子対応", "視覚支援機器"]
}');
```

## 練習問題

### 問題9-3-1
student_profiles テーブルを作成し、学生ID 304 の学生について、名前「森下風凛」、生年2003、スキル「["HTML", "CSS", "Photoshop"]」、メールアドレス「morishita@example.com」の情報を挿入するSQLを書いてください。

### 問題9-3-2
student_profiles テーブルから、すべての学生の名前とスキルの数を取得するSQLを書いてください。

### 問題9-3-3
student_profiles テーブルから、「HTML」スキルを持つ学生の名前とメールアドレスを取得するSQLを書いてください。

### 問題9-3-4
student_profiles テーブルで、学生ID 301 のスキル配列に「Kubernetes」を追加するSQLを書いてください。

### 問題9-3-5
student_profiles テーブルから、2003年生まれの学生の名前と興味分野を取得するSQLを書いてください。

### 問題9-3-6
student_profiles テーブルで、学生ID 302 の緊急連絡先電話番号を「090-5555-6666」に更新するSQLを書いてください。

### 問題9-3-7
student_profiles テーブルから、興味分野に「AI」を含む学生数を取得するSQLを書いてください。

### 問題9-3-8
student_profiles テーブルで、学生ID 303 のプロフィールから2番目のスキルを削除するSQLを書いてください。

### 問題9-3-9
student_profiles テーブルから、各学生について名前と「スキル：○○」という形式でスキルを1つの文字列として表示するSQLを書いてください。

### 問題9-3-10
student_profiles テーブルから、アクティブな学生（active = true）の中で、メールアドレスのドメインが「example.com」の学生の名前を取得するSQLを書いてください。

## 解答と詳細な解説

### 解答9-3-1
```sql
-- テーブル作成
CREATE TABLE student_profiles (
    student_id BIGINT PRIMARY KEY,
    profile_data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- データ挿入
INSERT INTO student_profiles (student_id, profile_data) VALUES
(304, '{
    "name": "森下風凛",
    "birth_year": 2003,
    "skills": ["HTML", "CSS", "Photoshop"],
    "contact": {
        "email": "morishita@example.com"
    }
}');
```

**解説**：
- JSONデータ型のカラムを持つテーブルを作成
- JSON文字列形式でデータを挿入
- 外部キー制約により、既存の学生IDとの整合性を保つ
- 配列形式でスキル情報を格納し、オブジェクト形式で連絡先情報を構造化

### 解答9-3-2
```sql
SELECT profile_data ->> '$.name' AS 名前,
       JSON_LENGTH(profile_data -> '$.skills') AS スキル数
FROM student_profiles;
```

**解説**：
- `->>` 演算子で引用符なしの文字列として名前を取得
- `JSON_LENGTH()` 関数で配列の要素数を取得
- `->` 演算子でJSONパスを指定してskills配列にアクセス

### 解答9-3-3
```sql
SELECT profile_data ->> '$.name' AS 名前,
       profile_data ->> '$.contact.email' AS メールアドレス
FROM student_profiles
WHERE JSON_CONTAINS(profile_data -> '$.skills', '"HTML"');
```

**解説**：
- `JSON_CONTAINS()` 関数で配列内の特定の値の存在を確認
- 検索する値は引用符で囲む必要がある（`"HTML"`）
- ネストしたオブジェクトのプロパティは`.`で連結してアクセス

### 解答9-3-4
```sql
UPDATE student_profiles 
SET profile_data = JSON_ARRAY_APPEND(profile_data, '$.skills', 'Kubernetes')
WHERE student_id = 301;
```

**解説**：
- `JSON_ARRAY_APPEND()` 関数で既存の配列に新しい要素を追加
- 配列の末尾に要素が追加される
- WHERE句で特定の学生のみを対象に更新

### 解答9-3-5
```sql
SELECT profile_data ->> '$.name' AS 名前,
       profile_data -> '$.interests' AS 興味分野
FROM student_profiles
WHERE profile_data -> '$.birth_year' = 2003;
```

**解説**：
- JSON内の数値フィールドでの条件指定
- 興味分野は配列形式で格納されているため、そのまま表示
- 等価比較演算子（=）でJSON内の値を直接比較

### 解答9-3-6
```sql
UPDATE student_profiles 
SET profile_data = JSON_SET(profile_data, '$.contact.emergency_phone', '090-5555-6666')
WHERE student_id = 302;
```

**解説**：
- `JSON_SET()` 関数で既存の値を更新または新規追加
- ネストしたオブジェクト内のプロパティを指定
- 値が存在しない場合は新規作成、存在する場合は上書き

### 解答9-3-7
```sql
SELECT COUNT(*) AS AI興味学生数
FROM student_profiles
WHERE JSON_CONTAINS(profile_data -> '$.interests', '"AI"');
```

**解説**：
- `COUNT(*)` で条件に合致する行数を集計
- `JSON_CONTAINS()` で配列内の特定の値の存在を確認
- 文字列値の検索時は引用符で囲む必要がある

### 解答9-3-8
```sql
UPDATE student_profiles 
SET profile_data = JSON_REMOVE(profile_data, '$.skills[1]')
WHERE student_id = 303;
```

**解説**：
- `JSON_REMOVE()` 関数で指定したパスの要素を削除
- 配列のインデックスは0から始まるため、`[1]`は2番目の要素
- 削除後は残りの要素が自動的に詰められる

### 解答9-3-9
```sql
SELECT profile_data ->> '$.name' AS 名前,
       CONCAT('スキル：', 
              REPLACE(
                  REPLACE(
                      JSON_EXTRACT(profile_data, '$.skills'), 
                      '[', ''
                  ), 
                  ']', ''
              )
       ) AS スキル一覧
FROM student_profiles;
```

**解説**：
- `JSON_EXTRACT()` で配列全体を取得
- `REPLACE()` 関数で配列の角括弧を除去
- `CONCAT()` で「スキル：」プレフィックスを追加
- 複数の文字列関数を組み合わせてデータを整形

### 解答9-3-10
```sql
SELECT profile_data ->> '$.name' AS 名前
FROM student_profiles
WHERE profile_data -> '$.active' = true
  AND profile_data ->> '$.contact.email' LIKE '%@example.com';
```

**解説**：
- 複数のJSON条件を組み合わせ
- `profile_data -> '$.active' = true` でアクティブ状態を確認
- `LIKE` 演算子でメールアドレスのドメイン部分をパターンマッチング
- `->>` 演算子で文字列として値を取得してLIKE検索に使用

## まとめ

この章では、MySQLにおけるJSONデータの格納と操作について学びました：

1. **JSONデータ型の基本**：従来のテキスト型との違いとJSONの利点
2. **JSON データの作成**：JSON_OBJECT()、JSON_ARRAY()による構造化データの作成
3. **JSON データの検索**：JSON_EXTRACT()、->、->>演算子による値の抽出
4. **JSON データの更新**：JSON_SET()、JSON_INSERT()、JSON_REPLACE()による値の変更
5. **JSON配列の操作**：要素の追加、挿入、削除
6. **JSON データの集計**：JSON_TABLE()を使った集計分析
7. **実践的な活用**：学校データベースでの具体的なJSON活用例

JSONデータ型は、複雑な構造を持つデータを効率的に格納し、柔軟に操作できる強力な機能です。特に設定情報、メタデータ、ユーザープロファイルなどの用途で威力を発揮します。ただし、リレーショナルデータベースの正規化の原則とのバランスを考慮して、適切な場面で使用することが重要です。

次のセクションでは、「地理空間データ：位置情報の取り扱い」について学び、位置データの格納と空間検索の技術を習得します。