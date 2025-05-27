# 42. ER図：エンティティ関連モデル

## はじめに

これまでの章では、既に存在するテーブルを使ってSQLの様々な機能を学習してきました。しかし、実際の開発現場では、**テーブルを作る前にデータベースの設計を行う**必要があります。

この章では、データベース設計の基礎となる「**ER図**（Entity-Relationship Diagram：エンティティ関連図）」について学習します。ER図は、データベースを作る前に「どんなテーブルが必要で、それらがどのような関係を持つのか」を図で表現する手法です。

> **用語解説**：
> - **エンティティ（Entity）**：データベースで管理したい「もの」や「概念」のことです。例：学生、教師、講座など
> - **関連（Relationship）**：エンティティ同士の関係のことです。例：学生は講座を受講する、教師は講座を担当する
> - **属性（Attribute）**：エンティティが持つ特徴や性質のことです。例：学生の名前、学生ID、入学日など
> - **ER図（Entity-Relationship Diagram）**：エンティティとその関連を図で表現したものです
> - **データベース設計**：データベースの構造を決める作業のことです
> - **概念設計**：データベースの全体的な構造を決める設計段階です
> - **論理設計**：概念設計を基に、具体的なテーブル構造を決める設計段階です
> - **物理設計**：実際のデータベース管理システムに合わせて、詳細な設定を決める設計段階です

学校システムを例に、ER図の読み方、書き方、そして実際のテーブル作成への応用方法を実践的に学んでいきます。

## ER図の基本要素

### 1. エンティティ（Entity）

**エンティティ**とは、データベースで管理したい「対象」のことです。学校システムでは以下のようなエンティティが考えられます：

- **学生（Students）**：学校に通う生徒
- **教師（Teachers）**：授業を行う先生
- **講座（Courses）**：開講されている授業
- **教室（Classrooms）**：授業が行われる部屋
- **時間割（Schedule）**：いつ、どこで、何の授業があるかの情報

ER図では、エンティティを**長方形**で表現します：

```
┌─────────┐
│  学生   │
│(Students)│
└─────────┘
```

### 2. 属性（Attribute）

**属性**とは、エンティティが持つ具体的な情報のことです。例えば「学生」エンティティの属性は以下のようになります：

- **学生ID**：学生を識別するための番号
- **学生名**：学生の名前
- **メールアドレス**：連絡先
- **入学日**：いつ入学したか
- **学年**：現在何年生か

ER図では、属性を**楕円形**で表現し、線でエンティティと結びます：

```
     ┌─────────┐
  ┌──│  学生ID │
  │  └─────────┘
  │  ┌─────────┐
  ├──│  学生名 │
  │  └─────────┘
┌─┴───────┐  ┌─────────────┐
│  学生   │──│メールアドレス│
│(Students)│  └─────────────┘
└─┬───────┘  ┌─────────┐
  ├──────────│  入学日 │
  │          └─────────┘
  │  ┌─────────┐
  └──│  学年   │
     └─────────┘
```

### 3. 主キー属性

**主キー**とは、そのエンティティの各レコードを一意に識別できる属性のことです。学生エンティティでは「学生ID」が主キーになります。

> **用語解説**：
> - **主キー（Primary Key）**：テーブル内の各行を一意に識別するための列（または列の組み合わせ）です
> - **一意（ユニーク）**：重複がない、同じ値が存在しないという意味です
> - **識別**：区別して認識することです

ER図では、主キー属性に**下線**を引いて表現します：

```
     ┌─────────┐
  ┌──│ 学生ID  │← 下線が引かれている（主キー）
  │  └─────────┘
┌─┴───────┐
│  学生   │
│(Students)│
└─────────┘
```

### 4. 関連（Relationship）

**関連**とは、エンティティ同士の関係を表現します。例えば：

- 学生は講座を**受講する**
- 教師は講座を**担当する**
- 講座は教室で**開講される**

ER図では、関連を**ひし形**で表現します：

```
┌─────────┐    ┌─────────┐    ┌─────────┐
│  学生   │────│  受講   │────│  講座   │
│(Students)│    │(Enrolls)│    │(Courses)│
└─────────┘    └─────────┘    └─────────┘
```

