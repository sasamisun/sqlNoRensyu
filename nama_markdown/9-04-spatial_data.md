# 9-4. 地理空間データ：位置情報の取り扱い

## はじめに

現代のアプリケーションでは、位置情報を扱うことが非常に多くなっています。GPSデータ、地図サービス、配送管理、店舗検索など、様々な場面で地理空間データが活用されています。

学校データベースでも、以下のような場面で地理空間データが役立ちます：

- **キャンパスマップ**：各建物や教室の正確な位置情報
- **通学路管理**：学生の通学経路や最寄り駅からの距離
- **災害対策**：避難経路や集合場所の位置データ
- **施設管理**：駐車場、食堂、図書館などの施設位置
- **イベント会場**：屋外授業や学園祭の会場位置
- **近隣情報**：最寄りの病院、コンビニ、公共交通機関

この章では、MySQLの地理空間データ型と空間関数について学び、位置情報を効率的に格納・検索・分析する方法を習得します。

> **用語解説**：
> - **地理空間データ（Spatial Data）**：地球上の位置や形状を表現するデータで、点、線、面などの幾何学的情報を含みます。
> - **GIS（地理情報システム）**：地理空間データを収集、格納、分析、表示するためのシステムです。
> - **座標系**：地球上の位置を数値で表現するための参照系統です。

## 地理空間データ型の基本

MySQLでは、地理空間データを格納するための専用データ型が用意されています。これらは**OpenGIS標準**に準拠しており、様々なGISソフトウェアとの互換性があります。

### 主要な地理空間データ型

| データ型 | 説明 | 例 |
|---------|------|-----|
| **POINT** | 単一の点（座標） | 建物の位置、教室の場所 |
| **LINESTRING** | 線（複数の点を結んだ線） | 通学路、道路 |
| **POLYGON** | 多角形（閉じられた領域） | 建物の敷地、キャンパスエリア |
| **MULTIPOINT** | 複数の点の集合 | 複数の出入口 |
| **MULTILINESTRING** | 複数の線の集合 | 複数の通学路 |
| **MULTIPOLYGON** | 複数の多角形の集合 | 複数の建物群 |
| **GEOMETRY** | 上記すべてを格納可能 | 混在する地理データ |

> **用語解説**：
> - **POINT**：経度・緯度で表される地球上の一点です。
> - **LINESTRING**：複数の点を順番に結んだ線分です。
> - **POLYGON**：閉じられた領域を表す多角形です。

## 座標系とSRID

地理空間データを扱う際は、**座標系（Coordinate Reference System）**の理解が重要です。

### 主要な座標系

1. **WGS84（SRID: 4326）**
   - 世界測地系、GPS で使用される標準座標系
   - 経度・緯度で表現（例：東京駅 139.7673, 35.6809）

2. **Web メルカトル（SRID: 3857）**
   - Google Maps、OpenStreetMap で使用
   - メートル単位での距離計算に適している

> **用語解説**：
> - **SRID（Spatial Reference System Identifier）**：座標系を識別するための番号です。
> - **WGS84**：世界測地系の標準で、GPSシステムで使用される座標系です。

## 学校データベースへの地理空間データの追加

学校の位置情報を管理するためのテーブルを作成しましょう。

### 建物位置テーブルの作成

```sql
-- 建物の位置情報テーブル
CREATE TABLE building_locations (
    building_id VARCHAR(16) PRIMARY KEY,
    building_name VARCHAR(100) NOT NULL,
    location POINT NOT NULL SRID 4326,
    entrance_points MULTIPOINT SRID 4326,  -- 複数の入口
    building_area POLYGON SRID 4326,       -- 建物の敷地
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 空間インデックスの作成
    SPATIAL INDEX idx_location (location),
    SPATIAL INDEX idx_area (building_area)
);
```

### キャンパス施設テーブルの作成

```sql
-- キャンパス内施設の位置情報テーブル
CREATE TABLE campus_facilities (
    facility_id VARCHAR(16) PRIMARY KEY,
    facility_name VARCHAR(100) NOT NULL,
    facility_type VARCHAR(50),  -- 'parking', 'restaurant', 'library', etc.
    location POINT NOT NULL SRID 4326,
    service_area POLYGON SRID 4326,  -- サービス提供エリア
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    SPATIAL INDEX idx_facility_location (location)
);
```

