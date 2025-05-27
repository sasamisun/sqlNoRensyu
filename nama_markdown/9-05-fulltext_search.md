# 9-5. 全文検索：テキスト検索の最適化

## はじめに

現代の情報システムでは、大量のテキストデータから必要な情報を素早く見つけることが重要です。従来のLIKE演算子による部分一致検索では、大量のデータに対して十分なパフォーマンスを発揮できません。

学校データベースでも、以下のような場面で高度なテキスト検索が必要になります：

- **講座検索**：キーワードから関連する講座を素早く見つける
- **教材検索**：シラバスや教材の内容から関連情報を検索
- **学生レポート検索**：提出されたレポートの内容検索
- **FAQ検索**：よくある質問から適切な回答を検索
- **図書館システム**：書籍の内容や概要からの検索
- **学習記録検索**：学習ログやコメントからの情報抽出

MySQLの全文検索機能を使うことで、これらの要求に効率的に対応できます。この章では、全文検索の基本概念から実践的な活用方法まで学びます。

> **用語解説**：
> - **全文検索（Full-Text Search）**：テキスト全体を対象として、キーワードや語句を効率的に検索する技術です。
> - **インデックス**：検索速度を向上させるためのデータ構造で、全文検索では特別な全文インデックスを使用します。
> - **関連度スコア**：検索結果の各行がクエリにどの程度関連しているかを数値で表したものです。

## MySQLの全文検索の基本

MySQLでは、**MyISAM**と**InnoDB**の両方のストレージエンジンで全文検索がサポートされています。全文検索は、通常のインデックスとは異なる**全文インデックス（Full-Text Index）**を使用します。

### 全文検索の利点

1. **高速検索**：大量のテキストデータでも高速に検索可能
2. **関連度ランキング**：検索結果を関連度順に並び替え
3. **柔軟な検索**：単語の組み合わせや除外条件の指定
4. **自然言語検索**：日常言語による検索クエリ
5. **最小語長制御**：短すぎる単語の除外

### 対応データ型

全文検索は以下のデータ型で使用できます：
- `CHAR`
- `VARCHAR`
- `TEXT`（TEXT、MEDIUMTEXT、LONGTEXT）

> **用語解説**：
> - **ストレージエンジン**：データの格納と取得を行うMySQLの内部コンポーネントです。
> - **MyISAM**：高速読み取りに特化したストレージエンジンです。
> - **InnoDB**：トランザクション処理をサポートする汎用ストレージエンジンです。

## 全文検索用テーブルの準備

学校データベースで全文検索を活用するため、教材やレポートのテーブルを作成しましょう。

### 教材テーブルの作成

```sql
-- 教材・資料テーブル
CREATE TABLE course_materials (
    material_id VARCHAR(16) PRIMARY KEY,
    course_id VARCHAR(16),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    content LONGTEXT,
    material_type VARCHAR(50), -- 'textbook', 'handout', 'slides', 'video_script'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    
    -- 全文インデックスの作成
    FULLTEXT INDEX ft_title (title),
    FULLTEXT INDEX ft_description (description),
    FULLTEXT INDEX ft_content (content),
    FULLTEXT INDEX ft_all (title, description, content)
) ENGINE=InnoDB;
```

### 学生レポートテーブルの作成

```sql
-- 学生レポート・課題テーブル
CREATE TABLE student_reports (
    report_id VARCHAR(16) PRIMARY KEY,
    student_id BIGINT,
    course_id VARCHAR(16),
    title VARCHAR(200) NOT NULL,
    abstract TEXT,
    content LONGTEXT,
    keywords VARCHAR(500),
    submission_date DATE,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    
    -- 全文インデックスの作成
    FULLTEXT INDEX ft_report_title (title),
    FULLTEXT INDEX ft_report_abstract (abstract),
    FULLTEXT INDEX ft_report_content (content),
    FULLTEXT INDEX ft_report_keywords (keywords),
    FULLTEXT INDEX ft_report_all (title, abstract, content, keywords)
) ENGINE=InnoDB;
```