## 関連の種類（カーディナリティ）

エンティティ間の関連には、**どのくらいの数のレコードが関係するか**を表す「**カーディナリティ**」という概念があります。

> **用語解説**：
> - **カーディナリティ（Cardinality）**：関連において、一方のエンティティの1つのレコードに対して、他方のエンティティの何個のレコードが関係するかを表す概念です

### 1. 一対一関係（1:1）

一方のエンティティの1つのレコードに対して、他方のエンティティの1つのレコードだけが関係する場合です。

**例**：教師と担任クラスの関係
- 1人の教師は1つのクラスだけを担任する
- 1つのクラスは1人の教師だけが担任する

```
┌─────────┐    ┌─────────┐    ┌─────────┐
│  教師   │─1──│  担任   │──1─│ クラス  │
│(Teachers)│    │(Homeroom)│    │(Classes)│
└─────────┘    └─────────┘    └─────────┘
```

### 2. 一対多関係（1:N）

一方のエンティティの1つのレコードに対して、他方のエンティティの複数のレコードが関係する場合です。

**例**：教師と講座の関係
- 1人の教師は複数の講座を担当できる
- 1つの講座は1人の教師だけが担当する

```
┌─────────┐    ┌─────────┐    ┌─────────┐
│  教師   │─1──│  担当   │──N─│  講座   │
│(Teachers)│    │(Teaches)│    │(Courses)│
└─────────┘    └─────────┘    └─────────┘
```

### 3. 多対多関係（M:N）

双方のエンティティで、1つのレコードが相手エンティティの複数のレコードと関係する場合です。

**例**：学生と講座の関係
- 1人の学生は複数の講座を受講できる
- 1つの講座は複数の学生が受講できる

```
┌─────────┐    ┌─────────┐    ┌─────────┐
│  学生   │─M──│  受講   │──N─│  講座   │
│(Students)│    │(Enrolls)│    │(Courses)│
└─────────┘    └─────────┘    └─────────┘
```

> **重要なポイント**：
> 多対多関係は、実際のデータベースでは**中間テーブル**を作って、**2つの一対多関係**に分解して実装します。これについては後で詳しく説明します。

## 学校システムのER図作成

実際に学校システムの全体的なER図を作成してみましょう。

### 1. エンティティの抽出

まず、学校システムで管理したい「もの」を洗い出します：

1. **学生（Students）**
2. **教師（Teachers）**
3. **講座（Courses）**
4. **教室（Classrooms）**
5. **授業時間（Class_Periods）**
6. **学期（Terms）**
7. **授業スケジュール（Course_Schedule）**
8. **出席（Attendance）**
9. **成績（Grades）**

### 2. 各エンティティの属性定義

#### 学生（Students）
- **学生ID**（主キー）：301, 302, 303...
- **学生名**：田中太郎、佐藤花子...
- **メールアドレス**：連絡先
- **入学日**：2023-04-01...

#### 教師（Teachers）
- **教師ID**（主キー）：101, 102, 103...
- **教師名**：田中先生、佐藤先生...

#### 講座（Courses）
- **講座ID**（主キー）：1, 2, 3...
- **講座名**：プログラミング基礎、データベース...
- **担当教師ID**（外部キー）：どの教師が担当するか

> **用語解説**：
> - **外部キー（Foreign Key）**：他のテーブルの主キーを参照する列のことです。テーブル間の関係を作るために使います

#### 教室（Classrooms）
- **教室ID**（主キー）：A101, B201...
- **教室名**：コンピュータ室1、講義室A...
- **収容人数**：30人、50人...
- **建物**：A棟、B棟...
- **設備**：プロジェクター、PC...

#### 授業時間（Class_Periods）
- **時限ID**（主キー）：1, 2, 3, 4, 5
- **開始時間**：09:00, 10:50, 13:00...
- **終了時間**：10:30, 12:20, 14:30...

### 3. 関連の定義

各エンティティ間の関係を整理します：

1. **教師 → 講座**（1:N）
   - 1人の教師は複数の講座を担当する
   - 1つの講座は1人の教師が担当する