## 地理空間データの挿入

### POINT データの挿入

```sql
-- 建物の位置データを挿入（東京都内の架空の学校）
INSERT INTO building_locations (building_id, building_name, location, building_area) VALUES
('BLDG001', '1号館（本館）', 
 ST_GeomFromText('POINT(139.7000 35.6500)', 4326),
 ST_GeomFromText('POLYGON((139.6995 35.6495, 139.7005 35.6495, 139.7005 35.6505, 139.6995 35.6505, 139.6995 35.6495))', 4326)
),
('BLDG002', '2号館（実習棟）', 
 ST_GeomFromText('POINT(139.7010 35.6510)', 4326),
 ST_GeomFromText('POLYGON((139.7005 35.6505, 139.7015 35.6505, 139.7015 35.6515, 139.7005 35.6515, 139.7005 35.6505))', 4326)
),
('BLDG003', '3号館（講義棟）', 
 ST_GeomFromText('POINT(139.6990 35.6520)', 4326),
 ST_GeomFromText('POLYGON((139.6985 35.6515, 139.6995 35.6515, 139.6995 35.6525, 139.6985 35.6525, 139.6985 35.6515))', 4326)
);
```

### 施設データの挿入

```sql
-- キャンパス施設の位置データを挿入
INSERT INTO campus_facilities (facility_id, facility_name, facility_type, location) VALUES
('FAC001', '学生食堂', 'restaurant', ST_GeomFromText('POINT(139.7005 35.6508)', 4326)),
('FAC002', '図書館', 'library', ST_GeomFromText('POINT(139.6995 35.6515)', 4326)),
('FAC003', '駐車場A', 'parking', ST_GeomFromText('POINT(139.6985 35.6490)', 4326)),
('FAC004', '駐車場B', 'parking', ST_GeomFromText('POINT(139.7020 35.6525)', 4326)),
('FAC005', '保健室', 'medical', ST_GeomFromText('POINT(139.7002 35.6502)', 4326));
```

> **用語解説**：
> - **ST_GeomFromText()**：WKT（Well-Known Text）形式の文字列から地理空間オブジェクトを作成する関数です。
> - **WKT（Well-Known Text）**：地理空間データをテキストで表現するための標準形式です。

## 地理空間データの検索と表示

### 基本的な位置データの取得

```sql
-- 建物の位置情報を表示
SELECT building_id,
       building_name,
       ST_AsText(location) AS 位置座標,
       ST_X(location) AS 経度,
       ST_Y(location) AS 緯度
FROM building_locations;
```

実行結果：
| building_id | building_name | 位置座標 | 経度 | 緯度 |
|------------|--------------|---------|------|------|
| BLDG001 | 1号館（本館） | POINT(139.7 35.65) | 139.7 | 35.65 |
| BLDG002 | 2号館（実習棟） | POINT(139.701 35.651) | 139.701 | 35.651 |
| BLDG003 | 3号館（講義棟） | POINT(139.699 35.652) | 139.699 | 35.652 |

### 距離の計算

```sql
-- 1号館から各施設までの距離を計算（メートル単位）
SELECT f.facility_name,
       f.facility_type,
       ROUND(ST_Distance_Sphere(
           b.location, 
           f.location
       ), 2) AS 距離_メートル
FROM building_locations b, campus_facilities f
WHERE b.building_id = 'BLDG001'
ORDER BY 距離_メートル;
```

実行結果：
| facility_name | facility_type | 距離_メートル |
|-------------|-------------|-------------|
| 保健室 | medical | 35.18 |
| 学生食堂 | restaurant | 89.34 |
| 図書館 | library | 167.23 |
| 駐車場A | parking | 223.89 |
| 駐車場B | parking | 278.45 |

## 空間検索と空間関数

### 範囲内検索（バッファ検索）

特定の地点から一定距離内にある施設を検索します。