## サンプルデータの挿入

全文検索のテストのため、サンプルデータを挿入します。

### 教材データの挿入

```sql
INSERT INTO course_materials (material_id, course_id, title, description, content, material_type) VALUES
('MAT001', '1', 'ITの基礎知識 第1章', 'コンピュータとインターネットの基本概念について学習します', 
 'コンピュータは現代社会において欠かせない道具となっています。デジタル技術の発展により、私たちの生活は大きく変化しました。インターネットの普及によって、世界中の情報にアクセスできるようになり、コミュニケーションの方法も革新されました。本章では、コンピュータの基本構成、CPU、メモリ、ストレージについて詳しく解説し、インターネットの仕組みやプロトコルについても学習します。', 'textbook'),

('MAT002', '3', 'Cプログラミング入門', 'C言語の基本文法とプログラミングの基礎を学びます', 
 'C言語は1972年にデニス・リッチーによって開発されたプログラミング言語です。多くの現代的なプログラミング言語の基礎となっており、システムプログラミングやアプリケーション開発に広く使用されています。本教材では、変数、データ型、制御構造、関数、配列、ポインタなどのC言語の基本概念を学習します。実際のプログラム例を通して、アルゴリズムの実装方法やデバッグ技術についても習得します。', 'textbook'),

('MAT003', '5', 'データベース設計の基礎', 'リレーショナルデータベースの設計原理と正規化について', 
 'データベースは現代の情報システムにおいて中核的な役割を果たします。効率的なデータベース設計により、データの整合性を保ち、パフォーマンスを最適化できます。本章では、エンティティ関係図（ERD）の作成方法、正規化の理論と実践、インデックスの設計、SQLクエリの最適化について学習します。実際のビジネス要件から論理設計、物理設計までの一連のプロセスを通して、実践的なスキルを身につけます。', 'textbook'),

('MAT004', '4', 'Webアプリケーション開発実践', 'HTMLからJavaScriptまでのWeb技術総合', 
 'Webアプリケーション開発では、フロントエンドとバックエンドの両方の技術を理解する必要があります。HTML5によるマークアップ、CSSによるスタイリング、JavaScriptによる動的な機能実装について学習します。また、Node.jsを使用したサーバーサイド開発、データベース連携、RESTfulAPIの設計と実装についても解説します。実際のプロジェクトを通して、モダンなWeb開発のベストプラクティスを身につけます。', 'textbook');
```

### 学生レポートデータの挿入