2. **学生 ← → 講座**（M:N）
   - 1人の学生は複数の講座を受講する
   - 1つの講座は複数の学生が受講する

3. **講座 → 授業スケジュール**（1:N）
   - 1つの講座は複数回の授業がある
   - 1回の授業は1つの講座に属する

4. **教室 → 授業スケジュール**（1:N）
   - 1つの教室で複数の授業が行われる
   - 1回の授業は1つの教室で行われる

5. **授業時間 → 授業スケジュール**（1:N）
   - 1つの時限で複数の授業が行われる（異なる日に）
   - 1回の授業は1つの時限で行われる

6. **授業スケジュール → 出席**（1:N）
   - 1回の授業に対して複数の学生の出席記録がある
   - 1つの出席記録は1回の授業に対応する

7. **学生 → 出席**（1:N）
   - 1人の学生は複数の出席記録を持つ
   - 1つの出席記録は1人の学生のもの

8. **学生 ← → 講座**（成績を通じてM:N）
   - 1人の学生は複数の講座で成績を持つ
   - 1つの講座で複数の学生が成績を持つ

### 4. 完成したER図の概念

学校システムの全体的なER図は以下のような構造になります：

```
学生（Students）
├─ 学生ID（主キー）
├─ 学生名
├─ メールアドレス
└─ 入学日
    │
    │ 受講（M:N）
    │
    ▼
講座（Courses）
├─ 講座ID（主キー）
├─ 講座名
└─ 担当教師ID（外部キー）
    │
    │ 担当（1:N）
    │
    ▼
教師（Teachers）
├─ 教師ID（主キー）
└─ 教師名

講座（Courses）
    │
    │ 開講（1:N）
    │
    ▼
授業スケジュール（Course_Schedule）
├─ スケジュールID（主キー）
├─ 講座ID（外部キー）
├─ 日付
├─ 時限ID（外部キー）
├─ 教室ID（外部キー）
└─ 教師ID（外部キー）
    │
    ├─ 使用（N:1）
    │   ▼
    │ 教室（Classrooms）
    │ ├─ 教室ID（主キー）
    │ ├─ 教室名
    │ ├─ 収容人数
    │ ├─ 建物
    │ └─ 設備
    │
    ├─ 時限（N:1）
    │   ▼
    │ 授業時間（Class_Periods）
    │ ├─ 時限ID（主キー）
    │ ├─ 開始時間
    │ └─ 終了時間
    │
    └─ 出席管理（1:N）
        ▼
      出席（Attendance）
      ├─ スケジュールID（外部キー）
      ├─ 学生ID（外部キー）
      ├─ 出席状況
      └─ コメント

学生（Students）
    │
    │ 成績管理（M:N）
    │
    ▼
成績（Grades）
├─ 学生ID（外部キー）
├─ 講座ID（外部キー）
├─ 成績種別
├─ 点数
├─ 満点
└─ 提出日
```

## ER図からテーブル設計への変換

ER図ができたら、次は実際のテーブル設計に変換します。この過程を「**論理設計**」と呼びます。

### 1. エンティティからテーブルの作成

各エンティティは1つのテーブルになります：

```sql
-- 学生テーブル
CREATE TABLE students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(64),
    student_email VARCHAR(100),
    admission_date DATE
);

-- 教師テーブル
CREATE TABLE teachers (
    teacher_id BIGINT PRIMARY KEY,
    teacher_name VARCHAR(64)
);

-- 講座テーブル
CREATE TABLE courses (
    course_id VARCHAR(16) PRIMARY KEY,
    course_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);
```

### 2. 多対多関係の解決

多対多関係は**中間テーブル**を作成して解決します。例えば「学生と講座」の多対多関係は：

```sql
-- 受講テーブル（学生と講座の中間テーブル）
CREATE TABLE student_courses (
    course_id VARCHAR(16),
    student_id BIGINT,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (course_id, student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
```

> **重要なポイント**：
> - 中間テーブルの主キーは、関連する両方のエンティティの主キーを組み合わせた**複合主キー**になります
> - 中間テーブルには、関連に関する追加情報（受講開始日など）も格納できます

### 3. 一対多関係の実装

一対多関係は、「多」の側のテーブルに「一」の側の主キーを**外部キー**として追加します：