```sql
-- 1号館から200メートル以内の施設を検索
SELECT f.facility_name,
       f.facility_type,
       ROUND(ST_Distance_Sphere(
           (SELECT location FROM building_locations WHERE building_id = 'BLDG001'),
           f.location
       ), 2) AS 距離_メートル
FROM campus_facilities f
WHERE ST_Distance_Sphere(
    (SELECT location FROM building_locations WHERE building_id = 'BLDG001'),
    f.location
) <= 200
ORDER BY 距離_メートル;
```

### 最寄り施設の検索

```sql
-- 各建物から最も近い駐車場を検索
SELECT b.building_name,
       f.facility_name AS 最寄り駐車場,
       ROUND(ST_Distance_Sphere(b.location, f.location), 2) AS 距離_メートル
FROM building_locations b
JOIN campus_facilities f ON f.facility_type = 'parking'
WHERE (b.building_id, ST_Distance_Sphere(b.location, f.location)) IN (
    SELECT b2.building_id, MIN(ST_Distance_Sphere(b2.location, f2.location))
    FROM building_locations b2, campus_facilities f2
    WHERE f2.facility_type = 'parking'
    GROUP BY b2.building_id
);
```

### エリア内検索（ポリゴン内検索）

```sql
-- キャンパスエリア内の施設を検索（キャンパス全体のポリゴンを仮定）
SET @campus_area = ST_GeomFromText('
    POLYGON((
        139.6980 35.6485, 139.7025 35.6485, 
        139.7025 35.6530, 139.6980 35.6530, 
        139.6980 35.6485
    ))', 4326);

SELECT facility_name,
       facility_type,
       ST_AsText(location) AS 位置
FROM campus_facilities
WHERE ST_Contains(@campus_area, location);
```

## 複雑な空間分析

### 通学路データの管理

```sql
-- 通学路テーブルの作成
CREATE TABLE commute_routes (
    route_id VARCHAR(16) PRIMARY KEY,
    route_name VARCHAR(100),
    start_point POINT NOT NULL SRID 4326,
    end_point POINT NOT NULL SRID 4326,
    route_path LINESTRING NOT NULL SRID 4326,
    distance_meters DECIMAL(10,2),
    estimated_time_minutes INT,
    route_type VARCHAR(20), -- 'walking', 'bicycle', 'bus'
    
    SPATIAL INDEX idx_start (start_point),
    SPATIAL INDEX idx_end (end_point),
    SPATIAL INDEX idx_path (route_path)
);
```

### 通学路データの挿入

```sql
-- 最寄り駅からのルートを挿入
INSERT INTO commute_routes (route_id, route_name, start_point, end_point, route_path, distance_meters, estimated_time_minutes, route_type) VALUES
('ROUTE001', '○○駅から1号館', 
 ST_GeomFromText('POINT(139.6950 35.6450)', 4326),
 ST_GeomFromText('POINT(139.7000 35.6500)', 4326),
 ST_GeomFromText('LINESTRING(139.6950 35.6450, 139.6975 35.6475, 139.7000 35.6500)', 4326),
 623.50, 8, 'walking'
),
('ROUTE002', 'バス停から2号館',
 ST_GeomFromText('POINT(139.7030 35.6480)', 4326),
 ST_GeomFromText('POINT(139.7010 35.6510)', 4326),
 ST_GeomFromText('LINESTRING(139.7030 35.6480, 139.7020 35.6495, 139.7010 35.6510)', 4326),
 387.20, 5, 'walking'
);
```

### ルート分析

```sql
-- 各ルートの詳細分析
SELECT route_name,
       route_type,
       distance_meters,
       estimated_time_minutes,
       ROUND(distance_meters / estimated_time_minutes * 60 / 1000, 2) AS 平均時速_kmh,
       ST_AsText(start_point) AS 出発地点,
       ST_AsText(end_point) AS 到着地点
FROM commute_routes;
```

## 地理空間インデックスとパフォーマンス

### 空間インデックスの効果確認

```sql
-- インデックスを使用した高速な近傍検索
EXPLAIN SELECT facility_name, facility_type
FROM campus_facilities
WHERE ST_Distance_Sphere(
    location, 
    ST_GeomFromText('POINT(139.7000 35.6500)', 4326)
) <= 100;
```

### 大量データでのパフォーマンス最適化