```sql
INSERT INTO student_reports (report_id, student_id, course_id, title, abstract, content, keywords, submission_date) VALUES
('RPT001', 301, '1', 'AIの社会的影響について', 'AI技術が社会に与える影響と課題について考察', 
 '人工知能（AI）技術の急速な発展により、私たちの社会は大きな変革期を迎えています。機械学習、深層学習、自然言語処理などのAI技術は、医療、教育、交通、製造業など様々な分野で活用され始めています。しかし、AI技術の普及には多くの課題も存在します。雇用への影響、プライバシーの問題、アルゴリズムのバイアス、倫理的な判断などについて社会全体で議論する必要があります。本レポートでは、AI技術の現状と将来の可能性について分析し、社会がどのように対応すべきかについて提言します。', 
 '人工知能,AI,機械学習,社会影響,倫理,プライバシー', '2025-05-20'),

('RPT002', 302, '3', 'アルゴリズムの効率性比較', 'ソートアルゴリズムの計算量比較と実装', 
 'コンピュータサイエンスにおいて、アルゴリズムの効率性は重要な要素です。本レポートでは、代表的なソートアルゴリズムの時間計算量と空間計算量を理論的に分析し、実際の実装による性能測定を行いました。バブルソート、選択ソート、挿入ソート、マージソート、クイックソートについて、異なるデータサイズでの実行時間を測定し、Big-O記法による理論値との比較を行いました。結果として、データサイズが大きくなるにつれて、効率的なアルゴリズムの重要性が増すことが確認できました。', 
 'アルゴリズム,ソート,計算量,効率性,プログラミング,C言語', '2025-05-18'),

('RPT003', 303, '5', 'データベース正規化の実践', '学校管理システムの正規化プロセス', 
 'データベース設計において正規化は重要なプロセスです。本レポートでは、学校管理システムを例として、第1正規形から第3正規形までの正規化プロセスを実践しました。非正規化されたデータから開始し、主キーの識別、部分関数従属性の排除、推移関数従属性の排除を段階的に実施しました。正規化により、データの冗長性が削減され、更新異常、挿入異常、削除異常が解決されることを確認しました。また、パフォーマンスとのトレードオフについても考察し、実際の運用における正規化レベルの選択指針を提示します。', 
 'データベース,正規化,関数従属,主キー,冗長性,SQL', '2025-05-22'),

('RPT004', 304, '4', 'レスポンシブWebデザインの実装', 'モバイルファーストアプローチによるWebサイト構築', 
 'モバイルデバイスの普及により、レスポンシブWebデザインは現代のWeb開発において必須の技術となっています。本レポートでは、モバイルファーストアプローチによるレスポンシブWebサイトの設計と実装について報告します。CSS3のメディアクエリ、フレキシブルグリッドレイアウト、可変画像などの技術を組み合わせ、デスクトップ、タブレット、スマートフォンに対応した学校紹介Webサイトを制作しました。パフォーマンス最適化、アクセシビリティ、SEO対策についても考慮し、実用的なWebサイトの構築プロセスを実践しました。', 
 'Web開発,レスポンシブデザイン,モバイルファースト,CSS,HTML,JavaScript', '2025-05-25');
```

## 基本的な全文検索

### MATCH ... AGAINST 構文

全文検索は `MATCH ... AGAINST` 構文を使用します。

#### 基本構文

```sql
SELECT カラム名 FROM テーブル名 
WHERE MATCH(検索対象カラム) AGAINST('検索語句');
```

#### 例1：基本的な全文検索

```sql
-- 教材のタイトルから「プログラミング」を検索
SELECT material_id, title, material_type
FROM course_materials
WHERE MATCH(title) AGAINST('プログラミング');
```

実行結果：
| material_id | title | material_type |
|------------|-------|---------------|
| MAT002 | Cプログラミング入門 | textbook |

#### 例2：複数カラムでの検索

```sql
-- タイトルと説明から「データベース」を検索
SELECT material_id, title, description
FROM course_materials
WHERE MATCH(title, description) AGAINST('データベース');
```

実行結果：
| material_id | title | description |
|------------|-------|-------------|
| MAT003 | データベース設計の基礎 | リレーショナルデータベースの設計原理と正規化について |

#### 例3：関連度スコア付きの検索

```sql
-- 関連度スコアを含む検索結果
SELECT material_id, 
       title,
       MATCH(title, description, content) AGAINST('AI 人工知能') AS 関連度スコア
FROM course_materials
WHERE MATCH(title, description, content) AGAINST('AI 人工知能')
ORDER BY 関連度スコア DESC;
```

## 全文検索のモード

MySQLの全文検索には複数のモードがあります。

### 1. 自然言語モード（Natural Language Mode）

デフォルトのモードで、自然言語での検索クエリを処理します。

```sql
-- 自然言語モードでの検索（デフォルト）
SELECT title, abstract
FROM student_reports
WHERE MATCH(title, abstract, content) AGAINST('アルゴリズム効率性' IN NATURAL LANGUAGE MODE)
ORDER BY MATCH(title, abstract, content) AGAINST('アルゴリズム効率性') DESC;
```

### 2. ブール言語モード（Boolean Mode）

論理演算子を使用してより詳細な検索条件を指定できます。

> **用語解説**：
> - **ブール言語モード**：論理演算子（+、-、*など）を使用して複雑な検索条件を指定できるモードです。