```sql
-- 授業スケジュールテーブル
CREATE TABLE course_schedule (
    schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(16) NOT NULL,
    schedule_date DATE NOT NULL,
    period_id INT NOT NULL,
    classroom_id VARCHAR(16) NOT NULL,
    teacher_id BIGINT NOT NULL,
    
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (period_id) REFERENCES class_periods(period_id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);
```

## 実践的なER図作成手順

実際にER図を作成する際の手順を整理します：

### ステップ1：要求分析

システムで「何を管理したいか」を明確にします：

- どんな情報を記録する必要があるか？
- どんな処理を行う必要があるか？
- どんなレポートを出力する必要があるか？

### ステップ2：エンティティの抽出

管理対象となる「もの」を洗い出します：

- **名詞に注目**：要求仕様書に出てくる名詞がエンティティの候補
- **重要度の判定**：システムにとって本当に重要なものかを判断
- **具体性の確認**：抽象的すぎないか、具体的すぎないかを確認

### ステップ3：属性の定義

各エンティティが持つべき情報を定義します：

- **識別子の選定**：主キーとなる属性を決める
- **必須属性の特定**：必ず値が入る属性を特定
- **データ型の決定**：文字列、数値、日付などの型を決める

### ステップ4：関連の特定

エンティティ間の関係を分析します：

- **動詞に注目**：「受講する」「担当する」などの動詞が関連の候補
- **カーディナリティの決定**：1:1、1:N、M:Nのどれかを決める
- **制約の確認**：関連に制約があるかを確認

### ステップ5：ER図の作成

図を描いて全体の構造を可視化します：

- **読みやすさを重視**：線の交差を避け、整理された配置にする
- **一貫性の確保**：記号の使い方を統一する
- **完全性の確認**：漏れがないかをチェックする

### ステップ6：検証と改善

作成したER図が要求を満たしているかを確認します：

- **機能要求の確認**：必要な処理が実現できるか
- **整合性の確認**：矛盾がないか
- **拡張性の確認**：将来の変更に対応できるか

## ER図作成の実習

実際に簡単なER図を作成してみましょう。

### 課題：図書館システムのER図作成

図書館システムに必要なエンティティと関連を考えてみてください：

**管理したい情報**：
- 本の情報（タイトル、著者、ISBN、出版社、出版年）
- 利用者の情報（利用者ID、名前、メールアドレス、登録日）
- 貸出記録（いつ、誰が、何を借りたか、返却期限、返却日）
- 著者の情報（著者ID、著者名、生年月日、国籍）

**実現したい機能**：
- 本の貸出・返却管理
- 利用者の貸出履歴確認
- 延滞者の管理
- 蔵書検索

### 解答例

#### エンティティの抽出
1. **本（Books）**
2. **利用者（Users）**
3. **著者（Authors）**
4. **貸出記録（Rentals）**

#### 属性の定義

**本（Books）**
- 本ID（主キー）
- タイトル
- ISBN
- 出版社
- 出版年

**利用者（Users）**
- 利用者ID（主キー）
- 利用者名
- メールアドレス
- 登録日

**著者（Authors）**
- 著者ID（主キー）
- 著者名
- 生年月日
- 国籍

**貸出記録（Rentals）**
- 貸出ID（主キー）
- 本ID（外部キー）
- 利用者ID（外部キー）
- 貸出日
- 返却期限
- 返却日

#### 関連の定義

1. **著者 ← → 本**（M:N）
   - 1人の著者は複数の本を書く
   - 1冊の本は複数の著者が書く場合がある
   - 中間テーブル「著者本関係（Author_Books）」が必要

2. **利用者 → 貸出記録**（1:N）
   - 1人の利用者は複数の貸出記録を持つ
   - 1つの貸出記録は1人の利用者のもの

3. **本 → 貸出記録**（1:N）
   - 1冊の本は複数回貸し出される（複数の貸出記録）
   - 1つの貸出記録は1冊の本に対応

#### テーブル設計例