```sql
-- 学生の居住地データテーブル（大量データを想定）
CREATE TABLE student_addresses (
    student_id BIGINT PRIMARY KEY,
    address_text VARCHAR(200),
    location POINT SRID 4326,
    distance_to_school DECIMAL(8,2), -- 事前計算した距離
    
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    SPATIAL INDEX idx_student_location (location),
    INDEX idx_distance (distance_to_school)
);
```

## 実践例：学校データベースでの地理空間活用

### 例1：教室予約システムとの連携

```sql
-- 教室の位置情報を既存のclassroomsテーブルに追加
ALTER TABLE classrooms 
ADD COLUMN location POINT SRID 4326,
ADD COLUMN building_floor INT,
ADD SPATIAL INDEX idx_classroom_location (location);

-- 教室の位置データを更新
UPDATE classrooms 
SET location = ST_GeomFromText('POINT(139.7000 35.6500)', 4326),
    building_floor = 1
WHERE classroom_id = '101A';

UPDATE classrooms 
SET location = ST_GeomFromText('POINT(139.7000 35.6502)', 4326),
    building_floor = 1  
WHERE classroom_id = '102B';
```

### 例2：最適な教室配置の分析

```sql
-- 学生の移動距離を最小化する教室配置分析
SELECT 
    cs1.course_id AS 前の授業,
    cs2.course_id AS 次の授業,
    c1.classroom_name AS 前の教室,
    c2.classroom_name AS 次の教室,
    ROUND(ST_Distance_Sphere(c1.location, c2.location), 2) AS 移動距離_メートル,
    CASE 
        WHEN ST_Distance_Sphere(c1.location, c2.location) > 200 THEN '長距離移動'
        WHEN ST_Distance_Sphere(c1.location, c2.location) > 100 THEN '中距離移動'
        ELSE '短距離移動'
    END AS 移動分類
FROM course_schedule cs1
JOIN course_schedule cs2 ON DATE(cs1.schedule_date) = DATE(cs2.schedule_date)
    AND cs1.period_id = cs2.period_id - 1
JOIN classrooms c1 ON cs1.classroom_id = c1.classroom_id
JOIN classrooms c2 ON cs2.classroom_id = c2.classroom_id
WHERE c1.location IS NOT NULL AND c2.location IS NOT NULL
ORDER BY 移動距離_メートル DESC;
```

### 例3：災害時避難計画

```sql
-- 避難場所テーブル
CREATE TABLE evacuation_points (
    point_id VARCHAR(16) PRIMARY KEY,
    point_name VARCHAR(100),
    capacity INT,
    location POINT NOT NULL SRID 4326,
    evacuation_area POLYGON SRID 4326,
    
    SPATIAL INDEX idx_evac_location (location)
);

-- 各建物から最寄りの避難場所を計算
SELECT b.building_name,
       ep.point_name AS 最寄り避難場所,
       ROUND(ST_Distance_Sphere(b.location, ep.location), 2) AS 距離_メートル,
       ROUND(ST_Distance_Sphere(b.location, ep.location) / 80 * 60, 1) AS 避難時間_秒
FROM building_locations b
CROSS JOIN evacuation_points ep
WHERE (b.building_id, ST_Distance_Sphere(b.location, ep.location)) IN (
    SELECT b2.building_id, MIN(ST_Distance_Sphere(b2.location, ep2.location))
    FROM building_locations b2, evacuation_points ep2
    GROUP BY b2.building_id
);
```

## 練習問題

### 問題9-4-1
building_locations テーブルから、すべての建物の位置を経度・緯度形式で表示し、建物名と共に取得するSQLを書いてください。

### 問題9-4-2
campus_facilities テーブルに新しい施設「コンビニ」（facility_id: 'FAC006'、位置: 139.7008, 35.6512）を挿入するSQLを書いてください。

### 問題9-4-3
2号館（BLDG002）から最も近い施設を1つ見つけ、その施設名、タイプ、距離を表示するSQLを書いてください。

### 問題9-4-4
すべての建物から150メートル以内にある施設を検索し、建物名、施設名、距離を表示するSQLを書いてください。

### 問題9-4-5
各施設タイプ（facility_type）ごとに、施設数と平均的な他施設からの距離を計算するSQLを書いてください。