#### ブール演算子

| 演算子 | 意味 | 例 |
|--------|------|-----|
| + | 必須単語 | +プログラミング +C言語 |
| - | 除外単語 | +データベース -MySQL |
| * | ワイルドカード | プログラミング* |
| "" | 完全一致フレーズ | "Web開発" |
| () | グループ化 | +(AI 人工知能) -倫理 |

#### 例：ブール言語モードの活用

```sql
-- 「プログラミング」を含み、「Java」を含まない教材を検索
SELECT material_id, title
FROM course_materials
WHERE MATCH(title, description, content) AGAINST('+プログラミング -Java' IN BOOLEAN MODE);
```

```sql
-- 「データベース」と「設計」の両方を含む教材を検索
SELECT material_id, title
FROM course_materials
WHERE MATCH(title, description, content) AGAINST('+データベース +設計' IN BOOLEAN MODE);
```

```sql
-- 「Web」で始まる単語を含む教材を検索
SELECT material_id, title
FROM course_materials
WHERE MATCH(title, description, content) AGAINST('Web*' IN BOOLEAN MODE);
```

### 3. クエリ拡張モード（Query Expansion Mode）

初回検索結果を基に自動的にクエリを拡張して、より関連性の高い結果を取得します。

```sql
-- クエリ拡張モードでの検索
SELECT material_id, title,
       MATCH(title, description, content) AGAINST('プログラミング' WITH QUERY EXPANSION) AS スコア
FROM course_materials
WHERE MATCH(title, description, content) AGAINST('プログラミング' WITH QUERY EXPANSION)
ORDER BY スコア DESC;
```

## 高度な全文検索クエリ

### 例1：複合条件での検索

```sql
-- AI関連のレポートで、特定の期間に提出されたものを検索
SELECT r.title, 
       r.abstract,
       s.student_name,
       r.submission_date,
       MATCH(r.title, r.abstract, r.content) AGAINST('AI 人工知能 機械学習') AS 関連度
FROM student_reports r
JOIN students s ON r.student_id = s.student_id
WHERE MATCH(r.title, r.abstract, r.content) AGAINST('AI 人工知能 機械学習')
  AND r.submission_date >= '2025-05-01'
ORDER BY 関連度 DESC;
```

### 例2：カテゴリ別の検索

```sql
-- 講座別の教材検索
SELECT c.course_name,
       m.title,
       m.material_type,
       MATCH(m.title, m.description, m.content) AGAINST('実践 応用') AS 関連度
FROM course_materials m
JOIN courses c ON m.course_id = c.course_id
WHERE MATCH(m.title, m.description, m.content) AGAINST('実践 応用')
ORDER BY c.course_name, 関連度 DESC;
```

### 例3：キーワード頻度分析

```sql
-- 学生レポートでよく使用されるキーワードの分析
SELECT keywords,
       COUNT(*) AS 使用回数,
       AVG(MATCH(title, abstract, content) AGAINST('技術 開発')) AS 平均関連度
FROM student_reports
WHERE keywords IS NOT NULL
  AND MATCH(title, abstract, content) AGAINST('技術 開発')
GROUP BY keywords
ORDER BY 使用回数 DESC;
```

## 全文検索のパフォーマンス最適化

### 1. 全文インデックスの管理

```sql
-- 既存テーブルに全文インデックスを追加
ALTER TABLE course_materials 
ADD FULLTEXT INDEX ft_combined (title, description);

-- 全文インデックスの削除
ALTER TABLE course_materials 
DROP INDEX ft_combined;
```

### 2. 最小語長の設定

MySQLの設定変数で検索対象となる最小語長を調整できます。

```sql
-- 現在の最小語長設定を確認
SHOW VARIABLES LIKE 'ft_min_word_len';

-- InnoDB全文検索の最小語長を確認
SHOW VARIABLES LIKE 'innodb_ft_min_token_size';
```