```sql
-- 著者テーブル
CREATE TABLE authors (
    author_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50)
);

-- 本テーブル
CREATE TABLE books (
    book_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publisher VARCHAR(100),
    publication_year YEAR
);

-- 著者本関係テーブル（多対多の解決）
CREATE TABLE author_books (
    author_id BIGINT,
    book_id BIGINT,
    PRIMARY KEY (author_id, book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- 利用者テーブル
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- 貸出記録テーブル
CREATE TABLE rentals (
    rental_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    book_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    rental_date DATE DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

## ER図の表記法

ER図には、いくつかの表記法があります。ここでは代表的なものを紹介します。

### 1. Chen記法（チェン記法）

最も伝統的な記法で、教科書でよく使われます：

- **エンティティ**：長方形
- **属性**：楕円形
- **関連**：ひし形
- **主キー**：下線

### 2. IE記法（Information Engineering記法）

実務でよく使われる記法です：

- **エンティティ**：長方形（属性も内部に記載）
- **関連**：線で接続
- **カーディナリティ**：線の端に記号で表現

### 3. UML記法（Unified Modeling Language）

オブジェクト指向開発でよく使われます：

- **エンティティ**：クラス図として表現
- **関連**：線で接続し、多重度を記載

実際の開発現場では、**IE記法**や**UML記法**がよく使われています。ツールも豊富で、実用的だからです。

## ER図作成ツール

ER図を作成するための代表的なツールを紹介します：

### 無料ツール
1. **draw.io（現：app.diagrams.net）**
   - ブラウザで使える無料ツール
   - ER図用のテンプレートが豊富
   - チーム共有機能もある

2. **MySQL Workbench**
   - MySQLの公式ツール
   - ER図から直接テーブルを生成可能
   - 既存のデータベースからER図を自動生成

3. **dbdiagram.io**
   - シンプルで使いやすいオンラインツール
   - テキストでER図を記述できる
   - SQLコードの自動生成機能

### 有料ツール
1. **ERwin Data Modeler**
   - 企業レベルのデータモデリングツール
   - 高度な機能が充実

2. **Lucidchart**
   - 汎用的な図表作成ツール
   - ER図テンプレートも豊富

3. **Microsoft Visio**
   - Microsoftの図表作成ツール
   - 企業環境でよく使われる

## ER図設計のベストプラクティス

良いER図を作成するためのポイントをまとめます：

### 1. 命名規則の統一

**エンティティ名**：
- 複数形を使う（Students、Teachers、Courses）
- 分かりやすい英語名を使う
- 略語は避ける

**属性名**：
- 明確で具体的な名前を使う
- データ型が分かりやすい名前にする
- ID属性は「エンティティ名_id」の形式に統一

### 2. 適切な抽象化レベル

**抽象化しすぎない**：
- 「人」エンティティではなく、「学生」「教師」と具体的に
- システムの目的に合った粒度にする

**具体化しすぎない**：
- 「1年生」「2年生」を別エンティティにしない
- 属性で表現できるものはエンティティにしない

### 3. 関連の明確化

**関連名を明記**：
- 単に線で結ぶだけでなく、関連の意味を明記
- 「受講する」「担当する」「開講される」など

**カーディナリティの根拠**：
- なぜその関連度数になるのかを説明できるようにする
- 業務ルールとの整合性を確認

### 4. 将来の拡張性を考慮

**柔軟性の確保**：
- 将来の機能追加に対応できる構造にする
- 過度に制約をかけすぎない

**保守性の向上**：
- 理解しやすい構造にする
- ドキュメントを充実させる

## 練習問題

### 問題42-1：基本的なER図の読み取り

以下のER図を見て、質問に答えてください：

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   顧客      │─1──│   注文      │──N─│   商品      │
│(Customers)  │    │(Orders)     │    │(Products)   │
├─────────────┤    ├─────────────┤    ├─────────────┤
│顧客ID(PK)   │    │注文ID(PK)   │    │商品ID(PK)   │
│顧客名       │    │顧客ID(FK)   │    │商品名       │
│メール       │    │注文日       │    │価格         │
│電話番号     │    │合計金額     │    │在庫数       │
└─────────────┘    └─────────────┘    └─────────────┘
```