### 問題9-4-6
3号館（BLDG003）を中心とした半径300メートルの円形エリア内にある施設を検索するSQLを書いてください。

### 問題9-4-7
各建物から最も遠い施設を見つけ、建物名、最も遠い施設名、その距離を表示するSQLを書いてください。

### 問題9-4-8
'restaurant'タイプまたは'library'タイプの施設で、1号館から200メートル以内にあるものを検索するSQLを書いてください。

### 問題9-4-9
建物の敷地面積（building_area）を平方メートル単位で計算して表示するSQLを書いてください。

### 問題9-4-10
キャンパスの中心点（すべての建物の重心）を計算し、そこから各施設までの距離を表示するSQLを書いてください。

## 解答と詳細な解説

### 解答9-4-1
```sql
SELECT building_id,
       building_name,
       ST_X(location) AS 経度,
       ST_Y(location) AS 緯度,
       ST_AsText(location) AS 位置座標
FROM building_locations;
```

**解説**：
- `ST_X()`関数でPOINTの経度（X座標）を取得
- `ST_Y()`関数でPOINTの緯度（Y座標）を取得
- `ST_AsText()`関数で地理空間データをWKT形式のテキストとして表示
- 地理空間データの基本的な表示方法

### 解答9-4-2
```sql
INSERT INTO campus_facilities (facility_id, facility_name, facility_type, location) 
VALUES ('FAC006', 'コンビニ', 'convenience_store', 
        ST_GeomFromText('POINT(139.7008 35.6512)', 4326));
```

**解説**：
- `ST_GeomFromText()`関数でWKT形式の文字列から地理空間オブジェクトを作成
- SRID 4326（WGS84座標系）を指定
- POINTデータの標準的な挿入方法

### 解答9-4-3
```sql
SELECT f.facility_name,
       f.facility_type,
       ROUND(ST_Distance_Sphere(b.location, f.location), 2) AS 距離_メートル
FROM building_locations b, campus_facilities f
WHERE b.building_id = 'BLDG002'
ORDER BY ST_Distance_Sphere(b.location, f.location)
LIMIT 1;
```

**解説**：
- `ST_Distance_Sphere()`関数で球面距離を計算（メートル単位）
- WHERE句で2号館を指定
- ORDER BYで距離の昇順に並べてLIMIT 1で最短距離の施設を取得
- ROUND()で距離を小数点第2位まで表示

### 解答9-4-4
```sql
SELECT b.building_name,
       f.facility_name,
       f.facility_type,
       ROUND(ST_Distance_Sphere(b.location, f.location), 2) AS 距離_メートル
FROM building_locations b, campus_facilities f
WHERE ST_Distance_Sphere(b.location, f.location) <= 150
ORDER BY b.building_name, 距離_メートル;
```

**解説**：
- クロス結合で全建物と全施設の組み合わせを生成
- WHERE句で150メートル以内の条件を指定
- 建物名と距離で並び替えて見やすく表示

### 解答9-4-5
```sql
SELECT f1.facility_type,
       COUNT(*) AS 施設数,
       ROUND(AVG(min_distances.最短距離), 2) AS 平均最短距離_メートル
FROM campus_facilities f1
JOIN (
    SELECT f.facility_id,
           MIN(ST_Distance_Sphere(f.location, f2.location)) AS 最短距離
    FROM campus_facilities f, campus_facilities f2
    WHERE f.facility_id != f2.facility_id
    GROUP BY f.facility_id
) min_distances ON f1.facility_id = min_distances.facility_id
GROUP BY f1.facility_type;
```

**解説**：
- サブクエリで各施設から他の施設への最短距離を計算
- 自分自身を除外するため`f.facility_id != f2.facility_id`条件を追加
- 施設タイプごとにグループ化して平均を計算

### 解答9-4-6
```sql
SELECT facility_name,
       facility_type,
       ROUND(ST_Distance_Sphere(
           (SELECT location FROM building_locations WHERE building_id = 'BLDG003'),
           location
       ), 2) AS 距離_メートル
FROM campus_facilities
WHERE ST_Distance_Sphere(
    (SELECT location FROM building_locations WHERE building_id = 'BLDG003'),
    location
) <= 300
ORDER BY 距離_メートル;
```