### 3. ストップワードの管理

一般的すぎて検索に有用でない単語（ストップワード）の管理も重要です。

```sql
-- 現在のストップワード設定を確認
SHOW VARIABLES LIKE 'ft_stopword_file';
```

## 実践例：学校データベースでの全文検索活用

### 例1：統合検索システム

```sql
-- 教材とレポートを統合した検索システム
(SELECT 'material' AS type, 
        material_id AS id,
        title,
        description AS summary,
        MATCH(title, description, content) AGAINST('データベース 設計') AS 関連度
 FROM course_materials
 WHERE MATCH(title, description, content) AGAINST('データベース 設計'))
UNION ALL
(SELECT 'report' AS type,
        report_id AS id,
        title,
        abstract AS summary,
        MATCH(title, abstract, content) AGAINST('データベース 設計') AS 関連度
 FROM student_reports
 WHERE MATCH(title, abstract, content) AGAINST('データベース 設計'))
ORDER BY 関連度 DESC
LIMIT 10;
```

### 例2：推薦システムの基盤

```sql
-- 学生の提出レポートに基づく関連教材の推薦
SELECT DISTINCT m.material_id,
       m.title AS 推薦教材,
       c.course_name,
       AVG(MATCH(m.title, m.description, m.content) 
           AGAINST(r.keywords)) AS 関連度
FROM student_reports r
JOIN course_materials m ON r.course_id = m.course_id
JOIN courses c ON m.course_id = c.course_id
WHERE r.student_id = 301
  AND r.keywords IS NOT NULL
  AND MATCH(m.title, m.description, m.content) AGAINST(r.keywords) > 0
GROUP BY m.material_id, m.title, c.course_name
ORDER BY 関連度 DESC
LIMIT 5;
```

### 例3：学習進度分析

```sql
-- 特定トピックに関する学習進度の分析
SELECT s.student_name,
       COUNT(r.report_id) AS レポート数,
       AVG(MATCH(r.title, r.abstract, r.content) 
           AGAINST('プログラミング アルゴリズム')) AS 平均関連度,
       MAX(r.submission_date) AS 最新提出日
FROM students s
LEFT JOIN student_reports r ON s.student_id = r.student_id
WHERE MATCH(r.title, r.abstract, r.content) 
      AGAINST('プログラミング アルゴリズム') > 0
GROUP BY s.student_id, s.student_name
ORDER BY 平均関連度 DESC;
```

## 練習問題

### 問題9-5-1
course_materials テーブルから、タイトルに「Web」を含む教材を全文検索で取得し、関連度スコアと共に表示するSQLを書いてください。

### 問題9-5-2
student_reports テーブルから、「AI」と「機械学習」の両方を含むレポートをブール言語モードで検索するSQLを書いてください。

### 問題9-5-3
course_materials テーブルから、「データベース」を含むが「MySQL」を含まない教材をブール言語モードで検索するSQLを書いてください。

### 問題9-5-4
student_reports テーブルから、「プログラミング」で始まる単語を含むレポートを検索し、学生名と提出日も表示するSQLを書いてください。

### 問題9-5-5
course_materials と student_reports の両方から「設計」に関連する内容を検索し、タイプ（教材/レポート）別に結果を表示するSQLを書いてください。

### 問題9-5-6
「アルゴリズム」をキーワードとして、student_reports テーブルをクエリ拡張モードで検索し、関連度の高い順に上位3件を取得するSQLを書いてください。

### 問題9-5-7
course_materials テーブルから、完全一致フレーズ「プログラミング言語」を含む教材をブール言語モードで検索するSQLを書いてください。

### 問題9-5-8
student_reports テーブルから、2025年5月に提出されたレポートの中で「技術」に関連する内容を検索し、講座名も表示するSQLを書いてください。

### 問題9-5-9
各講座について、その講座の教材で最も多く使用されているキーワード（全文検索スコアが最も高い語句）を「システム」として分析するSQLを書いてください。