**質問**：
1. このER図で表現されているエンティティは何個ありますか？
2. 「顧客」と「注文」の関係はどのような関連ですか？
3. 「注文」エンティティの主キーは何ですか？
4. 「注文」エンティティの外部キーは何ですか？
5. この構造では、1つの注文で複数の商品を購入することはできますか？理由も説明してください。

### 問題42-2：エンティティと属性の識別

以下の説明から、エンティティと属性を識別してください：

**病院システムの要求**：
「病院では、患者の診療記録を管理したい。患者には患者番号、氏名、生年月日、住所、電話番号がある。医師には医師番号、氏名、専門科目がある。診療記録には、いつ、どの患者を、どの医師が診療したか、診療内容、処方薬の情報を記録する。薬には薬品番号、薬品名、単価がある。」

**課題**：
1. エンティティを4つ抽出してください
2. 各エンティティの属性を列挙してください
3. 各エンティティの主キーとなる属性を選んでください

### 問題42-3：関連とカーディナリティの分析

以下の業務ルールから、エンティティ間の関連とカーディナリティを分析してください：

**レンタルビデオ店の業務ルール**：
- 1人の会員は複数のDVDを借りることができる
- 1枚のDVDは同時に1人の会員だけが借りることができる
- 1枚のDVDは複数回貸し出される（返却後に別の会員が借りる）
- 1つのジャンル（アクション、コメディなど）には複数のDVDが属する
- 1枚のDVDは1つのジャンルに属する

**課題**：
1. 必要なエンティティを抽出してください
2. エンティティ間の関連を特定してください
3. 各関連のカーディナリティ（1:1、1:N、M:N）を決定してください
4. 多対多関係がある場合は、中間テーブルの必要性を説明してください

### 問題42-4：ER図からテーブル設計

以下のER図を基に、適切なCREATE TABLE文を作成してください：

**オンライン書店のER図**：
```
著者(Authors)           本(Books)
├─著者ID(PK)      ←─1:N─├─本ID(PK)
├─著者名                ├─タイトル
├─生年月日              ├─価格
└─国籍                  ├─出版年
                        └─著者ID(FK)

顧客(Customers)         注文(Orders)
├─顧客ID(PK)      ←─1:N─├─注文ID(PK)
├─顧客名                ├─顧客ID(FK)
├─メール                ├─注文日
└─住所                  └─合計金額

本(Books)               注文詳細(Order_Details)
├─本ID(PK)        ←─1:N─├─注文ID(FK)
└─...                   ├─本ID(FK)
                        ├─数量
                        └─単価
                          ↑
注文(Orders)    ──1:N─────┘
├─注文ID(PK)
└─...
```

**課題**：
1. 各エンティティに対応するテーブルのCREATE TABLE文を書いてください
2. 適切な制約（主キー、外部キー、NOT NULL等）を設定してください
3. データ型も適切に選択してください

### 問題42-5：複雑なER図の設計

以下の要求仕様を基に、完全なER図を設計してください：

**大学の履修管理システム**：

**要求**：
- 学生は複数の科目を履修できる
- 科目は複数の学生が履修できる
- 各科目には担当教授が1人いる
- 教授は複数の科目を担当できる
- 学生には学籍番号、氏名、学年、学部の情報がある
- 教授には教授番号、氏名、所属学部、職位の情報がある
- 科目には科目番号、科目名、単位数、開講学期の情報がある
- 履修には履修年度、成績（A、B、C、D、F）の情報がある
- 学部には学部番号、学部名の情報がある

**課題**：
1. 必要なエンティティをすべて抽出してください
2. 各エンティティの属性を定義してください
3. エンティティ間の関連とカーディナリティを決定してください
4. 完全なER図を設計してください
5. 多対多関係があれば中間テーブルを設計してください

### 問題42-6：既存システムの分析と改善

学校データベースの現在の構造を分析し、改善案を提案してください：

**現在のテーブル構造**（簡略版）：
```sql
-- 学生テーブル
CREATE TABLE students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(64),
    teacher_name VARCHAR(64)  -- 担任の名前
);

-- 成績テーブル
CREATE TABLE grades (
    student_id BIGINT,
    subject_name VARCHAR(64),  -- 科目名
    teacher_name VARCHAR(64),  -- 担当教師名
    score DECIMAL(5,2)
);
```