**解説**：
- サブクエリで3号館の位置を取得
- `ST_Distance_Sphere() <= 300`で300メートル以内の条件を指定
- 円形範囲内の施設検索の典型的なパターン

### 解答9-4-7
```sql
SELECT b.building_name,
       f.facility_name,
       f.facility_type,
       ROUND(ST_Distance_Sphere(b.location, f.location), 2) AS 最長距離_メートル
FROM building_locations b, campus_facilities f
WHERE (b.building_id, ST_Distance_Sphere(b.location, f.location)) IN (
    SELECT b2.building_id, MAX(ST_Distance_Sphere(b2.location, f2.location))
    FROM building_locations b2, campus_facilities f2
    GROUP BY b2.building_id
);
```

**解説**：
- サブクエリで各建物から施設への最大距離を計算
- WHERE句のIN条件で最大距離を持つ組み合わせのみを抽出
- 複合条件による最大値検索のパターン

### 解答9-4-8
```sql
SELECT facility_name,
       facility_type,
       ROUND(ST_Distance_Sphere(
           (SELECT location FROM building_locations WHERE building_id = 'BLDG001'),
           location
       ), 2) AS 距離_メートル
FROM campus_facilities
WHERE facility_type IN ('restaurant', 'library')
  AND ST_Distance_Sphere(
      (SELECT location FROM building_locations WHERE building_id = 'BLDG001'),
      location
  ) <= 200
ORDER BY 距離_メートル;
```

**解説**：
- IN演算子で複数の施設タイプを指定
- AND条件で距離制限と施設タイプの両方の条件を満たす施設を検索
- 複合条件での空間検索の例

### 解答9-4-9
```sql
SELECT building_id,
       building_name,
       ROUND(ST_Area(ST_Transform(building_area, 3857)), 2) AS 敷地面積_平方メートル
FROM building_locations
WHERE building_area IS NOT NULL;
```

**解説**：
- `ST_Area()`関数でポリゴンの面積を計算
- `ST_Transform()`で座標系をメートル単位の投影座標系（3857）に変換
- WGS84（4326）は角度単位のため、面積計算には投影座標系への変換が必要

### 解答9-4-10
```sql
SELECT f.facility_name,
       f.facility_type,
       ROUND(ST_Distance_Sphere(
           ST_Centroid(ST_Collect(
               (SELECT ST_Collect(location) FROM building_locations)
           )),
           f.location
       ), 2) AS 中心点からの距離_メートル
FROM campus_facilities f
ORDER BY 中心点からの距離_メートル;
```

**解説**：
- `ST_Collect()`で複数のPOINTを集約してMULTIPOINTを作成
- `ST_Centroid()`で重心（中心点）を計算
- サブクエリで全建物の位置を集約し、その重心から各施設までの距離を計算
- 複数の空間関数を組み合わせた高度な計算例

## まとめ

この章では、MySQLにおける地理空間データの格納と操作について学びました：

1. **地理空間データ型の基本**：POINT、LINESTRING、POLYGONなどの基本データ型
2. **座標系の理解**：WGS84（SRID 4326）とWeb メルカトル（SRID 3857）の使い分け
3. **地理空間データの作成**：ST_GeomFromText()による地理空間オブジェクトの作成
4. **空間検索**：ST_Distance_Sphere()による距離計算と範囲検索
5. **空間分析**：最寄り施設検索、エリア内検索、ルート分析
6. **パフォーマンス最適化**：空間インデックスの活用
7. **実践的な活用**：学校データベースでの位置情報管理と分析

地理空間データは、現代のアプリケーションにおいて重要な役割を果たしています。特に学校のような物理的な施設を多く持つ組織では、効率的な施設管理、災害対策、学生サービスの向上などに大きく貢献します。

空間インデックスを適切に設定し、座標系を正しく理解して使用することで、大量の位置データでも高速な検索と分析が可能になります。また、GISソフトウェアとの連携により、より高度な地理空間分析も実現できます。

次のセクションでは、「全文検索：テキスト検索の最適化」について学び、大量のテキストデータから効率的に情報を検索する技術を習得します。