### 問題9-5-10
student_reports テーブルから、「効率」または「最適化」を含むレポートをブール言語モードで検索し、学生別にレポート数と平均関連度を計算するSQLを書いてください。

## 解答と詳細な解説

### 解答9-5-1
```sql
SELECT material_id, 
       title,
       MATCH(title) AGAINST('Web') AS 関連度スコア
FROM course_materials
WHERE MATCH(title) AGAINST('Web')
ORDER BY 関連度スコア DESC;
```

**解説**：
- `MATCH(title) AGAINST('Web')`で全文検索を実行
- SELECT句にも同じ式を記述して関連度スコアを取得
- WHERE句で全文検索条件を指定し、ORDER BYで関連度順に並び替え
- 関連度スコアは検索語句とのマッチ度を数値で表現

### 解答9-5-2
```sql
SELECT report_id, title, abstract
FROM student_reports
WHERE MATCH(title, abstract, content) AGAINST('+AI +機械学習' IN BOOLEAN MODE);
```

**解説**：
- `IN BOOLEAN MODE`でブール言語モードを指定
- `+`演算子で両方の単語が必須であることを指定
- 「AI」と「機械学習」の両方を含む文書のみが検索される
- 複数カラム（title, abstract, content）を検索対象に指定

### 解答9-5-3
```sql
SELECT material_id, title, description
FROM course_materials
WHERE MATCH(title, description, content) AGAINST('+データベース -MySQL' IN BOOLEAN MODE);
```

**解説**：
- `+データベース`で「データベース」を必須条件として指定
- `-MySQL`で「MySQL」を含む文書を除外
- ブール言語モードの除外機能を活用した検索条件
- 特定の単語を含む文書を除外したい場合に有効

### 解答9-5-4
```sql
SELECT r.report_id, 
       r.title,
       s.student_name,
       r.submission_date
FROM student_reports r
JOIN students s ON r.student_id = s.student_id
WHERE MATCH(r.title, r.abstract, r.content) AGAINST('プログラミング*' IN BOOLEAN MODE)
ORDER BY MATCH(r.title, r.abstract, r.content) AGAINST('プログラミング*') DESC;
```

**解説**：
- `プログラミング*`のワイルドカード検索で「プログラミング」で始まる単語をマッチ
- JOIN句で学生テーブルと結合して学生名を取得
- ワイルドカード（*）は語幹マッチングに使用
- 関連度順に並び替えて結果を表示

### 解答9-5-5
```sql
(SELECT 'material' AS タイプ,
        material_id AS ID,
        title AS タイトル,
        MATCH(title, description, content) AGAINST('設計') AS 関連度
 FROM course_materials
 WHERE MATCH(title, description, content) AGAINST('設計'))
UNION ALL
(SELECT 'report' AS タイプ,
        report_id AS ID,
        title AS タイトル,
        MATCH(title, abstract, content) AGAINST('設計') AS 関連度
 FROM student_reports
 WHERE MATCH(title, abstract, content) AGAINST('設計'))
ORDER BY 関連度 DESC;
```

**解説**：
- UNION ALLで教材テーブルとレポートテーブルの検索結果を結合
- 各サブクエリで同じ構造の結果セットを作成
- タイプ列で教材とレポートを区別
- 統合検索システムの基本的なパターン

### 解答9-5-6
```sql
SELECT report_id, 
       title,
       abstract,
       MATCH(title, abstract, content) AGAINST('アルゴリズム' WITH QUERY EXPANSION) AS 関連度
FROM student_reports
WHERE MATCH(title, abstract, content) AGAINST('アルゴリズム' WITH QUERY EXPANSION)
ORDER BY 関連度 DESC
LIMIT 3;
```

**解説**：
- `WITH QUERY EXPANSION`でクエリ拡張モードを使用
- 初回検索結果から関連語を自動抽出してクエリを拡張
- より幅広い関連文書を取得できる
- LIMIT 3で上位3件のみを取得