**課題**：
1. 現在の設計の問題点を3つ以上指摘してください
2. 正規化の観点から改善すべき点を説明してください
3. 改善されたER図を設計してください
4. 改善後のテーブル構造をCREATE TABLE文で表現してください

## 解答

### 解答42-1
1. **エンティティの数**：3個（顧客、注文、商品）
2. **顧客と注文の関係**：一対多関係（1:N）
   - 1人の顧客は複数の注文をできる
   - 1つの注文は1人の顧客のもの
3. **注文エンティティの主キー**：注文ID
4. **注文エンティティの外部キー**：顧客ID
5. **複数商品の購入**：できません
   - 理由：注文と商品が直接結ばれており、中間テーブルがない
   - 現在の構造では1つの注文に1つの商品しか関連付けられない
   - 複数商品を扱うには「注文詳細」という中間テーブルが必要

### 解答42-2
1. **エンティティ**：
   - 患者（Patients）
   - 医師（Doctors）
   - 診療記録（Medical_Records）
   - 薬（Medicines）

2. **各エンティティの属性**：
   - **患者**：患者番号、氏名、生年月日、住所、電話番号
   - **医師**：医師番号、氏名、専門科目
   - **診療記録**：診療日、患者番号、医師番号、診療内容、処方薬番号
   - **薬**：薬品番号、薬品名、単価

3. **主キー**：
   - **患者**：患者番号
   - **医師**：医師番号
   - **診療記録**：診療記録番号（新たに追加）
   - **薬**：薬品番号

### 解答42-3
1. **エンティティ**：
   - 会員（Members）
   - DVD（DVDs）
   - ジャンル（Genres）
   - 貸出記録（Rentals）

2. **関連の特定**：
   - 会員 ← → DVD（貸出を通じて）
   - ジャンル → DVD
   - 会員 → 貸出記録
   - DVD → 貸出記録

3. **カーディナリティ**：
   - **ジャンル → DVD**：1:N（1つのジャンルに複数のDVD）
   - **会員 → 貸出記録**：1:N（1人の会員が複数回借りる）
   - **DVD → 貸出記録**：1:N（1枚のDVDが複数回貸し出される）

4. **中間テーブル**：
   - 「貸出記録（Rentals）」が実質的に会員とDVDの中間テーブルとして機能
   - 現在の貸出状況を管理するために必要

### 解答42-4
```sql
-- 著者テーブル
CREATE TABLE authors (
    author_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50)
);

-- 本テーブル
CREATE TABLE books (
    book_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    publication_year YEAR,
    author_id BIGINT NOT NULL,
    
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- 顧客テーブル
CREATE TABLE customers (
    customer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    address TEXT
);

-- 注文テーブル
CREATE TABLE orders (
    order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 注文詳細テーブル
CREATE TABLE order_details (
    order_id BIGINT,
    book_id BIGINT,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);
```

### 解答42-5
1. **エンティティ**：
   - 学生（Students）
   - 教授（Professors）
   - 科目（Subjects）
   - 学部（Departments）
   - 履修記録（Enrollments）

2. **属性定義**：
   - **学生**：学籍番号（PK）、氏名、学年、学部番号（FK）
   - **教授**：教授番号（PK）、氏名、所属学部番号（FK）、職位
   - **科目**：科目番号（PK）、科目名、単位数、開講学期、担当教授番号（FK）
   - **学部**：学部番号（PK）、学部名
   - **履修記録**：学籍番号（FK）、科目番号（FK）、履修年度、成績

3. **関連とカーディナリティ**：
   - **学部 → 学生**：1:N
   - **学部 → 教授**：1:N
   - **教授 → 科目**：1:N
   - **学生 ← → 科目**：M:N（履修記録を通じて）

4. **テーブル設計**：
```sql
-- 学部テーブル
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- 教授テーブル
CREATE TABLE professors (
    professor_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    professor_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    position VARCHAR(50),
    
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 学生テーブル
CREATE TABLE students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    grade_level INT NOT NULL,
    department_id INT NOT NULL,
    
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 科目テーブル
CREATE TABLE subjects (
    subject_id VARCHAR(16) PRIMARY KEY,
    subject_name VARCHAR(128) NOT NULL,
    credits INT NOT NULL,
    semester ENUM('spring', 'fall', 'summer') NOT NULL,
    professor_id BIGINT NOT NULL,
    
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
);

-- 履修記録テーブル（多対多の解決）
CREATE TABLE enrollments (
    student_id BIGINT,
    subject_id VARCHAR(16),
    academic_year YEAR NOT NULL,
    grade ENUM('A', 'B', 'C', 'D', 'F', 'W') DEFAULT NULL,
    
    PRIMARY KEY (student_id, subject_id, academic_year),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);
```

### 解答42-6
1. **現在の設計の問題点**：
   - **非正規化**：teacher_name、subject_nameが重複格納されている
   - **整合性の問題**：教師名や科目名の変更時に複数箇所を更新する必要がある
   - **外部キー制約がない**：データの整合性が保証されない
   - **拡張性の欠如**：教師や科目の詳細情報を追加できない

2. **正規化の観点からの改善点**：
   - **第1正規形**：繰り返し項目の分離
   - **第2正規形**：部分関数従属の除去
   - **第3正規形**：推移関数従属の除去
   - エンティティの独立性確保

3. **改善されたER図**：
```
学生(Students)          教師(Teachers)
├─学生ID(PK)      ←─1:N─├─教師ID(PK)
├─学生名                ├─教師名
└─担任教師ID(FK)        └─...

科目(Subjects)          
├─科目ID(PK)            
├─科目名                
├─担当教師ID(FK)  ──N:1→ 教師(Teachers)
└─...                   

成績(Grades)
├─学生ID(FK)      ──N:1→ 学生(Students)
├─科目ID(FK)      ──N:1→ 科目(Subjects)
├─成績種別(PK)
├─点数
└─...
```

4. **改善後のテーブル構造**：
```sql
-- 教師テーブル
CREATE TABLE teachers (
    teacher_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    teacher_name VARCHAR(100) NOT NULL
);

-- 学生テーブル（改善版）
CREATE TABLE students (
    student_id BIGINT PRIMARY KEY,
    student_name VARCHAR(64) NOT NULL,
    homeroom_teacher_id BIGINT,
    
    FOREIGN KEY (homeroom_teacher_id) REFERENCES teachers(teacher_id)
);

-- 科目テーブル
CREATE TABLE subjects (
    subject_id VARCHAR(16) PRIMARY KEY,
    subject_name VARCHAR(128) NOT NULL,
    teacher_id BIGINT NOT NULL,
    
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- 成績テーブル（改善版）
CREATE TABLE grades (
    student_id BIGINT,
    subject_id VARCHAR(16),
    grade_type VARCHAR(32),
    score DECIMAL(5,2),
    submission_date DATE,
    
    PRIMARY KEY (student_id, subject_id, grade_type),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);
```

## まとめ

この章では、データベース設計の基礎となるER図について詳しく学習しました：

1. **ER図の基本要素**：
   - エンティティ（長方形）：管理対象となる「もの」
   - 属性（楕円形）：エンティティの特徴や性質
   - 関連（ひし形）：エンティティ間の関係
   - 主キー（下線）：レコードを一意に識別する属性

2. **関連の種類**：
   - **一対一関係（1:1）**：両方のエンティティで1つのレコードずつが関連
   - **一対多関係（1:N）**：一方の1つに対して他方の複数が関連
   - **多対多関係（M:N）**：両方のエンティティで複数のレコードが関連

3. **ER図からテーブル設計への変換**：
   - エンティティは1つのテーブルになる
   - 一対多関係は外部キーで実装
   - 多対多関係は中間テーブルで解決

4. **設計のベストプラクティス**：
   - 命名規則の統一
   - 適切な抽象化レベル
   - 関連の明確化
   - 将来の拡張性を考慮

ER図は、データベース設計の「設計図」として非常に重要です。**要求を正確に分析し、適切なエンティティと関連を定義することで、保守性と拡張性の高いデータベースを設計**できます。

次の章では、「正規化：データの冗長性削減」について学び、データベース設計をさらに洗練させる手法を理解していきます。