### 解答9-5-7
```sql
SELECT material_id, title
FROM course_materials
WHERE MATCH(title, description, content) AGAINST('"プログラミング言語"' IN BOOLEAN MODE);
```

**解説**：
- ダブルクォート（""）で完全一致フレーズを指定
- 「プログラミング言語」という連続した語句のみがマッチ
- 単語の順序と隣接性が重要な検索に使用
- ブール言語モードでのフレーズ検索機能

### 解答9-5-8
```sql
SELECT r.report_id,
       r.title,
       c.course_name,
       r.submission_date,
       MATCH(r.title, r.abstract, r.content) AGAINST('技術') AS 関連度
FROM student_reports r
JOIN courses c ON r.course_id = c.course_id
WHERE r.submission_date >= '2025-05-01' 
  AND r.submission_date < '2025-06-01'
  AND MATCH(r.title, r.abstract, r.content) AGAINST('技術')
ORDER BY 関連度 DESC;
```

**解説**：
- WHERE句で日付範囲と全文検索条件を組み合わせ
- JOIN句で講座テーブルと結合して講座名を取得
- 時間軸とテキスト内容の両方で絞り込み
- 複合条件での実用的な検索例

### 解答9-5-9
```sql
SELECT c.course_name,
       COUNT(*) AS システム関連教材数,
       AVG(MATCH(m.title, m.description, m.content) AGAINST('システム')) AS 平均関連度
FROM courses c
JOIN course_materials m ON c.course_id = m.course_id
WHERE MATCH(m.title, m.description, m.content) AGAINST('システム')
GROUP BY c.course_id, c.course_name
ORDER BY 平均関連度 DESC;
```

**解説**：
- GROUP BYで講座別に集計
- COUNT(*)で該当する教材数を計算
- AVG()で平均関連度を算出
- 講座別のキーワード使用傾向分析の例

### 解答9-5-10
```sql
SELECT s.student_name,
       COUNT(r.report_id) AS レポート数,
       AVG(MATCH(r.title, r.abstract, r.content) AGAINST('効率 最適化')) AS 平均関連度
FROM students s
JOIN student_reports r ON s.student_id = r.student_id
WHERE MATCH(r.title, r.abstract, r.content) AGAINST('効率 OR 最適化' IN BOOLEAN MODE)
GROUP BY s.student_id, s.student_name
ORDER BY 平均関連度 DESC;
```

**解説**：
- `OR`演算子で「効率」または「最適化」のいずれかを含む条件
- GROUP BYで学生別に集計
- JOIN句で学生テーブルと結合
- 学生の関心分野分析に活用できるクエリパターン

## まとめ

この章では、MySQLにおける全文検索機能について学びました：

1. **全文検索の基本概念**：従来のLIKE検索との違いと利点
2. **全文インデックスの作成**：FULLTEXT INDEXによる検索性能の向上
3. **MATCH...AGAINST構文**：基本的な全文検索の実行方法
4. **検索モード**：自然言語モード、ブール言語モード、クエリ拡張モード
5. **ブール演算子**：+、-、*、""、()を使った高度な検索条件指定
6. **関連度スコア**：検索結果の品質評価と並び替え
7. **パフォーマンス最適化**：インデックス管理とシステム設定
8. **実践的な活用**：統合検索、推薦システム、学習分析への応用

全文検索は、大量のテキストデータを扱う現代のアプリケーションにおいて必須の技術です。特に学校データベースのような教育コンテンツを多く含むシステムでは、学習者が必要な情報を素早く見つけるために重要な役割を果たします。

適切な全文インデックスの設計と、用途に応じた検索モードの選択により、ユーザーエクスペリエンスを大幅に向上させることができます。また、関連度スコアを活用することで、検索結果の品質を定量的に評価し、推薦システムや学習分析などの高度な機能も実現できます。

次のセクションでは、「XML：構造化マークアップデータの操作」について学び、階層構造を持つデータの格納と操作技術を習得します。